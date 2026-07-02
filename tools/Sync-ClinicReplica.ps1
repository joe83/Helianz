# =============================================================================
# Sync-ClinicReplica.ps1
# =============================================================================
# Auto-recovery script for per-clinic MariaDB replicas.
# Runs when the clinic server boots. Checks replication health:
#   - If HEALTHY: does nothing (already caught up)
#   - If behind but binlogs available: waits for catch-up (fast)
#   - If BROKEN (gap too large or errors): re-seeds from master (slower)
#
# PREREQUISITES:
#   - MariaDB on this clinic server (replica instance, port 3307 or same-machine)
#   - Network to master (through Pangolin tunnel)
#   - mysql.exe in PATH or set $MySqlBin
#
# INSTALL AS SCHEDULED TASK (run at startup):
#   $trigger = New-ScheduledTaskTrigger -AtStartup
#   $action  = New-ScheduledTaskAction -Execute "powershell.exe" `
#                -Argument "-File `"C:\Helianz\tools\Sync-ClinicReplica.ps1`" -MasterHost <ip> -WindowStyle Hidden"
#   Register-ScheduledTask -TaskName "HelianzReplicaSync" -Trigger $trigger -Action $action `
#                -RunLevel Highest -Description "Auto-resync MariaDB replica on boot"
#
# MANUAL RUN:
#   .\Sync-ClinicReplica.ps1 -MasterHost 192.168.1.200
# =============================================================================

param(
    [Parameter(Mandatory)]
    [string]$MasterHost,                    # Master IP (reachable through Pangolin)
    
    [string]$MasterPort       = "3306",
    [string]$ReplUser         = "repl_user",
    [string]$ReplPassword     = "",
    
    [string]$ReplicaHost      = "localhost",
    [string]$ReplicaPort      = "3307",
    [string]$ReplicaUser      = "root",
    [string]$ReplicaService   = "MariaDBReplica",   # or "MariaDB" if single-instance
    
    [string]$Database         = "helianz",
    [string]$RoUser           = "oduser_ro",
    [string]$RoPassword       = "",
    
    [string]$MySqlBin         = "",         # Path to mysql.exe if not in PATH
    [string]$WorkDir          = "C:\Helianz\tools\replica_sync",
    
    # Max minutes to wait for catch-up before giving up and re-seeding
    [int]$CatchUpTimeoutMins  = 30,
    
    [switch]$ForceReseed       # Skip catch-up, force full re-seed
)

$ErrorActionPreference = "Continue"
$script:LogLines = @()

function Write-Log {
    param([string]$Message, [string]$Color = "White")
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$ts] $Message"
    $script:LogLines += $line
    Write-Host $line -ForegroundColor $Color
}

function Get-MySqlExe {
    param([string]$ExeName)
    if ($MySqlBin) {
        $path = Join-Path $MySqlBin "$ExeName.exe"
        if (Test-Path $path) { return $path }
    }
    $found = Get-Command $ExeName -ErrorAction SilentlyContinue
    if ($found) { return $found.Source }
    $commonPaths = @(
        "C:\Program Files\MariaDB 10.6\bin",
        "C:\Program Files\MariaDB 10.5\bin",
        "C:\Program Files\MariaDB 10.4\bin",
        "C:\Program Files\MariaDB 10.3\bin",
        "C:\Program Files\MySQL\MySQL Server 8.0\bin"
    )
    foreach ($p in $commonPaths) {
        $test = Join-Path $p "$ExeName.exe"
        if (Test-Path $test) { return $test }
    }
    throw "Cannot find $ExeName.exe. Use -MySqlBin."
}

function Invoke-MySql {
    param([string]$HostName, [string]$Port, [string]$User, [string]$Password, [string]$Query)
    $exe = Get-MySqlExe "mysql"
    $tmpFile = [System.IO.Path]::GetTempFileName()
    $Query | Out-File -FilePath $tmpFile -Encoding ASCII
    $result = & $exe -h $HostName -P $Port -u $User "-p$Password" --default-character-set=utf8mb4 -e $Query 2>&1
    Remove-Item $tmpFile -ErrorAction SilentlyContinue
    return $result
}

