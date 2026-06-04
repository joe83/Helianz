#Requires -Version 5.1
<#
.SYNOPSIS
	Full build pipeline: builds both Helianz apps, compiles all Inno Setup
	packages, and produces HelianzSetup.exe (a self-extracting distribution
	launcher).

.DESCRIPTION
	Steps performed:
	  1. Build Helianz client        (Build-Helianz.ps1)
	  2. Build Helianz Server        (Build-HelianzServer.ps1)
	  3. Compile HelianzClientSetup.iss  -> Helianz-Installer\Release\Helianz Client Setup\Setup.exe
	  4. Compile HelianzServerSetup.iss  -> Helianz-Installer\Release\Helianz Server Setup\Setup.exe
	  5. Compile HelianzPackage.iss      -> Helianz-Installer\Release\HelianzSetup.exe

	HelianzSetup.exe, when run by an end-user:
	  - Extracts all installer files to a Windows temp sub-folder
	  - Launches HelianzInstaller.exe and waits for the user to close it
	  - Automatically deletes the temp folder on exit

.PARAMETER Configuration
	Build configuration passed to sub-build scripts: Debug or Release (default: Release).

.PARAMETER SkipBuild
	Skip both the client and server builds; assumes Output\ is already populated.

.PARAMETER SkipClientBuild
	Skip only the Helianz client build.

.PARAMETER SkipServerBuild
	Skip only the Helianz Server build.

.PARAMETER AppVersion
	Override the installer version string (e.g. "24.1.0").
	Auto-detected from Output\Helianz\Helianz.exe if not specified.

.PARAMETER IsccPath
	Full path to ISCC.exe. Auto-detected from standard Inno Setup install
	locations if not provided.

.EXAMPLE
	# Full pipeline
	.\Build-HelianzFull.ps1

	# Skip builds (Output\ already populated), stamp a specific version
	.\Build-HelianzFull.ps1 -SkipBuild -AppVersion "24.2.0"

	# Debug build
	.\Build-HelianzFull.ps1 -Configuration Debug
