import os
import re
import shutil
import pymysql
import xlsxwriter
from collections import defaultdict, Counter

# Connect to database
conn = pymysql.connect(host='localhost', user='root', password='J0k0m4r0k3@', database='helianz')
cur = conn.cursor()

conn_klt = pymysql.connect(host='localhost', user='root', password='J0k0m4r0k3@', database='helianz_klt')
conn_byl = pymysql.connect(host='localhost', user='root', password='J0k0m4r0k3@', database='helianz_byl')
conn_jog = pymysql.connect(host='localhost', user='root', password='J0k0m4r0k3@', database='helianz_jog')

def get_clinic_active(c_conn):
    with c_conn.cursor() as c_cur:
        c_cur.execute("""
            SELECT p.ProcCode, p.Descript, d.ItemName
            FROM procedurecode p
            JOIN definition d ON p.ProcCat = d.DefNum
            WHERE d.Category = 11 AND d.IsHidden = 0 AND LOWER(d.ItemName) NOT LIKE '%obat%'
        """)
        return {re.sub(r'[\s_]+', '', r[0]).upper(): (r[0].strip(), r[1].strip(), r[2].strip()) for r in c_cur.fetchall()}

def get_clinic_all_status(c_conn):
    with c_conn.cursor() as c_cur:
        c_cur.execute("""
            SELECT p.ProcCode, p.Descript, d.ItemName, d.IsHidden
            FROM procedurecode p
            JOIN definition d ON p.ProcCat = d.DefNum
            WHERE d.Category = 11
        """)
        return {re.sub(r'[\s_]+', '', r[0]).upper(): (r[2].strip(), r[3] == 1 or 'obat' in r[2].lower()) for r in c_cur.fetchall()}

klt_act = get_clinic_active(conn_klt)
byl_act = get_clinic_active(conn_byl)
jog_act = get_clinic_active(conn_jog)

klt_all_st = get_clinic_all_status(conn_klt)
byl_all_st = get_clinic_all_status(conn_byl)
jog_all_st = get_clinic_all_status(conn_jog)

active_keys = set(klt_act.keys()) | set(byl_act.keys()) | set(jog_act.keys())
print(f"Strictly active keys across source clinics: {len(active_keys)}")

cat_clean_map = {
    'EXAMS & XRAYS': 'EXAM', 'EXAM': 'EXAM',
    'CLEANINGS': 'CLEAN', 'CLEAN': 'CLEAN',
    'CONSERVATION': 'CONS', 'CONS': 'CONS',
    'ENDO': 'ENDO',
    'PERIO': 'PERIO',
    'DENTURES': 'PROST', 'PROST': 'PROST', 'PROSTHO': 'PROST',
    'COSMETIC': 'COSME', 'COSME': 'COSME',
    'IMPLANTS': 'IMPLANT', 'IMPLANT': 'IMPLANT',
    'ORAL SURGERY': 'OS', 'OS': 'OS',
    'ORTHO': 'ORTHO',
    'PEDO': 'PEDO'
}

cat_order_map = {
    'EXAM': 1, 'CLEAN': 2, 'CONS': 3, 'ENDO': 4,
    'PERIO': 5, 'PROST': 6, 'COSME': 7, 'IMPLANT': 8,
    'OS': 9, 'ORTHO': 10, 'PEDO': 11
}

# Fetch all procedure records in helianz
cur.execute("""
    SELECT p.CodeNum, p.ProcCode, p.Descript, p.ProcCat, p.TreatArea, p.AbbrDesc, d.ItemName
    FROM procedurecode p
    JOIN definition d ON p.ProcCat = d.DefNum
    WHERE d.Category = 11
""")
all_procs = cur.fetchall()

def get_norm_key(pcode, desc):
    clean_code = re.sub(r'[\s_]+', '', pcode).upper()
    if clean_code == 'OS' and 'hect' in desc.lower():
        return 'OS_HECT'
    if clean_code == 'PROM2' and 'behel' in desc.lower():
        return 'PROM2_BEHEL'
    return clean_code

