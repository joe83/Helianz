#Requires -Version 5.1
<#
.SYNOPSIS
	Builds the Helianz main client application and moves binaries to a dedicated output folder.

.PARAMETER Configuration
	Build configuration: Debug or Release (default: Release)

.PARAMETER OutputDir
	Destination folder for built binaries (default: .\Output\Helianz)

.PARAMETER MsBuildPath
	Full path to MSBuild.exe. Auto-detected from Visual Studio if not provided.

.EXAMPLE
	.\Build-Helianz.ps1
	.\Build-Helianz.ps1 -Configuration Debug -OutputDir "C:\Deploy\Helianz"
#>
param(
	[ValidateSet('Debug','Release')]
	[string]$Configuration = 'Release',

	[string]$OutputDir = "$PSScriptRoot\Output\Helianz",

	[string]$MsBuildPath = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Locate MSBuild
# ---------------------------------------------------------------------------
function Find-MsBuild {
	$candidates = @(
		# VS 2022 / 2019 / 2017 paths
		"${env:ProgramFiles}\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe",
		"${env:ProgramFiles}\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe",
		"${env:ProgramFiles}\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe",
		"${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\MSBuild.exe",
		"${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\MSBuild.exe",
		"${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\MSBuild.exe",
		"${env:ProgramFiles(x86)}\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\MSBuild.exe",
		"${env:ProgramFiles(x86)}\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin\MSBuild.exe",
		"${env:ProgramFiles(x86)}\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\MSBuild.exe",
		# VS 2026 (18.x) potential path
		"${env:ProgramFiles}\Microsoft Visual Studio\2026\Community\MSBuild\Current\Bin\MSBuild.exe",
		"${env:ProgramFiles}\Microsoft Visual Studio\2026\Professional\MSBuild\Current\Bin\MSBuild.exe",
		"${env:ProgramFiles}\Microsoft Visual Studio\2026\Enterprise\MSBuild\Current\Bin\MSBuild.exe"
	)

	# Try vswhere first
	$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
	if (-not (Test-Path $vswhere)) {
		$vswhere = "${env:ProgramFiles}\Microsoft Visual Studio\Installer\vswhere.exe"
	}
	if (Test-Path $vswhere) {
		$vsPath = & $vswhere -latest -products * -requires Microsoft.Component.MSBuild -property installationPath 2>$null
		if ($vsPath) {
			$candidate = Join-Path $vsPath 'MSBuild\Current\Bin\MSBuild.exe'
			if (Test-Path $candidate) { return $candidate }
		}
	}

	foreach ($c in $candidates) {
		if (Test-Path $c) { return $c }
	}

	throw "MSBuild.exe not found. Install Visual Studio or specify -MsBuildPath."
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
$stopwatch = [Diagnostics.Stopwatch]::StartNew()

Write-Host ""
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  Helianz Client Build Script" -ForegroundColor Cyan
Write-Host "  Configuration : $Configuration" -ForegroundColor Cyan
Write-Host "  Output Dir    : $OutputDir" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

# Resolve MSBuild
if (-not $MsBuildPath) {
	$MsBuildPath = Find-MsBuild
}
Write-Host "[INFO] Using MSBuild: $MsBuildPath" -ForegroundColor Green

# Project / solution paths
$projectFile = Join-Path $PSScriptRoot "Helianz\Helianz.csproj"
if (-not (Test-Path $projectFile)) {
	throw "Project not found: $projectFile"
}

$binDir = Join-Path $PSScriptRoot "Helianz\bin\$Configuration"

# ---------------------------------------------------------------------------
# Restore NuGet packages (if packages.config or PackageReference present)
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "[STEP 1/3] Restoring NuGet packages..." -ForegroundColor Yellow

$sln = Get-ChildItem -Path $PSScriptRoot -Filter "*.sln" -File | Select-Object -First 1
if ($sln) {
	& $MsBuildPath $sln.FullName /t:Restore /p:Configuration=$Configuration /verbosity:minimal
} else {
	Write-Host "[WARN] No .sln found; skipping restore." -ForegroundColor DarkYellow
}

# ---------------------------------------------------------------------------
# Build
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "[STEP 2/3] Building Helianz ($Configuration)..." -ForegroundColor Yellow

$buildArgs = @(
	$projectFile,
	"/t:Clean;Build",
	"/p:Configuration=$Configuration",
	"/p:Platform=AnyCPU",
	"/m",                    # parallel build
	"/verbosity:minimal",
	"/fl",                   # file logger
	"/flp:LogFile=`"$PSScriptRoot\build-helianz.log`";Verbosity=normal"
)

& $MsBuildPath @buildArgs
if ($LASTEXITCODE -ne 0) {
	Write-Host ""
	Write-Error "Build FAILED. Check build-helianz.log for details."
	exit 1
}

Write-Host "[INFO] Build succeeded." -ForegroundColor Green

# ---------------------------------------------------------------------------
# Copy output to dedicated folder
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "[STEP 3/3] Copying binaries to output folder..." -ForegroundColor Yellow

if (-not (Test-Path $OutputDir)) {
	New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

if (-not (Test-Path $binDir)) {
	Write-Error "Binary folder not found after build: $binDir"
	exit 1
}

# Copy all build output, preserving sub-folders
Copy-Item -Path "$binDir\*" -Destination $OutputDir -Recurse -Force

$stopwatch.Stop()
Write-Host ""
Write-Host "========================================================" -ForegroundColor Green
Write-Host "  BUILD COMPLETE" -ForegroundColor Green
Write-Host "  Time    : $($stopwatch.Elapsed.ToString('hh\:mm\:ss'))" -ForegroundColor Green
Write-Host "  Output  : $OutputDir" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
Write-Host ""
