# Return to Krondor display patch

A drop-in patch for a **GOG v1.00.6** install of *Return to Krondor*. The picture stays the original 4:3 shape and fills a widescreen monitor with black bars on the sides. The retail executable is not modified, and this download does not include the game.

The picture is drawn by [cnc-ddraw](https://github.com/FunkyFr3sh/cnc-ddraw) 7.1, which already ships a Return to Krondor profile. cnc-ddraw is MIT licensed. See `cnc-ddraw-LICENSE.txt`.

Windows treats a program named `RtK.exe` as an old DirectDraw title and forces a driver that cannot show this game correctly on current graphics cards. The patch keeps your retail `RtK.exe` as `RtKGame.exe` and puts a small launcher in its place. Shortcuts and the GOG launcher still start `RtK.exe`. The launcher source is `src/launchgame.c`.

## Install

Download **ReturnToKrondor-Display-1.0.zip** from [Releases](https://github.com/RetroKevin/return-to-krondor-display/releases), extract it, and double-click `Apply.bat`.

If the game is not next to `Apply.bat`:

```
powershell -ExecutionPolicy Bypass -File Apply.ps1 -GameDir "D:\Games\Return to Krondor"
```

`RtK.exe.original` is a backup of the retail executable. To uninstall, copy that file back over `RtK.exe` and delete `ddraw.dll`, `ddraw.ini`, `cnc-ddraw config.exe`, and the `Shaders` folder.

Picture size and filtering can be changed with `cnc-ddraw config.exe` in the game folder. The shipped settings are a borderless window, 4:3, and vsync.
