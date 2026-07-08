# Helianz Multi-Clinic Migration Guide

**Date:** 2026-07-08 | **Database:** `helianz` on `localhost` (root / J0k0m4r0k3@)

---

## 1. Overview

Merging 3 independent clinic databases (cdental v11 → Helianz v24) into one centralized multi-clinic database.

| Clinic | ClinicNum | PatNum Range | Status |
|--------|-----------|-------------|--------|
| Klaten 1 | 1 | 7 – 10,626 | ✅ In production |
| Jogja 1 | 2 | 1,000,007 – 1,010,626 (offset +1M) | ⏳ Pending import |
| Boyolali 1 | 3 | 2,000,007 – 2,010,626 (offset +2M) | ⏳ Pending import |

---

## 2. Migration Toolkit

All scripts in `Migration/`. Run from repo root with the venv Python.

| Script | Purpose |
|--------|---------|
| `segregate_clinic.py` | Assign all ClinicNum=0 data to a clinic |
| `offset_db.py` | Offset clinic PKs+FKs by N to avoid collisions |
| `merge_clinics.py` | Merge multiple temp DBs into target |
| `simulate_merge.py` | Full simulation from helianz copies |
| `calc_offset.py` | Calculate safe offset values |

### 2.1 `segregate_clinic.py`

```bash
python segregate_clinic.py <ClinicNum> --db <database> [--yes] [--dry-run]
```

- Moves all ClinicNum=0 data to the specified clinic
- Creates `userclinic` and `providercliniclink` entries
- Auto-sets `feesched.IsGlobal=0` for schedules used by the clinic (no UI editor)
- `--yes` — skip confirmation prompt
- `--dry-run` — preview only

### 2.2 `offset_db.py`

```bash
python offset_db.py <offset_amount> --db <database> [--dry-run]
```

Offsets PKs and FKs for 3 categories of tables:

| Category | Detection | Examples |
|----------|-----------|---------|
| Clinic | Has `ClinicNum` column | patient, apptview, operatory |
| Patient-shared | Has `PatNum`, no `ClinicNum` | document, recall, commlog |
| Clinic-adjacent | FK to clinic PK, no `ClinicNum`/`PatNum` | apptviewitem, scheduleop (49 tables) |

Protected from offset: `ClinicNum`, shared reference PKs (`DefNum`, `ProvNum`, `CodeNum`, `FeeSchedNum`, etc.)

FK discovery: parses 738 FK mappings from `HelianzBusiness/TableTypes/*.cs` source comments to handle non-matching column names (e.g., `appointment.Op` → `operatory.OperatoryNum`).

### 2.3 `merge_clinics.py`

```bash
python merge_clinics.py --target <target_db> --sources <db1,db2,...> [--dry-run]
```

Merges ALL tables from source DBs into target using `INSERT IGNORE`. Truly shared tables (definitions, procedure codes) have non-offset PKs and are automatically skipped on duplicate key.

### 2.4 `simulate_merge.py`

```bash
python simulate_merge.py --count 3 [--prefix heliantmp_] [--target final_db] [--offset-gap N] [--skip-offset]
```

Full simulation: creates N copies of helianz, processes each (reset→segregate→offset), then merges into target. Uses `heliantmp_<N>` naming by default.

### 2.5 `calc_offset.py`

```bash
python calc_offset.py --target helianz --count 3 [--gap 1000000]
```

Queries the target DB for actual max PK values and calculates safe offset ranges to avoid collisions. Use `--gap` for safety buffer between ranges.

---

## 3. Real Import Workflow

### Step 1: Klaten (Done)

Klaten data is in `helianz` at ClinicNum=1.

### Step 2: For Each Additional Clinic

```bash
# 1. Calculate safe offset
python calc_offset.py --target helianz --count 3
# Example: Max PK=1,025,987 → Jogja offset=2,025,987, Boyolali offset=4,051,974

# 2. Import dump into temp DB
mysql -u root -p"J0k0m4r0k3@" -e "CREATE DATABASE helianz_import_jogja"
mysql -u root -p"J0k0m4r0k3@" helianz_import_jogja < jogja_dump.sql

# 3. Auto-upgrade 11→24
# Point FreeDentalConfig.xml to helianz_import_jogja, launch Helianz, close

# 4. Segregate
python segregate_clinic.py 2 --db helianz_import_jogja --yes

# 5. Offset (use calculated value, not fixed 2M)
python offset_db.py 2025987 --db helianz_import_jogja

# 6. Merge
python merge_clinics.py --target helianz --sources helianz_import_jogja

# 7. Clean up
mysql -u root -p"J0k0m4r0k3@" -e "DROP DATABASE helianz_import_jogja"
```

Repeat for Boyolali with ClinicNum=3 and calculated offset.

---

## 4. Code Fixes Applied

