using System;
using System.Collections.Generic;
using System.IO;
using CodeBase;

namespace HelianzBusiness {
	///<summary>Handles cross-clinic media resolution for the hybrid local+server media system.
	///When a user at one clinic needs to access a patient's images from another clinic,
	///this class ensures the media is pulled from the server to the local cache.</summary>
	public static class HybridMediaResolver {

		///<summary>The current clinic's ClinicNum, cached from startup. 0 means no clinic selected or practice mode.</summary>
		private static long _clinicNumCur=-1;

		///<summary>Returns the current clinic number. Only queries the database once per session.</summary>
		private static long GetClinicNumCur() {
			if(_clinicNumCur==-1) {
				_clinicNumCur=Clinics.ClinicNum;
			}
			return _clinicNumCur;
		}

		///<summary>Checks if a patient belongs to the current clinic.
		///Returns true if the patient's ClinicNum matches the current clinic, or if clinics are not in use (ClinicNum=0).</summary>
		public static bool IsLocalPatient(long patNum) {
			if(PrefC.AtoZfolderUsed!=DataStorageType.LocalAtoZHybrid) {
				return true;//Not hybrid mode, always local
			}
			long curClinicNum=GetClinicNumCur();
			if(curClinicNum==0) {
				return true;//Practice mode (no clinics), treat all as local
			}
			Patient pat=Patients.GetPat(patNum);
			if(pat==null) {
				return false;
			}
			return pat.ClinicNum==curClinicNum;
		}

		///<summary>Gets the clinic number for a patient. Returns 0 if patient not found or no clinic assigned.</summary>
		public static long GetPatientClinicNum(long patNum) {
			Patient pat=Patients.GetPat(patNum);
			if(pat==null) {
				return 0;
			}
			return pat.ClinicNum;
		}

		///<summary>Ensures that a patient's media is available locally.
		///For local patients: checks if the folder exists locally, no server pull needed.
		///For remote patients: triggers rclone pull from server to local cache.
		///Returns true if media should be available, false if pull failed or hybrid mode not active.</summary>
		public static bool EnsureMediaAvailable(long patNum) {
			if(PrefC.AtoZfolderUsed!=DataStorageType.LocalAtoZHybrid) {
				return true;//Not hybrid mode, no special handling needed
			}
			if(IsLocalPatient(patNum)) {
				return true;//Local patient, files should already be local from save operations
			}
			// Remote patient - pull from server
			try {
				string localBase=ImageStore.GetPreferredAtoZpath();
				int bucket=(int)(patNum % 100);
				string localFolder=ODFileUtils.CombinePaths(localBase,bucket.ToString(),patNum.ToString());
				// Only pull if folder doesn't exist locally or is empty
				if(!Directory.Exists(localFolder) || Directory.GetFiles(localFolder).Length==0) {
					RcloneSync.PullPatientFolder(patNum,localBase);
				}
				return Directory.Exists(localFolder) && Directory.GetFiles(localFolder).Length>0;
			}
			catch(Exception ex) {
				Logger.openlog.LogMB("EnsureMediaAvailable failed for patient "+patNum+": "+ex.Message,Logger.Severity.WARNING);
				return false;
			}
		}

		///<summary>Gets all documents for a patient from the database.
		///This already works cross-clinic since Documents.GetAllWithPat queries by PatNum regardless of clinic.
		///For hybrid mode, also triggers a sync if the patient is from another clinic.</summary>
		public static List<Document> GetPatientDocuments(long patNum) {
			List<Document> listDocs=new List<Document>(Documents.GetAllWithPat(patNum));
			if(PrefC.AtoZfolderUsed==DataStorageType.LocalAtoZHybrid && listDocs.Count>0) {
				EnsureMediaAvailable(patNum);
			}
			return listDocs;
		}

		///<summary>Resets the cached clinic number. Should be called when the user switches clinics.</summary>
		public static void ResetClinicCache() {
			_clinicNumCur=-1;
		}

		///<summary>Checks if the patient's media folder exists locally.
		///For hybrid mode, checks the numbered folder: {AtoZpath}/{PatNum%100}/{PatNum}/</summary>
		public static bool PatientMediaExistsLocally(long patNum) {
			if(PrefC.AtoZfolderUsed!=DataStorageType.LocalAtoZHybrid) {
				return true;
			}
			string localBase=ImageStore.GetPreferredAtoZpath();
			int bucket=(int)(patNum % 100);
			string localFolder=ODFileUtils.CombinePaths(localBase,bucket.ToString(),patNum.ToString());
			return Directory.Exists(localFolder);
		}
	}
}
