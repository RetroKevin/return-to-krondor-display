# Installs the Return to Krondor display patch into a GOG (or other
# full) install. The retail RtK.exe is kept and started under the name
# RtKGame.exe. A small launcher takes the RtK.exe name so Windows does
# not replace the local DirectDraw driver.
param(
    [string]$GameDir
)

$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$payload = Join-Path $here 'payload'

function Resolve-GameDir {
    param([string]$Asked)
    if ($Asked) {
        if (-not (Test-Path (Join-Path $Asked 'RTKRONDOR.INI'))) {
            throw "No RTKRONDOR.INI in $Asked"
        }
        return (Resolve-Path $Asked).Path
    }
    foreach ($candidate in @($here, (Join-Path $here '..'))) {
        $ini = Join-Path $candidate 'RTKRONDOR.INI'
        if (Test-Path $ini) {
            return (Resolve-Path $candidate).Path
        }
    }
    throw "Run this from the game folder, or pass -GameDir 'C:\path\to\Return to Krondor'."
}

function Test-GameBinary {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return $false }
    return ((Get-Item $Path).Length -gt 1MB)
}

function Get-Sha1 {
    param([string]$Path)
    $sha = [System.Security.Cryptography.SHA1]::Create()
    $stream = [System.IO.File]::OpenRead($Path)
    try {
        return ([BitConverter]::ToString($sha.ComputeHash($stream))).Replace('-', '').ToLowerInvariant()
    } finally {
        $stream.Close()
        $sha.Dispose()
    }
}

function Copy-IfDifferent {
    param([string]$Source, [string]$Dest)
    if ((Test-Path $Dest) -and (Get-Sha1 $Source) -eq (Get-Sha1 $Dest)) {
        return
    }
    Copy-Item -LiteralPath $Source -Destination $Dest -Force
}

$game = Resolve-GameDir $GameDir
$rtk = Join-Path $game 'RtK.exe'
$original = Join-Path $game 'RtK.exe.original'
$played = Join-Path $game 'RtKGame.exe'
$source = $null

if (Test-Path $original) {
    $source = $original
} elseif (Test-GameBinary $rtk) {
    Copy-Item -LiteralPath $rtk -Destination $original
    $source = $original
} elseif (Test-GameBinary $played) {
    $source = $played
} else {
    throw "Could not find the retail RtK.exe in $game"
}

Copy-IfDifferent $source $played
Copy-Item -LiteralPath (Join-Path $payload 'launcher.exe') -Destination $rtk -Force
Copy-Item -LiteralPath (Join-Path $payload 'ddraw.dll') -Destination (Join-Path $game 'ddraw.dll') -Force
Copy-Item -LiteralPath (Join-Path $payload 'ddraw.ini') -Destination (Join-Path $game 'ddraw.ini') -Force
Copy-Item -LiteralPath (Join-Path $payload 'cnc-ddraw config.exe') -Destination (Join-Path $game 'cnc-ddraw config.exe') -Force
$shaders = Join-Path $game 'Shaders'
if (Test-Path $shaders) { Remove-Item -LiteralPath $shaders -Recurse -Force }
Copy-Item -LiteralPath (Join-Path $payload 'Shaders') -Destination $shaders -Recurse -Force

Write-Host "Display patch installed in $game"
Write-Host "Start the game with RtK.exe. The retail executable is RtKGame.exe."
Write-Host "RtK.exe.original is the untouched backup."
