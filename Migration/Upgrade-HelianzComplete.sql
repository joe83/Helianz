-- ============================================================================
-- Helianz Post-Upgrade Completer Script
-- ============================================================================
-- Purpose: Converts an "incomplete" helianz database (freshly auto-upgraded 
--          from cdental/OD11 -> OD24) into a fully functional Helianz database
--          with proper groups, permissions, branding, and user assignments.
--
-- Use: Run this AFTER the Helianz app has completed its automatic schema 
--      upgrade (ConvertDatabases chain from 11.0.36 -> 24.3.49).
--
-- IMPORTANT: This script is idempotent - safe to run multiple times.
-- Run: mysql -u root -p"password" helianz < Upgrade-HelianzComplete.sql
-- ============================================================================

-- ============================================================================
-- STEP 0: ENSURE IDEMPOTENCY - add unique indexes to prevent duplicate inserts
-- ============================================================================
-- grouppermission and usergroupattach have auto-increment PKs but no unique
-- constraint on their business keys. Without a unique index, INSERT IGNORE
-- cannot detect duplicates. We add business-key indexes so INSERT IGNORE
-- will skip rows that already exist on subsequent runs.
-- If duplicates already exist from prior runs, we clean only those exact
-- duplicates (keeping the oldest row) so the index can be created.

-- grouppermission: deduplicate then add unique index
DELETE g1 FROM grouppermission g1
INNER JOIN grouppermission g2 
WHERE g1.GroupPermNum > g2.GroupPermNum 
  AND g1.UserGroupNum = g2.UserGroupNum 
  AND g1.PermType = g2.PermType 
  AND g1.FKey = g2.FKey;
SET @sql_gp = IF(
    (SELECT COUNT(*) FROM information_schema.statistics 
     WHERE table_schema=DATABASE() AND table_name='grouppermission' AND index_name='idx_gp_bizkey') = 0,
    'ALTER TABLE grouppermission ADD UNIQUE INDEX idx_gp_bizkey (UserGroupNum, PermType, FKey)',
    'SELECT ''idx_gp_bizkey already exists'' AS msg'
);
PREPARE stmt FROM @sql_gp; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- usergroupattach: deduplicate then add unique index
DELETE ua1 FROM usergroupattach ua1
INNER JOIN usergroupattach ua2
WHERE ua1.UserGroupAttachNum > ua2.UserGroupAttachNum
  AND ua1.UserNum = ua2.UserNum
  AND ua1.UserGroupNum = ua2.UserGroupNum;
SET @sql_ua = IF(
    (SELECT COUNT(*) FROM information_schema.statistics
     WHERE table_schema=DATABASE() AND table_name='usergroupattach' AND index_name='idx_ua_bizkey') = 0,
    'ALTER TABLE usergroupattach ADD UNIQUE INDEX idx_ua_bizkey (UserNum, UserGroupNum)',
    'SELECT ''idx_ua_bizkey already exists'' AS msg'
);
PREPARE stmt FROM @sql_ua; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SELECT 'Idempotency indexes ensured' AS Status;

-- ============================================================================
-- STEP 1: ADD MISSING USER GROUPS (5-12)
-- ============================================================================
-- The cdental database only has groups 1-3. Helianz adds 8 more role-based groups.
INSERT IGNORE INTO usergroup (UserGroupNum, Description) VALUES 
(5, 'G_SYS_SECURITY_ADMIN'),
(6, 'G_BRANCH_MANAGER'),
(7, 'G_FRONT_DESK'),
(8, 'G_DENTIST'),
(9, 'G_HYGIENIST'),
(10, 'G_DENTAL_ASSISTANT'),
(11, 'G_BILLING_AR'),
(12, 'G_READONLY_AUDITOR');

SELECT CONCAT('Groups added: ', ROW_COUNT()) AS Status;

