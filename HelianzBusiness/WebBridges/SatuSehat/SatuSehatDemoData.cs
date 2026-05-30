using System;
using System.Collections.Generic;
using System.Reflection;
using DataConnectionBase;

namespace HelianzBusiness.WebBridges.SatuSehat {
	///<summary>Generates fake Indonesian patient records for SatuSehat integration testing.
	///Each call inserts patients, appointments, and procedures, then enqueues them as Pending in satusehatstatus.</summary>
	public class SatuSehatDemoData {

		///<summary>Demo patient seed data using real Indonesian NIK numbers provided for trial/testing.
		///NIK encodes province, regency, district, birthdate (DD+40 for female), and sequence.
		///Phone numbers are fictional placeholders.</summary>
		private static readonly DemoPatient[] _demoPatients=new DemoPatient[] {
			//NIK 3471130111830001 → Province 34 (DIY), Kota Yogyakarta, born 01-Nov-1983, Male
			new DemoPatient("Maryono",  "Joko",  PatientGender.Male,   new DateTime(1983,11,1),  "3471130111830001","Jl. Malioboro No. 5",     "Yogyakarta","62812300001"),
			//NIK 6401040403010005 → Province 64 (Kaltim), Kutai Kartanegara, born 04-Mar-2001, Male
			new DemoPatient("Ariyanto", "Putra", PatientGender.Male,   new DateTime(2001,3,4),   "6401040403010005","Jl. Kartanegara No. 20",  "Tenggarong","62821300005"),
			//NIK 3315196408790001 → Province 33 (Jateng), Grobogan, born 24-Aug-1979, Female (64-40=24)
			new DemoPatient("",         "Anik",  PatientGender.Female, new DateTime(1979,8,24),  "3315196408790001","Jl. Diponegoro No. 3",    "Purwodadi", "62856300001"),
		};

		///<summary>Inserts demo patients, appointments, and procedures into the database and enqueues each resource in satusehatstatus.
		///Skips patients whose NIK already exists in the patient table.
		///Returns the number of new patients created.</summary>
		public static int CreateDemoData() {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				return Meth.GetInt(MethodBase.GetCurrentMethod());
			}
			long codeNum=GetOrCreateDemoProcedureCode();
			int patientsCreated=0;
			foreach(DemoPatient demo in _demoPatients) {
				//Skip if a patient with this NIK already exists.
				string checkCmd="SELECT PatNum FROM patient WHERE SSN='"+POut.String(demo.NIK)+"' LIMIT 1";
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
				pat.SSN=demo.NIK;
				pat.Address=demo.Address;
				pat.City=demo.City;
				pat.State="ID";
				pat.Country="Indonesia";
				pat.WirelessPhone=demo.Phone;
				pat.PatStatus=PatientStatus.Patient;
				pat.PriProv=0;
				long patNum=Crud.PatientCrud.Insert(pat);
				//Set Guarantor = PatNum (required by the app).
				Db.NonQ("UPDATE patient SET Guarantor="+POut.Long(patNum)+" WHERE PatNum="+POut.Long(patNum));
				//------ Appointment (completed, 30 days ago) ------
				Appointment apt=new Appointment();
				apt.PatNum=patNum;
				apt.AptStatus=ApptStatus.Complete;
				apt.AptDateTime=DateTime.Today.AddDays(-30).Date.AddHours(9);//09:00 local
				apt.Pattern="/XXX/";//15-minute slot
				apt.ProvNum=0;
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
				proc.ProvNum=0;
				proc.DateEntryC=DateTime.Today;
				long procNum=Crud.ProcedureCrud.Insert(proc);
				//------ Enqueue in SatuSehat sync queue ------
				SatuSehatStatuses.Enqueue(patNum,SatuSehatResourceType.Patient,   patNum);
				SatuSehatStatuses.Enqueue(patNum,SatuSehatResourceType.Encounter, aptNum);
				SatuSehatStatuses.Enqueue(patNum,SatuSehatResourceType.Procedure, procNum);
				patientsCreated++;
			}
			return patientsCreated;
		}

		///<summary>Removes all demo patients (identified by the demo NIK list) and their associated appointments,
		///procedures, and satusehatstatus rows.</summary>
		public static int ClearDemoData() {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				return Meth.GetInt(MethodBase.GetCurrentMethod());
			}
			int removed=0;
			foreach(DemoPatient demo in _demoPatients) {
				string cmd="SELECT PatNum FROM patient WHERE SSN='"+POut.String(demo.NIK)+"' LIMIT 1";
				long patNum=PIn.Long(Db.GetScalar(cmd));
				if(patNum<=0) {
					continue;
				}
				//Delete satusehatstatus rows first.
				Db.NonQ("DELETE FROM satusehatstatus WHERE PatNum="+POut.Long(patNum));
				//Delete procedurelog rows.
				Db.NonQ("DELETE FROM procedurelog WHERE PatNum="+POut.Long(patNum));
				//Delete appointment rows.
				Db.NonQ("DELETE FROM appointment WHERE PatNum="+POut.Long(patNum));
				//Delete the patient row.
				Db.NonQ("UPDATE patient SET PatStatus="+POut.Int((int)PatientStatus.Deleted)+" WHERE PatNum="+POut.Long(patNum));
				removed++;
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
	}
}
