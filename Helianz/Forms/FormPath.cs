using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.IO;
using System.Diagnostics;
using System.Windows.Forms;
using HelianzBusiness;
using CodeBase;
using System.Collections.Generic;
using System.Linq;

namespace Helianz{
///<summary></summary>
	public partial class FormPath : FormODBase {
		///<summary>If this is set to true before opening this form, then the program cannot find the AtoZ path and needs user input.</summary>
		public bool IsStartingUp;
		private string _errorMsg="";
		private bool _didVerifySwitchingFromDBStorage;
		#region Dropbox Private Variables
		private Program _program;
		private ProgramProperty _programPropertyDropboxPathAtoZ;
		private ProgramProperty _programPropertyDropboxAccessToken;
		///<summary>Set to true if the Dropbox API has been loaded already.</summary>
		private bool _hasDropboxLoaded;
		#endregion

		#region Sftp Private Variables
		///<summary>Set to true if the Sftp stuff has been loaded already.</summary>
		private bool _hasSftpLoaded;
		private ProgramProperty _programPropertySftpPathAtoZ;
		private ProgramProperty _programPropertySftpHostname;
		private ProgramProperty _programPropertySftpUsername;
		private ProgramProperty _programPropertySftpPassword;
		#endregion

		///<summary>This is the database storage type that the user has chosen (or was pulled from the database.
		///DO NOT change the value of this variable outside of SetRadioButtonChecked() or there is a chance for a stack overflow exception</summary>
		private DataStorageType _dataStorageType=DataStorageType.LocalAtoZ;

		#region Hybrid Private Variables
		private ProgramProperty _progPropHybridSftpHost;
		private ProgramProperty _progPropHybridSftpUser;
		private ProgramProperty _progPropHybridSftpPass;
		private ProgramProperty _progPropHybridKeyFile;
		private const string PropDescHybridSftpHost = "Hybrid SFTP Host";
		private const string PropDescHybridSftpUser = "Hybrid SFTP User";
		private const string PropDescHybridSftpPass = "Hybrid SFTP Pass";
		private const string PropDescHybridSftpKeyFile = "Hybrid Key File";
		#endregion

		///<summary></summary>
		public FormPath(){
			InitializeComponent();
			InitializeLayoutManager();
			Lan.F(this);
			//We only show the tabs in the designer for development purposes.  We want to hide them for our users.
			//Because the tab control is in "flat buttons" appearance and "fixed size" style the tabs will not show even if they are one pixel tall.
			//0,0 does not work because some size is required.
			tabControlDataStorageType.TabsAreCollapsed=true;
		}

		private void FormPath_Load(object sender, System.EventArgs e){
			if(!IsStartingUp && !Security.IsAuthorized(EnumPermType.Setup)) {//Verify user has Setup permission to change paths, after user has logged in.
				butOK.Enabled=false;
			}
			textDocPath.Text=PrefC.GetString(PrefName.DocPath);
			//ComputerPref compPref=ComputerPrefs.GetForLocalComputer();
			if(ReplicationServers.GetCount()==0) {
				labelServerPath.Visible=false;
				textServerPath.Visible=false;
				butBrowseServer.Visible=false;
			}
			else {
				labelServerPath.Text="Path override for this server.  Server id = "+ReplicationServers.GetServerId().ToString();
				textServerPath.Text=ReplicationServers.GetAtoZpath();
			}
			textLocalPath.Text=HelianzBusiness.FileIO.FileAtoZ.LocalAtoZpath;//This was set on startup.  //compPref.AtoZpath;
			textExportPath.Text=PrefC.GetString(PrefName.ExportPath);
			textLetterMergePath.Text=PrefC.GetString(PrefName.LetterMergePath);
			SetRadioButtonChecked(PrefC.AtoZfolderUsed);
			// The opt***_checked event will enable/disable the appropriate UI elements.
			checkMultiplePaths.Checked=(textDocPath.Text.LastIndexOf(';')!=-1);	
			//Also set the "multiple paths" checkbox at startup based on the current image folder list format. No need to store this info in the db.
			if(IsStartingUp) {//and failed to find path
				MsgBox.Show(this,"Could not find the path for the AtoZ folder.");
				if(Security.CurUser==null || !Security.IsAuthorized(EnumPermType.Setup)) {
					//The user is still allowed to set the "Path override for this computer", thus the user has a way to temporariliy get into OD in worst case.
					//For example, if the primary folder path is wrong or has changed, the user can set the path override for this computer to get into OD, then
					//can to to Setup | Data Paths to fix the primary path.
					DisableMostControls();
					textLocalPath.ReadOnly=false;
					butBrowseLocal.Enabled=true;
					ActiveControl=textLocalPath;//Focus on textLocalPath, since this is the only textbox the user can edit in this case.
				}
			}
			if(ODEnvironment.IsCloudServer) {
				textSftpUsername.UseSystemPasswordChar=true;
				butOK.Enabled=false;
				DisableMostControls();
			}
			if(PrefC.AtoZfolderUsed!=DataStorageType.InDatabase) {
				radioDatabaseStorage.Visible=false;
				LayoutManager.MoveLocation(radioDropboxStorage,new Point(LayoutManager.Scale(9),LayoutManager.Scale(38)));
				LayoutManager.MoveLocation(radioHybrid,new Point(LayoutManager.Scale(9),LayoutManager.Scale(95)));
				LayoutManager.MoveLocation(radioSftp,new Point(LayoutManager.Scale(9),LayoutManager.Scale(57)));
			}
		}

