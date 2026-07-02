# Cdental → Helianz Upgrade Guide

## Overview

This documents the complete process for upgrading a production Cdental database
(OpenDental v11.0.36) to Helianz (OpenDental v24.3.49), including all post-upgrade
fixes discovered and battle-tested in session 2026-06-29/30.

## Architecture

```
cdental (v11.0.36) ──import──▶ helianz (v11.0.36)
                                     │
                           [Launch Helianz.exe]
                           Auto-upgrades 11→24
                                     │
                           helianz (v24.3.49, INCOMPLETE)
                                     │
                     [Upgrade-HelianzComplete.sql]
                                     │
                           helianz (v24.3.49, COMPLETE)
```

## Problem Discovery

After the automatic schema upgrade (ConvertDatabases chain 11.0.36→24.3.49),
several things are broken or incomplete:

### 1. Missing User Groups
- **Symptom:** Only 3 groups (Admin, Regular Users, DOKTER)
- **Root cause:** cdental never had the 8 role-based groups (5-12)
- **Fix:** INSERT IGNORE 8 groups

### 2. Missing Permissions
- **Symptom:** Standard Reports menu invisible, features inaccessible
- **Root cause 1:** Group 2 (Regular Users) missing perms beyond PermType 44
- **Root cause 2:** Groups 5-12 have no permissions assigned
- **Key finding:** `EnumPermType.Reports = 22`. FKey=0 = global access.
  `DoesPermissionTreatZeroFKeyAsAll(Reports)` returns true, meaning if
  any of the user's groups has PermType 22 FKey=0, they get all reports.
- **Fix:** INSERT IGNORE ~176 permission rows

### 3. Broken Multi-Group Assignments (usergroupattach)
- **Symptom:** Reports menu still invisible even after adding permissions
- **Root cause:** Users only had their primary group (userod.UserGroupNum).
  Helianz uses **multi-group** inheritance via `usergroupattach`. Groups
  5,7,8,11 have PermType 22 FKey=0 (global reports), but no users were
  assigned to these groups.
- **Fix:** DELETE + re-INSERT all 42 usergroupattach rows with proper
  multi-group assignments:
  - Owners → Groups 1+5+11 (Admin + SecurityAdmin + Billing)
  - FO staff → Groups 2+7 (Regular + FrontDesk)
  - Dentists → Groups 3+8 (DOKTER + Dentist)
  - Billing → Groups 2+11 (Regular + Billing)

### 4. Branding (Cdental → Helianz)
- **Fix:** Update preferences (MainWindowTitle, DocPath, etc.)
- **Fix:** Clean definition table text references
- **Fix:** Clean computerpref AtoZpath (NOTE: column is `AtoZpath` not `ImagePath`)

### 5. RegistrationKey Crash
- **Symptom:** `Unhandled exception: RegistrationKey is an invalid pref name`
- **Root cause:** `RegistrationKey` IS a valid `PrefName` enum value in Helianz.
  The app calls `PrefC.GetString(PrefName.RegistrationKey)` at startup.
  If the preference doesn't exist in the table, the cache won't have it,
  and `GetOne()` throws.
- **Fix:** Keep `RegistrationKey` (empty) and `RegistrationKeyIsDisabled` (0).
  Only delete `RegistrationNumberClaim` (cdental-specific, not in PrefName enum).

## Files

| File | Purpose |
|------|---------|
| `Upgrade-HelianzComplete.sql` | Standalone SQL script for post-upgrade fixes |
| `Migrate-CdentalToHelianz.ps1` | PowerShell orchestrator (backup→import→fix→verify) |

## Usage

### Quick: Apply fixes to an already-upgraded database

```powershell
# Option A: PowerShell
.\Migration\Migrate-CdentalToHelianz.ps1 -OnlyPostFixes -MySqlPassword "password"

# Option B: Direct SQL
mysql -u root -p"password" -h localhost helianz < Migration\Upgrade-HelianzComplete.sql
```

### Full: Complete migration from scratch

```powershell
# Step 1: Import + configure
.\Migration\Migrate-CdentalToHelianz.ps1 -MySqlPassword "password"

# Step 2: The script pauses — launch Helianz.exe, wait for upgrade, close it

# Step 3: Apply post-upgrade fixes
.\Migration\Migrate-CdentalToHelianz.ps1 -OnlyPostFixes -MySqlPassword "password"
```

### Custom databases

```powershell
.\Migration\Migrate-CdentalToHelianz.ps1 `
    -SourceDb cdental_production `
    -TargetDb helianz_new `
    -MySqlPassword "password"
```

## Expected Final State

| Metric | Value |
|--------|-------|
| Groups | 11 |
| Permissions | ~575+ |
| Group Assignments | 42 |
| Users | 20 |
| Main Title | Helianz |
| DB Version | 24.3.49.0 |
| Reports Access | Groups 5,6,7,8,9,11,12 (FKey=0) |

## Key PermType Reference

| PermType | Name | Notes |
|----------|------|-------|
| 22 | Reports | FKey=0 = global. Controls Standard Reports menu |
| 24 | SecurityAdmin | Controls Setup/Tools menus |
| 59 | GraphicalReports | Controls Graphical Reports menu |
| 8 | Setup | Global setup access |

## Session Log

- **2026-06-29:** Discovered groups/permissions/usergroupattach mismatch.
  Compared `helianz` vs `helianz4`. Found `EnumPermType.Reports = 22`.
  Traced code path: `FormHelianzMenus.cs` → `Security.IsAuthorized` →
  `GroupPermissions.HasPermission` → `DoesPermissionTreatZeroFKeyAsAll`.
  Merged groups, permissions, and fixed usergroupattach.

- **2026-06-30:** Created `Upgrade-HelianzComplete.sql` and `Migrate-CdentalToHelianz.ps1`.
  Fixed PowerShell `<` redirection error (PowerShell uses `Get-Content |`).
  Fixed `FreeDentalConfig.xml` path resolution (repo root, not Migration folder).
  Fixed `computerpref` column name (`AtoZpath`, not `ImagePath`).
  Discovered `RegistrationKey` crash: it's a valid `PrefName` enum value,
  must exist in table with empty value. Only `RegistrationNumberClaim` should be deleted.
  Ran complete upgrade end-to-end on test databases — zero errors.