def to_canonical_code(pcode, desc):
    clean = pcode.strip()
    if clean.upper() == 'OS' and 'hect' in desc.lower():
        return 'OS (Hecting)'
    if re.sub(r'[\s_]+', '', clean).upper() == 'PROM2' and 'behel' in desc.lower():
        return 'PROM2 (Behel)'
    m = re.match(r'^([A-Za-z]+)\s*(\d+)$', clean)
    if m:
        return f"{m.group(1).upper()}{m.group(2)}"
    return re.sub(r'\s+', ' ', clean).upper()

area_map = {0: 'Surf', 1: 'Tooth', 2: 'Mouth', 3: 'Quad', 4: 'Sextant', 5: 'Arch', 6: 'ToothRange'}

groups_active = defaultdict(list)
groups_obsolete = defaultdict(list)

for r in all_procs:
    k = get_norm_key(r[1], r[2])
    if k in active_keys:
        groups_active[k].append(r)
    else:
        # Check if it was in source clinics as hidden/obsolete (like PR1, O1..O33)
        groups_obsolete[k].append(r)

print(f"Active procedure groups: {len(groups_active)}")
print(f"Obsolete procedure groups: {len(groups_obsolete)}")

# Fetch all clinic fees strictly
cur.execute("""
    SELECT f.CodeNum, f.ClinicNum, f.FeeSched, f.Amount, f.ProviderShare, f.Bahan, f.Alat
    FROM fee f
    WHERE f.FeeSched IN (56, 57, 58) AND f.ClinicNum IN (1, 2, 3)
""")
fee_map = defaultdict(dict)
for r in cur.fetchall():
    cnum, cl, fs, amt, share, bahan, alat = r
    curr = fee_map[(cnum, cl)].get(fs, {'amt': 0.0, 'share': 0.0, 'bahan': 0.0, 'alat': 0.0})
    fee_map[(cnum, cl)][fs] = {
        'amt': max(curr['amt'], amt or 0.0),
        'share': max(curr['share'], share or 0.0),
        'bahan': max(curr['bahan'], bahan or 0.0),
        'alat': max(curr['alat'], alat or 0.0)
    }

# Build active procedure objects
standardized_procs = []
cat_counts = Counter()

for norm_k, records in groups_active.items():
    codes = [r[1] for r in records]
    descs = [r[2].strip() for r in records]
    clean_desc = max(descs, key=lambda d: len(d))
    canonical_code = to_canonical_code(codes[0], clean_desc)
    
    # Category resolution: prefer source clinic's clean category
    source_cat_entry = klt_act.get(norm_k) or byl_act.get(norm_k) or jog_act.get(norm_k)
    raw_cat_name = source_cat_entry[2] if source_cat_entry else records[0][6]
    clean_cat = cat_clean_map.get(raw_cat_name.upper(), 'CONS')
    cat_order = cat_order_map.get(clean_cat, 99)
    cat_counts[clean_cat] += 1
    
    treat_raw = records[0][4]
    treat_str = area_map.get(treat_raw, 'Mouth') if isinstance(treat_raw, int) else (treat_raw or 'Mouth')
    abbr_str = records[0][5] or ''
    cnums = [r[0] for r in records]
    
    clinics_data = {}
    for cl in [1, 2, 3]:
        cl_fees = {}
        cl_bahan = 0.0
        cl_alat = 0.0
        for fs in [56, 57, 58]:
            amt = 0.0
            share = 0.0
            for cn in cnums:
                if (cn, cl) in fee_map and fs in fee_map[(cn, cl)]:
                    f_entry = fee_map[(cn, cl)][fs]
                    amt = max(amt, f_entry['amt'])
                    share = max(share, f_entry['share'])
                    cl_bahan = max(cl_bahan, f_entry['bahan'])
                    cl_alat = max(cl_alat, f_entry['alat'])
            cl_fees[fs] = {'amt': amt, 'share': share}
            
        tarif = cl_fees[57]['amt'] if cl_fees[57]['amt'] > 0 else (cl_fees[56]['amt'] if cl_fees[56]['amt'] > 0 else cl_fees[58]['amt'])
        clinics_data[cl] = {
            'tarif': tarif,
            'jm_sp': cl_fees[56]['share'],
            'jm_ft': cl_fees[57]['share'],
            'jm_pt': cl_fees[58]['share'],
            'bahan': cl_bahan,
            'alat': cl_alat
        }
        
    standardized_procs.append({
        'norm_key': norm_k,
        'code': canonical_code,
        'descript': clean_desc,
        'cat_name': clean_cat,
        'cat_order': cat_order,
        'abbr': abbr_str.strip(),
        'treat_area': treat_str,
        'codenums': sorted(cnums),
        'clinics': clinics_data
    })

