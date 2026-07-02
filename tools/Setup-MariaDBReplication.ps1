# =============================================================================
# Setup-MariaDBReplication.ps1
# =============================================================================
# Interactive PowerShell script to set up MariaDB master-slave replication
# for Helianz on WINDOWS. Supports Pangolin/VPS tunnel setups.
#
# SCENARIOS:
#
#   A) MASTER-ONLY (home server — prepare for remote clinics):
#      .\Setup-MariaDBReplication.ps1 -MasterOnly
#      Enables binlog, creates repl_user, shows MASTER STATUS.
#      Does NOT create a replica. Run this FIRST on the home server.
#
#   B) SAME MACHINE (master + replica on one server):
#      .\Setup-MariaDBReplication.ps1 -SameMachine
#      Runs a second MariaDB instance on port 3307 on the same server.
#
#   C) TWO LAN MACHINES (both on same office network):
#      .\Setup-MariaDBReplication.ps1 -MasterHost 192.168.1.100 -ReplicaHost 192.168.1.101
#
#   D) REMOTE CLINIC (master at home, replica at clinic, through WireGuard):
#      .\Setup-MariaDBReplication.ps1 -RemoteClinic -MasterHost 192.168.1.200
#      MasterHost = home server's WireGuard/LAN IP (NOT the HTTPS hostname!)
#
# PREREQUISITES:
#   - MariaDB/MySQL installed on this machine (replica host)
#   - Network to master via Pangolin tunnel (Scenario C) or LAN (Scenario B)
#   - Run PowerShell AS ADMINISTRATOR
#   - mysql.exe and mysqldump.exe in PATH, or adjust -MySqlBin
# =============================================================================

