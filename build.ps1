<#
.SYNOPSIS
    Concentration Redux - Build and Deployment Script
.DESCRIPTION
    Validates mod files and deploys Concentration Redux directly into the Baldur's Gate 3 Data directory.
.PARAMETER Deploy
    Deploy loose files to BG3 Data directory for active testing with Script Extender.
.PARAMETER Clean
    Remove installed files from BG3 Data directory.
.PARAMETER GameDir
    Path to Baldur's Gate 3 installation directory (defaults to detected Steam path).
#>

[CmdletBinding()]
param(
    [switch]$Deploy,
    [switch]$Package,
    [switch]$Clean,
    [string]$GameDir = "D:\SteamLibrary\steamapps\common\Baldurs Gate 3"
)

$ErrorActionPreference = "Stop"
$ModName = "ConcentrationRedux"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "    Concentration Redux - Build & Deployment Tool        " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Validation
Write-Host "[1/3] Validating mod files..." -ForegroundColor Yellow

$RequiredFiles = @(
    "Mods\$ModName\meta.lsx",
    "Mods\$ModName\ScriptExtender\Config.json",
    "Mods\$ModName\Scripts\Server\main.lua",
    "Mods\$ModName\icon.png",
    "Public\$ModName\Stats\Generated\Data\Spells.txt",
    "Public\$ModName\Stats\Generated\Data\Statuses.txt",
    "Public\$ModName\Stats\Generated\Data\Passives.txt",
    "Public\$ModName\GUI\Icons_ConcentrationRedux.lsx",
    "Public\$ModName\Assets\Tooltips\Icons\Icons_ConcentrationRedux.dds"
)

foreach ($rel in $RequiredFiles) {
    $full = Join-Path $ScriptDir $rel
    if (-not (Test-Path $full)) {
        Write-Error "Missing required file: $rel"
        exit 1
    }
    Write-Host "  [OK] $rel" -ForegroundColor Green
}

# 2. XML/JSON Syntax Check
Write-Host "[2/3] Checking XML and JSON syntax..." -ForegroundColor Yellow

try {
    [xml](Get-Content (Join-Path $ScriptDir "Mods\$ModName\meta.lsx")) | Out-Null
    [xml](Get-Content (Join-Path $ScriptDir "Public\$ModName\Localization\English\english.loca.xml")) | Out-Null
    [xml](Get-Content (Join-Path $ScriptDir "Public\$ModName\GUI\Icons_ConcentrationRedux.lsx")) | Out-Null
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

# 3. Deployment / Cleaning / Packaging
$ModFolder = "ConcentrationRedux_5ca2dda8-eedc-41be-95f0-50747d552d10"
$DestPak = Join-Path $env:LOCALAPPDATA "Larian Studios\Baldur's Gate 3\Mods\$ModFolder.pak"
$ReleaseDir = Join-Path $ScriptDir "Release"
$ReleasePak = Join-Path $ReleaseDir "$ModFolder.pak"

function Build-ModPackage {
    Write-Host "`n[*] Packaging $ModFolder.pak..." -ForegroundColor Yellow
    $TempDir = Join-Path $env:TEMP "ConcentrationRedux_pkg"
    if (Test-Path $TempDir) { Remove-Item -Recurse -Force $TempDir }
    
    New-Item -ItemType Directory -Force -Path (Join-Path $TempDir "Mods\$ModFolder") | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $TempDir "Public\$ModFolder") | Out-Null

    Copy-Item -Recurse -Force (Join-Path $ScriptDir "Mods\$ModName\*") (Join-Path $TempDir "Mods\$ModFolder")
    Copy-Item -Recurse -Force (Join-Path $ScriptDir "Public\$ModName\*") (Join-Path $TempDir "Public\$ModFolder")
    
    # Package structure strictly matches v1.0.5 layout: Localization lives under Public/$ModFolder/Localization/English/
    # Ensure no duplicate Localization directory under Mods
    $ModsLoca = Join-Path $TempDir "Mods\$ModFolder\Localization"
    if (Test-Path $ModsLoca) { Remove-Item -Recurse -Force $ModsLoca }

    if (-not (Test-Path $ReleaseDir)) { New-Item -ItemType Directory -Force -Path $ReleaseDir | Out-Null }
    
    & $DivinePath -g bg3 -a create-package -s $TempDir -d $ReleasePak -c lz4
    Remove-Item -Recurse -Force $TempDir

    $ZipPath = Join-Path $ReleaseDir "ConcentrationRedux-v1.1.0.zip"
    if (Test-Path $ZipPath) { Remove-Item -Force $ZipPath }
    Compress-Archive -Path $ReleasePak -DestinationPath $ZipPath -Force
    Write-Host "  [OK] Created Release package and zip archive:" -ForegroundColor Green
    Write-Host "       $ZipPath" -ForegroundColor Gray

    try {
        Copy-Item -Force $ReleasePak $DestPak -ErrorAction Stop
        Write-Host "  [OK] Installed latest package to active game Mods directory:" -ForegroundColor Green
        Write-Host "       $DestPak" -ForegroundColor Gray

        # Also remove loose files from Game Data directory to prevent collision with the active .pak
        $LooseMods = Join-Path $GameDir "Data\Mods\$ModName"
        $LoosePublic = Join-Path $GameDir "Data\Public\$ModName"
        if (Test-Path $LooseMods) { Remove-Item -Recurse -Force $LooseMods; Write-Host "  [OK] Cleaned conflicting loose files: $LooseMods" -ForegroundColor Gray }
        if (Test-Path $LoosePublic) { Remove-Item -Recurse -Force $LoosePublic; Write-Host "  [OK] Cleaned conflicting loose files: $LoosePublic" -ForegroundColor Gray }
    } catch {
        Write-Warning "Baldur's Gate 3 is currently running and locking the active .pak file."
        Write-Warning "Close BG3 and re-run to copy into your local game Mods folder."
    }
}

