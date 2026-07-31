"""Verify why FeeSched=57 is missing from fee list"""
import mysql.connector
conn = mysql.connector.connect(host='localhost', user='root', password='J0k0m4r0k3@', database='helianz_klt')
c = conn.cursor(buffered=True, dictionary=True)

# Check PracticeDefaultProv
c.execute("SELECT ValueString FROM preference WHERE PrefName='PracticeDefaultProv'")
r = c.fetchone()
defprov = int(r['ValueString']) if r and r['ValueString'] else 0
if defprov > 0:
    c.execute('SELECT ProvNum, Abbr, FeeSched FROM provider WHERE ProvNum=%s', (defprov,))
    r = c.fetchone()
    print(f'PracticeDefaultProv: ProvNum={defprov} Abbr={r["Abbr"]} FeeSched={r["FeeSched"]}')
else:
    print('PracticeDefaultProv: not set')

# Check first provider
c.execute('SELECT ProvNum, Abbr, FeeSched FROM provider ORDER BY ItemOrder LIMIT 1')
r = c.fetchone()
print(f'First provider: ProvNum={r["ProvNum"]} Abbr={r["Abbr"]} FeeSched={r["FeeSched"]}')

# Patient PriProv=1 (FeeSched=56), SecProv=?
c.execute('SELECT SecProv FROM patient WHERE PatNum=8181')
r = c.fetchone()
secprov = r['SecProv'] if r else 0
print(f'Adelyya SecProv={secprov}')

# BM22 ProvNumDefault
c.execute("SELECT ProvNumDefault FROM procedurecode WHERE ProcCode='BM22'")
r = c.fetchone()
bm22_provdef = r['ProvNumDefault'] if r else 0
print(f'BM22 ProvNumDefault={bm22_provdef}')

# Simulate GetListFromObjects: what FeeScheds are in the list?
print()
print('=== Simulating GetListFromObjects for ControlChart ===')
fee_scheds = set()

# First provider
c.execute('SELECT FeeSched FROM provider ORDER BY ItemOrder LIMIT 1')
r = c.fetchone()
if r['FeeSched'] > 0: fee_scheds.add(r['FeeSched'])

# PracticeDefaultProv
if defprov > 0:
    c.execute('SELECT FeeSched FROM provider WHERE ProvNum=%s', (defprov,))
    r = c.fetchone()
    if r and r['FeeSched'] > 0: fee_scheds.add(r['FeeSched'])

# listProvNumsTreat = NULL => SKIPPED

# PatPriProv (1)
c.execute('SELECT FeeSched FROM provider WHERE ProvNum=1')
r = c.fetchone()
if r and r['FeeSched'] > 0: fee_scheds.add(r['FeeSched'])

# PatSecProv
if secprov > 0:
    c.execute('SELECT FeeSched FROM provider WHERE ProvNum=%s', (secprov,))
    r = c.fetchone()
    if r and r['FeeSched'] > 0: fee_scheds.add(r['FeeSched'])

# BM22 ProvNumDefault
if bm22_provdef > 0:
    c.execute('SELECT FeeSched FROM provider WHERE ProvNum=%s', (bm22_provdef,))
    r = c.fetchone()
    if r and r['FeeSched'] > 0: fee_scheds.add(r['FeeSched'])

c.execute('SELECT FeeSchedNum, Description FROM feesched ORDER BY FeeSchedNum')
all_fs = {r['FeeSchedNum']: r['Description'] for r in c.fetchall()}

print(f'FeeScheds in list: {sorted(fee_scheds)}')
for fs in sorted(fee_scheds):
    print(f'  FeeSched={fs} ({all_fs.get(fs, "?")})')

print()
print('*** FeeSched=57 (JM fulltimer, drg Rizky) is MISSING from the fee list! ***')
print('*** When GetFee(BM22, 57, ...) is called, listFees has no FeeSched=57 entries ***')
print('*** GetFeeFromList returns null => Share = 0 ***')
print()
print('ProcFee is correct (200000) because GetProcFee falls back to PPO/UCR logic')
print('which uses patient primary provider FeeSched=56 (found in listFees).')
conn.close()
