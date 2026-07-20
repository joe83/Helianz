using System;
using System.Diagnostics;
using System.IO;
using CodeBase;

namespace HelianzBusiness {
	///<summary>Wraps rclone CLI operations for hybrid media sync to/from a central server.
	///Supports SFTP and S3 backends. Uses bundled rclone binary (in app's rclone/ subfolder)
	///with a custom config file managed by the application. The config file is written ONLY
	///when the user saves hybrid settings in FormPath — sync operations use the existing config as-is.</summary>
	public static class RcloneSync {

		///<summary>Set to true once availability has been checked this session.</summary>
		private static bool _checkedAvailability=false;
		///<summary>Cached result of rclone availability check.</summary>
		private static bool _isAvailable=false;

		#region Config Path and Binary Resolution

		///<summary>Gets the path to the rclone binary.
		///Checks the bundled location first (app install folder), then user preference, then PATH.</summary>
		public static string GetRclonePath() {
			// 1. Check bundled rclone in app install folder
			string bundled=Path.Combine(AppDomain.CurrentDomain.BaseDirectory,"rclone",
				Environment.OSVersion.Platform==PlatformID.Unix ? "rclone" : "rclone.exe");
			if(File.Exists(bundled)) {
				return bundled;
			}
			// 2. Check user-configured preference
			string prefPath=PrefC.GetStringSilent(PrefName.RclonePath);
			if(!string.IsNullOrEmpty(prefPath) && File.Exists(prefPath)) {
				return prefPath;
			}
			// 3. Fall back to system PATH
			return "rclone";
		}

