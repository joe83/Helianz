#Requires -Version 5.1
<#
.SYNOPSIS
	Builds the Helianz Client Setup and Helianz Server Setup installer packages
	(Setup.exe) using Inno Setup 6, and optionally builds the applications first.

.DESCRIPTION
	Steps performed:
	  1. (Optional) Build Helianz client via .\Build-Helianz.ps1
	  2. (Optional) Build Helianz Server via .\Build-HelianzServer.ps1
	  3. Locate the Inno Setup 6 compiler (ISCC.exe)
	  4. Detect app version from Output\Helianz\Helianz.exe (or use -AppVersion)
	  5. Compile HelianzClientSetup.iss
	       -> Helianz-Installer\Release\Helianz Client Setup\Setup.exe
	  6. Compile HelianzServerSetup.iss
	       -> Helianz-Installer\Release\Helianz Server Setup\Setup.exe

	The produced Setup.exe files are consumed by HelianzInstaller.exe, which
	looks for them in its own directory under "Helianz Client Setup\" and
	"Helianz Server Setup\".

	Requires Inno Setup 6 (https://jrsoftware.org/isinfo.php).

.PARAMETER Configuration
	Build configuration passed to sub-build scripts: Debug or Release (default: Release).

.PARAMETER SkipBuild
	Skip both the client and server builds. Assumes Output\ is already populated.

.PARAMETER SkipClientBuild
	Skip only the Helianz client build.

.PARAMETER SkipServerBuild
	Skip only the Helianz Server build.

.PARAMETER AppVersion
	Override the installer version string (e.g. "24.1.0").
	Passed to ISCC as /DMyAppVersion=... and embedded in both Setup.exe files.
	If omitted, the version is read from Output\Helianz\Helianz.exe; defaults
	to "1.0" if the exe is not present.

.PARAMETER IsccPath
	Full path to ISCC.exe. Auto-detected from standard Inno Setup install
	locations if not provided.

.EXAMPLE
	# Full pipeline: build both apps, then compile both installers
	.\Build-HelianzSetup.ps1

	# Compile installers only (builds were done separately)
	.\Build-HelianzSetup.ps1 -SkipBuild

	# Build client only, skip server, compile both installers
	.\Build-HelianzSetup.ps1 -SkipServerBuild

	# Full pipeline with an explicit version stamp
	.\Build-HelianzSetup.ps1 -AppVersion "24.1.0"
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

$clientIss  = Join-Path $PSScriptRoot "Helianz-Installer\HelianzClientSetup.iss"
$serverIss  = Join-Path $PSScriptRoot "Helianz-Installer\HelianzServerSetup.iss"
$clientExe  = Join-Path $PSScriptRoot "Output\Helianz\Helianz.exe"

$skipAllBuilds = $SkipBuild -or ($SkipClientBuild -and $SkipServerBuild)

Write-Host ""
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  Helianz Setup Builder" -ForegroundColor Cyan
Write-Host "  Configuration : $Configuration" -ForegroundColor Cyan
Write-Host "  Build Client  : $(-not ($SkipBuild -or $SkipClientBuild))" -ForegroundColor Cyan
Write-Host "  Build Server  : $(-not ($SkipBuild -or $SkipServerBuild))" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

# ---------------------------------------------------------------------------
# Step 1a - Build Helianz client (optional)
# ---------------------------------------------------------------------------
if (-not $SkipBuild -and -not $SkipClientBuild) {
	Write-Host "[STEP 1a] Building Helianz client ($Configuration)..." -ForegroundColor Yellow
	$buildScript = Join-Path $PSScriptRoot "Build-Helianz.ps1"
	if (-not (Test-Path $buildScript)) { throw "Build script not found: $buildScript" }
	& $buildScript -Configuration $Configuration
	if ($LASTEXITCODE -ne 0) { throw "Helianz client build failed. Check build-helianz.log." }
	Write-Host "[INFO] Helianz client build complete." -ForegroundColor Green
} else {
	Write-Host "[STEP 1a] Skipping Helianz client build." -ForegroundColor DarkGray
}

# ---------------------------------------------------------------------------
# Step 1b - Build Helianz Server (optional)
# ---------------------------------------------------------------------------
if (-not $SkipBuild -and -not $SkipServerBuild) {
	Write-Host ""
	Write-Host "[STEP 1b] Building Helianz Server ($Configuration)..." -ForegroundColor Yellow
	$serverScript = Join-Path $PSScriptRoot "Build-HelianzServer.ps1"
	if (-not (Test-Path $serverScript)) { throw "Build script not found: $serverScript" }
	& $serverScript -Configuration $Configuration
	if ($LASTEXITCODE -ne 0) { throw "Helianz Server build failed. Check build-helianzserver.log." }
	Write-Host "[INFO] Helianz Server build complete." -ForegroundColor Green
} else {
	Write-Host "[STEP 1b] Skipping Helianz Server build." -ForegroundColor DarkGray
}

# ---------------------------------------------------------------------------
# Step 2 - Resolve installer version
# ---------------------------------------------------------------------------
Write-Host ""
if ([string]::IsNullOrWhiteSpace($AppVersion)) {
	$AppVersion = Get-FileVersion -ExePath $clientExe
	if ($AppVersion) {
		Write-Host "[INFO] Detected version from Helianz.exe: $AppVersion" -ForegroundColor Green
	} else {
		$AppVersion = "1.0"
		Write-Host "[WARN] Could not read version from $clientExe - defaulting to $AppVersion." -ForegroundColor DarkYellow
	}
} else {
	Write-Host "[INFO] Using specified version: $AppVersion" -ForegroundColor Green
}

# ---------------------------------------------------------------------------
# Step 3 - Locate Inno Setup compiler
# ---------------------------------------------------------------------------
if ([string]::IsNullOrWhiteSpace($IsccPath)) { $IsccPath = Find-ISCC }
Write-Host "[INFO] Using ISCC: $IsccPath" -ForegroundColor Green

# ---------------------------------------------------------------------------
# Step 4 - Validate source directories exist
# ---------------------------------------------------------------------------
$clientSrc = Join-Path $PSScriptRoot "Output\Helianz"
$serverSrc = Join-Path $PSScriptRoot "Output\HelianzServer"

if (-not (Test-Path $clientSrc)) {
	throw "Client build output not found: $clientSrc`nRun Build-Helianz.ps1 first or remove -SkipClientBuild."
}
if (-not (Test-Path $serverSrc)) {
	throw "Server build output not found: $serverSrc`nRun Build-HelianzServer.ps1 first or remove -SkipServerBuild."
}

# ---------------------------------------------------------------------------
# Step 5 - Compile Helianz Client Setup
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "[STEP 2/3] Compiling Helianz Client Setup..." -ForegroundColor Yellow

if (-not (Test-Path $clientIss)) { throw "ISS script not found: $clientIss" }

Push-Location (Split-Path $clientIss -Parent)
try {
	& $IsccPath (Split-Path $clientIss -Leaf) "/DMyAppVersion=$AppVersion"
	if ($LASTEXITCODE -ne 0) { throw "HelianzClientSetup.iss compilation failed." }
} finally {
	Pop-Location
}

$clientOut = Join-Path $PSScriptRoot "Helianz-Installer\Release\Helianz Client Setup\Setup.exe"
Write-Host "[INFO] Client Setup: $clientOut" -ForegroundColor Green

# ---------------------------------------------------------------------------
# Step 6 - Compile Helianz Server Setup
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "[STEP 3/3] Compiling Helianz Server Setup..." -ForegroundColor Yellow

if (-not (Test-Path $serverIss)) { throw "ISS script not found: $serverIss" }

Push-Location (Split-Path $serverIss -Parent)
try {
	& $IsccPath (Split-Path $serverIss -Leaf) "/DMyAppVersion=$AppVersion"
	if ($LASTEXITCODE -ne 0) { throw "HelianzServerSetup.iss compilation failed." }
} finally {
	Pop-Location
}

$serverOut = Join-Path $PSScriptRoot "Helianz-Installer\Release\Helianz Server Setup\Setup.exe"
Write-Host "[INFO] Server Setup: $serverOut" -ForegroundColor Green

$stopwatch.Stop()
Write-Host ""
Write-Host "========================================================" -ForegroundColor Green
Write-Host "  SETUP BUILD COMPLETE" -ForegroundColor Green
Write-Host "  Time    : $($stopwatch.Elapsed.ToString('hh\:mm\:ss'))" -ForegroundColor Green
Write-Host "  Version : $AppVersion" -ForegroundColor Green
Write-Host "  Client  : Helianz-Installer\Release\Helianz Client Setup\Setup.exe" -ForegroundColor Green
Write-Host "  Server  : Helianz-Installer\Release\Helianz Server Setup\Setup.exe" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
Write-Host ""
