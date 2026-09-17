-- =============================================================================
-- Fix: Appointment Doctor Name & Status Color Missing After Clinic Switch
-- Database: helianz
-- Date: 2026-07-22
-- =============================================================================
-- 
-- Root Cause (traced through ControlAppt.cs FillViews/GetApptViewForUser):
--   1. 3 computers have ApptViewNum=0 in computerpref → GetApptView(0) = null
--   2. On RESTART: _hasInitializedOnStartup=true → picks first real view → WORKS
--   3. After CLINIC SWITCH: _hasInitializedOnStartup=false → falls to "none"
--   4. "none" view renders appointments as plain text (no Provider, no ConfirmedColor)
--   5. Clinics 2 & 3 have NO apptview entries → switching to them forces "none"
--   6. Only 1 user (UserNum=18) has a userodapptview assignment
--
-- The apptview filter in FillViews() is:
--   GetWhere(x => !(HasClinicsEnabled && ClinicNum != x.ClinicNum))
-- This means ClinicNum=0 views are EXCLUDED when a specific clinic is selected.
-- So each clinic needs its OWN apptview entries.
-- =============================================================================

USE helianz;

-- ── Part 1: Fix computerpref.ApptViewNum = 0 → 2 ("All") ──
-- MJOE-PC, DESKTOP-GBJEDR2, WIN-JFRMMQESJRN currently have ApptViewNum=0
UPDATE computerpref SET ApptViewNum = 2 WHERE ApptViewNum = 0;
SELECT 'Part 1: computerpref' AS step, ROW_COUNT() AS rows_affected;

-- ── Part 2: Add userodapptview for ALL users, clinic-SPECIFIC ──
-- IMPORTANT: GetOneForUserAndClinic does EXACT ClinicNum match.
-- ClinicNum=0 entries are only found when Clinics.ClinicNum=0 (HQ mode).
-- Each clinic needs its own entries with the correct ApptViewNum.

-- Clinic 1 (Klaten) - uses ApptViewNum 2 = "All"
INSERT IGNORE INTO userodapptview (UserNum, ClinicNum, ApptViewNum)
SELECT u.UserNum, 1, 2
FROM userod u
WHERE u.UserNum NOT IN (SELECT UserNum FROM userodapptview WHERE ClinicNum=1);

-- Clinic 2 (Boyolali)
INSERT IGNORE INTO userodapptview (UserNum, ClinicNum, ApptViewNum)
SELECT u.UserNum, 2,
    (SELECT ApptViewNum FROM apptview WHERE ClinicNum=2 AND Description='All' LIMIT 1)
FROM userod u
WHERE u.UserNum NOT IN (SELECT UserNum FROM userodapptview WHERE ClinicNum=2);

-- Clinic 3 (Jogja)
INSERT IGNORE INTO userodapptview (UserNum, ClinicNum, ApptViewNum)
SELECT u.UserNum, 3,
    (SELECT ApptViewNum FROM apptview WHERE ClinicNum=3 AND Description='All' LIMIT 1)
FROM userod u
WHERE u.UserNum NOT IN (SELECT UserNum FROM userodapptview WHERE ClinicNum=3);
SELECT 'Part 2: userodapptview' AS step, ROW_COUNT() AS rows_affected;

-- ── Part 3: Create apptview entries for clinics 2 (Boyolali) and 3 (Jogja) ──
-- Clone layout from clinic 1 views. Each clinic needs its own views because
-- the app filter excludes ClinicNum=0 views when a clinic is selected.

-- Clinic 2 views
INSERT INTO apptview (Description, ItemOrder, RowsPerIncr, OnlyScheduledProvs,
    OnlySchedBeforeTime, OnlySchedAfterTime, StackBehavUR, StackBehavLR,
    ClinicNum, ApptTimeScrollStart, IsScrollStartDynamic, IsApptBubblesDisabled,
    WidthOpMinimum, WaitingRmName, OnlyScheduledProvDays)
SELECT Description, ItemOrder, RowsPerIncr, OnlyScheduledProvs,
    OnlySchedBeforeTime, OnlySchedAfterTime, StackBehavUR, StackBehavLR,
    2, ApptTimeScrollStart, IsScrollStartDynamic, IsApptBubblesDisabled,
    WidthOpMinimum, WaitingRmName, OnlyScheduledProvDays
FROM apptview WHERE ClinicNum = 1;

-- Clinic 3 views
INSERT INTO apptview (Description, ItemOrder, RowsPerIncr, OnlyScheduledProvs,
    OnlySchedBeforeTime, OnlySchedAfterTime, StackBehavUR, StackBehavLR,
    ClinicNum, ApptTimeScrollStart, IsScrollStartDynamic, IsApptBubblesDisabled,
    WidthOpMinimum, WaitingRmName, OnlyScheduledProvDays)
SELECT Description, ItemOrder, RowsPerIncr, OnlyScheduledProvs,
    OnlySchedBeforeTime, OnlySchedAfterTime, StackBehavUR, StackBehavLR,
    3, ApptTimeScrollStart, IsScrollStartDynamic, IsApptBubblesDisabled,
    WidthOpMinimum, WaitingRmName, OnlyScheduledProvDays
FROM apptview WHERE ClinicNum = 1;

SELECT 'Part 3: apptview for clinics 2&3' AS step, ROW_COUNT() AS rows_affected;

-- ── Part 4: Clone apptviewitem entries for the newly created views ──
-- For each new view, copy layout items from the corresponding clinic 1 originals.

