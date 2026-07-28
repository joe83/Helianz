#Requires -Version 5.1
<#
.SYNOPSIS
    Tears down a temporary HelianzServer middle-tier instance created by
    Create-HelianzTempServer.ps1.

.DESCRIPTION
    Removes the IIS site, application pool, and optionally the output folder
    for a temporary branch/clinic HelianzServer instance.

    Run as Administrator (required for IIS operations).

.PARAMETER SiteName
    IIS site name to remove. Default: HelianzServerTemp

.PARAMETER AppPoolName
    IIS Application Pool name to remove. Default: HelianzServerTempPool

.PARAMETER OutputDir
    Temp server output folder to optionally remove.
    Default: .\Output\HelianzServerTemp

.PARAMETER KeepFiles
    Keep the output folder (only remove IIS site and app pool).

.PARAMETER Force
    Skip confirmation prompts.

.EXAMPLE
    # Remove the temp server completely (with confirmation)
    .\Remove-HelianzTempServer.ps1

    # Remove without confirmation, keep the files
    .\Remove-HelianzTempServer.ps1 -Force -KeepFiles
#>

param(
    [string]$SiteName = "HelianzServerTemp",

    [string]$AppPoolName = "HelianzServerTempPool",

    [string]$OutputDir = "$PSScriptRoot\Output\HelianzServerTemp",

    [switch]$KeepFiles,

    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Continue"

# If running from within the deployed folder, use current directory as default
if ((Test-Path "$PSScriptRoot\Web.config") -and (Test-Path "$PSScriptRoot\bin\HelianzServer.dll")) {
    $OutputDir = $PSScriptRoot
}

# =============================================================================
# Main
# =============================================================================

Write-Host ""
Write-Host "==================================================================" -ForegroundColor Magenta
Write-Host "  Helianz TEMP Server TEARDOWN" -ForegroundColor Magenta
Write-Host "==================================================================" -ForegroundColor Magenta
Write-Host ""

# Check admin rights
$id = [Security.Principal.WindowsIdentity]::GetCurrent()
$p  = New-Object Security.Principal.WindowsPrincipal($id)
if (-not $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw "IIS removal requires Administrator privileges. Run PowerShell as Administrator."
}

# Confirm
if (-not $Force) {
    Write-Host "  This will remove:" -ForegroundColor Yellow
    Write-Host "    - IIS Site       : $SiteName" -ForegroundColor Yellow
    Write-Host "    - App Pool       : $AppPoolName" -ForegroundColor Yellow
    if (-not $KeepFiles) {
        Write-Host "    - Output Folder  : $OutputDir" -ForegroundColor Yellow
    }
    Write-Host ""
    $confirm = Read-Host -Prompt "  Proceed? (y/N)"
    if ($confirm -notmatch "^[yY]") {
        Write-Host "  Aborted." -ForegroundColor DarkGray
        exit 0
    }
}

# ---------------------------------------------------------------------------
# 1. Stop and remove IIS site
# ---------------------------------------------------------------------------
Write-Host "[1/3] Removing IIS site: $SiteName ..." -ForegroundColor Yellow

try {
    Import-Module WebAdministration -ErrorAction Stop
} catch {
    Write-Host "  [WARN] WebAdministration module not available. IIS may not be installed." -ForegroundColor DarkYellow
    Write-Host "  Skipping IIS cleanup." -ForegroundColor DarkGray
}

$site = Get-Website -Name $SiteName -ErrorAction SilentlyContinue
if ($site) {
    try {
        Stop-Website -Name $SiteName -ErrorAction SilentlyContinue
        Write-Host "  Site stopped." -ForegroundColor DarkGray
    } catch {
        Write-Host "  [WARN] Could not stop site (may already be stopped): $_" -ForegroundColor DarkYellow
    }

    try {
        Remove-Website -Name $SiteName -ErrorAction Stop
        Write-Host "  Site $SiteName removed." -ForegroundColor Green
    } catch {
        Write-Host "  [ERROR] Could not remove site: $_" -ForegroundColor Red
    }
} else {
    Write-Host "  Site $SiteName not found. Nothing to remove." -ForegroundColor DarkGray
}

# ---------------------------------------------------------------------------
# 2. Stop and remove App Pool
# ---------------------------------------------------------------------------
Write-Host "[2/3] Removing App Pool: $AppPoolName ..." -ForegroundColor Yellow

$pool = Get-Item "IIS:\AppPools\$AppPoolName" -ErrorAction SilentlyContinue
if ($pool) {
    try {
        Stop-WebAppPool -Name $AppPoolName -ErrorAction SilentlyContinue
        Write-Host "  App Pool stopped." -ForegroundColor DarkGray
    } catch {
        Write-Host "  [WARN] Could not stop app pool: $_" -ForegroundColor DarkYellow
    }

    try {
        Remove-WebAppPool -Name $AppPoolName -ErrorAction Stop
        Write-Host "  App Pool $AppPoolName removed." -ForegroundColor Green
    } catch {
        Write-Host "  [ERROR] Could not remove app pool: $_" -ForegroundColor Red
    }
} else {
    Write-Host "  App Pool $AppPoolName not found. Nothing to remove." -ForegroundColor DarkGray
}

# ---------------------------------------------------------------------------
# 3. Optionally remove output folder
# ---------------------------------------------------------------------------
if (-not $KeepFiles) {
    Write-Host "[3/3] Removing output folder: $OutputDir ..." -ForegroundColor Yellow

    if (Test-Path $OutputDir) {
        try {
            Remove-Item -Path $OutputDir -Recurse -Force -ErrorAction Stop
            Write-Host "  Output folder removed." -ForegroundColor Green
        } catch {
            Write-Host "  [ERROR] Could not remove output folder: $_" -ForegroundColor Red
            Write-Host "  You may need to close any files open in that folder." -ForegroundColor DarkYellow
        }
    } else {
        Write-Host "  Output folder not found. Nothing to remove." -ForegroundColor DarkGray
    }
} else {
    Write-Host "[3/3] Keeping output folder (-KeepFiles)." -ForegroundColor DarkGray
}

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "==================================================================" -ForegroundColor Green
Write-Host "  TEMP SERVER REMOVED" -ForegroundColor Green
Write-Host "==================================================================" -ForegroundColor Green
Write-Host ""

if ($KeepFiles -and (Test-Path $OutputDir)) {
    Write-Host "  Files preserved at: $OutputDir" -ForegroundColor DarkGray
    Write-Host "  Manually delete this folder when no longer needed." -ForegroundColor DarkGray
}
