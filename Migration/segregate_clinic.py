"""
Segregate all unassigned data (ClinicNum=0) to a specific clinic.
Usage: python segregate_clinic.py <ClinicNum> [--db database_name]

Examples:
  python segregate_clinic.py 1              # Assign to Klaten 1 on helianz
  python segregate_clinic.py 2 --db heliantmp  # Test on copy
"""
import mysql.connector
import sys
import argparse

# ── Config ──
HOST = "localhost"
USER = "root"
PASSWORD = "J0k0m4r0k3@"
DEFAULT_DB = "helianz"

# ── Tables to segregate ──
# Tables WITH ClinicNum column that hold clinic-specific operational data.
# Ordered by dependency: setup tables first, then core data.
CLINIC_TABLES = [
    # Setup / configuration
    "operatory",
    "schedule",
    "userod",
    "providerclinic",
    "computerpref",
    "fee",
    "apptview",
    "alertitem",
    "alertsub",
    "ebill",
    # Core operational data
    "patient",
    "appointment",
    "histappointment",
    "procedurelog",
    "proctp",
    # Financial
    "claim",
    "claimproc",
    "claimpayment",
    "payment",
    "paysplit",
    "adjustment",
    "payplancharge",
    "recurringcharge",
    "timeadjust",
    "dunning",
    "promotion",
    "promotionlog",
    # Other clinic-specific
    "orthocase",
    "rxpat",
    "sheet",
]

# ── Post-segregation: tables that need new linking rows ──
def post_segregate(cursor, clinic_num, db):
    """Create userclinic and providercliniclink rows."""
    print("\n--- Post-segregation: linking tables ---")

    # userclinic: grant all users access to this clinic
    cursor.execute(f"""
        INSERT IGNORE INTO userclinic (UserNum, ClinicNum)
        SELECT UserNum, {clinic_num} FROM userod
    """)
    print(f"  userclinic: {cursor.rowcount} rows added")

    # providercliniclink: link providers to this clinic
    cursor.execute(f"""
        INSERT IGNORE INTO providercliniclink (ProvNum, ClinicNum)
        SELECT ProvNum, {clinic_num} FROM providerclinic WHERE ClinicNum = {clinic_num}
    """)
    print(f"  providercliniclink: {cursor.rowcount} rows added")

    # fee schedules: set to non-global so clinic selector works in Procedure Codes
    # (IsGlobal has no UI editor — must be set here)
    cursor.execute(f"""
        UPDATE feesched SET IsGlobal = 0 
        WHERE IsGlobal = 1 AND FeeSchedNum IN (
            SELECT DISTINCT FeeSched FROM fee WHERE ClinicNum = {clinic_num}
        )
    """)
    if cursor.rowcount > 0:
        print(f"  feesched IsGlobal→0: {cursor.rowcount} schedules updated")


def verify(cursor, clinic_num):
    """Quick verification after segregation."""
    print("\n=== Verification ===")

    # Check ClinicNum=0 remaining
    checks = ["patient", "procedurelog", "appointment", "payment", "userod",
              "operatory", "providerclinic", "fee", "schedule"]
    all_zero = True
    for t in checks:
        cursor.execute(f"SELECT COUNT(*) FROM `{t}` WHERE ClinicNum = 0")
        cnt = cursor.fetchone()[0]
        if cnt > 0:
            print(f"  ⚠️  {t}: {cnt} rows still at ClinicNum=0")
            all_zero = False

    if all_zero:
        print("  ✅ No ClinicNum=0 rows remain in any key table")

    # Count at target clinic
    print(f"\n  Data at ClinicNum={clinic_num}:")
    for t in ["patient", "procedurelog", "appointment", "payment"]:
        cursor.execute(f"SELECT COUNT(*) FROM `{t}` WHERE ClinicNum = {clinic_num}")
        print(f"    {t}: {cursor.fetchone()[0]}")

    # userclinic
    cursor.execute(f"SELECT COUNT(*) FROM userclinic WHERE ClinicNum = {clinic_num}")
    print(f"    userclinic: {cursor.fetchone()[0]}")

    # providercliniclink
    cursor.execute(f"SELECT COUNT(*) FROM providercliniclink WHERE ClinicNum = {clinic_num}")
    print(f"    providercliniclink: {cursor.fetchone()[0]}")


def main():
    parser = argparse.ArgumentParser(description="Segregate ClinicNum=0 data to a specific clinic")
    parser.add_argument("clinic_num", type=int, help="Target ClinicNum (e.g., 1, 2, 3)")
    parser.add_argument("--db", default=DEFAULT_DB, help=f"Database name (default: {DEFAULT_DB})")
    parser.add_argument("--dry-run", action="store_true", help="Show what would be done, don't execute")
    parser.add_argument("-y", "--yes", action="store_true", help="Skip confirmation prompt")
    args = parser.parse_args()

    clinic_num = args.clinic_num
    db = args.db

    print(f"Target: ClinicNum={clinic_num} on database '{db}'")
    print(f"Tables to update: {len(CLINIC_TABLES)}")

    if args.dry_run:
        print("\n=== DRY RUN (no changes) ===")
        for t in CLINIC_TABLES:
            print(f"  UPDATE {t} SET ClinicNum = {clinic_num} WHERE ClinicNum = 0")
        return

    conn = mysql.connector.connect(host=HOST, user=USER, password=PASSWORD, database=db)
    cursor = conn.cursor()

    # Count before
    cursor.execute("SELECT COUNT(*) FROM patient WHERE ClinicNum = 0")
    before_patients = cursor.fetchone()[0]
    print(f"Patients at ClinicNum=0 before: {before_patients}")

    if before_patients == 0:
        print("⚠️  No unassigned data found (ClinicNum=0 is empty). Nothing to do.")
        cursor.close()
        conn.close()
        return

    if not args.yes:
        confirm = input(f"\nMove {before_patients} patients (and all related data) to ClinicNum={clinic_num}? [y/N]: ")
        if confirm.lower() != 'y':
            print("Aborted.")
            cursor.close()
            conn.close()
            return
    else:
        print(f"\nMoving {before_patients} patients to ClinicNum={clinic_num}...")

    # ── Phase 1: Move all data ──
    print("\n=== Segregating data ===")
    for table in CLINIC_TABLES:
        try:
            sql = f"UPDATE `{table}` SET ClinicNum = {clinic_num} WHERE ClinicNum = 0"
            cursor.execute(sql)
            if cursor.rowcount > 0:
                print(f"  {table}: {cursor.rowcount} rows -> ClinicNum={clinic_num}")
        except Exception as e:
            print(f"  ⚠️  {table}: ERROR - {e}")

    # ── Phase 2: Linking tables ──
    post_segregate(cursor, clinic_num, db)

    conn.commit()

    # ── Verify ──
    verify(cursor, clinic_num)

    cursor.close()
    conn.close()
    print("\n✅ Done.")


if __name__ == "__main__":
    main()