param(
    [string]$MasterHost   = "localhost",
    [string]$MasterPort   = "3306",
    [string]$MasterUser   = "root",
    [string]$MasterDb     = "helianz",
    [string]$MasterServiceName = "MariaDB",   # or "MySQL80", "MySQL"
    
    [string]$ReplicaHost  = "",
    [string]$ReplicaPort  = "3306",
    [string]$ReplicaUser  = "root",
    [string]$ReplicaServiceName = "MariaDB",  # or "MySQL80", "MySQL"
    
    # Same-machine mode: creates a second MariaDB instance on port 3307
    [switch]$SameMachine,
    
    # Remote clinic mode: master is at home, access through Pangolin tunnel
    # MasterHost should be the WireGuard/LAN IP of the home server (NOT the HTTPS hostname)
    [switch]$RemoteClinic,
    
    # Master-only mode: only configure the master for replication (enable binlog, create repl_user).
    # Does NOT set up any replica. Use this on the home server before running RemoteClinic at clinics.
    [switch]$MasterOnly,
    
    [string]$ReplUser     = "repl_user",
    [string]$ReplPassword = "",
    
    [string]$RoUser       = "oduser_ro",
    [string]$RoPassword   = "",
    
    # Path to mysql.exe / mysqldump.exe if not in PATH
    [string]$MySqlBin     = "",
    
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

# =============================================================================
# SAME-MACHINE OVERRIDE (Scenario A — Pangolin/VPS setups)
# =============================================================================
if ($SameMachine) {
    $ReplicaHost  = "localhost"
    $ReplicaPort  = "3307"
    $ReplicaUser  = "root"
    # Use a different service name for the second instance
    $ReplicaServiceName = "MariaDBReplica"
    Write-Host @"
==============================================================
  SAME-MACHINE REPLICA MODE (Pangolin/VPS friendly)
==============================================================
  Master:   localhost:$MasterPort  ($MasterServiceName)
  Replica:  localhost:$ReplicaPort ($ReplicaServiceName)
  
  A second MariaDB instance will be created on port 3307.
  Replication stays entirely on localhost — no tunnel needed.
==============================================================
"@ -ForegroundColor Cyan
}

if ($RemoteClinic) {
    # Remote clinic: master is at home, accessible through Pangolin
    # Replica is this machine's existing MariaDB on port 3306
    $ReplicaHost  = "localhost"
    $ReplicaPort  = "3306"
    $ReplicaUser  = "root"
    Write-Host @"
==============================================================
  REMOTE CLINIC REPLICA MODE
==============================================================
  Master:   $MasterHost`:$MasterPort  (WireGuard tunnel)
  Replica:  localhost:$ReplicaPort    (this clinic server)
  
  Binlog replication flows through the WireGuard tunnel.
  This clinic's HelianzServer reads from the local replica.
  
  PREREQUISITE: Run -MasterOnly on home server first!
    Master must have binary logging + repl_user created.
==============================================================
"@ -ForegroundColor Cyan
    
    $ready = Read-Host "`nIs the master already configured for replication? (y/n)"
    if ($ready -ne "y") {
        Write-Host "Run this script on the MASTER first (without -RemoteClinic), then re-run here." -ForegroundColor Red
        exit 1
    }
}

if ($MasterOnly) {
    Write-Host @"
==============================================================
  MASTER-ONLY MODE
==============================================================
  Configure master for replication WITHOUT setting up a replica.
  Use this on the home server first, then run -RemoteClinic at
  each clinic.
==============================================================
"@ -ForegroundColor Cyan
}

# =============================================================================
# HELPERS
# =============================================================================

function Read-Password {
    param([string]$Prompt)
    $secure = Read-Host -Prompt $Prompt -AsSecureString
    $ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    try { return [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr) }
    finally { [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr) }
}

function Get-MySqlExe {
    param([string]$ExeName)
    if ($MySqlBin) {
        $path = Join-Path $MySqlBin "$ExeName.exe"
        if (Test-Path $path) { return $path }
    }
    # Try PATH
    $found = Get-Command $ExeName -ErrorAction SilentlyContinue
    if ($found) { return $found.Source }
    # Try common install locations
    $commonPaths = @(
        "C:\Program Files\MariaDB 10.6\bin",
        "C:\Program Files\MariaDB 10.5\bin",
        "C:\Program Files\MariaDB 10.4\bin",
        "C:\Program Files\MariaDB 10.3\bin",
        "C:\Program Files\MySQL\MySQL Server 8.0\bin",
        "C:\Program Files\MySQL\MySQL Server 5.7\bin",
        "C:\ProgramData\MySQL\MySQL Server 8.0\bin",
        "C:\xampp\mysql\bin"
    )
    foreach ($p in $commonPaths) {
        $test = Join-Path $p "$ExeName.exe"
        if (Test-Path $test) { return $test }
    }
    throw "Cannot find $ExeName.exe. Use -MySqlBin to specify the path."
}

function Invoke-MySql {
    param(
        [string]$HostName,
        [string]$Port,
        [string]$User,
        [string]$Password,
        [string]$Query
    )
    $mysqlExe = Get-MySqlExe "mysql"
    $mysqlArgs = @(
        "-h", $HostName,
        "-P", $Port,
        "-u", $User,
        "-p$Password",
        "--default-character-set=utf8mb4",
        "-e", $Query
    )
    if ($DryRun) {
        Write-Host "[DRY RUN] & `"$mysqlExe`" $mysqlArgs" -ForegroundColor Cyan
        return ""
    }
    $result = & $mysqlExe $mysqlArgs 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "MySQL error (exit code $LASTEXITCODE): $result"
    }
    return $result
}

function Invoke-MySqlDump {
    param(
        [string]$HostName,
        [string]$Port,
        [string]$User,
        [string]$Password,
        [string]$Database,
        [string]$OutputFile
    )
    $dumpExe = Get-MySqlExe "mysqldump"
    if ($DryRun) {
        Write-Host "[DRY RUN] & `"$dumpExe`" -h $HostName -P $Port -u $User -p*** --single-transaction --master-data=2 --databases $Database > `"$OutputFile`"" -ForegroundColor Cyan
        return
    }
    # Use cmd /c with output redirection — PowerShell's & operator mangles --result-file quoting
    $cmd = "`"$dumpExe`" -h $HostName -P $Port -u $User -p$Password --single-transaction --master-data=2 --databases $Database --default-character-set=utf8mb4 > `"$OutputFile`" 2>&1"
    Write-Host "Running mysqldump (no progress bar, watch file size in another window)..." -ForegroundColor Gray
    Write-Host "  Dump file: $OutputFile" -ForegroundColor Gray
    cmd /c $cmd
    if ($LASTEXITCODE -ne 0) {
        throw "mysqldump failed with exit code $LASTEXITCODE. Check credentials and network."
    }
}

function Find-MyIni {
    param([string]$ServiceName)
    # Try to get path from service binary
    try {
        $svc = Get-CimInstance Win32_Service -Filter "Name='$ServiceName'" -ErrorAction SilentlyContinue
        if ($svc -and $svc.PathName) {
            $pathName = $svc.PathName -replace '"',''
            if ($pathName -match '(.+?)\\bin\\') {
                $dataDir = Join-Path $Matches[1] "data\my.ini"
                if (Test-Path $dataDir) { return $dataDir }
            }
            # MySQL 8 often puts my.ini in ProgramData
            if ($pathName -match 'MySQL Server') {
                $progData = "$env:ProgramData\MySQL\MySQL Server 8.0\my.ini"
                if (Test-Path $progData) { return $progData }
            }
        }
    } catch { }
    # Fallback: common paths
    $commonPaths = @(
        "$env:ProgramData\MySQL\MySQL Server 8.0\my.ini",
        "C:\Program Files\MariaDB 10.6\data\my.ini",
        "C:\Program Files\MariaDB 10.5\data\my.ini",
        "C:\Program Files\MariaDB 10.4\data\my.ini",
        "C:\Program Files\MariaDB 10.3\data\my.ini",
        "C:\Program Files\MySQL\MySQL Server 8.0\my.ini",
        "C:\xampp\mysql\bin\my.ini"
    )
    foreach ($p in $commonPaths) {
        if (Test-Path $p) { return $p }
    }
    return $null
}

function Restart-MySqlService {
    param([string]$ServiceName, [string]$ComputerName)
    Write-Host "Restarting service '$ServiceName'..." -ForegroundColor Gray
    if ($DryRun) {
        Write-Host "[DRY RUN] Restart-Service $ServiceName (or net stop/start)" -ForegroundColor Cyan
        return
    }
    if ($ComputerName -eq "localhost" -or $ComputerName -eq $env:COMPUTERNAME -or $ComputerName -eq "127.0.0.1") {
        try {
            Restart-Service $ServiceName -Force -ErrorAction Stop
        } catch {
            Write-Host "Restart-Service failed, trying net stop/start..." -ForegroundColor Yellow
            & net.exe stop $ServiceName 2>&1 | Out-Null
            Start-Sleep -Seconds 3
            & net.exe start $ServiceName 2>&1 | Out-Null
        }
    } else {
        # Remote restart via sc.exe
        & sc.exe "\\$ComputerName" stop $ServiceName
        Start-Sleep -Seconds 3
        & sc.exe "\\$ComputerName" start $ServiceName
    }
    Start-Sleep -Seconds 5  # Wait for service to fully start
    Write-Host "Service restarted." -ForegroundColor Green
}

function New-MariaDbSecondInstance {
    # =========================================================================
    # Creates a second MariaDB instance on the SAME machine for replication.
    # Instance 1 (master): port 3306, existing service
    # Instance 2 (replica): port 3307, new service "MariaDBReplica"
    #
    # This avoids needing a second physical machine and works perfectly
    # behind Pangolin/VPS tunnels since replication is localhost-only.
    # =========================================================================
    
    # Detect the existing MariaDB/MySQL install
    $svc = Get-CimInstance Win32_Service -Filter "Name='$MasterServiceName'" -ErrorAction Stop
    if (-not $svc) { throw "Service '$MasterServiceName' not found. Is MariaDB installed?" }
    
    $pathName = $svc.PathName -replace '"',''
    # Typical: "C:\Program Files\MariaDB 10.6\bin\mysqld.exe" --defaults-file="C:\...\data\my.ini" MariaDB
    $installDir = $null
    $dataDir = $null
    
    if ($pathName -match '(.+?)\\bin\\mysqld') {
        $installDir = $Matches[1]
    } else {
        throw "Cannot determine MariaDB install directory from: $pathName"
    }
    
    # Find the data directory from existing my.ini
    $masterMyIni = Find-MyIni $MasterServiceName
    if ($masterMyIni) {
        $dataDir = Split-Path $masterMyIni -Parent
    } else {
        $dataDir = Join-Path $installDir "data"
    }
    
    Write-Host "MariaDB install dir : $installDir" -ForegroundColor Gray
    Write-Host "Master data dir     : $dataDir" -ForegroundColor Gray
    
    # Create replica data directory
    $replicaDataDir = Join-Path $installDir "data_replica"
    $replicaMyIni   = Join-Path $replicaDataDir "my.ini"
    
    if (Test-Path $replicaDataDir) {
        Write-Host "Replica data directory already exists: $replicaDataDir" -ForegroundColor Yellow
        $overwrite = Read-Host "Overwrite? This will DELETE all replica data! (y/n)"
        if ($overwrite -eq "y") {
            Stop-Service $ReplicaServiceName -ErrorAction SilentlyContinue
            & sc.exe delete $ReplicaServiceName 2>$null
            Remove-Item $replicaDataDir -Recurse -Force
        } else {
            Write-Host "Keeping existing replica data. Skipping init." -ForegroundColor Yellow
            return $replicaMyIni
        }
    }
    
    New-Item -ItemType Directory -Path $replicaDataDir -Force | Out-Null
    
    # Copy base system tables from master data dir (mysql schema, etc.)
    Write-Host "Copying base system tables from master data directory..." -ForegroundColor Gray
    $excludeDirs = @("helianz", "performance_schema", "aria_log.00000001", "aria_log_control",
                     "ib_logfile0", "ib_logfile1", "ibdata1", "multi-master.info",
                     "mysql-bin.*", "relay-bin.*", "master.info", "*.err", "*.pid")
    
    Copy-Item "$dataDir\*" -Destination $replicaDataDir -Recurse -Force -Exclude "helianz"
    
    # Create replica my.ini
    Write-Host "Creating replica my.ini..." -ForegroundColor Gray
    $myIniContent = @"
[mysqld]
# Second MariaDB instance — Helianz Read-Only Replica
server-id               = 2
port                    = 3307
datadir                 = $replicaDataDir
socket                  = MariaDB_Replica
relay-log               = relay-bin
read_only               = ON
log_slave_updates       = ON
gtid_domain_id          = 1

# Reduce memory for second instance (adjust based on available RAM)
innodb_buffer_pool_size = 256M
max_connections         = 50

# Use different pipe/socket names to avoid conflict with master
# (the socket line above handles this on MariaDB)
"@
    Set-Content -Path $replicaMyIni -Value $myIniContent -Encoding ASCII
    
    # Install as a Windows service
    Write-Host "Installing replica as Windows service '$ReplicaServiceName'..." -ForegroundColor Gray
    $mysqldExe = Join-Path $installDir "bin\mysqld.exe"
    if (-not (Test-Path $mysqldExe)) {
        $mysqldExe = Join-Path $installDir "bin\mysqld.exe"
    }
    
    if ($DryRun) {
        Write-Host "[DRY RUN] & `"$mysqldExe`" --install $ReplicaServiceName --defaults-file=`"$replicaMyIni`"" -ForegroundColor Cyan
    } else {
        & $mysqldExe --install $ReplicaServiceName --defaults-file="$replicaMyIni" 2>&1
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to install replica service. Run as Administrator?"
        }
    }
    
    # Start the service
    Write-Host "Starting replica service..." -ForegroundColor Gray
    if (-not $DryRun) {
        Start-Service $ReplicaServiceName
        Start-Sleep -Seconds 5
        $svcStatus = Get-Service $ReplicaServiceName -ErrorAction SilentlyContinue
        if ($svcStatus -and $svcStatus.Status -eq 'Running') {
            Write-Host "Replica service is RUNNING on port 3307." -ForegroundColor Green
        } else {
            Write-Warning "Replica service may not have started. Check Windows Event Viewer."
            Write-Host "You can manually start it: net start $ReplicaServiceName" -ForegroundColor Yellow
        }
    }
    
    return $replicaMyIni
}

