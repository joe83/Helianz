# =============================================================================
# Seed-PatientFoldersLocal.ps1
# Creates local patient folders ({LocalBase}/{PatNum%100}/{PatNum}/.keep)
# directly on Windows Server without any Python dependency.
# =============================================================================

[CmdletBinding()]
param (
    [string]$TargetDir = "C:\HelianzImages",
    [string]$MySqlHost = "localhost",
    [int]$MySqlPort = 3306,
    [string]$MySqlDatabase = "helianz",
    [string]$MySqlUser = "root",
    [string]$MySqlPassword = "",
    [string]$EnvFile = "",
    [int]$Limit = 0
)

# If no password provided, check .env in script directory
if ([string]::IsNullOrWhiteSpace($MySqlPassword)) {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
    $candidateEnv = if ($EnvFile) { $EnvFile } else { Join-Path $scriptDir ".env" }
    if (Test-Path $candidateEnv) {
        Get-Content $candidateEnv | ForEach-Object {
            $line = $_.Trim()
            if ($line -and -not $line.StartsWith("#") -and $line.Contains("=")) {
                $parts = $line.Split("=", 2)
                $k = $parts[0].Trim()
                $v = $parts[1].Trim().Trim("'").Trim('"')
                if ($k -eq "MYSQL_PASSWORD" -and -not $MySqlPassword) { $MySqlPassword = $v }
                if ($k -eq "MYSQL_USER" -and $MySqlUser -eq "root") { $MySqlUser = $v }
                if ($k -eq "MYSQL_DATABASE" -and $MySqlDatabase -eq "helianz") { $MySqlDatabase = $v }
                if ($k -eq "MYSQL_HOST" -and $MySqlHost -eq "localhost") { $MySqlHost = $v }
            }
        }
    }
}

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " HELIANZ LOCAL PATIENT FOLDER SEEDER (POWERSHELL)" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Target Directory : $TargetDir" -ForegroundColor White
Write-Host "Database         : $MySqlUser@$MySqlHost`:$MySqlPort/$MySqlDatabase" -ForegroundColor White

# 1. Fetch PatNums from MySQL
$patNums = @()

# Try mysql.exe if in PATH or MariaDB/MySQL install directories
$mysqlExe = (Get-Command mysql -ErrorAction SilentlyContinue).Source
if (-not $mysqlExe) {
    $candidates = @(
        "C:\Program Files\MariaDB*\bin\mysql.exe",
        "C:\Program Files\MySQL\MySQL Server*\bin\mysql.exe",
        "C:\xampp\mysql\bin\mysql.exe"
    )
    foreach ($c in $candidates) {
        $found = Get-Item $c -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($found) { $mysqlExe = $found.FullName; break }
    }
}

if ($mysqlExe) {
    Write-Host "Using MySQL CLI : $mysqlExe" -ForegroundColor DarkGray
    $sqlCmd = "SELECT PatNum FROM patient ORDER BY PatNum ASC;"
    $argsList = @("-h", $MySqlHost, "-P", $MySqlPort.ToString(), "-u", $MySqlUser)
    if ($MySqlPassword) { $argsList += "-p$MySqlPassword" }
    $argsList += @("-D", $MySqlDatabase, "-s", "-N", "-e", $sqlCmd)

    $output = & $mysqlExe $argsList 2>&1
    foreach ($line in $output) {
        $lineClean = $line.ToString().Trim()
        if ($lineClean -match '^\d+$') {
            $patNums += [int64]$lineClean
        }
    }
} else {
    # Fallback to python query
    Write-Host "Querying database via Python..." -ForegroundColor DarkGray
    $pyScript = @"
import sys, os
script_dir = r'$scriptDir'
sys.path.insert(0, script_dir)
from seed_patient_storage import get_db_connection, fetch_all_patients
conn = get_db_connection('$MySqlHost', $MySqlPort, '$MySqlUser', '$MySqlPassword', '$MySqlDatabase')
pats = fetch_all_patients(conn)
conn.close()
for p in pats:
    print(p)
"@
    $pyOut = python -c "$pyScript" 2>&1
    foreach ($line in $pyOut) {
        $lineClean = $line.ToString().Trim()
        if ($lineClean -match '^\d+$') {
            $patNums += [int64]$lineClean
        }
    }
}

if ($patNums.Count -eq 0) {
    Write-Host "ERROR: No patients retrieved from database. Check MySQL connection." -ForegroundColor Red
    return
}

Write-Host "Total Patients   : $($patNums.Count)" -ForegroundColor Green

if ($Limit -gt 0) {
    $patNums = $patNums | Select-Object -First $Limit
    Write-Host "Limiting to first $Limit patients." -ForegroundColor Yellow
}

# Ensure Target Directory Exists
if (-not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}

# 2. Create Folders and .keep Files
Write-Host "Creating local folders in '$TargetDir'..." -ForegroundColor Cyan
$sw = [System.Diagnostics.Stopwatch]::StartNew()
$createdCount = 0

foreach ($p in $patNums) {
    $bucket = ($p % 100).ToString()
    $pDir = Join-Path $TargetDir (Join-Path $bucket $p.ToString())
    if (-not (Test-Path $pDir)) {
        [System.IO.Directory]::CreateDirectory($pDir) | Out-Null
    }
    $keepFile = Join-Path $pDir ".keep"
    if (-not (Test-Path $keepFile)) {
        [System.IO.File]::WriteAllText($keepFile, "Helianz Folder Marker`n")
    }
    $createdCount++
}

$sw.Stop()
Write-Host "============================================================" -ForegroundColor Green
Write-Host "SUCCESS! Created $createdCount patient folders in $($sw.Elapsed.TotalSeconds.ToString('F2')) seconds." -ForegroundColor Green
Write-Host "Location: $TargetDir" -ForegroundColor Cyan
$sample = $patNums | Select-Object -First 5
foreach ($s in $sample) {
    $b = ($s % 100).ToString()
    $samplePath = Join-Path $TargetDir (Join-Path $b (Join-Path $s.ToString() ".keep"))
    Write-Host "  [DIR] $samplePath" -ForegroundColor Gray
}
Write-Host "============================================================" -ForegroundColor Green
