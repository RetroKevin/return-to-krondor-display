# Remove Krondor.ttf from the Windows font list. The game adds that file
# while it runs and removes it only if it exits cleanly. A crash leaves
# the desktop using the game font until reboot.
param(
    [string]$GameDir
)

$ErrorActionPreference = 'Stop'

$here = Split-Path -Parent $MyInvocation.MyCommand.Path

function Resolve-GameDir {
    param([string]$Asked)
    if ($Asked) {
        if (-not (Test-Path (Join-Path $Asked 'Krondor.ttf')) -and -not (Test-Path (Join-Path $Asked 'krondor.ttf'))) {
            throw "No Krondor.ttf in $Asked"
        }
        return (Resolve-Path $Asked).Path
    }
    foreach ($candidate in @($here, (Join-Path $here '..'))) {
        if ((Test-Path (Join-Path $candidate 'Krondor.ttf')) -or (Test-Path (Join-Path $candidate 'krondor.ttf'))) {
            return (Resolve-Path $candidate).Path
        }
    }
    throw "Pass -GameDir 'C:\path\to\Return to Krondor'."
}

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public static class RtKFonts {
    [DllImport("gdi32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    public static extern bool RemoveFontResource(string name);
    [DllImport("user32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    public static extern IntPtr SendMessageTimeout(IntPtr hwnd, uint msg, UIntPtr wParam, IntPtr lParam, uint flags, uint timeout, out UIntPtr result);
}
"@

$game = Resolve-GameDir $GameDir
$font = Join-Path $game 'Krondor.ttf'
if (-not (Test-Path -LiteralPath $font)) {
    $font = Join-Path $game 'krondor.ttf'
}
$removed = 0
for ($i = 0; $i -lt 8; $i++) {
    $full = [RtKFonts]::RemoveFontResource($font)
    $bare = [RtKFonts]::RemoveFontResource('Krondor.ttf')
    if (-not $full -and -not $bare) { break }
    $removed++
}
if ($removed -gt 0) {
    $result = [UIntPtr]::Zero
    [void][RtKFonts]::SendMessageTimeout([IntPtr]0xffff, 0x1d, [UIntPtr]::Zero, [IntPtr]::Zero, 2, 1000, [ref]$result)
    Write-Host "Removed the Krondor font from Windows."
} else {
    Write-Host "The Krondor font was not installed in Windows."
}