-- ============================================================================
-- STEP 2: ADD MISSING PERMISSIONS FOR EXISTING GROUPS (Group 2 - Regular Users)
-- ============================================================================
-- The auto-upgrade adds base permissions but misses many feature-level perms.
-- Group 2 (Regular Users) needs permissions beyond PermType 44.
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(2,45,0,'0001-01-01',0), (2,46,0,'0001-01-01',0),
(2,53,0,'0001-01-01',0), (2,54,0,'0001-01-01',0),
(2,56,0,'0001-01-01',0), (2,57,0,'0001-01-01',0),
(2,58,0,'0001-01-01',0), (2,59,0,'0001-01-01',0),
(2,60,0,'0001-01-01',0), (2,62,0,'0001-01-01',0),
(2,66,0,'0001-01-01',0), (2,71,0,'0001-01-01',0),
(2,72,0,'0001-01-01',0), (2,73,0,'0001-01-01',0),
(2,79,0,'0001-01-01',0), (2,82,0,'0001-01-01',0),
(2,84,0,'0001-01-01',0), (2,85,0,'0001-01-01',0),
(2,86,0,'0001-01-01',0), (2,88,0,'0001-01-01',0),
(2,89,0,'0001-01-01',0), (2,96,0,'0001-01-01',0),
(2,103,0,'0001-01-01',0), (2,104,0,'0001-01-01',0),
(2,105,0,'0001-01-01',0), (2,107,0,'0001-01-01',0),
(2,108,0,'0001-01-01',0), (2,110,0,'0001-01-01',0),
(2,115,0,'0001-01-01',0), (2,118,0,'0001-01-01',0),
(2,119,0,'0001-01-01',0), (2,120,0,'0001-01-01',0),
(2,123,0,'0001-01-01',0), (2,127,0,'0001-01-01',0),
(2,129,0,'0001-01-01',0), (2,130,0,'0001-01-01',0),
(2,131,0,'0001-01-01',0), (2,132,0,'0001-01-01',0),
(2,133,0,'0001-01-01',0), (2,134,0,'0001-01-01',0),
(2,136,0,'0001-01-01',0), (2,138,0,'0001-01-01',0),
(2,139,0,'0001-01-01',0), (2,141,0,'0001-01-01',0),
(2,142,0,'0001-01-01',0), (2,143,0,'0001-01-01',0),
(2,144,0,'0001-01-01',0), (2,145,0,'0001-01-01',0),
(2,146,0,'0001-01-01',0), (2,147,0,'0001-01-01',0),
(2,149,0,'0001-01-01',0), (2,159,0,'0001-01-01',0),
(2,160,0,'0001-01-01',0), (2,162,0,'0001-01-01',0),
(2,165,0,'0001-01-01',0), (2,169,0,'0001-01-01',0),
(2,173,0,'0001-01-01',0), (2,174,0,'0001-01-01',1),  -- NewerDays=1 intentional
(2,181,0,'0001-01-01',0), (2,182,0,'0001-01-01',0),
(2,192,0,'0001-01-01',0), (2,193,0,'0001-01-01',0),
(2,199,0,'0001-01-01',0), (2,200,0,'0001-01-01',0),
(2,201,0,'0001-01-01',0), (2,202,0,'0001-01-01',0),
(2,203,0,'0001-01-01',0), (2,204,0,'0001-01-01',0),
(2,206,0,'0001-01-01',0), (2,208,0,'0001-01-01',0),
(2,214,0,'0001-01-01',0), (2,215,0,'0001-01-01',0),
(2,217,0,'0001-01-01',0), (2,218,0,'0001-01-01',0),
(2,219,0,'0001-01-01',0), (2,224,0,'0001-01-01',0),
(2,237,0,'0001-01-01',0), (2,238,0,'0001-01-01',0),
(2,242,0,'0001-01-01',0), (2,245,0,'0001-01-01',0),
(2,247,0,'0001-01-01',0), (2,249,0,'0001-01-01',0),
(2,252,0,'0001-01-01',0), (2,253,0,'0001-01-01',0),
(2,257,0,'0001-01-01',0), (2,259,0,'0001-01-01',0),
(2,260,0,'0001-01-01',0), (2,263,0,'0001-01-01',0);

-- Add Group 1 (Admin) extra perms beyond auto-upgrade baseline
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(1,22,44,'0001-01-01',0), (1,22,45,'0001-01-01',0), (1,22,46,'0001-01-01',0);

-- ============================================================================
-- STEP 3: ADD PERMISSIONS FOR NEW GROUPS (5-12)
-- ============================================================================
-- PermType 22 (Reports) - FKey=0 means global report access
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(5,22,0,'0001-01-01',0),
(6,22,0,'0001-01-01',0),
(7,22,0,'0001-01-01',0),
(8,22,0,'0001-01-01',0),
(9,22,0,'0001-01-01',0),
(11,22,0,'0001-01-01',0),
(12,22,0,'0001-01-01',0);

