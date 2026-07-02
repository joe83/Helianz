#Requires -Version 5.1
<#
.SYNOPSIS
	Complete Cdental → Helianz database migration script.
	
.DESCRIPTION
	Performs a full production upgrade from Cdental (OD 11.0.36) to Helianz (OD 24.3.49).
	Steps:
	  1. Backup the cdental source database
	  2. Drop and recreate the helianz target database
	  3. Import cdental schema + data into helianz
	  4. Update FreeDentalConfig.xml to point to helianz
	  5. [MANUAL] Launch Helianz app once to trigger auto schema upgrade (11→24)
	  6. [MANUAL] Close Helianz after upgrade completes
	  7. Apply post-upgrade fixes (groups, permissions, branding, usergroupattach)
	  8. Verify the result

.PARAMETER MySqlUser
	MySQL root user. Default: root

.PARAMETER MySqlPassword
	MySQL root password. Default: read from FreeDentalConfig.xml

.PARAMETER MySqlHost
	MySQL host. Default: localhost

.PARAMETER MySqlBin
	Path to MariaDB/MySQL bin directory. Default: auto-detect

.PARAMETER SourceDb
	Source database name. Default: cdental

.PARAMETER TargetDb
	Target database name. Default: helianz

.PARAMETER BackupDir
	Directory to store backups. Default: script directory

.PARAMETER ConfigPath
	Path to FreeDentalConfig.xml. Default: repo root

.PARAMETER SqlScriptPath
	Path to Upgrade-HelianzComplete.sql. Default: beside this script

.PARAMETER SkipBackup
	Skip the source database backup step (dangerous!)

.PARAMETER SkipPostFixes
	Skip the post-upgrade SQL fixes (for testing)

.PARAMETER OnlyPostFixes
	Only run the post-upgrade fixes (assumes import + app upgrade already done)

.EXAMPLE
	# Full production upgrade
	.\Migrate-CdentalToHelianz.ps1

	# Only apply post-upgrade fixes to an already-upgraded database
	.\Migrate-CdentalToHelianz.ps1 -OnlyPostFixes

	# Custom database names
	.\Migrate-CdentalToHelianz.ps1 -SourceDb cdental_live -TargetDb helianz_new
#>

[CmdletBinding()]
param(
	[string]$MySqlUser = "root",
	[string]$MySqlPassword,
	[string]$MySqlHost = "localhost",
	[string]$MySqlBin,
	[string]$SourceDb = "cdental",
	[string]$TargetDb = "helianz",
	[string]$BackupDir,
	[string]$ConfigPath,
	[string]$SqlScriptPath,
	[switch]$SkipBackup,
	[switch]$SkipPostFixes,
	[switch]$OnlyPostFixes
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $ScriptDir) { $ScriptDir = Get-Location }

# ============================================================================
# 1. RESOLVE PATHS & CREDENTIALS
# ============================================================================
if (-not $BackupDir) {
	$BackupDir = Join-Path $ScriptDir "Backups"
}
if (-not (Test-Path $BackupDir)) {
	New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
}

if (-not $ConfigPath) {
	$RepoRoot = Split-Path -Parent $ScriptDir
	$ConfigPath = Join-Path $RepoRoot "FreeDentalConfig.xml"
}

if (-not $SqlScriptPath) {
	$SqlScriptPath = Join-Path $ScriptDir "Upgrade-HelianzComplete.sql"
}

if (-not $MySqlPassword) {
	# Try to read password from FreeDentalConfig.xml
	if (Test-Path $ConfigPath) {
		[xml]$config = Get-Content $ConfigPath
		$MySqlPassword = $config.ConnectionSettings.DatabaseConnection.Password
	}
	if (-not $MySqlPassword) {
		$MySqlPassword = Read-Host "Enter MySQL root password" -AsSecureString
		$MySqlPassword = [System.Net.NetworkCredential]::new("", $MySqlPassword).Password
	}
}

# Find mysql.exe
if (-not $MySqlBin) {
	$mysqlExe = (Get-Command "mysql.exe" -ErrorAction SilentlyContinue).Source
	if (-not $mysqlExe) {
		$searchPaths = @(
			"C:\Program Files\MariaDB 10.5\bin\mysql.exe",
			"C:\Program Files\MariaDB 10.6\bin\mysql.exe",
			"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe",
			"C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql.exe"
		)
		foreach ($p in $searchPaths) {
			if (Test-Path $p) {
				$mysqlExe = $p
				break
			}
		}
	}
	if (-not $mysqlExe) {
		throw "mysql.exe not found. Specify -MySqlBin or install MySQL/MariaDB."
	}
	$MySqlBin = Split-Path -Parent $mysqlExe
}

$mysqlExe = Join-Path $MySqlBin "mysql.exe"
$mysqldumpExe = Join-Path $MySqlBin "mysqldump.exe"

if (-not (Test-Path $mysqlExe)) {
	throw "mysql.exe not found at: $mysqlExe"
}
if (-not (Test-Path $mysqldumpExe)) {
	throw "mysqldump.exe not found at: $mysqldumpExe"
}

