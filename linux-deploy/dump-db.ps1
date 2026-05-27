# dump-db.ps1
# Dumps a local MariaDB/MySQL database and saves it as a gzipped SQL file
# ready to be deployed to the Linux server.
#
# Usage (from the linux-deploy directory):
#   .\dump-db.ps1
#   .\dump-db.ps1 -Host localhost -Port 3306 -User root -Password "secret" -Database opendental -OutFile data\opendental.sql.gz
#
# Prerequisites:
#   - mysqldump must be on PATH (ships with MariaDB / MySQL installations)
#   - gzip must be on PATH  OR  the script falls back to PowerShell compression

param(
    [string]$Host     = "localhost",
    [int]   $Port     = 3306,
    [string]$User     = "root",
    [string]$Password = "",        # leave blank to be prompted
    [string]$Database = "opendental",
    [string]$OutFile  = "data\opendental.sql.gz"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ── Prompt for password if not supplied ──────────────────────────────────────
if ($Password -eq "") {
    $secPwd = Read-Host "MySQL/MariaDB password for ${User}@${Host}" -AsSecureString
    $bstr   = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secPwd)
    $Password = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
}

# ── Ensure output directory exists ───────────────────────────────────────────
$outDir = Split-Path -Parent $OutFile
if ($outDir -and !(Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir | Out-Null
}

# ── Check for mysqldump ───────────────────────────────────────────────────────
$mysqldump = Get-Command mysqldump -ErrorAction SilentlyContinue
if (-not $mysqldump) {
    # Try common MariaDB install location
    $candidates = @(
        "C:\Program Files\MariaDB 10.5\bin\mysqldump.exe",
        "C:\Program Files\MariaDB 10.6\bin\mysqldump.exe",
        "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqldump.exe",
        "C:\Program Files\MySQL\MySQL Server 5.7\bin\mysqldump.exe"
    )
    foreach ($c in $candidates) {
        if (Test-Path $c) { $mysqldump = $c; break }
    }
    if (-not $mysqldump) {
        Write-Error "mysqldump not found. Add it to PATH or install MariaDB/MySQL client tools."
        exit 1
    }
}

$dumpExe = if ($mysqldump -is [System.Management.Automation.ApplicationInfo]) { $mysqldump.Source } else { $mysqldump }

Write-Host "Using mysqldump: $dumpExe"
Write-Host "Dumping ${Database} from ${Host}:${Port} ..."

# ── Temporary uncompressed dump file ─────────────────────────────────────────
$tmpSql = [System.IO.Path]::GetTempFileName() -replace '\.tmp$', '.sql'

# Build mysqldump arguments
# --single-transaction   : consistent InnoDB dump without locking tables
# --routines             : include stored procedures / functions
# --triggers             : include triggers
# --set-gtid-purged=OFF  : avoid GTID errors when importing into a different server
$dumpArgs = @(
    "--host=$Host",
    "--port=$Port",
    "--user=$User",
    "--password=$Password",
    "--single-transaction",
    "--routines",
    "--triggers",
    "--set-gtid-purged=OFF",
    "--databases", $Database
)

try {
    & $dumpExe @dumpArgs 2>&1 | Tee-Object -FilePath $tmpSql | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "mysqldump exited with code $LASTEXITCODE"
    }
} catch {
    Remove-Item $tmpSql -ErrorAction SilentlyContinue
    throw
}

$sqlSize = (Get-Item $tmpSql).Length
Write-Host ("Dump complete: {0:N0} bytes uncompressed." -f $sqlSize)

# ── Compress ─────────────────────────────────────────────────────────────────
Write-Host "Compressing to $OutFile ..."

$gzip = Get-Command gzip -ErrorAction SilentlyContinue
if ($gzip) {
    # Fast native gzip
    & $gzip -c $tmpSql | Set-Content $OutFile -AsByteStream
} else {
    # Fallback: PowerShell GZipStream
    $inStream  = [System.IO.File]::OpenRead($tmpSql)
    $outStream = [System.IO.File]::Create($OutFile)
    $gzStream  = [System.IO.Compression.GZipStream]::new($outStream, [System.IO.Compression.CompressionMode]::Compress)
    $inStream.CopyTo($gzStream)
    $gzStream.Close(); $outStream.Close(); $inStream.Close()
}

Remove-Item $tmpSql -ErrorAction SilentlyContinue

$gzSize = (Get-Item $OutFile).Length
Write-Host ("Done. Output: $OutFile  ({0:N0} bytes compressed)" -f $gzSize)
Write-Host ""
Write-Host "Next step — upload and deploy:"
Write-Host "  scp -r . user@YOUR_SERVER:/opt/opendental-deploy"
Write-Host "  ssh user@YOUR_SERVER 'bash /opt/opendental-deploy/deploy.sh --src /path/to/repo --db /opt/opendental-deploy/data/opendental.sql.gz'"