# =============================================================================
# MAIN
# =============================================================================
Clear-Host
Write-Host @"
==============================================================
  Helianz - MariaDB Master-Replica Replication Setup (Windows)
==============================================================
"@ -ForegroundColor Green

# Check admin rights
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin -and -not $DryRun) {
    Write-Warning "This script works best when run AS ADMINISTRATOR (needed to restart services)."
    Write-Warning "If you don't restart services here, you'll need to do it manually."
}

# Detect MySQL executable
Write-Host "`nDetecting MySQL installation..." -ForegroundColor Gray
try {
    $mysqlPath = Get-MySqlExe "mysql"
    Write-Host "  mysql.exe found: $mysqlPath" -ForegroundColor Green
} catch {
    Write-Host "  mysql.exe NOT found in PATH. Use -MySqlBin to specify location." -ForegroundColor Yellow
    Write-Host "  Example: .\Setup-MariaDBReplication.ps1 -MySqlBin `"C:\Program Files\MariaDB 10.6\bin`"" -ForegroundColor Yellow
}

# Auto-detect MySQL/MariaDB service name if not explicitly set
if ($MasterServiceName -eq "MariaDB" -and -not $SameMachine -and -not $RemoteClinic) {
    $detected = Get-Service -Name "MariaDB*", "MySQL*", "MySQL??" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($detected) {
        $MasterServiceName = $detected.Name
        Write-Host "  Detected service: $MasterServiceName" -ForegroundColor Green
    }
}

# Find my.ini locations (skip replica detection if same-machine — it doesn't exist yet)
$masterMyIni = Find-MyIni $MasterServiceName
if ($masterMyIni) { Write-Host "  Master my.ini : $masterMyIni" -ForegroundColor Gray }
if ($SameMachine -and -not $MasterOnly) {
    Write-Host "  Replica will be created as a second MariaDB instance on port 3307" -ForegroundColor Cyan
} elseif (-not $MasterOnly) {
    $replicaMyIni = Find-MyIni $ReplicaServiceName
    if ($replicaMyIni) { Write-Host "  Replica my.ini: $replicaMyIni" -ForegroundColor Gray }
}

# Collect missing info
if (-not $ReplPassword) { $ReplPassword = Read-Password "Enter password for replication user '$ReplUser'" }
$masterRootPass = Read-Password "Enter MySQL ROOT password for MASTER ($MasterHost)"

if (-not $MasterOnly) {
    if (-not $SameMachine) {
        if (-not $ReplicaHost) { $ReplicaHost = Read-Host "Enter REPLICA hostname or IP" }
        $replicaRootPass = Read-Password "Enter MySQL ROOT password for REPLICA ($ReplicaHost)"
    } else {
        # Same-machine: replica root password is same as master
        $replicaRootPass = $masterRootPass
    }

    if ($RemoteClinic) {
        # Remote clinic: replica root password is this machine's MariaDB root
        $replicaRootPass = Read-Password "Enter MySQL ROOT password for THIS clinic server ($ReplicaHost)"
    }
    if (-not $RoPassword) { $RoPassword = Read-Password "Enter password for read-only user '$RoUser'" }
}

# -------------------------------------------------------
# SAME-MACHINE: Create second MariaDB instance now (skip if MasterOnly)
# -------------------------------------------------------
if ($SameMachine -and -not $MasterOnly) {
    Write-Host "`n========================================" -ForegroundColor Yellow
    Write-Host "  Creating Second MariaDB Instance (Replica)" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow
    $replicaMyIni = New-MariaDbSecondInstance
    if (-not $replicaMyIni) {
        Write-Host "Failed to create replica instance." -ForegroundColor Red
        exit 1
    }
}

