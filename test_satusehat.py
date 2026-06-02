"""
SatuSehat FHIR R4 flow test script.

Steps:
  1. OAuth2 token
  2. Search Patient by NIK
  3. Use practitioner IHS ID directly (no NIK lookup needed for demo)
  4. Find or create Location
  5. POST Encounter  (identifier, statusHistory, participant, location, diagnosis)
  6. POST Condition  (linked to Encounter)
  7. POST Procedure  (linked to Encounter, SNOMED CT code)

Run:  python test_satusehat.py
Requires: pip install requests
"""

import json
import sys
import requests
from datetime import datetime, timedelta, timezone

# ── Config ─────────────────────────────────────────────────────────────────────
BASE      = "https://api-satusehat-stg.dto.kemkes.go.id"
CLIENT_ID = "dpqSB2g27EMut5T9bh9vQTyBIsjzQTKTLz7ir5553obLFrp6"
CLIENT_SECRET = "EeGT0nfrpjocNgAqfDJimuBXvihiQD7mhWvpGtjf0YAXIScZDHW5TMApJTJb4n4h"
ORG_ID    = "64c250b7-cb7a-409f-8913-75e0dd161ae6"

# Official Kemkes sandbox data
PATIENT_NIK       = "9271060312000001"   # Putra Ardianto
PRACTITIONER_IHS  = "10009880728"        # dr. Alexander (IHS ID, not NIK)
PRACTITIONER_NAME = "Alexander"

# ── Helpers ────────────────────────────────────────────────────────────────────
def ok(label, data):
    print(f"\n✅  {label}")
    if isinstance(data, dict):
        print(json.dumps(data, indent=2)[:600])
    else:
        print(str(data)[:600])

def fail(label, resp):
    print(f"\n❌  {label}  [{resp.status_code}]")
    try:
        print(json.dumps(resp.json(), indent=2)[:1200])
    except Exception:
        print(resp.text[:1200])
    sys.exit(1)

# ── Step 1: Token ──────────────────────────────────────────────────────────────
print("── Step 1: OAuth2 token ──────────────────────────────")
r = requests.post(
    f"{BASE}/oauth2/v1/accesstoken?grant_type=client_credentials",
    data={"client_id": CLIENT_ID, "client_secret": CLIENT_SECRET},
    headers={"Content-Type": "application/x-www-form-urlencoded"},
)
if r.status_code != 200:
    fail("Token", r)
token = r.json()["access_token"]
ok("Token acquired", {"expires_in": r.json().get("expires_in")})

HDR = {"Authorization": f"Bearer {token}", "Content-Type": "application/json", "Accept": "application/json"}

# ── Step 2: Patient ────────────────────────────────────────────────────────────
print("\n── Step 2: Patient by NIK ────────────────────────────")
r = requests.get(
    f"{BASE}/fhir-r4/v1/Patient?identifier=https://fhir.kemkes.go.id/id/nik|{PATIENT_NIK}",
    headers=HDR,
)
if r.status_code != 200:
    fail("Patient search", r)
bundle = r.json()
entries = bundle.get("entry", [])
if not entries:
    fail("Patient search – no entry", r)
patient_ihs = entries[0]["resource"]["id"]
ok("Patient IHS ID", patient_ihs)

# ── Step 3: Practitioner (skip NIK lookup, use IHS directly) ──────────────────
print("\n── Step 3: Practitioner IHS ID (direct, no API call) ─")
ok("Practitioner IHS ID (hardcoded)", PRACTITIONER_IHS)

# ── Step 4: Location (find or create) ─────────────────────────────────────────
print("\n── Step 4: Location ──────────────────────────────────")
location_ihs = None
for param in ("organization", "managingOrganization"):
    r = requests.get(f"{BASE}/fhir-r4/v1/Location?{param}={ORG_ID}", headers=HDR)
    print(f"  GET Location?{param}={ORG_ID}  → {r.status_code}")
    if r.status_code == 200:
        entries = r.json().get("entry", [])
        if entries:
            location_ihs = entries[0]["resource"]["id"]
            ok(f"Existing Location found via '{param}'", location_ihs)
            break

if not location_ihs:
    print("  No existing location — trying to create one...")
    # Try different type coding systems accepted by SatuSehat staging
    type_options = [
        None,  # omit type entirely
        {"coding": [{"system": "http://terminology.kemkes.go.id/CodeSystem/locationServices",
                     "code": "rawatJalan", "display": "Rawat Jalan"}]},
        {"coding": [{"system": "http://snomed.info/sct",
                     "code": "91891000", "display": "Dental service"}]},
        {"coding": [{"system": "http://terminology.hl7.org/CodeSystem/v3-RoleCode",
                     "code": "DX", "display": "Diagnostics or therapeutics unit"}]},
    ]
    for i, type_val in enumerate(type_options):
        loc_body = {
            "resourceType": "Location",
            "identifier": [{"system": f"http://sys-ids.kemkes.go.id/location/{ORG_ID}", "value": "poli-gigi"}],
            "status": "active",
            "name": "Poli Gigi",
            "mode": "instance",
            "physicalType": {"coding": [{"system": "http://terminology.hl7.org/CodeSystem/location-physical-type",
                                          "code": "ro", "display": "Room"}]},
            "managingOrganization": {"reference": f"Organization/{ORG_ID}"},
        }
        if type_val is not None:
            loc_body["type"] = [type_val]
        label = f"no type" if type_val is None else type_val["coding"][0]["system"].split("/")[-1]+":"+type_val["coding"][0]["code"]
        r = requests.post(f"{BASE}/fhir-r4/v1/Location", json=loc_body, headers=HDR)
        print(f"  Create Location ({label}) → {r.status_code}")
        if r.status_code in (200, 201):
            location_ihs = r.json()["id"]
            ok(f"Location created ({label})", location_ihs)
            break
        else:
            try:
                issues = r.json().get("issue", [])
                for iss in issues:
                    print(f"    {iss.get('details',{}).get('text','')}")
            except Exception:
                print(f"    {r.text[:200]}")
    if not location_ihs:
        fail("Create Location (all variants failed)", r)

