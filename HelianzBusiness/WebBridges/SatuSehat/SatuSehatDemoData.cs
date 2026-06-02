using System;
using System.Collections.Generic;
using System.Reflection;
using DataConnectionBase;

namespace HelianzBusiness.WebBridges.SatuSehat {
	///<summary>Generates Indonesian patient records for SatuSehat integration testing using official Kemkes sandbox data.
	///Each call inserts patients, appointments, and procedures, then enqueues them as Pending in satusehatstatus.</summary>
	public class SatuSehatDemoData {

		///<summary>Official Kemkes SatuSehat sandbox patient data (Tabel 1 – Patient dummy data for Sandbox/Staging).
		///Source: https://satusehat.kemkes.go.id/platform/docs/id/api-catalogue/onboardings/apis/patient/
		///Phone numbers are fictional placeholders.</summary>
		private static readonly DemoPatient[] _demoPatients=new DemoPatient[] {
			//NIK 9271060312000001 → Kemkes sandbox patient 1 (Ardianto Putra, male, IHS: P02478375538)
			new DemoPatient("Putra",   "Ardianto", PatientGender.Male,   new DateTime(1992,1,9),  "9271060312000001","Jl. Cenderawasih No. 1","Jayapura","62812000001"),
			//NIK 9204014804000002 → Kemkes sandbox patient 2 (Claudia Sintia, female, IHS: P03647103112)
			new DemoPatient("Sintia",  "Claudia",  PatientGender.Female, new DateTime(1989,11,3), "9204014804000002","Jl. Trikora No. 8",     "Sorong",  "62813000002"),
			//NIK 9104224606000005 → Kemkes sandbox patient 5 (Ghina Assyifa, female, IHS: P01654557057)
			new DemoPatient("Assyifa", "Ghina",    PatientGender.Female, new DateTime(2004,8,21), "9104224606000005","Jl. Pattimura No. 5",   "Ambon",   "62821000005"),
		};

		///<summary>Official Kemkes SatuSehat sandbox practitioner data (Tabel 1 – Practitioner dummy data for Sandbox/Staging).
		///Source: https://satusehat.kemkes.go.id/platform/docs/id/api-catalogue/onboardings/apis/practitioner/
		///KnownIhsId is stored in provider.NationalProvID so SyncEncounter can use it directly without an API lookup.</summary>
		private static readonly DemoPractitioner[] _demoPractitioners=new DemoPractitioner[] {
			//NIK 7209061211900001 → Kemkes sandbox practitioner 1 (dr. Alexander, male, IHS: 10009880728)
			new DemoPractitioner("Alexander",    "dr.",PatientGender.Male,new DateTime(1994,1,1),"7209061211900001","10009880728"),
			//NIK 3322071302900002 → Kemkes sandbox practitioner 2 (dr. Yoga Yandika Sp.A, male, IHS: 10006926841)
			new DemoPractitioner("Yoga Yandika", "dr.",PatientGender.Male,new DateTime(1995,2,2),"3322071302900002","10006926841"),
		};