function Test-MySqlConnection {
    param([string]$HostName, [string]$Port, [string]$User, [string]$Password)
    try {
        $null = Invoke-MySql -HostName $HostName -Port $Port -User $User -Password $Password -Query "SELECT 1;" 2>$null
        return ($LASTEXITCODE -eq 0)
    } catch {
        return $false
    }
}

# =============================================================================
# INIT
# =============================================================================
$logFile = Join-Path $WorkDir "replica_sync_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
New-Item -ItemType Directory -Path $WorkDir -Force | Out-Null

Write-Log "=====================================" "Cyan"
Write-Log "  Clinic Replica Sync Starting" "Cyan"
Write-Log "  Master:  ${MasterHost}:${MasterPort}" "Cyan"
Write-Log "  Replica: ${ReplicaHost}:${ReplicaPort}" "Cyan"
Write-Log "=====================================" "Cyan"

# Collect password if not provided
if (-not $ReplPassword) {
    $secure = Read-Host "Enter replication user password" -AsSecureString
    $ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    $ReplPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
}

# =============================================================================
# STEP 1: Ensure replica service is running
# =============================================================================
Write-Log "Checking replica service '$ReplicaServiceName'..." "Gray"
try {
    $svc = Get-Service $ReplicaService -ErrorAction Stop
    if ($svc.Status -ne 'Running') {
        Write-Log "Starting replica service..." "Yellow"
        Start-Service $ReplicaService
        Start-Sleep -Seconds 8
    }
    Write-Log "Replica service is running." "Green"
} catch {
    Write-Log "ERROR: Replica service '$ReplicaService' not found. Is MariaDB installed?" "Red"
    exit 1
}

# Wait for replica MySQL to accept connections
$retries = 0
while (-not (Test-MySqlConnection -HostName $ReplicaHost -Port $ReplicaPort -User $ReplicaUser -Password $ReplPassword) -and $retries -lt 12) {
    Write-Log "Waiting for replica MySQL to accept connections... ($retries/12)" "Gray"
    Start-Sleep -Seconds 5
    $retries++
}
if ($retries -ge 12) {
    Write-Log "ERROR: Cannot connect to replica MySQL after 60 seconds." "Red"
    exit 1
}
Write-Log "Replica MySQL is accepting connections." "Green"

# =============================================================================
# STEP 2: Check replication health
# =============================================================================
Write-Log "Checking replication status..." "Gray"
$slaveStatus = Invoke-MySql -HostName $ReplicaHost -Port $ReplicaPort -User $ReplicaUser -Password $ReplPassword -Query "SHOW SLAVE STATUS\G"

$ioRunning    = ($slaveStatus -match "Slave_IO_Running:\s*Yes")
$sqlRunning   = ($slaveStatus -match "Slave_SQL_Running:\s*Yes")
$lastError    = if ($slaveStatus -match "Last_IO_Error:\s*(.+)") { $Matches[1].Trim() } else { "" }
$lastSqlError = if ($slaveStatus -match "Last_SQL_Error:\s*(.+)") { $Matches[1].Trim() } else { "" }
$secsBehind   = if ($slaveStatus -match "Seconds_Behind_Master:\s*(\d+)") { [int]$Matches[1] } else { -1 }

Write-Log "  Slave_IO_Running    : $(if($ioRunning){'Yes'}else{'No'})" "Gray"
Write-Log "  Slave_SQL_Running   : $(if($sqlRunning){'Yes'}else{'No'})" "Gray"
Write-Log "  Seconds_Behind      : $secsBehind" "Gray"

if ($lastError -and $lastError -ne "0") {
    Write-Log "  Last_IO_Error       : $lastError" "Yellow"
}
if ($lastSqlError -and $lastSqlError -ne "0") {
    Write-Log "  Last_SQL_Error      : $lastSqlError" "Yellow"
}

# =============================================================================
# STEP 3: Decide - catch-up or re-seed?
# =============================================================================
$needReseed = $false