-- PermType 8 (Setup) - global
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(5,8,0,'0001-01-01',0);

-- PermType 24 (SecurityAdmin) - global
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(5,24,0,'0001-01-01',0);

-- PermType 12 (Schedules) - global for group 8 (Dentist)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(8,12,0,'0001-01-01',0);

-- PermType 2 (Family Module) - for front desk + dentist
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(7,2,0,'0001-01-01',0),
(8,2,0,'0001-01-01',0);

-- PermType 3 (Account Module)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(7,3,0,'0001-01-01',0),
(8,3,0,'0001-01-01',0),
(11,3,0,'0001-01-01',0);

-- PermType 4 (Treatment Plan Module)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(8,4,0,'0001-01-01',0);

-- PermType 5 (Chart Module)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(7,5,0,'0001-01-01',0),
(8,5,0,'0001-01-01',0),
(9,5,0,'0001-01-01',0);

-- PermType 6 (Imaging Module)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(8,6,0,'0001-01-01',0);

-- PermType 7 (Manage Module)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(7,7,0,'0001-01-01',0),
(8,7,0,'0001-01-01',0);

-- PermType 10 (ProcComplEdit)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(8,10,0,'0001-01-01',0);

-- PermType 13 (Blockouts)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(7,13,0,'0001-01-01',0),
(8,13,0,'0001-01-01',0);

-- PermType 15 (Payment Create)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(7,15,0,'0001-01-01',0),
(11,15,0,'0001-01-01',0);

-- PermType 16 (Payment Edit)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(11,16,0,'0001-01-01',0);

-- PermType 17 (Adjustment Create)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(7,17,0,'0001-01-01',0),
(11,17,0,'0001-01-01',0);

-- PermType 18 (Adjustment Edit)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(11,18,0,'0001-01-01',0);

-- PermType 23 (ProcComplCreate)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(7,23,0,'0001-01-01',0),
(8,23,0,'0001-01-01',0);

-- PermType 25 (Appointment Create)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(7,25,0,'0001-01-01',0),
(8,25,0,'0001-01-01',0);

-- PermType 26 (Appointment Move)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(7,26,0,'0001-01-01',0),
(8,26,0,'0001-01-01',0);

-- PermType 27 (Appointment Edit)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(7,27,0,'0001-01-01',0),
(8,27,0,'0001-01-01',0);

-- PermType 30 (Deposit Slips)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(11,30,0,'0001-01-01',0);

-- PermType 31 (Accounting Edit Entry)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(11,31,0,'0001-01-01',0);

-- PermType 32 (Accounting Create Entry)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(11,32,0,'0001-01-01',0);

-- PermType 33 (Accounting)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(11,33,0,'0001-01-01',0);

-- PermType 39 (ReportProdInc - deprecated but present)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(7,39,0,'0001-01-01',0),
(8,39,0,'0001-01-01',0);

-- PermType 42 (Sheet Edit)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(8,42,0,'0001-01-01',0);

-- PermType 43 (Commlog Edit)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(7,43,0,'0001-01-01',0),
(8,43,0,'0001-01-01',0);

-- PermType 44 (Image Delete)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(8,44,0,'0001-01-01',0);

-- PermType 49 (Proc Delete)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(8,49,0,'0001-01-01',0);

-- PermType 51 (Provider Edit)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(5,51,0,'0001-01-01',0),
(7,51,0,'0001-01-01',0),
(8,51,0,'0001-01-01',0);

-- PermType 53 (Procedure Note Full)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(8,53,0,'0001-01-01',0);

-- PermType 54 (Referral Add)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(8,54,0,'0001-01-01',0);

-- PermType 55 (Ins Plan Change Subscriber)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(11,55,0,'0001-01-01',0);

-- PermType 56 (Ref Attach Add)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(7,56,0,'0001-01-01',0),
(8,56,0,'0001-01-01',0);

-- PermType 57 (Ref Attach Delete)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(7,57,0,'0001-01-01',0),
(8,57,0,'0001-01-01',0);

-- PermType 61 (Equipment Setup)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(5,61,0,'0001-01-01',0);

-- PermType 62 (Billing)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(11,62,0,'0001-01-01',0);

-- PermType 63 (Problem Def Edit)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(8,63,0,'0001-01-01',0);

