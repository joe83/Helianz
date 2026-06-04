# update-db-helianz.ps1
# Connects to MySQL and replaces all OpenDental/OpenDent string values with Helianz equivalents.

Set-Location "D:\Project\PakRevi\opendental\Helia"

$Server   = "127.0.0.1"
$Port     = 3306
$Database = "opendental"
$User     = "root"
$Pass     = "j0k0m4r0k3"

# Load MySQL connector - try MySql.Data first, fall back to MySqlConnector
$loaded = $false
foreach ($dllPath in @(
    "Helianz-Installer\Release\MySql.Data.dll",
    "Helianz\bin\Debug\MySqlConnector.dll",
    "Required dlls\MySqlConnector.dll"
)) {
    if (Test-Path $dllPath) {
        try {
            Add-Type -Path $dllPath -ErrorAction Stop
            Write-Host "Loaded: $dllPath"
            $loaded = $true
            break
        } catch {
            # try next
        }
    }
}
if (-not $loaded) {
    Write-Host "WARNING: No MySQL DLL loaded cleanly, trying anyway..."
}

# Ordered replacements (most specific first)
$replacements = @(
    @("OpenDentalBusiness", "HelianzBusiness"),
    @("OpenDentalCloud",    "HelianzCloud"),
    @("OpenDentalHelp",     "HelianzHelp"),
    @("OpenDentalServer",   "HelianzServer"),
    @("OpenDentalGraph",    "HelianzGraph"),
    @("OpenDentalHL7",      "HelianzHL7"),
    @("OpenDental",         "Helianz"),
    @("OpenDent",           "Helianz"),
    @("opendental",         "helianz"),
    @("opendent",           "helianz")
)

$connStr = "server=$Server;port=$Port;database=$Database;uid=$User;password=$Pass;SslMode=Preferred;AllowLoadLocalInfile=false;"

function Get-Connection {
    $conn = $null
    try { $conn = New-Object MySql.Data.MySqlClient.MySqlConnection($connStr) } catch {}
    if ($null -eq $conn) {
        try { $conn = New-Object MySqlConnector.MySqlConnection($connStr) } catch {}
    }
    if ($null -eq $conn) { throw "Could not create MySQL connection object" }
    $conn.Open()
    return $conn
}

function Exec-Reader {
    param($conn, [string]$sql)
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = $sql
    $reader = $cmd.ExecuteReader()
    $results = [System.Collections.Generic.List[hashtable]]::new()
    while ($reader.Read()) {
        $row = @{}
        for ($i = 0; $i -lt $reader.FieldCount; $i++) {
            $row[$reader.GetName($i)] = if ($reader.IsDBNull($i)) { $null } else { $reader.GetValue($i) }
        }
        $results.Add($row)
    }
    $reader.Close()
    return ,$results
}

function Exec-NonQuery {
    param($conn, [string]$sql)
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = $sql
    return $cmd.ExecuteNonQuery()
}

# Build nested REPLACE() expression for a column
function Build-ReplaceExpr {
    param([string]$colExpr)
    $expr = $colExpr
    foreach ($pair in $replacements) {
        $from = $pair[0] -replace "'", "''"
        $to   = $pair[1] -replace "'", "''"
        $expr = "REPLACE($expr, '$from', '$to')"
    }
    return $expr
}

# Build WHERE: column contains any search string
function Build-WhereExpr {
    param([string]$colExpr)
    $parts = @()
    $seen  = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($pair in $replacements) {
        $k = $pair[0]
        if ($seen.Add($k)) {
            $escaped = $k -replace "'", "''"
            $parts += "$colExpr LIKE '%$escaped%'"
        }
    }
    return "(" + ($parts -join " OR ") + ")"
}

Write-Host "`n=== Helianz Database Rename ===" -ForegroundColor Cyan
Write-Host "Connecting to $Server`:$Port/$Database ..."

try {
    $conn = Get-Connection
    Write-Host "Connected OK`n" -ForegroundColor Green
} catch {
    Write-Host "ERROR: $_" -ForegroundColor Red; exit 1
}

# Get all string-type columns
$bt = [char]96
$colQuery = "SELECT TABLE_NAME, COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '$Database' AND DATA_TYPE IN ('varchar','text','mediumtext','longtext','tinytext','char') ORDER BY TABLE_NAME, ORDINAL_POSITION"

Write-Host "Fetching columns from information_schema..."
$cols = Exec-Reader $conn $colQuery
Write-Host "Found $($cols.Count) string columns.`n"

# Group by table
$byTable = @{}
foreach ($c in $cols) {
    $t = $c["TABLE_NAME"]
    if (-not $byTable[$t]) { $byTable[$t] = [System.Collections.Generic.List[string]]::new() }
    $byTable[$t].Add($c["COLUMN_NAME"])
}

$totalRows = 0
$updatedTables = @{}

foreach ($tbl in ($byTable.Keys | Sort-Object)) {
    $colNames = $byTable[$tbl]

    # WHERE: any column contains a match
    $whereParts = @()
    foreach ($cn in $colNames) {
        $whereParts += Build-WhereExpr "${bt}${cn}${bt}"
    }
    $where = "(" + ($whereParts -join " OR ") + ")"

    # Count matching rows first
    try {
        $result = Exec-Reader $conn "SELECT COUNT(*) AS n FROM ${bt}${tbl}${bt} WHERE $where"
        $rowCount = [int]$result[0]["n"]
    } catch {
        Write-Host "  SKIP $tbl (count failed)" -ForegroundColor DarkGray
        continue
    }

    if ($rowCount -eq 0) { continue }

    # Build SET clause: update every string column
    $setParts = @()
    foreach ($cn in $colNames) {
        $colExpr  = "${bt}${cn}${bt}"
        $replaced = Build-ReplaceExpr $colExpr
        $setParts += "$colExpr = $replaced"
    }

    $updateSql = "UPDATE ${bt}${tbl}${bt} SET " + ($setParts -join ", ") + " WHERE $where"

    try {
        $affected = Exec-NonQuery $conn $updateSql
        if ($affected -gt 0) {
            Write-Host "  $tbl : $affected row(s) updated" -ForegroundColor Yellow
            $totalRows += $affected
            $updatedTables[$tbl] = $affected
        }
    } catch {
        Write-Host "  ERROR updating $tbl : $_" -ForegroundColor Red
    }
}

$conn.Close()

Write-Host "`n=== Summary ===" -ForegroundColor Cyan
if ($updatedTables.Count -eq 0) {
    Write-Host "No rows needed updating." -ForegroundColor Green
} else {
    foreach ($kv in ($updatedTables.GetEnumerator() | Sort-Object Name)) {
        Write-Host "  $($kv.Name): $($kv.Value) row(s)"
    }
    Write-Host "`nTotal rows updated: $totalRows" -ForegroundColor Green
}
Write-Host "Done." -ForegroundColor Cyan
