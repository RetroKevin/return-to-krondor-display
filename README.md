# Return to Krondor display patch

A drop-in patch for *Return to Krondor*. The picture stays the original 4:3 shape and fills a widescreen monitor with black bars on the sides. The game executable is left unchanged, and this download does not include the game.

Tested with the **GOG v1.00.6** install and the **Steam** install. The original 1998 retail release is still untested.

The picture is drawn by [cnc-ddraw](https://github.com/FunkyFr3sh/cnc-ddraw) 7.1, which already ships a Return to Krondor profile. cnc-ddraw is MIT licensed. See `cnc-ddraw-LICENSE.txt`.

Windows treats a program named `RtK.exe` as an old DirectDraw title and forces a driver that cannot show this game correctly on current graphics cards. The patch keeps your retail `RtK.exe` as `RtKGame.exe` and puts a small launcher in its place. Shortcuts and the GOG and Steam launchers still start `RtK.exe`. The launcher source is `src/launchgame.c`.

Letters that look blurred or doubled are ClearType drawn onto the game's picture. The shipped `ddraw.ini` turns font smoothing off for those letters. GOG's own launcher does the same thing by turning ClearType off for the whole desktop (`CT.exe`) and back on afterward. This patch does not change the desktop setting.

The game installs `Krondor.ttf` for every program while it runs, and removes it only on a clean exit. A crash leaves the desktop in that font until reboot. The launcher removes it when the game process ends, including a crash. If the desktop is already stuck, run `RestoreFonts.bat`.

Combat text that is too large (the top bar, and HP when you hover a character) is Windows display scaling above 100%. The game sizes a 12-point font from that DPI, inside a layout drawn for 96 DPI. Set scaling to 100%. Swapping in another file named `Krondor.ttf` changes the letter shapes and does not change the size.

## Install

Download **ReturnToKrondor-Display-1.1.zip** from [Releases](https://github.com/RetroKevin/return-to-krondor-display/releases), extract it, and double-click `Apply.bat`.

If the game is not next to `Apply.bat`:

```
powershell -ExecutionPolicy Bypass -File Apply.ps1 -GameDir "D:\Games\Return to Krondor"
```

`RtK.exe.original` is a backup of the retail executable. To uninstall, copy that file back over `RtK.exe` and delete `ddraw.dll`, `ddraw.ini`, `cnc-ddraw config.exe`, `RestoreFonts.bat`, `RestoreFonts.ps1`, and the `Shaders` folder.

Picture size and filtering can be changed with `cnc-ddraw config.exe` in the game folder. The shipped settings are a borderless window, 4:3, and vsync.