		/// <summary>Returns true if user really wants to continue or N/A. Verifies if there is RawBase64 data currently stored in the database. It will warn users that switching away means they are no longer able to access that data.</summary>
		private bool VerifySwitchingAwayFromDBStorage() {
			if(_didVerifySwitchingFromDBStorage) {
				return true;//already verified
			}
			if(PrefC.AtoZfolderUsed!=DataStorageType.InDatabase) {
				return true;//N/A
			}
			if(!MsgBox.Show(this,MsgBoxButtons.OKCancel,"You have chosen to switch away from storing images in the database. If you continue, you will not be able to switch back and you will lose access to your existing Imaging Module data currently stored in the database. Continue anyway?"))
			{
				//user will have one more chance to cancel because they can just cancel out of the form.
				SetRadioButtonChecked(_dataStorageType);
				return false;//changed their mind
			}
			_didVerifySwitchingFromDBStorage=true;
			return true;
		}

		private void DisableMostControls() {
			radioUseFolder.Enabled=false;
			textDocPath.ReadOnly=true;
			butBrowseDoc.Enabled=false;
			checkMultiplePaths.Enabled=false;
			textServerPath.ReadOnly=true;
			butBrowseServer.Enabled=false;
			radioDatabaseStorage.Enabled=false;
			textExportPath.ReadOnly=true;
			butBrowseExport.Enabled=false;
			textLetterMergePath.ReadOnly=true;
			butBrowseLetter.Enabled=false;
			textLocalPath.ReadOnly=true;
			butBrowseLocal.Enabled=false;
			radioDropboxStorage.Enabled=false;
			radioSftp.Enabled=false;
			textAtoZPath.ReadOnly=true;
			butAuthorize.Enabled=false;
			textSftpAtoZ.ReadOnly=true;
			textSftpHostname.ReadOnly=true;
			textSftpPassword.ReadOnly=true;
			textSftpUsername.ReadOnly=true;
			butSftpClear.Enabled=false;
		}

		private void SetRadioButtonChecked(DataStorageType dataStorageType) {
			switch(dataStorageType) {
				case DataStorageType.LocalAtoZ:
					_dataStorageType=DataStorageType.LocalAtoZ;
					radioUseFolder.Checked=true;//Will only do something when SetRadioButtonChecked is called on Load
					tabControlDataStorageType.SelectedTab=tabAtoZ;
					break;
				case DataStorageType.InDatabase:
					_dataStorageType=DataStorageType.InDatabase;
					radioDatabaseStorage.Checked=true;//Will only do something when SetRadioButtonChecked is called on Load
					tabControlDataStorageType.SelectedTab=tabInDatabase;
					break;
				case DataStorageType.DropboxAtoZ:
					if(!LoadDropboxSetup()) {
						SetRadioButtonChecked(_dataStorageType);//This can cause a stack overflow exception if someone sets _storageType from outside of this method.
						MessageBox.Show(_errorMsg);
						return;
					}
					radioDropboxStorage.Checked=true;//Will only do something when SetRadioButtonChecked is called on Load
					tabControlDataStorageType.SelectedTab=tabDropbox;
					_dataStorageType=DataStorageType.DropboxAtoZ;
					break;
				case DataStorageType.SftpAtoZ:
					if(!LoadSftpSetup()) {
						SetRadioButtonChecked(_dataStorageType);//This can cause a stack overflow exception if someone sets _storageType from outside of this method.
						MessageBox.Show(_errorMsg);
						return;
					}
					radioSftp.Checked=true;//Will only do something when SetRadioButtonChecked is called on Load
					tabControlDataStorageType.SelectedTab=tabSftp;
					_dataStorageType=DataStorageType.SftpAtoZ;
					break;
					case DataStorageType.LocalAtoZHybrid:
						LoadHybridSetup();
						radioHybrid.Checked=true;
						tabControlDataStorageType.SelectedTab=tabHybrid;
						_dataStorageType=DataStorageType.LocalAtoZHybrid;
						break;
				default:
					MsgBox.Show(this,"There was an error retrieving your preferred data storage method.  Please call support to solve this issue.");
					break;
			}
		}

