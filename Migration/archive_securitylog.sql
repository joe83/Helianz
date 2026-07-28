-- ============================================================================
-- Auto-archive securitylog rows older than 2 years to securitylog_archive
-- Run this manually or schedule via MySQL EVENT / cron / Task Scheduler
-- ============================================================================

-- 1. Ensure archive table exists (same schema, no auto_increment)
CREATE TABLE IF NOT EXISTS securitylog_archive LIKE securitylog;
ALTER TABLE securitylog_archive MODIFY SecurityLogNum bigint(20) NOT NULL;

-- 2. Copy old rows to archive (ignore duplicates if re-run)
INSERT IGNORE INTO securitylog_archive
SELECT * FROM securitylog
WHERE LogDateTime < DATE_SUB(NOW(), INTERVAL 2 YEAR);

-- 3. Delete archived rows from active table
DELETE FROM securitylog
WHERE LogDateTime < DATE_SUB(NOW(), INTERVAL 2 YEAR);

-- 4. Optimize (optional, reclaims disk space)
-- OPTIMIZE TABLE securitylog;


-- ============================================================================
-- Optional: Schedule as MySQL EVENT (runs daily at 3 AM)
-- Uncomment below to enable:
-- ============================================================================
/*
DROP EVENT IF EXISTS evt_archive_securitylog;

CREATE EVENT evt_archive_securitylog
ON SCHEDULE EVERY 1 DAY
STARTS CONCAT(CURDATE(), ' 03:00:00')
DO
BEGIN
    INSERT IGNORE INTO securitylog_archive
    SELECT * FROM securitylog
    WHERE LogDateTime < DATE_SUB(NOW(), INTERVAL 2 YEAR);

    DELETE FROM securitylog
    WHERE LogDateTime < DATE_SUB(NOW(), INTERVAL 2 YEAR);
END;

-- Enable MySQL event scheduler:
-- SET GLOBAL event_scheduler = ON;
*/