if ($ForceReseed) {
    Write-Log "ForceReseed flag set. Will re-seed." "Yellow"
    $needReseed = $true
}
elseif (-not $ioRunning -or -not $sqlRunning) {
    Write-Log "Replication is broken (IO or SQL not running)." "Yellow"
    
    # Check if it's a known recoverable error vs. needs reseed
    if ($lastError -match "connect|timeout|refused|network") {
        Write-Log "Connection error to master. Checking if master is reachable..." "Yellow"
        if (-not (Test-MySqlConnection -HostName $MasterHost -Port $MasterPort -User $ReplUser -Password $ReplPassword)) {
            Write-Log "Master is NOT reachable. Will retry catch-up." "Yellow"
            # Try simple restart of slave
            Invoke-MySql -HostName $ReplicaHost -Port $ReplicaPort -User $ReplicaUser -Password $ReplPassword -Query "STOP SLAVE; START SLAVE;" | Out-Null
            Start-Sleep -Seconds 5
            $slaveStatus = Invoke-MySql -HostName $ReplicaHost -Port $ReplicaPort -User $ReplicaUser -Password $ReplPassword -Query "SHOW SLAVE STATUS\G"
            $ioRunning  = ($slaveStatus -match "Slave_IO_Running:\s*Yes")
            $sqlRunning = ($slaveStatus -match "Slave_SQL_Running:\s*Yes")
            if (-not $ioRunning -or -not $sqlRunning) {
                $needReseed = $true
            }
        } else {
            Write-Log "Master is reachable. Trying restart..." "Yellow"
            Invoke-MySql -HostName $ReplicaHost -Port $ReplicaPort -User $ReplicaUser -Password $ReplPassword -Query "STOP SLAVE; START SLAVE;" | Out-Null
            Start-Sleep -Seconds 5
        }
    } elseif ($lastSqlError -match "Duplicate entry|duplicate key") {
        # Skip the duplicate and continue
        Write-Log "Duplicate key error — skipping and continuing..." "Yellow"
        Invoke-MySql -HostName $ReplicaHost -Port $ReplicaPort -User $ReplicaUser -Password $ReplPassword -Query "SET GLOBAL SQL_SLAVE_SKIP_COUNTER=1; START SLAVE;" | Out-Null
        Start-Sleep -Seconds 3
    } else {
        $needReseed = $true
    }
}

# Re-check after potential fixes
if (-not $needReseed) {
    $slaveStatus = Invoke-MySql -HostName $ReplicaHost -Port $ReplicaPort -User $ReplicaUser -Password $ReplPassword -Query "SHOW SLAVE STATUS\G"
    $ioRunning  = ($slaveStatus -match "Slave_IO_Running:\s*Yes")
    $sqlRunning = ($slaveStatus -match "Slave_SQL_Running:\s*Yes")
    $secsBehind = if ($slaveStatus -match "Seconds_Behind_Master:\s*(\d+)") { [int]$Matches[1] } else { -1 }
}

if (-not $needReseed -and $ioRunning -and $sqlRunning) {
    if ($secsBehind -eq 0) {
        Write-Log "Replication is HEALTHY and caught up. Nothing to do." "Green"
        Save-Log
        exit 0
    }
    
    Write-Log "Replication is running but $secsBehind seconds behind. Waiting for catch-up..." "Yellow"
    
    # Wait up to CatchUpTimeoutMins for catch-up
    $deadline = (Get-Date).AddMinutes($CatchUpTimeoutMins)
    while ((Get-Date) -lt $deadline) {
        Start-Sleep -Seconds 30
        $slaveStatus = Invoke-MySql -HostName $ReplicaHost -Port $ReplicaPort -User $ReplicaUser -Password $ReplPassword -Query "SHOW SLAVE STATUS\G"
        $ioRunning  = ($slaveStatus -match "Slave_IO_Running:\s*Yes")
        $sqlRunning = ($slaveStatus -match "Slave_SQL_Running:\s*Yes")
        $secsBehind = if ($slaveStatus -match "Seconds_Behind_Master:\s*(\d+)") { [int]$Matches[1] } else { -1 }
        
        Write-Log "  Still catching up... ${secsBehind}s behind" "Gray"
        
        if (-not $ioRunning -or -not $sqlRunning) {
            Write-Log "Replication broke during catch-up." "Red"
            $needReseed = $true
            break
        }
        if ($secsBehind -eq 0) {
            Write-Log "Replication CAUGHT UP! ($(Get-Date -Format 'HH:mm:ss'))" "Green"
            Save-Log
            exit 0
        }
    }
    
    if (-not $needReseed) {
        Write-Log "TIMEOUT: Still behind after ${CatchUpTimeoutMins}min. Re-seeding." "Yellow"
        $needReseed = $true
    }
}