		///<summary>Tries to show the file browser dialog to the user.  Returns true if the user actually selected a path from the dialog.
		///Returns false if the user cancels out.  Also, shows a warning message and returns false if an exception occurred.</summary>
		private bool ShowFileBrowserDialog() {
			//A customer is having a "Unable to retrieve root folder" unhandled exception occur when trying to show the file browser dialog.
			//Therefore, try to show the dialog and if any exception occurs simply show a message box giving some suggestions to the user.
			try {
				return (folderBrowserDialog.ShowDialog()==DialogResult.OK);
			}
			catch(Exception) {
				MsgBox.Show(this,"There was an error showing the Browse window.\r\nTry running as an Administrator or manually typing in a path.");
				return false;
			}
		}

		///<summary>Returns the given path with the local OS path separators as necessary.</summary>
		public static string FixDirSeparators(string path){
			if(Environment.OSVersion.Platform==PlatformID.Unix){
				path.Replace('\\',Path.DirectorySeparatorChar);
			}
			else{//Windows
				path.Replace('/',Path.DirectorySeparatorChar);
			}
			return path;
		}

		private void butBrowseDoc_Click(object sender,EventArgs e) {
			if(!ShowFileBrowserDialog()) {
				return;
			}
			//Ensure that the path entered has slashes matching the current OS (in case entered manually).
			string path=FixDirSeparators(folderBrowserDialog.SelectedPath);
			if(checkMultiplePaths.Checked && textDocPath.Text.Length>0) {
				string messageText=Lan.g(this,"Replace existing document paths? Click No to add path to existing document paths.");
				switch(MessageBox.Show(messageText,"",MessageBoxButtons.YesNoCancel)) {
					case DialogResult.Yes:
						textDocPath.Text=path;//Replace existing paths with new path.
						break;
					case DialogResult.No://Append to existing paths?
						//Do not append a path which is already present in the list.
						if(!IsPathInList(path,textDocPath.Text)) {
							textDocPath.Text=textDocPath.Text+";"+path;
						}
						break;
					default://Cancel button.
						break;
				}
			}
			else{
				textDocPath.Text=path;//Just replace existing paths with new path.
			}
		}

		private void butBrowseServer_Click(object sender,EventArgs e) {
			if(ShowFileBrowserDialog()) {
				textServerPath.Text=folderBrowserDialog.SelectedPath;
			}
		}

		private void butBrowseLocal_Click(object sender,EventArgs e) {
			if(ShowFileBrowserDialog()) {
				textLocalPath.Text=folderBrowserDialog.SelectedPath;
			}
		}

		private void butBrowseExport_Click(object sender, System.EventArgs e) {
			if(ShowFileBrowserDialog()) {
				textExportPath.Text=folderBrowserDialog.SelectedPath;
			}
		}

		private void butBrowseLetter_Click(object sender, System.EventArgs e) {
			if(ShowFileBrowserDialog()) {
				textLetterMergePath.Text=folderBrowserDialog.SelectedPath;
			}
		}

		///<summary>Returns true if the given path is part of the imagePaths list, false otherwise.</summary>
		private static bool IsPathInList(string path,string imagePaths){
			string[] stringArrayPaths=imagePaths.Split(';');
			for(int i=0;i<stringArrayPaths.Length;i++){
				if(stringArrayPaths[i]==path){//Case sensitive (since these could be unix paths).
					return true;
				}
			}
			return false;
		}

		private void radioUseFolder_Click(object sender,EventArgs e) {
			if(!VerifySwitchingAwayFromDBStorage()) { //they clicked cancel
				return;
			}
			labelPathSameForAll.Enabled = radioUseFolder.Checked;
			textDocPath.Enabled = radioUseFolder.Checked;
			butBrowseDoc.Enabled = radioUseFolder.Checked;
			checkMultiplePaths.Enabled = radioUseFolder.Checked;
			//even though server path might not be visible:
			labelServerPath.Enabled=radioUseFolder.Checked;
			textServerPath.Enabled=radioUseFolder.Checked;
			butBrowseServer.Enabled=radioUseFolder.Checked;
			//
			labelLocalPath.Enabled=radioUseFolder.Checked;
			textLocalPath.Enabled=radioUseFolder.Checked;
			butBrowseLocal.Enabled=radioUseFolder.Checked;
			SetRadioButtonChecked(DataStorageType.LocalAtoZ);
		}

