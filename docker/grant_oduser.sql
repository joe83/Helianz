-- =============================================================================
-- grant_oduser.sql  –  Create / update the MySQL user for HelianzServer
-- =============================================================================
-- Run this script as the MySQL root user:
--   mysql -u root -p < grant_oduser.sql
--
-- SECURITY NOTE:
--   These grants are scoped to the 'helianz' database only.
--   The oduser account does NOT have access to mysql.* or other databases.
--   If you need to tighten host access, replace '%' with a specific hostname/IP.
-- =============================================================================

-- Revoke any existing overly-broad grants (cleanup from older config)
REVOKE ALL PRIVILEGES ON *.* FROM 'oduser'@'%';

-- Grant only what HelianzServer needs on the helianz database
GRANT SELECT, INSERT, UPDATE, DELETE,
      CREATE, ALTER, INDEX,
      CREATE TEMPORARY TABLES,
      LOCK TABLES,
      EXECUTE
ON helianz.* TO 'oduser'@'%';

FLUSH PRIVILEGES;
