#Requires -Version 5.1
<#
.SYNOPSIS
    Installs IIS and required components for HelianzServer on Windows Server or Desktop.

.DESCRIPTION
    Called automatically by HelianzServerSetup.iss [Run] before IIS registration.
    Detects the OS type and uses the appropriate cmdlets:
      - Windows Server: Install-WindowsFeature
      - Windows Desktop: Enable-WindowsOptionalFeature (via DISM)

    ALWAYS runs the feature installation — both cmdlets are idempotent and will
    only install features that are missing. This handles partial-install scenarios
    where IIS is present but ASP.NET 4.5 features (Web-Asp-Net45, etc.) are not.

    After feature installation, adds a bitness-neutral .asmx handler via appcmd
    so the handler works regardless of the app pool's enable32BitAppOnWin64 setting.
    This is required because Install-WindowsFeature on Server registers handlers
    with preCondition="bitness64" but the app pool runs in 32-bit mode.

    Idempotent — safe to run even if IIS is already partially or fully installed.

.PARAMETER LogDir
    Directory for the installation log file. Default: $env:TEMP
#>
param(
    [string]$LogDir = $env:TEMP
)

$ErrorActionPreference = 'Stop'
$logFile = Join-Path $LogDir 'iis-install.log'

function Write-Log {
    param([string]$Msg)
    $line = "[{0}] {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Msg
    Write-Host $line
    Add-Content -Path $logFile -Value $line -ErrorAction SilentlyContinue
}

# IIS sub-features required for an ASP.NET 4.x ASMX web service.
# These are Windows Server feature names (Install-WindowsFeature).
$ServerFeatures = @(
    'Web-Server',                   # IIS Web Server (top-level include)
    'Web-WebServer',                # Core web server
    'Web-Common-Http',              # Common HTTP features
    'Web-Default-Doc',              # Default document
    'Web-Dir-Browsing',             # Directory browsing
    'Web-Http-Errors',              # HTTP error pages
    'Web-Static-Content',           # Static content
    'Web-Http-Redirect',            # HTTP redirection
    'Web-Health',                   # Health and diagnostics
    'Web-Http-Logging',             # HTTP logging
    'Web-Performance',              # Performance features
    'Web-Stat-Compression',         # Static compression
    'Web-Security',                 # Security
    'Web-Filtering',                # Request filtering
    'Web-App-Dev',                  # Application development
    'Web-Net-Ext45',                # .NET Extensibility 4.5
    'Web-ISAPI-Ext',                # ISAPI Extensions
    'Web-ISAPI-Filter',             # ISAPI Filters
    'Web-Asp-Net45',                # ASP.NET 4.5+ (creates .asmx handler mappings)
    'Web-Mgmt-Tools',               # Management tools
    'Web-Mgmt-Console',             # IIS Management Console (includes appcmd.exe)
    'NET-WCF-HTTP-Activation45'     # WCF HTTP Activation (needed for ASMX pipeline)
)

# Equivalent DISM capability names for Windows 10/11 Desktop.
$DesktopCapabilities = @(
    'IIS-WebServerRole',
    'IIS-WebServer',
    'IIS-CommonHttpFeatures',
    'IIS-DefaultDocument',
    'IIS-DirectoryBrowsing',
    'IIS-HttpErrors',
    'IIS-StaticContent',
    'IIS-HttpRedirect',
    'IIS-HealthAndDiagnostics',
    'IIS-HttpLogging',
    'IIS-Performance',
    'IIS-HttpCompressionStatic',
    'IIS-Security',
    'IIS-RequestFiltering',
    'IIS-ApplicationDevelopment',
    'IIS-NetFxExtensibility45',
    'IIS-ISAPIExtensions',
    'IIS-ISAPIFilter',
    'IIS-ASPNET45',
    'IIS-ManagementConsole',
    'WCF-Services45',
    'WCF-HTTP-Activation45'
)

function Test-IsWindowsServer {
    $os = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction SilentlyContinue
    if ($os) {
        # ProductType: 1 = Workstation, 2 = Domain Controller, 3 = Server
        return ($os.ProductType -ne 1)
    }
    # Fallback: check for ServerManager module availability
    return (Get-Module -ListAvailable -Name ServerManager)
}

function Test-AspNetHandlerRegistered {
    <#
    .SYNOPSIS
        Checks if the .asmx handler mapping exists in IIS.
    #>
    $appcmd = Join-Path $env:SystemRoot 'System32\inetsrv\appcmd.exe'
    if (-not (Test-Path $appcmd)) {
        Write-Log "WARNING: appcmd.exe not available — cannot verify handler mappings."
        return $false
    }

    $result = & $appcmd list config /section:handlers 2>&1 |
        Select-String -Pattern '\.asmx' -SimpleMatch

    if ($result) {
        Write-Log "Verified: .asmx handler mapping exists in IIS configuration."
        return $true
    }

    Write-Log "WARNING: No .asmx handler mapping found in IIS configuration."
    return $false
}