### 4.1 ApptViewItemL — Clinic Filter

**File:** `Helianz\Logic\ApptViewItemL.cs` line 88

**Problem:** Switching to a clinic with no operatories loaded another clinic's apptview without clinic filtering, showing wrong operatories and appointments.

**Fix:**
```csharp
Operatory operatory = Operatories.GetFirstOrDefault(x => 
    x.OperatoryNum == listApptViewItems[i].OpNum
    && (!PrefC.HasClinicsEnabled || Clinics.ClinicNum==0 || x.ClinicNum==Clinics.ClinicNum)
, true);
```

### 4.2 GetPatTable — Stale Binary Crash

**File:** `HelianzBusiness\Data Interface\Appointments.cs` line 1724

A null guard `if(tablePatRaw.Rows.Count==0) return table;` exists in the code. The crash during testing was caused by running a stale binary (app was running during build, locking `HelianzBusiness.dll`). **Always close the app before building.**

---

## 5. Verification Queries

```sql
-- Patient count by clinic
SELECT ClinicNum, COUNT(*) FROM patient GROUP BY ClinicNum;

-- FK integrity (all must be 0)
SELECT COUNT(*) FROM procedurelog WHERE PatNum NOT IN (SELECT PatNum FROM patient);
SELECT COUNT(*) FROM appointment WHERE Op>0 AND Op NOT IN (SELECT OperatoryNum FROM operatory);
SELECT COUNT(*) FROM document WHERE PatNum>0 AND PatNum NOT IN (SELECT PatNum FROM patient);
SELECT COUNT(*) FROM paysplit WHERE PatNum NOT IN (SELECT PatNum FROM patient);
SELECT COUNT(*) FROM recall WHERE PatNum NOT IN (SELECT PatNum FROM patient);

-- PK ranges by clinic
SELECT ClinicNum, MIN(PatNum), MAX(PatNum) FROM patient GROUP BY ClinicNum;

-- ApptView chain (must have items for each clinic)
SELECT av.ClinicNum, av.ApptViewNum, av.Description, COUNT(avi.ApptViewItemNum)
FROM apptview av JOIN apptviewitem avi ON av.ApptViewNum = avi.ApptViewNum
GROUP BY av.ApptViewNum ORDER BY av.ClinicNum;

-- Operatories by clinic
SELECT ClinicNum, COUNT(*), MIN(OperatoryNum), MAX(OperatoryNum) FROM operatory GROUP BY ClinicNum;

-- Documents by clinic tier
SELECT CASE WHEN DocNum<1000000 THEN 'Klaten'
            WHEN DocNum<3000000 THEN 'Jogja'
            ELSE 'Boyolali' END, COUNT(*)
FROM document GROUP BY 1;

-- Fee schedules (check IsGlobal)
SELECT FeeSchedNum, Description, IsHidden, IsGlobal FROM feesched;
```

---

## 6. Known Limitations & Fixes

| Issue | Fix |
|-------|-----|
| PK offset overlap (e.g., securitylog 1M rows vs 1M gap) | Use `calc_offset.py` to compute safe gaps |
| Clinic dropdown disabled in Procedure Codes | Auto-fixed by `segregate_clinic.py` (`feesched.IsGlobal=0`) |
| Provider table is shared (no ClinicNum) | Multi-clinic assignment via `providerclinic` table |
| ApptView shows wrong clinic's ops | Fixed in `ApptViewItemL.cs` (Section 4.1) |
| Stale DLL causes crash | Close app before `MSBuild` |

---

## 7. Quick Reference

```bash
# Full simulation (3 clinics, ~15-20 min):
python simulate_merge.py --count 3

# Simulation with calculated offset:
python calc_offset.py --target helianz --count 3
python simulate_merge.py --count 3 --offset-gap 2025987

# Manual merge:
python merge_clinics.py --target helianz --sources helianz_jogja,helianz_byl

# Dry run:
python merge_clinics.py --target helianz --sources db1,db2 --dry-run

# Single clinic import:
python segregate_clinic.py 2 --db import_db --yes
python offset_db.py 2025987 --db import_db
python merge_clinics.py --target helianz --sources import_db
```

---

## 8. File Index

| File | Description |
|------|-------------|
| `Migration/segregate_clinic.py` | Assign ClinicNum + fix fee schedules |
| `Migration/offset_db.py` | Offset PKs/FKs (3 categories, 738 FK map) |
| `Migration/merge_clinics.py` | Merge all tables via INSERT IGNORE |
| `Migration/simulate_merge.py` | Full multi-clinic simulation |
| `Migration/calc_offset.py` | Calculate safe offset values |
| `Helianz/Logic/ApptViewItemL.cs` | ApptView operatory loading (fixed) |
| `HelianzBusiness/Data Interface/Appointments.cs` | GetPatTable null guard (existing) |