standardized_procs.sort(key=lambda x: (x['cat_order'], x['code']))
print(f"Total verified active procedures to output: {len(standardized_procs)}")

# Build obsolete procedure objects
obsolete_items = []
for norm_k, records in groups_obsolete.items():
    codes = [r[1] for r in records]
    descs = [r[2].strip() for r in records]
    clean_desc = max(descs, key=lambda d: len(d))
    canonical_code = to_canonical_code(codes[0], clean_desc)
    
    klt_s = klt_all_st.get(norm_k, ('N/A', True))[0]
    byl_s = byl_all_st.get(norm_k, ('N/A', True))[0]
    jog_s = jog_all_st.get(norm_k, ('N/A', True))[0]
    cnums = [r[0] for r in records]
    
    obsolete_items.append({
        'code': canonical_code,
        'descript': clean_desc,
        'klt_status': klt_s,
        'byl_status': byl_s,
        'jog_status': jog_s,
        'codenums': sorted(cnums)
    })
obsolete_items.sort(key=lambda x: x['code'])
print(f"Total obsolete procedures archived: {len(obsolete_items)}")

# Generate Excel workbook
excel_path = r'C:\Users\MJO\Desktop\ProcCodes_Harmonized_Clean.xlsx'
wb = xlsxwriter.Workbook(excel_path)

# Styles
f_bold = {'font_name': 'Segoe UI', 'font_size': 9, 'bold': True}
f_regular = {'font_name': 'Segoe UI', 'font_size': 9}

fmt_super_hdr_info = wb.add_format({**f_bold, 'font_color': '#FFFFFF', 'bg_color': '#1E293B', 'align': 'center', 'valign': 'vcenter', 'border': 1})
fmt_super_hdr_klt  = wb.add_format({**f_bold, 'font_color': '#FFFFFF', 'bg_color': '#0F766E', 'align': 'center', 'valign': 'vcenter', 'border': 1})
fmt_super_hdr_byl  = wb.add_format({**f_bold, 'font_color': '#FFFFFF', 'bg_color': '#4338CA', 'align': 'center', 'valign': 'vcenter', 'border': 1})
fmt_super_hdr_jog  = wb.add_format({**f_bold, 'font_color': '#FFFFFF', 'bg_color': '#9D174D', 'align': 'center', 'valign': 'vcenter', 'border': 1})
fmt_super_hdr_act  = wb.add_format({**f_bold, 'font_color': '#FFFFFF', 'bg_color': '#334155', 'align': 'center', 'valign': 'vcenter', 'border': 1})

fmt_sub_hdr_info = wb.add_format({**f_bold, 'font_color': '#FFFFFF', 'bg_color': '#334155', 'align': 'center', 'valign': 'vcenter', 'border': 1})
fmt_sub_hdr_klt  = wb.add_format({**f_bold, 'font_color': '#FFFFFF', 'bg_color': '#14B8A6', 'align': 'center', 'valign': 'vcenter', 'border': 1})
fmt_sub_hdr_byl  = wb.add_format({**f_bold, 'font_color': '#FFFFFF', 'bg_color': '#6366F1', 'align': 'center', 'valign': 'vcenter', 'border': 1})
fmt_sub_hdr_jog  = wb.add_format({**f_bold, 'font_color': '#FFFFFF', 'bg_color': '#F43F5E', 'align': 'center', 'valign': 'vcenter', 'border': 1})
fmt_sub_hdr_act  = wb.add_format({**f_bold, 'font_color': '#FFFFFF', 'bg_color': '#64748B', 'align': 'center', 'valign': 'vcenter', 'border': 1})

