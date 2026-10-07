@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Apply.ps1" %*
if errorlevel 1 (
    echo.
    echo The display patch did not install.
    pause
    exit /b 1
)
echo.
pause