		private void radioDatabaseStorage_Click(object sender,EventArgs e) {
			if(radioDatabaseStorage.Checked && PrefC.AtoZfolderUsed!=DataStorageType.InDatabase){//user attempting to use db to store images
				InputBox inputbox=new InputBox("Please enter password");
				inputbox.ShowDialog();
				if(inputbox.IsDialogCancel){
					SetRadioButtonChecked(_dataStorageType);
					return;
				}
				if(inputbox.StringResult!="abracadabra"){//to keep ignorant people from clicking this box.
					SetRadioButtonChecked(_dataStorageType);
					MsgBox.Show(this,"Wrong password");
					return;
				}
			}
			SetRadioButtonChecked(DataStorageType.InDatabase);
		}

		#region Dropbox Methods and Events

		///<summary>Returns true if loading Dropbox settings was successful.  False is something went wrong.
		///errorMsg will contain translated details about what went wrong in the case of a failure.</summary>
		private bool LoadDropboxSetup() {
			_errorMsg="";
			if(_hasDropboxLoaded) {
				return true;
			}
			_program=Programs.GetCur(ProgramName.Dropbox);
			if(_program==null) {//Should never happen.
				_errorMsg=Lan.g(this,"The Dropbox bridge is missing from the database.");
				return false;
			}
			List<ProgramProperty> listProgramProperties=ProgramProperties.GetForProgram(_program.ProgramNum);
			_programPropertyDropboxPathAtoZ=listProgramProperties.Find(x => x.PropertyDesc==Dropbox.PropertyDescs.AtoZPath);
			_programPropertyDropboxAccessToken=listProgramProperties.Find(x => x.PropertyDesc==Dropbox.PropertyDescs.AccessToken);
			if(_programPropertyDropboxPathAtoZ==null || _programPropertyDropboxAccessToken==null) { 
				_errorMsg=Lan.g(this,"You are missing a program property for Dropbox.  Please contact support to resolve this issue.");
				return false;
			}
			textAtoZPath.Text=_programPropertyDropboxPathAtoZ.PropertyValue;
			textAccessToken.Text=_programPropertyDropboxAccessToken.PropertyValue;
			_hasDropboxLoaded=true;
			return true;
		}

		private void butAuthorize_Click(object sender,EventArgs e) {
			using FormDropboxAuthorize formDropboxAuthorize=new FormDropboxAuthorize();
			formDropboxAuthorize.ProgramPropertyAccessToken=_programPropertyDropboxAccessToken;
			formDropboxAuthorize.ShowDialog();
			if(formDropboxAuthorize.DialogResult==DialogResult.OK) {
				_programPropertyDropboxAccessToken=formDropboxAuthorize.ProgramPropertyAccessToken.Copy();
				textAccessToken.Text=formDropboxAuthorize.ProgramPropertyAccessToken.PropertyValue;
			}
		}

		private void radioDropboxStorage_Click(object sender,EventArgs e) {
			if(!VerifySwitchingAwayFromDBStorage()) { //they clicked cancel
				return;
			}
			if(_dataStorageType==DataStorageType.DropboxAtoZ) {
				return;
			}
			SetRadioButtonChecked(DataStorageType.DropboxAtoZ);
		}
		#endregion

		#region Sftp

		///<summary>Returns true if loading Dropbox settings was successful.  False is something went wrong.
		///errorMsg will contain translated details about what went wrong in the case of a failure.</summary>
		private bool LoadSftpSetup() {
			_errorMsg="";
			if(_hasSftpLoaded) {
				return true;
			}
			_program=Programs.GetCur(ProgramName.SFTP);
			if(_program==null) {//Should never happen.
				_errorMsg=Lan.g(this,"The SFTP bridge is missing from the database.");
				return false;
			}
			List<ProgramProperty> listProgramProperties=ProgramProperties.GetForProgram(_program.ProgramNum);
			_programPropertySftpPathAtoZ=listProgramProperties.Find(x => x.PropertyDesc==ODSftp.PropertyDescs.AtoZPath);
			_programPropertySftpHostname=listProgramProperties.Find(x => x.PropertyDesc==ODSftp.PropertyDescs.SftpHostname);
			_programPropertySftpUsername=listProgramProperties.Find(x => x.PropertyDesc==ODSftp.PropertyDescs.UserName);
			_programPropertySftpPassword=listProgramProperties.Find(x => x.PropertyDesc==ODSftp.PropertyDescs.Password);
			if(_programPropertySftpPathAtoZ==null || _programPropertySftpHostname==null || _programPropertySftpUsername==null || _programPropertySftpPassword==null) {
				_errorMsg=Lan.g(this,"You are missing a program property for SFTP.  Please contact support to resolve this issue.");
				return false;
			}
			textSftpAtoZ.Text=_programPropertySftpPathAtoZ.PropertyValue;
			textSftpHostname.Text=_programPropertySftpHostname.PropertyValue;
			textSftpUsername.Text=_programPropertySftpUsername.PropertyValue;
			textSftpPassword.Text=_programPropertySftpPassword.PropertyValue;
			if(textSftpPassword.Text.Length>0) {
				string pass="";
				if(CDT.Class1.DecryptSftp(textSftpPassword.Text,out pass)) {
					textSftpPassword.Text=pass;
				}
				textSftpPassword.UseSystemPasswordChar=true;
				textSftpPassword.ReadOnly=true;
			}
			_hasSftpLoaded=true;
			return true;
		}

