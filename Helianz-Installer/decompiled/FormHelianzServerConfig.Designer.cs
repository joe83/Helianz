namespace FreeDentalInstaller {
	partial class FormHelianzServerConfig {
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.IContainer components = null;

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		/// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
		protected override void Dispose(bool disposing) {
			if(disposing && (components != null)) {
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows Form Designer generated code

		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent() {
			this.grpRootCurrent = new System.Windows.Forms.GroupBox();
			this.labelRootPassword = new System.Windows.Forms.Label();
			this.textRootPassword = new System.Windows.Forms.TextBox();
			this.labelRootUser = new System.Windows.Forms.Label();
			this.textRootUser = new System.Windows.Forms.TextBox();
			this.chkChangeRootPassword = new System.Windows.Forms.CheckBox();
			this.grpRootNew = new System.Windows.Forms.GroupBox();
			this.chkKeepBlankRoot = new System.Windows.Forms.CheckBox();
			this.labelNewRootVerifyPassword = new System.Windows.Forms.Label();
			this.textNewRootVerifyPassword = new System.Windows.Forms.TextBox();
			this.labelNewRootPassword = new System.Windows.Forms.Label();
			this.textNewRootPassword = new System.Windows.Forms.TextBox();
			this.labelRootStatus = new System.Windows.Forms.Label();
			this.grpDatabase = new System.Windows.Forms.GroupBox();
			this.labelLowPrivPassword = new System.Windows.Forms.Label();
			this.textLowPrivPassword = new System.Windows.Forms.TextBox();
			this.labelLowPrivUser = new System.Windows.Forms.Label();
			this.textLowPrivUser = new System.Windows.Forms.TextBox();
			this.labelAppPasswordVerify = new System.Windows.Forms.Label();
			this.textAppPasswordVerify = new System.Windows.Forms.TextBox();
			this.labelAppPassword = new System.Windows.Forms.Label();
			this.textAppPassword = new System.Windows.Forms.TextBox();
			this.labelAppUser = new System.Windows.Forms.Label();
			this.textAppUser = new System.Windows.Forms.TextBox();
			this.labelDatabase = new System.Windows.Forms.Label();
			this.textDatabase = new System.Windows.Forms.TextBox();
			this.labelPort = new System.Windows.Forms.Label();
			this.textPort = new System.Windows.Forms.TextBox();
			this.labelHost = new System.Windows.Forms.Label();
			this.textHost = new System.Windows.Forms.TextBox();
			this.grpServer = new System.Windows.Forms.GroupBox();
			this.butBrowse = new System.Windows.Forms.Button();
			this.textHelianzServerPath = new System.Windows.Forms.TextBox();
			this.labelHelianzServerPath = new System.Windows.Forms.Label();
			this.textServerPort = new System.Windows.Forms.TextBox();
			this.labelServerPort = new System.Windows.Forms.Label();
			this.butTestConnection = new System.Windows.Forms.Button();
			this.butOK = new System.Windows.Forms.Button();
			this.butCancel = new System.Windows.Forms.Button();
			this.grpRootCurrent.SuspendLayout();
			this.grpRootNew.SuspendLayout();
			this.grpDatabase.SuspendLayout();
			this.grpServer.SuspendLayout();
			this.SuspendLayout();
			//
			// labelRootStatus
			//
			this.labelRootStatus.Location = new System.Drawing.Point(16, 4);
			this.labelRootStatus.Name = "labelRootStatus";
			this.labelRootStatus.Size = new System.Drawing.Size(621, 22);
			this.labelRootStatus.TabIndex = 0;
			this.labelRootStatus.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			//
			// grpRootCurrent
			//
			this.grpRootCurrent.Controls.Add(this.chkChangeRootPassword);
			this.grpRootCurrent.Controls.Add(this.labelRootPassword);
			this.grpRootCurrent.Controls.Add(this.textRootPassword);
			this.grpRootCurrent.Controls.Add(this.labelRootUser);
			this.grpRootCurrent.Controls.Add(this.textRootUser);
			this.grpRootCurrent.Location = new System.Drawing.Point(16, 28);
			this.grpRootCurrent.Name = "grpRootCurrent";
			this.grpRootCurrent.Padding = new System.Windows.Forms.Padding(4, 4, 4, 4);
			this.grpRootCurrent.Size = new System.Drawing.Size(621, 95);
			this.grpRootCurrent.TabIndex = 1;
			this.grpRootCurrent.TabStop = false;
			this.grpRootCurrent.Text = "MySQL Root Password";
			//
			// labelRootUser
			//
			this.labelRootUser.Location = new System.Drawing.Point(24, 23);
			this.labelRootUser.Name = "labelRootUser";
			this.labelRootUser.Size = new System.Drawing.Size(120, 25);
			this.labelRootUser.TabIndex = 1;
			this.labelRootUser.Text = "Root User:";
			this.labelRootUser.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textRootUser
			//
			this.textRootUser.Location = new System.Drawing.Point(151, 20);
			this.textRootUser.Name = "textRootUser";
			this.textRootUser.Size = new System.Drawing.Size(461, 22);
			this.textRootUser.TabIndex = 2;
			this.textRootUser.Text = "root";
			//
			// labelRootPassword
			//
			this.labelRootPassword.Location = new System.Drawing.Point(24, 47);
			this.labelRootPassword.Name = "labelRootPassword";
			this.labelRootPassword.Size = new System.Drawing.Size(120, 25);
			this.labelRootPassword.TabIndex = 3;
			this.labelRootPassword.Text = "Root Password:";
			this.labelRootPassword.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textRootPassword
			//
			this.textRootPassword.Location = new System.Drawing.Point(151, 44);
			this.textRootPassword.Name = "textRootPassword";
			this.textRootPassword.Size = new System.Drawing.Size(461, 22);
			this.textRootPassword.TabIndex = 4;
			this.textRootPassword.UseSystemPasswordChar = true;
			//
			// chkChangeRootPassword
			//
			this.chkChangeRootPassword.Location = new System.Drawing.Point(24, 70);
			this.chkChangeRootPassword.Name = "chkChangeRootPassword";
			this.chkChangeRootPassword.Size = new System.Drawing.Size(588, 20);
			this.chkChangeRootPassword.TabIndex = 5;
			this.chkChangeRootPassword.Text = "Change root password to a new value";
			this.chkChangeRootPassword.UseVisualStyleBackColor = true;
			this.chkChangeRootPassword.CheckedChanged += new System.EventHandler(this.chkChangeRootPassword_CheckedChanged);
			//
			// grpRootNew
			//
			this.grpRootNew.Controls.Add(this.chkKeepBlankRoot);
			this.grpRootNew.Controls.Add(this.labelNewRootVerifyPassword);
			this.grpRootNew.Controls.Add(this.textNewRootVerifyPassword);
			this.grpRootNew.Controls.Add(this.labelNewRootPassword);
			this.grpRootNew.Controls.Add(this.textNewRootPassword);
			this.grpRootNew.Location = new System.Drawing.Point(16, 28);
			this.grpRootNew.Name = "grpRootNew";
			this.grpRootNew.Padding = new System.Windows.Forms.Padding(4, 4, 4, 4);
			this.grpRootNew.Size = new System.Drawing.Size(621, 95);
			this.grpRootNew.TabIndex = 2;
			this.grpRootNew.TabStop = false;
			this.grpRootNew.Text = "Set Root Password";
			//
			// labelNewRootPassword
			//
			this.labelNewRootPassword.Location = new System.Drawing.Point(24, 23);
			this.labelNewRootPassword.Name = "labelNewRootPassword";
			this.labelNewRootPassword.Size = new System.Drawing.Size(120, 25);
			this.labelNewRootPassword.TabIndex = 1;
			this.labelNewRootPassword.Text = "New Password:";
			this.labelNewRootPassword.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textNewRootPassword
			//
			this.textNewRootPassword.Location = new System.Drawing.Point(151, 20);
			this.textNewRootPassword.Name = "textNewRootPassword";
			this.textNewRootPassword.Size = new System.Drawing.Size(461, 22);
			this.textNewRootPassword.TabIndex = 2;
			this.textNewRootPassword.UseSystemPasswordChar = true;
			//
			// labelNewRootVerifyPassword
			//
			this.labelNewRootVerifyPassword.Location = new System.Drawing.Point(24, 47);
			this.labelNewRootVerifyPassword.Name = "labelNewRootVerifyPassword";
			this.labelNewRootVerifyPassword.Size = new System.Drawing.Size(120, 25);
			this.labelNewRootVerifyPassword.TabIndex = 3;
			this.labelNewRootVerifyPassword.Text = "Verify:";
			this.labelNewRootVerifyPassword.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textNewRootVerifyPassword
			//
			this.textNewRootVerifyPassword.Location = new System.Drawing.Point(151, 44);
			this.textNewRootVerifyPassword.Name = "textNewRootVerifyPassword";
			this.textNewRootVerifyPassword.Size = new System.Drawing.Size(461, 22);
			this.textNewRootVerifyPassword.TabIndex = 4;
			this.textNewRootVerifyPassword.UseSystemPasswordChar = true;
			//
			// chkKeepBlankRoot
			//
			this.chkKeepBlankRoot.Location = new System.Drawing.Point(24, 70);
			this.chkKeepBlankRoot.Name = "chkKeepBlankRoot";
			this.chkKeepBlankRoot.Size = new System.Drawing.Size(588, 20);
			this.chkKeepBlankRoot.TabIndex = 5;
			this.chkKeepBlankRoot.Text = "Keep root password blank (not recommended)";
			this.chkKeepBlankRoot.UseVisualStyleBackColor = true;
			//
			// grpDatabase
			//
			this.grpDatabase.Controls.Add(this.labelLowPrivPassword);
			this.grpDatabase.Controls.Add(this.textLowPrivPassword);
			this.grpDatabase.Controls.Add(this.labelLowPrivUser);
			this.grpDatabase.Controls.Add(this.textLowPrivUser);
			this.grpDatabase.Controls.Add(this.labelAppPasswordVerify);
			this.grpDatabase.Controls.Add(this.textAppPasswordVerify);
			this.grpDatabase.Controls.Add(this.labelAppPassword);
			this.grpDatabase.Controls.Add(this.textAppPassword);
			this.grpDatabase.Controls.Add(this.labelAppUser);
			this.grpDatabase.Controls.Add(this.textAppUser);
			this.grpDatabase.Controls.Add(this.labelDatabase);
			this.grpDatabase.Controls.Add(this.textDatabase);
			this.grpDatabase.Controls.Add(this.labelPort);
			this.grpDatabase.Controls.Add(this.textPort);
			this.grpDatabase.Controls.Add(this.labelHost);
			this.grpDatabase.Controls.Add(this.textHost);
			this.grpDatabase.Location = new System.Drawing.Point(16, 130);
			this.grpDatabase.Name = "grpDatabase";
			this.grpDatabase.Padding = new System.Windows.Forms.Padding(4, 4, 4, 4);
			this.grpDatabase.Size = new System.Drawing.Size(621, 193);
			this.grpDatabase.TabIndex = 3;
			this.grpDatabase.TabStop = false;
			this.grpDatabase.Text = "Database & Application User";
			//
			// labelLowPrivPassword
			//
			this.labelLowPrivPassword.Location = new System.Drawing.Point(307, 162);
			this.labelLowPrivPassword.Name = "labelLowPrivPassword";
			this.labelLowPrivPassword.Size = new System.Drawing.Size(73, 25);
			this.labelLowPrivPassword.TabIndex = 13;
			this.labelLowPrivPassword.Text = "Pass:";
			this.labelLowPrivPassword.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textLowPrivPassword
			//
			this.textLowPrivPassword.Location = new System.Drawing.Point(385, 159);
			this.textLowPrivPassword.Name = "textLowPrivPassword";
			this.textLowPrivPassword.Size = new System.Drawing.Size(176, 22);
			this.textLowPrivPassword.TabIndex = 12;
			this.textLowPrivPassword.UseSystemPasswordChar = true;
			//
			// labelLowPrivUser
			//
			this.labelLowPrivUser.Location = new System.Drawing.Point(24, 162);
			this.labelLowPrivUser.Name = "labelLowPrivUser";
			this.labelLowPrivUser.Size = new System.Drawing.Size(73, 25);
			this.labelLowPrivUser.TabIndex = 11;
			this.labelLowPrivUser.Text = "Low-Priv:";
			this.labelLowPrivUser.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textLowPrivUser
			//
			this.textLowPrivUser.Location = new System.Drawing.Point(103, 159);
			this.textLowPrivUser.Name = "textLowPrivUser";
			this.textLowPrivUser.Size = new System.Drawing.Size(192, 22);
			this.textLowPrivUser.TabIndex = 10;
			//
			// labelAppPasswordVerify
			//
			this.labelAppPasswordVerify.Location = new System.Drawing.Point(24, 135);
			this.labelAppPasswordVerify.Name = "labelAppPasswordVerify";
			this.labelAppPasswordVerify.Size = new System.Drawing.Size(73, 25);
			this.labelAppPasswordVerify.TabIndex = 9;
			this.labelAppPasswordVerify.Text = "Verify:";
			this.labelAppPasswordVerify.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textAppPasswordVerify
			//
			this.textAppPasswordVerify.Location = new System.Drawing.Point(103, 132);
			this.textAppPasswordVerify.Name = "textAppPasswordVerify";
			this.textAppPasswordVerify.Size = new System.Drawing.Size(459, 22);
			this.textAppPasswordVerify.TabIndex = 8;
			this.textAppPasswordVerify.UseSystemPasswordChar = true;
			//
			// labelAppPassword
			//
			this.labelAppPassword.Location = new System.Drawing.Point(24, 108);
			this.labelAppPassword.Name = "labelAppPassword";
			this.labelAppPassword.Size = new System.Drawing.Size(73, 25);
			this.labelAppPassword.TabIndex = 7;
			this.labelAppPassword.Text = "Password:";
			this.labelAppPassword.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textAppPassword
			//
			this.textAppPassword.Location = new System.Drawing.Point(103, 105);
			this.textAppPassword.Name = "textAppPassword";
			this.textAppPassword.Size = new System.Drawing.Size(459, 22);
			this.textAppPassword.TabIndex = 6;
			this.textAppPassword.UseSystemPasswordChar = true;
			this.textAppPassword.KeyUp += new System.Windows.Forms.KeyEventHandler(this.textAppPassword_KeyUp);
			//
			// labelAppUser
			//
			this.labelAppUser.Location = new System.Drawing.Point(24, 81);
			this.labelAppUser.Name = "labelAppUser";
			this.labelAppUser.Size = new System.Drawing.Size(73, 25);
			this.labelAppUser.TabIndex = 5;
			this.labelAppUser.Text = "DB User:";
			this.labelAppUser.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textAppUser
			//
			this.textAppUser.Location = new System.Drawing.Point(103, 78);
			this.textAppUser.Name = "textAppUser";
			this.textAppUser.Size = new System.Drawing.Size(459, 22);
			this.textAppUser.TabIndex = 4;
			this.textAppUser.Text = "oduser";
			//
			// labelDatabase
			//
			this.labelDatabase.Location = new System.Drawing.Point(24, 54);
			this.labelDatabase.Name = "labelDatabase";
			this.labelDatabase.Size = new System.Drawing.Size(73, 25);
			this.labelDatabase.TabIndex = 3;
			this.labelDatabase.Text = "Database:";
			this.labelDatabase.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textDatabase
			//
			this.textDatabase.Location = new System.Drawing.Point(103, 50);
			this.textDatabase.Name = "textDatabase";
			this.textDatabase.Size = new System.Drawing.Size(459, 22);
			this.textDatabase.TabIndex = 2;
			this.textDatabase.Text = "helianz";
			//
			// labelPort
			//
			this.labelPort.Location = new System.Drawing.Point(349, 27);
			this.labelPort.Name = "labelPort";
			this.labelPort.Size = new System.Drawing.Size(45, 25);
			this.labelPort.TabIndex = 1;
			this.labelPort.Text = "Port:";
			this.labelPort.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textPort
			//
			this.textPort.Location = new System.Drawing.Point(400, 23);
			this.textPort.Name = "textPort";
			this.textPort.Size = new System.Drawing.Size(105, 22);
			this.textPort.TabIndex = 1;
			this.textPort.Text = "3306";
			//
			// labelHost
			//
			this.labelHost.Location = new System.Drawing.Point(24, 27);
			this.labelHost.Name = "labelHost";
			this.labelHost.Size = new System.Drawing.Size(73, 25);
			this.labelHost.TabIndex = 0;
			this.labelHost.Text = "Host:";
			this.labelHost.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textHost
			//
			this.textHost.Location = new System.Drawing.Point(103, 23);
			this.textHost.Name = "textHost";
			this.textHost.Size = new System.Drawing.Size(239, 22);
			this.textHost.TabIndex = 0;
			this.textHost.Text = "localhost";
			//
			// grpServer
			//
			this.grpServer.Controls.Add(this.butBrowse);
			this.grpServer.Controls.Add(this.textHelianzServerPath);
			this.grpServer.Controls.Add(this.labelHelianzServerPath);
			this.grpServer.Controls.Add(this.textServerPort);
			this.grpServer.Controls.Add(this.labelServerPort);
			this.grpServer.Location = new System.Drawing.Point(16, 331);
			this.grpServer.Name = "grpServer";
			this.grpServer.Padding = new System.Windows.Forms.Padding(4, 4, 4, 4);
			this.grpServer.Size = new System.Drawing.Size(621, 68);
			this.grpServer.TabIndex = 4;
			this.grpServer.TabStop = false;
			this.grpServer.Text = "HelianzServer";
			//
			// labelServerPort
			//
			this.labelServerPort.Location = new System.Drawing.Point(8, 36);
			this.labelServerPort.Name = "labelServerPort";
			this.labelServerPort.Size = new System.Drawing.Size(93, 25);
			this.labelServerPort.TabIndex = 0;
			this.labelServerPort.Text = "Server Port:";
			this.labelServerPort.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textServerPort
			//
			this.textServerPort.Location = new System.Drawing.Point(118, 37);
			this.textServerPort.Name = "textServerPort";
			this.textServerPort.Size = new System.Drawing.Size(92, 22);
			this.textServerPort.TabIndex = 1;
			this.textServerPort.Text = "9390";
			//
			// labelHelianzServerPath
			//
			this.labelHelianzServerPath.Location = new System.Drawing.Point(231, 37);
			this.labelHelianzServerPath.Name = "labelHelianzServerPath";
			this.labelHelianzServerPath.Size = new System.Drawing.Size(67, 25);
			this.labelHelianzServerPath.TabIndex = 2;
			this.labelHelianzServerPath.Text = "Path:";
			this.labelHelianzServerPath.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textHelianzServerPath
			//
			this.textHelianzServerPath.Location = new System.Drawing.Point(304, 37);
			this.textHelianzServerPath.Name = "textHelianzServerPath";
			this.textHelianzServerPath.Size = new System.Drawing.Size(236, 22);
			this.textHelianzServerPath.TabIndex = 3;
			//
			// butBrowse
			//
			this.butBrowse.Location = new System.Drawing.Point(548, 37);
			this.butBrowse.Name = "butBrowse";
			this.butBrowse.Size = new System.Drawing.Size(65, 25);
			this.butBrowse.TabIndex = 4;
			this.butBrowse.Text = "Browse";
			this.butBrowse.Click += new System.EventHandler(this.butBrowse_Click);
			//
			// butTestConnection
			//
			this.butTestConnection.Location = new System.Drawing.Point(13, 409);
			this.butTestConnection.Name = "butTestConnection";
			this.butTestConnection.Size = new System.Drawing.Size(160, 32);
			this.butTestConnection.TabIndex = 5;
			this.butTestConnection.Text = "Test Connection";
			this.butTestConnection.Click += new System.EventHandler(this.butTestConnection_Click);
			//
			// butOK
			//
			this.butOK.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.butOK.Location = new System.Drawing.Point(340, 409);
			this.butOK.Name = "butOK";
			this.butOK.Size = new System.Drawing.Size(107, 32);
			this.butOK.TabIndex = 6;
			this.butOK.Text = "OK";
			this.butOK.UseVisualStyleBackColor = true;
			this.butOK.Click += new System.EventHandler(this.butOK_Click);
			//
			// butCancel
			//
			this.butCancel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.butCancel.Location = new System.Drawing.Point(460, 409);
			this.butCancel.Name = "butCancel";
			this.butCancel.Size = new System.Drawing.Size(107, 32);
			this.butCancel.TabIndex = 7;
			this.butCancel.Text = "Cancel";
			this.butCancel.UseVisualStyleBackColor = true;
			this.butCancel.Click += new System.EventHandler(this.butCancel_Click);
			//
			// FormHelianzServerConfig
			//
			this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(653, 458);
			this.Controls.Add(this.labelRootStatus);
			this.Controls.Add(this.butCancel);
			this.Controls.Add(this.butOK);
			this.Controls.Add(this.butTestConnection);
			this.Controls.Add(this.grpServer);
			this.Controls.Add(this.grpDatabase);
			this.Controls.Add(this.grpRootNew);
			this.Controls.Add(this.grpRootCurrent);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "FormHelianzServerConfig";
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
			this.Text = "HelianzServer Configuration";
			this.Load += new System.EventHandler(this.FormHelianzServerConfig_Load);
			this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.FormHelianzServerConfig_FormClosing);
			this.grpRootCurrent.ResumeLayout(false);
			this.grpRootCurrent.PerformLayout();
			this.grpRootNew.ResumeLayout(false);
			this.grpRootNew.PerformLayout();
			this.grpDatabase.ResumeLayout(false);
			this.grpDatabase.PerformLayout();
			this.grpServer.ResumeLayout(false);
			this.grpServer.PerformLayout();
			this.ResumeLayout(false);

		}

		#endregion

		private System.Windows.Forms.GroupBox grpRootCurrent;
		private System.Windows.Forms.GroupBox grpRootNew;
		private System.Windows.Forms.Panel grpRootNewContent;
		private System.Windows.Forms.Label labelRootStatus;
		private System.Windows.Forms.CheckBox chkChangeRootPassword;
		private System.Windows.Forms.CheckBox chkKeepBlankRoot;
		private System.Windows.Forms.Label labelNewRootPassword;
		private System.Windows.Forms.TextBox textNewRootPassword;
		private System.Windows.Forms.Label labelNewRootVerifyPassword;
		private System.Windows.Forms.TextBox textNewRootVerifyPassword;
		private System.Windows.Forms.GroupBox grpDatabase;
		private System.Windows.Forms.GroupBox grpServer;
		private System.Windows.Forms.Label labelRootUser;
		private System.Windows.Forms.TextBox textRootUser;
		private System.Windows.Forms.Label labelRootPassword;
		private System.Windows.Forms.TextBox textRootPassword;
		private System.Windows.Forms.Label labelHost;
		private System.Windows.Forms.TextBox textHost;
		private System.Windows.Forms.Label labelPort;
		private System.Windows.Forms.TextBox textPort;
		private System.Windows.Forms.Label labelDatabase;
		private System.Windows.Forms.TextBox textDatabase;
		private System.Windows.Forms.Label labelAppUser;
		private System.Windows.Forms.TextBox textAppUser;
		private System.Windows.Forms.Label labelAppPassword;
		private System.Windows.Forms.TextBox textAppPassword;
		private System.Windows.Forms.Label labelAppPasswordVerify;
		private System.Windows.Forms.TextBox textAppPasswordVerify;
		private System.Windows.Forms.Label labelLowPrivUser;
		private System.Windows.Forms.TextBox textLowPrivUser;
		private System.Windows.Forms.Label labelLowPrivPassword;
		private System.Windows.Forms.TextBox textLowPrivPassword;
		private System.Windows.Forms.Label labelServerPort;
		private System.Windows.Forms.TextBox textServerPort;
		private System.Windows.Forms.Label labelHelianzServerPath;
		private System.Windows.Forms.TextBox textHelianzServerPath;
		private System.Windows.Forms.Button butBrowse;
		private System.Windows.Forms.Button butTestConnection;
		private System.Windows.Forms.Button butOK;
		private System.Windows.Forms.Button butCancel;
	}
}