		///<summary>Returns the path to the application-managed rclone config file.
		///Config is stored in %AppData%/Helianz/rclone.conf to avoid conflicts with user's own rclone config.</summary>
		public static string GetConfigFilePath() {
			string dir=Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData),"Helianz");
			if(!Directory.Exists(dir)) {
				Directory.CreateDirectory(dir);
			}
			return Path.Combine(dir,"rclone.conf");
		}

		///<summary>Checks if the managed rclone config file exists and has content.</summary>
		public static bool ConfigFileExists() {
			string configPath=GetConfigFilePath();
			return File.Exists(configPath) && new FileInfo(configPath).Length > 0;
		}

		///<summary>Checks if rclone binary is available on the system. Result is cached for the session.</summary>
		public static bool IsRcloneAvailable() {
			if(_checkedAvailability) {
				return _isAvailable;
			}
			_checkedAvailability=true;
			try {
				ProcessStartInfo psi=new ProcessStartInfo();
				psi.FileName=GetRclonePath();
				psi.Arguments="version";
				psi.UseShellExecute=false;
				psi.CreateNoWindow=true;
				psi.RedirectStandardOutput=true;
				psi.RedirectStandardError=true;
				using(Process process=Process.Start(psi)) {
					process.WaitForExit(3000);//3 second timeout
					_isAvailable=(process.ExitCode==0);
				}
			}
			catch {
				_isAvailable=false;
			}
			return _isAvailable;
		}

		///<summary>Resets the availability cache so IsRcloneAvailable() will re-check.
		///Call after user changes rclone path in settings.</summary>
		public static void InvalidateAvailabilityCache() {
			_checkedAvailability=false;
			_isAvailable=false;
		}

		///<summary>Checks if a bundled rclone binary exists in the app's rclone/ subfolder.</summary>
		public static bool IsBundledRcloneAvailable() {
			string bundled=Path.Combine(AppDomain.CurrentDomain.BaseDirectory,"rclone",
				Environment.OSVersion.Platform==PlatformID.Unix ? "rclone" : "rclone.exe");
			return File.Exists(bundled);
		}

		#endregion

		#region Config File Management

		///<summary>Writes an SFTP rclone config file with the given parameters.
		///This should ONLY be called from FormPath when the user saves hybrid settings.
		///Password is NOT written to the config file — it is passed via environment variable at runtime.
		///Uses UTF8 without BOM for maximum compatibility.</summary>
		public static void WriteConfigFile(string host,string user,string keyFilePath) {
			string configPath=GetConfigFilePath();
			string remoteName=GetRemoteName();
			using(StreamWriter writer=new StreamWriter(configPath,false,new System.Text.UTF8Encoding(false))) {
				writer.WriteLine("["+remoteName+"]");
				writer.WriteLine("type = sftp");
				if(!string.IsNullOrEmpty(host)) {
					writer.WriteLine("host = "+host);
				}
				if(!string.IsNullOrEmpty(user)) {
					writer.WriteLine("user = "+user);
				}
				if(!string.IsNullOrEmpty(keyFilePath) && File.Exists(keyFilePath)) {
					writer.WriteLine("key_file = "+keyFilePath);
				}
				writer.WriteLine("pass = ");
			}
		}

		///<summary>Writes an S3 rclone config file with the given parameters.
		///Credentials are written to the config file for a self-contained setup.
		///The config file is in the user's private AppData folder and access/secret keys
		///are encrypted at rest in the database.
		///Uses UTF8 without BOM for maximum compatibility.</summary>
		public static void WriteS3ConfigFile(string endpoint,string region,string bucket,string provider="",string accessKey="",string secretKey="") {
			string configPath=GetConfigFilePath();
			string remoteName=GetRemoteName();
			using(StreamWriter writer=new StreamWriter(configPath,false,new System.Text.UTF8Encoding(false))) {
				writer.WriteLine("["+remoteName+"]");
				writer.WriteLine("type = s3");
				if(!string.IsNullOrEmpty(provider)) {
					writer.WriteLine("provider = "+provider);
				}
				if(!string.IsNullOrEmpty(endpoint)) {
					writer.WriteLine("endpoint = "+endpoint);
				}
				if(!string.IsNullOrEmpty(region)) {
					writer.WriteLine("region = "+region);
				}
				writer.WriteLine("env_auth = false");
				// Write credentials directly to the config for a self-contained setup.
				if(!string.IsNullOrEmpty(accessKey)) {
					writer.WriteLine("access_key_id = "+accessKey);
				}
				if(!string.IsNullOrEmpty(secretKey)) {
					writer.WriteLine("secret_access_key = "+secretKey);
				}
			}
		}

		///<summary>Deletes the managed rclone config file if it exists.</summary>
		public static void DeleteConfigFile() {
			string configPath=GetConfigFilePath();
			if(File.Exists(configPath)) {
				try {
					File.Delete(configPath);
				}
				catch {
					// Non-critical
				}
			}
		}

		#endregion

		#region Remote Name, Server Path, and Backend Type

		///<summary>Gets the configured rclone remote name, defaulting to "helianz-media".</summary>
		private static string GetRemoteName() {
			string name=PrefC.GetStringSilent(PrefName.RcloneRemoteName);
			if(string.IsNullOrEmpty(name)) {
				name="helianz-media";
			}
			return name;
		}

		///<summary>Gets the configured hybrid backend type, defaulting to SFTP for backward compatibility.</summary>
		public static HybridBackendType GetBackendType() {
			string typeStr=PrefC.GetStringSilent(PrefName.RcloneBackendType);
			if(string.IsNullOrEmpty(typeStr)) {
				return HybridBackendType.SFTP;
			}
			if(typeStr.Equals("S3",StringComparison.OrdinalIgnoreCase)) {
				return HybridBackendType.S3;
			}
			return HybridBackendType.SFTP;
		}

		///<summary>Gets the server-side base path for media storage, defaulting to "/media".
		///For S3 backend, the bucket name is prepended since rclone needs it in the path
		///(bucket in config is not used for path routing by all providers).</summary>
		private static string GetServerBasePath() {
			string path=PrefC.GetStringSilent(PrefName.RcloneServerPath);
			if(string.IsNullOrEmpty(path)) {
				path="/media";
			}
			if(GetBackendType()==HybridBackendType.S3) {
				// S3: bucket must be in the path, not just the config.
				// Format: {bucket}/{serverPath}
				path=path.Trim('/');
				string bucket=GetS3Bucket();
				if(!string.IsNullOrEmpty(bucket)) {
					path=bucket+"/"+path;
				}
			}
			else {
				path=path.TrimEnd('/');
			}
			return path;
		}

		///<summary>Gets the S3 bucket name from ProgramProperties.
		///Returns empty string if not configured.</summary>
		private static string GetS3Bucket() {
			try {
				long progNum=Programs.GetProgramNum(ProgramName.SFTP);
				string bucket=ProgramProperties.GetPropVal(progNum,"Hybrid S3 Bucket");
				if(!string.IsNullOrEmpty(bucket)) {
					return bucket.Trim();
				}
			}
			catch { }
			return "";
		}

		///<summary>Returns the remote path for a patient folder on the server.
		///Format: {remoteName}:{serverBase}/{PatNum%100}/{PatNum}/</summary>
		private static string GetRemotePatientPath(long patNum) {
			int bucket=(int)(patNum % 100);
			return GetRemoteName()+":"+GetServerBasePath()+"/"+bucket.ToString()+"/"+patNum.ToString()+"/";
		}

		///<summary>Returns the local patient folder path.
		///Format: {localBase}/{PatNum%100}/{PatNum}/</summary>
		public static string GetLocalPatientPath(long patNum,string localBasePath) {
			int bucket=(int)(patNum % 100);
			return ODFileUtils.CombinePaths(localBasePath,bucket.ToString(),patNum.ToString())+Path.DirectorySeparatorChar;
		}

		///<summary>Returns the full local path for a specific file in a patient's folder.
		///Format: {localBase}/{PatNum%100}/{PatNum}/{fileName}</summary>
		public static string GetLocalFilePath(long patNum,string localBasePath,string fileName) {
			return ODFileUtils.CombinePaths(GetLocalPatientPath(patNum,localBasePath),fileName);
		}

		#endregion

		#region Sync Operations

		///<summary>Pushes (uploads) a patient folder from local to server using rclone copy.
		///This is a one-way sync: files that exist locally but not on server will be uploaded.</summary>
		public static void PushPatientFolder(long patNum,string localBasePath) {
			if(!IsRcloneAvailable()) {
				Logger.openlog.LogMB("rclone not available, skipping push for patient "+patNum,Logger.Severity.WARNING);
				return;
			}
			if(!ConfigFileExists()) {
				Logger.openlog.LogMB("rclone config not found, skipping push for patient "+patNum,Logger.Severity.WARNING);
				return;
			}
			try {
				string localPath=GetLocalPatientPath(patNum,localBasePath);
				string remotePath=GetRemotePatientPath(patNum);
				RunRclone("copy",localPath,remotePath);
			}
			catch(Exception ex) {
				Logger.openlog.LogMB("rclone push failed for patient "+patNum+": "+ex.Message,Logger.Severity.WARNING);
			}
		}

		///<summary>Pushes a single file from local to server using rclone copyto.
		///More efficient than pushing the whole folder when only one file changed.</summary>
		public static void PushFile(long patNum,string localBasePath,string fileName) {
			if(!IsRcloneAvailable()) {
				return;
			}
			if(!ConfigFileExists()) {
				return;
			}
			try {
				string localPath=GetLocalPatientPath(patNum,localBasePath);
				string remotePath=GetRemotePatientPath(patNum);
				RunRclone("copyto",ODFileUtils.CombinePaths(localPath,fileName),remotePath+fileName);
			}
			catch(Exception ex) {
				Logger.openlog.LogMB("rclone push file failed for patient "+patNum+": "+ex.Message,Logger.Severity.WARNING);
			}
		}

		///<summary>Syncs a patient folder between local and server using rclone copy.
		///If the remote folder does not exist on the server (e.g. after migration), pushes local files up.
		///If the remote folder exists, pulls server files down.</summary>
		public static void PullPatientFolder(long patNum,string localBasePath) {
			if(!IsRcloneAvailable()) {
				return;
			}
			if(!ConfigFileExists()) {
				return;
			}
			try {
				string localPath=GetLocalPatientPath(patNum,localBasePath);
				string remotePath=GetRemotePatientPath(patNum);
				if(FolderExistsOnServer(patNum)) {
					// Server has data: pull down
					RunRclone("copy",remotePath,localPath);
				}
				else {
					// Server doesn't have this folder yet (e.g. after migration): push local up
					RunRclone("copy",localPath,remotePath);
				}
			}
			catch(Exception ex) {
				Logger.openlog.LogMB("rclone sync failed for patient "+patNum+": "+ex.Message,Logger.Severity.WARNING);
			}
		}

		///<summary>Pulls a patient folder asynchronously on a background thread.</summary>
		public static System.Threading.Tasks.Task PullPatientFolderAsync(long patNum,string localBasePath) {
			return System.Threading.Tasks.Task.Run(() => {
				PullPatientFolder(patNum,localBasePath);
			});
		}

		///<summary>Pulls a single file from server to local using rclone copyto.
		///If the file doesn't exist on server, returns false. Otherwise returns true.
		///Used as synchronous fallback when a file is needed but hasn't been synced yet.</summary>
		public static bool PullFile(long patNum,string localBasePath,string fileName) {
			if(!IsRcloneAvailable()) {
				return false;
			}
			if(!ConfigFileExists()) {
				return false;
			}
			try {
				string localPath=GetLocalPatientPath(patNum,localBasePath);
				string remotePath=GetRemotePatientPath(patNum);
				// Ensure the local directory exists
				string localDir=GetLocalPatientPath(patNum,localBasePath).TrimEnd(Path.DirectorySeparatorChar);
				if(!Directory.Exists(localDir)) {
					Directory.CreateDirectory(localDir);
				}
				string localFile=ODFileUtils.CombinePaths(localPath,fileName);
				string remoteFile=remotePath+fileName;
				// Use copyto for single-file pull
				RunRclone("copyto",remoteFile,localFile);
				return File.Exists(localFile);
			}
			catch(Exception ex) {
				Logger.openlog.LogMB("rclone pull file failed for patient "+patNum+" file "+fileName+": "+ex.Message,Logger.Severity.WARNING);
				return false;
			}
		}

		///<summary>Checks whether a specific file exists in the local patient folder.</summary>
		public static bool FileExistsLocally(string localBasePath,long patNum,string fileName) {
			string localPath=ODFileUtils.CombinePaths(GetLocalPatientPath(patNum,localBasePath),fileName);
			return File.Exists(localPath);
		}

		///<summary>Checks whether a patient folder exists on the server by listing its contents.
		///Returns true if the remote folder exists and has at least one file.</summary>
		public static bool FolderExistsOnServer(long patNum) {
			if(!IsRcloneAvailable()) {
				return false;
			}
			if(!ConfigFileExists()) {
				return false;
			}
			try {
				string remotePath=GetRemotePatientPath(patNum);
				string configPath=GetConfigFilePath();
				string remoteName=GetRemoteName();
				ProcessStartInfo psi=new ProcessStartInfo();
				psi.FileName=GetRclonePath();
				psi.Arguments="lsf \""+remotePath+"\" --config \""+configPath+"\" --max-depth 1";
				psi.UseShellExecute=false;
				psi.CreateNoWindow=true;
				psi.RedirectStandardOutput=true;
				psi.RedirectStandardError=true;
				psi.Environment["RCLONE_CONFIG"]=configPath;
				// S3 credentials are in the config file; SFTP password passed via env var.
				string envPrefix="RCLONE_CONFIG_"+remoteName.ToUpper().Replace("-","_")+"_";
				if(GetBackendType()!=HybridBackendType.S3) {
					string password=GetSftpPass();
					if(!string.IsNullOrEmpty(password)) {
						psi.Environment[envPrefix+"PASS"]=password;
					}
				}
				using(Process process=Process.Start(psi)) {
					string output=process.StandardOutput.ReadToEnd();
					process.WaitForExit(30000);//30 second timeout
					return process.ExitCode==0 && !string.IsNullOrEmpty(output.Trim());
				}
			}
			catch {
				return false;
			}
		}

		#endregion

		#region Credential Access

		///<summary>Gets the SFTP password from ProgramProperties for passing via environment variable.
		///Returns empty string if not configured or decryption fails.</summary>
		private static string GetSftpPass() {
			try {
				long progNum=Programs.GetProgramNum(ProgramName.SFTP);
				string passEncrypted=ProgramProperties.GetPropVal(progNum,"Hybrid SFTP Pass")??"";
				if(string.IsNullOrEmpty(passEncrypted)) {
					return "";
				}
				string passDecrypted="";
				if(CDT.Class1.DecryptSftp(passEncrypted,out passDecrypted)) {
					return passDecrypted;
				}
			}
			catch {
				// Property not found or decryption failed
			}
			return "";
		}

		///<summary>Gets the S3 access key from ProgramProperties for passing via environment variable.
		///Returns empty string if not configured or decryption fails.</summary>
		private static string GetS3AccessKey() {
			try {
				long progNum=Programs.GetProgramNum(ProgramName.SFTP);
				string keyEncrypted=ProgramProperties.GetPropVal(progNum,"Hybrid S3 Access Key")??"";
				if(string.IsNullOrEmpty(keyEncrypted)) {
					return "";
				}
				string keyDecrypted="";
				if(CDT.Class1.DecryptSftp(keyEncrypted,out keyDecrypted)) {
					return keyDecrypted;
				}
			}
			catch {
				// Property not found or decryption failed
			}
			return "";
		}

		///<summary>Gets the S3 secret key from ProgramProperties for passing via environment variable.
		///Returns empty string if not configured or decryption fails.</summary>
		private static string GetS3SecretKey() {
			try {
				long progNum=Programs.GetProgramNum(ProgramName.SFTP);
				string keyEncrypted=ProgramProperties.GetPropVal(progNum,"Hybrid S3 Secret Key")??"";
				if(string.IsNullOrEmpty(keyEncrypted)) {
					return "";
				}
				string keyDecrypted="";
				if(CDT.Class1.DecryptSftp(keyEncrypted,out keyDecrypted)) {
					return keyDecrypted;
				}
			}
			catch {
				// Property not found or decryption failed
			}
			return "";
		}

		#endregion

		#region Process Execution

		///<summary>On Windows, converts a local path (C:\... or \\server\...) to use forward slashes
		///so rclone/Go doesn't internally add the \\?\ extended-path prefix that fails on Windows 7.
		///Remote paths (containing ":/") already use forward slashes and are returned unchanged.</summary>
		private static string NormalizeLocalPathForRclone(string path) {
			if(string.IsNullOrEmpty(path)) { return path; }
			// Remote paths have ":/" (e.g. helianz-media:/media/...) — already forward-slashed, leave alone.
			if(path.Contains(":/")) { return path; }
			// This is a local Windows path. Convert backslashes to forward slashes.
			return path.Replace('\\','/');
		}

		///<summary>Runs an rclone command with the custom config file and credentials via environment variables.
		///Throws on non-zero exit code.</summary>
		private static void RunRclone(string operation,string sourcePath,string destPath) {
			ProcessStartInfo psi=new ProcessStartInfo();
			psi.FileName=GetRclonePath();
			string configPath=GetConfigFilePath();
			string remoteName=GetRemoteName();
			// Trim trailing slashes to prevent backslash from escaping the closing quote
			string src=sourcePath.TrimEnd('\\','/');
			string dst=destPath.TrimEnd('\\','/');
			// On Windows, normalize local paths to use forward slashes for rclone.
			if(Environment.OSVersion.Platform==PlatformID.Win32NT) {
				src=NormalizeLocalPathForRclone(src);
				dst=NormalizeLocalPathForRclone(dst);
			}
			string args=operation+" \""+src+"\" \""+dst+"\" --config \""+configPath+"\" --verbose=1";
			psi.Arguments=args;
			psi.UseShellExecute=false;
			psi.CreateNoWindow=true;
			psi.RedirectStandardOutput=true;
			psi.RedirectStandardError=true;
			// Override any system-wide RCLONE_CONFIG env var with our managed config
			psi.Environment["RCLONE_CONFIG"]=configPath;
			// Pass SFTP password via env var if needed (S3 credentials are in the config file).
			string envPrefix="RCLONE_CONFIG_"+remoteName.ToUpper().Replace("-","_")+"_";
			if(GetBackendType()!=HybridBackendType.S3) {
				string password=GetSftpPass();
				if(!string.IsNullOrEmpty(password)) {
					psi.Environment[envPrefix+"PASS"]=password;
				}
			}
			using(Process process=Process.Start(psi)) {
				string output=process.StandardOutput.ReadToEnd();
				string error=process.StandardError.ReadToEnd();
				process.WaitForExit(120000);//2 minute timeout
				if(process.ExitCode!=0) {
					string cmdLine="\""+GetRclonePath()+"\" "+args
						+"\n[config: "+configPath+"]";
					throw new Exception("rclone "+operation+" failed (exit "+process.ExitCode+"):\n"+error+output
						+"\n\nFull command:\n"+cmdLine);
				}
			}
		}

		///<summary>Runs an rclone command with custom arguments and returns the combined stdout.
		///Used for test connectivity and version checks from the UI.</summary>
		public static string RunRcloneCommand(string arguments) {
			return RunRcloneCommand(arguments,null);
		}

		///<summary>Runs an rclone command with an explicit backend type override.
		///Used by FormPath test connection when the backend preference hasn't been saved yet.</summary>
		public static string RunRcloneCommandWithBackend(string arguments,HybridBackendType backendType) {
			ProcessStartInfo psi=new ProcessStartInfo();
			psi.FileName=GetRclonePath();
			psi.Arguments=arguments;
			psi.UseShellExecute=false;
			psi.CreateNoWindow=true;
			psi.RedirectStandardOutput=true;
			psi.RedirectStandardError=true;
			psi.Environment["RCLONE_CONFIG"]=GetConfigFilePath();
			string remoteName=GetRemoteName();
			string envPrefix="RCLONE_CONFIG_"+remoteName.ToUpper().Replace("-","_")+"_";
			if(backendType==HybridBackendType.S3) {
				string accessKey=GetS3AccessKey();
				string secretKey=GetS3SecretKey();
				if(!string.IsNullOrEmpty(accessKey)) {
					psi.Environment[envPrefix+"ACCESS_KEY_ID"]=accessKey;
				}
				if(!string.IsNullOrEmpty(secretKey)) {
					psi.Environment[envPrefix+"SECRET_ACCESS_KEY"]=secretKey;
				}
			}
			else {
				string password=GetSftpPass();
				if(!string.IsNullOrEmpty(password)) {
					psi.Environment[envPrefix+"PASS"]=password;
				}
			}
			using(Process process=Process.Start(psi)) {
				string output=process.StandardOutput.ReadToEnd();
				string error=process.StandardError.ReadToEnd();
				process.WaitForExit(30000);
				if(process.ExitCode!=0) {
					throw new Exception(error+output);
				}
				return output.Trim();
			}
		}

		///<summary>Runs an rclone command with custom arguments and optional password via environment variable.
		///Returns stdout. Throws on non-zero exit code.</summary>
		public static string RunRcloneCommand(string arguments,string password) {
			ProcessStartInfo psi=new ProcessStartInfo();
			psi.FileName=GetRclonePath();
			psi.Arguments=arguments;
			psi.UseShellExecute=false;
			psi.CreateNoWindow=true;
			psi.RedirectStandardOutput=true;
			psi.RedirectStandardError=true;
			// Override any system-wide RCLONE_CONFIG env var with our managed config
			psi.Environment["RCLONE_CONFIG"]=GetConfigFilePath();
			string remoteName=GetRemoteName();
			string envPrefix="RCLONE_CONFIG_"+remoteName.ToUpper().Replace("-","_")+"_";
			if(GetBackendType()==HybridBackendType.S3) {
				string accessKey=GetS3AccessKey();
				string secretKey=GetS3SecretKey();
				if(!string.IsNullOrEmpty(accessKey)) {
					psi.Environment[envPrefix+"ACCESS_KEY_ID"]=accessKey;
				}
				if(!string.IsNullOrEmpty(secretKey)) {
					psi.Environment[envPrefix+"SECRET_ACCESS_KEY"]=secretKey;
				}
			}
			else if(!string.IsNullOrEmpty(password)) {
				psi.Environment[envPrefix+"PASS"]=password;
			}
			using(Process process=Process.Start(psi)) {
				string output=process.StandardOutput.ReadToEnd();
				string error=process.StandardError.ReadToEnd();
				process.WaitForExit(30000);//30 second timeout
				if(process.ExitCode!=0) {
					throw new Exception(error+output);
				}
				return output.Trim();
			}
		}

		#endregion
	}
}