Write-Host "`nService names (used for restart):" -ForegroundColor Gray
Write-Host "  Master  service: $MasterServiceName" -ForegroundColor Gray
Write-Host "  Replica service: $ReplicaServiceName" -ForegroundColor Gray
if (-not $SameMachine -and -not $MasterOnly) {
    $confirm = Read-Host "Is this correct? (y/n)"
    if ($confirm -ne "y") {
        $MasterServiceName = Read-Host "Master service name (e.g. MariaDB, MySQL80)"
        $ReplicaServiceName = Read-Host "Replica service name (e.g. MariaDB, MySQL80)"
    }
}

# =============================================================================
# STEP 1: CONFIGURE MASTER (skip for RemoteClinic — master already configured)
# =============================================================================
if ($RemoteClinic) {
    Write-Host "`n========================================" -ForegroundColor Yellow
    Write-Host "  STEP 1: Verify MASTER ($MasterHost)" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow
    
    Write-Host "Testing connection to master through WireGuard tunnel..." -ForegroundColor Gray
    $testResult = Invoke-MySql -HostName $MasterHost -Port $MasterPort -User $ReplUser -Password $ReplPassword -Query "SELECT 1 AS connectivity_test;"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "`nFATAL: Cannot reach master at ${MasterHost}:${MasterPort}" -ForegroundColor Red
        Write-Host "Check:" -ForegroundColor Yellow
        Write-Host "  1. WireGuard/Pangolin tunnel is running on this clinic server" -ForegroundColor Yellow
        Write-Host "  2. Master MariaDB is running at home" -ForegroundColor Yellow
        Write-Host "  3. repl_user exists on master (did you run -MasterOnly on home server?)" -ForegroundColor Yellow
        Write-Host "  4. Master my.ini has bind-address=0.0.0.0 (not 127.0.0.1)" -ForegroundColor Yellow
        Write-Host "  5. Windows Firewall on master allows port 3306 from WireGuard IPs" -ForegroundColor Yellow
        exit 1
    }
    Write-Host "Master is reachable through tunnel!" -ForegroundColor Green
} else {
    # Local/LAN: we can configure the master
    Write-Host "`n========================================" -ForegroundColor Yellow
    Write-Host "  STEP 1: Configure MASTER ($MasterHost)" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow

    if (-not $masterMyIni) {
        $masterMyIni = Read-Host "Path to MASTER my.ini (find it first)"
    }

    Write-Host @"

Add these lines to the [mysqld] section of:
    $masterMyIni

[mysqld]
server-id               = 1
log-bin                 = mysql-bin
binlog_format           = ROW
expire_logs_days        = 7
max_binlog_size         = 100M
binlog_do_db            = $MasterDb
gtid_domain_id          = 1
"@ -ForegroundColor Cyan

    $ready = Read-Host "`nHave you saved my.ini? (y) or skip (s)?"
    if ($ready -eq "s") {
        Write-Host "Skipping my.ini edit. Make sure it's already configured." -ForegroundColor Yellow
    } elseif ($ready -ne "y") {
        Write-Host "Please edit my.ini first, then re-run." -ForegroundColor Red
        exit 1
    }

    # Restart master service
    $doRestart = Read-Host "Restart $MasterServiceName service now? (y/n)"
    if ($doRestart -eq "y") {
        Restart-MySqlService $MasterServiceName $MasterHost
    }

    # Create replication user
    Write-Host "Creating replication user on master..." -ForegroundColor Gray
    Invoke-MySql -HostName $MasterHost -Port $MasterPort -User $MasterUser -Password $masterRootPass -Query @"
CREATE USER IF NOT EXISTS '$ReplUser'@'%' IDENTIFIED BY '$ReplPassword';
GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO '$ReplUser'@'%';
FLUSH PRIVILEGES;
"@
}