		///<summary>Inserts demo patients, appointments, and procedures into the database and enqueues each resource in satusehatstatus.
		///Also ensures demo practitioners exist as Helianz Provider records (identified by NationalProvID = NIK).
		///Skips patients whose NIK already exists in the patient table.
		///Returns the number of new patients created.</summary>
		public static int CreateDemoData() {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				return Meth.GetInt(MethodBase.GetCurrentMethod());
			}
			long codeNum=GetOrCreateDemoProcedureCode();
			//Ensure the first sandbox practitioner exists as a Helianz provider and get their ProvNum.
			long demoProv1Num=GetOrCreateDemoPractitioner(_demoPractitioners[0]);
			int patientsCreated=0;
			foreach(DemoPatient demo in _demoPatients) {
				//Skip if a non-deleted patient with this NIK already exists.
				string checkCmd="SELECT PatNum FROM patient WHERE Nik='"+POut.String(demo.NIK)+"'"
					+" AND PatStatus!="+POut.Int((int)PatientStatus.Deleted)+" LIMIT 1";
				long existingPatNum=PIn.Long(Db.GetScalar(checkCmd));
				if(existingPatNum>0) {
					continue;
				}
				//------ Patient ------
				Patient pat=new Patient();
				pat.LName=demo.LName;
				pat.FName=demo.FName;
				pat.Gender=demo.Gender;
				pat.Birthdate=demo.Birthdate;
				pat.Nik=demo.NIK;
				pat.Address=demo.Address;
				pat.City=demo.City;
				pat.State="ID";
				pat.Country="Indonesia";
				pat.WirelessPhone=demo.Phone;
				pat.PatStatus=PatientStatus.Patient;
				pat.PriProv=demoProv1Num;
				long patNum=Crud.PatientCrud.Insert(pat);
				//Set Guarantor = PatNum (required by the app).
				Db.NonQ("UPDATE patient SET Guarantor="+POut.Long(patNum)+" WHERE PatNum="+POut.Long(patNum));
				//------ Appointment (completed, 30 days ago) ------
				Appointment apt=new Appointment();
				apt.PatNum=patNum;
				apt.AptStatus=ApptStatus.Complete;
				apt.AptDateTime=DateTime.Today.AddDays(-30).Date.AddHours(9);//09:00 local
				apt.Pattern="/XXX/";//15-minute slot
				apt.ProvNum=demoProv1Num;
				apt.Note="Demo appointment – SatuSehat integration test";
				apt.DateTStamp=DateTime.Now;
				long aptNum=Crud.AppointmentCrud.Insert(apt);
				//------ Procedure (completed, same date) ------
				Procedure proc=new Procedure();
				proc.PatNum=patNum;
				proc.AptNum=aptNum;
				proc.ProcDate=apt.AptDateTime;
				proc.ProcStatus=ProcStat.C;
				proc.CodeNum=codeNum;
				proc.DiagnosticCode="K02.9";//Dental caries, unspecified (ICD-10)
				proc.ProcFee=150000;//IDR 150,000
				proc.ProvNum=demoProv1Num;
				proc.DateEntryC=DateTime.Today;
				long procNum=Crud.ProcedureCrud.Insert(proc);
				//------ Enqueue in SatuSehat sync queue ------
				//Order matters: Patient(0) → Encounter(1) → Condition(2) → Procedure(3)
				SatuSehatStatuses.Enqueue(patNum,SatuSehatResourceType.Patient,   patNum);
				SatuSehatStatuses.Enqueue(patNum,SatuSehatResourceType.Encounter, aptNum);
				SatuSehatStatuses.Enqueue(patNum,SatuSehatResourceType.Condition, procNum);
				SatuSehatStatuses.Enqueue(patNum,SatuSehatResourceType.Procedure, procNum);
				patientsCreated++;
			}
			return patientsCreated;
		}