-- Clinic 2 "All" (match by Description='All')
INSERT INTO apptviewitem (ApptViewNum, OpNum, ProvNum, ElementDesc, ElementOrder,
    ElementColor, ElementAlignment, ApptFieldDefNum, PatFieldDefNum, IsMobile)
SELECT 
    (SELECT ApptViewNum FROM apptview WHERE ClinicNum=2 AND Description='All' LIMIT 1),
    OpNum, ProvNum, ElementDesc, ElementOrder,
    ElementColor, ElementAlignment, ApptFieldDefNum, PatFieldDefNum, IsMobile
FROM apptviewitem WHERE ApptViewNum = (SELECT ApptViewNum FROM apptview WHERE ClinicNum=1 AND Description='All');

-- Clinic 2 "Doc"
INSERT INTO apptviewitem (ApptViewNum, OpNum, ProvNum, ElementDesc, ElementOrder,
    ElementColor, ElementAlignment, ApptFieldDefNum, PatFieldDefNum, IsMobile)
SELECT 
    (SELECT ApptViewNum FROM apptview WHERE ClinicNum=2 AND Description='Doc' LIMIT 1),
    OpNum, ProvNum, ElementDesc, ElementOrder,
    ElementColor, ElementAlignment, ApptFieldDefNum, PatFieldDefNum, IsMobile
FROM apptviewitem WHERE ApptViewNum = (SELECT ApptViewNum FROM apptview WHERE ClinicNum=1 AND Description='Doc');

-- Clinic 2 "Hyg"
INSERT INTO apptviewitem (ApptViewNum, OpNum, ProvNum, ElementDesc, ElementOrder,
    ElementColor, ElementAlignment, ApptFieldDefNum, PatFieldDefNum, IsMobile)
SELECT 
    (SELECT ApptViewNum FROM apptview WHERE ClinicNum=2 AND Description='Hyg' LIMIT 1),
    OpNum, ProvNum, ElementDesc, ElementOrder,
    ElementColor, ElementAlignment, ApptFieldDefNum, PatFieldDefNum, IsMobile
FROM apptviewitem WHERE ApptViewNum = (SELECT ApptViewNum FROM apptview WHERE ClinicNum=1 AND Description='Hyg');

-- Clinic 3 "All"
INSERT INTO apptviewitem (ApptViewNum, OpNum, ProvNum, ElementDesc, ElementOrder,
    ElementColor, ElementAlignment, ApptFieldDefNum, PatFieldDefNum, IsMobile)
SELECT 
    (SELECT ApptViewNum FROM apptview WHERE ClinicNum=3 AND Description='All' LIMIT 1),
    OpNum, ProvNum, ElementDesc, ElementOrder,
    ElementColor, ElementAlignment, ApptFieldDefNum, PatFieldDefNum, IsMobile
FROM apptviewitem WHERE ApptViewNum = (SELECT ApptViewNum FROM apptview WHERE ClinicNum=1 AND Description='All');

-- Clinic 3 "Doc"
INSERT INTO apptviewitem (ApptViewNum, OpNum, ProvNum, ElementDesc, ElementOrder,
    ElementColor, ElementAlignment, ApptFieldDefNum, PatFieldDefNum, IsMobile)
SELECT 
    (SELECT ApptViewNum FROM apptview WHERE ClinicNum=3 AND Description='Doc' LIMIT 1),
    OpNum, ProvNum, ElementDesc, ElementOrder,
    ElementColor, ElementAlignment, ApptFieldDefNum, PatFieldDefNum, IsMobile
FROM apptviewitem WHERE ApptViewNum = (SELECT ApptViewNum FROM apptview WHERE ClinicNum=1 AND Description='Doc');

-- Clinic 3 "Hyg"
INSERT INTO apptviewitem (ApptViewNum, OpNum, ProvNum, ElementDesc, ElementOrder,
    ElementColor, ElementAlignment, ApptFieldDefNum, PatFieldDefNum, IsMobile)
SELECT 
    (SELECT ApptViewNum FROM apptview WHERE ClinicNum=3 AND Description='Hyg' LIMIT 1),
    OpNum, ProvNum, ElementDesc, ElementOrder,
    ElementColor, ElementAlignment, ApptFieldDefNum, PatFieldDefNum, IsMobile
FROM apptviewitem WHERE ApptViewNum = (SELECT ApptViewNum FROM apptview WHERE ClinicNum=1 AND Description='Hyg');

SELECT 'Part 4: apptviewitem cloned' AS step, ROW_COUNT() AS rows_affected;

-- ── Verification ──
SELECT '' AS ' ';
SELECT '=== computerpref with ApptViewNum=0 remaining ===' AS '';
SELECT ComputerPrefNum, ComputerName, ApptViewNum FROM computerpref WHERE ApptViewNum = 0;

SELECT '' AS ' ';
SELECT '=== userodapptview count ===' AS '';
SELECT COUNT(*) AS total_rows FROM userodapptview;

SELECT '' AS ' ';
SELECT '=== apptview distribution by ClinicNum ===' AS '';
SELECT ClinicNum, COUNT(*) AS view_count FROM apptview GROUP BY ClinicNum;

SELECT '' AS ' ';
SELECT '=== apptviewitem by clinic/view ===' AS '';
SELECT av.ClinicNum, av.ApptViewNum, av.Description, COUNT(avi.ApptViewItemNum) AS item_count
FROM apptview av
LEFT JOIN apptviewitem avi ON av.ApptViewNum = avi.ApptViewNum
GROUP BY av.ApptViewNum, av.ClinicNum, av.Description
ORDER BY av.ClinicNum, av.ApptViewNum;

SELECT '' AS ' ';
SELECT 'FIX COMPLETE. Restart Helianz for changes to take effect.' AS '';