# Show master status (uses ReplUser for RemoteClinic, root for local setups)
$masterStatusUser = if ($RemoteClinic) { $ReplUser } else { $MasterUser }
$masterStatusPass = if ($RemoteClinic) { $ReplPassword } else { $masterRootPass }
Write-Host "`nMaster binary log status:" -ForegroundColor Gray
$masterStatus = Invoke-MySql -HostName $MasterHost -Port $MasterPort -User $masterStatusUser -Password $masterStatusPass -Query "SHOW MASTER STATUS;"
Write-Host $masterStatus -ForegroundColor White

$lines = $masterStatus -split "`r`n"
$masterLogFile = ""
$masterLogPos = ""
if ($lines.Count -ge 2) {
    $fields = $lines[1] -split "`t"
    $masterLogFile = $fields[0].Trim()
    $masterLogPos  = $fields[1].Trim()
    Write-Host "`n>>> WRITE THESE DOWN: File=$masterLogFile  Position=$masterLogPos" -ForegroundColor Green
}

# MasterOnly: stop here — master is configured, clinics will connect later
if ($MasterOnly) {
    Write-Host "`n==============================================================" -ForegroundColor Green
    Write-Host "  MASTER is configured for replication!" -ForegroundColor Green
    Write-Host "==============================================================" -ForegroundColor Green
    Write-Host @"
    
  Replication user : $ReplUser
  Binlog file      : $masterLogFile
  Binlog position  : $masterLogPos
  
  Now run this on EACH clinic server:
    .\Setup-MariaDBReplication.ps1 -RemoteClinic -MasterHost <home-server-wireguard-ip>
    
  Use the WireGuard/LAN IP of this home server, NOT the HTTPS hostname.
  MySQL port 3306 must be reachable through the WireGuard tunnel.
  
  Also make sure MariaDB binds to the network interface, not just localhost.
  Check my.ini: bind-address should be 0.0.0.0 or the WireGuard interface IP.
  
"@ -ForegroundColor Cyan
    exit 0
}