		///<summary>Removes all demo patients (identified by the demo NIK list) and their associated appointments,
		///procedures, and satusehatstatus rows. Also removes demo practitioner Provider records.</summary>
		public static int ClearDemoData() {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				return Meth.GetInt(MethodBase.GetCurrentMethod());
			}
			int removed=0;
			foreach(DemoPatient demo in _demoPatients) {
				//Find the patient row regardless of PatStatus (handles re-run after partial clear).
				string cmd="SELECT PatNum FROM patient WHERE Nik='"+POut.String(demo.NIK)+"' LIMIT 1";
				long patNum=PIn.Long(Db.GetScalar(cmd));
				if(patNum<=0) {
					continue;
				}
				//Delete dependent rows first.
				Db.NonQ("DELETE FROM satusehatstatus WHERE PatNum="+POut.Long(patNum));
				Db.NonQ("DELETE FROM procedurelog WHERE PatNum="+POut.Long(patNum));
				Db.NonQ("DELETE FROM appointment WHERE PatNum="+POut.Long(patNum));
				//Hard-delete the patient row so NIK is fully released for re-import.
				Db.NonQ("DELETE FROM patient WHERE PatNum="+POut.Long(patNum));
				removed++;
			}
			//Remove demo practitioners identified by NationalProvID = KnownIhsId.
			foreach(DemoPractitioner dp in _demoPractitioners) {
				Db.NonQ("DELETE FROM provider WHERE NationalProvID='"+POut.String(dp.KnownIhsId)+"'");
			}
			return removed;
		}

		///<summary>Returns an existing CodeNum from the procedurecode table.
		///If the table is empty, inserts a minimal demo code and returns its CodeNum.</summary>
		private static long GetOrCreateDemoProcedureCode() {
			long codeNum=PIn.Long(Db.GetScalar("SELECT CodeNum FROM procedurecode LIMIT 1"));
			if(codeNum>0) {
				return codeNum;
			}
			//No procedure codes exist yet – create a placeholder.
			ProcedureCode code=new ProcedureCode();
			code.ProcCode="D0120";
			code.Descript="Periodic oral evaluation";
			code.AbbrDesc="PerioEval";
			code.TreatArea=TreatmentArea.Mouth;
			code.ProcTime="/XX/";
			return Crud.ProcedureCodeCrud.Insert(code);
		}

		///<summary>Ensures a demo practitioner Provider record exists (identified by NationalProvID = KnownIhsId) and returns its ProvNum.
		///Uses provider.NationalProvID to store the practitioner IHS ID directly so SyncEncounter can skip the API NIK lookup.
		///This is safe for demo practitioners because we know their IHS IDs in advance from the Kemkes sandbox table.</summary>
		private static long GetOrCreateDemoPractitioner(DemoPractitioner dp) {
			long existing=PIn.Long(Db.GetScalar(
				"SELECT ProvNum FROM provider WHERE NationalProvID='"+POut.String(dp.KnownIhsId)+"' LIMIT 1"));
			if(existing>0) {
				return existing;
			}
			Provider prov=new Provider();
			prov.LName=dp.LName;
			prov.FName="";
			prov.Abbr=dp.Abbr;
			prov.NationalProvID=dp.KnownIhsId;//IHS ID stored here; SyncEncounter uses it directly (length < 16 chars)
			prov.Birthdate=dp.Birthdate;
			prov.IsHidden=false;
			FeeSched firstSched=FeeScheds.GetFirst(true);
			prov.FeeSched=(firstSched==null ? 0 : firstSched.FeeSchedNum);
			return Providers.Insert(prov);
		}

		///<summary>Simple value holder for demo patient seed data.</summary>
		private class DemoPatient {
			public readonly string LName;
			public readonly string FName;
			public readonly PatientGender Gender;
			public readonly DateTime Birthdate;
			public readonly string NIK;
			public readonly string Address;
			public readonly string City;
			public readonly string Phone;

			public DemoPatient(string lName,string fName,PatientGender gender,DateTime birthdate,string nik,string address,string city,string phone) {
				LName=lName;
				FName=fName;
				Gender=gender;
				Birthdate=birthdate;
				NIK=nik;
				Address=address;
				City=city;
				Phone=phone;
			}
		}

		///<summary>Sandbox practitioner from the official Kemkes SatuSehat test data.
		///NIK is stored in provider.NationalProvID for lookup via the Practitioner FHIR API.
		///KnownIhsId is the pre-known sandbox IHS ID returned by the staging API.</summary>
		private class DemoPractitioner {
			public readonly string LName;
			public readonly string Prefix;
			public readonly PatientGender Gender;
			public readonly DateTime Birthdate;
			public readonly string NIK;
			public readonly string KnownIhsId;
			public string Abbr {
				get {
					string raw=(Prefix+LName).Replace(" ","").Replace(".","");
					return raw.Substring(0,Math.Min(7,raw.Length));
				}
			}

			public DemoPractitioner(string lName,string prefix,PatientGender gender,DateTime birthdate,string nik,string knownIhsId) {
				LName=lName;
				Prefix=prefix;
				Gender=gender;
				Birthdate=birthdate;
				NIK=nik;
				KnownIhsId=knownIhsId;
			}
		}
	}
}
