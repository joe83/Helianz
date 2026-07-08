"""
Simulate merging N clinics into one database.
Creates heliantmp_1, heliantmp_2, ... heliantmp_N from copies of helianz,
segregates each to its clinic number, offsets PKs, then merges into a target.

Usage:
  python simulate_merge.py --count 3                    # 3 clinics: heliantmp_1,2,3
  python simulate_merge.py --count 2 --prefix sim_      # sim_1, sim_2
  python simulate_merge.py --count 3 --skip-offset       # Skip offset (faster, just test segregate)
  python simulate_merge.py --count 3 --target final_db  # Merge into final_db instead of {prefix}merged
"""
import mysql.connector
import subprocess
import argparse
import sys
import os

HOST = "localhost"
USER = "root"
PASSWORD = "J0k0m4r0k3@"
MYSQL = rf'"C:\Program Files\MariaDB 10.5\bin\mysql.exe"'
MYSQLDUMP = rf'"C:\Program Files\MariaDB 10.5\bin\mysqldump.exe"'
PYTHON = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                       '.venv', 'Scripts', 'python.exe')
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
SEGREGATE = os.path.join(SCRIPT_DIR, 'segregate_clinic.py')
OFFSET = os.path.join(SCRIPT_DIR, 'offset_db.py')
MERGE = os.path.join(SCRIPT_DIR, 'merge_clinics.py')

CLINIC_NAMES = {1: "Klaten", 2: "Jogja", 3: "Boyolali",
                4: "Clinic 4", 5: "Clinic 5", 6: "Clinic 6",
                7: "Clinic 7", 8: "Clinic 8", 9: "Clinic 9", 10: "Clinic 10"}


def run_cmd(cmd, check=True):
    """Run shell command, return (returncode, stdout, stderr)."""
    env = os.environ.copy()
    env['PYTHONIOENCODING'] = 'utf-8'
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True, env=env)
    if result.returncode != 0 and result.stderr.strip():
        # Filter out unicode-related errors from stderr (they're just print issues)
        err = result.stderr.strip()
        if 'UnicodeEncodeError' not in err and 'charmap' not in err:
            print(f"  [!] {err[:300]}")
    return result


def run_sql(db, sql):
    """Execute SQL on a database."""
    conn = mysql.connector.connect(host=HOST, user=USER, password=PASSWORD, database=db)
    c = conn.cursor()
    for stmt in sql.split(";"):
        stmt = stmt.strip()
        if stmt:
            try:
                c.execute(stmt)
            except Exception as e:
                print(f"  ⚠️  SQL: {e}: {stmt[:80]}")
    conn.commit()
    c.close()
    conn.close()


def reset_clinic_to_zero(db):
    """Move all clinic-specific tables to ClinicNum=0."""
    tables = ["patient", "procedurelog", "appointment", "histappointment",
              "payment", "paysplit", "adjustment", "operatory", "schedule",
              "userod", "providerclinic", "computerpref", "fee", "apptview",
              "alertitem", "alertsub", "ebill", "proctp"]
    for t in tables:
        run_sql(db, f"UPDATE `{t}` SET ClinicNum = 0")
    run_sql(db, "DELETE FROM userclinic; DELETE FROM providercliniclink")


def main():
    parser = argparse.ArgumentParser(description="Simulate N-clinic merge from helianz copies")
    parser.add_argument("--count", type=int, required=True, help="Number of clinics to simulate")
    parser.add_argument("--prefix", default="heliantmp_", help="DB name prefix (default: heliantmp_)")
    parser.add_argument("--target", default=None, help="Target DB (default: {prefix}merged)")
    parser.add_argument("--skip-offset", action="store_true", help="Skip PK offset (faster test)")
    parser.add_argument("--offset-gap", type=int, default=1_000_000, help="Offset gap between clinics (default: 1000000)")
    args = parser.parse_args()

    count = args.count
    prefix = args.prefix
    target = args.target or f"{prefix}merged"
    offset_gap = args.offset_gap

    print("=" * 60)
    print(f"N-CLINIC MERGE SIMULATION (count={count})")
    print("=" * 60)
    print(f"  Source prefix: {prefix}<N>")
    print(f"  Target:        {target}")
    print(f"  Offset gap:    +{offset_gap:,}")
    if args.skip_offset:
        print(f"  ⚠️  Skipping offset (PKs will collide!)")

    # ── Step 1: Create target with Klaten data ──
    print(f"\n{'─'*40}")
    print(f"STEP 1: Creating target '{target}' from helianz (ClinicNum=1)")
    print(f"{'─'*40}")
    run_cmd(f"{MYSQL} -u {USER} -p\"{PASSWORD}\" -e \"DROP DATABASE IF EXISTS {target}; CREATE DATABASE {target} CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;\"")
    run_cmd(f"{MYSQLDUMP} -u {USER} -p\"{PASSWORD}\" --single-transaction --routines --triggers --events helianz | {MYSQL} -u {USER} -p\"{PASSWORD}\" {target}")
    print("  ✅ Target ready (ClinicNum=1)")

    # ── Step 2: Process each simulated clinic ──
    sources = []
    for n in range(2, count + 1):
        db_name = f"{prefix}{n}"
        clinic_num = n
        offset_val = (clinic_num - 1) * offset_gap  # Clinic 2→1M, 3→2M, 4→3M...
        clinic_name = CLINIC_NAMES.get(n, f"Clinic {n}")

        print(f"\n{'─'*40}")
        print(f"STEP 2.{n - 1}: Processing {clinic_name} → {db_name} (ClinicNum={clinic_num}, offset=+{offset_val:,})")
        print(f"{'─'*40}")

        # 2a. Create temp DB
        print(f"  Creating {db_name} from helianz...")
        run_cmd(f"{MYSQL} -u {USER} -p\"{PASSWORD}\" -e \"DROP DATABASE IF EXISTS {db_name}; CREATE DATABASE {db_name} CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;\"")
        result = run_cmd(f"{MYSQLDUMP} -u {USER} -p\"{PASSWORD}\" --single-transaction --routines --triggers --events helianz | {MYSQL} -u {USER} -p\"{PASSWORD}\" {db_name}")
        if result.returncode != 0:
            print(f"  ❌ Failed to create {db_name}, skipping...")
            continue
        sources.append(db_name)

        # 2b. Reset ClinicNum to 0
        print(f"  Resetting ClinicNum → 0...")
        reset_clinic_to_zero(db_name)

        # 2c. Segregate
        print(f"  Segregating to ClinicNum={clinic_num}...")
        run_cmd(f"{PYTHON} {SEGREGATE} {clinic_num} --db {db_name} --yes")

        # 2d. Offset
        if not args.skip_offset:
            print(f"  Offsetting PKs by +{offset_val:,}...")
            result = run_cmd(f"{PYTHON} {OFFSET} {offset_val} --db {db_name}")
            if result.returncode != 0:
                print(f"  ❌ Offset failed for {db_name}")
        else:
            print(f"  ⚠️  Skipping offset")

        print(f"  ✅ {clinic_name} ready")

    # ── Step 3: Merge ──
    print(f"\n{'─'*40}")
    print(f"STEP 3: Merging into {target}")
    print(f"{'─'*40}")
    sources_str = ",".join(sources)
    if sources:
        run_cmd(f"{PYTHON} {MERGE} --target {target} --sources {sources_str}")
    else:
        print("  ❌ No sources to merge!")

    print(f"\n{'='*60}")
    print(f"SIMULATION COMPLETE — Target: {target}")
    print(f"{'='*60}")


if __name__ == "__main__":
    main()
