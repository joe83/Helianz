#Requires -Version 5.1
<#
.SYNOPSIS
    Silent installer helper executed by the Inno Setup installer.
    Configures MySQL, IIS, Windows Firewall, and writes the OpenDental
    Server config. All output captured to %TEMP%\OpenDentalServer-install.log.

.NOTES
    Hardcoded defaults (MySQL is localhost-only - no network exposure):
      MySQL root user : root
      MySQL password  : opendental
      MySQL database  : opendental
      Middle-tier port: 9390
      IIS app name    : OpenDentalServer
#>
param(
    [string]$InstallDir      = $PSScriptRoot,
    [string]$SchemaFile      = '',
    [bool]  $AddFirewallRule = $true,
    [ValidateSet('All','MySQL','StartMySQL','ConfigMySQL','Firewall','IIS','Config')]
    [string]$Step            = 'All'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Continue'   # Each step function handles its own errors

# ---------------------------------------------------------------------------
# Log everything to a file the user can inspect if something goes wrong
# ---------------------------------------------------------------------------
$LogFile = Join-Path $env:TEMP 'OpenDentalServer-install.log'
Start-Transcript -Path $LogFile -Append | Out-Null  # Append so all steps share one log per session

# ---------------------------------------------------------------------------
# Hardcoded defaults
# MySQL is bound to 127.0.0.1 - password is only a secondary control
# ---------------------------------------------------------------------------
$MYSQL_HOST     = '127.0.0.1'
$MYSQL_PORT     = 3306
$MYSQL_DATABASE = 'opendental'
$MYSQL_USER     = 'root'
$MYSQL_PASSWORD = 'opendental'
$IIS_SITE       = 'Default Web Site'
$IIS_APP_NAME   = 'OpenDentalServer'
$APP_POOL_NAME  = 'OpenDentalServerPool'
$SERVER_PORT    = 9390

$sw = [Diagnostics.Stopwatch]::StartNew()

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  OpenDentalServer Installer Helper" -ForegroundColor Cyan
Write-Host "  Install Dir : $InstallDir" -ForegroundColor Cyan
Write-Host "  Log File    : $LogFile" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

# ===========================================================================
# Helper functions
# ===========================================================================

function Find-MySqlExe {
    $inPath = Get-Command 'mysql.exe' -ErrorAction SilentlyContinue
    if ($inPath) { return $inPath.Source }
    $bases = @(
        "${env:ProgramFiles}\MySQL",
        "${env:ProgramFiles(x86)}\MySQL",
        "${env:SystemDrive}\MySQL",
        "${env:ProgramFiles}\MariaDB*"
    )
    foreach ($base in $bases) {
        foreach ($resolved in (Resolve-Path $base -ErrorAction SilentlyContinue)) {
            Get-ChildItem -Path $resolved.Path -Directory -ErrorAction SilentlyContinue |
                Sort-Object Name -Descending | ForEach-Object {
                    $c = Join-Path $_.FullName 'bin\mysql.exe'
                    if (Test-Path $c) { return $c }
                }
            $c = Join-Path $resolved.Path 'bin\mysql.exe'
            if (Test-Path $c) { return $c }
        }
    }
    return $null
}

function Find-MyIni {
    $candidates = @(
        "${env:ProgramData}\MySQL\MySQL Server 9.0\my.ini",
        "${env:ProgramData}\MySQL\MySQL Server 8.4\my.ini",
        "${env:ProgramData}\MySQL\MySQL Server 8.0\my.ini",
        "${env:ProgramData}\MySQL\MySQL Server 5.7\my.ini",
        'C:\MySQL\my.ini',
        "${env:ProgramFiles}\MySQL\MySQL Server 9.0\my.ini",
        "${env:ProgramFiles}\MySQL\MySQL Server 8.4\my.ini",
        "${env:ProgramFiles}\MySQL\MySQL Server 8.0\my.ini"
    )
    foreach ($c in $candidates) {
        if (Test-Path $c) { return $c }
    }
    # Dynamic scan
    foreach ($resolved in (Resolve-Path "${env:ProgramData}\MySQL\*" -ErrorAction SilentlyContinue)) {
        $c = Join-Path $resolved.Path 'my.ini'
        if (Test-Path $c) { return $c }
    }
    return $null
}

function Get-MySqlServiceName {
    $names = @('MySQL90','MySQL84','MySQL80','MySQL57','MySQL','MariaDB')
    foreach ($n in $names) {
        if (Get-Service -Name $n -ErrorAction SilentlyContinue) { return $n }
    }
    $svc = Get-Service -ErrorAction SilentlyContinue |
        Where-Object { $_.DisplayName -like '*MySQL*' -or $_.DisplayName -like '*MariaDB*' } |
        Select-Object -First 1
    return if ($svc) { $svc.Name } else { $null }
}

function Invoke-MySql {
    param([string]$Exe, [string]$User, [string]$Password, [string]$Sql,
          [string]$Database = '', [switch]$IgnoreErrors)
    $args = @("--host=$MYSQL_HOST","--port=$MYSQL_PORT","--user=$User",
              "--password=$Password","--connect-timeout=15","--execute=$Sql")
    if ($Database) { $args += "--database=$Database" }
    $savedEAP = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        $out = & $Exe @args 2>&1 | ForEach-Object { "$_" }
        $rc  = $LASTEXITCODE
    } finally { $ErrorActionPreference = $savedEAP }
    if ($rc -ne 0 -and -not $IgnoreErrors) {
        throw "mysql.exe failed (exit $rc): $($out | Out-String)"
    }
    return [PSCustomObject]@{ ExitCode = $rc; Output = ($out | Out-String).Trim() }
}

