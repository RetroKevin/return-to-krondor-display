Return to Krondor display patch
================================

This makes a GOG v1.00.6 or Steam install fill a widescreen monitor at
the original 4:3 shape, with black bars on the sides. Menus, the map,
and the cursor are drawn by cnc-ddraw
(https://github.com/FunkyFr3sh/cnc-ddraw), which is included. cnc-ddraw
is MIT licensed; see cnc-ddraw-LICENSE.txt.

Tested with GOG v1.00.6 and Steam. The original 1998 retail release is
still untested.

The game executable is left unchanged. Windows treats a program named
RtK.exe as an old DirectDraw title and forces a driver that cannot show
this game correctly. The patch keeps your RtK.exe as RtKGame.exe and
puts a small launcher in its place. Shortcuts and the GOG and Steam
launchers still start RtK.exe.

Letters that look blurred or doubled are ClearType drawn onto the
game's picture. The shipped ddraw.ini turns font smoothing off for
those letters. This patch does not change ClearType for the desktop.

The game installs Krondor.ttf for every program while it runs, and
removes it only on a clean exit. A crash leaves the desktop in that
font until reboot. The launcher removes it when the game process ends.
If the desktop is already stuck, run RestoreFonts.bat.

Combat text that is too large is Windows display scaling above 100%.
The game sizes a 12-point font from that DPI. Set scaling to 100%.
Swapping in another file named Krondor.ttf does not change the size.

Install
-------
1. Extract this folder anywhere.
2. Double-click Apply.bat.
   If the game is not next to Apply.bat, run:
     powershell -ExecutionPolicy Bypass -File Apply.ps1 -GameDir "D:\Games\Return to Krondor"

RtK.exe.original is a backup of the retail executable. To uninstall,
copy that file back over RtK.exe and delete ddraw.dll, ddraw.ini,
cnc-ddraw config.exe, RestoreFonts.bat, RestoreFonts.ps1, and the
Shaders folder.

Picture size and filtering can be changed with "cnc-ddraw config.exe"
in the game folder. The shipped settings are a borderless window, 4:3,
and vsync.