# =============================================================================
# STEP 2: CREATE AND TRANSFER DUMP
# =============================================================================
Write-Host "`n========================================" -ForegroundColor Yellow
Write-Host "  STEP 2: Seed REPLICA with master data" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow

$dumpFile = Join-Path $env:TEMP "helianz_replica_seed.sql"
Write-Host "Creating mysqldump (this may take a while for large databases)..." -ForegroundColor Gray
Invoke-MySqlDump -HostName $MasterHost -Port $MasterPort -User $MasterUser -Password $masterRootPass -Database $MasterDb -OutputFile $dumpFile

$dumpSize = "{0:N0} MB" -f ((Get-Item $dumpFile).Length / 1MB)
Write-Host "Dump created: $dumpFile ($dumpSize)" -ForegroundColor Green

if ($SameMachine) {
    # Same machine: import directly via local mysql on port 3307
    Write-Host "`nImporting dump into replica (localhost:3307)..." -ForegroundColor Gray
    $mysqlExe = Get-MySqlExe "mysql"
    if (-not $DryRun) {
        $importCmd = "`"$mysqlExe`" -h localhost -P $ReplicaPort -u $ReplicaUser -p$replicaRootPass < `"$dumpFile`""
        cmd /c $importCmd
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Import may have had errors. Check the output above."
        } else {
            Write-Host "Dump imported into replica." -ForegroundColor Green
        }
    }
} elseif ($RemoteClinic) {
    # Remote clinic: dump was created via tunnel. Import locally.
    Write-Host "`nImporting dump into local replica (localhost:$ReplicaPort)..." -ForegroundColor Gray
    $mysqlExe = Get-MySqlExe "mysql"
    if (-not $DryRun) {
        # Drop existing helianz DB on replica first (clean start)
        Write-Host "Dropping existing database (if any)..." -ForegroundColor Gray
        Invoke-MySql -HostName $ReplicaHost -Port $ReplicaPort -User $ReplicaUser -Password $replicaRootPass -Query "DROP DATABASE IF EXISTS $MasterDb; CREATE DATABASE $MasterDb;" | Out-Null
        $importCmd = "`"$mysqlExe`" -h $ReplicaHost -P $ReplicaPort -u $ReplicaUser -p$replicaRootPass < `"$dumpFile`""
        cmd /c $importCmd
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Import may have had errors. Check the output above."
        } else {
            Write-Host "Dump imported into local replica." -ForegroundColor Green
        }
    }
} else {
    # Two-machine mode: manual transfer instructions
    Write-Host @"

Transfer the dump to the REPLICA machine. Options:
  A) Network share:
       copy `"$dumpFile`" \\$ReplicaHost\c$\temp\
  B) USB drive (copy manually)