		private void butSftpClear_Click(object sender,EventArgs e) {
			textSftpPassword.Text="";
			textSftpPassword.UseSystemPasswordChar=false;
			textSftpPassword.ReadOnly=false;
		}
		
		private void radioSftp_Click(object sender,EventArgs e) {
			if(!VerifySwitchingAwayFromDBStorage()) { //they clicked cancel
				return;
			}
			if(_dataStorageType==DataStorageType.SftpAtoZ) {
				return;
			}
			SetRadioButtonChecked(DataStorageType.SftpAtoZ);
		}



		#endregion
		#region Hybrid

		private void LoadHybridSetup() {
			textHybridLocalPath.Text=PrefC.GetString(PrefName.DocPath);
			// Load SFTP credentials from ProgramProperties (where butSave_Click stores them)
			if(_program==null) {
				_program=Programs.GetCur(ProgramName.SFTP);
			}
			if(_program!=null) {
				List<ProgramProperty> listProgProps=ProgramProperties.GetForProgram(_program.ProgramNum);
				_progPropHybridSftpHost=listProgProps.Find(x => x.PropertyDesc==PropDescHybridSftpHost);
				_progPropHybridSftpUser=listProgProps.Find(x => x.PropertyDesc==PropDescHybridSftpUser);
				_progPropHybridSftpPass=listProgProps.Find(x => x.PropertyDesc==PropDescHybridSftpPass);
				_progPropHybridKeyFile=listProgProps.Find(x => x.PropertyDesc==PropDescHybridSftpKeyFile);
				textHybridSftpHost.Text=_progPropHybridSftpHost?.PropertyValue??"";
				textHybridSftpUser.Text=_progPropHybridSftpUser?.PropertyValue??"";
				if(_progPropHybridSftpPass!=null && !string.IsNullOrEmpty(_progPropHybridSftpPass.PropertyValue)) {
					string pass="";
					if(CDT.Class1.DecryptSftp(_progPropHybridSftpPass.PropertyValue,out pass)) {
						textHybridSftpPass.Text=pass;
					}
				}
				else {
					textHybridSftpPass.Text="";
				}
				textHybridKeyFile.Text=_progPropHybridKeyFile?.PropertyValue??"";
			}
			// Auto-detect bundled rclone
			if(RcloneSync.IsBundledRcloneAvailable()) {
				textHybridRclonePath.Text=Path.Combine(AppDomain.CurrentDomain.BaseDirectory,"rclone",
					Environment.OSVersion.Platform==PlatformID.Unix?"rclone":"rclone.exe");
			}
			else {
				textHybridRclonePath.Text=PrefC.GetStringSilent(PrefName.RclonePath);
				if(string.IsNullOrEmpty(textHybridRclonePath.Text)) {
					textHybridRclonePath.Text="rclone";
				}
			}
			textHybridServerPath.Text=PrefC.GetStringSilent(PrefName.RcloneServerPath);
			if(string.IsNullOrEmpty(textHybridServerPath.Text)) {
				textHybridServerPath.Text="/media";
			}
		}

		private void radioHybrid_Click(object sender,EventArgs e) {
			if(!VerifySwitchingAwayFromDBStorage()) {
				return;
			}
			if(_dataStorageType==DataStorageType.LocalAtoZHybrid) {
				return;
			}
			SetRadioButtonChecked(DataStorageType.LocalAtoZHybrid);
		}

		private void butHybridBrowseLocal_Click(object sender,EventArgs e) {
			if(ShowFileBrowserDialog()) {
				textHybridLocalPath.Text=FixDirSeparators(folderBrowserDialog.SelectedPath);
			}
		}

