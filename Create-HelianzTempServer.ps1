#Requires -Version 5.1
<#
.SYNOPSIS
    Creates a temporary HelianzServer middle-tier instance on a custom IIS port,
    pointing to the same MySQL host as the live server but using a different database.

.DESCRIPTION
    Use this for branch/clinic adaptation. Gives a branch real data in a separate
    database without touching the production server. The temp server runs on its own
    IIS site and port, completely isolated from the live server.

    TWO-PHASE WORKFLOW (dev machine, then server):
      PHASE 1 (dev machine): .\Create-HelianzTempServer.ps1 -PrepareOnly
        → Builds everything into Output\HelianzServerTemp (self-contained folder)
        → Copy Output\HelianzServerTemp to the server
      PHASE 2 (server, as Admin): cd C:\path\to\HelianzServerTemp ; .\Create-HelianzTempServer.ps1 -SkipBuild
        → Interactive DB config dialog, then registers IIS on port 9391

    Run Phase 2 as Administrator (required for IIS registration).

.PARAMETER Configuration
    Build configuration: Debug or Release (default: Release)

.PARAMETER Platform
    Build platform: x86 or AnyCPU (default: AnyCPU)

.PARAMETER OutputDir
    Root folder for the temp server files.
    Default: .\Output\HelianzServerTemp

.PARAMETER SiteName
    IIS site name for the temp server. Default: HelianzServerTemp

.PARAMETER Port
    IIS port for the temp server. Default: 9391

.PARAMETER AppPoolName
    IIS Application Pool name. Default: HelianzServerTempPool

.PARAMETER MySqlHost
    MySQL server hostname or IP. Default: localhost.
    (Use the same host as your live server.)

.PARAMETER MySqlDatabase
    MySQL database name for the temp server. Default: helianz_temp
    (MUST be different from your live database name.)

.PARAMETER MySqlUser
    MySQL admin (read/write) username.

.PARAMETER MySqlUserLow
    MySQL low-privilege (read-only) username. Leave blank to skip.

.PARAMETER SkipBuild
    Skip the MSBuild step and reuse existing build output in Output\HelianzServer.

.PARAMETER MsBuildPath
    Full path to MSBuild.exe. Auto-detected if not provided.

.EXAMPLE
    # Full setup with build + IIS registration (run as Administrator)
    .\Create-HelianzTempServer.ps1

    # Skip build, reuse existing output, use specific DB name
    .\Create-HelianzTempServer.ps1 -SkipBuild -MySqlHost 192.168.1.100 -MySqlDatabase helianz_cabang -Port 9392

    # Just build, don't register IIS yet
    .\Create-HelianzTempServer.ps1 -SkipIIS
#>