"@ -ForegroundColor Cyan

    # Try to copy directly if replica is reachable via admin share
    $remoteTemp = "\\$ReplicaHost\c$\temp"
    if (Test-Path $remoteTemp) {
        $autoCopy = Read-Host "Admin share to $ReplicaHost is accessible. Copy dump now? (y/n)"
        if ($autoCopy -eq "y") {
            Copy-Item $dumpFile -Destination "$remoteTemp\" -Force
            Write-Host "Dump copied to $remoteTemp" -ForegroundColor Green
        }
    }

    Write-Host "`nIMPORT the dump on the REPLICA (from PowerShell on the replica):"
    Write-Host "  cd `"C:\Program Files\MariaDB 10.6\bin`"  (adjust path as needed)"
    Write-Host "  .\mysql.exe -u root -p < C:\temp\helianz_replica_seed.sql"
    $ready = Read-Host "`nHave you imported the dump on the replica? (y/n)"
    if ($ready -ne "y") {
        Write-Host "Import the dump first, then re-run." -ForegroundColor Red
        exit 1
    }
}


# =============================================================================
# STEP 3: CONFIGURE REPLICA
# =============================================================================
Write-Host "`n========================================" -ForegroundColor Yellow
Write-Host "  STEP 3: Configure REPLICA ($ReplicaHost`:$ReplicaPort)" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow

if (-not $SameMachine -and -not $RemoteClinic) {
    # Two-machine LAN: user needs to configure my.ini on the replica
    if (-not $replicaMyIni) {
        $replicaMyIni = Read-Host "Path to REPLICA my.ini"
    }

    Write-Host @"

Add these lines to the [mysqld] section of:
    $replicaMyIni

[mysqld]
server-id               = 2
relay-log               = relay-bin
read_only               = ON
log_slave_updates       = ON
gtid_domain_id          = 1
"@ -ForegroundColor Cyan

    $ready = Read-Host "`nSaved my.ini on replica? (y) or skip (s)?"
    if ($ready -eq "n") {
        Write-Host "Please edit my.ini on the replica first." -ForegroundColor Red
        exit 1
    }

    $doRestart = Read-Host "Restart $ReplicaServiceName on $ReplicaHost? (y/n)"
    if ($doRestart -eq "y") {
        Restart-MySqlService $ReplicaServiceName $ReplicaHost
    }
} elseif ($RemoteClinic) {
    # Remote clinic: use existing MariaDB. Ensure read-only and relay-log are set.
    Write-Host "Configuring local MariaDB for replication..." -ForegroundColor Gray
    $replicaMyIni = Find-MyIni $ReplicaServiceName
    if ($replicaMyIni) {
        Write-Host "Replica my.ini: $replicaMyIni" -ForegroundColor Gray
        Write-Host @"

Make sure your local my.ini has these under [mysqld]:
  server-id      = <unique per clinic, e.g. 2, 3, or 4>
  relay-log      = relay-bin
  read_only      = ON
  log_slave_updates = ON   (optional, for future chain replication)
"@ -ForegroundColor Cyan
        $ready = Read-Host "`nConfigured and saved? (y)"
        if ($ready -ne "y") { exit 1 }
        
        $doRestart = Read-Host "Restart $ReplicaServiceName now? (y/n)"
        if ($doRestart -eq "y") {
            Restart-MySqlService $ReplicaServiceName $ReplicaHost
        }
    }
} else {
    # Same-machine: my.ini already created by New-MariaDbSecondInstance, 
    # and service is already running. Just verify.
    Write-Host "Replica instance already configured and running on localhost:$ReplicaPort" -ForegroundColor Green
    $svcStatus = Get-Service $ReplicaServiceName -ErrorAction SilentlyContinue
    if (-not $svcStatus -or $svcStatus.Status -ne 'Running') {
        Write-Warning "Replica service '$ReplicaServiceName' is not running. Starting it..."
        Start-Service $ReplicaServiceName -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 3
    }
}

# Determine MASTER_HOST for CHANGE MASTER:
#   SameMachine: localhost
#   RemoteClinic: tunnel-accessible hostname/IP (user's -MasterHost)
#   LAN: direct IP
$changeMasterHost = if ($SameMachine) { "localhost" } else { $MasterHost }

# Use collected or prompt for log file/pos
if (-not $masterLogFile) { $masterLogFile = Read-Host "Enter MASTER_LOG_FILE (from SHOW MASTER STATUS)" }
if (-not $masterLogPos)  { $masterLogPos  = Read-Host "Enter MASTER_LOG_POS  (from SHOW MASTER STATUS)" }

