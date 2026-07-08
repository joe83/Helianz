-- ============================================================================
-- Phase 1: Segregate Klaten Data (ClinicNum 0 → 1)
-- ============================================================================
-- ⚠️  REPLACED by segregate_clinic.py — use the dynamic script instead:
--     python segregate_clinic.py 1
--     python segregate_clinic.py 2 --db heliantmp
--
-- This file kept for reference only.
-- ============================================================================

USE helianz;

-- ============================================================================
-- SECTION A: Core Operational Data (HIGH IMPACT)
-- ============================================================================

-- A1. Operatories - Klaten's chairs/rooms
UPDATE operatory SET ClinicNum = 1 WHERE ClinicNum = 0;

-- A2. Patients - all patients are from Klaten
UPDATE patient SET ClinicNum = 1 WHERE ClinicNum = 0;

-- A3. Appointments (current + history)
UPDATE appointment SET ClinicNum = 1 WHERE ClinicNum = 0;
UPDATE histappointment SET ClinicNum = 1 WHERE ClinicNum = 0;

-- A4. Procedures
UPDATE procedurelog SET ClinicNum = 1 WHERE ClinicNum = 0;
UPDATE proctp SET ClinicNum = 1 WHERE ClinicNum = 0;

-- A5. Financial transactions
UPDATE claim SET ClinicNum = 1 WHERE ClinicNum = 0;
UPDATE claimproc SET ClinicNum = 1 WHERE ClinicNum = 0;
UPDATE claimpayment SET ClinicNum = 1 WHERE ClinicNum = 0;
UPDATE payment SET ClinicNum = 1 WHERE ClinicNum = 0;
UPDATE paysplit SET ClinicNum = 1 WHERE ClinicNum = 0;
UPDATE adjustment SET ClinicNum = 1 WHERE ClinicNum = 0;

-- A6. Schedules
UPDATE schedule SET ClinicNum = 1 WHERE ClinicNum = 0;

-- ============================================================================
-- SECTION B: Setup / Configuration Data
-- ============================================================================

-- B1. Users - all users are Klaten staff
UPDATE userod SET ClinicNum = 1 WHERE ClinicNum = 0;

-- B2. Provider-Clinic assignments
--     Each provider can have multiple rows: ClinicNum=0 = all clinics,
--     ClinicNum=N = specific clinic. For now, assign all to Klaten.
UPDATE providerclinic SET ClinicNum = 1 WHERE ClinicNum = 0;

-- B3. Computer preferences (per-workstation settings)
UPDATE computerpref SET ClinicNum = 1 WHERE ClinicNum = 0;

-- B4. Fee schedule items (clinic-specific pricing)
--     If all clinics share the same pricing, leave at 0 instead.
--     For now, assign to Klaten since this is Klaten's data.
UPDATE fee SET ClinicNum = 1 WHERE ClinicNum = 0;

-- B5. Appointment views (saved view configurations)
UPDATE apptview SET ClinicNum = 1 WHERE ClinicNum = 0;

-- B6. Alert items
UPDATE alertitem SET ClinicNum = 1 WHERE ClinicNum = 0;
UPDATE alertsub SET ClinicNum = 1 WHERE ClinicNum = 0;

-- B7. E-bill configurations
UPDATE ebill SET ClinicNum = 1 WHERE ClinicNum = 0;

-- ============================================================================
-- SECTION C: User-Clinic Access (NEW records)
-- ============================================================================

-- Grant all users access to Klaten 1
-- This ensures users can see Klaten data after segregation
INSERT IGNORE INTO userclinic (UserNum, ClinicNum)
SELECT UserNum, 1 FROM userod;

-- ============================================================================
-- SECTION D: Provider-Clinic Links for multi-clinic (NEW records)
-- ============================================================================

-- Create providercliniclink entries linking providers to Klaten 1
-- (providercliniclink is the detailed link table; providerclinic is the summary)
INSERT IGNORE INTO providercliniclink (ProvNum, ClinicNum) 
SELECT ProvNum, 1 FROM providerclinic WHERE ClinicNum = 1;

-- ============================================================================
-- SECTION E: Clinic Preferences (NEW records)
-- ============================================================================

-- Clone key preferences from global (preference table) to clinicpref for Klaten 1
-- Only if the preference has clinic-specific meaning.
-- For now, clinicpref stays empty - it will be populated as needed when 
-- clinic-specific overrides are required.

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- After running, verify:
-- 1. No ClinicNum=0 rows remain in key tables:
SELECT 'patient (ClinicNum=0)' as check_item, COUNT(*) as remaining FROM patient WHERE ClinicNum = 0;
SELECT 'appointment (0)', COUNT(*) FROM appointment WHERE ClinicNum = 0;
SELECT 'procedurelog (0)', COUNT(*) FROM procedurelog WHERE ClinicNum = 0;
SELECT 'payment (0)', COUNT(*) FROM payment WHERE ClinicNum = 0;
SELECT 'userod (0)', COUNT(*) FROM userod WHERE ClinicNum = 0;
SELECT 'providerclinic (0)', COUNT(*) FROM providerclinic WHERE ClinicNum = 0;
SELECT 'operatory (0)', COUNT(*) FROM operatory WHERE ClinicNum = 0;

-- 2. All data now at ClinicNum=1:
SELECT 'patient (ClinicNum=1)' as check_item, COUNT(*) as klaten_data FROM patient WHERE ClinicNum = 1;
SELECT 'procedurelog (1)', COUNT(*) FROM procedurelog WHERE ClinicNum = 1;
SELECT 'appointment (1)', COUNT(*) FROM appointment WHERE ClinicNum = 1;

-- 3. User-clinic assignments created:
SELECT COUNT(*) as userclinic_rows FROM userclinic;

-- 4. Clinics still exist:
SELECT ClinicNum, Description, Abbr FROM clinic ORDER BY ClinicNum;
