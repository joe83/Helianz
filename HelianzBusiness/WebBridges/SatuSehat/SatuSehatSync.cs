using CodeBase;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;

namespace HelianzBusiness.WebBridges.SatuSehat {
	///<summary>Orchestrates the SatuSehat sync queue.  Called by HelianzServer on a scheduled interval.</summary>
	public class SatuSehatSync {
		///<summary>Tries to acquire the DB sync lock and, if successful, processes up to <paramref name="maxBatch"/> pending rows.
		///Returns false without doing any work if another client holds a fresh lock.
		///Safe to call concurrently from multiple clients — only one will win the lock.</summary>
		public static bool TryProcessPendingQueue(int maxBatch=50) {
			SatuSehatConfig config=SatuSehatConfigs.GetOne();
			if(config==null || !config.IsEnabled) {
				return false;
			}
			string hostName=System.Environment.MachineName;
			if(!SatuSehatConfigs.TryAcquireSyncLock(config.SatuSehatConfigNum,hostName)) {
				return false;//Another client holds the lock.
			}
			try {
				ProcessPendingQueue(maxBatch);
			}
			finally {
				SatuSehatConfigs.ReleaseSyncLock(config.SatuSehatConfigNum);
			}
			return true;
		}

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
			//Track patients whose IHS ID lookup failed this run so we don't cascade-fail
			//their dependent Encounter/Procedure/etc. rows in the same batch.
			HashSet<long> setFailedPatNums=new HashSet<long>();
			//Track "PatNum:AptNum" for encounters that failed so we skip their dependent Procedures in the same batch.
			HashSet<string> setFailedAptKeys=new HashSet<string>();
			foreach(SatuSehatStatus statusRow in listPending) {
				//If the patient lookup already failed this run, leave dependents as Pending
				//so they are retried once the patient is successfully resolved.
				if(statusRow.ResourceType!=SatuSehatResourceType.Patient
					&& setFailedPatNums.Contains(statusRow.PatNum))
				{
					continue;
				}
				//If the Encounter for this procedure's appointment already failed, skip and let Encounter retry first.
				if(statusRow.ResourceType==SatuSehatResourceType.Condition
					|| statusRow.ResourceType==SatuSehatResourceType.Procedure)
				{
					Procedure proc=Procedures.GetOneProc(statusRow.LocalResourceId,false);
					if(proc!=null && proc.AptNum>0) {
						string aptKey=statusRow.PatNum+":"+proc.AptNum;
						if(setFailedAptKeys.Contains(aptKey)) {
							continue;
						}
					}
				}
				try {
					string ihsId=SyncResource(api,config,statusRow);
					SatuSehatStatuses.MarkSynced(statusRow.SatuSehatStatusNum,ihsId);
					successCount++;
				}
				catch(Exception ex) {
					if(statusRow.ResourceType==SatuSehatResourceType.Patient) {
						setFailedPatNums.Add(statusRow.PatNum);
					}
					else if(statusRow.ResourceType==SatuSehatResourceType.Encounter) {
						setFailedAptKeys.Add(statusRow.PatNum+":"+statusRow.LocalResourceId);
					}
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
		///Requires the patient IHS ID, a practitioner with a valid NIK, and a configured Location.</summary>
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
			//Resolve practitioner IHS ID via NationalProvID.
			//Convention: NationalProvID length < 16 chars → already an IHS ID (demo practitioners).
			//            NationalProvID length == 16 chars → NIK → resolve via SatuSehat Practitioner API.
			//Use GetProvFromDb to bypass the cache — the provider may have been inserted in the same session.
			string practitionerIhsId="";
			string practitionerName="";
			if(apt.ProvNum>0) {
				Provider prov=Providers.GetProvFromDb(apt.ProvNum);
				if(prov!=null) {
					practitionerName=(prov.LName+" "+prov.FName).Trim();
					if(!string.IsNullOrWhiteSpace(prov.NationalProvID)) {
						string natId=prov.NationalProvID.Trim();
						if(natId.Length<16) {
							//Short value → treat as IHS ID directly (no API call needed).
							practitionerIhsId=natId;
						}
						else {
							//16-digit NIK → resolve via SatuSehat Practitioner search.
							practitionerIhsId=api.SearchPractitionerByNik(natId);
						}
					}
				}
			}
			if(string.IsNullOrEmpty(practitionerIhsId)) {
				throw new ODException("Practitioner IHS ID could not be resolved for ProvNum="+apt.ProvNum
					+". Ensure the provider has a valid NationalProvID (NIK or IHS ID) and is registered in SatuSehat.");
			}
			//Resolve Location IHS ID — use cached value, fetch from API, or auto-create.
			string locationId=config.LocationId;
			if(string.IsNullOrEmpty(locationId)) {
				locationId=api.GetOrganizationFirstLocationId(config.OrganizationId);
			}
			if(string.IsNullOrEmpty(locationId)) {
				//No existing location found — create a Poli Gigi Location resource on SatuSehat.
				locationId=api.CreateOrganizationLocation(config.OrganizationId);
				if(string.IsNullOrEmpty(locationId)) {
					throw new ODException("No Location ID could be found or created for organization "+config.OrganizationId
						+". Set LocationId manually in SatuSehat Setup.");
				}
			}
			if(locationId!=config.LocationId) {
				//Cache for subsequent syncs to avoid repeated API calls.
				SatuSehatConfigs.UpdateLocationId(config.SatuSehatConfigNum,locationId);
				config.LocationId=locationId;
			}
			//Look for a synced Condition linked to any procedure on this appointment.
			string conditionIhsId="";
			string diagnosisCode="";
			List<Procedure> listProcs=Procedures.GetProcsForSingle(apt.AptNum,false);
			foreach(Procedure proc in listProcs) {
				if(!string.IsNullOrEmpty(proc.DiagnosticCode)) {
					diagnosisCode=proc.DiagnosticCode.Trim();
					SatuSehatStatus condStatus=SatuSehatStatuses.GetForResource(statusRow.PatNum,SatuSehatResourceType.Condition,proc.ProcNum);
					if(condStatus!=null && !string.IsNullOrEmpty(condStatus.IhsId)) {
						conditionIhsId=condStatus.IhsId;
					}
					break;
				}
			}
			string fhirJson=BuildEncounterJson(apt,patientStatus.IhsId,config.OrganizationId,
				practitionerIhsId,practitionerName,locationId,conditionIhsId,diagnosisCode);
			return api.SendResource("Encounter",fhirJson,statusRow.IhsId);
		}

		///<summary>Pushes a Condition (diagnosis) to SatuSehat.
		///Must be called after the linked Encounter is synced (SatuSehat requires Condition.encounter).</summary>
		private static string SyncCondition(SatuSehatApi api,SatuSehatConfig config,SatuSehatStatus statusRow) {
			SatuSehatStatus patientStatus=SatuSehatStatuses.GetForResource(statusRow.PatNum,SatuSehatResourceType.Patient,statusRow.PatNum);
			if(patientStatus==null || string.IsNullOrEmpty(patientStatus.IhsId)) {
				throw new ODException("Patient IHS ID not yet synced for PatNum="+statusRow.PatNum);
			}
			//LocalResourceId for Condition is ProcNum — load proc to get AptNum.
			Procedure proc=Procedures.GetOneProc(statusRow.LocalResourceId,false);
			if(proc==null) {
				throw new ODException("Procedure not found: ProcNum="+statusRow.LocalResourceId);
			}
			//Encounter must already be synced (queue order ensures this).
			string encounterIhsId="";
			if(proc.AptNum>0) {
				SatuSehatStatus encStatus=SatuSehatStatuses.GetForResource(statusRow.PatNum,SatuSehatResourceType.Encounter,proc.AptNum);
				if(encStatus!=null) {
					encounterIhsId=encStatus.IhsId;
				}
			}
			if(string.IsNullOrEmpty(encounterIhsId)) {
				throw new ODException("Encounter IHS ID not yet synced for AptNum="+proc.AptNum+". Sync Encounter first.");
			}
			string fhirJson=BuildConditionJson(proc,patientStatus.IhsId,config.OrganizationId,encounterIhsId);
			return api.SendResource("Condition",fhirJson,statusRow.IhsId);
		}

		///<summary>Pushes a Procedure (completed dental procedure) to SatuSehat.</summary>
		private static string SyncProcedure(SatuSehatApi api,SatuSehatConfig config,SatuSehatStatus statusRow) {
			SatuSehatStatus patientStatus=SatuSehatStatuses.GetForResource(statusRow.PatNum,SatuSehatResourceType.Patient,statusRow.PatNum);
			if(patientStatus==null || string.IsNullOrEmpty(patientStatus.IhsId)) {
				throw new ODException("Patient IHS ID not yet synced for PatNum="+statusRow.PatNum);
			}
			Procedure proc=Procedures.GetOneProc(statusRow.LocalResourceId,false);
			if(proc==null) {
				throw new ODException("Procedure not found: ProcNum="+statusRow.LocalResourceId);
			}
			//Encounter IHS ID — look up via the procedure's linked appointment.
			string encounterIhsId="";
			if(proc.AptNum>0) {
				SatuSehatStatus encStatus=SatuSehatStatuses.GetForResource(statusRow.PatNum,SatuSehatResourceType.Encounter,proc.AptNum);
				if(encStatus!=null) {
					encounterIhsId=encStatus.IhsId;
				}
			}
			if(string.IsNullOrEmpty(encounterIhsId)) {
				throw new ODException("Encounter IHS ID not yet synced for AptNum="+proc.AptNum+". Sync Encounter first.");
			}
			ProcedureCode procCode=ProcedureCodes.GetProcCode(proc.CodeNum);
			string fhirJson=BuildProcedureJson(proc,patientStatus.IhsId,config.OrganizationId,encounterIhsId,procCode);
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

		///<summary>Returns the patient's NIK (Nomor Induk Kependudukan) from the dedicated Nik column.</summary>
		private static string GetPatientNik(Patient patient) {
			return patient.Nik;
		}

		#region FHIR JSON Builders
		//These methods build minimal valid FHIR R4 JSON for each resource type.
		//They will be expanded with full field mapping in subsequent phases.

		private static string BuildEncounterJson(Appointment apt,string patientIhsId,string orgId,
			string practitionerIhsId,string practitionerName,string locationId,
			string conditionIhsId,string diagnosisCode)
		{
			string status=MapAppointmentStatusToEncounterStatus(apt.AptStatus);
			int slotMinutes=apt.Pattern==null ? 30 : apt.Pattern.Length*5;
			string startStr=apt.AptDateTime.ToString("yyyy-MM-ddTHH:mm:sszzz");
			string endStr=apt.AptDateTime.AddMinutes(slotMinutes).ToString("yyyy-MM-ddTHH:mm:sszzz");
			string midStr=apt.AptDateTime.AddMinutes(Math.Max(slotMinutes-5,1)).ToString("yyyy-MM-ddTHH:mm:sszzz");
			//statusHistory: arrived → in-progress → finished
			var statusHistory=new JArray {
				new JObject {
					["status"]="arrived",
					["period"]=new JObject { ["start"]=startStr, ["end"]=startStr }
				},
				new JObject {
					["status"]="in-progress",
					["period"]=new JObject { ["start"]=startStr, ["end"]=midStr }
				},
				new JObject {
					["status"]=status,
					["period"]=new JObject { ["start"]=startStr, ["end"]=endStr }
				}
			};
			//participant: attending practitioner
			var participantIndividual=new JObject { ["reference"]="Practitioner/"+practitionerIhsId };
			if(!string.IsNullOrEmpty(practitionerName)) {
				participantIndividual["display"]=practitionerName;
			}
			var participant=new JArray(new JObject {
				["type"]=new JArray(new JObject {
					["coding"]=new JArray(new JObject {
						["system"]="http://terminology.hl7.org/CodeSystem/v3-ParticipationType",
						["code"]="ATND",
						["display"]="attender"
					})
				}),
				["individual"]=participantIndividual
			});
			//location
			var location=new JArray(new JObject {
				["location"]=new JObject {
					["reference"]="Location/"+locationId,
					["display"]="Poli Gigi"
				}
			});
			//diagnosis
			var diagCondition=new JObject();
			if(!string.IsNullOrEmpty(conditionIhsId)) {
				diagCondition["reference"]="Condition/"+conditionIhsId;
			}
			if(!string.IsNullOrEmpty(diagnosisCode)) {
				diagCondition["display"]=diagnosisCode;
			}
			var diagnosis=new JArray(new JObject {
				["condition"]=diagCondition,
				["use"]=new JObject {
					["coding"]=new JArray(new JObject {
						["system"]="http://terminology.hl7.org/CodeSystem/diagnosis-role",
						["code"]="DD",
						["display"]="Discharge diagnosis"
					})
				},
				["rank"]=1
			});
			var obj=new JObject {
				["resourceType"]="Encounter",
				["identifier"]=new JArray(new JObject {
					["system"]="http://sys-ids.kemkes.go.id/encounter/"+orgId,
					["value"]=apt.AptNum.ToString()
				}),
				["status"]=status,
				["statusHistory"]=statusHistory,
				["class"]=new JObject {
					["system"]="http://terminology.hl7.org/CodeSystem/v3-ActCode",
					["code"]="AMB",
					["display"]="ambulatory"
				},
				["subject"]=new JObject { ["reference"]="Patient/"+patientIhsId },
				["participant"]=participant,
				["period"]=new JObject { ["start"]=startStr, ["end"]=endStr },
				["location"]=location,
				["diagnosis"]=diagnosis,
				["serviceProvider"]=new JObject { ["reference"]="Organization/"+orgId }
			};
			return obj.ToString();
		}

		///<summary>Builds a FHIR Condition resource from a completed procedure's ICD-10 diagnostic code.
		///<paramref name="proc"/> is the procedure carrying the diagnosis. <paramref name="encounterIhsId"/> is the
		///already-synced Encounter IHS ID — SatuSehat requires Condition.encounter to reference a real Encounter.</summary>
		private static string BuildConditionJson(Procedure proc,string patientIhsId,string orgId,string encounterIhsId) {
			string icd10Code="";
			string icd10Display="";
			if(proc!=null && !string.IsNullOrEmpty(proc.DiagnosticCode)) {
				icd10Code=proc.DiagnosticCode.Trim();
				icd10Display=icd10Code;
			}
			var conditionCode=new JObject {
				["coding"]=new JArray(new JObject {
					["system"]="http://hl7.org/fhir/sid/icd-10",
					["code"]=icd10Code,
					["display"]=icd10Display
				}),
				["text"]=icd10Display
			};
			var obj=new JObject {
				["resourceType"]="Condition",
				["clinicalStatus"]=new JObject {
					["coding"]=new JArray(new JObject {
						["system"]="http://terminology.hl7.org/CodeSystem/condition-clinical",
						["code"]="active"
					})
				},
				["code"]=conditionCode,
				["subject"]=new JObject { ["reference"]="Patient/"+patientIhsId }
			};
			if(!string.IsNullOrEmpty(encounterIhsId)) {
				obj["encounter"]=new JObject { ["reference"]="Encounter/"+encounterIhsId };
			}
			return obj.ToString();
		}

		///<summary>Builds a FHIR Procedure resource for a completed dental procedure.
		///Uses SNOMED CT codes mapped from CDT code prefixes.</summary>
		private static string BuildProcedureJson(Procedure proc,string patientIhsId,string orgId,string encounterIhsId,ProcedureCode procCode) {
			var obj=new JObject {
				["resourceType"]="Procedure",
				["status"]="completed",
				["subject"]=new JObject { ["reference"]="Patient/"+patientIhsId }
			};
			if(!string.IsNullOrEmpty(encounterIhsId)) {
				obj["encounter"]=new JObject { ["reference"]="Encounter/"+encounterIhsId };
			}
			if(procCode!=null) {
				obj["code"]=new JObject {
					["coding"]=new JArray(new JObject {
						["system"]="http://snomed.info/sct",
						["code"]=MapCdtToSnomedCode(procCode.ProcCode),
						["display"]=procCode.Descript
					}),
					["text"]=procCode.ProcCode+" – "+procCode.Descript
				};
			}
			if(proc!=null && proc.ProcDate!=DateTime.MinValue) {
				obj["performedDateTime"]=proc.ProcDate.ToString("yyyy-MM-ddTHH:mm:sszzz");
			}
			obj["performer"]=new JArray(new JObject {
				["actor"]=new JObject { ["reference"]="Organization/"+orgId }
			});
			return obj.ToString();
		}

		///<summary>Maps CDT code prefix to a SNOMED CT procedure code.
		///Returns a generic dental procedure code when no specific mapping is available.</summary>
		private static string MapCdtToSnomedCode(string cdtCode) {
			if(string.IsNullOrEmpty(cdtCode)) {
				return "225358003"; //dental examination
			}
			string code=cdtCode.ToUpper().Trim();
			if(code.StartsWith("D0")) return "225358003"; //diagnostic → dental examination
			if(code.StartsWith("D1")) return "410021001"; //preventive → dental prophylaxis
			if(code.StartsWith("D2")) return "234723009"; //restorative → restoration of tooth
			if(code.StartsWith("D3")) return "58834002";  //endodontic → root canal treatment
			if(code.StartsWith("D4")) return "52161003";  //periodontic → periodontal procedure
			if(code.StartsWith("D7")) return "53174009";  //oral surgery → tooth extraction
			return "225358003";
		}

		///<summary>Builds a FHIR Observation resource for a vital sign record.
		///<paramref name="localId"/> is VitalsignNum from the vitalsign table.
		///Each non-zero measurement is emitted as a separate component entry using standard LOINC codes.</summary>
		private static string BuildObservationJson(long localId,string patientIhsId,string orgId) {
			Vitalsign vs=localId>0 ? Vitalsigns.GetOne(localId) : null;
			var components=new JArray();
			if(vs!=null) {
				//Height: LOINC 8302-2
				if(vs.Height>0) {
					components.Add(BuildVsComponent("8302-2","Body height",vs.Height,"[in_i]","in"));
				}
				//Weight: LOINC 29463-7
				if(vs.Weight>0) {
					components.Add(BuildVsComponent("29463-7","Body weight",vs.Weight,"[lb_av]","lbs"));
				}
				//Systolic BP: LOINC 8480-6
				if(vs.BpSystolic>0) {
					components.Add(BuildVsComponent("8480-6","Systolic blood pressure",vs.BpSystolic,"mm[Hg]","mmHg"));
				}
				//Diastolic BP: LOINC 8462-4
				if(vs.BpDiastolic>0) {
					components.Add(BuildVsComponent("8462-4","Diastolic blood pressure",vs.BpDiastolic,"mm[Hg]","mmHg"));
				}
				//Pulse: LOINC 8867-4
				if(vs.Pulse>0) {
					components.Add(BuildVsComponent("8867-4","Heart rate",vs.Pulse,"/min","/min"));
				}
			}
			var obj=new JObject {
				["resourceType"]="Observation",
				["status"]="final",
				//Vital signs panel: LOINC 85353-1
				["category"]=new JArray(new JObject {
					["coding"]=new JArray(new JObject {
						["system"]="http://terminology.hl7.org/CodeSystem/observation-category",
						["code"]="vital-signs",
						["display"]="Vital Signs"
					})
				}),
				["code"]=new JObject {
					["coding"]=new JArray(new JObject {
						["system"]="http://loinc.org",
						["code"]="85353-1",
						["display"]="Vital signs, weight, height, head circumference, oxygen saturation and BMI panel"
					})
				},
				["subject"]=new JObject { ["reference"]="Patient/"+patientIhsId },
				["performer"]=new JArray(new JObject { ["reference"]="Organization/"+orgId })
			};
			if(vs!=null) {
				obj["effectiveDateTime"]=vs.DateTaken.ToString("yyyy-MM-ddTHH:mm:sszzz");
			}
			if(components.Count>0) {
				obj["component"]=components;
			}
			return obj.ToString();
		}

		///<summary>Builds a single FHIR Observation component object for a vital sign measurement.</summary>
		private static JObject BuildVsComponent(string loincCode,string display,double value,string ucumUnit,string unitDisplay) {
			return new JObject {
				["code"]=new JObject {
					["coding"]=new JArray(new JObject {
						["system"]="http://loinc.org",
						["code"]=loincCode,
						["display"]=display
					})
				},
				["valueQuantity"]=new JObject {
					["value"]=value,
					["unit"]=unitDisplay,
					["system"]="http://unitsofmeasure.org",
					["code"]=ucumUnit
				}
			};
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
