/* Stand-in for RtK.exe. Windows applies a compatibility shim to that
   exact file name and forces the system DirectDraw. The game itself
   lives in RtKGame.exe, so the local cnc-ddraw library is used instead. */
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

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
    return (int)code;
}
