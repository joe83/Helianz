#Requires -Version 5.1
<#
.SYNOPSIS
	Installs MySQL Community Server (if needed) and creates a fresh Helianz
	database ready for the community 24.3.x application.

.DESCRIPTION
	Steps performed:
	  1. Parse connection settings from HelianzServerConfig.xml
	# 2. Locate mysql.exe / mariadb mysql.exe in PATH or common install paths
	# 3. If MySQL/MariaDB is not found: install via winget (Oracle.MySQL) or chocolatey
	# 4. Ensure the MySQL/MariaDB service is running
	# 5. Drop the existing database (if -Force or user confirms)
	# 6. Create a fresh database with utf8mb4 character set
	# 7. Load baseline schema (packaging/helianzdata/mysql.sql -> v3.4.17.0)
	# 8. Grant full privileges to the configured user (if user != root)
	# 9. Verify the connection works

	On a fresh MySQL install the root password is empty; use -MySqlRootPassword ''
	(the default). After running this script once the password will remain as-is;
	only the *database* is changed.

After the database is created, this script loads the baseline schema from
	'packaging/helianzdata/mysql.sql' (seeds the DB at version 3.4.17.0).
	The Helianz application then automatically upgrades from 3.4.17.0 to
	24.3.45.0 via the ConvertDatabases chain on first startup.

.PARAMETER ConfigPath
	Path to HelianzServerConfig.xml. Defaults to the repo-root copy.

.PARAMETER MySqlRootPassword
	Root password used to connect to MySQL and execute administrative commands.
	Defaults to the password found in the first DatabaseConnection element of
	ConfigPath. Pass an empty string '' for a blank root password (fresh install).

.PARAMETER MySqlPort
	TCP port MySQL listens on. Default: 3306.

.PARAMETER Force
	Drop the existing database without prompting for confirmation.

.PARAMETER SkipInstall
	Do not attempt to install MySQL; fail instead if mysql.exe is not found.

.EXAMPLE
	# Standard fresh install - reads credentials from config, installs MySQL if needed
	.\Setup-HelianzDatabase.ps1

	# Drop and recreate without prompting
	.\Setup-HelianzDatabase.ps1 -Force

	# MySQL already installed with blank root password
	.\Setup-HelianzDatabase.ps1 -MySqlRootPassword '' -Force

	# Run elevated automatically (or use _setup_db.ps1 wrapper)
	Start-Process powershell -Verb RunAs -ArgumentList '-File "Setup-HelianzDatabase.ps1" -Force' -Wait
#>