-- PermType 66 (Task Note Edit)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(7,66,0,'0001-01-01',0),
(8,66,0,'0001-01-01',0);

-- PermType 67 (Wiki List Setup)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(5,67,0,'0001-01-01',0);

-- PermType 71 (Pat Problem List Edit)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(8,71,0,'0001-01-01',0);

-- PermType 72 (Medication Pat Edit)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(8,72,0,'0001-01-01',0);

-- PermType 73 (Allergy Edit)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(8,73,0,'0001-01-01',0);

-- PermType 76 (EHR Lab Edit)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(8,76,0,'0001-01-01',0);

-- PermType 79 (EHR Measure Edit)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(8,79,0,'0001-01-01',0);

-- Add remaining higher-numbered perms for group 8 (Dentist)
INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays) VALUES
(8,82,0,'0001-01-01',0), (8,84,0,'0001-01-01',0), (8,85,0,'0001-01-01',0),
(8,86,0,'0001-01-01',0), (8,88,0,'0001-01-01',0), (8,89,0,'0001-01-01',0),
(8,91,0,'0001-01-01',0), (8,92,0,'0001-01-01',0), (8,93,0,'0001-01-01',0),
(8,94,0,'0001-01-01',0), (8,96,0,'0001-01-01',0), (8,99,0,'0001-01-01',0),
(8,100,0,'0001-01-01',0), (8,102,0,'0001-01-01',0);

SELECT CONCAT('Permissions added: ', ROW_COUNT()) AS Status;

-- ============================================================================
-- STEP 4: FIX USER GROUP ASSIGNMENTS (usergroupattach)
-- ============================================================================
-- The cdental upgrade only assigns each user to a single primary group.
-- Helianz uses multi-group assignments for proper permission inheritance.
-- This fixes the standard reports menu (PermType 22 FKey=0 is only on groups 5-12).

DELETE FROM usergroupattach;  -- Clean slate

INSERT INTO usergroupattach (UserNum, UserGroupNum) VALUES
-- Owners / Security Admins (Users 1, 7, 18)
(1, 1),  (1, 5),  (1, 11),   -- Owner: Admin + SecurityAdmin + Billing
(7, 1),  (7, 5),  (7, 8),    -- drg Prima: Admin + SecurityAdmin + Dentist
(18, 1), (18, 5), (18, 11),  -- endru: Admin + SecurityAdmin + Billing

-- Front Desk FO staff (Users 2, 8, 14, 19)
(2, 2),  (2, 7),              -- FO Fitri: Regular + FrontDesk
(8, 2),  (8, 7),              -- FO: Regular + FrontDesk
(14, 2), (14, 7),             -- FO Intan: Regular + FrontDesk
(19, 2), (19, 7),             -- FO Tiya: Regular + FrontDesk

-- Regular Users
(3, 2),                        -- BINTANG: Regular

-- Dentists (Users 4-6, 9-13, 15-16)
(4, 3),  (4, 8),              -- drg Minda: DOKTER + Dentist
(5, 3),  (5, 8),              -- drg Lintang
(6, 3),  (6, 8),              -- drg Evi
(9, 3),  (9, 8),              -- drg Adzana
(10, 3), (10, 8),             -- drg Istiqomah
(11, 3), (11, 8),             -- drg Nina
(12, 3), (12, 8),             -- drg Fadlhli
(13, 3), (13, 8),             -- drg Lucky
(15, 3), (15, 8),             -- drg Efraim
(16, 3), (16, 8),             -- drg Hanifah

-- Billing / AR (Users 17, 20)
(17, 2), (17, 11),            -- Arisna: Regular + Billing
(20, 2), (20, 11);            -- Risna: Regular + Billing

SELECT CONCAT('Group assignments fixed: ', ROW_COUNT(), ' records') AS Status;

-- ============================================================================
-- STEP 5: UPDATE PREFERENCES (Cdental → Helianz Branding)
-- ============================================================================
UPDATE preference SET ValueString = 'Helianz'        WHERE PrefName = 'MainWindowTitle';
UPDATE preference SET ValueString = 'C:\\HelianzImages' WHERE PrefName = 'DocPath';
UPDATE preference SET ValueString = 'C:/HelianzLetters/' WHERE PrefName = 'LetterMergePath';
UPDATE preference SET ValueString = 'C:/HelianzTemp/'   WHERE PrefName = 'ClaimAttachExportPath';

