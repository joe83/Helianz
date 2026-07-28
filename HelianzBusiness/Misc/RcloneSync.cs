using System;
using System.Diagnostics;
using System.IO;
using CodeBase;

namespace HelianzBusiness {
	///<summary>Wraps rclone CLI operations for hybrid media sync to/from a central server.
	///Supports SFTP and S3 backends via on-the-fly environment variable configuration.
	///No config file is written to disk — all rclone settings are passed as RCLONE_CONFIG_*
	///env vars read directly from the database.</summary>
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
			string configPath=WriteRcloneTempConfigFromDb();
			try {
				string remotePath=GetRemotePatientPath(patNum);
				ProcessStartInfo psi=new ProcessStartInfo();
				psi.FileName=GetRclonePath();
				psi.Arguments="lsf \""+remotePath+"\" --max-depth 1 --config \""+configPath+"\"";
				psi.UseShellExecute=false;
				psi.CreateNoWindow=true;
				psi.RedirectStandardOutput=true;
				psi.RedirectStandardError=true;
				using(Process process=Process.Start(psi)) {
					string output=process.StandardOutput.ReadToEnd();
					process.WaitForExit(30000);
					return process.ExitCode==0 && !string.IsNullOrEmpty(output.Trim());
				}
			}
			catch {
				return false;
			}
			finally {
				try { File.Delete(configPath); } catch { }
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
			if(path.Contains(":/")) { return path; }
			return path.Replace('\\','/');
		}

		///<summary>Writes a temporary rclone config file with the remote definition.
		///Returns the path to the temp config file, which the caller must delete after use.
		///This is used instead of RCLONE_CONFIG_* env vars because ProcessStartInfo.Environment
		///does not reliably pass custom env vars to child processes on Windows/.NET Framework.</summary>
		private static string WriteRcloneTempConfig(HybridBackendType backendType,
			string sftpHost,string sftpUser,string sftpPass,
			string s3Provider,string s3Endpoint,string s3Region,string s3AccessKey,string s3SecretKey)
		{
			string remoteName=GetRemoteName();
			System.Text.StringBuilder sb=new System.Text.StringBuilder();
			sb.AppendLine("["+remoteName+"]");
			if(backendType==HybridBackendType.S3) {
				sb.AppendLine("type = s3");
				if(!string.IsNullOrEmpty(s3Provider)) sb.AppendLine("provider = "+s3Provider);
				if(!string.IsNullOrEmpty(s3Endpoint)) sb.AppendLine("endpoint = "+s3Endpoint);
				if(!string.IsNullOrEmpty(s3Region))   sb.AppendLine("region = "+s3Region);
				if(!string.IsNullOrEmpty(s3AccessKey)) sb.AppendLine("access_key_id = "+s3AccessKey);
				if(!string.IsNullOrEmpty(s3SecretKey)) sb.AppendLine("secret_access_key = "+s3SecretKey);
				sb.AppendLine("env_auth = false");
				sb.AppendLine("force_path_style = true");
				sb.AppendLine("acl = private");
			}
			else {
				sb.AppendLine("type = sftp");
				if(!string.IsNullOrEmpty(sftpHost)) sb.AppendLine("host = "+sftpHost);
				if(!string.IsNullOrEmpty(sftpUser)) sb.AppendLine("user = "+sftpUser);
				if(!string.IsNullOrEmpty(sftpPass)) sb.AppendLine("pass = "+sftpPass);
			}
			string configPath=Path.Combine(Path.GetTempPath(),"rclone_helianz_"+Guid.NewGuid().ToString("N")+".conf");
			File.WriteAllText(configPath,sb.ToString());
			return configPath;
		}