$mysqlArgs = @("-u", $MySqlUser, "--password=$MySqlPassword", "-h", $MySqlHost)
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Cdental → Helianz Migration Tool" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Source DB : $SourceDb"
Write-Host "Target DB : $TargetDb"
Write-Host "MySQL Bin : $MySqlBin"
Write-Host "Backup Dir: $BackupDir"
Write-Host "Config    : $ConfigPath"
Write-Host ""

# ============================================================================
# 2. VERIFY SOURCE DATABASE EXISTS (skip if --OnlyPostFixes)
# ============================================================================
if (-not $OnlyPostFixes) {
	Write-Host "[1/6] Verifying source database '$SourceDb'..." -ForegroundColor Yellow
	$dbList = & $mysqlExe @mysqlArgs -e "SHOW DATABASES;" 2>&1
	if ($dbList -notmatch $SourceDb) {
		throw "Source database '$SourceDb' not found. Available databases:`n$dbList"
	}
	Write-Host "       Source database '$SourceDb' exists." -ForegroundColor Green
}
else {
	Write-Host "[1/6] Skipping source check (--OnlyPostFixes)." -ForegroundColor Yellow
}

# ============================================================================
# 3. BACKUP SOURCE DATABASE
# ============================================================================
if (-not $SkipBackup -and -not $OnlyPostFixes) {
	Write-Host "[2/6] Backing up '$SourceDb'..." -ForegroundColor Yellow
	$sourceBackup = Join-Path $BackupDir "${SourceDb}_backup_${timestamp}.sql"
	& $mysqldumpExe @mysqlArgs --single-transaction --routines --triggers --events $SourceDb 2>&1 | Out-File -FilePath $sourceBackup -Encoding UTF8
	if ($LASTEXITCODE -ne 0) {
		throw "Source backup failed!"
	}
	$backupSize = (Get-Item $sourceBackup).Length / 1MB
	Write-Host "       Backed up to: $sourceBackup ($([math]::Round($backupSize,1)) MB)" -ForegroundColor Green
}
elseif ($OnlyPostFixes) {
	Write-Host "[2/6] Skipping backup (--OnlyPostFixes)." -ForegroundColor Yellow
}
else {
	Write-Host "[2/6] Skipping backup (--SkipBackup). DANGEROUS!" -ForegroundColor Red
}

# ============================================================================
# 4. BACKUP TARGET (if exists) + DROP + CREATE + IMPORT
# ============================================================================
if (-not $OnlyPostFixes) {
	Write-Host "[3/6] Preparing target database '$TargetDb'..." -ForegroundColor Yellow
	
	# Backup existing target if it has data
	$targetExists = & $mysqlExe @mysqlArgs -e "SHOW DATABASES LIKE '$TargetDb';" 2>&1
	if ($targetExists -match $TargetDb) {
		$targetBackup = Join-Path $BackupDir "${TargetDb}_premigrate_${timestamp}.sql"
		Write-Host "       Backing up existing '$TargetDb' to: $targetBackup" -ForegroundColor Yellow
		& $mysqldumpExe @mysqlArgs --single-transaction --routines --triggers $TargetDb 2>&1 | Out-File -FilePath $targetBackup -Encoding UTF8
	}
	
	Write-Host "       Dropping '$TargetDb' (if exists)..." -ForegroundColor Yellow
	& $mysqlExe @mysqlArgs -e "DROP DATABASE IF EXISTS $TargetDb; CREATE DATABASE $TargetDb CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;" 2>&1
	if ($LASTEXITCODE -ne 0) {
		throw "Failed to recreate database!"
	}
	Write-Host "       Target database '$TargetDb' created." -ForegroundColor Green

	# Import source data into target
	Write-Host "[4/6] Importing '$SourceDb' data into '$TargetDb'..." -ForegroundColor Yellow
	& $mysqldumpExe @mysqlArgs --skip-add-drop-table --skip-add-locks --single-transaction --routines --triggers --events $SourceDb 2>&1 | & $mysqlExe @mysqlArgs $TargetDb 2>&1
	if ($LASTEXITCODE -ne 0) {
		throw "Data import failed!"
	}
	Write-Host "       Data imported successfully." -ForegroundColor Green
}
else {
	Write-Host "[3/6] Skipping import (--OnlyPostFixes)." -ForegroundColor Yellow
	Write-Host "[4/6] Skipping import (--OnlyPostFixes)." -ForegroundColor Yellow
}