fmt_text      = wb.add_format({**f_regular, 'border': 1, 'valign': 'vcenter'})
fmt_text_alt  = wb.add_format({**f_regular, 'border': 1, 'valign': 'vcenter', 'bg_color': '#F8FAFC'})
fmt_code      = wb.add_format({**f_bold, 'border': 1, 'align': 'center', 'valign': 'vcenter'})
fmt_code_alt  = wb.add_format({**f_bold, 'border': 1, 'align': 'center', 'valign': 'vcenter', 'bg_color': '#F8FAFC'})
fmt_cntr      = wb.add_format({**f_regular, 'border': 1, 'align': 'center', 'valign': 'vcenter'})
fmt_cntr_alt  = wb.add_format({**f_regular, 'border': 1, 'align': 'center', 'valign': 'vcenter', 'bg_color': '#F8FAFC'})

fmt_curr      = wb.add_format({**f_regular, 'border': 1, 'align': 'right', 'valign': 'vcenter', 'num_format': '#,##0'})
fmt_curr_alt  = wb.add_format({**f_regular, 'border': 1, 'align': 'right', 'valign': 'vcenter', 'num_format': '#,##0', 'bg_color': '#F8FAFC'})
fmt_curr_klt  = wb.add_format({**f_regular, 'border': 1, 'align': 'right', 'valign': 'vcenter', 'num_format': '#,##0', 'bg_color': '#F0FDFA'})
fmt_curr_byl  = wb.add_format({**f_regular, 'border': 1, 'align': 'right', 'valign': 'vcenter', 'num_format': '#,##0', 'bg_color': '#EEF2FF'})
fmt_curr_jog  = wb.add_format({**f_regular, 'border': 1, 'align': 'right', 'valign': 'vcenter', 'num_format': '#,##0', 'bg_color': '#FFF1F2'})

# SHEET 1: Master_All_Clinics
ws = wb.add_worksheet('Master_All_Clinics')
ws.freeze_panes(2, 2)
ws.set_row(0, 24)
ws.set_row(1, 24)

ws.merge_range(0, 0, 0, 4, 'INFORMASI PROSEDUR', fmt_super_hdr_info)
ws.merge_range(0, 5, 0, 8, 'KLATEN (KLT 1)', fmt_super_hdr_klt)
ws.merge_range(0, 9, 0, 12, 'BOYOLALI (BYL 2)', fmt_super_hdr_byl)
ws.merge_range(0, 13, 0, 16, 'JOGJA (JOG 3)', fmt_super_hdr_jog)
ws.merge_range(0, 17, 0, 18, 'AKSI & REF', fmt_super_hdr_act)

cols = [
    ('ProcCode', 12, fmt_sub_hdr_info),
    ('Deskripsi Tindakan', 42, fmt_sub_hdr_info),
    ('Kategori', 14, fmt_sub_hdr_info),
    ('Abbr', 14, fmt_sub_hdr_info),
    ('Area', 12, fmt_sub_hdr_info),
    
    ('Tarif Pasien KLT', 16, fmt_sub_hdr_klt),
    ('JM Spesialis KLT', 16, fmt_sub_hdr_klt),
    ('JM Fulltimer KLT', 16, fmt_sub_hdr_klt),
    ('JM Parttimer KLT', 16, fmt_sub_hdr_klt),
    
    ('Tarif Pasien BYL', 16, fmt_sub_hdr_byl),
    ('JM Spesialis BYL', 16, fmt_sub_hdr_byl),
    ('JM Fulltimer BYL', 16, fmt_sub_hdr_byl),
    ('JM Parttimer BYL', 16, fmt_sub_hdr_byl),
    
    ('Tarif Pasien JOG', 16, fmt_sub_hdr_jog),
    ('JM Spesialis JOG', 16, fmt_sub_hdr_jog),
    ('JM Fulltimer JOG', 16, fmt_sub_hdr_jog),
    ('JM Parttimer JOG', 16, fmt_sub_hdr_jog),
    
    ('Aksi', 14, fmt_sub_hdr_act),
    ('CodeNum_Ref', 18, fmt_sub_hdr_act),
]