try {
    Write-Log "=== HelianzServer IIS Installation ==="
    Write-Log "Log file : $logFile"

    $isServer = Test-IsWindowsServer
    Write-Log "OS type: $(if ($isServer) { 'Windows Server' } else { 'Windows Desktop' })"

    if ($isServer) {
        # ----------------------------------------------------------------
        # Windows Server — use Install-WindowsFeature
        # ----------------------------------------------------------------
        Write-Log "Using Install-WindowsFeature (Server Manager module)..."

        Import-Module -Name ServerManager -Force -ErrorAction Stop
        Write-Log "ServerManager module imported."

        $featureList = $ServerFeatures -join ','
        Write-Log "Ensuring features are installed: $featureList"

        $result = Install-WindowsFeature -Name $ServerFeatures -IncludeManagementTools -WarningAction SilentlyContinue

        if ($result.RestartNeeded) {
            Write-Log "WARNING: A reboot is required to complete IIS installation."
        }

        $failed = $result | Where-Object { -not $_.Success -and (-not $_.Installed) }
        if ($failed) {
            $failedNames = ($failed | ForEach-Object { $_.Name }) -join ', '
            throw "Failed to install the following IIS features: $failedNames"
        }

        # Log which features were newly installed vs already present
        $alreadyInstalled = ($result | Where-Object { $_.Installed -and -not $_.Success }).Count
        $newlyInstalled  = ($result | Where-Object { $_.Success }).Count
        Write-Log "Features already installed: $alreadyInstalled"
        Write-Log "Features newly installed : $newlyInstalled"
    }
    else {
        # ----------------------------------------------------------------
        # Windows Desktop — use Enable-WindowsOptionalFeature (DISM)
        # ----------------------------------------------------------------
        Write-Log "Using Enable-WindowsOptionalFeature (DISM)..."

        $failedFeatures = @()
        foreach ($cap in $DesktopCapabilities) {
            Write-Log "  Enabling: $cap"
            try {
                $result = Enable-WindowsOptionalFeature -Online -FeatureName $cap -All -NoRestart -ErrorAction Stop
                if ($result.RestartNeeded) {
                    Write-Log "    Result: RestartNeeded"
                } else {
                    Write-Log "    Result: OK"
                }
            }
            catch {
                # Feature may not exist on this OS version — log and continue
                Write-Log "    WARNING: Could not enable '$cap': $_"
                # Only track as failed for critical features
                if ($cap -in @('IIS-WebServerRole', 'IIS-WebServer', 'IIS-ASPNET45')) {
                    $failedFeatures += $cap
                }
            }
        }

        if ($failedFeatures.Count -gt 0) {
            throw "Failed to install critical IIS features: $($failedFeatures -join ', ')"
        }

        Write-Log "Enable-WindowsOptionalFeature completed."
    }

    # Verify IIS is running
    Write-Log "Verifying IIS installation..."
    Start-Sleep -Seconds 2  # Allow services to register

    $w3svc = Get-Service -Name 'W3SVC' -ErrorAction SilentlyContinue
    if ($w3svc -and $w3svc.Status -eq 'Running') {
        Write-Log "IIS verified — W3SVC service is running."
    }
    else {
        Write-Log "WARNING: W3SVC service not running. A system reboot may be required."
    }

    # ------------------------------------------------------------------------
    # Ensure .asmx handler works with the 32-bit app pool.
    # ------------------------------------------------------------------------
    # On Windows Server, Install-WindowsFeature registers handlers with
    # preCondition="bitness64", but the app pool runs 32-bit
    # (enable32BitAppOnWin64:true). We need a handler without bitness
    # restriction so it matches regardless of pool bitness.
    # Use appcmd to add the ASP.NET 4.0 integrated .asmx handler
    # without a bitness precondition. Safe to call on Desktop too.
    $appcmd = Join-Path $env:SystemRoot 'System32\inetsrv\appcmd.exe'
    if (Test-Path $appcmd) {
        Write-Log "Ensuring .asmx handler exists without bitness restriction..."
        # Remove pre-existing copy (ignore error if absent)
        & $appcmd set config /section:handlers /-"[name='ASMX-Integrated-4.0']" 2>&1 | Out-Null
        # Add the handler: integrated mode, no bitness precondition
        & $appcmd set config /section:handlers /+"[name='ASMX-Integrated-4.0',path='*.asmx',verb='*',type='System.Web.Services.Protocols.WebServiceHandlerFactory, System.Web.Services, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a',preCondition='managedHandler,runtimeVersionv4.0']" 2>&1 |
            ForEach-Object { Write-Log "  [appcmd] $_" }
        if ($LASTEXITCODE -ne 0) {
            Write-Log "WARNING: Failed to add .asmx handler via appcmd."
        }
        else {
            Write-Log ".asmx handler added successfully."
        }
    }

    # Verify .asmx handler mappings exist
    Write-Log "Verifying ASP.NET handler mappings..."
    Start-Sleep -Seconds 1
    Test-AspNetHandlerRegistered

    Write-Log ""
    Write-Log "IIS installation complete."
    Write-Log "Service endpoint: http://localhost/HelianzServer/ServiceMain.asmx"
    exit 0
}
catch {
    Write-Log "ERROR: $_"
    exit 1
}