param(
	[string]$ConfigPath        = "$PSScriptRoot\HelianzServerConfig.xml",
	[string]$MySqlRootPassword = $null,
	[int]   $MySqlPort         = 3306,
	[switch]$Force,
	[switch]$SkipInstall
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Helper: Parse first DatabaseConnection from HelianzServerConfig.xml
# ---------------------------------------------------------------------------
function Get-DbConfig {
	param([string]$XmlPath)

	if (-not (Test-Path $XmlPath)) {
		throw "Config file not found: $XmlPath"
	}
	[xml]$xml = Get-Content $XmlPath -Encoding UTF8
	$conn = $xml.SelectSingleNode('//DatabaseConnection')
	if (-not $conn) {
		throw "No DatabaseConnection element found in: $XmlPath"
	}
	return [PSCustomObject]@{
		Host     = if ($conn.ComputerName) { $conn.ComputerName.Trim() } else { 'localhost' }
		Database = $conn.Database.Trim()
		User     = $conn.User.Trim()
		Password = ($conn.SelectSingleNode('Password').InnerText).Trim()
	}
}

# ---------------------------------------------------------------------------
# Helper: Find mysql.exe binary
# ---------------------------------------------------------------------------
function Find-MySqlExe {
	# 1. Check PATH
	$inPath = Get-Command 'mysql.exe' -ErrorAction SilentlyContinue
	if ($inPath) { return $inPath.Source }

	# 2. Scan common install locations (MySQL 5.7, 8.0, 8.4, 9.x and MariaDB)
	$bases = @(
		"${env:ProgramFiles}\MySQL",
		"${env:ProgramFiles(x86)}\MySQL",
		"${env:SystemDrive}\MySQL",
		"${env:ProgramFiles}\MariaDB*",
		"${env:ProgramFiles(x86)}\MariaDB*"
	)
	foreach ($base in $bases) {
		# Support glob patterns like 'MariaDB*'
		$resolvedBases = Resolve-Path $base -ErrorAction SilentlyContinue
		if (-not $resolvedBases) { continue }
		foreach ($resolved in $resolvedBases) {
			Get-ChildItem -Path $resolved.Path -Directory -ErrorAction SilentlyContinue |
				Sort-Object Name -Descending |
				ForEach-Object {
					$candidate = Join-Path $_.FullName 'bin\mysql.exe'
					if (Test-Path $candidate) { return $candidate }
				}
			# Also check bin/ directly under the resolved path (MariaDB layout)
			$direct = Join-Path $resolved.Path 'bin\mysql.exe'
			if (Test-Path $direct) { return $direct }
		}
	}
	return $null
}

# ---------------------------------------------------------------------------
# Helper: Find mysqladmin.exe (same directory as mysql.exe)
# ---------------------------------------------------------------------------
function Find-MySqlAdmin {
	$mysql = Find-MySqlExe
	if ($mysql) {
		$admin = Join-Path (Split-Path $mysql) 'mysqladmin.exe'
		if (Test-Path $admin) { return $admin }
	}
	return $null
}

# ---------------------------------------------------------------------------
# Helper: Get running MySQL service name
# ---------------------------------------------------------------------------
function Get-MySqlServiceName {
	$services = @('MySQL80', 'MySQL84', 'MySQL57', 'MySQL', 'MySQL56', 'MariaDB')
	foreach ($svc in $services) {
		$s = Get-Service -Name $svc -ErrorAction SilentlyContinue
		if ($s) { return $svc }
	}
	# Fallback: any service whose DisplayName contains MySQL or MariaDB
	$s = Get-Service -ErrorAction SilentlyContinue |
		Where-Object { $_.DisplayName -like '*MySQL*' -or $_.Name -like 'MySQL*' -or
		               $_.DisplayName -like '*MariaDB*' -or $_.Name -like 'MariaDB*' } |
		Select-Object -First 1
	if ($s) { return $s.Name }
	return $null
}

# ---------------------------------------------------------------------------
# Helper: Start MySQL service if stopped
# ---------------------------------------------------------------------------
function Assert-MySqlRunning {
	$svcName = Get-MySqlServiceName
	if (-not $svcName) {
		Write-Host "  [WARN] No MySQL service found. If MySQL was just installed, a system PATH refresh may be needed." -ForegroundColor DarkYellow
		return
	}
	$svc = Get-Service -Name $svcName
	if ($svc.Status -ne 'Running') {
		Write-Host "  Starting MySQL service ($svcName)..." -ForegroundColor DarkCyan
		Start-Service -Name $svcName -ErrorAction Stop
		Start-Sleep -Seconds 3
		$svc.Refresh()
		if ($svc.Status -eq 'Running') {
			Write-Host "  MySQL service started." -ForegroundColor Green
		} else {
			throw "MySQL service '$svcName' failed to start."
		}
	} else {
		Write-Host "  MySQL service ($svcName) is already running." -ForegroundColor DarkGray
	}
}

# ---------------------------------------------------------------------------
# Helper: Install MySQL via winget or chocolatey
# ---------------------------------------------------------------------------
function Install-MySQL {
	# Try winget first
	$winget = Get-Command 'winget.exe' -ErrorAction SilentlyContinue
	if ($winget) {
		Write-Host "  Installing MySQL Community Server via winget..." -ForegroundColor DarkCyan
		Write-Host "  This may take several minutes and open an installer window." -ForegroundColor DarkYellow

		$result = & winget.exe install --id Oracle.MySQL --silent --accept-package-agreements --accept-source-agreements 2>&1
		$result | ForEach-Object { Write-Host "  [winget] $_" -ForegroundColor DarkGray }

		if ($LASTEXITCODE -eq 0 -or $LASTEXITCODE -eq -1978335189) {
			# -1978335189 = WINGET_E_ALREADY_INSTALLED (0x8A150011)
			Write-Host "  MySQL installed (or already present) via winget." -ForegroundColor Green

			# Refresh PATH so mysql.exe is findable in this session
			$env:PATH = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' +
						[System.Environment]::GetEnvironmentVariable('PATH', 'User')
			return
		}
		Write-Host "  [WARN] winget returned exit code $LASTEXITCODE. Trying chocolatey..." -ForegroundColor DarkYellow
	} else {
		Write-Host "  winget not available. Trying chocolatey..." -ForegroundColor DarkYellow
	}

	# Try chocolatey
	$choco = Get-Command 'choco.exe' -ErrorAction SilentlyContinue
	if ($choco) {
		Write-Host "  Installing MySQL via chocolatey..." -ForegroundColor DarkCyan
		$result = & choco.exe install mysql --yes 2>&1
		$result | ForEach-Object { Write-Host "  [choco] $_" -ForegroundColor DarkGray }
		if ($LASTEXITCODE -eq 0) {
			$env:PATH = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' +
						[System.Environment]::GetEnvironmentVariable('PATH', 'User')
			Write-Host "  MySQL installed via chocolatey." -ForegroundColor Green
			return
		}
	}

	# Neither worked
	Write-Host ""
	Write-Host "  ================================================================" -ForegroundColor Red
	Write-Host "  MySQL could not be installed automatically." -ForegroundColor Red
	Write-Host "  Please install MySQL Community Server 8.x manually:" -ForegroundColor Red
	Write-Host "    winget install Oracle.MySQL" -ForegroundColor Yellow
	Write-Host "    -- or --" -ForegroundColor DarkGray
	Write-Host "    Download from https://dev.mysql.com/downloads/mysql/" -ForegroundColor Yellow
	Write-Host "  After installing, re-run this script with -SkipInstall." -ForegroundColor Red
	Write-Host "  ================================================================" -ForegroundColor Red
	throw "MySQL installation failed. Install MySQL manually and re-run this script."
}

# ---------------------------------------------------------------------------
# Helper: Run a SQL statement via mysql.exe command-line
# Returns (ExitCode, stdout+stderr combined)
# ---------------------------------------------------------------------------
function Invoke-MySql {
	param(
		[string]$MySqlExe,
		[string]$DbHost,
		[int]   $Port,
		[string]$User,
		[string]$Password,
		[string]$Sql,
		[string]$Database = '',
		[switch]$IgnoreErrors
	)

	$mysqlArgs = @(
		"--host=$DbHost",
		"--port=$Port",
		"--user=$User",
		"--password=$Password",
		"--connect-timeout=10",
		"--execute=$Sql"
	)
	if (-not [string]::IsNullOrEmpty($Database)) {
		$mysqlArgs += "--database=$Database"
	}

	# Temporarily override ErrorActionPreference so mysql.exe stderr (via 2>&1)
	# does not trigger a terminating error under the script's 'Stop' preference
	$savedEAP = $ErrorActionPreference
	$ErrorActionPreference = 'Continue'
	try {
		$output = & $MySqlExe @mysqlArgs 2>&1 | ForEach-Object { "$_" }
		$exitCode = $LASTEXITCODE
	} finally {
		$ErrorActionPreference = $savedEAP
	}

	if ($exitCode -ne 0 -and -not $IgnoreErrors) {
		$msg = ($output | Out-String).Trim()
		throw "mysql.exe command failed (exit $exitCode): $msg"
	}
	return [PSCustomObject]@{ ExitCode = $exitCode; Output = ($output | Out-String).Trim() }
}

# ---------------------------------------------------------------------------
# Helper: Test that mysql.exe can connect with given credentials
# ---------------------------------------------------------------------------
function Test-MySqlConnection {
	param(
		[string]$MySqlExe,
		[string]$DbHost,
		[int]   $Port,
		[string]$User,
		[string]$Password
	)
	$r = Invoke-MySql -MySqlExe $MySqlExe -DbHost $DbHost -Port $Port `
		-User $User -Password $Password -Sql 'SELECT 1' -IgnoreErrors
	return ($r.ExitCode -eq 0)
}

# ===========================================================================
# Main
# ===========================================================================
$stopwatch = [Diagnostics.Stopwatch]::StartNew()

Write-Host ""
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  Helianz Database Setup" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

# ---------------------------------------------------------------------------
# Step 1 - Read config
# ---------------------------------------------------------------------------
Write-Host "[STEP 1/6] Reading database config from: $ConfigPath" -ForegroundColor Yellow
$cfg = Get-DbConfig -XmlPath $ConfigPath

# If no explicit root password supplied, default to the config password
if ([string]::IsNullOrEmpty($MySqlRootPassword)) {
	$MySqlRootPassword = $cfg.Password
}

Write-Host "  Host     : $($cfg.Host)"     -ForegroundColor DarkGray
Write-Host "  Port     : $MySqlPort"        -ForegroundColor DarkGray
Write-Host "  Database : $($cfg.Database)"  -ForegroundColor DarkGray
Write-Host "  User     : $($cfg.User)"      -ForegroundColor DarkGray
Write-Host ""

# ---------------------------------------------------------------------------
# Step 2 - Locate or install MySQL
# ---------------------------------------------------------------------------
Write-Host "[STEP 2/6] Locating MySQL/MariaDB..." -ForegroundColor Yellow

$mysqlExe = Find-MySqlExe
if ($mysqlExe) {
	Write-Host "  Found mysql.exe: $mysqlExe" -ForegroundColor Green
} else {
	if ($SkipInstall) {
		throw "mysql.exe not found and -SkipInstall was specified. Install MySQL and ensure it is in PATH."
	}
	Write-Host "  mysql.exe not found. Installing MySQL..." -ForegroundColor DarkYellow
	Install-MySQL
	Start-Sleep -Seconds 5  # allow service registration to settle
	$mysqlExe = Find-MySqlExe
	if (-not $mysqlExe) {
		# winget may have installed MySQL but PATH isn't updated in this session yet.
		# Scan for it explicitly one more time after forcing PATH refresh.
		$env:PATH = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' +
					[System.Environment]::GetEnvironmentVariable('PATH', 'User')
		$mysqlExe = Find-MySqlExe
	}
	if (-not $mysqlExe) {
		throw "mysql.exe still not found after installation. " +
			  "Open a new PowerShell window and re-run this script with -SkipInstall, " +
			  "or add the MySQL bin directory to PATH manually."
	}
}

Write-Host ""

# ---------------------------------------------------------------------------
# Step 3 - Ensure MySQL service is running
# ---------------------------------------------------------------------------
Write-Host "[STEP 3/6] Ensuring MySQL/MariaDB service is running..." -ForegroundColor Yellow
Assert-MySqlRunning
Write-Host ""

# ---------------------------------------------------------------------------
# Step 4 - Verify connection  (try config password first, then blank)
# ---------------------------------------------------------------------------
Write-Host "[STEP 4/6] Verifying MySQL/MariaDB connection as root..." -ForegroundColor Yellow

$connectPassword = $MySqlRootPassword
$connectUser     = 'root'

$canConnect = Test-MySqlConnection -MySqlExe $mysqlExe -DbHost $cfg.Host `
	-Port $MySqlPort -User $connectUser -Password $connectPassword

if (-not $canConnect -and $connectPassword -ne '') {
	Write-Host "  Connection failed with configured password. Trying blank password (fresh install)..." -ForegroundColor DarkYellow
	$canConnect = Test-MySqlConnection -MySqlExe $mysqlExe -DbHost $cfg.Host `
		-Port $MySqlPort -User $connectUser -Password ''
	if ($canConnect) {
		Write-Host "  Connected with blank root password." -ForegroundColor Green

		# Set root password to the one in config so the app can connect
		if (-not [string]::IsNullOrEmpty($MySqlRootPassword)) {
			Write-Host "  Setting root password to configured value..." -ForegroundColor DarkCyan
			$alterSql = "ALTER USER 'root'@'localhost' IDENTIFIED BY '$($MySqlRootPassword -replace "'","''")';" +
						" ALTER USER 'root'@'%' IDENTIFIED BY '$($MySqlRootPassword -replace "'","''")' " +
						" IF EXISTS; FLUSH PRIVILEGES;"
			Invoke-MySql -MySqlExe $mysqlExe -DbHost $cfg.Host -Port $MySqlPort `
				-User $connectUser -Password '' -Sql $alterSql -IgnoreErrors | Out-Null
			Write-Host "  Root password set." -ForegroundColor Green
			$connectPassword = $MySqlRootPassword
		}
	}
}