function Test-MySqlConn {
    param([string]$Exe, [string]$User, [string]$Password)
    $r = Invoke-MySql -Exe $Exe -User $User -Password $Password -Sql 'SELECT 1' -IgnoreErrors
    return ($r.ExitCode -eq 0)
}

# ===========================================================================
# STEP FUNCTIONS  (each returns $true on success / $false on failure)
# ===========================================================================

function Write-StepHeader {
    param([string]$Text)
    Write-Host ''
    Write-Host ('=' * 62) -ForegroundColor Cyan
    Write-Host "  $Text" -ForegroundColor Cyan
    Write-Host ('=' * 62) -ForegroundColor Cyan
}

function Write-Ok   { param([string]$Msg) Write-Host "  [OK  ] $Msg" -ForegroundColor Green }
function Write-Fail { param([string]$Msg) Write-Host "  [FAIL] $Msg" -ForegroundColor Red }
function Write-Warn { param([string]$Msg) Write-Host "  [WARN] $Msg" -ForegroundColor DarkYellow }
function Write-Info { param([string]$Msg) Write-Host "  [INFO] $Msg" -ForegroundColor DarkGray }

# ---------------------------------------------------------------------------
# Step 1: Locate or install MySQL
# ---------------------------------------------------------------------------
function Invoke-StepMySQL {
    Write-StepHeader 'STEP 1 of 6 — Install / Locate MySQL'

    $exe = Find-MySqlExe
    if ($exe) { Write-Ok "mysql.exe found: $exe"; return $true }

    Write-Host '  mysql.exe not found. Installing via winget...' -ForegroundColor Yellow
    $winget = Get-Command 'winget.exe' -ErrorAction SilentlyContinue
    if (-not $winget) {
        Write-Fail 'winget.exe not available. Install MySQL Community Server 8 manually then re-run.'
        return $false
    }

    Write-Host '  Running: winget install Oracle.MySQL ...' -ForegroundColor DarkCyan
    & winget.exe install --id Oracle.MySQL --silent --accept-package-agreements --accept-source-agreements 2>&1 |
        ForEach-Object { Write-Host "    $_" -ForegroundColor DarkGray }

    # 0 = installed  -1978335189 = already installed
    if ($LASTEXITCODE -notin @(0, -1978335189)) {
        Write-Fail "winget exit code $LASTEXITCODE — check output above"
        return $false
    }

    $env:PATH = [System.Environment]::GetEnvironmentVariable('PATH','Machine') + ';' +
                [System.Environment]::GetEnvironmentVariable('PATH','User')
    Start-Sleep -Seconds 5
    $exe = Find-MySqlExe
    if ($exe) { Write-Ok "MySQL installed and located: $exe"; return $true }

    Write-Fail 'mysql.exe still not found after install. A reboot may be needed.'
    return $false
}