Write-Host "Configuring replication on replica..." -ForegroundColor Gray
$stopResult = Invoke-MySql -HostName $ReplicaHost -Port $ReplicaPort -User $ReplicaUser -Password $replicaRootPass -Query "STOP SLAVE;"
$changeResult = Invoke-MySql -HostName $ReplicaHost -Port $ReplicaPort -User $ReplicaUser -Password $replicaRootPass -Query @"
CHANGE MASTER TO
    MASTER_HOST             = '$changeMasterHost',
    MASTER_PORT             = $MasterPort,
    MASTER_USER             = '$ReplUser',
    MASTER_PASSWORD         = '$ReplPassword',
    MASTER_LOG_FILE         = '$masterLogFile',
    MASTER_LOG_POS          = $masterLogPos;
"@
$startResult = Invoke-MySql -HostName $ReplicaHost -Port $ReplicaPort -User $ReplicaUser -Password $replicaRootPass -Query "START SLAVE;"
Start-Sleep -Seconds 2

# Check slave status
Write-Host "`nReplica status:" -ForegroundColor Gray
$slaveStatus = Invoke-MySql -HostName $ReplicaHost -Port $ReplicaPort -User $ReplicaUser -Password $replicaRootPass -Query "SHOW SLAVE STATUS\G"
Write-Host $slaveStatus -ForegroundColor White

if ($slaveStatus -match "Slave_IO_Running:\s*Yes" -and $slaveStatus -match "Slave_SQL_Running:\s*Yes") {
    Write-Host "`n*** REPLICATION IS RUNNING successfully! ***" -ForegroundColor Green
} else {
    Write-Host "`n*** WARNING: Replication may not be healthy. Check the SHOW SLAVE STATUS output above. ***" -ForegroundColor Red
    Write-Host "Common issues:" -ForegroundColor Yellow
    Write-Host "  - Firewall blocking port 3306 on master (add Windows Firewall rule)" -ForegroundColor Yellow
    Write-Host "  - repl_user password incorrect on CHANGE MASTER" -ForegroundColor Yellow
    Write-Host "  - MASTER_LOG_FILE/MASTER_LOG_POS don't match the master" -ForegroundColor Yellow
}


# =============================================================================
# STEP 4: CREATE READ-ONLY USER ON REPLICA
# =============================================================================
Write-Host "`n========================================" -ForegroundColor Yellow
Write-Host "  STEP 4: Create read-only user on REPLICA" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow

Invoke-MySql -HostName $ReplicaHost -Port $ReplicaPort -User $ReplicaUser -Password $replicaRootPass -Query @"
CREATE USER IF NOT EXISTS '$RoUser'@'%' IDENTIFIED BY '$RoPassword';
GRANT SELECT, EXECUTE ON ${MasterDb}.* TO '$RoUser'@'%';
FLUSH PRIVILEGES;
"@
Write-Host "Read-only user '$RoUser' created on replica." -ForegroundColor Green


# =============================================================================
# STEP 5: HELIANZ CONFIGURATION INSTRUCTIONS
# =============================================================================
Write-Host @"

==============================================================
  Helianz - Read-Only Server Configuration
==============================================================

In Helianz, go to:
  Setup > Preferences > Server Connections

  1. Check: [x] Use Separate Read-Only Server
  2. Select: Direct Connection (not middle-tier)
  3. Enter:
       Computer Name : $ReplicaHost
       Database      : $MasterDb
       MySQL User    : $RoUser
       MySQL Password: (your read-only password)

"@ -ForegroundColor Cyan

if ($SameMachine) {
    Write-Host @"
  NOTE: Replica is on the SAME MACHINE as master (port $ReplicaPort).
  Replication uses localhost — Pangolin/VPS tunnel is NOT involved.
  HelianzServer can read directly without tunnel overhead.
"@ -ForegroundColor Green
}

if ($RemoteClinic) {
    Write-Host @"
  NOTE: Replica runs on THIS clinic server (port $ReplicaPort).
  Reads are LOCAL (no tunnel). Replication pulls binlogs through
  the WireGuard tunnel to master at $MasterHost.
  Make sure WireGuard/Pangolin is running and master port 3306 is reachable.
  
  Install Sync-ClinicReplica.ps1 as a Scheduled Task (AtStartup)
  to auto-reseed if replication breaks overnight.
"@ -ForegroundColor Green
}

Write-Host @"
  4. Click OK and restart Helianz.

Read queries (cache refreshes, reports, list grids) will now
use the replica, reducing load on the master.

==============================================================
"@ -ForegroundColor Cyan

Write-Host "`nSetup complete!" -ForegroundColor Green