# =============================================================================
# STEP 4: RE-SEED (full resync from master)
# =============================================================================
if ($needReseed) {
    Write-Log "=====================================" "Yellow"
    Write-Log "  RE-SEEDING REPLICA FROM MASTER" "Yellow"
    Write-Log "  This may take a while for large DBs" "Yellow"
    Write-Log "=====================================" "Yellow"
    
    # 4a. Test master connectivity
    Write-Log "Testing master connectivity..." "Gray"
    if (-not (Test-MySqlConnection -HostName $MasterHost -Port $MasterPort -User $ReplUser -Password $ReplPassword)) {
        Write-Log "FATAL: Cannot reach master at ${MasterHost}:${MasterPort}" "Red"
        Write-Log "Check Pangolin tunnel and master server status." "Red"
        Save-Log
        exit 2
    }
    Write-Log "Master is reachable." "Green"
    
    # 4b. Get master binlog position
    $masterStatus = Invoke-MySql -HostName $MasterHost -Port $MasterPort -User $ReplUser -Password $ReplPassword -Query "SHOW MASTER STATUS;"
    $masterLogFile = ""
    $masterLogPos  = ""
    $lines = $masterStatus -split "`r`n"
    if ($lines.Count -ge 2) {
        $fields = $lines[1] -split "`t"
        $masterLogFile = $fields[0].Trim()
        $masterLogPos  = $fields[1].Trim()
        Write-Log "Master binlog: $masterLogFile @ $masterLogPos" "Gray"
    } else {
        Write-Log "WARNING: Could not parse SHOW MASTER STATUS. Using MASTER_AUTO_POSITION=1." "Yellow"
    }
    
    # 4c. Stop slave
    Write-Log "Stopping slave..." "Gray"
    Invoke-MySql -HostName $ReplicaHost -Port $ReplicaPort -User $ReplicaUser -Password $ReplPassword -Query "STOP SLAVE; RESET SLAVE ALL;" | Out-Null
    
    # 4d. Create mysqldump from master
    $dumpFile = Join-Path $WorkDir "helianz_reseed_$(Get-Date -Format 'yyyyMMdd_HHmmss').sql"
    Write-Log "Creating mysqldump from master (this may take 10-30 minutes)..." "Yellow"
    
    $dumpExe = Get-MySqlExe "mysqldump"
    $dumpArgs = @(
        "-h", $MasterHost,
        "-P", $MasterPort,
        "-u", $ReplUser,
        "-p$ReplPassword",
        "--single-transaction",
        "--master-data=2",
        "--databases", $Database,
        "--default-character-set=utf8mb4",
        "--result-file=`"$dumpFile`""
    )
    
    $dumpWatch = [System.Diagnostics.Stopwatch]::StartNew()
    & $dumpExe $dumpArgs
    $dumpWatch.Stop()
    
    if ($LASTEXITCODE -ne 0) {
        Write-Log "FATAL: mysqldump failed. Check master connectivity." "Red"
        Save-Log
        exit 3
    }
    
    $dumpSize = "{0:N0} MB" -f ((Get-Item $dumpFile).Length / 1MB)
    Write-Log "Dump completed: $dumpFile ($dumpSize) in $([math]::Round($dumpWatch.Elapsed.TotalMinutes,1)) min" "Green"
    
    # 4e. Drop and recreate the database on replica
    Write-Log "Recreating database on replica..." "Gray"
    Invoke-MySql -HostName $ReplicaHost -Port $ReplicaPort -User $ReplicaUser -Password $ReplPassword -Query "DROP DATABASE IF EXISTS $Database; CREATE DATABASE $Database;" | Out-Null
    
    # 4f. Import dump
    Write-Log "Importing dump into replica..." "Yellow"
    $mysqlExe = Get-MySqlExe "mysql"
    $importWatch = [System.Diagnostics.Stopwatch]::StartNew()
    $importCmd = "`"$mysqlExe`" -h $ReplicaHost -P $ReplicaPort -u $ReplicaUser -p$ReplPassword < `"$dumpFile`""
    cmd /c $importCmd
    $importWatch.Stop()
    
    if ($LASTEXITCODE -ne 0) {
        Write-Log "WARNING: Import may have had errors. Check log." "Yellow"
    }
    Write-Log "Import completed in $([math]::Round($importWatch.Elapsed.TotalMinutes,1)) min" "Green"
    
    # 4g. Re-establish replication
    Write-Log "Re-establishing replication..." "Gray"
    if ($masterLogFile -and $masterLogPos) {
        Invoke-MySql -HostName $ReplicaHost -Port $ReplicaPort -User $ReplicaUser -Password $ReplPassword -Query @"
CHANGE MASTER TO
    MASTER_HOST             = '$MasterHost',
    MASTER_PORT             = $MasterPort,
    MASTER_USER             = '$ReplUser',
    MASTER_PASSWORD         = '$ReplPassword',
    MASTER_LOG_FILE         = '$masterLogFile',
    MASTER_LOG_POS          = $masterLogPos;
START SLAVE;
"@ | Out-Null
    } else {
        # Fallback: try GTID mode
        Invoke-MySql -HostName $ReplicaHost -Port $ReplicaPort -User $ReplicaUser -Password $ReplPassword -Query @"
CHANGE MASTER TO
    MASTER_HOST             = '$MasterHost',
    MASTER_PORT             = $MasterPort,
    MASTER_USER             = '$ReplUser',
    MASTER_PASSWORD         = '$ReplPassword',
    MASTER_AUTO_POSITION    = 1;
START SLAVE;
"@ | Out-Null
    }
    Start-Sleep -Seconds 3
    
    # 4h. Re-create read-only user (dropped with database)
    Write-Log "Re-creating read-only user..." "Gray"
    if ($RoPassword) {
        Invoke-MySql -HostName $ReplicaHost -Port $ReplicaPort -User $ReplicaUser -Password $ReplPassword -Query @"
CREATE USER IF NOT EXISTS '$RoUser'@'%' IDENTIFIED BY '$RoPassword';
GRANT SELECT, EXECUTE ON ${Database}.* TO '$RoUser'@'%';
FLUSH PRIVILEGES;
"@ | Out-Null
    }
    
    # 4i. Verify
    Start-Sleep -Seconds 2
    $slaveStatus = Invoke-MySql -HostName $ReplicaHost -Port $ReplicaPort -User $ReplicaUser -Password $ReplPassword -Query "SHOW SLAVE STATUS\G"
    $ioRunning  = ($slaveStatus -match "Slave_IO_Running:\s*Yes")
    $sqlRunning = ($slaveStatus -match "Slave_SQL_Running:\s*Yes")
    
    if ($ioRunning -and $sqlRunning) {
        Write-Log "RE-SEED COMPLETE. Replication is running!" "Green"
    } else {
        Write-Log "WARNING: Replication may not be healthy after re-seed. Check manually." "Red"
        Write-Log $slaveStatus "Red"
    }
}

# =============================================================================
# CLEANUP
# =============================================================================
# Remove old dumps (keep only last 3)
$oldDumps = Get-ChildItem -Path $WorkDir -Filter "helianz_reseed_*.sql" | Sort-Object LastWriteTime -Descending | Select-Object -Skip 3
foreach ($f in $oldDumps) {
    Remove-Item $f.FullName -Force
    Write-Log "Cleaned up old dump: $($f.Name)" "Gray"
}

Save-Log
Write-Log "Sync complete." "Cyan"
exit 0

function Save-Log {
    $script:LogLines | Out-File -FilePath $logFile -Encoding UTF8
    # Also keep a rolling log
    $rollingLog = Join-Path $WorkDir "replica_sync_latest.log"
    $script:LogLines | Out-File -FilePath $rollingLog -Encoding UTF8
}