if ($Clean) {
    Write-Host "[3/3] Removing deployed mod from game directory..." -ForegroundColor Yellow
    $TargetMods = Join-Path $GameDir "Data\Mods\$ModName"
    $TargetPublic = Join-Path $GameDir "Data\Public\$ModName"
    if (Test-Path $TargetMods) { Remove-Item -Recurse -Force $TargetMods; Write-Host "  Removed: $TargetMods" -ForegroundColor Green }
    if (Test-Path $TargetPublic) { Remove-Item -Recurse -Force $TargetPublic; Write-Host "  Removed: $TargetPublic" -ForegroundColor Green }
    Write-Host "Mod cleaned from $GameDir." -ForegroundColor Cyan
    exit 0
}

if ($Deploy -or $Package) {
    if ($Deploy) {
        Write-Host "[3/3] Deploying to $GameDir\Data..." -ForegroundColor Yellow
        if (-not (Test-Path (Join-Path $GameDir "bin\bg3.exe")) -and -not (Test-Path (Join-Path $GameDir "bin\bg3_dx11.exe"))) {
            Write-Warning "Could not find bg3.exe in '$GameDir\bin'. Please verify GameDir."
        }
        
        $DestMods = Join-Path $GameDir "Data\Mods\$ModName"
        $DestPublic = Join-Path $GameDir "Data\Public\$ModName"
        
        New-Item -ItemType Directory -Force -Path $DestMods | Out-Null
        New-Item -ItemType Directory -Force -Path $DestPublic | Out-Null
        
        Copy-Item -Recurse -Force (Join-Path $ScriptDir "Mods\$ModName\*") $DestMods
        Copy-Item -Recurse -Force (Join-Path $ScriptDir "Public\$ModName\*") $DestPublic
        
        Write-Host "  [OK] Deployed loose files to:" -ForegroundColor Green
        Write-Host "       $DestMods" -ForegroundColor Gray
        Write-Host "       $DestPublic" -ForegroundColor Gray
    }

    # Always build and sync the .pak so BG3 Mod Manager users have the latest version active
    Build-ModPackage

    Write-Host "`nDeployment & Packaging complete! You can now run Baldur's Gate 3." -ForegroundColor Cyan
    Write-Host "In the BG3SE console, you can type 'reset' at any time to reload main.lua live." -ForegroundColor Cyan
}