for idx, (col_name, col_width, f_hdr) in enumerate(cols):
    ws.write(1, idx, col_name, f_hdr)
    ws.set_column(idx, idx, col_width)

for r_idx, item in enumerate(standardized_procs, start=2):
    is_alt = (r_idx % 2 == 1)
    f_t = fmt_text_alt if is_alt else fmt_text
    f_c = fmt_code_alt if is_alt else fmt_code
    f_cntr = fmt_cntr_alt if is_alt else fmt_cntr
    
    ws.set_row(r_idx, 20)
    ws.write(r_idx, 0, item['code'], f_c)
    ws.write(r_idx, 1, item['descript'], f_t)
    ws.write(r_idx, 2, item['cat_name'], f_cntr)
    ws.write(r_idx, 3, item['abbr'], f_t)
    ws.write(r_idx, 4, item['treat_area'], f_cntr)
    
    # Klaten
    klt = item['clinics'][1]
    ws.write_number(r_idx, 5, klt['tarif'], fmt_curr_klt)
    ws.write_number(r_idx, 6, klt['jm_sp'], fmt_curr_klt)
    ws.write_number(r_idx, 7, klt['jm_ft'], fmt_curr_klt)
    ws.write_number(r_idx, 8, klt['jm_pt'], fmt_curr_klt)
    
    # Boyolali
    byl = item['clinics'][2]
    ws.write_number(r_idx, 9, byl['tarif'], fmt_curr_byl)
    ws.write_number(r_idx, 10, byl['jm_sp'], fmt_curr_byl)
    ws.write_number(r_idx, 11, byl['jm_ft'], fmt_curr_byl)
    ws.write_number(r_idx, 12, byl['jm_pt'], fmt_curr_byl)
    
    # Jogja
    jog = item['clinics'][3]
    ws.write_number(r_idx, 13, jog['tarif'], fmt_curr_jog)
    ws.write_number(r_idx, 14, jog['jm_sp'], fmt_curr_jog)
    ws.write_number(r_idx, 15, jog['jm_ft'], fmt_curr_jog)
    ws.write_number(r_idx, 16, jog['jm_pt'], fmt_curr_jog)
    
    # Aksi & Ref
    ws.write(r_idx, 17, 'Keep', f_cntr)
    ws.write(r_idx, 18, ','.join(map(str, item['codenums'])), f_cntr)

valid_cats = ['EXAM', 'CLEAN', 'CONS', 'ENDO', 'PERIO', 'PROST', 'COSME', 'IMPLANT', 'OS', 'ORTHO', 'PEDO']
valid_actions = ['Keep', 'Hide / Obsolete']
valid_areas = ['Mouth', 'Tooth', 'Surf', 'Arch', 'Quad', 'Sextant', 'ToothRange']

num_rows = len(standardized_procs)
ws.data_validation(2, 2, num_rows + 1, 2, {'validate': 'list', 'source': valid_cats, 'error_type': 'warning'})
ws.data_validation(2, 4, num_rows + 1, 4, {'validate': 'list', 'source': valid_areas, 'error_type': 'warning'})
ws.data_validation(2, 17, num_rows + 1, 17, {'validate': 'list', 'source': valid_actions, 'error_type': 'warning'})
ws.autofilter(1, 0, num_rows + 1, len(cols) - 1)