-- Enable Helianz features (cdental had these off)
UPDATE preference SET ValueString = '1' WHERE PrefName = 'EasyHideInsurance';
UPDATE preference SET ValueString = '1' WHERE PrefName = 'AllowSettingProcsComplete';
UPDATE preference SET ValueString = '1' WHERE PrefName = 'PatientSSNMasked';
UPDATE preference SET ValueString = '1' WHERE PrefName = 'SecurityLogOffAllowUserOverride';
UPDATE preference SET ValueString = '1' WHERE PrefName = 'AddressVerifyWithUSPS';
UPDATE preference SET ValueString = '1' WHERE PrefName = 'EmailDisclaimerIsOn';

-- Default user group for new users
UPDATE preference SET ValueString = '7' WHERE PrefName = 'DefaultUserGroup';

SELECT 'Preferences updated' AS Status;

-- ============================================================================
-- STEP 6: CLEAN CDENTAL REFERENCES FROM DEFINITIONS TABLE
-- ============================================================================
UPDATE definition SET ItemValue = REPLACE(ItemValue, 'Cdental', 'Helianz');
UPDATE definition SET ItemValue = REPLACE(ItemValue, 'cdental', 'helianz');
UPDATE definition SET ItemValue = REPLACE(ItemValue, 'CdentImages', 'HelianzImages');
UPDATE definition SET ItemValue = REPLACE(ItemValue, 'cdentimages', 'HelianzImages');

SELECT CONCAT('Definition entries cleaned: ', ROW_COUNT()) AS Status;

-- ============================================================================
-- STEP 7: CLEAN COMPUTER PREFERENCES (AtoZ Image Paths)
-- ============================================================================
UPDATE computerpref SET AtoZpath = REPLACE(AtoZpath, 'C:\\CdentImages', 'C:\\HelianzImages');
UPDATE computerpref SET AtoZpath = REPLACE(AtoZpath, 'C:\\cdentimages', 'C:\\HelianzImages');

-- ============================================================================
-- STEP 8: REMOVE CDENTAL-SPECIFIC PREFERENCES (invalid PrefName enum values)
-- ============================================================================
-- RegistrationKey and RegistrationKeyIsDisabled ARE valid Helianz PrefName values
-- and must be kept (set to empty/0). Only delete cdental-specific ones.
DELETE FROM preference WHERE PrefName = 'RegistrationNumberClaim';
SELECT CONCAT('Cdental artifacts removed: ', ROW_COUNT()) AS Status;

-- ============================================================================
-- STEP 9: HELIANZ-SPECIFIC SCHEMA ADDITIONS
-- ============================================================================
-- QueueLabel: waiting room queue ticket labels stored in appointment table for cross-PC consistency.
ALTER TABLE appointment ADD COLUMN IF NOT EXISTS QueueLabel VARCHAR(20) NOT NULL DEFAULT '';
ALTER TABLE histappointment ADD COLUMN IF NOT EXISTS QueueLabel VARCHAR(20) NOT NULL DEFAULT '';
SELECT 'Schema additions applied (QueueLabel columns)' AS Status;

-- ============================================================================
-- STEP 10: MT_SERVICE GROUP (for HelianzServer middle-tier)
-- ============================================================================
-- This group exists solely so the 'helianz' service user can log in via
-- FormCentralChooseDatabase. No grouppermission entries are needed —
-- CheckUserAndPassword only validates credentials, not permissions.
INSERT IGNORE INTO usergroup (UserGroupNum, Description) VALUES (13, 'MT_Service');
SELECT 'MT_Service group created' AS Status;

-- ============================================================================
-- STEP 11: DEFAULT USERS (Admin + helianz)
-- ============================================================================
-- Password for both users: 12345
-- Hash generated with SHA3-512 (same format as Authentication.GenerateLoginDetails)
SET @pw_hash = 'SHA3_512$l0Wg6gEuHbHwVW94JAWoMnn6xEm+VPPwozZ6TeHl0dSRWpi3RyB1rPsbbJlGgWPdGEglIpiwZiEAPDYvJSG9cg==$BRcdWig1xZCHeXOFhmitOZyTXDZtkosgJMZB0jPxUTgIyJ5PUOAlIULuvL8naYZOHS5doV0xl9jJEOJ1cKxZOg==';

