-- ============================================================================
-- Cdental → Helianz Data Migration Script
-- ============================================================================
-- Source: Cdental database (OpenDental 11.0.53, DB version 11.0.36.0)
-- Target: Helianz database (OpenDental 24.3.49)
--
-- Strategy:
--   1. Drop the existing helianz database (it's nearly empty - only test data)
--   2. Create a fresh helianz database
--   3. Import the full Cdental database dump (schema + data at v11.0.36)
--   4. When Helianz/OpenDental 24.3.49 starts, it detects DataBaseVersion=11.0.36.0
--      and automatically runs ALL conversion steps from 11.0.36 → 24.3.49
--
-- The OpenDental ConvertDatabases chain handles:
--   - Column additions/removals/renames
--   - Table alterations
--   - Data transformations
--   - New table creation
--   - Index changes
--   All the way from v2.8.2 to v24.3.49
-- ============================================================================

-- Step 0: Create full backup of both databases before any changes
-- IMPORTANT: Run these commands from the command line, not from within mysql

-- === BACKUP COMMANDS (run from shell) ===
-- mysqldump -u root -p"J0k0m4r0k3@" --databases helianz > "D:\Backup\Lecylia IT and Software\Cdental\helianz_backup_before_migration.sql"
-- mysqldump -u root -p"J0k0m4r0k3@" --databases cdental > "D:\Backup\Lecylia IT and Software\Cdental\cdental_full_backup.sql"

-- ============================================================================
-- STEP 1: Drop and recreate helianz database with cdental data
-- ============================================================================

DROP DATABASE IF EXISTS helianz;
CREATE DATABASE helianz CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- ============================================================================
-- STEP 2: Import cdental data into helianz
-- This is done via shell command:
-- mysqldump -u root -p"J0k0m4r0k3@" --skip-add-drop-table --skip-add-locks
--   --single-transaction --routines --triggers --events
--   cdental | mysql -u root -p"J0k0m4r0k3@" helianz
--
-- Then update the database name references in preference table
-- ============================================================================

-- After import, verify the database version is correct
SELECT PrefName, ValueString FROM preference WHERE PrefName = 'DataBaseVersion';
-- Expected: 11.0.36.0

-- ============================================================================
-- STEP 3: Remove the Cdental registration system artifacts
-- The modifier added a FormRegister that writes to Windows Registry (HKCU\Software\LyX)
-- This is NOT stored in MySQL, so nothing to clean in the database.
-- However, there may be a RegistrationKey preference to clean up.
-- ============================================================================

-- Check for registration-related preferences
SELECT * FROM preference WHERE PrefName LIKE '%Registration%' OR PrefName LIKE '%RegKey%';

-- ============================================================================
-- STEP 4: Update FreeDentalConfig.xml to point to helianz database
-- This is done outside of SQL - the config already points to helianz
-- ============================================================================

-- ============================================================================
-- STEP 5: Launch Helianz/OpenDental 24.3.49
-- The program will:
--   1. Read DataBaseVersion = 11.0.36.0 from preference table
--   2. Detect it's older than current version 24.3.49
--   3. Run ConvertDatabases.InvokeConvertMethods() which chains through:
--      To2_8_2 → To2_8_3 → ... → To11_0_1 → ... → To24_3_49
--   4. Update DataBaseVersion to 24.3.49.0
--   5. Start normally with all migrated data
-- ============================================================================

-- ============================================================================
-- POST-MIGRATION VERIFICATION QUERIES
-- Run these after Helianz has started and completed the conversion:
-- ============================================================================

-- Verify database version has been upgraded
-- SELECT ValueString FROM preference WHERE PrefName = 'DataBaseVersion';
-- Expected: 24.3.49.0

-- Verify patient count
-- SELECT COUNT(*) FROM patient;

-- Verify procedure log count
-- SELECT COUNT(*) FROM procedurelog;

-- Verify appointment count
-- SELECT COUNT(*) FROM appointment;

-- Check for any conversion errors
-- SELECT * FROM preference WHERE PrefName = 'CorruptedDatabase';
-- Expected: ValueString = 0 (false)