param(
    [ValidateSet("Debug", "Release")]
    [string]$Configuration = "Release",

    [ValidateSet("x86", "AnyCPU")]
    [string]$Platform = "x86",

    [string]$OutputDir = "$PSScriptRoot\Output\HelianzServerTemp",

    [string]$SiteName = "HelianzServerTemp",

    [int]$Port = 9391,

    [string]$AppPoolName = "HelianzServerTempPool",

    [string]$MySqlHost = "",

    [string]$MySqlDatabase = "",

    [string]$MySqlUser = "",

    [string]$MySqlUserLow = "",

    [switch]$SkipBuild,

    [switch]$SkipIIS,

    [switch]$PrepareOnly,

    [string]$MsBuildPath = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# =============================================================================
# Helper Functions
# =============================================================================

function Write-Banner {
    Write-Host ""
    Write-Host "==================================================================" -ForegroundColor Magenta
    Write-Host "  Helianz TEMPORARY Middle-Tier Server Setup" -ForegroundColor Magenta
    Write-Host "  For branch/clinic adaptation - NOT production" -ForegroundColor DarkYellow
    Write-Host "==================================================================" -ForegroundColor Magenta
    Write-Host ""
}

function Find-MsBuild {
    $vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    if (-not (Test-Path $vswhere)) {
        $vswhere = "${env:ProgramFiles}\Microsoft Visual Studio\Installer\vswhere.exe"
    }
    if (Test-Path $vswhere) {
        $vsPath = & $vswhere -latest -products * -requires Microsoft.Component.MSBuild -property installationPath 2>$null
        if ($vsPath) {
            $candidate = Join-Path $vsPath "MSBuild\Current\Bin\MSBuild.exe"
            if (Test-Path $candidate) { return $candidate }
        }
    }
    $candidates = @(
        "${env:ProgramFiles}\Microsoft Visual Studio\2026\Community\MSBuild\Current\Bin\MSBuild.exe",
        "${env:ProgramFiles}\Microsoft Visual Studio\2026\Professional\MSBuild\Current\Bin\MSBuild.exe",
        "${env:ProgramFiles}\Microsoft Visual Studio\2026\Enterprise\MSBuild\Current\Bin\MSBuild.exe",
        "${env:ProgramFiles}\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe",
        "${env:ProgramFiles}\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe",
        "${env:ProgramFiles}\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe",
        "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\MSBuild.exe",
        "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\MSBuild.exe",
        "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\MSBuild.exe"
    )
    foreach ($c in $candidates) {
        if (Test-Path $c) { return $c }
    }
    throw "MSBuild.exe not found. Install Visual Studio or specify -MsBuildPath."
}

function Read-SecurePassword {
    param([string]$Prompt)
    $ss = Read-Host -Prompt $Prompt -AsSecureString
    return [Runtime.InteropServices.Marshal]::PtrToStringBSTR(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($ss))
}

function Invoke-ConfigDialog {
    Write-Host ""
    Write-Host "  --------------------------------------------------------" -ForegroundColor Cyan
    Write-Host "  Database Connection Setup (TEMP SERVER)" -ForegroundColor Cyan
    Write-Host "  --------------------------------------------------------" -ForegroundColor Cyan
    Write-Host "  This temp server will connect to the SAME MySQL host" -ForegroundColor DarkGray
    Write-Host "  as your live server, but use a DIFFERENT database name." -ForegroundColor DarkGray
    Write-Host ""

    $hostVal = if ($MySqlHost) { $MySqlHost } else { Read-Host -Prompt "  MySQL Host (e.g., 192.168.1.100)" }
    if (-not $hostVal) { throw "MySQL host is required." }

    $dbDefault = if ($MySqlDatabase) { $MySqlDatabase } else { "helianz_temp" }
    $dbVal = Read-Host -Prompt "  Database Name [$dbDefault]"
    if ([string]::IsNullOrWhiteSpace($dbVal)) { $dbVal = $dbDefault }

    Write-Host ""
    Write-Host "  --- Admin (Read/Write) User ---" -ForegroundColor DarkCyan
    $userDefault = if ($MySqlUser) { $MySqlUser } else { "oduser" }
    $userVal = Read-Host -Prompt "  Username [$userDefault]"
    if ([string]::IsNullOrWhiteSpace($userVal)) { $userVal = $userDefault }
    $pwdVal = Read-SecurePassword -Prompt "  Password"

    Write-Host ""
    Write-Host "  --- Low-Privilege (Read-Only) User (optional) ---" -ForegroundColor DarkCyan
    $userLowVal = Read-Host -Prompt "  Low-Priv User (Enter to skip)"
    $pwdLowVal = ""
    if ($userLowVal) {
        $pwdLowVal = Read-SecurePassword -Prompt "  Low-Priv Password"
    }

    return @{
        Host        = $hostVal
        Database    = $dbVal
        User        = $userVal
        Password    = $pwdVal
        UserLow     = $userLowVal
        PasswordLow = $pwdLowVal
    }
}

function Write-ConfigXml {
    param(
        [hashtable]$Config,
        [string]$DestinationPath,
        [int]$ServerPort
    )
    $esc = { param($s) [System.Security.SecurityElement]::Escape($s) }
    $lines = @(
        "<?xml version=""1.0""?>",
        "<!-- TEMPORARY HelianzServer config - branch/clinic adaptation -->",
        "<ConnectionSettings>",
        "  <ServerPort>$ServerPort</ServerPort>",
        "  <DatabaseConnection>",
        "    <ComputerName>$(& $esc $Config.Host)</ComputerName>",
        "    <Database>$(& $esc $Config.Database)</Database>",
        "    <User>$(& $esc $Config.User)</User>",
        "    <Password>$(& $esc $Config.Password)</Password>",
        "    <UserLow>$(& $esc $Config.UserLow)</UserLow>",
        "    <PasswordLow>$(& $esc $Config.PasswordLow)</PasswordLow>",
        "    <DatabaseType>MySql</DatabaseType>",
        "    <ApplicationName>/HelianzServer</ApplicationName>",
        "    <VerboseLogging>false</VerboseLogging>",
        "    <LogDirectory></LogDirectory>",
        "  </DatabaseConnection>",
        "</ConnectionSettings>"
    )
    Set-Content -Path $DestinationPath -Value $lines -Encoding UTF8
}

function Assert-IISReady {
    if (-not (Get-Module -ListAvailable -Name WebAdministration -ErrorAction SilentlyContinue)) {
        throw "IIS WebAdministration module not found. Install IIS or run on a machine with IIS."
    }
    Import-Module WebAdministration -ErrorAction Stop

    $os = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
    $isServer = $os -and ($os.ProductType -ne 1)

    if ($isServer) {
        $feat = Get-WindowsFeature -Name "Web-Asp-Net45" -ErrorAction SilentlyContinue
        if ($feat -and $feat.InstallState -ne "Installed") {
            Write-Host "  Installing ASP.NET 4.5 IIS feature..." -ForegroundColor DarkCyan
            Add-WindowsFeature -Name "Web-Asp-Net45" -IncludeAllSubFeature | Out-Null
        }
    } else {
        foreach ($f in @("IIS-ASPNET45", "IIS-NetFxExtensibility45", "IIS-ISAPIExtensions", "IIS-ISAPIFilter")) {
            $state = Get-WindowsOptionalFeature -Online -FeatureName $f -ErrorAction SilentlyContinue
            if ($state -and $state.State -ne "Enabled") {
                Write-Host "  Enabling IIS feature: $f..." -ForegroundColor DarkCyan
                Enable-WindowsOptionalFeature -Online -FeatureName $f -All -NoRestart -ErrorAction Stop | Out-Null
            }
        }
    }
}

function Register-TempIISSite {
    param(
        [string]$PhysicalPath,
        [string]$SiteName,
        [int]$Port,
        [string]$AppPoolName
    )

    Write-Host ""
    Write-Host "  Registering IIS site: $SiteName on port $Port" -ForegroundColor Yellow

    # --- Create App Pool ---
    if (-not (Test-Path "IIS:\AppPools\$AppPoolName")) {
        Write-Host "  Creating Application Pool: $AppPoolName" -ForegroundColor DarkCyan
        New-WebAppPool -Name $AppPoolName | Out-Null
    } else {
        Write-Host "  Application Pool already exists: $AppPoolName" -ForegroundColor DarkGray
    }

    $pool = Get-Item "IIS:\AppPools\$AppPoolName"
    $pool.managedRuntimeVersion = "v4.0"
    $pool.managedPipelineMode   = "Integrated"
    $pool.startMode             = "AlwaysRunning"
    $pool.enable32BitAppOnWin64 = $true
    $pool.processModel.idleTimeout = [TimeSpan]::Zero
    $pool | Set-Item
    Write-Host "  App Pool configured: .NET v4.0, Integrated, AlwaysRunning" -ForegroundColor DarkCyan

    # --- Create or update site.
    #     Site root points to the output dir (contains HelianzServer\ subfolder + scripts).
    #     We add an IIS Application at /HelianzServer so .asmx goes through ASP.NET pipeline.
    $existingSite = Get-Website -Name $SiteName -ErrorAction SilentlyContinue
    if ($existingSite) {
        Write-Host "  IIS site $SiteName already exists - updating..." -ForegroundColor DarkGray
        $existingBinding = $existingSite.Bindings.Collection |
            Where-Object { $_.protocol -eq "http" -and $_.bindingInformation -eq "*:$($Port):" }
        if (-not $existingBinding) {
            Write-Host "  Adding HTTP binding on port $Port..." -ForegroundColor DarkCyan
            New-WebBinding -Name $SiteName -Protocol http -Port $Port -IPAddress "*" | Out-Null
        }
        Set-ItemProperty "IIS:\Sites\$SiteName" -Name physicalPath -Value $PhysicalPath
        Set-ItemProperty "IIS:\Sites\$SiteName" -Name applicationPool -Value $AppPoolName
    } else {
        Write-Host "  Creating IIS site: $SiteName on port $Port" -ForegroundColor DarkCyan
        New-Website -Name $SiteName `
                    -PhysicalPath $PhysicalPath `
                    -Port $Port `
                    -ApplicationPool $AppPoolName | Out-Null
    }

    # --- Register ASP.NET 4.x with IIS (essential for .asmx handler to work) ---
    $aspnetRegiis = "$env:SystemRoot\Microsoft.NET\Framework\v4.0.30319\aspnet_regiis.exe"
    if (Test-Path $aspnetRegiis) {
        Write-Host "  Registering ASP.NET 4.x handlers with IIS..." -ForegroundColor DarkCyan
        & $aspnetRegiis -iru 2>&1 | Out-Null
        Write-Host "  ASP.NET 4.x handlers registered." -ForegroundColor DarkGray
    }

    # --- Add /HelianzServer as an IIS Application.
    #     Without this, .asmx requests hit StaticFile handler (404).
    $appSubDir = Join-Path $PhysicalPath "HelianzServer"
    $appPath = "IIS:\Sites\$SiteName\HelianzServer"
    if (Test-Path $appPath) {
        Write-Host "  /HelianzServer application already exists - updating..." -ForegroundColor DarkGray
        Set-ItemProperty $appPath -Name physicalPath -Value $appSubDir
        Set-ItemProperty $appPath -Name applicationPool -Value $AppPoolName
    } else {
        Write-Host "  Creating /HelianzServer IIS application..." -ForegroundColor DarkCyan
        New-WebApplication -Name "HelianzServer" -Site $SiteName -PhysicalPath $appSubDir -ApplicationPool $AppPoolName | Out-Null
    }

    # --- Ensure the site is started ---
    $siteState = Get-WebsiteState -Name $SiteName
    if ($siteState.Value -ne "Started") {
        Start-Website -Name $SiteName
        Write-Host "  Site started." -ForegroundColor DarkCyan
    }

    # --- Ensure app pool is started ---
    $poolState = Get-WebAppPoolState -Name $AppPoolName
    if ($poolState.Value -ne "Started") {
        Start-WebAppPool -Name $AppPoolName
    }

    $url = "http://localhost:$Port/HelianzServer/ServiceMain.asmx"
    return $url
}

# =============================================================================
# Main
# =============================================================================

Write-Banner

if ((-not $SkipIIS) -and (-not $PrepareOnly)) {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $p  = New-Object Security.Principal.WindowsPrincipal($id)
    if (-not $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        throw "IIS registration requires Administrator privileges. Run PowerShell as Administrator."
    }
}

$stopwatch = [Diagnostics.Stopwatch]::StartNew()

# ---------------------------------------------------------------------------
# Step 1 - Build (or skip)
# ---------------------------------------------------------------------------
$liveOutputDir = "$PSScriptRoot\Output\HelianzServer"

# Resolve where the pre-built HelianzServer files live when skipping build.
# Priority: 1) script directory itself (when run from copied folder on server)
#           2) Output\HelianzServer (standard build output)
function Find-ServerFiles {
    # Check if we are already inside a deployed folder (script + bin + Web.config alongside)
    if ((Test-Path "$PSScriptRoot\Web.config") -and (Test-Path "$PSScriptRoot\bin\HelianzServer.dll")) {
        return $PSScriptRoot
    }
    if (Test-Path "$liveOutputDir\Web.config") {
        return $liveOutputDir
    }
    return $null
}

if ($SkipBuild) {
    $sourceFromDir = Find-ServerFiles
    if (-not $sourceFromDir) {
        throw "No existing build found. Checked: script directory and $liveOutputDir. Run without -SkipBuild on dev machine first."
    }
    Write-Host "[STEP 1/4] Skipping build - using files from:" -ForegroundColor Yellow
    Write-Host "  $sourceFromDir" -ForegroundColor DarkGray
    $liveOutputDir = $sourceFromDir
} else {
    Write-Host "[STEP 1/4] Building HelianzServer..." -ForegroundColor Yellow

    if (-not $MsBuildPath) { $MsBuildPath = Find-MsBuild }
    Write-Host "  MSBuild: $MsBuildPath" -ForegroundColor DarkGray

    $projectFile = Join-Path $PSScriptRoot "HelianzServer\HelianzServer.csproj"
    if (-not (Test-Path $projectFile)) {
        throw "Project not found: $projectFile"
    }

    # Restore NuGet
    $sln = Get-ChildItem -Path $PSScriptRoot -Filter "*.sln" -File | Select-Object -First 1
    if ($sln) {
        $SlnPlatform = if ($Platform -eq "AnyCPU") { "Any CPU" } else { $Platform }
        Write-Host "  Restoring NuGet packages..." -ForegroundColor DarkGray
        & $MsBuildPath $sln.FullName /t:Restore /p:Configuration=$Configuration "/p:Platform=$SlnPlatform" /verbosity:minimal
        if ($LASTEXITCODE -ne 0) { throw "NuGet restore failed." }
    }

    # Build & Publish
    $publishDir = Join-Path $PSScriptRoot "_publish_HelianzServerTemp"
    if (Test-Path $publishDir) { Remove-Item $publishDir -Recurse -Force }

    Write-Host "  Building & publishing..." -ForegroundColor DarkGray
    & $MsBuildPath $projectFile `
        "/t:Clean;Build" `
        /p:Configuration=$Configuration `
        /p:Platform=$Platform `
        /p:DeployOnBuild=true `
        /p:WebPublishMethod=FileSystem `
        "/p:PublishUrl=$publishDir" `
        /p:DeleteExistingFiles=True `
        /m `
        /verbosity:minimal

    if ($LASTEXITCODE -ne 0) { throw "Build FAILED." }

    # Determine actual output: prefer explicit FileSystem publish dir,
    # fall back to PackageTmp produced by the Web Deploy pipeline.
    $packageTmpDir = Join-Path $PSScriptRoot "HelianzServer\obj\$Platform\$Configuration\Package\PackageTmp"
    $packageTmpDir2 = Join-Path $PSScriptRoot "HelianzServer\obj\$Configuration\Package\PackageTmp"
    $sourceFromDir = $null
    if (Test-Path "$publishDir\Web.config") {
        $sourceFromDir = $publishDir
    } elseif (Test-Path "$packageTmpDir\Web.config") {
        Write-Host "  Using PackageTmp output: $packageTmpDir" -ForegroundColor DarkCyan
        $sourceFromDir = $packageTmpDir
    } elseif (Test-Path "$packageTmpDir2\Web.config") {
        Write-Host "  Using PackageTmp output: $packageTmpDir2" -ForegroundColor DarkCyan
        $sourceFromDir = $packageTmpDir2
    } else {
        throw "Could not locate published output. Checked: $publishDir, $packageTmpDir, $packageTmpDir2"
    }

    # Copy to live output so we can reuse it
    if (-not (Test-Path $liveOutputDir)) {
        New-Item -ItemType Directory -Path $liveOutputDir -Force | Out-Null
    }
    Copy-Item -Path "$sourceFromDir\*" -Destination $liveOutputDir -Recurse -Force
    Remove-Item $publishDir -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "  Build complete." -ForegroundColor Green
}

# ---------------------------------------------------------------------------
# Step 2 - Copy to temp output folder
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "[STEP 2/4] Preparing temp server files..." -ForegroundColor Yellow

# If we are already running from inside the output folder (server deployment),
# skip the copy and use the current directory as the output dir.
if ($SkipBuild -and (Find-ServerFiles) -eq $PSScriptRoot) {
    $OutputDir = $PSScriptRoot
    Write-Host "  Already in deployed folder. Skipping copy." -ForegroundColor DarkGray
} else {
    Write-Host "  Temp output: $OutputDir" -ForegroundColor DarkGray

    if (-not (Test-Path $OutputDir)) {
        New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
    } else {
        if (Test-Path (Join-Path $OutputDir "bin")) {
            Remove-Item (Join-Path $OutputDir "bin") -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    Copy-Item -Path "$liveOutputDir\*" -Destination $OutputDir -Recurse -Force

    # --- Restructure: move all server files into HelianzServer\ subfolder.
    #     This way http://HOST:PORT/HelianzServer/ServiceMain.asmx works naturally,
    #     matching the path hardcoded in Helianz client apps.
    $appSubDir = Join-Path $OutputDir "HelianzServer"
    if (-not (Test-Path $appSubDir)) {
        New-Item -ItemType Directory -Path $appSubDir -Force | Out-Null
    }
    Get-ChildItem -Path $OutputDir -Force | Where-Object {
        $_.Name -ne "HelianzServer" -and
        $_.Name -ne "Create-HelianzTempServer.ps1" -and
        $_.Name -ne "Remove-HelianzTempServer.ps1" -and
        $_.Name -ne "wwwroot"
    } | Move-Item -Destination $appSubDir -Force -ErrorAction SilentlyContinue
    Write-Host "  Server files moved into HelianzServer\ subfolder." -ForegroundColor DarkGray

    # --- Make the output folder self-contained: copy this script + teardown script into it ---
    $scriptSelf = $PSCommandPath
    if ($scriptSelf) {
        Copy-Item -Path $scriptSelf -Destination $OutputDir -Force
        Write-Host "  Script copied into output folder (self-contained)." -ForegroundColor DarkGray
    }
    $teardownScript = Join-Path $PSScriptRoot "Remove-HelianzTempServer.ps1"
    if (Test-Path $teardownScript) {
        Copy-Item -Path $teardownScript -Destination $OutputDir -Force
        Write-Host "  Teardown script copied into output folder." -ForegroundColor DarkGray
    }
}

Write-Host "  Files copied." -ForegroundColor Green

# ---------------------------------------------------------------------------
# PrepareOnly mode: build + copy done, stop here
# ---------------------------------------------------------------------------
if ($PrepareOnly) {
    $stopwatch.Stop()
    $elapsedStr = $stopwatch.Elapsed.ToString("hh\:mm\:ss")

    Write-Host ""
    Write-Host "==================================================================" -ForegroundColor Green
    Write-Host "  DEPLOYABLE FOLDER READY (PrepareOnly)" -ForegroundColor Green
    Write-Host "==================================================================" -ForegroundColor Green
    Write-Host "  Time        : $elapsedStr" -ForegroundColor Green
    Write-Host "  Output      : $OutputDir" -ForegroundColor Green
    Write-Host "==================================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "  NEXT: Copy this entire folder to the server:" -ForegroundColor Yellow
    Write-Host "        $OutputDir" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Then on the SERVER (as Administrator), run:" -ForegroundColor Yellow
    Write-Host "        cd C:\path\to\HelianzServerTemp" -ForegroundColor Yellow
    Write-Host "        .\Create-HelianzTempServer.ps1 -SkipBuild" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  This will prompt for DB config and register the IIS site." -ForegroundColor DarkGray
    Write-Host ""
    exit 0
}

# ---------------------------------------------------------------------------
# Step 3 - Configure database connection
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "[STEP 3/4] Configuring database connection..." -ForegroundColor Yellow

$dbConfig = Invoke-ConfigDialog

$configPath = Join-Path $OutputDir "HelianzServerConfig.xml"
Write-ConfigXml -Config $dbConfig -DestinationPath $configPath -ServerPort $Port

Write-Host ""
Write-Host "  Config written to: $configPath" -ForegroundColor Green
Write-Host "  MySQL Host    : $($dbConfig.Host)" -ForegroundColor DarkCyan
Write-Host "  Database      : $($dbConfig.Database)" -ForegroundColor DarkCyan
Write-Host "  User          : $($dbConfig.User)" -ForegroundColor DarkCyan
if ($dbConfig.UserLow) {
    Write-Host "  Low-Priv User : $($dbConfig.UserLow)" -ForegroundColor DarkCyan
}

# ---------------------------------------------------------------------------
# Step 4 - Register in IIS (optional)
# ---------------------------------------------------------------------------
if ($SkipIIS) {
    Write-Host ""
    Write-Host "[STEP 4/4] IIS registration SKIPPED (-SkipIIS)." -ForegroundColor DarkGray
    Write-Host "  Files are ready at: $OutputDir" -ForegroundColor DarkGray
    Write-Host "  To register later, re-run without -SkipIIS as Administrator." -ForegroundColor DarkGray
} else {
    Write-Host ""
    Write-Host "[STEP 4/4] Registering in IIS..." -ForegroundColor Yellow

    Assert-IISReady
    $serviceUrl = Register-TempIISSite `
        -PhysicalPath $OutputDir `
        -SiteName $SiteName `
        -Port $Port `
        -AppPoolName $AppPoolName

    $stopwatch.Stop()
    $elapsedStr = $stopwatch.Elapsed.ToString("hh\:mm\:ss")

    Write-Host ""
    Write-Host "==================================================================" -ForegroundColor Green
    Write-Host "  TEMP SERVER READY" -ForegroundColor Green
    Write-Host "==================================================================" -ForegroundColor Green
    Write-Host "  Time        : $elapsedStr" -ForegroundColor Green
    Write-Host "  IIS Site    : $SiteName" -ForegroundColor Green
    Write-Host "  Port        : $Port" -ForegroundColor Green
    Write-Host "  Output      : $OutputDir" -ForegroundColor Green
    Write-Host "  Database    : $($dbConfig.Database) @ $($dbConfig.Host)" -ForegroundColor Green
    Write-Host "  Endpoint    : $serviceUrl" -ForegroundColor Green
    Write-Host "==================================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Clients connect to: http://YOUR_SERVER_IP:$Port/HelianzServer/ServiceMain.asmx" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  To TEAR DOWN this temp server, run:" -ForegroundColor DarkYellow
    Write-Host "    .\Remove-HelianzTempServer.ps1" -ForegroundColor DarkYellow
    Write-Host ""
    Write-Host "  NOTE: Make sure the database $($dbConfig.Database) exists on" -ForegroundColor DarkYellow
    Write-Host "        $($dbConfig.Host) and has the Helianz schema before clients connect." -ForegroundColor DarkYellow
    Write-Host ""
}