		private void butHybridTestConnection_Click(object sender,EventArgs e) {
			string rclonePath=textHybridRclonePath.Text.Trim();
			if(string.IsNullOrEmpty(rclonePath)) {
				rclonePath="rclone";
			}
			// 1. Check rclone binary
			try {
				string ver=RcloneSync.RunRcloneCommand("version");
				MsgBox.Show(this,"rclone found: "+ver);
			}
			catch {
				MsgBox.Show(this,"rclone not found at: "+rclonePath+"\nPlease install rclone or place rclone.exe in the app rclone/ folder.");
				return;
			}
			// 2. Write config and test SFTP connection
			string host=textHybridSftpHost.Text.Trim();
			string user=textHybridSftpUser.Text.Trim();
			string pass=textHybridSftpPass.Text;
			string keyFile=textHybridKeyFile.Text.Trim();
			if(string.IsNullOrEmpty(host) || string.IsNullOrEmpty(user)) {
				MsgBox.Show(this,"SFTP host and username are required.");
				return;
			}
			try {
				RcloneSync.WriteConfigFile(host,user,keyFile);
				string configPath=RcloneSync.GetConfigFilePath();
				string args="lsf helianz-media: --config \""+configPath+"\" --max-depth 1";
				string output=RcloneSync.RunRcloneCommand(args,pass);
				RcloneSync.InvalidateAvailabilityCache();
				MsgBox.Show(this,"Connection successful!\nRemote root contents:\n"+output);
			}
			catch(Exception ex) {
				MsgBox.Show(this,"SFTP connection failed: "+ex.Message);
			}
		}

	private void butHybridBrowseKey_Click(object sender,EventArgs e) {
			OpenFileDialog dlg=new OpenFileDialog();
			dlg.Title="Select SSH Key File";
			dlg.Filter="SSH Key Files|*.pem;*.key;id_rsa;id_rsa.pub|All Files|*.*";
			if(dlg.ShowDialog()==System.Windows.Forms.DialogResult.OK) {
				textHybridKeyFile.Text=dlg.FileName;
			}
		}

		private void butHybridMigrate_Click(object sender,EventArgs e) {
			if(PrefC.AtoZfolderUsed!=DataStorageType.LocalAtoZHybrid) {
				MsgBox.Show(this,"Migration can only run when Hybrid mode is selected.");
				return;
			}
			int count=MediaMigration.CountPatientsToMigrate();
			if(count==0) {
				MsgBox.Show(this,"No patients found with old A-Z paths. All patients are already using numbered folders.");
				return;
			}
			if(!MsgBox.Show(this,MsgBoxButtons.OKCancel,"Found "+count+" patient(s) with old A-Z paths."
				+"\r\nThis will move files from A-Z folders to numbered folders (0-99)."
				+"\r\n\r\nThis operation cannot be undone. Continue?"))
			{
				return;
			}
			Cursor=Cursors.WaitCursor;
			try {
				int migrated=0;
				int errors=0;
				UI.ProgressWin progressWin=new UI.ProgressWin();
				progressWin.StartingMessage="Migrating "+count+" patient(s) from A-Z to numbered folders...";
				MediaMigration.OnLog=(msg) => {
					Logger.openlog.LogMB("Migration: "+msg,Logger.Severity.INFO);
				};
				progressWin.ActionMain=() => {
					migrated=MediaMigration.MigrateAll();
				};
				progressWin.ShowDialog();
				if(migrated >= 0) {
					MsgBox.Show(this,"Migration complete.\r\nMigrated: "+migrated+" patient(s).");
				}
			}
			catch(Exception ex) {
				MsgBox.Show(this,"Migration error: "+ex.Message);
			}
			finally {
				Cursor=Cursors.Default;
				MediaMigration.OnLog=null;
			}
		}

		///<summary>Updates an existing ProgramProperty or creates a new one if it does not exist.</summary>
		private void UpdateOrCreateProp(string propDesc,string propValue) {
			if(_program==null) {
				return;
			}
			ProgramProperty prop=ProgramProperties.GetForProgram(_program.ProgramNum)
				.Find(x => x.PropertyDesc==propDesc);
			if(prop!=null) {
				prop.PropertyValue=propValue;
				ProgramProperties.Update(prop);
			}
			else {
				prop=new ProgramProperty();
				prop.ProgramNum=_program.ProgramNum;
				prop.PropertyDesc=propDesc;
				prop.PropertyValue=propValue;
				ProgramProperties.Insert(prop);
			}
		}

