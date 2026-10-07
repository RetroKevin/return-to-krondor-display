Return to Krondor display patch
================================

This makes the GOG v1.00.6 game fill a widescreen monitor at the
original 4:3 shape, with black bars on the sides. Menus, the map, and
the cursor are drawn by cnc-ddraw (https://github.com/FunkyFr3sh/cnc-ddraw),
which is included. cnc-ddraw is MIT licensed; see cnc-ddraw-LICENSE.txt.

The retail game is not modified. Windows treats a program named RtK.exe
as an old DirectDraw title and forces a driver that cannot show this
game correctly. The patch keeps your RtK.exe as RtKGame.exe and puts a
small launcher in its place. Shortcuts and the GOG launcher still start
RtK.exe.

Install
-------
1. Extract this folder anywhere.
2. Double-click Apply.bat.
   If the game is not next to Apply.bat, run:
     powershell -ExecutionPolicy Bypass -File Apply.ps1 -GameDir "D:\Games\Return to Krondor"

RtK.exe.original is a backup of the retail executable. To uninstall,
copy that file back over RtK.exe and delete ddraw.dll, ddraw.ini,
cnc-ddraw config.exe, and the Shaders folder.

Picture size and filtering can be changed with "cnc-ddraw config.exe"
in the game folder. The shipped settings are a borderless window, 4:3,
and vsync.