# ---------------------------------------------------------------------------
# Step 2: Start MySQL service
# ---------------------------------------------------------------------------
function Invoke-StepStartMySQL {
    Write-StepHeader 'STEP 2 of 6 — Start MySQL Service'

    $svcName = Get-MySqlServiceName
    if (-not $svcName) { Write-Warn 'No MySQL service found. May need a reboot.'; return $false }

    $svc = Get-Service -Name $svcName
    if ($svc.Status -eq 'Running') { Write-Ok "Service '$svcName' is already running."; return $true }

    Write-Host "  Starting service: $svcName ..." -ForegroundColor DarkCyan
    Start-Service -Name $svcName -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 3
    $svc.Refresh()
    if ($svc.Status -eq 'Running') { Write-Ok "Service '$svcName' started."; return $true }

    Write-Fail "Failed to start service '$svcName'."
    return $false
}

# ---------------------------------------------------------------------------
# Step 3: Configure MySQL (bind-address, root password, create database)
# ---------------------------------------------------------------------------
function Invoke-StepConfigMySQL {
    Write-StepHeader 'STEP 3 of 6 — Configure MySQL (bind-address, password, database)'

    $exe = Find-MySqlExe
    if (-not $exe) { Write-Fail 'mysql.exe not found. Run Step 1 first.'; return $false }

    # Patch my.ini – bind MySQL to localhost only
    $myIni = Find-MyIni
    if ($myIni) {
        Write-Host "  Patching: $myIni" -ForegroundColor DarkCyan
        $content = Get-Content $myIni -Raw
        if ($content -notmatch 'bind-address\s*=') {
            $content = $content -replace '(\[mysqld\][^\[]*)', "`$1`nbind-address = 127.0.0.1`n"
            Set-Content -Path $myIni -Value $content -Encoding UTF8
            Write-Ok 'bind-address = 127.0.0.1 added.'
        } elseif ($content -match 'bind-address\s*=\s*0\.0\.0\.0') {
            $content = $content -replace 'bind-address\s*=\s*0\.0\.0\.0', 'bind-address = 127.0.0.1'
            Set-Content -Path $myIni -Value $content -Encoding UTF8
            Write-Ok 'bind-address updated to 127.0.0.1.'
        } else {
            Write-Ok 'bind-address already configured.'
        }
        $svcName = Get-MySqlServiceName
        if ($svcName) {
            Write-Host '  Restarting MySQL to apply bind-address...' -ForegroundColor DarkCyan
            Restart-Service -Name $svcName -Force -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 5
            Write-Ok 'MySQL restarted.'
        }
    } else {
        Write-Warn 'my.ini not found. MySQL may accept connections on all interfaces.'
    }

    # Determine root password (try configured value, then blank for fresh install)
    $connectPwd = $MYSQL_PASSWORD
    if (-not (Test-MySqlConn -Exe $exe -User $MYSQL_USER -Password $connectPwd)) {
        Write-Host '  Trying blank password (fresh install)...' -ForegroundColor DarkGray
        if (Test-MySqlConn -Exe $exe -User $MYSQL_USER -Password '') {
            $escapedPwd = $MYSQL_PASSWORD -replace "'", "''"
            Invoke-MySql -Exe $exe -User $MYSQL_USER -Password '' `
                -Sql "ALTER USER 'root'@'localhost' IDENTIFIED BY '$escapedPwd'; FLUSH PRIVILEGES;" `
                -IgnoreErrors | Out-Null
            Write-Ok 'Root password set.'
            $connectPwd = $MYSQL_PASSWORD
        } else {
            Write-Fail 'Cannot connect as root (wrong password or MySQL not running).'
            return $false
        }
    } else {
        Write-Ok 'MySQL connection verified.'
    }

    # Create database if it does not exist
    $chk = Invoke-MySql -Exe $exe -User $MYSQL_USER -Password $connectPwd `
        -Sql "SELECT COUNT(*) FROM information_schema.SCHEMATA WHERE SCHEMA_NAME='$MYSQL_DATABASE';" `
        -IgnoreErrors
    if ($chk.Output -notmatch '1') {
        Invoke-MySql -Exe $exe -User $MYSQL_USER -Password $connectPwd `
            -Sql "CREATE DATABASE $MYSQL_DATABASE CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" | Out-Null
        Write-Ok "Database '$MYSQL_DATABASE' created."

        if ($SchemaFile -and (Test-Path $SchemaFile)) {
            Write-Host '  Loading baseline schema (may take a moment)...' -ForegroundColor DarkCyan
            $savedEAP = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
            & $exe "--host=$MYSQL_HOST" "--port=$MYSQL_PORT" `
                "--user=$MYSQL_USER" "--password=$connectPwd" `
                "--database=$MYSQL_DATABASE" "--execute=source $SchemaFile" 2>&1 |
                ForEach-Object { Write-Host "    [schema] $_" -ForegroundColor DarkGray }
            $ErrorActionPreference = $savedEAP
            Write-Ok 'Schema loaded.'
        } else {
            Write-Info 'No schema file — OpenDental will create tables on first launch.'
        }
    } else {
        Write-Ok "Database '$MYSQL_DATABASE' already exists."
    }
    return $true
}

# ---------------------------------------------------------------------------
# Step 4: Windows Firewall rule
# ---------------------------------------------------------------------------
function Invoke-StepFirewall {
    Write-StepHeader 'STEP 4 of 6 — Windows Firewall Rule'

    if (-not $AddFirewallRule) { Write-Info 'Skipped (user opted out).'; return $true }

    $ruleName = 'Block MySQL 3306 (OpenDental)'
    if (Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue) {
        Write-Ok "Rule already exists: '$ruleName'"
        return $true
    }
    try {
        New-NetFirewallRule -DisplayName $ruleName `
            -Description 'Blocks external access to MySQL. OpenDentalServer uses localhost only.' `
            -Direction Inbound -Protocol TCP -LocalPort 3306 `
            -Action Block -Profile Any -ErrorAction Stop | Out-Null
        Write-Ok 'Firewall rule added: block inbound TCP:3306.'
        return $true
    } catch {
        Write-Fail "Firewall rule failed: $_"
        return $false
    }
}

