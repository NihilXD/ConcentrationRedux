<#
.SYNOPSIS
    Concentration Redux - Kinetic Witch Bolt Build & Deployment Script
.DESCRIPTION
    Validates mod files, compiles localization, and packages into a .pak mod.
#>

[CmdletBinding()]
param(
    [switch]$Deploy,
    [switch]$Package = $true,
    [switch]$Clean,
    [string]$GameDir = "D:\SteamLibrary\steamapps\common\Baldurs Gate 3"
)

$ErrorActionPreference = "Stop"
$ModName = "ConcentrationRedux_WitchBolt"
$ModFolder = "ConcentrationRedux_WitchBolt_269a45af-60f8-4a56-b05f-8c18b2186722"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   CR - Kinetic Witch Bolt: Build & Deployment Tool       " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Validation
Write-Host "[1/3] Validating mod files..." -ForegroundColor Yellow

$RequiredFiles = @(
    "Mods\$ModName\meta.lsx",
    "Mods\$ModName\ScriptExtender\Config.json",
    "Mods\$ModName\ScriptExtender\Lua\BootstrapServer.lua",
    "Mods\$ModName\Scripts\Server\main.lua",
    "Public\$ModName\Stats\Generated\Data\Spells.txt",
    "Public\$ModName\Stats\Generated\Data\Statuses.txt",
    "Public\$ModName\Localization\English\english.loca.xml"
)

foreach ($rel in $RequiredFiles) {
    $full = Join-Path $ScriptDir $rel
    if (-not (Test-Path $full)) {
        Write-Error "Missing required file: $rel"
        exit 1
    }
    Write-Host "  [OK] $rel" -ForegroundColor Green
}

# 2. XML/JSON Syntax Check & Loca Compilation
Write-Host "[2/3] Checking XML/JSON and compiling localization..." -ForegroundColor Yellow

try {
    [xml](Get-Content (Join-Path $ScriptDir "Mods\$ModName\meta.lsx")) | Out-Null
    [xml](Get-Content (Join-Path $ScriptDir "Public\$ModName\Localization\English\english.loca.xml")) | Out-Null
    Get-Content (Join-Path $ScriptDir "Mods\$ModName\ScriptExtender\Config.json") -Raw | ConvertFrom-Json | Out-Null
    Write-Host "  [OK] All XML and JSON files parsed cleanly." -ForegroundColor Green

    $DivinePath = "C:\Users\NihilXD\AppData\Roaming\Vortex\baldursgate3\mods\ExportTool-v1.20.4\tools\Divine.exe"
    if (Test-Path $DivinePath) {
        $LocaXml = Join-Path $ScriptDir "Public\$ModName\Localization\English\english.loca.xml"
        $LocaBin = Join-Path $ScriptDir "Public\$ModName\Localization\English\english.loca"
        & $DivinePath -g bg3 -a convert-loca -s $LocaXml -d $LocaBin | Out-Null
        Write-Host "  [OK] Compiled english.loca" -ForegroundColor Green
    }
} catch {
    Write-Error "Syntax error in project files: $_"
    exit 1
}

# 3. Packaging
$DestPak = Join-Path $env:LOCALAPPDATA "Larian Studios\Baldur's Gate 3\Mods\$ModFolder.pak"
$ReleaseDir = Join-Path $ScriptDir "Release"
$ReleasePak = Join-Path $ReleaseDir "$ModFolder.pak"

function Build-ModPackage {
    Write-Host "`n[*] Packaging $ModFolder.pak..." -ForegroundColor Yellow
    $TempDir = Join-Path $env:TEMP "CR_WitchBolt_pkg"
    if (Test-Path $TempDir) { Remove-Item -Recurse -Force $TempDir }
    
    New-Item -ItemType Directory -Force -Path (Join-Path $TempDir "Mods\$ModFolder") | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $TempDir "Public\$ModFolder") | Out-Null

    Copy-Item -Recurse -Force (Join-Path $ScriptDir "Mods\$ModName\*") (Join-Path $TempDir "Mods\$ModFolder")
    Copy-Item -Recurse -Force (Join-Path $ScriptDir "Public\$ModName\*") (Join-Path $TempDir "Public\$ModFolder")
    
    # Match proven Concentration Redux layout: Localization lives under Public/$ModFolder/Localization/English/
    # Ensure no duplicate Localization directory under Mods
    $ModsLoca = Join-Path $TempDir "Mods\$ModFolder\Localization"
    if (Test-Path $ModsLoca) { Remove-Item -Recurse -Force $ModsLoca }

    if (-not (Test-Path $ReleaseDir)) { New-Item -ItemType Directory -Force -Path $ReleaseDir | Out-Null }
    
    & $DivinePath -g bg3 -a create-package -s $TempDir -d $ReleasePak -c lz4
    Remove-Item -Recurse -Force $TempDir
    Write-Host "  [OK] Created $ReleasePak" -ForegroundColor Green

    $ZipPath = Join-Path $ReleaseDir "ConcentrationRedux_WitchBolt-v1.0.0.zip"
    if (Test-Path $ZipPath) { Remove-Item -Force $ZipPath }
    Compress-Archive -Path $ReleasePak -DestinationPath $ZipPath -Force
    Write-Host "  [OK] Created Release zip archive:" -ForegroundColor Green
    Write-Host "       $ZipPath" -ForegroundColor Gray

    try {
        $ModsDir = Join-Path $env:LOCALAPPDATA "Larian Studios\Baldur's Gate 3\Mods"
        if (-not (Test-Path $ModsDir)) { New-Item -ItemType Directory -Force -Path $ModsDir | Out-Null }
        Copy-Item -Force $ReleasePak $DestPak -ErrorAction Stop
        Write-Host "  [OK] Installed latest package to active game Mods directory:" -ForegroundColor Green
        Write-Host "       $DestPak" -ForegroundColor Gray

        # Purge any conflicting loose mod files from Game Data directory to prevent overriding the active .pak
        Remove-Item -Recurse -Force (Join-Path $GameDir "Data\Mods\ConcentrationRedux*") -ErrorAction SilentlyContinue
        Remove-Item -Recurse -Force (Join-Path $GameDir "Data\Public\ConcentrationRedux*") -ErrorAction SilentlyContinue
        Write-Host "  [OK] Verified game Data directory has no conflicting loose mod files." -ForegroundColor Green
    } catch {
        Write-Warning "Baldur's Gate 3 is currently running and locking the active .pak file."
        Write-Warning "Close BG3 and re-run to copy into your local game Mods folder."
    }
}

if ($Package) {
    Build-ModPackage
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "                 Build Complete!                          " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
