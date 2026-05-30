using CodeBase;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;

namespace HelianzBusiness.WebBridges.SatuSehat {
	///<summary>Orchestrates the SatuSehat sync queue.  Called by HelianzServer on a scheduled interval.</summary>
	public class SatuSehatSync {
		///<summary>Processes up to <paramref name="maxBatch"/> pending or failed rows from satusehatstatus.
		///Returns the number of rows successfully synced.</summary>
		public static int ProcessPendingQueue(int maxBatch=50) {
			SatuSehatConfig config=SatuSehatConfigs.GetOne();
			if(config==null || !config.IsEnabled) {
				return 0;
			}
			SatuSehatApi api=new SatuSehatApi(config);
			List<SatuSehatStatus> listPending=SatuSehatStatuses.GetPendingQueue(maxBatch);
			int successCount=0;
			foreach(SatuSehatStatus statusRow in listPending) {
				try {
					string ihsId=SyncResource(api,config,statusRow);
					SatuSehatStatuses.MarkSynced(statusRow.SatuSehatStatusNum,ihsId);
					successCount++;
				}
				catch(Exception ex) {
					SatuSehatStatuses.MarkFailed(statusRow.SatuSehatStatusNum,ex.Message);
				}
			}
			return successCount;
		}

		///<summary>Dispatches a single status row to the appropriate resource-specific sync handler.
		///Returns the IHS resource ID returned by SatuSehat.</summary>
		private static string SyncResource(SatuSehatApi api,SatuSehatConfig config,SatuSehatStatus statusRow) {
			switch(statusRow.ResourceType) {
				case SatuSehatResourceType.Patient:
					return SyncPatient(api,statusRow);
				case SatuSehatResourceType.Encounter:
					return SyncEncounter(api,config,statusRow);
				case SatuSehatResourceType.Condition:
					return SyncCondition(api,config,statusRow);
				case SatuSehatResourceType.Procedure:
					return SyncProcedure(api,config,statusRow);
				case SatuSehatResourceType.Observation:
					return SyncObservation(api,config,statusRow);
				default:
					throw new ODException("SatuSehatSync: unhandled resource type "+statusRow.ResourceType);
			}
		}

		///<summary>Looks up the patient's IHS ID using their NIK stored in the patient record.</summary>
		private static string SyncPatient(SatuSehatApi api,SatuSehatStatus statusRow) {
			Patient patient=Patients.GetPat(statusRow.PatNum);
			if(patient==null) {
				throw new ODException("Patient not found: PatNum="+statusRow.PatNum);
			}
			//TODO: Map the NIK field once confirmed in patient table (e.g. patient.Nik or a PatientNote field).
			string nik=GetPatientNik(patient);
			if(string.IsNullOrWhiteSpace(nik)) {
				throw new ODException("Patient PatNum="+statusRow.PatNum+" has no NIK; cannot look up IHS ID.");
			}
			string ihsId=api.SearchPatientByNik(nik);
			if(string.IsNullOrEmpty(ihsId)) {
				throw new ODException("SatuSehat returned no patient match for NIK "+nik);
			}
			return ihsId;
		}

		///<summary>Pushes an Encounter (appointment visit) to SatuSehat.
		///Requires the patient and practitioner IHS IDs to already be synced.</summary>
		private static string SyncEncounter(SatuSehatApi api,SatuSehatConfig config,SatuSehatStatus statusRow) {
			//Retrieve patient IHS ID from a previously-synced Patient row.
			SatuSehatStatus patientStatus=SatuSehatStatuses.GetForResource(statusRow.PatNum,SatuSehatResourceType.Patient,statusRow.PatNum);
			if(patientStatus==null || string.IsNullOrEmpty(patientStatus.IhsId)) {
				throw new ODException("Patient IHS ID not yet synced for PatNum="+statusRow.PatNum+". Sync Patient first.");
			}
			Appointment apt=Appointments.GetOneApt(statusRow.LocalResourceId);
			if(apt==null) {
				throw new ODException("Appointment not found: AptNum="+statusRow.LocalResourceId);
			}
			string fhirJson=BuildEncounterJson(apt,patientStatus.IhsId,config.OrganizationId);
			return api.SendResource("Encounter",fhirJson,statusRow.IhsId);
		}

		///<summary>Pushes a Condition (diagnosis) to SatuSehat.</summary>
		private static string SyncCondition(SatuSehatApi api,SatuSehatConfig config,SatuSehatStatus statusRow) {
			SatuSehatStatus patientStatus=SatuSehatStatuses.GetForResource(statusRow.PatNum,SatuSehatResourceType.Patient,statusRow.PatNum);
			if(patientStatus==null || string.IsNullOrEmpty(patientStatus.IhsId)) {
				throw new ODException("Patient IHS ID not yet synced for PatNum="+statusRow.PatNum);
			}
			//TODO: Load diagnosis from local table and map to FHIR Condition JSON.
			string fhirJson=BuildConditionJson(statusRow.LocalResourceId,patientStatus.IhsId,config.OrganizationId);
			return api.SendResource("Condition",fhirJson,statusRow.IhsId);
		}