# Helper function for clinic individual sheets
def add_clinic_sheet(sheet_name, cl_id, hdr_format, super_format, bg_curr_format):
    ws_cl = wb.add_worksheet(sheet_name)
    ws_cl.freeze_panes(1, 2)
    ws_cl.set_row(0, 26)
    
    cl_cols = [
        ('ProcCode', 12),
        ('Deskripsi Tindakan', 42),
        ('Kategori', 14),
        ('Abbr', 14),
        ('Area', 12),
        ('Tarif Pasien', 18),
        ('JM Spesialis', 18),
        ('JM Fulltimer', 18),
        ('JM Parttimer', 18),
        ('Biaya Bahan', 16),
        ('Biaya Alat', 16),
        ('Aksi', 14)
    ]
    for c_i, (c_name, c_w) in enumerate(cl_cols):
        ws_cl.write(0, c_i, c_name, hdr_format)
        ws_cl.set_column(c_i, c_i, c_w)
        
    for r_i, p_item in enumerate(standardized_procs, start=1):
        is_a = (r_i % 2 == 0)
        c_data = p_item['clinics'][cl_id]
        
        ws_cl.set_row(r_i, 20)
        ws_cl.write(r_i, 0, p_item['code'], fmt_code_alt if is_a else fmt_code)
        ws_cl.write(r_i, 1, p_item['descript'], fmt_text_alt if is_a else fmt_text)
        ws_cl.write(r_i, 2, p_item['cat_name'], fmt_cntr_alt if is_a else fmt_cntr)
        ws_cl.write(r_i, 3, p_item['abbr'], fmt_text_alt if is_a else fmt_text)
        ws_cl.write(r_i, 4, p_item['treat_area'], fmt_cntr_alt if is_a else fmt_cntr)
        
        ws_cl.write_number(r_i, 5, c_data['tarif'], bg_curr_format)
        ws_cl.write_number(r_i, 6, c_data['jm_sp'], bg_curr_format)
        ws_cl.write_number(r_i, 7, c_data['jm_ft'], bg_curr_format)
        ws_cl.write_number(r_i, 8, c_data['jm_pt'], bg_curr_format)
        ws_cl.write_number(r_i, 9, c_data['bahan'], fmt_curr_alt if is_a else fmt_curr)
        ws_cl.write_number(r_i, 10, c_data['alat'], fmt_curr_alt if is_a else fmt_curr)
        ws_cl.write(r_i, 11, 'Keep', fmt_cntr_alt if is_a else fmt_cntr)
        
    ws_cl.data_validation(1, 2, num_rows, 2, {'validate': 'list', 'source': valid_cats, 'error_type': 'warning'})
    ws_cl.data_validation(1, 4, num_rows, 4, {'validate': 'list', 'source': valid_areas, 'error_type': 'warning'})
    ws_cl.data_validation(1, 11, num_rows, 11, {'validate': 'list', 'source': valid_actions, 'error_type': 'warning'})
    ws_cl.autofilter(0, 0, num_rows, len(cl_cols) - 1)

add_clinic_sheet('Klaten_KLT', 1, fmt_sub_hdr_klt, fmt_super_hdr_klt, fmt_curr_klt)
add_clinic_sheet('Boyolali_BYL', 2, fmt_sub_hdr_byl, fmt_super_hdr_byl, fmt_curr_byl)
add_clinic_sheet('Jogja_JOG', 3, fmt_sub_hdr_jog, fmt_super_hdr_jog, fmt_curr_jog)

# SHEET 5: Obsolete_Archived (Retired codes like PR1, O1..O33)
ws_obs = wb.add_worksheet('Obsolete_Archived')
ws_obs.freeze_panes(1, 1)
ws_obs.set_row(0, 26)

obs_cols = [
    ('Kode Lama (ProcCode)', 18),
    ('Deskripsi Tindakan Lama', 45),
    ('Kategori di Klaten', 22),
    ('Kategori di Boyolali', 22),
    ('Kategori di Jogja', 22),
    ('Keterangan / Alasan Diarsipkan', 40),
    ('CodeNum_Ref', 18)
]
for c_i, (c_name, c_w) in enumerate(obs_cols):
    ws_obs.write(0, c_i, c_name, fmt_super_hdr_info)
    ws_obs.set_column(c_i, c_i, c_w)

