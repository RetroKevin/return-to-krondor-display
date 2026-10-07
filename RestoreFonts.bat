@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0RestoreFonts.ps1" %*
if errorlevel 1 (
    echo.
    echo The Krondor font was not removed.
    pause
    exit /b 1
)
echo.
pause
