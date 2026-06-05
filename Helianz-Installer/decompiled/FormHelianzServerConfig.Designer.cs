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
			this.grpRoot = new System.Windows.Forms.GroupBox();
			this.labelRootPassword = new System.Windows.Forms.Label();
			this.textRootPassword = new System.Windows.Forms.TextBox();
			this.labelRootUser = new System.Windows.Forms.Label();
			this.textRootUser = new System.Windows.Forms.TextBox();
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
			this.grpRoot.SuspendLayout();
			this.grpDatabase.SuspendLayout();
			this.grpServer.SuspendLayout();
			this.SuspendLayout();
			//
			// grpRoot
			//
			this.grpRoot.Controls.Add(this.labelRootPassword);
			this.grpRoot.Controls.Add(this.textRootPassword);
			this.grpRoot.Controls.Add(this.labelRootUser);
			this.grpRoot.Controls.Add(this.textRootUser);
			this.grpRoot.Location = new System.Drawing.Point(12, 8);
			this.grpRoot.Name = "grpRoot";
			this.grpRoot.Size = new System.Drawing.Size(466, 55);
			this.grpRoot.TabIndex = 0;
			this.grpRoot.TabStop = false;
			this.grpRoot.Text = "MySQL Root Connection";
			//
			// labelRootPassword
			//
			this.labelRootPassword.Location = new System.Drawing.Point(18, 38);
			this.labelRootPassword.Name = "labelRootPassword";
			this.labelRootPassword.Size = new System.Drawing.Size(90, 20);
			this.labelRootPassword.TabIndex = 3;
			this.labelRootPassword.Text = "Root Password:";
			this.labelRootPassword.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textRootPassword
			//
			this.textRootPassword.Location = new System.Drawing.Point(113, 35);
			this.textRootPassword.Name = "textRootPassword";
			this.textRootPassword.Size = new System.Drawing.Size(347, 20);
			this.textRootPassword.TabIndex = 2;
			this.textRootPassword.UseSystemPasswordChar = true;
			//
			// labelRootUser
			//
			this.labelRootUser.Location = new System.Drawing.Point(18, 19);
			this.labelRootUser.Name = "labelRootUser";
			this.labelRootUser.Size = new System.Drawing.Size(90, 20);
			this.labelRootUser.TabIndex = 1;
			this.labelRootUser.Text = "Root User:";
			this.labelRootUser.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textRootUser
			//
			this.textRootUser.Location = new System.Drawing.Point(113, 16);
			this.textRootUser.Name = "textRootUser";
			this.textRootUser.Size = new System.Drawing.Size(347, 20);
			this.textRootUser.TabIndex = 0;
			this.textRootUser.Text = "root";
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
			this.grpDatabase.Location = new System.Drawing.Point(12, 68);
			this.grpDatabase.Name = "grpDatabase";
			this.grpDatabase.Size = new System.Drawing.Size(466, 152);
			this.grpDatabase.TabIndex = 1;
			this.grpDatabase.TabStop = false;
			this.grpDatabase.Text = "Database & Application User";
			//
			// labelLowPrivPassword
			//
			this.labelLowPrivPassword.Location = new System.Drawing.Point(230, 132);
			this.labelLowPrivPassword.Name = "labelLowPrivPassword";
			this.labelLowPrivPassword.Size = new System.Drawing.Size(55, 20);
			this.labelLowPrivPassword.TabIndex = 13;
			this.labelLowPrivPassword.Text = "Pass:";
			this.labelLowPrivPassword.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textLowPrivPassword
			//
			this.textLowPrivPassword.Location = new System.Drawing.Point(289, 129);
			this.textLowPrivPassword.Name = "textLowPrivPassword";
			this.textLowPrivPassword.Size = new System.Drawing.Size(133, 20);
			this.textLowPrivPassword.TabIndex = 12;
			this.textLowPrivPassword.UseSystemPasswordChar = true;
			//
			// labelLowPrivUser
			//
			this.labelLowPrivUser.Location = new System.Drawing.Point(18, 132);
			this.labelLowPrivUser.Name = "labelLowPrivUser";
			this.labelLowPrivUser.Size = new System.Drawing.Size(55, 20);
			this.labelLowPrivUser.TabIndex = 11;
			this.labelLowPrivUser.Text = "Low-Priv:";
			this.labelLowPrivUser.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textLowPrivUser
			//
			this.textLowPrivUser.Location = new System.Drawing.Point(77, 129);
			this.textLowPrivUser.Name = "textLowPrivUser";
			this.textLowPrivUser.Size = new System.Drawing.Size(145, 20);
			this.textLowPrivUser.TabIndex = 10;
			//
			// labelAppPasswordVerify
			//
			this.labelAppPasswordVerify.Location = new System.Drawing.Point(18, 110);
			this.labelAppPasswordVerify.Name = "labelAppPasswordVerify";
			this.labelAppPasswordVerify.Size = new System.Drawing.Size(55, 20);
			this.labelAppPasswordVerify.TabIndex = 9;
			this.labelAppPasswordVerify.Text = "Verify:";
			this.labelAppPasswordVerify.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textAppPasswordVerify
			//
			this.textAppPasswordVerify.Location = new System.Drawing.Point(77, 107);
			this.textAppPasswordVerify.Name = "textAppPasswordVerify";
			this.textAppPasswordVerify.Size = new System.Drawing.Size(345, 20);
			this.textAppPasswordVerify.TabIndex = 8;
			this.textAppPasswordVerify.UseSystemPasswordChar = true;
			//
			// labelAppPassword
			//
			this.labelAppPassword.Location = new System.Drawing.Point(18, 88);
			this.labelAppPassword.Name = "labelAppPassword";
			this.labelAppPassword.Size = new System.Drawing.Size(55, 20);
			this.labelAppPassword.TabIndex = 7;
			this.labelAppPassword.Text = "Password:";
			this.labelAppPassword.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textAppPassword
			//
			this.textAppPassword.Location = new System.Drawing.Point(77, 85);
			this.textAppPassword.Name = "textAppPassword";
			this.textAppPassword.Size = new System.Drawing.Size(345, 20);
			this.textAppPassword.TabIndex = 6;
			this.textAppPassword.UseSystemPasswordChar = true;
			this.textAppPassword.KeyUp += new System.Windows.Forms.KeyEventHandler(this.textAppPassword_KeyUp);
			//
			// labelAppUser
			//
			this.labelAppUser.Location = new System.Drawing.Point(18, 66);
			this.labelAppUser.Name = "labelAppUser";
			this.labelAppUser.Size = new System.Drawing.Size(55, 20);
			this.labelAppUser.TabIndex = 5;
			this.labelAppUser.Text = "DB User:";
			this.labelAppUser.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textAppUser
			//
			this.textAppUser.Location = new System.Drawing.Point(77, 63);
			this.textAppUser.Name = "textAppUser";
			this.textAppUser.Size = new System.Drawing.Size(345, 20);
			this.textAppUser.TabIndex = 4;
			this.textAppUser.Text = "oduser";
			//
			// labelDatabase
			//
			this.labelDatabase.Location = new System.Drawing.Point(18, 44);
			this.labelDatabase.Name = "labelDatabase";
			this.labelDatabase.Size = new System.Drawing.Size(55, 20);
			this.labelDatabase.TabIndex = 3;
			this.labelDatabase.Text = "Database:";
			this.labelDatabase.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textDatabase
			//
			this.textDatabase.Location = new System.Drawing.Point(77, 41);
			this.textDatabase.Name = "textDatabase";
			this.textDatabase.Size = new System.Drawing.Size(345, 20);
			this.textDatabase.TabIndex = 2;
			this.textDatabase.Text = "helianz";
			//
			// labelPort
			//
			this.labelPort.Location = new System.Drawing.Point(262, 22);
			this.labelPort.Name = "labelPort";
			this.labelPort.Size = new System.Drawing.Size(34, 20);
			this.labelPort.TabIndex = 1;
			this.labelPort.Text = "Port:";
			this.labelPort.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textPort
			//
			this.textPort.Location = new System.Drawing.Point(300, 19);
			this.textPort.Name = "textPort";
			this.textPort.Size = new System.Drawing.Size(80, 20);
			this.textPort.TabIndex = 1;
			this.textPort.Text = "3306";
			//
			// labelHost
			//
			this.labelHost.Location = new System.Drawing.Point(18, 22);
			this.labelHost.Name = "labelHost";
			this.labelHost.Size = new System.Drawing.Size(55, 20);
			this.labelHost.TabIndex = 0;
			this.labelHost.Text = "Host:";
			this.labelHost.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textHost
			//
			this.textHost.Location = new System.Drawing.Point(77, 19);
			this.textHost.Name = "textHost";
			this.textHost.Size = new System.Drawing.Size(180, 20);
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
			this.grpServer.Location = new System.Drawing.Point(12, 225);
			this.grpServer.Name = "grpServer";
			this.grpServer.Size = new System.Drawing.Size(466, 55);
			this.grpServer.TabIndex = 2;
			this.grpServer.TabStop = false;
			this.grpServer.Text = "HelianzServer";
			//
			// butBrowse
			//
			this.butBrowse.Location = new System.Drawing.Point(411, 30);
			this.butBrowse.Name = "butBrowse";
			this.butBrowse.Size = new System.Drawing.Size(49, 20);
			this.butBrowse.TabIndex = 4;
			this.butBrowse.Text = "Browse";
			this.butBrowse.Click += new System.EventHandler(this.butBrowse_Click);
			//
			// textHelianzServerPath
			//
			this.textHelianzServerPath.Location = new System.Drawing.Point(228, 30);
			this.textHelianzServerPath.Name = "textHelianzServerPath";
			this.textHelianzServerPath.Size = new System.Drawing.Size(178, 20);
			this.textHelianzServerPath.TabIndex = 3;
			//
			// labelHelianzServerPath
			//
			this.labelHelianzServerPath.Location = new System.Drawing.Point(173, 30);
			this.labelHelianzServerPath.Name = "labelHelianzServerPath";
			this.labelHelianzServerPath.Size = new System.Drawing.Size(50, 20);
			this.labelHelianzServerPath.TabIndex = 2;
			this.labelHelianzServerPath.Text = "Path:";
			this.labelHelianzServerPath.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textServerPort
			//
			this.textServerPort.Location = new System.Drawing.Point(93, 7);
			this.textServerPort.Name = "textServerPort";
			this.textServerPort.Size = new System.Drawing.Size(70, 20);
			this.textServerPort.TabIndex = 1;
			this.textServerPort.Text = "9390";
			//
			// labelServerPort
			//
			this.labelServerPort.Location = new System.Drawing.Point(18, 7);
			this.labelServerPort.Name = "labelServerPort";
			this.labelServerPort.Size = new System.Drawing.Size(70, 20);
			this.labelServerPort.TabIndex = 0;
			this.labelServerPort.Text = "Server Port:";
			this.labelServerPort.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// butTestConnection
			//
			this.butTestConnection.Location = new System.Drawing.Point(125, 290);
			this.butTestConnection.Name = "butTestConnection";
			this.butTestConnection.Size = new System.Drawing.Size(120, 26);
			this.butTestConnection.TabIndex = 3;
			this.butTestConnection.Text = "Test Connection";
			this.butTestConnection.Click += new System.EventHandler(this.butTestConnection_Click);
			//
			// butOK
			//
			this.butOK.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.butOK.Location = new System.Drawing.Point(255, 290);
			this.butOK.Name = "butOK";
			this.butOK.Size = new System.Drawing.Size(80, 26);
			this.butOK.TabIndex = 4;
			this.butOK.Text = "OK";
			this.butOK.UseVisualStyleBackColor = true;
			this.butOK.Click += new System.EventHandler(this.butOK_Click);
			//
			// butCancel
			//
			this.butCancel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.butCancel.Location = new System.Drawing.Point(345, 290);
			this.butCancel.Name = "butCancel";
			this.butCancel.Size = new System.Drawing.Size(80, 26);
			this.butCancel.TabIndex = 5;
			this.butCancel.Text = "Cancel";
			this.butCancel.UseVisualStyleBackColor = true;
			this.butCancel.Click += new System.EventHandler(this.butCancel_Click);
			//
			// FormHelianzServerConfig
			//
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(490, 330);
			this.Controls.Add(this.butCancel);
			this.Controls.Add(this.butOK);
			this.Controls.Add(this.butTestConnection);
			this.Controls.Add(this.grpServer);
			this.Controls.Add(this.grpDatabase);
			this.Controls.Add(this.grpRoot);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "FormHelianzServerConfig";
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
			this.Text = "HelianzServer Configuration";
			this.Load += new System.EventHandler(this.FormHelianzServerConfig_Load);
			this.grpRoot.ResumeLayout(false);
			this.grpRoot.PerformLayout();
			this.grpDatabase.ResumeLayout(false);
			this.grpDatabase.PerformLayout();
			this.grpServer.ResumeLayout(false);
			this.grpServer.PerformLayout();
			this.ResumeLayout(false);
			this.PerformLayout();

		}

		#endregion

		private System.Windows.Forms.GroupBox grpRoot;
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
