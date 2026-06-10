using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Helianz {
	public partial class FormPath {
		private System.ComponentModel.IContainer components = null;

		///<summary></summary>
		protected override void Dispose( bool disposing ){
			if( disposing ){
				if(components != null){
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#region Windows Form Designer generated code

		private void InitializeComponent(){
			System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FormPath));
			this.butOK = new Helianz.UI.Button();
			this.textDocPath = new System.Windows.Forms.TextBox();
			this.textExportPath = new System.Windows.Forms.TextBox();
			this.butBrowseExport = new Helianz.UI.Button();
			this.butBrowseDoc = new Helianz.UI.Button();
			this.folderBrowserDialog = new Helianz.FolderBrowserDialog();
			this.label1 = new System.Windows.Forms.Label();
			this.labelPathSameForAll = new System.Windows.Forms.Label();
			this.label3 = new System.Windows.Forms.Label();
			this.butBrowseLetter = new Helianz.UI.Button();
			this.textLetterMergePath = new System.Windows.Forms.TextBox();
			this.checkMultiplePaths = new Helianz.UI.CheckBox();
			this.groupbox1 = new Helianz.UI.GroupBox();
			this.radioSftp = new System.Windows.Forms.RadioButton();
			this.radioDropboxStorage = new System.Windows.Forms.RadioButton();
			this.tabControlDataStorageType = new Helianz.UI.TabControl();
			this.tabAtoZ = new Helianz.UI.TabPage();
			this.butBrowseLocal = new Helianz.UI.Button();
			this.butBrowseServer = new Helianz.UI.Button();
			this.labelServerPath = new System.Windows.Forms.Label();
			this.textServerPath = new System.Windows.Forms.TextBox();
			this.labelLocalPath = new System.Windows.Forms.Label();
			this.textLocalPath = new System.Windows.Forms.TextBox();
			this.tabInDatabase = new Helianz.UI.TabPage();
			this.label2 = new System.Windows.Forms.Label();
			this.tabDropbox = new Helianz.UI.TabPage();
			this.label12 = new System.Windows.Forms.Label();
			this.label5 = new System.Windows.Forms.Label();
			this.textAtoZPath = new System.Windows.Forms.TextBox();
			this.butAuthorize = new Helianz.UI.Button();
			this.labelWebhostURL = new System.Windows.Forms.Label();
			this.textAccessToken = new System.Windows.Forms.TextBox();
			this.label4 = new System.Windows.Forms.Label();
			this.tabSftp = new Helianz.UI.TabPage();
			this.label11 = new System.Windows.Forms.Label();
			this.butSftpClear = new Helianz.UI.Button();
			this.label10 = new System.Windows.Forms.Label();
			this.label9 = new System.Windows.Forms.Label();
			this.textSftpPassword = new System.Windows.Forms.TextBox();
			this.label8 = new System.Windows.Forms.Label();
			this.textSftpUsername = new System.Windows.Forms.TextBox();
			this.label6 = new System.Windows.Forms.Label();
			this.textSftpAtoZ = new System.Windows.Forms.TextBox();
			this.label7 = new System.Windows.Forms.Label();
			this.textSftpHostname = new System.Windows.Forms.TextBox();
			this.radioHybrid = new System.Windows.Forms.RadioButton();
			this.tabHybrid = new Helianz.UI.TabPage();
			this.labelHybridDesc = new System.Windows.Forms.Label();
			this.labelHybridLocalPath = new System.Windows.Forms.Label();
			this.textHybridLocalPath = new System.Windows.Forms.TextBox();
			this.butHybridBrowseLocal = new Helianz.UI.Button();
			this.labelHybridSftpHost = new System.Windows.Forms.Label();
			this.textHybridSftpHost = new System.Windows.Forms.TextBox();
			this.labelHybridSftpUser = new System.Windows.Forms.Label();
			this.textHybridSftpUser = new System.Windows.Forms.TextBox();
			this.labelHybridSftpPass = new System.Windows.Forms.Label();
			this.textHybridSftpPass = new System.Windows.Forms.TextBox();
			this.labelHybridRclonePath = new System.Windows.Forms.Label();
			this.textHybridRclonePath = new System.Windows.Forms.TextBox();
			this.labelHybridServerPath = new System.Windows.Forms.Label();
			this.textHybridServerPath = new System.Windows.Forms.TextBox();
			this.butHybridTestConnection = new Helianz.UI.Button();
			this.labelHybridKeyFile = new System.Windows.Forms.Label();
			this.textHybridKeyFile = new System.Windows.Forms.TextBox();
			this.butHybridBrowseKey = new Helianz.UI.Button();
			this.butHybridMigrate = new Helianz.UI.Button();
			this.radioDatabaseStorage = new System.Windows.Forms.RadioButton();
			this.radioUseFolder = new System.Windows.Forms.RadioButton();
			this.groupbox1.SuspendLayout();
			this.tabControlDataStorageType.SuspendLayout();
			this.tabAtoZ.SuspendLayout();
			this.tabInDatabase.SuspendLayout();
			this.tabDropbox.SuspendLayout();
			this.tabSftp.SuspendLayout();
			this.SuspendLayout();
			// 
			// butOK
			// 
			this.butOK.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.butOK.Location = new System.Drawing.Point(588, 588);
			this.butOK.Name = "butOK";
			this.butOK.Size = new System.Drawing.Size(75, 26);
			this.butOK.TabIndex = 2;
			this.butOK.Text = "&Save";
			this.butOK.Click += new System.EventHandler(this.butSave_Click);
			// 
			// textDocPath
			// 
			this.textDocPath.Location = new System.Drawing.Point(7, 60);
			this.textDocPath.Name = "textDocPath";
			this.textDocPath.Size = new System.Drawing.Size(497, 20);
			this.textDocPath.TabIndex = 1;
			// 
			// textExportPath
			// 
			this.textExportPath.Location = new System.Drawing.Point(19, 452);
			this.textExportPath.Name = "textExportPath";
			this.textExportPath.Size = new System.Drawing.Size(515, 20);
			this.textExportPath.TabIndex = 1;
			// 
			// butBrowseExport
			// 
			this.butBrowseExport.Location = new System.Drawing.Point(538, 450);
			this.butBrowseExport.Name = "butBrowseExport";
			this.butBrowseExport.Size = new System.Drawing.Size(76, 25);
			this.butBrowseExport.TabIndex = 91;
			this.butBrowseExport.Text = "Browse";
			this.butBrowseExport.Click += new System.EventHandler(this.butBrowseExport_Click);
			// 
			// butBrowseDoc
			// 
			this.butBrowseDoc.Location = new System.Drawing.Point(510, 56);
			this.butBrowseDoc.Name = "butBrowseDoc";
			this.butBrowseDoc.Size = new System.Drawing.Size(76, 25);
			this.butBrowseDoc.TabIndex = 2;
			this.butBrowseDoc.Text = "&Browse";
			this.butBrowseDoc.Click += new System.EventHandler(this.butBrowseDoc_Click);
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(20, 381);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(596, 65);
			this.label1.TabIndex = 92;
			this.label1.Text = resources.GetString("label1.Text");
			this.label1.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
			// 
			// labelPathSameForAll
			// 
			this.labelPathSameForAll.Location = new System.Drawing.Point(7, 4);
			this.labelPathSameForAll.Name = "labelPathSameForAll";
			this.labelPathSameForAll.Size = new System.Drawing.Size(579, 50);
			this.labelPathSameForAll.TabIndex = 93;
			this.labelPathSameForAll.Text = resources.GetString("labelPathSameForAll.Text");
			this.labelPathSameForAll.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
			// 
			// label3
			// 
			this.label3.Location = new System.Drawing.Point(20, 476);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(596, 65);
			this.label3.TabIndex = 96;
			this.label3.Text = resources.GetString("label3.Text");
			this.label3.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
			// 
			// butBrowseLetter
			// 
			this.butBrowseLetter.Location = new System.Drawing.Point(538, 545);
			this.butBrowseLetter.Name = "butBrowseLetter";
			this.butBrowseLetter.Size = new System.Drawing.Size(76, 25);
			this.butBrowseLetter.TabIndex = 95;
			this.butBrowseLetter.Text = "Browse";
			this.butBrowseLetter.Click += new System.EventHandler(this.butBrowseLetter_Click);
			// 
			// textLetterMergePath
			// 
			this.textLetterMergePath.Location = new System.Drawing.Point(19, 548);
			this.textLetterMergePath.Name = "textLetterMergePath";
			this.textLetterMergePath.Size = new System.Drawing.Size(515, 20);
			this.textLetterMergePath.TabIndex = 94;
			// 
			// checkMultiplePaths
			// 
			this.checkMultiplePaths.CheckAlign = System.Drawing.ContentAlignment.TopLeft;
			this.checkMultiplePaths.Location = new System.Drawing.Point(7, 86);
			this.checkMultiplePaths.Name = "checkMultiplePaths";
			this.checkMultiplePaths.Size = new System.Drawing.Size(580, 44);
			this.checkMultiplePaths.TabIndex = 98;
			this.checkMultiplePaths.Text = resources.GetString("checkMultiplePaths.Text");
			// 
			// groupbox1
			// 
			this.groupbox1.Controls.Add(this.radioSftp);
			this.groupbox1.Controls.Add(this.radioDropboxStorage);
			this.groupbox1.Controls.Add(this.tabControlDataStorageType);
			this.groupbox1.Controls.Add(this.radioHybrid);
			this.groupbox1.Controls.Add(this.radioDatabaseStorage);
			this.groupbox1.Controls.Add(this.radioUseFolder);
			this.groupbox1.Location = new System.Drawing.Point(10, 12);
			this.groupbox1.Name = "groupbox1";
			this.groupbox1.Size = new System.Drawing.Size(624, 384);
			this.groupbox1.TabIndex = 0;
			this.groupbox1.Text = "A to Z Images Folder for storing images and documents";
			// 
			// radioSftp
			// 
			this.radioSftp.Location = new System.Drawing.Point(9, 76);
			this.radioSftp.Name = "radioSftp";
			this.radioSftp.Size = new System.Drawing.Size(569, 18);
			this.radioSftp.TabIndex = 103;
			this.radioSftp.Text = "Store images on a server via SSH File Transfer Protocol (SFTP)";
			this.radioSftp.UseVisualStyleBackColor = true;
			this.radioSftp.Click += new System.EventHandler(this.radioSftp_Click);
			// 
			// radioDropboxStorage
			// 
			this.radioDropboxStorage.Location = new System.Drawing.Point(9, 57);
			this.radioDropboxStorage.Name = "radioDropboxStorage";
			this.radioDropboxStorage.Size = new System.Drawing.Size(435, 18);
			this.radioDropboxStorage.TabIndex = 102;
			this.radioDropboxStorage.Text = "Store images in Dropbox (an internet connection will be required)";
			this.radioDropboxStorage.UseVisualStyleBackColor = true;
			this.radioDropboxStorage.Click += new System.EventHandler(this.radioDropboxStorage_Click);
			// 
			// tabControlDataStorageType
			// 
			this.tabControlDataStorageType.Controls.Add(this.tabAtoZ);
			this.tabControlDataStorageType.Controls.Add(this.tabInDatabase);
			this.tabControlDataStorageType.Controls.Add(this.tabDropbox);
			this.tabControlDataStorageType.Controls.Add(this.tabSftp);
			this.tabControlDataStorageType.Controls.Add(this.tabHybrid);
			this.tabControlDataStorageType.Location = new System.Drawing.Point(11, 119);
			this.tabControlDataStorageType.Name = "tabControlDataStorageType";
			this.tabControlDataStorageType.Size = new System.Drawing.Size(606, 256);
			this.tabControlDataStorageType.TabIndex = 97;
			this.tabControlDataStorageType.TabStop = false;
			// 
			// tabAtoZ
			// 
			this.tabAtoZ.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(252)))), ((int)(((byte)(253)))), ((int)(((byte)(254)))));
			this.tabAtoZ.Controls.Add(this.butBrowseLocal);
			this.tabAtoZ.Controls.Add(this.labelPathSameForAll);
			this.tabAtoZ.Controls.Add(this.butBrowseServer);
			this.tabAtoZ.Controls.Add(this.butBrowseDoc);
			this.tabAtoZ.Controls.Add(this.labelServerPath);
			this.tabAtoZ.Controls.Add(this.textDocPath);
			this.tabAtoZ.Controls.Add(this.textServerPath);
			this.tabAtoZ.Controls.Add(this.checkMultiplePaths);
			this.tabAtoZ.Controls.Add(this.labelLocalPath);
			this.tabAtoZ.Controls.Add(this.textLocalPath);
			this.tabAtoZ.Location = new System.Drawing.Point(2, 21);
			this.tabAtoZ.Name = "tabAtoZ";
			this.tabAtoZ.Padding = new System.Windows.Forms.Padding(3);
			this.tabAtoZ.Size = new System.Drawing.Size(602, 233);
			this.tabAtoZ.TabIndex = 0;
			this.tabAtoZ.Text = "AtoZ";
			// 
			// butBrowseLocal
			// 
			this.butBrowseLocal.Location = new System.Drawing.Point(510, 202);
			this.butBrowseLocal.Name = "butBrowseLocal";
			this.butBrowseLocal.Size = new System.Drawing.Size(76, 25);
			this.butBrowseLocal.TabIndex = 103;
			this.butBrowseLocal.Text = "Browse";
			this.butBrowseLocal.Click += new System.EventHandler(this.butBrowseLocal_Click);
			// 
			// butBrowseServer
			// 
			this.butBrowseServer.Location = new System.Drawing.Point(510, 156);
			this.butBrowseServer.Name = "butBrowseServer";
			this.butBrowseServer.Size = new System.Drawing.Size(76, 25);
			this.butBrowseServer.TabIndex = 106;
			this.butBrowseServer.Text = "Browse";
			this.butBrowseServer.Click += new System.EventHandler(this.butBrowseServer_Click);
			// 
			// labelServerPath
			// 
			this.labelServerPath.Location = new System.Drawing.Point(7, 140);
			this.labelServerPath.Name = "labelServerPath";
			this.labelServerPath.Size = new System.Drawing.Size(488, 17);
			this.labelServerPath.TabIndex = 107;
			this.labelServerPath.Text = "Path override for this server.  Usually leave blank.";
			this.labelServerPath.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
			// 
			// textServerPath
			// 
			this.textServerPath.Location = new System.Drawing.Point(7, 160);
			this.textServerPath.Name = "textServerPath";
			this.textServerPath.Size = new System.Drawing.Size(497, 20);
			this.textServerPath.TabIndex = 105;
			// 
			// labelLocalPath
			// 
			this.labelLocalPath.Location = new System.Drawing.Point(7, 186);
			this.labelLocalPath.Name = "labelLocalPath";
			this.labelLocalPath.Size = new System.Drawing.Size(498, 17);
			this.labelLocalPath.TabIndex = 104;
			this.labelLocalPath.Text = "Path override for this computer.  Usually leave blank.";
			this.labelLocalPath.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
			// 
			// textLocalPath
			// 
			this.textLocalPath.Location = new System.Drawing.Point(7, 206);
			this.textLocalPath.Name = "textLocalPath";
			this.textLocalPath.Size = new System.Drawing.Size(497, 20);
			this.textLocalPath.TabIndex = 102;
			// 
			// tabInDatabase
			// 
			this.tabInDatabase.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(252)))), ((int)(((byte)(253)))), ((int)(((byte)(254)))));
			this.tabInDatabase.Controls.Add(this.label2);
			this.tabInDatabase.Location = new System.Drawing.Point(2, 21);
			this.tabInDatabase.Name = "tabInDatabase";
			this.tabInDatabase.Padding = new System.Windows.Forms.Padding(3);
			this.tabInDatabase.Size = new System.Drawing.Size(602, 233);
			this.tabInDatabase.TabIndex = 1;
			this.tabInDatabase.Text = "Database";
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(6, 7);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(583, 124);
			this.label2.TabIndex = 97;
			this.label2.Text = resources.GetString("label2.Text");
			// 
			// tabDropbox
			// 
			this.tabDropbox.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(252)))), ((int)(((byte)(253)))), ((int)(((byte)(254)))));
			this.tabDropbox.Controls.Add(this.label12);
			this.tabDropbox.Controls.Add(this.label5);
			this.tabDropbox.Controls.Add(this.textAtoZPath);
			this.tabDropbox.Controls.Add(this.butAuthorize);
			this.tabDropbox.Controls.Add(this.labelWebhostURL);
			this.tabDropbox.Controls.Add(this.textAccessToken);
			this.tabDropbox.Controls.Add(this.label4);
			this.tabDropbox.Location = new System.Drawing.Point(2, 21);
			this.tabDropbox.Name = "tabDropbox";
			this.tabDropbox.Padding = new System.Windows.Forms.Padding(3);
			this.tabDropbox.Size = new System.Drawing.Size(602, 233);
			this.tabDropbox.TabIndex = 2;
			this.tabDropbox.Text = "Dropbox";
			// 
			// label12
			// 
			this.label12.Location = new System.Drawing.Point(81, 40);
			this.label12.Name = "label12";
			this.label12.Size = new System.Drawing.Size(465, 29);
			this.label12.TabIndex = 138;
			this.label12.Text = "Any subfolders defined in the AtoZ Path must be separated with the forward slash " +
    "\" / \" character.";
			this.label12.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
			// 
			// label5
			// 
			this.label5.Location = new System.Drawing.Point(99, 77);
			this.label5.Name = "label5";
			this.label5.Size = new System.Drawing.Size(129, 19);
			this.label5.TabIndex = 127;
			this.label5.Text = "Dropbox AtoZ Path";
			this.label5.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// textAtoZPath
			// 
			this.textAtoZPath.Location = new System.Drawing.Point(230, 76);
			this.textAtoZPath.Name = "textAtoZPath";
			this.textAtoZPath.Size = new System.Drawing.Size(199, 20);
			this.textAtoZPath.TabIndex = 126;
			// 
			// butAuthorize
			// 
			this.butAuthorize.Location = new System.Drawing.Point(230, 128);
			this.butAuthorize.Name = "butAuthorize";
			this.butAuthorize.Size = new System.Drawing.Size(199, 24);
			this.butAuthorize.TabIndex = 125;
			this.butAuthorize.Text = "Authorize Dropbox";
			this.butAuthorize.Click += new System.EventHandler(this.butAuthorize_Click);
			// 
			// labelWebhostURL
			// 
			this.labelWebhostURL.Location = new System.Drawing.Point(99, 103);
			this.labelWebhostURL.Name = "labelWebhostURL";
			this.labelWebhostURL.Size = new System.Drawing.Size(129, 19);
			this.labelWebhostURL.TabIndex = 124;
			this.labelWebhostURL.Text = "Access Token";
			this.labelWebhostURL.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// textAccessToken
			// 
			this.textAccessToken.Location = new System.Drawing.Point(230, 102);
			this.textAccessToken.Name = "textAccessToken";
			this.textAccessToken.ReadOnly = true;
			this.textAccessToken.Size = new System.Drawing.Size(199, 20);
			this.textAccessToken.TabIndex = 123;
			// 
			// label4
			// 
			this.label4.Location = new System.Drawing.Point(6, 3);
			this.label4.Name = "label4";
			this.label4.Size = new System.Drawing.Size(436, 15);
			this.label4.TabIndex = 93;
			this.label4.Text = "Store images on your Dropbox account.";
			this.label4.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
			// 
			// tabSftp
			// 
			this.tabSftp.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(252)))), ((int)(((byte)(253)))), ((int)(((byte)(254)))));
			this.tabSftp.Controls.Add(this.label11);
			this.tabSftp.Controls.Add(this.butSftpClear);
			this.tabSftp.Controls.Add(this.label10);
			this.tabSftp.Controls.Add(this.label9);
			this.tabSftp.Controls.Add(this.textSftpPassword);
			this.tabSftp.Controls.Add(this.label8);
			this.tabSftp.Controls.Add(this.textSftpUsername);
			this.tabSftp.Controls.Add(this.label6);
			this.tabSftp.Controls.Add(this.textSftpAtoZ);
			this.tabSftp.Controls.Add(this.label7);
			this.tabSftp.Controls.Add(this.textSftpHostname);
			this.tabSftp.Location = new System.Drawing.Point(2, 21);
			this.tabSftp.Name = "tabSftp";
			this.tabSftp.Size = new System.Drawing.Size(602, 233);
			this.tabSftp.TabIndex = 3;
			this.tabSftp.Text = "SFTP";
			this.tabHybrid.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(252)))), ((int)(((byte)(253)))), ((int)(((byte)(254)))));
			this.tabHybrid.Controls.Add(this.butHybridTestConnection);
			this.tabHybrid.Controls.Add(this.textHybridServerPath);
			this.tabHybrid.Controls.Add(this.labelHybridServerPath);
			this.tabHybrid.Controls.Add(this.textHybridRclonePath);
			this.tabHybrid.Controls.Add(this.labelHybridRclonePath);
			this.tabHybrid.Controls.Add(this.textHybridSftpPass);
			this.tabHybrid.Controls.Add(this.labelHybridSftpPass);
			this.tabHybrid.Controls.Add(this.textHybridSftpUser);
			this.tabHybrid.Controls.Add(this.labelHybridSftpUser);
			this.tabHybrid.Controls.Add(this.textHybridSftpHost);
			this.tabHybrid.Controls.Add(this.labelHybridSftpHost);
			this.tabHybrid.Controls.Add(this.butHybridBrowseLocal);
			this.tabHybrid.Controls.Add(this.textHybridLocalPath);
			this.tabHybrid.Controls.Add(this.labelHybridLocalPath);
			this.tabHybrid.Controls.Add(this.butHybridBrowseKey);
			this.tabHybrid.Controls.Add(this.butHybridMigrate);
			this.tabHybrid.Controls.Add(this.textHybridKeyFile);
			this.tabHybrid.Controls.Add(this.labelHybridKeyFile);
			this.tabHybrid.Controls.Add(this.labelHybridDesc);
			this.tabHybrid.Location = new System.Drawing.Point(2, 21);
			this.tabHybrid.Name = "tabHybrid";
			this.tabHybrid.Size = new System.Drawing.Size(602, 255);
			this.tabHybrid.TabIndex = 4;
			this.tabHybrid.Text = "Hybrid";
						// 
			// labelHybridDesc
			// 
			this.labelHybridDesc.Location = new System.Drawing.Point(6, 3);
			this.labelHybridDesc.Name = "labelHybridDesc";
			this.labelHybridDesc.Size = new System.Drawing.Size(588, 32);
			this.labelHybridDesc.TabIndex = 150;
			this.labelHybridDesc.Text = "Hybrid: local numbered folders (0-99) with rclone sync to SFTP server for multi-clinic.";
			this.labelHybridDesc.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
			// 
			// labelHybridLocalPath
			// 
			this.labelHybridLocalPath.Location = new System.Drawing.Point(6, 40);
			this.labelHybridLocalPath.Name = "labelHybridLocalPath";
			this.labelHybridLocalPath.Size = new System.Drawing.Size(130, 18);
			this.labelHybridLocalPath.TabIndex = 151;
			this.labelHybridLocalPath.Text = "Local AtoZ Path";
			this.labelHybridLocalPath.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
			// 
			// textHybridLocalPath
			// 
			this.textHybridLocalPath.Location = new System.Drawing.Point(140, 39);
			this.textHybridLocalPath.Name = "textHybridLocalPath";
			this.textHybridLocalPath.Size = new System.Drawing.Size(370, 20);
			this.textHybridLocalPath.TabIndex = 152;
			// 
			// butHybridBrowseLocal
			// 
			this.butHybridBrowseLocal.Location = new System.Drawing.Point(516, 37);
			this.butHybridBrowseLocal.Name = "butHybridBrowseLocal";
			this.butHybridBrowseLocal.Size = new System.Drawing.Size(75, 23);
			this.butHybridBrowseLocal.TabIndex = 153;
			this.butHybridBrowseLocal.Text = "Browse";
			this.butHybridBrowseLocal.Click += new System.EventHandler(this.butHybridBrowseLocal_Click);
			// 
			// labelHybridSftpHost
			// 
			this.labelHybridSftpHost.Location = new System.Drawing.Point(6, 66);
			this.labelHybridSftpHost.Name = "labelHybridSftpHost";
			this.labelHybridSftpHost.Size = new System.Drawing.Size(130, 18);
			this.labelHybridSftpHost.TabIndex = 154;
			this.labelHybridSftpHost.Text = "SFTP Host";
			this.labelHybridSftpHost.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
			// 
			// textHybridSftpHost
			// 
			this.textHybridSftpHost.Location = new System.Drawing.Point(140, 65);
			this.textHybridSftpHost.Name = "textHybridSftpHost";
			this.textHybridSftpHost.Size = new System.Drawing.Size(370, 20);
			this.textHybridSftpHost.TabIndex = 155;
			// 
			// labelHybridSftpUser
			// 
			this.labelHybridSftpUser.Location = new System.Drawing.Point(6, 92);
			this.labelHybridSftpUser.Name = "labelHybridSftpUser";
			this.labelHybridSftpUser.Size = new System.Drawing.Size(130, 18);
			this.labelHybridSftpUser.TabIndex = 156;
			this.labelHybridSftpUser.Text = "SFTP Username";
			this.labelHybridSftpUser.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
			// 
			// textHybridSftpUser
			// 
			this.textHybridSftpUser.Location = new System.Drawing.Point(140, 91);
			this.textHybridSftpUser.Name = "textHybridSftpUser";
			this.textHybridSftpUser.Size = new System.Drawing.Size(370, 20);
			this.textHybridSftpUser.TabIndex = 157;
			// 
			// labelHybridSftpPass
			// 
			this.labelHybridSftpPass.Location = new System.Drawing.Point(6, 118);
			this.labelHybridSftpPass.Name = "labelHybridSftpPass";
			this.labelHybridSftpPass.Size = new System.Drawing.Size(130, 18);
			this.labelHybridSftpPass.TabIndex = 158;
			this.labelHybridSftpPass.Text = "SFTP Password";
			this.labelHybridSftpPass.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
			// 
			// textHybridSftpPass
			// 
			this.textHybridSftpPass.Location = new System.Drawing.Point(140, 117);
			this.textHybridSftpPass.Name = "textHybridSftpPass";
			this.textHybridSftpPass.Size = new System.Drawing.Size(370, 20);
			this.textHybridSftpPass.TabIndex = 159;
			this.textHybridSftpPass.UseSystemPasswordChar = true;
			// 
			// labelHybridRclonePath
			// 
			this.labelHybridRclonePath.Location = new System.Drawing.Point(6, 166);
			this.labelHybridRclonePath.Name = "labelHybridRclonePath";
			this.labelHybridRclonePath.Size = new System.Drawing.Size(130, 18);
			this.labelHybridRclonePath.TabIndex = 160;
			this.labelHybridRclonePath.Text = "rclone Path";
			this.labelHybridRclonePath.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
			// 
			// textHybridRclonePath
			// 
			this.textHybridRclonePath.Location = new System.Drawing.Point(140, 165);
			this.textHybridRclonePath.Name = "textHybridRclonePath";
			this.textHybridRclonePath.Size = new System.Drawing.Size(370, 20);
			this.textHybridRclonePath.TabIndex = 161;
			// 
			// labelHybridServerPath
			// 
			this.labelHybridServerPath.Location = new System.Drawing.Point(6, 192);
			this.labelHybridServerPath.Name = "labelHybridServerPath";
			this.labelHybridServerPath.Size = new System.Drawing.Size(130, 18);
			this.labelHybridServerPath.TabIndex = 162;
			this.labelHybridServerPath.Text = "Server Media Path";
			this.labelHybridServerPath.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
			// 
			// textHybridServerPath
			// 
			this.textHybridServerPath.Location = new System.Drawing.Point(140, 191);
			this.textHybridServerPath.Name = "textHybridServerPath";
			this.textHybridServerPath.Size = new System.Drawing.Size(370, 20);
			this.textHybridServerPath.TabIndex = 163;
			// 
			// butHybridMigrate
			// 
			this.butHybridMigrate.Location = new System.Drawing.Point(200, 217);
			this.butHybridMigrate.Name = "butHybridMigrate";
			this.butHybridMigrate.Size = new System.Drawing.Size(160, 26);
			this.butHybridMigrate.TabIndex = 173;
			this.butHybridMigrate.Text = "Migrate from A-Z";
			this.butHybridMigrate.Click += new System.EventHandler(this.butHybridMigrate_Click);
			// 
			// butHybridTestConnection
			// 
			this.butHybridTestConnection.Location = new System.Drawing.Point(370, 217);
			this.butHybridTestConnection.Name = "butHybridTestConnection";
			this.butHybridTestConnection.Size = new System.Drawing.Size(170, 26);
			this.butHybridTestConnection.TabIndex = 164;
			this.butHybridTestConnection.Text = "Test rclone && Setup";
			this.butHybridTestConnection.Click += new System.EventHandler(this.butHybridTestConnection_Click);
			// 
			// radioHybrid
			// 
			this.radioHybrid.Location = new System.Drawing.Point(9, 95);
			this.radioHybrid.Name = "radioHybrid";
			this.radioHybrid.Size = new System.Drawing.Size(569, 18);
			this.radioHybrid.TabIndex = 104;
			this.radioHybrid.Text = "Hybrid: local numbered folders + rclone sync to SFTP server (for multi-clinic)";
			this.radioHybrid.UseVisualStyleBackColor = true;
			this.radioHybrid.Click += new System.EventHandler(this.radioHybrid_Click);
			// 
			// label11
			// 
			this.label11.Location = new System.Drawing.Point(66, 25);
			this.label11.Name = "label11";
			this.label11.Size = new System.Drawing.Size(465, 29);
			this.label11.TabIndex = 137;
			this.label11.Text = "Any subfolders defined in the AtoZ Path must be separated with the forward slash " +
    "\" / \" character.";
			this.label11.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
			// 
			// butSftpClear
			// 
			this.butSftpClear.Location = new System.Drawing.Point(384, 135);
			this.butSftpClear.Name = "butSftpClear";
			this.butSftpClear.Size = new System.Drawing.Size(56, 24);
			this.butSftpClear.TabIndex = 97;
			this.butSftpClear.Text = "Clear";
			this.butSftpClear.Click += new System.EventHandler(this.butSftpClear_Click);
			// 
			// label10
			// 
			this.label10.Location = new System.Drawing.Point(6, 3);
			this.label10.Name = "label10";
			this.label10.Size = new System.Drawing.Size(525, 15);
			this.label10.TabIndex = 136;
			this.label10.Text = "Store images on a server via SSH File Transfer Protocol (SFTP). ";
			this.label10.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
			// 
			// label9
			// 
			this.label9.Location = new System.Drawing.Point(115, 138);
			this.label9.Name = "label9";
			this.label9.Size = new System.Drawing.Size(129, 19);
			this.label9.TabIndex = 135;
			this.label9.Text = "Password";
			this.label9.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// textSftpPassword
			// 
			this.textSftpPassword.Location = new System.Drawing.Point(246, 137);
			this.textSftpPassword.Name = "textSftpPassword";
			this.textSftpPassword.Size = new System.Drawing.Size(134, 20);
			this.textSftpPassword.TabIndex = 134;
			// 
			// label8
			// 
			this.label8.Location = new System.Drawing.Point(115, 112);
			this.label8.Name = "label8";
			this.label8.Size = new System.Drawing.Size(129, 19);
			this.label8.TabIndex = 133;
			this.label8.Text = "Username";
			this.label8.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// textSftpUsername
			// 
			this.textSftpUsername.Location = new System.Drawing.Point(246, 111);
			this.textSftpUsername.Name = "textSftpUsername";
			this.textSftpUsername.Size = new System.Drawing.Size(134, 20);
			this.textSftpUsername.TabIndex = 132;
			// 
			// label6
			// 
			this.label6.Location = new System.Drawing.Point(115, 60);
			this.label6.Name = "label6";
			this.label6.Size = new System.Drawing.Size(129, 19);
			this.label6.TabIndex = 131;
			this.label6.Text = "AtoZ Path";
			this.label6.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// textSftpAtoZ
			// 
			this.textSftpAtoZ.Location = new System.Drawing.Point(246, 59);
			this.textSftpAtoZ.Name = "textSftpAtoZ";
			this.textSftpAtoZ.Size = new System.Drawing.Size(134, 20);
			this.textSftpAtoZ.TabIndex = 128;
			// 
			// label7
			// 
			this.label7.Location = new System.Drawing.Point(115, 86);
			this.label7.Name = "label7";
			this.label7.Size = new System.Drawing.Size(129, 19);
			this.label7.TabIndex = 129;
			this.label7.Text = "Hostname";
			this.label7.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// textSftpHostname
			// 
			this.textSftpHostname.Location = new System.Drawing.Point(246, 85);
			this.textSftpHostname.Name = "textSftpHostname";
			this.textSftpHostname.Size = new System.Drawing.Size(134, 20);
			this.textSftpHostname.TabIndex = 130;
			// 
			// radioDatabaseStorage
			// 
			this.radioDatabaseStorage.Location = new System.Drawing.Point(9, 38);
			this.radioDatabaseStorage.Name = "radioDatabaseStorage";
			this.radioDatabaseStorage.Size = new System.Drawing.Size(537, 18);
			this.radioDatabaseStorage.TabIndex = 101;
			this.radioDatabaseStorage.Text = "Store images directly in database.  No AtoZ folder. (Some features will be unavai" +
    "lable)";
			this.radioDatabaseStorage.UseVisualStyleBackColor = true;
			this.radioDatabaseStorage.Click += new System.EventHandler(this.radioDatabaseStorage_Click);
			// 
			// radioUseFolder
			// 
			this.radioUseFolder.Checked = true;
			this.radioUseFolder.Location = new System.Drawing.Point(9, 19);
			this.radioUseFolder.Name = "radioUseFolder";
			this.radioUseFolder.Size = new System.Drawing.Size(333, 18);
			this.radioUseFolder.TabIndex = 0;
			this.radioUseFolder.TabStop = true;
			this.radioUseFolder.Text = "Store images and documents on a local or network folder.";
			this.radioUseFolder.UseVisualStyleBackColor = true;
			this.radioUseFolder.Click += new System.EventHandler(this.radioUseFolder_Click);
			// 
			// FormPath
			// 
			this.AcceptButton = this.butOK;
			this.ClientSize = new System.Drawing.Size(675, 645);
			this.Controls.Add(this.groupbox1);
			this.Controls.Add(this.butBrowseLetter);
			this.Controls.Add(this.butBrowseExport);
			this.Controls.Add(this.label3);
			this.Controls.Add(this.textLetterMergePath);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.textExportPath);
			this.Controls.Add(this.butOK);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "FormPath";
			this.Text = "Edit Paths";
			this.Closing += new System.ComponentModel.CancelEventHandler(this.FormPath_Closing);
			this.Load += new System.EventHandler(this.FormPath_Load);
			this.groupbox1.ResumeLayout(false);
			this.tabControlDataStorageType.ResumeLayout(false);
			this.tabAtoZ.ResumeLayout(false);
			this.tabAtoZ.PerformLayout();
			this.tabInDatabase.ResumeLayout(false);
			this.tabDropbox.ResumeLayout(false);
			this.tabDropbox.PerformLayout();
			this.tabSftp.ResumeLayout(false);
			this.tabSftp.PerformLayout();
			// 
			// labelHybridKeyFile
			// 
			this.labelHybridKeyFile.Location = new System.Drawing.Point(6, 144);
			this.labelHybridKeyFile.Name = "labelHybridKeyFile";
			this.labelHybridKeyFile.Size = new System.Drawing.Size(130, 18);
			this.labelHybridKeyFile.TabIndex = 170;
			this.labelHybridKeyFile.Text = "SSH Key File (optional)";
			this.labelHybridKeyFile.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
			// 
			// textHybridKeyFile
			// 
			this.textHybridKeyFile.Location = new System.Drawing.Point(140, 143);
			this.textHybridKeyFile.Name = "textHybridKeyFile";
			this.textHybridKeyFile.Size = new System.Drawing.Size(370, 20);
			this.textHybridKeyFile.TabIndex = 171;
			// 
			// butHybridBrowseKey
			// 
			this.butHybridBrowseKey.Location = new System.Drawing.Point(516, 141);
			this.butHybridBrowseKey.Name = "butHybridBrowseKey";
			this.butHybridBrowseKey.Size = new System.Drawing.Size(75, 23);
			this.butHybridBrowseKey.TabIndex = 172;
			this.butHybridBrowseKey.Text = "Browse";
			this.butHybridBrowseKey.Click += new System.EventHandler(this.butHybridBrowseKey_Click);
			// 
			this.tabHybrid.ResumeLayout(false);
			this.tabHybrid.PerformLayout();
			this.ResumeLayout(false);
			this.PerformLayout();

		}
		#endregion

		private Helianz.UI.Button butOK;
		private System.Windows.Forms.TextBox textExportPath;
		private System.Windows.Forms.TextBox textDocPath;
		private Helianz.UI.Button butBrowseExport;
		private Helianz.UI.Button butBrowseDoc;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Label labelPathSameForAll;
		private System.Windows.Forms.Label label3;
		private Helianz.UI.Button butBrowseLetter;
		private System.Windows.Forms.TextBox textLetterMergePath;
		private Helianz.UI.CheckBox checkMultiplePaths;
		private RadioButton radioDatabaseStorage;
		private RadioButton radioUseFolder;
		private Label labelLocalPath;
		private TextBox textLocalPath;
		private Helianz.UI.Button butBrowseLocal;
		private Helianz.UI.Button butBrowseServer;
		private Label labelServerPath;
		private TextBox textServerPath;
		private Helianz.UI.GroupBox groupbox1;
		private Helianz.UI.TabControl tabControlDataStorageType;
		private Helianz.UI.TabPage tabAtoZ;
		private Helianz.UI.TabPage tabInDatabase;
		private Helianz.UI.TabPage tabDropbox;
		private Label label2;
		private Label label4;
		private Label label5;
		private TextBox textAtoZPath;
		private UI.Button butAuthorize;
		private Label labelWebhostURL;
		private TextBox textAccessToken;
		private RadioButton radioDropboxStorage;
		private RadioButton radioSftp;
		private Helianz.UI.TabPage tabSftp;
		private Label label6;
		private TextBox textSftpAtoZ;
		private Label label7;
		private TextBox textSftpHostname;
		private Label label9;
		private TextBox textSftpPassword;
		private Label label8;
		private TextBox textSftpUsername;
		private Label label10;
		private UI.Button butSftpClear;
		private Label label11;
		private Label label12;
		private FolderBrowserDialog folderBrowserDialog;
		private RadioButton radioHybrid;
		private Helianz.UI.TabPage tabHybrid;
		private Label labelHybridDesc;
		private Label labelHybridLocalPath;
		private TextBox textHybridLocalPath;
		private Helianz.UI.Button butHybridBrowseLocal;
		private Label labelHybridSftpHost;
		private TextBox textHybridSftpHost;
		private Label labelHybridSftpUser;
		private TextBox textHybridSftpUser;
		private Label labelHybridSftpPass;
		private TextBox textHybridSftpPass;
		private Label labelHybridRclonePath;
		private TextBox textHybridRclonePath;
		private Label labelHybridServerPath;
		private TextBox textHybridServerPath;
		private Helianz.UI.Button butHybridTestConnection;
		private Label labelHybridKeyFile;
		private TextBox textHybridKeyFile;
		private Helianz.UI.Button butHybridBrowseKey;
		private Helianz.UI.Button butHybridMigrate;
	}
}
