# rename-db-to-helianz.ps1
# Creates a new database `helianz` and copies schema + data from `opendental`.
# Usage: powershell -NoProfile -ExecutionPolicy Bypass -File .\rename-db-to-helianz.ps1

Set-Location "D:\Project\PakRevi\opendental\Helia"

$Server   = '127.0.0.1'
$Port     = 3306
$SrcDb    = 'opendental'
$DstDb    = 'helianz'
$User     = 'root'
$Pass     = 'j0k0m4r0k3'

# Load connector: try MySql.Data then MySqlConnector
$loaded = $false
foreach ($dllPath in @(
    "Helianz-Installer\Release\MySql.Data.dll",
    "Helianz\bin\Debug\MySqlConnector.dll",
    "Required dlls\MySqlConnector.dll"
)) {
    if (Test-Path $dllPath) {
        try { Add-Type -Path $dllPath -ErrorAction Stop; Write-Host "Loaded: $dllPath"; $loaded = $true; break } catch {}
    }
}
if (-not $loaded) { Write-Host "WARNING: No MySQL client DLL loaded cleanly; script may fail." -ForegroundColor Yellow }

$connStr = "server=$Server;port=$Port;uid=$User;password=$Pass;SslMode=Preferred;AllowLoadLocalInfile=false;"

function Get-Conn {
    $c = $null
    try { $c = New-Object MySql.Data.MySqlClient.MySqlConnection($connStr) } catch {}
    if ($null -eq $c) { try { $c = New-Object MySqlConnector.MySqlConnection($connStr) } catch {} }
    if ($null -eq $c) { throw 'Could not construct MySQL connection object' }
    $c.Open(); return $c
}

function Exec {
    param($conn, [string]$sql)
    $cmd = $conn.CreateCommand(); $cmd.CommandText = $sql; return $cmd.ExecuteNonQuery()
}

function Query { param($conn,$sql)
    $cmd = $conn.CreateCommand(); $cmd.CommandText = $sql; $r = $cmd.ExecuteReader(); $rows = @(); while ($r.Read()) { $obj = @{}; for ($i=0;$i -lt $r.FieldCount;$i++){ $obj[$r.GetName($i)] = $r.GetValue($i) } ; $rows += $obj }; $r.Close(); return $rows }

Write-Host ("Connecting to MySQL {0}:{1}..." -f $Server,$Port)
try { $conn = Get-Conn; Write-Host "Connected" -ForegroundColor Green } catch { Write-Host "ERROR connecting: $_" -ForegroundColor Red; exit 1 }

# Check if destination DB exists
$exists = (Query $conn "SELECT SCHEMA_NAME FROM information_schema.SCHEMATA WHERE SCHEMA_NAME = '$DstDb'").Count -gt 0
if ($exists) { Write-Host "Database '$DstDb' already exists. Aborting to avoid data loss." -ForegroundColor Yellow; exit 1 }

# use backtick char variable for safe quoting
$bt = [char]96
# Create database
Write-Host ("Creating database {0}" -f $DstDb)
Exec $conn ("CREATE DATABASE " + $bt + $DstDb + $bt + " DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci")

# Disable foreign key checks for copy
Exec $conn "SET FOREIGN_KEY_CHECKS=0"

# Copy tables structure and data
 $tables = Query $conn ("SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA = '" + $SrcDb + "' AND TABLE_TYPE='BASE TABLE'")
Write-Host ("Found {0} tables to copy" -f $tables.Count)
foreach ($trow in $tables) {
    $t = $trow.TABLE_NAME
    Write-Host "Copying table: $t"
    try {
        Exec $conn ("CREATE TABLE " + $bt + $DstDb + $bt + "." + $bt + $t + $bt + " LIKE " + $bt + $SrcDb + $bt + "." + $bt + $t + $bt)
        Exec $conn ("INSERT INTO " + $bt + $DstDb + $bt + "." + $bt + $t + $bt + " SELECT * FROM " + $bt + $SrcDb + $bt + "." + $bt + $t + $bt)
    } catch { Write-Host ("  WARNING: failed to copy {0} : {1}" -f $t, $_) -ForegroundColor Yellow }
}

# Copy views
$views = Query $conn ("SELECT TABLE_NAME FROM information_schema.VIEWS WHERE TABLE_SCHEMA = '" + $SrcDb + "'")
foreach ($vrow in $views) {
    $v = $vrow.TABLE_NAME
    Write-Host ("Copying view: {0}" -f $v)
    try {
        $create = (Query $conn ("SHOW CREATE VIEW " + $bt + $SrcDb + $bt + "." + $bt + $v + $bt))[0]["Create View"]
        # replace source schema qualifier with dest schema using backtick char variable
        $create2 = $create.Replace($bt + $SrcDb + $bt, $bt + $DstDb + $bt)
        Exec $conn $create2
    } catch { Write-Host ("  WARNING: failed to copy view {0} : {1}" -f $v, $_) -ForegroundColor Yellow }
}

# Copy routines (procedures/functions)
$routines = Query $conn ("SELECT ROUTINE_NAME, ROUTINE_TYPE FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA = '" + $SrcDb + "'")
foreach ($r in $routines) {
    $name = $r.ROUTINE_NAME; $typ = $r.ROUTINE_TYPE
    Write-Host ("Copying {0}: {1}" -f $typ, $name)
    try {
        $show = Query $conn ("SHOW CREATE " + $typ + " " + $bt + $SrcDb + $bt + "." + $bt + $name + $bt)
        $col = if ($typ -eq 'PROCEDURE') { 'Create Procedure' } else { 'Create Function' }
        $sql = $show[0][$col].Replace($bt + $SrcDb + $bt, $bt + $DstDb + $bt)
        Exec $conn $sql
    } catch { Write-Host ("  WARNING: failed to copy {0} {1} : {2}" -f $typ, $name, $_) -ForegroundColor Yellow }
}

# Copy triggers
$trigs = Query $conn ("SELECT TRIGGER_NAME FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA = '" + $SrcDb + "'")
foreach ($tr in $trigs) {
    $name = $tr.TRIGGER_NAME
    Write-Host ("Copying trigger: {0}" -f $name)
    try {
        $show = Query $conn ("SHOW CREATE TRIGGER " + $bt + $SrcDb + $bt + "." + $bt + $name + $bt)
        $sql = $null
        if ($show.Count -gt 0) {
            $row = $show[0]
            foreach ($k in $row.Keys) { if ($k -match 'SQL') { $sql = $row[$k]; break } }
        }
        # As SHOW CREATE TRIGGER output varies, fallback to SHOW CREATE TRIGGER then replace schema references
        $create = $sql
        if ($create) {
            $create2 = $create.Replace($bt + $SrcDb + $bt, $bt + $DstDb + $bt)
            # Triggers are created in the context of db, so set the database then create
            Exec $conn ("USE " + $bt + $DstDb + $bt) | Out-Null
            Exec $conn $create2
        } else {
            Write-Host ("  WARNING: could not obtain create for trigger {0}" -f $name) -ForegroundColor Yellow
        }
    } catch { Write-Host ("  WARNING: failed to copy trigger {0} : {1}" -f $name, $_) -ForegroundColor Yellow }
}

# Re-enable foreign key checks
Exec $conn "SET FOREIGN_KEY_CHECKS=1"

Write-Host "Done. New database '$DstDb' created with copied tables. Verify application connection strings to point to '$DstDb' if desired." -ForegroundColor Green

$conn.Close()