#>
param(
	[ValidateSet('Debug','Release')]
	[string]$Configuration = 'Release',

	[switch]$SkipBuild,
	[switch]$SkipClientBuild,
	[switch]$SkipServerBuild,

	[string]$AppVersion = '',

	[string]$IsccPath = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Helper: Find ISCC.exe
# ---------------------------------------------------------------------------
function Find-ISCC {
	$candidates = @(
		"${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
		"${env:ProgramFiles}\Inno Setup 6\ISCC.exe",
		"${env:ProgramFiles(x86)}\Inno Setup 5\ISCC.exe",
		"${env:ProgramFiles}\Inno Setup 5\ISCC.exe"
	)
	foreach ($c in $candidates) {
		if (Test-Path $c) { return $c }
	}
	throw "ISCC.exe not found. Install Inno Setup 6 from https://jrsoftware.org/isinfo.php or specify -IsccPath."
}

# ---------------------------------------------------------------------------
# Helper: Read file version from a PE binary
# ---------------------------------------------------------------------------
function Get-FileVersion {
	param([string]$ExePath)
	if (-not (Test-Path $ExePath)) { return $null }
	try {
		$v = [Diagnostics.FileVersionInfo]::GetVersionInfo($ExePath)
		return "$($v.FileMajorPart).$($v.FileMinorPart).$($v.FileBuildPart).$($v.FilePrivatePart)"
	} catch {
		return $null
	}
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
$stopwatch = [Diagnostics.Stopwatch]::StartNew()

Write-Host ""
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  Helianz Full Build Pipeline" -ForegroundColor Cyan
Write-Host "  Configuration : $Configuration" -ForegroundColor Cyan
Write-Host "  Build Client  : $(-not ($SkipBuild -or $SkipClientBuild))" -ForegroundColor Cyan
Write-Host "  Build Server  : $(-not ($SkipBuild -or $SkipServerBuild))" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

# ---------------------------------------------------------------------------
# Steps 1-4: Delegate to Build-HelianzSetup.ps1
# (builds both apps + compiles HelianzClientSetup.iss and HelianzServerSetup.iss)
# ---------------------------------------------------------------------------
Write-Host "[STEPS 1-4] Running Build-HelianzSetup.ps1 (apps + sub-installers)..." -ForegroundColor Yellow

$setupScript = Join-Path $PSScriptRoot "Build-HelianzSetup.ps1"
if (-not (Test-Path $setupScript)) { throw "Script not found: $setupScript" }

$buildParams = @{ Configuration = $Configuration }
if ($SkipBuild)       { $buildParams['SkipBuild']       = $true }
if ($SkipClientBuild) { $buildParams['SkipClientBuild'] = $true }
if ($SkipServerBuild) { $buildParams['SkipServerBuild'] = $true }
if ($AppVersion)      { $buildParams['AppVersion']      = $AppVersion }
if ($IsccPath)        { $buildParams['IsccPath']        = $IsccPath }

& $setupScript @buildParams

Write-Host "[INFO] Build-HelianzSetup.ps1 complete." -ForegroundColor Green

# ---------------------------------------------------------------------------
# Step 5: Build helianz_qris_mirror_kotlin (Release APK)
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "[STEP 5/6] Building QRIS Mirror Android app (assembleRelease)..." -ForegroundColor Yellow

$qrisDir = Join-Path $PSScriptRoot "helianz_qris_mirror_kotlin"
if (-not (Test-Path $qrisDir)) { throw "QRIS Kotlin project not found: $qrisDir" }

$gradlew = Join-Path $qrisDir "gradlew.bat"
if (-not (Test-Path $gradlew)) { throw "gradlew.bat not found: $gradlew" }

Push-Location $qrisDir
try {
	# Android Gradle Plugin 8.7.3 requires Java 11+.
	# Use Android Studio's bundled JBR (Java 21) if JAVA_HOME is not already set to 11+.
	$savedJavaHome = $env:JAVA_HOME
	$studioJbr = "D:\Android\Android Studio\jbr"
	if (Test-Path $studioJbr) {
		$env:JAVA_HOME = $studioJbr
		Write-Host "[INFO] JAVA_HOME -> $studioJbr" -ForegroundColor DarkGray
	} else {
		Write-Warning "Android Studio JBR not found at '$studioJbr'. Ensure Java 11+ is on PATH or set JAVA_HOME before running this script."
	}
	& cmd.exe /c "$gradlew assembleRelease"
	$env:JAVA_HOME = $savedJavaHome
	if ($LASTEXITCODE -ne 0) { throw "QRIS Mirror assembleRelease failed (exit code $LASTEXITCODE)." }
} finally {
	Pop-Location
}

$qrisApk = Join-Path $qrisDir "app\build\outputs\apk\release\app-release.apk"
if (Test-Path $qrisApk) {
	Write-Host "[INFO] QRIS Mirror APK: $qrisApk" -ForegroundColor Green
} else {
	Write-Warning "Expected APK not found at: $qrisApk"
}

# ---------------------------------------------------------------------------
# Resolve version for the distribution package
# (if not specified, detect from the built client exe)
# ---------------------------------------------------------------------------
if ([string]::IsNullOrWhiteSpace($AppVersion)) {
	$AppVersion = Get-FileVersion -ExePath (Join-Path $PSScriptRoot "Output\Helianz\Helianz.exe")
	if (-not $AppVersion) { $AppVersion = "1.0" }
	Write-Host "[INFO] Distribution version: $AppVersion" -ForegroundColor Green
}

# ---------------------------------------------------------------------------
# Locate ISCC (needed for step 5; may already be known from buildParams)
# ---------------------------------------------------------------------------
if ([string]::IsNullOrWhiteSpace($IsccPath)) { $IsccPath = Find-ISCC }
Write-Host "[INFO] Using ISCC: $IsccPath" -ForegroundColor Green

# ---------------------------------------------------------------------------
# Step 5: Compile HelianzPackage.iss -> Release\HelianzSetup.exe
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "[STEP 6/6] Compiling distribution package (HelianzPackage.iss)..." -ForegroundColor Yellow

$packageIss  = Join-Path $PSScriptRoot "Helianz-Installer\HelianzPackage.iss"
$releaseDir  = Join-Path $PSScriptRoot "Helianz-Installer\Release"
$installerExe = Join-Path $releaseDir "HelianzInstaller.exe"

if (-not (Test-Path $packageIss)) {
	throw "HelianzPackage.iss not found: $packageIss"
}
if (-not (Test-Path $installerExe)) {
	throw "HelianzInstaller.exe not found in $releaseDir.`nEnsure the Release\ folder is populated before running this step."
}

Push-Location (Split-Path $packageIss -Parent)
try {
	& $IsccPath (Split-Path $packageIss -Leaf) "/DMyAppVersion=$AppVersion"
	if ($LASTEXITCODE -ne 0) { throw "HelianzPackage.iss compilation failed." }
} finally {
	Pop-Location
}

$distExe = Join-Path $releaseDir "HelianzSetup.exe"
Write-Host "[INFO] Distribution package: $distExe" -ForegroundColor Green

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
$stopwatch.Stop()
Write-Host ""
Write-Host "========================================================" -ForegroundColor Green
Write-Host "  FULL BUILD COMPLETE" -ForegroundColor Green
Write-Host "  Time    : $($stopwatch.Elapsed.ToString('hh\:mm\:ss'))" -ForegroundColor Green
Write-Host "  Version : $AppVersion" -ForegroundColor Green
Write-Host "  Client  : Helianz-Installer\Release\Helianz Client Setup\Setup.exe" -ForegroundColor Green
Write-Host "  Server  : Helianz-Installer\Release\Helianz Server Setup\Setup.exe" -ForegroundColor Green
Write-Host "  Package : Helianz-Installer\Release\HelianzSetup.exe" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
Write-Host ""
