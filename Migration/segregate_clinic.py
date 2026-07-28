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
    """Create linking rows and fix appointment views after clinic segregation."""
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
    cursor.execute(f"""
        UPDATE feesched SET IsGlobal = 0 
        WHERE IsGlobal = 1 AND FeeSchedNum IN (
            SELECT DISTINCT FeeSched FROM fee WHERE ClinicNum = {clinic_num}
        )
    """)
    if cursor.rowcount > 0:
        print(f"  feesched IsGlobal→0: {cursor.rowcount} schedules updated")

    # ── Appointment view fixes ──
    # Fix computers with ApptViewNum=0 (causes "none" view after clinic switch)
    # Set to the "All" view for this clinic
    cursor.execute(f"""
        UPDATE computerpref
        SET ApptViewNum = COALESCE(
            (SELECT ApptViewNum FROM apptview
             WHERE ClinicNum = {clinic_num} AND Description = 'All'
             LIMIT 1),
            2
        )
        WHERE ApptViewNum = 0
    """)
    if cursor.rowcount > 0:
        print(f"  computerpref ApptViewNum=0 fixed: {cursor.rowcount} computers")

    # Add userodapptview for all users with THIS clinic's "All" view
    # IMPORTANT: GetOneForUserAndClinic does exact ClinicNum match — ClinicNum=0
    # entries are NOT found when a specific clinic is selected. So we need
    # clinic-specific entries with the correct ApptViewNum for this clinic.
    cursor.execute(f"""
        INSERT IGNORE INTO userodapptview (UserNum, ClinicNum, ApptViewNum)
        SELECT u.UserNum, {clinic_num},
            COALESCE(
                (SELECT ApptViewNum FROM apptview
                 WHERE ClinicNum = {clinic_num} AND Description = 'All'
                 LIMIT 1),
                2
            )
        FROM userod u
        WHERE u.UserNum NOT IN (
            SELECT UserNum FROM userodapptview WHERE ClinicNum = {clinic_num}
        )
    """)
    if cursor.rowcount > 0:
        print(f"  userodapptview ClinicNum={clinic_num}: {cursor.rowcount} users assigned")

    # Clone apptview entries from clinic 1 if this clinic has none
    cursor.execute(f"SELECT COUNT(*) FROM apptview WHERE ClinicNum = {clinic_num}")
    if cursor.fetchone()[0] == 0:
        print(f"  Cloning apptview entries from ClinicNum=1 → ClinicNum={clinic_num}...")

        # Clone apptview rows (ApptViewNum is AUTO_INCREMENT)
        cursor.execute(f"""
            INSERT INTO apptview (Description, ItemOrder, RowsPerIncr, OnlyScheduledProvs,
                OnlySchedBeforeTime, OnlySchedAfterTime, StackBehavUR, StackBehavLR,
                ClinicNum, ApptTimeScrollStart, IsScrollStartDynamic, IsApptBubblesDisabled,
                WidthOpMinimum, WaitingRmName, OnlyScheduledProvDays)
            SELECT Description, ItemOrder, RowsPerIncr, OnlyScheduledProvs,
                OnlySchedBeforeTime, OnlySchedAfterTime, StackBehavUR, StackBehavLR,
                {clinic_num}, ApptTimeScrollStart, IsScrollStartDynamic, IsApptBubblesDisabled,
                WidthOpMinimum, WaitingRmName, OnlyScheduledProvDays
            FROM apptview WHERE ClinicNum = 1
        """)
        n_views = cursor.rowcount
        print(f"    {n_views} apptview rows created")

        # Clone apptviewitem for each new view (match by Description)
        for desc in ['All', 'Doc', 'Hyg']:
            cursor.execute(f"""
                INSERT INTO apptviewitem (ApptViewNum, OpNum, ProvNum, ElementDesc,
                    ElementOrder, ElementColor, ElementAlignment, ApptFieldDefNum,
                    PatFieldDefNum, IsMobile)
                SELECT
                    (SELECT ApptViewNum FROM apptview WHERE ClinicNum={clinic_num} AND Description='{desc}' LIMIT 1),
                    OpNum, ProvNum, ElementDesc, ElementOrder,
                    ElementColor, ElementAlignment, ApptFieldDefNum,
                    PatFieldDefNum, IsMobile
                FROM apptviewitem
                WHERE ApptViewNum = (SELECT ApptViewNum FROM apptview WHERE ClinicNum=1 AND Description='{desc}')
            """)
            if cursor.rowcount > 0:
                print(f"    {desc}: {cursor.rowcount} items cloned")

    # If this IS clinic 1 (already has views), still fix the standalone issues
    elif clinic_num == 1:
        print("  Clinic 1 apptviews already exist — skipping clone")


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

    # apptview distribution
    print(f"\n  apptview by ClinicNum:")
    cursor.execute("SELECT ClinicNum, COUNT(*) FROM apptview GROUP BY ClinicNum")
    for row in cursor.fetchall():
        print(f"    ClinicNum={row[0]}: {row[1]} views")

    # userodapptview
    cursor.execute("SELECT COUNT(*) FROM userodapptview")
    print(f"    userodapptview: {cursor.fetchone()[0]} users")


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