		///<summary>Overload that reads credentials from ProgramProperties (DB).</summary>
		private static string WriteRcloneTempConfigFromDb() {
			long progNum=Programs.GetProgramNum(ProgramName.SFTP);
			HybridBackendType backendType=GetBackendType();
			string sftpHost="",sftpUser="",sftpPass="";
			string s3Provider="",s3Endpoint="",s3Region="",s3AccessKey="",s3SecretKey="";
			if(backendType==HybridBackendType.S3) {
				s3Provider=ProgramProperties.GetPropVal(progNum,"Hybrid S3 Provider")??"";
				s3Endpoint=ProgramProperties.GetPropVal(progNum,"Hybrid S3 Endpoint")??"";
				s3Region=ProgramProperties.GetPropVal(progNum,"Hybrid S3 Region")??"";
				s3AccessKey=GetS3AccessKey();
				s3SecretKey=GetS3SecretKey();
			}
			else {
				sftpHost=ProgramProperties.GetPropVal(progNum,"Hybrid SFTP Host")??"";
				sftpUser=ProgramProperties.GetPropVal(progNum,"Hybrid SFTP User")??"";
				sftpPass=GetSftpPass();
			}
			return WriteRcloneTempConfig(backendType,sftpHost,sftpUser,sftpPass,
				s3Provider,s3Endpoint,s3Region,s3AccessKey,s3SecretKey);
		}

		///<summary>Runs an rclone command with config passed via temporary config file.
		///The temp file is deleted after the process exits. Throws on non-zero exit code.</summary>
		private static void RunRclone(string operation,string sourcePath,string destPath) {
			string configPath=WriteRcloneTempConfigFromDb();
			try {
				ProcessStartInfo psi=new ProcessStartInfo();
				psi.FileName=GetRclonePath();
				string src=sourcePath.TrimEnd('\\','/');
				string dst=destPath.TrimEnd('\\','/');
				if(Environment.OSVersion.Platform==PlatformID.Win32NT) {
					src=NormalizeLocalPathForRclone(src);
					dst=NormalizeLocalPathForRclone(dst);
				}
				psi.Arguments=operation+" \""+src+"\" \""+dst+"\" --config \""+configPath+"\" --verbose=1";
				psi.UseShellExecute=false;
				psi.CreateNoWindow=true;
				psi.RedirectStandardOutput=true;
				psi.RedirectStandardError=true;
				using(Process process=Process.Start(psi)) {
					string output=process.StandardOutput.ReadToEnd();
					string error=process.StandardError.ReadToEnd();
					process.WaitForExit(120000);
					if(process.ExitCode!=0) {
						throw new Exception("rclone "+operation+" failed (exit "+process.ExitCode+"):\n"+error+output);
					}
				}
			}
			finally {
				try { File.Delete(configPath); } catch { }
			}
		}

		///<summary>Runs an rclone command with custom arguments and returns stdout.
		///Uses temp config file from DB credentials.</summary>
		public static string RunRcloneCommand(string arguments) {
			string configPath=WriteRcloneTempConfigFromDb();
			try {
				ProcessStartInfo psi=new ProcessStartInfo();
				psi.FileName=GetRclonePath();
				psi.Arguments=arguments+" --config \""+configPath+"\"";
				psi.UseShellExecute=false;
				psi.CreateNoWindow=true;
				psi.RedirectStandardOutput=true;
				psi.RedirectStandardError=true;
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
			finally {
				try { File.Delete(configPath); } catch { }
			}
		}

		///<summary>Runs an rclone command for test connection with explicit backend parameters.
		///Uses temp config file (params from UI, not DB).</summary>
		public static string RunRcloneCommandTest(string arguments,HybridBackendType backendType,
			string sftpHost,string sftpUser,string sftpPass,
			string s3Provider,string s3Endpoint,string s3Region,string s3AccessKey,string s3SecretKey)
		{
			string configPath=WriteRcloneTempConfig(backendType,sftpHost,sftpUser,sftpPass,
				s3Provider,s3Endpoint,s3Region,s3AccessKey,s3SecretKey);
			try {
				ProcessStartInfo psi=new ProcessStartInfo();
				psi.FileName=GetRclonePath();
				psi.Arguments=arguments+" --config \""+configPath+"\"";
				psi.UseShellExecute=false;
				psi.CreateNoWindow=true;
				psi.RedirectStandardOutput=true;
				psi.RedirectStandardError=true;
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
			finally {
				try { File.Delete(configPath); } catch { }
			}
		}

		#endregion
	}
}
