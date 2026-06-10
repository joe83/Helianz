using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using CodeBase;

namespace HelianzBusiness {
	///<summary>Migrates patient images from the legacy A-to-Z folder structure to the new numbered folder scheme.
	///This is a one-time migration tool that can be run after switching to LocalAtoZHybrid mode.
	///For each patient with a non-empty ImageFolder that contains letters (legacy format):
	///  1. Calculates new path: {AtoZpath}/{PatNum%100}/{PatNum}/
	///  2. Moves all files from old location to new location
	///  3. Updates patient.ImageFolder to PatNum.ToString()
	///  4. Removes old empty patient folder
	///
	///Usage: Call MediaMigration.MigrateAll() from a setup/maintenance window or from the conversion scripts.</summary>
	public static class MediaMigration {

		///<summary>Callback for progress reporting during migration.</summary>
		public static Action<string,int,int> OnProgress;

		///<summary>Callback for logging migration results.</summary>
		public static Action<string> OnLog;

		///<summary>Migrates all patients from A-Z folders to numbered folders.
		///Returns the number of patients successfully migrated.</summary>
		public static int MigrateAll() {
			if(PrefC.AtoZfolderUsed!=DataStorageType.LocalAtoZHybrid) {
				throw new Exception("Migration can only run in LocalAtoZHybrid mode.");
			}
			string atozPath=ImageStore.GetPreferredAtoZpath();
			if(string.IsNullOrEmpty(atozPath)) {
				throw new Exception("AtoZ path is not configured.");
			}
			// Get all patients with non-empty ImageFolder that are in legacy format (contains letters)
			List<Patient> listPatients=Patients.GetAllPatients()
				.Where(p => !string.IsNullOrEmpty(p.ImageFolder) && !ImageStore.IsNumberedFolder(p.ImageFolder))
				.OrderBy(p => p.PatNum)
				.ToList();

			int migrated=0;
			int errors=0;
			int total=listPatients.Count;
			Log("Starting migration of "+total+" patients from A-Z to numbered folders...");
			Log("AtoZ path: "+atozPath);

			for(int i=0;i<listPatients.Count;i++) {
				Patient pat=listPatients[i];
				ReportProgress("Migrating patient "+pat.PatNum+" ("+(i+1)+"/"+total+")",i+1,total);
				try {
					MigratePatient(pat,atozPath);
					migrated++;
				}
				catch(Exception ex) {
					errors++;
					Log("ERROR migrating patient "+pat.PatNum+" ("+pat.ImageFolder+"): "+ex.Message);
				}
			}

			Log("Migration complete. Migrated: "+migrated+", Errors: "+errors+", Skipped (already numbered): "+(total - migrated - errors));
			return migrated;
		}

		///<summary>Migrates a single patient from A-Z to numbered folder.
		///Moves files, updates patient.ImageFolder, removes old folder.</summary>
		public static void MigratePatient(Patient pat,string atozPath) {
			if(ImageStore.IsNumberedFolder(pat.ImageFolder)) {
				return;//Already migrated
			}

			string oldFolderPath=ODFileUtils.CombinePaths(atozPath,
				pat.ImageFolder.Substring(0,1).ToUpper(),
				pat.ImageFolder);

			if(!Directory.Exists(oldFolderPath)) {
				// Old folder doesn't exist - just update ImageFolder
				Patient patOld=pat.Copy();
				pat.ImageFolder=pat.PatNum.ToString();
				Patients.Update(pat,patOld);
				return;
			}

			// Create new numbered folder path
			int bucket=(int)(pat.PatNum % 100);
			string newFolderPath=ODFileUtils.CombinePaths(atozPath,bucket.ToString(),pat.PatNum.ToString());

			if(!Directory.Exists(newFolderPath)) {
				Directory.CreateDirectory(newFolderPath);
			}

			// Move all files from old to new
			DirectoryInfo oldDir=new DirectoryInfo(oldFolderPath);
			FileInfo[] files=oldDir.GetFiles();
			foreach(FileInfo file in files) {
				if(file.Attributes.HasFlag(FileAttributes.Hidden)) {
					continue;
				}
				string destPath=Path.Combine(newFolderPath,file.Name);
				// Handle name collision by prepending "x"
				if(File.Exists(destPath) && !destPath.Equals(file.FullName,StringComparison.OrdinalIgnoreCase)) {
					destPath=Path.Combine(newFolderPath,"x"+file.Name);
				}
				if(!destPath.Equals(file.FullName,StringComparison.OrdinalIgnoreCase)) {
					file.MoveTo(destPath);
				}
			}

			// Move Thumbnails subfolder if it exists
			DirectoryInfo thumbDir=new DirectoryInfo(Path.Combine(oldFolderPath,"Thumbnails"));
			if(thumbDir.Exists) {
				string newThumbDir=Path.Combine(newFolderPath,"Thumbnails");
				if(!Directory.Exists(newThumbDir)) {
					Directory.CreateDirectory(newThumbDir);
				}
				foreach(FileInfo thumbFile in thumbDir.GetFiles()) {
					string destPath=Path.Combine(newThumbDir,thumbFile.Name);
					if(!destPath.Equals(thumbFile.FullName,StringComparison.OrdinalIgnoreCase)) {
						thumbFile.MoveTo(destPath);
					}
				}
				// Remove empty Thumbnails folder from old location
				try {
					thumbDir.Delete();
				}
				catch {
					// Non-critical
				}
			}

			// Update patient.ImageFolder in database
			Patient patOldDb=pat.Copy();
			pat.ImageFolder=pat.PatNum.ToString();
			Patients.Update(pat,patOldDb);

			// Remove old folder if empty
			try {
				if(oldDir.GetFiles().Length==0 && oldDir.GetDirectories().Length==0) {
					oldDir.Delete();
				}
			}
			catch {
				// Non-critical - folder may still have hidden files
			}
		}

		///<summary>Dry-run: counts how many patients would be migrated without actually moving files.</summary>
		public static int CountPatientsToMigrate() {
			return Patients.GetAllPatients()
				.Count(p => !string.IsNullOrEmpty(p.ImageFolder) && !ImageStore.IsNumberedFolder(p.ImageFolder));
		}

		///<summary>Checks if the numbered folder structure (0-99) has been created in the AtoZ path.</summary>
		public static bool NumberedFoldersExist(string atozPath) {
			if(string.IsNullOrEmpty(atozPath)) {
				return false;
			}
			return Directory.Exists(Path.Combine(atozPath,"0"));
		}

		private static void Log(string message) {
			Logger.openlog.LogMB(message,Logger.Severity.INFO);
			if(OnLog!=null) {
				OnLog(message);
			}
		}

		private static void ReportProgress(string message,int current,int total) {
			if(OnProgress!=null) {
				OnProgress(message,current,total);
			}
		}
	}
}