# ── Step 5: Encounter ──────────────────────────────────────────────────────────
print("\n── Step 5: Encounter ─────────────────────────────────")
apt_num   = "TEST-001"
now       = datetime.now(timezone.utc)
start_str = (now - timedelta(hours=2)).strftime("%Y-%m-%dT%H:%M:%S+07:00")
end_str   = (now - timedelta(hours=1, minutes=30)).strftime("%Y-%m-%dT%H:%M:%S+07:00")
mid_str   = (now - timedelta(hours=1, minutes=35)).strftime("%Y-%m-%dT%H:%M:%S+07:00")

enc_body = {
    "resourceType": "Encounter",
    "identifier": [{"system": f"http://sys-ids.kemkes.go.id/encounter/{ORG_ID}", "value": apt_num}],
    "status": "finished",
    "statusHistory": [
        {"status": "arrived",     "period": {"start": start_str, "end": start_str}},
        {"status": "in-progress", "period": {"start": start_str, "end": mid_str}},
        {"status": "finished",    "period": {"start": start_str, "end": end_str}},
    ],
    "class": {"system": "http://terminology.hl7.org/CodeSystem/v3-ActCode", "code": "AMB", "display": "ambulatory"},
    "subject": {"reference": f"Patient/{patient_ihs}"},
    "participant": [{"type": [{"coding": [{"system": "http://terminology.hl7.org/CodeSystem/v3-ParticipationType",
                                            "code": "ATND", "display": "attender"}]}],
                     "individual": {"reference": f"Practitioner/{PRACTITIONER_IHS}", "display": PRACTITIONER_NAME}}],
    "period": {"start": start_str, "end": end_str},
    "location": [{"location": {"reference": f"Location/{location_ihs}", "display": "Poli Gigi"}}],
    "diagnosis": [{"condition": {"display": "K02.9"},
                   "use": {"coding": [{"system": "http://terminology.hl7.org/CodeSystem/diagnosis-role",
                                       "code": "DD", "display": "Discharge diagnosis"}]},
                   "rank": 1}],
    "serviceProvider": {"reference": f"Organization/{ORG_ID}"},
}

r = requests.post(f"{BASE}/fhir-r4/v1/Encounter", json=enc_body, headers=HDR)
if r.status_code not in (200, 201):
    fail("Create Encounter", r)
encounter_ihs = r.json()["id"]
ok("Encounter IHS ID", encounter_ihs)

# ── Step 6: Condition ──────────────────────────────────────────────────────────
print("\n── Step 6: Condition ─────────────────────────────────")
cond_body = {
    "resourceType": "Condition",
    "clinicalStatus": {"coding": [{"system": "http://terminology.hl7.org/CodeSystem/condition-clinical",
                                    "code": "active"}]},
    "code": {"coding": [{"system": "http://hl7.org/fhir/sid/icd-10", "code": "K02.9",
                          "display": "Dental caries, unspecified"}],
             "text": "Karies gigi"},
    "subject": {"reference": f"Patient/{patient_ihs}"},
    "encounter": {"reference": f"Encounter/{encounter_ihs}"},
}
r = requests.post(f"{BASE}/fhir-r4/v1/Condition", json=cond_body, headers=HDR)
if r.status_code not in (200, 201):
    fail("Create Condition", r)
condition_ihs = r.json()["id"]
ok("Condition IHS ID", condition_ihs)

# ── Step 7: Procedure ──────────────────────────────────────────────────────────
print("\n── Step 7: Procedure ─────────────────────────────────")
proc_body = {
    "resourceType": "Procedure",
    "status": "completed",
    "subject": {"reference": f"Patient/{patient_ihs}"},
    "encounter": {"reference": f"Encounter/{encounter_ihs}"},
    "code": {"coding": [{"system": "http://snomed.info/sct", "code": "225358003",
                          "display": "Dental examination"}],
             "text": "D0120 – Periodic oral evaluation"},
    "performedDateTime": start_str,
    "performer": [{"actor": {"reference": f"Organization/{ORG_ID}"}}],
}
r = requests.post(f"{BASE}/fhir-r4/v1/Procedure", json=proc_body, headers=HDR)
if r.status_code not in (200, 201):
    fail("Create Procedure", r)
procedure_ihs = r.json()["id"]
ok("Procedure IHS ID", procedure_ihs)

# ── Summary ────────────────────────────────────────────────────────────────────
print("\n" + "="*60)
print("ALL STEPS PASSED")
print(f"  Patient   : {patient_ihs}")
print(f"  Practitioner: {PRACTITIONER_IHS}")
print(f"  Location  : {location_ihs}")
print(f"  Encounter : {encounter_ihs}")
print(f"  Condition : {condition_ihs}")
print(f"  Procedure : {procedure_ihs}")
print("="*60)