if (-not $canConnect) {
	Write-Host ""
	Write-Host "  ================================================================" -ForegroundColor Red
	Write-Host "  Cannot connect to MySQL as root." -ForegroundColor Red
	Write-Host "  If MySQL was just installed, find the temporary password:" -ForegroundColor Red
	Write-Host "    Get-Content 'C:\ProgramData\MySQL\MySQL Server 8.0\Data\*.err' | Select-String 'temporary'" -ForegroundColor Yellow
	Write-Host "  Then re-run with: -MySqlRootPassword 'the_temp_password'" -ForegroundColor Yellow
	Write-Host "  ================================================================" -ForegroundColor Red
	throw "Cannot connect to MySQL. Check the root password and retry."
}

Write-Host "  MySQL connection OK." -ForegroundColor Green
Write-Host ""

# ---------------------------------------------------------------------------
# Step 5 - Drop (if exists) and recreate the database
# ---------------------------------------------------------------------------
Write-Host "[STEP 5/6] Setting up database '$($cfg.Database)'..." -ForegroundColor Yellow

# Check whether the database exists
$checkSql  = "SELECT COUNT(*) FROM information_schema.SCHEMATA WHERE SCHEMA_NAME='$($cfg.Database)';"
$checkResult = Invoke-MySql -MySqlExe $mysqlExe -DbHost $cfg.Host -Port $MySqlPort `
	-User $connectUser -Password $connectPassword -Sql $checkSql
$dbExists = ($checkResult.Output -match '1')

if ($dbExists) {
	if (-not $Force) {
		Write-Host ""
		Write-Host "  [WARNING] Database '$($cfg.Database)' already exists!" -ForegroundColor DarkYellow
		$answer = Read-Host "  Type 'yes' to DROP it and create a fresh empty database, or anything else to cancel"
		if ($answer.Trim().ToLower() -ne 'yes') {
			Write-Host "  Cancelled. No changes made." -ForegroundColor DarkYellow
			exit 0
		}
	}
	Write-Host "  Dropping existing database: $($cfg.Database)" -ForegroundColor DarkCyan
	Invoke-MySql -MySqlExe $mysqlExe -DbHost $cfg.Host -Port $MySqlPort `
		-User $connectUser -Password $connectPassword `
		-Sql "DROP DATABASE IF EXISTS $($cfg.Database);" | Out-Null
	Write-Host "  Database dropped." -ForegroundColor Green
}

# Create fresh database
Write-Host "  Creating fresh database: $($cfg.Database)" -ForegroundColor DarkCyan
$createSql = "CREATE DATABASE $($cfg.Database) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
Invoke-MySql -MySqlExe $mysqlExe -DbHost $cfg.Host -Port $MySqlPort `
	-User $connectUser -Password $connectPassword -Sql $createSql | Out-Null
