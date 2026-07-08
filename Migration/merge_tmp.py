"""Merge jogja and byl temp DBs into heliantmp_merged.
INCLUDES auto_increment PK columns since IDs are offset (no collisions)."""
import mysql.connector

HOST = "localhost"
USER = "root"
PASSWORD = "J0k0m4r0k3@"
MERGED = "heliantmp_merged"

TABLES = [
    # Clinic-specific tables (have ClinicNum column)
    'adjustment','alertitem','alertsub','appointment','apptview','clearinghouse',
    'computerpref','ebill','fee','histappointment','operatory','patient','payment','paysplit',
    'procedurelog','proctp','providerclinic','providercliniclink','schedule','userclinic',
    'userod','userodapptview','userodpref','apptreminderrule','emailhostingtemplate',
    'programproperty','apptgeneralmessagesent','apptnewpatthankyousent','asapcomm',
    'autocommexcludedate','carecreditwebresponse','claim','claimpayment','claimproc',
    'clinicerx','clinicpref','clockevent','confirmationrequest','creditcard','dunning',
    'eclipboardimagecapturedef','eclipboardsheetdef','emailsecure','emailsecureattach',
    'erouting','eroutingdef','eservicelog','hieclinic','limitedbetafeature',
    'midtransconfig','midtranstransaction','mobileappdevice','mobilebrandingprofile',
    'msgtopaysent','orthocase','patientportalinvite','payplancharge','payplantemplate',
    'payterminal','pharmclinic','promotion','promotionlog','recurringcharge',
    'referralcliniclink','rxpat','smsfrommobile','smsphone','smstomobile','timeadjust',
    'tsitranslog','webschedcarrierrule','webschedrecall','xwebresponse','sheet',
    # Shared tables with PatNum (patient-specific data — need merging)
    'allergy','anestheticrecord','anesthvsdata','commlog','commoptout',
    'custreference','discountplansub','disease','document','eclipboardimagecapture',
    'eform','eformfield','ehramendment','ehrcareplan','ehrlab','ehrmeasureevent',
    'ehrnotperformed','ehrpatient','ehrprovkey','ehrquarterlykey','ehrsummaryccd',
    'emailmessage','encounter','erxlog','etrans','famaging','familyhealth',
    'formpat','hiequeue','hl7msg','installmentplan','intervention','labcase',
    'labpanel','medicalorder','medicationpat','medlab','mobiledatabyte','mount',
    'orthochart','orthochartlog','orthochartrow','orthohardware','patfield',
    'patientnote','patientrace','patplan','patrestriction','payconnectresponseweb',
    'payortype','payplan','perioexam','phonenumber','popup','procmultivisit',
    'procnote','providererx','question','reactivation','recall','refattach',
    'referral','registrationkey','repeatcharge','reqstudent','reseller',
    'satusehatstatus','screenpat','securitylog','statement','terminalactive',
    'toothinitial','treatplan','treatplanparam','vaccinepat','vitalsign',
    'xchargetransaction',
]

conn = mysql.connector.connect(host=HOST, user=USER, password=PASSWORD, database=MERGED)
c = conn.cursor()
c.execute("SET FOREIGN_KEY_CHECKS = 0")

for src_db in ['heliantmp_jogja', 'heliantmp_byl']:
    print(f"\nMerging {src_db}...")
    for table in TABLES:
        try:
            c.execute(f"SELECT COUNT(*) FROM {src_db}.`{table}`")
            cnt = c.fetchone()[0]
            if cnt == 0:
                continue
            # Get ALL columns including PK
            c.execute(f"SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='{src_db}' AND TABLE_NAME='{table}' ORDER BY ORDINAL_POSITION")
            cols = [r[0] for r in c.fetchall()]
            if not cols:
                continue
            col_list = "`, `".join(cols)
            c.execute(f"INSERT INTO `{MERGED}`.`{table}` (`{col_list}`) SELECT `{col_list}` FROM `{src_db}`.`{table}`")
            if c.rowcount > 0:
                print(f"  {table}: {c.rowcount}")
        except Exception as e:
            print(f"  {table}: ERROR - {e}")
    conn.commit()

c.execute("SET FOREIGN_KEY_CHECKS = 1")

# Verify
c2 = conn.cursor(buffered=True)
c2.execute("SELECT ClinicNum, COUNT(*) FROM patient GROUP BY ClinicNum ORDER BY ClinicNum")
print(f"\n{'='*50}")
print("VERIFICATION")
print(f"{'='*50}")
print("\nPatients by clinic:")
for r in c2.fetchall():
    print(f"  ClinicNum={r[0]}: {r[1]}")
c2.execute("SELECT COUNT(*) FROM patient")
print(f"  TOTAL: {c2.fetchone()[0]}")

checks = [
    ("proc->pat", "procedurelog", "PatNum", "patient", "PatNum"),
    ("apt->pat", "appointment", "PatNum", "patient", "PatNum"),
    ("apt->op", "appointment", "Op", "operatory", "OperatoryNum"),
    ("split->pat", "paysplit", "PatNum", "patient", "PatNum"),
    ("pay->pat", "payment", "PatNum", "patient", "PatNum"),
    ("adj->pat", "adjustment", "PatNum", "patient", "PatNum"),
]
print("\nFK integrity:")
all_ok = True
for label, ft, fc, pt, pc in checks:
    c2.execute(f"SELECT COUNT(*) FROM `{ft}` WHERE `{fc}`>0 AND `{fc}` NOT IN (SELECT `{pc}` FROM `{pt}`)")
    n = c2.fetchone()[0]
    ok = "OK" if n == 0 else f"FAIL ({n})"
    if n > 0: all_ok = False
    print(f"  {label}: {ok}")

c2.execute("SELECT ClinicNum, MIN(PatNum), MAX(PatNum) FROM patient GROUP BY ClinicNum ORDER BY ClinicNum")
print("\nPK ranges:")
for r in c2.fetchall():
    print(f"  ClinicNum={r[0]}: PatNum {r[1]} -> {r[2]}")

print(f"\n{'✅ ALL CLEAN!' if all_ok else '❌ HAS ORPHANS'}")

c2.close()
c.close()
conn.close()