for r_i, obs_item in enumerate(obsolete_items, start=1):
    is_a = (r_i % 2 == 0)
    f_t = fmt_text_alt if is_a else fmt_text
    f_c = fmt_code_alt if is_a else fmt_code
    f_cntr = fmt_cntr_alt if is_a else fmt_cntr
    
    note = "Sudah digantikan dengan kode baru (Contoh: PR diganti PS, O diganti OR)"
    if obs_item['code'].startswith('PR'):
        note = "Prosedur Prostho lama (telah digantikan kode seri PS)"
    elif obs_item['code'].startswith('O') and obs_item['code'] not in ('OS', 'OS (Hecting)'):
        note = "Prosedur Ortho lama (telah digantikan kode seri OR)"
    elif obs_item['code'].startswith('00'):
        note = "Kode administrasi/screening lama 2018 (tidak aktif)"
        
    ws_obs.set_row(r_i, 20)
    ws_obs.write(r_i, 0, obs_item['code'], f_c)
    ws_obs.write(r_i, 1, obs_item['descript'], f_t)
    ws_obs.write(r_i, 2, obs_item['klt_status'], f_cntr)
    ws_obs.write(r_i, 3, obs_item['byl_status'], f_cntr)
    ws_obs.write(r_i, 4, obs_item['jog_status'], f_cntr)
    ws_obs.write(r_i, 5, note, f_t)
    ws_obs.write(r_i, 6, ','.join(map(str, obs_item['codenums'])), f_cntr)

ws_obs.autofilter(0, 0, len(obsolete_items), len(obs_cols) - 1)

# SHEET 6: Categories_Reference
ws_cat = wb.add_worksheet('Categories_Reference')
ws_cat.freeze_panes(1, 0)
ws_cat.set_row(0, 26)

cat_headers = [('Kategori Singkat', 20), ('Nama Lengkap Bidang', 35), ('Jumlah Prosedur Aktif', 25), ('Keterangan Klinis', 45)]
for c_idx, (h_n, w) in enumerate(cat_headers):
    ws_cat.write(0, c_idx, h_n, fmt_super_hdr_info)
    ws_cat.set_column(c_idx, c_idx, w)

cat_info = [
    ('EXAM', 'Pemeriksaan & Konsultasi', 'Konsultasi dokter umum/spesialis, foto rontgen, diagnosa'),
    ('CLEAN', 'Pembersihan Karang Gigi', 'Scaling, profilaksis, fluoridasi, pembersihan rutin'),
    ('CONS', 'Konservasi Gigi (Penambalan)', 'Tambalan komposit, GIC, restorasi estetik'),
    ('ENDO', 'Endodontik (Perawatan Saluran Akar)', 'PSA, devitalisasi pulpa, obturasi saluran akar'),
    ('PERIO', 'Periodonsia (Gusi & Jaringan)', 'Kuretase gingiva, splinting, perawatan gusi'),
    ('PROST', 'Prostodonsia (Gigi Tiruan / Crown)', 'Gigi tiruan lepasan, mahkota/crown, bridge, veneer'),
    ('COSME', 'Kosmetik & Estetika', 'Bleaching / pemutihan gigi, diamond tooth'),
    ('IMPLANT', 'Implant Gigi', 'Pemasangan implan & mahkota implan'),
    ('OS', 'Bedah Mulut (Oral Surgery / Cabut)', 'Pencabutan gigi sulung/tetap, odontektomi, insisi'),
    ('ORTHO', 'Ortodonti (Kawat Gigi)', 'Pasang behel, kontrol ortho, retensi, cetak studi'),
    ('PEDO', 'Kedokteran Gigi Anak', 'Perawatan khusus gigi anak, pulpotomi, space maintainer')
]

for r_idx, (c_code, c_full, c_desc) in enumerate(cat_info, start=1):
    cnt = cat_counts.get(c_code, 0)
    ws_cat.set_row(r_idx, 20)
    ws_cat.write(r_idx, 0, c_code, fmt_code)
    ws_cat.write(r_idx, 1, c_full, fmt_text)
    ws_cat.write(r_idx, 2, cnt, fmt_cntr)
    ws_cat.write(r_idx, 3, c_desc, fmt_text)

ws_cat.autofilter(0, 0, len(cat_info), len(cat_headers) - 1)