Write-Host "  Database created with utf8mb4 character set." -ForegroundColor Green

# Grant privileges if the app user is not root
if ($cfg.User -ne 'root') {
	Write-Host "  Granting privileges to user '$($cfg.User)'@'$($cfg.Host)'..." -ForegroundColor DarkCyan
	$escapedPw = $cfg.Password -replace "'", "''"
	$grantSql  = "CREATE USER IF NOT EXISTS '$($cfg.User)'@'localhost' IDENTIFIED BY '$escapedPw'; " +
				 "CREATE USER IF NOT EXISTS '$($cfg.User)'@'%'         IDENTIFIED BY '$escapedPw'; " +
				 "GRANT ALL PRIVILEGES ON $($cfg.Database).* TO '$($cfg.User)'@'localhost'; " +
				 "GRANT ALL PRIVILEGES ON $($cfg.Database).* TO '$($cfg.User)'@'%'; " +
				 "FLUSH PRIVILEGES;"
	Invoke-MySql -MySqlExe $mysqlExe -DbHost $cfg.Host -Port $MySqlPort `
		-User $connectUser -Password $connectPassword -Sql $grantSql | Out-Null
	Write-Host "  Privileges granted." -ForegroundColor Green
}
# ---------------------------------------------------------------------------
# Step 6 - Load baseline schema SQL
# ---------------------------------------------------------------------------
$baselineSql = Join-Path $PSScriptRoot 'packaging\helianzdata\mysql.sql'
Write-Host ""
Write-Host "[STEP 6/6] Loading baseline schema into '$($cfg.Database)'..." -ForegroundColor Yellow
if (-not (Test-Path $baselineSql)) {
	Write-Host "  [WARN] Baseline SQL not found at: $baselineSql" -ForegroundColor DarkYellow
	Write-Host "  The database was created empty. Helianz cannot auto-initialize from empty." -ForegroundColor DarkYellow
	Write-Host "  You must manually load the baseline schema before starting Helianz." -ForegroundColor DarkYellow
} else {
	Write-Host "  Loading: $baselineSql" -ForegroundColor DarkGray
	# Use pipe (stdin) to feed the SQL file to mysql.exe to avoid command-length limits
	$savedEAP2 = $ErrorActionPreference
	$ErrorActionPreference = 'Continue'
	try {
		$output = Get-Content $baselineSql -Encoding UTF8 -Raw |
			& $mysqlExe `
				"--host=$($cfg.Host)" "--port=$MySqlPort" "--user=$connectUser" `
				"--password=$connectPassword" `
				"--database=$($cfg.Database)" "--connect-timeout=30" 2>&1 |
			ForEach-Object { "$_" }
		$loadExit = $LASTEXITCODE
	} finally {
		$ErrorActionPreference = $savedEAP2
	}
	if ($loadExit -ne 0) {
		$msg = ($output | Out-String).Trim()
		throw "Failed to load baseline schema (exit $loadExit): $msg"
	}
	Write-Host "  Baseline schema loaded (database version set to 3.4.17.0)." -ForegroundColor Green
	Write-Host "  Helianz will upgrade from 3.4.17.0 to 24.3.45.0 automatically on first startup." -ForegroundColor DarkGray
}