		///<summary>Safely updates a Pref value. If the pref does not exist in the DB yet,
		///inserts it. This avoids the exception thrown by Prefs.UpdateString when
		///a new PrefName enum value has no corresponding row in the preference table.</summary>
		private void UpdatePrefSafe(PrefName prefName,string newValue) {
			try {
				Prefs.UpdateString(prefName,newValue);
			}
			catch {
				// Pref does not exist in DB yet. Add to in-memory cache so it works immediately.
				Pref pref=new Pref();
				pref.PrefName=prefName.ToString();
				pref.ValueString=newValue;
				Prefs.UpdateValueForKey(pref);
			}
		}

				#endregion
		private void butSave_Click(object sender, System.EventArgs e){
			//remember that user might be using a website or a linux box to store images, therefore must allow forward slashes.
			if(radioUseFolder.Checked){
				if(textLocalPath.Text!="") {
					if(HelianzBusiness.FileIO.FileAtoZ.GetValidPathFromString(textLocalPath.Text)==null) {
						MsgBox.Show(this,"The path override for this computer is invalid.  The folder must exist and must contain all 26 A through Z folders.");
						return;
					}
				}
				else if(textServerPath.Text!="") {
					if(HelianzBusiness.FileIO.FileAtoZ.GetValidPathFromString(textServerPath.Text)==null) {
						MsgBox.Show(this,"The path override for this server is invalid.  The folder must exist and must contain all 26 A through Z folders.");
						return;
					}
				}
				else {
					if(HelianzBusiness.FileIO.FileAtoZ.GetValidPathFromString(textDocPath.Text)==null) {
						MsgBox.Show(this,"The path is invalid. The folder must exist and must contain the required subfolders.");
						return;
					}
				}				
    		}
			if(radioDropboxStorage.Checked && PrefC.AtoZfolderUsed!=DataStorageType.DropboxAtoZ
				&& !MsgBox.Show(this,MsgBoxButtons.OKCancel,"Warning: Updating workstations older than 16.3 while using Dropbox may cause issues."
					+"\r\nIf experienced, use Setup.exe located in AtoZ folder on DropBox to reinstall."))
			{
				return;
			}
			Cursor=Cursors.WaitCursor;
			if(radioDropboxStorage.Checked && !HelianzCloud.Dropbox.FileExists(textAccessToken.Text,
				ODFileUtils.CombinePaths(textAtoZPath.Text,"A",'/'))) 
			{
				Cursor=Cursors.Default;
				MsgBox.Show(this,"The Dropbox folder cannot be accessed or does not exist. The folder must contain all 26 A through Z folders.");
				return;
			}
			Cursor=Cursors.Default;
			if(radioDropboxStorage.Checked && ProgramProperties.UpdateProgramPropertyWithValue(_programPropertyDropboxPathAtoZ,textAtoZPath.Text)) {
				DataValid.SetInvalid(InvalidType.Programs);
			}
			Cursor=Cursors.WaitCursor;
			if(radioSftp.Checked) {
				bool doesFileExist;
				try {
					doesFileExist=HelianzCloud.Sftp.FileExists(textSftpHostname.Text,textSftpUsername.Text,textSftpPassword.Text,
						ODFileUtils.CombinePaths(textSftpAtoZ.Text,"A",'/'));
				}
				catch(Exception ex) {
					Cursor=Cursors.Default;
					MessageBox.Show(Lan.g(this,"Error connecting to SFTP host: ")+ex.Message);
					return;
				}
				if(!doesFileExist) {
					Cursor=Cursors.Default;
					MsgBox.Show(this,"The SFTP folder cannot be accessed or does not exist. The folder must contain all 26 A through Z folders.");
					return;
				}
			}
			Cursor=Cursors.Default;
			string sftpWarningMsg=Lan.g(this,"Warning: Updating workstations older than 16.3 while using SFTP may cause issues."
				+"\r\nIf experienced, use the Setup.exe located in the AtoZ folder on your SFTP server to reinstall.");
			if(radioSftp.Checked && PrefC.AtoZfolderUsed!=DataStorageType.SftpAtoZ
				&& !MsgBox.Show(this,MsgBoxButtons.OKCancel,sftpWarningMsg))
			{
				return;
			}

			if(radioHybrid.Checked) {
				if(HelianzBusiness.FileIO.FileAtoZ.GetValidPathFromString(textHybridLocalPath.Text)==null) {
					MsgBox.Show(this,"The local path is invalid. The folder must exist.");
					return;
				}
				// Save SFTP credentials as ProgramProperties
				if(_program==null) {
					_program=Programs.GetCur(ProgramName.SFTP);
				}
				if(_program!=null) {
					UpdateOrCreateProp(PropDescHybridSftpHost,textHybridSftpHost.Text.Trim());
					UpdateOrCreateProp(PropDescHybridSftpUser,textHybridSftpUser.Text.Trim());
					string encryptedPass="";
					if(!string.IsNullOrEmpty(textHybridSftpPass.Text)) {
						encryptedPass=CDT.Class1.EncryptSftp(textHybridSftpPass.Text);
					}
					UpdateOrCreateProp(PropDescHybridSftpPass,encryptedPass);
					UpdateOrCreateProp(PropDescHybridSftpKeyFile,textHybridKeyFile.Text.Trim());
					DataValid.SetInvalid(InvalidType.Programs);
				}
				// Save local path so GetPreferredAtoZpath() returns the correct path
				UpdatePrefSafe(PrefName.DocPath,textHybridLocalPath.Text.Trim());
				HelianzBusiness.FileIO.FileAtoZ.LocalAtoZpath=textHybridLocalPath.Text.Trim();
				ComputerPrefs.LocalComputer.AtoZpath=textHybridLocalPath.Text.Trim();
				ComputerPrefs.Update(ComputerPrefs.LocalComputer);
				// Save rclone and server path as Prefs
				UpdatePrefSafe(PrefName.RclonePath,textHybridRclonePath.Text.Trim());
				UpdatePrefSafe(PrefName.RcloneRemoteName,"helianz-media");
				UpdatePrefSafe(PrefName.RcloneServerPath,textHybridServerPath.Text.Trim());
				// Write rclone config file
				RcloneSync.WriteConfigFile(textHybridSftpHost.Text.Trim(),textHybridSftpUser.Text.Trim(),textHybridKeyFile.Text.Trim());
				RcloneSync.InvalidateAvailabilityCache();
			}

			bool isChanged=false;
			if(radioSftp.Checked){
				isChanged|=ProgramProperties.UpdateProgramPropertyWithValue(_programPropertySftpPathAtoZ,textSftpAtoZ.Text);
				isChanged|=ProgramProperties.UpdateProgramPropertyWithValue(_programPropertySftpHostname,textSftpHostname.Text);
				isChanged|=ProgramProperties.UpdateProgramPropertyWithValue(_programPropertySftpUsername,textSftpUsername.Text);
				string encryptedText=CDT.Class1.EncryptSftp(textSftpPassword.Text);
				if(encryptedText!="") { 
					isChanged|=ProgramProperties.UpdateProgramPropertyWithValue(_programPropertySftpPassword,encryptedText);
				}
				if (isChanged) { 
					DataValid.SetInvalid(InvalidType.Programs);
				}
			}
			isChanged=false;
			isChanged|=Prefs.UpdateInt(PrefName.AtoZfolderUsed,(int)_dataStorageType);
			isChanged|=Prefs.UpdateString(PrefName.DocPath,textDocPath.Text);
			isChanged|=Prefs.UpdateString(PrefName.ExportPath,textExportPath.Text);
			isChanged|=Prefs.UpdateString(PrefName.LetterMergePath,textLetterMergePath.Text);
			if(isChanged) { 
				DataValid.SetInvalid(InvalidType.Prefs);
			}
			if(HelianzBusiness.FileIO.FileAtoZ.LocalAtoZpath!=textLocalPath.Text) {//if local path changed
				HelianzBusiness.FileIO.FileAtoZ.LocalAtoZpath=textLocalPath.Text;
				//ComputerPref compPref=ComputerPrefs.GetForLocalComputer();
				ComputerPrefs.LocalComputer.AtoZpath=HelianzBusiness.FileIO.FileAtoZ.LocalAtoZpath;
				ComputerPrefs.Update(ComputerPrefs.LocalComputer);
			}
			if(ReplicationServers.GetAtoZpath()!=textServerPath.Text) {
				ReplicationServer replicationServer=ReplicationServers.GetForLocalComputer();
				replicationServer.AtoZpath=textServerPath.Text;
				ReplicationServers.Update(replicationServer);
				DataValid.SetInvalid(InvalidType.ReplicationServers);
			}
			SecurityLogs.MakeLogEntry(EnumPermType.Setup,0,"Data Path");
			DialogResult=DialogResult.OK;
		}

		private void FormPath_Closing(object sender,System.ComponentModel.CancelEventArgs e) {
			folderBrowserDialog?.Dispose();
			/*
			if(DialogResult==DialogResult.OK) {
				return;
			}
			if(!IsStartingUp) {
				return;
			}
			//no need to check paths here.  If user hits cancel when starting up, it should always notify and exit.
			if(radioUseFolder.Checked 
				&& ImageStore.GetValidPathFromString(textDocPath.Text)==null 
				&& ImageStore.GetValidPathFromString(textLocalPath.Text)==null) 
			{
				MsgBox.Show(this,"Invalid A to Z path.  Closing program.");
				Application.Exit();
			}*/
		}

	}
}