		///<summary>Pushes a Procedure (completed dental procedure) to SatuSehat.</summary>
		private static string SyncProcedure(SatuSehatApi api,SatuSehatConfig config,SatuSehatStatus statusRow) {
			SatuSehatStatus patientStatus=SatuSehatStatuses.GetForResource(statusRow.PatNum,SatuSehatResourceType.Patient,statusRow.PatNum);
			if(patientStatus==null || string.IsNullOrEmpty(patientStatus.IhsId)) {
				throw new ODException("Patient IHS ID not yet synced for PatNum="+statusRow.PatNum);
			}
			ProcedureCode procCode=ProcedureCodes.GetProcCode(statusRow.LocalResourceId);
			string fhirJson=BuildProcedureJson(statusRow.LocalResourceId,patientStatus.IhsId,config.OrganizationId,procCode);
			return api.SendResource("Procedure",fhirJson,statusRow.IhsId);
		}

		///<summary>Pushes an Observation (vital sign) to SatuSehat.</summary>
		private static string SyncObservation(SatuSehatApi api,SatuSehatConfig config,SatuSehatStatus statusRow) {
			SatuSehatStatus patientStatus=SatuSehatStatuses.GetForResource(statusRow.PatNum,SatuSehatResourceType.Patient,statusRow.PatNum);
			if(patientStatus==null || string.IsNullOrEmpty(patientStatus.IhsId)) {
				throw new ODException("Patient IHS ID not yet synced for PatNum="+statusRow.PatNum);
			}
			string fhirJson=BuildObservationJson(statusRow.LocalResourceId,patientStatus.IhsId,config.OrganizationId);
			return api.SendResource("Observation",fhirJson,statusRow.IhsId);
		}

		///<summary>Returns the patient's NIK.
		///TODO: Replace with the actual field path once NIK storage is confirmed.</summary>
		private static string GetPatientNik(Patient patient) {
			//Placeholder: NIK field mapping to be confirmed (e.g. patient.SSN, a PatField, or a dedicated column).
			return patient.SSN;
		}

		#region FHIR JSON Builders
		//These methods build minimal valid FHIR R4 JSON for each resource type.
		//They will be expanded with full field mapping in subsequent phases.

		private static string BuildEncounterJson(Appointment apt,string patientIhsId,string orgId) {
			var obj=new JObject {
				["resourceType"]="Encounter",
				["status"]=MapAppointmentStatusToEncounterStatus(apt.AptStatus),
				["class"]=new JObject {
					["system"]="http://terminology.hl7.org/CodeSystem/v3-ActCode",
					["code"]="AMB",
					["display"]="ambulatory"
				},
				["subject"]=new JObject { ["reference"]="Patient/"+patientIhsId },
				["serviceProvider"]=new JObject { ["reference"]="Organization/"+orgId },
				["period"]=new JObject {
					["start"]=apt.AptDateTime.ToString("yyyy-MM-ddTHH:mm:sszzz"),
					["end"]=apt.AptDateTime.AddMinutes(apt.Pattern==null ? 30 : apt.Pattern.Length*5).ToString("yyyy-MM-ddTHH:mm:sszzz")
				}
			};
			return obj.ToString();
		}

		private static string BuildConditionJson(long diagnosisNum,string patientIhsId,string orgId) {
			//TODO: Load diagnosis and map ICD-10 code.
			var obj=new JObject {
				["resourceType"]="Condition",
				["clinicalStatus"]=new JObject {
					["coding"]=new JArray(new JObject {
						["system"]="http://terminology.hl7.org/CodeSystem/condition-clinical",
						["code"]="active"
					})
				},
				["subject"]=new JObject { ["reference"]="Patient/"+patientIhsId }
			};
			return obj.ToString();
		}

		private static string BuildProcedureJson(long procNum,string patientIhsId,string orgId,ProcedureCode procCode) {
			var obj=new JObject {
				["resourceType"]="Procedure",
				["status"]="completed",
				["subject"]=new JObject { ["reference"]="Patient/"+patientIhsId },
				["performer"]=new JArray(new JObject {
					["actor"]=new JObject { ["reference"]="Organization/"+orgId }
				})
			};
			if(procCode!=null) {
				obj["code"]=new JObject {
					["coding"]=new JArray(new JObject {
						["system"]="http://www.ama-assn.org/go/cpt",
						["code"]=procCode.ProcCode,
						["display"]=procCode.Descript
					}),
					["text"]=procCode.Descript
				};
			}
			return obj.ToString();
		}

		private static string BuildObservationJson(long localId,string patientIhsId,string orgId) {
			//TODO: Load vitalsign and map LOINC code.
			var obj=new JObject {
				["resourceType"]="Observation",
				["status"]="final",
				["subject"]=new JObject { ["reference"]="Patient/"+patientIhsId }
			};
			return obj.ToString();
		}

		private static string MapAppointmentStatusToEncounterStatus(ApptStatus aptStatus) {
			switch(aptStatus) {
				case ApptStatus.Complete:    return "finished";
				case ApptStatus.Broken:      return "cancelled";
				case ApptStatus.PtNote:      return "planned";
				default:                     return "in-progress";
			}
		}

		#endregion FHIR JSON Builders
	}
}