Write-Host ""
# Verify the app user can connect to the new database
Write-Host "  Verifying app-user connection ($($cfg.User)) to '$($cfg.Database)'..." -ForegroundColor DarkCyan
$appConnect = Test-MySqlConnection -MySqlExe $mysqlExe -DbHost $cfg.Host `
	-Port $MySqlPort -User $cfg.User -Password $cfg.Password
if ($appConnect) {
	Write-Host "  App user connection verified." -ForegroundColor Green
} else {
	Write-Host "  [WARN] App user could not connect. Check the credentials in HelianzServerConfig.xml." -ForegroundColor DarkYellow
}

$stopwatch.Stop()
Write-Host ""
Write-Host "========================================================" -ForegroundColor Green
Write-Host "  DATABASE SETUP COMPLETE" -ForegroundColor Green
Write-Host "  Time     : $($stopwatch.Elapsed.ToString('hh\:mm\:ss'))" -ForegroundColor Green
Write-Host "  Database : $($cfg.Database) (seeded at v3.4.17.0, ready for app to upgrade)" -ForegroundColor Green
Write-Host "  Host     : $($cfg.Host):$MySqlPort" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  NEXT STEPS:" -ForegroundColor Yellow
Write-Host "  1. Deploy HelianzServer to IIS (run _iis_run.ps1 if not done)." -ForegroundColor DarkGray
Write-Host "  2. Connect the Helianz 24.3.x client to this server." -ForegroundColor DarkGray
Write-Host "  3. The client connects and runs ConvertDatabases from 3.4.17.0 to" -ForegroundColor DarkGray
	Write-Host "     24.3.45.0 automatically (may take a few minutes on first startup)." -ForegroundColor DarkGray
Write-Host ""

