/* Stand-in for RtK.exe. Windows applies a compatibility shim to that
   exact file name and forces the system DirectDraw. The game itself
   lives in RtKGame.exe, so the local cnc-ddraw library is used instead.

   The game calls AddFontResource on Krondor.ttf and only removes it on
   a clean exit. A crash leaves that font installed for every program
   until reboot. This process outlives the game, so it removes the font
   on the way in and on the way out. */
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

static void unload_krondor_font(const wchar_t *dir)
{
    wchar_t path[MAX_PATH];
    DWORD_PTR result;
    int removed;
    int i;

    wsprintfW(path, L"%s\\Krondor.ttf", dir);
    removed = 0;
    for (i = 0; i < 8; i++) {
        BOOL full = RemoveFontResourceW(path);
        BOOL bare = RemoveFontResourceW(L"Krondor.ttf");
        if (!full && !bare)
            break;
        removed = 1;
    }
    if (removed) {
        SendMessageTimeoutW(HWND_BROADCAST, WM_FONTCHANGE, 0, 0,
                             SMTO_ABORTIFHUNG, 1000, &result);
    }
}

int WINAPI wWinMain(HINSTANCE inst, HINSTANCE prev, LPWSTR cmd, int show)
{
    wchar_t self[MAX_PATH];
    wchar_t dir[MAX_PATH];
    wchar_t game[MAX_PATH * 2];
    wchar_t *slash;
    STARTUPINFOW si;
    PROCESS_INFORMATION pi;
    DWORD code;
    (void)inst;
    (void)prev;
    (void)show;
    if (!GetModuleFileNameW(NULL, self, MAX_PATH))
        return 1;
    lstrcpyW(dir, self);
    slash = wcsrchr(dir, L'\\');
    if (slash)
        *slash = 0;
    unload_krondor_font(dir);
    wsprintfW(game, L"\"%s\\RtKGame.exe\"%s%s", dir, (cmd && cmd[0]) ? L" " : L"", cmd ? cmd : L"");
    ZeroMemory(&si, sizeof si);
    si.cb = sizeof si;
    if (!CreateProcessW(NULL, game, NULL, NULL, FALSE, 0, NULL, dir, &si, &pi))
        return 1;
    WaitForSingleObject(pi.hProcess, INFINITE);
    code = 1;
    GetExitCodeProcess(pi.hProcess, &code);
    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);
    unload_krondor_font(dir);
    return (int)code;
}
