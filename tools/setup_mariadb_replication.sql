-- =============================================================================
-- setup_mariadb_replication.sql
-- =============================================================================
-- MariaDB Master-Slave Replication Setup for Helianz (WINDOWS VERSION)
-- 
-- PURPOSE:
--   Offload read queries (SELECT) to replica(s) to reduce load on the master.
--   Helianz already supports ReadOnlyServer and ReportingServer connections.
--
-- PREREQUISITES:
--   - MariaDB 10.3+ or MySQL 8.0+ on both master and replica (Windows)
--   - Network connectivity between master (port 3306) and replica
--   - Root access to both servers
--   - Sufficient disk space on replica (same size as master database)
--   - Firewall: open port 3306 on BOTH servers for each other's IP
--
-- WINDOWS CONFIG PATHS (find your actual file):
--   MariaDB:  C:\Program Files\MariaDB 10.x\data\my.ini
--   MySQL 8:  C:\ProgramData\MySQL\MySQL Server 8.0\my.ini
--   XAMPP:    C:\xampp\mysql\bin\my.ini
--
-- RESTART SERVICE (PowerShell as Admin):
--   Restart-Service MariaDB
--   Restart-Service MySQL80
--   OR: net stop MariaDB && net start MariaDB
--
-- USAGE:
--   Run STEP 1 on the MASTER server as root.
--   Run STEP 2 to take a backup for the replica.
--   Run STEP 3 on the REPLICA server as root.
-- =============================================================================


-- =============================================================================
-- STEP 1: CONFIGURE THE MASTER SERVER (run on MASTER)
-- =============================================================================
-- 1a. Edit your my.ini file (typical locations listed above).
--     Add these lines under the [mysqld] section:
--
--   [mysqld]
--   server-id               = 1
--   log-bin                 = mysql-bin
--   binlog_format           = ROW
--   expire_logs_days        = 7
--   max_binlog_size         = 100M
--   binlog_do_db            = helianz
--   gtid_domain_id          = 1
--   binlog_ignore_db        = mysql,performance_schema,information_schema
--
-- 1b. Save my.ini, then restart the service as Administrator:
--     PowerShell:  Restart-Service MariaDB
--     CMD:         net stop MariaDB && net start MariaDB
--
-- 1c. Now run the SQL below to create the replication user:

-- Create a dedicated replication user on the MASTER:
-- Only needs REPLICATION SLAVE + REPLICATION CLIENT privileges.
CREATE USER IF NOT EXISTS 'repl_user'@'%' IDENTIFIED BY 'ReplStr0ngP@ss!';
GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'repl_user'@'%';
FLUSH PRIVILEGES;

-- Verify binary logging is enabled:
SHOW VARIABLES LIKE 'log_bin';
SHOW VARIABLES LIKE 'binlog_format';
SHOW MASTER STATUS;
-- ⚠️ WRITE DOWN the File and Position values (e.g. mysql-bin.000003 / 157)
--    You will need them in STEP 3.


-- =============================================================================
-- STEP 2: BACKUP THE MASTER FOR INITIAL REPLICA SEED
-- =============================================================================
-- Run from PowerShell or CMD on the MASTER (NOT inside mysql client):
--
--   cd "C:\Program Files\MariaDB 10.6\bin"
--   .\mysqldump.exe -u root -p --single-transaction --master-data=2 --databases helianz > C:\temp\helianz_replica_seed.sql
--
-- Transfer the dump to the replica server via network share:
--   copy C:\temp\helianz_replica_seed.sql \\REPLICA-PC\c$\temp\
--
-- Or use a USB drive / shared folder.


-- =============================================================================
-- STEP 3: CONFIGURE THE REPLICA SERVER (run on REPLICA)
-- =============================================================================
-- 3a. Edit the my.ini file on the REPLICA. Add under [mysqld]:
--
--   [mysqld]
--   server-id               = 2
--   relay-log               = relay-bin
--   read_only               = ON
--   log_slave_updates       = ON
--   gtid_domain_id          = 1
--
-- 3b. Save my.ini, then restart the service as Administrator:
--     PowerShell:  Restart-Service MariaDB
--     CMD:         net stop MariaDB && net start MariaDB
--
-- 3c. Import the master dump on the REPLICA:
--     From PowerShell or CMD:
--     cd "C:\Program Files\MariaDB 10.6\bin"
--     .\mysql.exe -u root -p < C:\temp\helianz_replica_seed.sql
--
-- 3d. Now run the SQL below on the REPLICA:

-- ⚠️ Replace MASTER_HOST, MASTER_LOG_FILE, MASTER_LOG_POS with your actual values!
CHANGE MASTER TO
    MASTER_HOST             = '192.168.1.10',          -- ← YOUR master IP
    MASTER_PORT             = 3306,
    MASTER_USER             = 'repl_user',
    MASTER_PASSWORD         = 'ReplStr0ngP@ss!',
    MASTER_LOG_FILE         = 'mysql-bin.000003',      -- ← from SHOW MASTER STATUS
    MASTER_LOG_POS          = 157;                      -- ← from SHOW MASTER STATUS

START SLAVE;

-- Verify replication is working:
SHOW SLAVE STATUS\G
-- Check these fields MUST all show:
--   Slave_IO_Running:     Yes
--   Slave_SQL_Running:    Yes
--   Seconds_Behind_Master: 0 (or near 0)
--
-- If Slave_IO_Running is "Connecting", check:
--   - Firewall on master allows port 3306 from replica IP
--   - repl_user password is correct
--   - Master server is reachable via ping


-- =============================================================================
-- STEP 4: CREATE READ-ONLY HELIANZ USER ON THE REPLICA
-- =============================================================================
-- Run on the REPLICA. This user is used by Helianz for read queries.
-- Only SELECT privilege is needed since the replica is read-only.
CREATE USER IF NOT EXISTS 'oduser_ro'@'%' IDENTIFIED BY 'YourReadOnlyP@ss!';
GRANT SELECT, EXECUTE ON helianz.* TO 'oduser_ro'@'%';
FLUSH PRIVILEGES;


-- =============================================================================
-- STEP 5: VERIFY REPLICATION HEALTH (run periodically)
-- =============================================================================
-- On the REPLICA:
SHOW SLAVE STATUS\G
-- Check: Slave_IO_Running, Slave_SQL_Running, Seconds_Behind_Master

-- On the MASTER - see connected replicas:
SHOW SLAVE HOSTS;
SHOW PROCESSLIST;