# SHEET 7: Panduan_Staff
ws_info = wb.add_worksheet('Panduan_Staff')
ws_info.set_column(0, 0, 85)
fmt_title = wb.add_format({'bold': True, 'font_size': 14, 'font_name': 'Segoe UI', 'font_color': '#1E293B'})
fmt_subtitle = wb.add_format({'bold': True, 'font_size': 11, 'font_name': 'Segoe UI', 'font_color': '#0F172A'})
fmt_body = wb.add_format({'font_size': 10, 'font_name': 'Segoe UI'})

instructions = [
    (fmt_title, 'PANDUAN HARMONISASI TARIF & JASA MEDIS (SHARE FEE) KLINIK HELIANZ'),
    (fmt_body, ''),
    (fmt_subtitle, '1. Struktur Sheet di File Excel Ini:'),
    (fmt_body, '   - Master_All_Clinics : 266 tindakan AKTIF hasil perbandingan side-by-side (Klaten, Boyolali, Jogja).'),
    (fmt_body, '   - Klaten_KLT         : Rincian 266 tindakan, tarif, share fee, bahan & alat khusus cabang Klaten.'),
    (fmt_body, '   - Boyolali_BYL       : Rincian 266 tindakan, tarif, share fee, bahan & alat khusus cabang Boyolali.'),
    (fmt_body, '   - Jogja_JOG          : Rincian 266 tindakan, tarif, share fee, bahan & alat khusus cabang Jogja.'),
    (fmt_body, '   - Obsolete_Archived  : 197 tindakan LAMA (seperti PR1, O1..O33) yang sudah tidak aktif di cabang.'),
    (fmt_body, '   - Categories_Reference: Daftar kategori aktif dan jumlah prosedur saat ini.'),
    (fmt_body, ''),
    (fmt_subtitle, '2. Tindakan Obsolete / Harga Lama yang Telah Disaring:'),
    (fmt_body, '   - Kode PR1 s/d PR19 (Prostho lama) telah disaring karena sudah digantikan oleh kode seri PS.'),
    (fmt_body, '   - Kode O1 s/d O33 (Ortho lama) telah disaring karena sudah digantikan oleh kode seri OR.'),
    (fmt_body, '   - Kode-kode lama tersebut dapat dilihat pada sheet "Obsolete_Archived".'),
    (fmt_body, ''),
    (fmt_subtitle, '3. Arti Kolom Finansial:'),
    (fmt_body, '   - Tarif Pasien : Biaya total yang ditagihkan ke pasien untuk tindakan tersebut.'),
    (fmt_body, '   - JM Spesialis : Jasa Medis (share fee) yang diterima Dokter Gigi Spesialis.'),
    (fmt_body, '   - JM Fulltimer : Jasa Medis (share fee) yang diterima Dokter Gigi Umum Fulltimer.'),
    (fmt_body, '   - JM Parttimer : Jasa Medis (share fee) yang diterima Dokter Gigi Umum Parttimer.'),
    (fmt_body, '   - Biaya Bahan / Alat : Komponen biaya bahan habis pakai & sewa alat jika ada.'),
    (fmt_body, ''),
    (fmt_subtitle, '4. Penyimpanan & Sinkronisasi Database:'),
    (fmt_body, '   - Setelah tim klinik selesai mengedit angka tarif & JM, klik Simpan (Save).'),
    (fmt_body, '   - Beritahu kami agar kami sinkronkan langsung ke database Helianz secara aman.')
]

for r_idx, (fmt_line, text_line) in enumerate(instructions):
    ws_info.set_row(r_idx, 20)
    ws_info.write(r_idx, 0, text_line, fmt_line)

wb.close()
conn.close()
conn_klt.close()
conn_byl.close()
conn_jog.close()

# Also try to make copies if not locked
for target_f in [r'C:\Users\MJO\Desktop\ProcCodes_klt.xlsx', r'C:\Users\MJO\Desktop\ProcCodes_Fees_AllClinics.xlsx']:
    try:
        shutil.copyfile(excel_path, target_f)
        print(f"SUCCESS! Copied to {os.path.basename(target_f)}")
    except Exception as e:
        print(f"Notice: {os.path.basename(target_f)} was open/locked, skipped copy.")

print('SUCCESS! Generated ProcCodes_Harmonized_Clean.xlsx with 266 active procedures and 197 obsolete archived.')
