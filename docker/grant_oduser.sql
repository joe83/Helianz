-- =============================================================================
-- grant_oduser.sql  –  Create / update the MySQL user for HelianzServer
-- =============================================================================
-- Run this script as the MySQL root user:
--   mysql -u root -p < grant_oduser.sql
--
-- SECURITY NOTE:
--   These grants are scoped to the 'helianz' database only.
--   The oduser account does NOT have access to mysql.* or other databases.
--   All access is restricted to 'localhost' only — MySQL never faces the network.
--   Clinics connect via HelianzServer SOAP, not directly to MySQL.
-- =============================================================================

-- Revoke any existing overly-broad grants (cleanup from older config with @'%')
REVOKE ALL PRIVILEGES ON *.* FROM 'oduser'@'%';
REVOKE ALL PRIVILEGES ON *.* FROM 'oduser'@'localhost';

-- Grant only what HelianzServer needs on the helianz database (localhost only)
GRANT SELECT, INSERT, UPDATE, DELETE,
      CREATE, ALTER, INDEX,
      CREATE TEMPORARY TABLES,
      LOCK TABLES,
      EXECUTE
ON helianz.* TO 'oduser'@'localhost';

FLUSH PRIVILEGES;