# ---------------------------------------------------------------------------
# Step 5: Configure IIS (app pool + web application)
# ---------------------------------------------------------------------------
function Invoke-StepIIS {
    Write-StepHeader 'STEP 5 of 6 — Register in IIS'

    $os = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
    if ($os -and ($os.ProductType -ne 1)) {
        # Windows Server
        $features = @('Web-Server','Web-WebServer','Web-Common-Http','Web-Asp-Net45',
                      'Web-ISAPI-Ext','Web-ISAPI-Filter','Web-Mgmt-Console','Web-Scripting-Tools')
        Import-Module ServerManager -ErrorAction SilentlyContinue
        Add-WindowsFeature -Name $features -IncludeManagementTools -ErrorAction SilentlyContinue | Out-Null
        Write-Ok 'Windows Server IIS features enabled.'
    } else {
        # Windows Desktop
        $features = @('IIS-WebServerRole','IIS-WebServer','IIS-CommonHttpFeatures',
                      'IIS-DefaultDocument','IIS-StaticContent','IIS-HttpErrors','IIS-HttpLogging',
                      'IIS-ApplicationDevelopment','IIS-ISAPIExtensions','IIS-ISAPIFilter',
                      'IIS-ASPNET45','IIS-NetFxExtensibility45',
                      'IIS-ManagementConsole','IIS-ManagementScriptingTools')
        foreach ($f in $features) {
            $state = Get-WindowsOptionalFeature -Online -FeatureName $f -ErrorAction SilentlyContinue
            if ($state -and $state.State -ne 'Enabled') {
                Write-Host "    Enabling: $f ..." -ForegroundColor DarkCyan
                Enable-WindowsOptionalFeature -Online -FeatureName $f -All -NoRestart -ErrorAction SilentlyContinue | Out-Null
            }
        }
        Write-Ok 'IIS Desktop features ready.'
    }

    # Load WebAdministration
    if (-not (Get-Module WebAdministration -ErrorAction SilentlyContinue)) {
        Import-Module WebAdministration -ErrorAction SilentlyContinue
    }
    if (-not (Get-Module WebAdministration -ErrorAction SilentlyContinue)) {
        Write-Fail 'WebAdministration module not available (IIS may not be installed).'
        return $false
    }
    Write-Ok 'WebAdministration module loaded.'

    $appcmd = "$env:SystemRoot\System32\inetsrv\appcmd.exe"
    if (-not (Test-Path $appcmd)) { Write-Fail 'appcmd.exe not found — IIS may be incomplete.'; return $false }

    # App pool
    if (-not (Test-Path "IIS:\AppPools\$APP_POOL_NAME")) {
        New-WebAppPool -Name $APP_POOL_NAME | Out-Null
        Write-Ok "App pool created: $APP_POOL_NAME"
    } else {
        Write-Ok "App pool exists: $APP_POOL_NAME"
    }
    $pool = Get-Item "IIS:\AppPools\$APP_POOL_NAME"
    $pool.managedRuntimeVersion    = 'v4.0'
    $pool.managedPipelineMode      = 'Integrated'
    $pool.startMode                = 'AlwaysRunning'
    $pool.enable32BitAppOnWin64    = $true
    $pool.processModel.idleTimeout = [TimeSpan]::Zero
    $pool | Set-Item
    Write-Ok 'App pool: .NET v4.0 | Integrated | 32-bit | AlwaysRunning.'

    # Web application
    & $appcmd delete app "$IIS_SITE/$IIS_APP_NAME" 2>&1 | Out-Null
    $addOut = & $appcmd add app /site.name:"$IIS_SITE" /path:"/$IIS_APP_NAME" /physicalPath:"$InstallDir" 2>&1
    if ($LASTEXITCODE -ne 0) { Write-Fail "appcmd add app failed: $addOut"; return $false }
    & $appcmd set app "$IIS_SITE/$IIS_APP_NAME" /applicationPool:"$APP_POOL_NAME" 2>&1 | Out-Null
    Write-Ok "Web app registered: /$IIS_APP_NAME  ->  $InstallDir"

    # Start pool + W3SVC
    $poolState = Get-WebAppPoolState -Name $APP_POOL_NAME -ErrorAction SilentlyContinue
    if ($poolState -and $poolState.Value -ne 'Started') {
        Start-WebAppPool -Name $APP_POOL_NAME -ErrorAction SilentlyContinue
    }
    Set-Service -Name W3SVC -StartupType Automatic -ErrorAction SilentlyContinue
    Start-Service -Name W3SVC -ErrorAction SilentlyContinue
    Write-Ok 'IIS (W3SVC) started.'
    return $true
}

