#Requires -Version 5.1
<#
.SYNOPSIS
    Registers HelianzServer as an IIS Web Application under the Default Web Site.

.DESCRIPTION
    Called automatically by HelianzServerSetup.iss [Run] after files are copied.
    Creates (or reconfigures) the HelianzServerPool application pool, then
    registers the web application.  Safe to re-run on upgrade — existing
    registration is removed and recreated cleanly.

.PARAMETER InstallDir
    Physical path of the installed web service files (value of {app} in Inno Setup).

.PARAMETER SiteName
    IIS site that will host the web application. Default: "Default Web Site"

.PARAMETER AppName
    Virtual path / application name. Default: HelianzServer

.PARAMETER AppPoolName
    Application Pool name. Default: HelianzServerPool
#>
param(
    [Parameter(Mandatory)]
    [string]$InstallDir,

    [string]$SiteName    = 'Default Web Site',
    [string]$AppName     = 'HelianzServer',
    [string]$AppPoolName = 'HelianzServerPool'
)

$ErrorActionPreference = 'Stop'
$logFile = Join-Path $InstallDir 'iis-register.log'

function Write-Log {
    param([string]$Msg)
    $line = "[{0}] {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Msg
    Write-Host $line
    Add-Content -Path $logFile -Value $line -ErrorAction SilentlyContinue
}

try {
    Write-Log "=== HelianzServer IIS Registration ==="
    Write-Log "InstallDir : $InstallDir"
    Write-Log "Site       : $SiteName"
    Write-Log "AppName    : $AppName"
    Write-Log "AppPool    : $AppPoolName"

    $appcmd = "$env:SystemRoot\System32\inetsrv\appcmd.exe"
    if (-not (Test-Path $appcmd)) {
        throw "appcmd.exe not found at '$appcmd'. IIS does not appear to be installed."
    }

    # ------------------------------------------------------------------
    # 1. Application Pool — create if absent, then configure
    # ------------------------------------------------------------------
    $existingPool = & $appcmd list apppool /name:"$AppPoolName" 2>&1
    if ($LASTEXITCODE -ne 0 -or -not $existingPool) {
        Write-Log "Creating Application Pool: $AppPoolName"
        & $appcmd add apppool /name:"$AppPoolName" 2>&1 | ForEach-Object { Write-Log "  [appcmd] $_" }
        if ($LASTEXITCODE -ne 0) { throw "Failed to create application pool '$AppPoolName'." }
    } else {
        Write-Log "Application Pool already exists: $AppPoolName (reconfiguring)"
    }

    # Configure pool: .NET v4, Integrated pipeline, AlwaysRunning, 32-bit, no idle timeout
    $cfgArgs = @(
        "set", "apppool", $AppPoolName,
        "/managedRuntimeVersion:v4.0",
        "/managedPipelineMode:Integrated",
        "/startMode:AlwaysRunning",
        "/enable32BitAppOnWin64:true",
        "/processModel.idleTimeout:00:00:00"
    )
    & $appcmd @cfgArgs 2>&1 | ForEach-Object { Write-Log "  [appcmd] $_" }
    if ($LASTEXITCODE -ne 0) { throw "Failed to configure application pool '$AppPoolName'." }

    # ------------------------------------------------------------------
    # 2. Web Application — delete then recreate for idempotency
    # ------------------------------------------------------------------
    Write-Log "Removing existing registration '$SiteName/$AppName' (if any)..."
    & $appcmd delete app "$SiteName/$AppName" 2>&1 | Out-Null   # non-zero OK if absent

    Write-Log "Creating Web Application: /$AppName under '$SiteName'"
    Write-Log "  Physical path: $InstallDir"
    & $appcmd add app /site.name:"$SiteName" /path:"/$AppName" /physicalPath:"$InstallDir" 2>&1 |
        ForEach-Object { Write-Log "  [appcmd] $_" }
    if ($LASTEXITCODE -ne 0) { throw "appcmd.exe failed to create web application '$AppName'." }

    & $appcmd set app "$SiteName/$AppName" /applicationPool:"$AppPoolName" 2>&1 |
        ForEach-Object { Write-Log "  [appcmd] $_" }
    if ($LASTEXITCODE -ne 0) { throw "Failed to assign application pool '$AppPoolName' to '$AppName'." }

    # ------------------------------------------------------------------
    # 3. Start the Application Pool
    # ------------------------------------------------------------------
    Write-Log "Starting Application Pool: $AppPoolName"
    & $appcmd start apppool "$AppPoolName" 2>&1 | Out-Null   # may already be started — ignore exit code

    # Verify
    $verify = & $appcmd list app "$SiteName/$AppName" 2>&1
    Write-Log "Verify: $verify"

    Write-Log "IIS registration complete."
    Write-Log "Service endpoint: http://localhost/$AppName/ServiceMain.asmx"
    exit 0
}
catch {
    Write-Log "ERROR: $_"
    exit 1
}