-- Admin user (full permissions, group 1)
SET @admin_exists = (SELECT COUNT(*) FROM userod WHERE UserName = 'Admin');
SET @next_num = (SELECT COALESCE(MAX(UserNum),0) + 1 FROM userod);
INSERT IGNORE INTO userod (UserNum, UserName, Password, UserGroupNum, IsHidden, PasswordIsStrong)
SELECT @next_num, 'Admin', @pw_hash, 1, 0, 1 WHERE @admin_exists = 0;
UPDATE userod SET Password = @pw_hash, PasswordIsStrong = 1, IsHidden = 0 WHERE UserName = 'Admin';
INSERT IGNORE INTO usergroupattach (UserNum, UserGroupNum)
SELECT UserNum, 1 FROM userod WHERE UserName = 'Admin';

-- helianz service user (MT_Service group 13, choose-database only)
SET @helianz_exists = (SELECT COUNT(*) FROM userod WHERE UserName = 'helianz');
SET @next_num = (SELECT COALESCE(MAX(UserNum),0) + 1 FROM userod);
INSERT IGNORE INTO userod (UserNum, UserName, Password, UserGroupNum, IsHidden, PasswordIsStrong)
SELECT @next_num, 'helianz', @pw_hash, 13, 0, 1 WHERE @helianz_exists = 0;
UPDATE userod SET Password = @pw_hash, PasswordIsStrong = 1, IsHidden = 0 WHERE UserName = 'helianz';
INSERT IGNORE INTO usergroupattach (UserNum, UserGroupNum)
SELECT UserNum, 13 FROM userod WHERE UserName = 'helianz';

SELECT CONCAT('Users ready: Admin + helianz (password=12345)') AS Status;

-- ============================================================================
-- STEP 12: STANDARD REPORTS - PATIENT BALANCES AND CREDITS
-- ============================================================================
-- Add ODPatientBalancesCredits to displayreport (Category 2 = Monthly)
SET @report_exists = (SELECT COUNT(*) FROM displayreport WHERE InternalName = 'ODPatientBalancesCredits');
SET @next_order = (SELECT COALESCE(MAX(ItemOrder), 0) + 1 FROM displayreport WHERE Category = 2);

INSERT INTO displayreport (InternalName, ItemOrder, Description, Category, IsHidden, IsVisibleInSubMenu)
SELECT 'ODPatientBalancesCredits', @next_order, 'Patient Balances and Credits', 2, 0, 0
WHERE @report_exists = 0;

-- Grant access (PermType 22 = Reports) to all user groups that have Reports permissions
SET @new_report_num = (SELECT DisplayReportNum FROM displayreport WHERE InternalName = 'ODPatientBalancesCredits');

INSERT IGNORE INTO grouppermission (NewerDate, NewerDays, UserGroupNum, PermType, FKey)
SELECT DISTINCT '0001-01-01', 0, gp.UserGroupNum, 22, @new_report_num
FROM grouppermission gp
WHERE gp.PermType = 22 AND @new_report_num IS NOT NULL;

SELECT 'Patient Balances and Credits report registered in displayreport' AS Status;

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================
SELECT '=== POST-UPGRADE VERIFICATION ===' AS '';
SELECT CONCAT('Groups: ', COUNT(*), ' (expected 11)') FROM usergroup;
SELECT CONCAT('Permissions: ', COUNT(*), ' (expected ~575)') FROM grouppermission;
SELECT CONCAT('Group Assignments: ', COUNT(*), ' (expected 42)') FROM usergroupattach;
SELECT CONCAT('Users: ', COUNT(*), ' (expected 20-21)') FROM userod;
SELECT CONCAT('Patients: ', COUNT(*)) FROM patient;
SELECT CONCAT('Main Title: ', ValueString) FROM preference WHERE PrefName='MainWindowTitle';
SELECT CONCAT('DB Version: ', ValueString) FROM preference WHERE PrefName='DataBaseVersion';

-- Verify reports access: Groups 5,7,8,11 should have PermType 22 FKey=0
SELECT 'Groups with global Reports access (PermType 22 FKey=0):' AS '';
SELECT ug.UserGroupNum, ug.Description 
FROM usergroup ug 
JOIN grouppermission gp ON ug.UserGroupNum=gp.UserGroupNum 
WHERE gp.PermType=22 AND gp.FKey=0
ORDER BY ug.UserGroupNum;

SELECT '=== UPGRADE COMPLETE ===' AS '';