# ============================================================================
# 5. UPDATE CONFIG + INSTRUCTIONS FOR APP UPGRADE
# ============================================================================
if (-not $OnlyPostFixes) {
	Write-Host "[5/6] Updating configuration..." -ForegroundColor Yellow
	
	# Update FreeDentalConfig.xml
	if (Test-Path $ConfigPath) {
		[xml]$configXml = Get-Content $ConfigPath
		$configXml.ConnectionSettings.DatabaseConnection.Database = $TargetDb
		$configXml.ConnectionSettings.ServerConnection.Database = $TargetDb
		$configXml.Save($ConfigPath)
		Write-Host "       FreeDentalConfig.xml updated to use database '$TargetDb'." -ForegroundColor Green
	}

	# Verify DB version
	$dbVersion = & $mysqlExe @mysqlArgs $TargetDb -e "SELECT ValueString FROM preference WHERE PrefName='DataBaseVersion';" 2>&1
	Write-Host "       Database version: $dbVersion" -ForegroundColor Green
	
	Write-Host ""
	Write-Host "========================================" -ForegroundColor Cyan
	Write-Host "  MANUAL STEP REQUIRED" -ForegroundColor Yellow
	Write-Host "========================================" -ForegroundColor Cyan
	Write-Host ""
	Write-Host "  1. Launch Helianz.exe" -ForegroundColor White
	Write-Host "  2. Wait for the automatic database upgrade to complete" -ForegroundColor White
	Write-Host "     (converts from 11.0.36 → 24.3.49, may take several minutes)" -ForegroundColor White
	Write-Host "  3. Close Helianz after the main window appears" -ForegroundColor White
	Write-Host "  4. Re-run this script with -OnlyPostFixes to apply the fixes" -ForegroundColor White
	Write-Host ""
	Write-Host "  Command: .\Migrate-CdentalToHelianz.ps1 -OnlyPostFixes" -ForegroundColor Green
	Write-Host ""
	Write-Host "  Or press Enter to apply post-upgrade fixes NOW" -ForegroundColor Yellow
	Write-Host "  (only if you've already run the app upgrade)" -ForegroundColor Yellow
	
	$response = Read-Host "  Apply post-fixes now? (y/N)"
	if ($response -ne "y" -and $response -ne "Y") {
		Write-Host "Exiting. Re-run with -OnlyPostFixes after the app upgrade." -ForegroundColor Cyan
		exit 0
	}
}

# ============================================================================
# 6. APPLY POST-UPGRADE FIXES
# ============================================================================
Write-Host "[6/6] Applying post-upgrade fixes..." -ForegroundColor Yellow

# Verify the DB has been upgraded (DataBaseVersion should be 24.x)
$dbVersion = & $mysqlExe @mysqlArgs $TargetDb --batch --skip-column-names -e "SELECT ValueString FROM preference WHERE PrefName='DataBaseVersion';" 2>&1
Write-Host "       Current database version: $dbVersion" -ForegroundColor Yellow
if ($dbVersion -like "11.*") {
	Write-Host "       WARNING: Database still at v11.x. App upgrade may not have run yet!" -ForegroundColor Red
	Write-Host "       Continuing anyway, but some fixes may fail." -ForegroundColor Red
}

if (-not $SkipPostFixes) {
	if (-not (Test-Path $SqlScriptPath)) {
		throw "SQL fix script not found: $SqlScriptPath"
	}
	
	Write-Host "       Running Upgrade-HelianzComplete.sql..." -ForegroundColor Yellow
	$sqlOutput = Get-Content $SqlScriptPath -Raw | & $mysqlExe @mysqlArgs $TargetDb 2>&1
	
	# Show summarized output (just status lines)
	$sqlOutput | ForEach-Object {
		if ($_ -match "Status|expected|Groups|Permissions|Assignments|Users|Patients|Title|Version|UPGRADE|access") {
			Write-Host "       $_" -ForegroundColor Green
		}
	}
	
	if ($LASTEXITCODE -ne 0) {
		Write-Host "       WARNING: Some SQL statements may have had issues. Check output above." -ForegroundColor Yellow
	}
}

# ============================================================================
# 7. FINAL VERIFICATION
# ============================================================================
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MIGRATION COMPLETE" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Quick health check
$groups = & $mysqlExe @mysqlArgs $TargetDb --batch --skip-column-names -e "SELECT COUNT(*) FROM usergroup;" 2>&1
$perms = & $mysqlExe @mysqlArgs $TargetDb --batch --skip-column-names -e "SELECT COUNT(*) FROM grouppermission;" 2>&1
$attach = & $mysqlExe @mysqlArgs $TargetDb --batch --skip-column-names -e "SELECT COUNT(*) FROM usergroupattach;" 2>&1
$patients = & $mysqlExe @mysqlArgs $TargetDb --batch --skip-column-names -e "SELECT COUNT(*) FROM patient;" 2>&1
$title = & $mysqlExe @mysqlArgs $TargetDb --batch --skip-column-names -e "SELECT ValueString FROM preference WHERE PrefName='MainWindowTitle';" 2>&1

Write-Host "  Final State:" -ForegroundColor White
Write-Host "    Groups      : $groups (expect 11)" -ForegroundColor $(if ($groups -eq 11) { "Green" } else { "Yellow" })
Write-Host "    Permissions : $perms (expect ~575)" -ForegroundColor $(if ($perms -ge 500) { "Green" } else { "Yellow" })
Write-Host "    Assignments : $attach (expect 42)" -ForegroundColor $(if ($attach -ge 30) { "Green" } else { "Yellow" })
Write-Host "    Patients    : $patients" -ForegroundColor Green
Write-Host "    Title       : $title" -ForegroundColor $(if ($title -eq "Helianz") { "Green" } else { "Yellow" })
Write-Host ""
Write-Host "  Backups saved to: $BackupDir" -ForegroundColor Cyan