# ---------------------------------------------------------------------------
# Step 6: Write OpenDentServerConfig.xml
# ---------------------------------------------------------------------------
function Invoke-StepConfig {
    Write-StepHeader 'STEP 6 of 6 — Write OpenDentServerConfig.xml'

    $configPath = Join-Path $InstallDir 'OpenDentServerConfig.xml'
    $esc = { param($s) [System.Security.SecurityElement]::Escape($s) }
    $xml = @"
<?xml version="1.0"?>
<ConnectionSettings>
	<ServerPort>$SERVER_PORT</ServerPort>
	<DatabaseConnection>
		<ComputerName>$(& $esc $MYSQL_HOST)</ComputerName>
		<Database>$(& $esc $MYSQL_DATABASE)</Database>
		<User>$(& $esc $MYSQL_USER)</User>
		<Password>$(& $esc $MYSQL_PASSWORD)</Password>
		<UserLow>$(& $esc $MYSQL_USER)</UserLow>
		<PasswordLow>$(& $esc $MYSQL_PASSWORD)</PasswordLow>
	</DatabaseConnection>
</ConnectionSettings>
"@
    try {
        Set-Content -Path $configPath -Value $xml -Encoding UTF8
        Write-Ok "Config written: $configPath"
        return $true
    } catch {
        Write-Fail "Failed to write config: $_"
        return $false
    }
}

# ===========================================================================
# MAIN EXECUTION
# ===========================================================================

Write-Host ''
Write-Host ('=' * 62) -ForegroundColor Cyan
Write-Host '  OpenDentalServer Setup Helper' -ForegroundColor Cyan
Write-Host "  Step    : $Step" -ForegroundColor Cyan
Write-Host "  Dir     : $InstallDir" -ForegroundColor Cyan
Write-Host "  Log     : $LogFile" -ForegroundColor Cyan
Write-Host ('=' * 62) -ForegroundColor Cyan

$results = [ordered]@{}
switch ($Step) {
    'All' {
        $results['MySQL']        = Invoke-StepMySQL
        $results['StartMySQL']   = Invoke-StepStartMySQL
        $results['ConfigMySQL']  = Invoke-StepConfigMySQL
        $results['Firewall']     = Invoke-StepFirewall
        $results['IIS']          = Invoke-StepIIS
        $results['Config']       = Invoke-StepConfig
    }
    'MySQL'        { $results['MySQL']        = Invoke-StepMySQL }
    'StartMySQL'   { $results['StartMySQL']   = Invoke-StepStartMySQL }
    'ConfigMySQL'  { $results['ConfigMySQL']  = Invoke-StepConfigMySQL }
    'Firewall'     { $results['Firewall']     = Invoke-StepFirewall }
    'IIS'          { $results['IIS']          = Invoke-StepIIS }
    'Config'       { $results['Config']       = Invoke-StepConfig }
}

$sw.Stop()
$anyFailed = $results.Values -contains $false

Write-Host ''
Write-Host ('=' * 62) -ForegroundColor $(if ($anyFailed) { 'DarkYellow' } else { 'Green' })
Write-Host ('  RESULTS  (' + $sw.Elapsed.ToString('mm\:ss') + ')') -ForegroundColor $(if ($anyFailed) { 'DarkYellow' } else { 'Green' })
Write-Host ('=' * 62) -ForegroundColor $(if ($anyFailed) { 'DarkYellow' } else { 'Green' })
foreach ($k in $results.Keys) {
    $ok  = $results[$k]
    $ico = if ($ok) { '[OK  ]' } else { '[FAIL]' }
    $col = if ($ok) { 'Green' } else { 'Red' }
    Write-Host "    $ico  $k" -ForegroundColor $col
}
if ($Step -eq 'All' -and -not $anyFailed) {
    Write-Host ''
    Write-Host '  Endpoint: http://localhost/OpenDentalServer/ServiceMain.asmx' -ForegroundColor Cyan
}
Write-Host ('=' * 62) -ForegroundColor $(if ($anyFailed) { 'DarkYellow' } else { 'Green' })
Write-Host ''

Stop-Transcript | Out-Null
exit $(if ($anyFailed) { 1 } else { 0 })

