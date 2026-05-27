namespace FreeDentalInstaller{
	partial class FormMain {
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
			System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FormMain));
			this.label1 = new System.Windows.Forms.Label();
			this.checkDbmsServer = new System.Windows.Forms.CheckBox();
			this.checkmyini = new System.Windows.Forms.CheckBox();
			this.checkDatabase = new System.Windows.Forms.CheckBox();
			this.checkODImages = new System.Windows.Forms.CheckBox();
			this.textServer = new System.Windows.Forms.TextBox();
			this.textBox2 = new System.Windows.Forms.TextBox();
			this.textBox3 = new System.Windows.Forms.TextBox();
			this.textBox4 = new System.Windows.Forms.TextBox();
			this.butInstall = new System.Windows.Forms.Button();
			this.textDbmsInstallationDir = new System.Windows.Forms.TextBox();
			this.label3 = new System.Windows.Forms.Label();
			this.textmyini = new System.Windows.Forms.TextBox();
			this.textDatabase = new System.Windows.Forms.TextBox();
			this.textHelianzImages = new System.Windows.Forms.TextBox();
			this.groupBox1 = new System.Windows.Forms.GroupBox();
			this.label7 = new System.Windows.Forms.Label();
			this.label6 = new System.Windows.Forms.Label();
			this.butUpdateDbms = new System.Windows.Forms.Button();
			this.label5 = new System.Windows.Forms.Label();
			this.butUpdateServer = new System.Windows.Forms.Button();
			this.label4 = new System.Windows.Forms.Label();
			this.butWorkstation = new System.Windows.Forms.Button();
			this.label2 = new System.Windows.Forms.Label();
			this.butNewServer = new System.Windows.Forms.Button();
			this.textApplication = new System.Windows.Forms.TextBox();
			this.textBox10 = new System.Windows.Forms.TextBox();
			this.checkOD = new System.Windows.Forms.CheckBox();
			this.butClose = new System.Windows.Forms.Button();
			this.textGrant = new System.Windows.Forms.TextBox();
			this.textGrantTables = new System.Windows.Forms.TextBox();
			this.checkGrant = new System.Windows.Forms.CheckBox();
			this.butMariaDBLicense = new System.Windows.Forms.Button();
			this.butFullInstall = new System.Windows.Forms.Button();
			this.labelFullInstall = new System.Windows.Forms.Label();
			this.groupBox1.SuspendLayout();
			this.SuspendLayout();
			// 
			// label1
			// 
			this.label1.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.label1.Location = new System.Drawing.Point(19, 193);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(107, 15);
			this.label1.TabIndex = 0;
			this.label1.Text = "Install Items:";
			// 
			// checkDbmsServer
			// 
			this.checkDbmsServer.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.checkDbmsServer.Location = new System.Drawing.Point(21, 276);
			this.checkDbmsServer.Name = "checkDbmsServer";
			this.checkDbmsServer.Size = new System.Drawing.Size(162, 16);
			this.checkDbmsServer.TabIndex = 2;
			this.checkDbmsServer.Text = "MariaDB Server";
			this.checkDbmsServer.CheckedChanged += new System.EventHandler(this.checkDbmsServer_CheckedChanged);
			// 
			// checkmyini
			// 
			this.checkmyini.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.checkmyini.Location = new System.Drawing.Point(21, 405);
			this.checkmyini.Name = "checkmyini";
			this.checkmyini.Size = new System.Drawing.Size(171, 16);
			this.checkmyini.TabIndex = 3;
			this.checkmyini.Text = "my.ini";
			// 
			// checkDatabase
			// 
			this.checkDatabase.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.checkDatabase.Location = new System.Drawing.Point(21, 471);
			this.checkDatabase.Name = "checkDatabase";
			this.checkDatabase.Size = new System.Drawing.Size(161, 16);
			this.checkDatabase.TabIndex = 4;
			this.checkDatabase.Text = "helianz Database";
			// 
			// checkODImages
			// 
			this.checkODImages.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.checkODImages.Location = new System.Drawing.Point(21, 536);
			this.checkODImages.Name = "checkODImages";
			this.checkODImages.Size = new System.Drawing.Size(167, 14);
			this.checkODImages.TabIndex = 5;
			this.checkODImages.Text = "HelianzImages";
			// 
			// textServer
			// 
			this.textServer.BackColor = System.Drawing.SystemColors.Control;
			this.textServer.Location = new System.Drawing.Point(21, 293);
			this.textServer.Multiline = true;
			this.textServer.Name = "textServer";
			this.textServer.Size = new System.Drawing.Size(534, 40);
			this.textServer.TabIndex = 7;
			this.textServer.Text = "Runs the setup for the MariaDB program. MariaDB - Copyright 2009-2021, www.mariadb.com. MariaDB Community Server (GPL)";
			// 
			// textBox2
			// 
			this.textBox2.BackColor = System.Drawing.SystemColors.Control;
			this.textBox2.Location = new System.Drawing.Point(21, 423);
			this.textBox2.Multiline = true;
			this.textBox2.Name = "textBox2";
			this.textBox2.Size = new System.Drawing.Size(534, 40);
			this.textBox2.TabIndex = 8;
			this.textBox2.Text = "A small file that is required for MariaDB to function properly.  Uses the paths entered in the \"MariaDB Server\" box above and the \"helianz Database\" box below.";
			// 
			// textBox3
			// 
			this.textBox3.BackColor = System.Drawing.SystemColors.Control;
			this.textBox3.Location = new System.Drawing.Point(21, 553);
			this.textBox3.Multiline = true;
			this.textBox3.Name = "textBox3";
			this.textBox3.Size = new System.Drawing.Size(534, 40);
			this.textBox3.TabIndex = 9;
			this.textBox3.Text = "Contains the A-Z folders that hold patient images.";
			// 
			// textBox4
			// 
			this.textBox4.BackColor = System.Drawing.SystemColors.Control;
			this.textBox4.Location = new System.Drawing.Point(21, 488);
			this.textBox4.Multiline = true;
			this.textBox4.Name = "textBox4";
			this.textBox4.Size = new System.Drawing.Size(534, 40);
			this.textBox4.TabIndex = 10;
			this.textBox4.Text = "The actual database files.  Includes a demo database.";
			// 
			// butInstall
			// 
			this.butInstall.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.butInstall.Location = new System.Drawing.Point(584, 534);
			this.butInstall.Name = "butInstall";
			this.butInstall.Size = new System.Drawing.Size(75, 25);
			this.butInstall.TabIndex = 11;
			this.butInstall.Text = "Install";
			this.butInstall.Click += new System.EventHandler(this.butInstall_Click);
			// 
			// textDbmsInstallationDir
			// 
			this.textDbmsInstallationDir.BackColor = System.Drawing.SystemColors.Window;
			this.textDbmsInstallationDir.Location = new System.Drawing.Point(204, 273);
			this.textDbmsInstallationDir.Name = "textDbmsInstallationDir";
			this.textDbmsInstallationDir.Size = new System.Drawing.Size(351, 20);
			this.textDbmsInstallationDir.TabIndex = 12;
			this.textDbmsInstallationDir.Text = "C:\\Program Files\\MariaDB 10.5\\";
			this.textDbmsInstallationDir.TextChanged += new System.EventHandler(this.textDbmsInstallationDir_TextChanged);
			// 
			// label3
			// 
			this.label3.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.label3.Location = new System.Drawing.Point(201, 192);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(342, 17);
			this.label3.TabIndex = 13;
			this.label3.Text = "Installation Locations:";
			// 
			// textmyini
			// 
			this.textmyini.BackColor = System.Drawing.SystemColors.Control;
			this.textmyini.Location = new System.Drawing.Point(204, 403);
			this.textmyini.Name = "textmyini";
			this.textmyini.ReadOnly = true;
			this.textmyini.Size = new System.Drawing.Size(351, 20);
			this.textmyini.TabIndex = 14;
			this.textmyini.Text = "C:\\Program Files\\MariaDB 10.5\\";
			// 
			// textDatabase
			// 
			this.textDatabase.BackColor = System.Drawing.SystemColors.Window;
			this.textDatabase.Location = new System.Drawing.Point(204, 468);
			this.textDatabase.Name = "textDatabase";
			this.textDatabase.Size = new System.Drawing.Size(351, 20);
			this.textDatabase.TabIndex = 15;
			this.textDatabase.Text = "C:\\mysql\\data\\";
			this.textDatabase.TextChanged += new System.EventHandler(this.textDatabase_TextChanged);
			// 
			// textHelianzImages
			// 
			this.textHelianzImages.BackColor = System.Drawing.SystemColors.Window;
			this.textHelianzImages.Location = new System.Drawing.Point(204, 533);
			this.textHelianzImages.Name = "textHelianzImages";
			this.textHelianzImages.Size = new System.Drawing.Size(351, 20);
			this.textHelianzImages.TabIndex = 16;
			this.textHelianzImages.Text = "C:\\HelianzImages\\";
			// 
			// groupBox1
			// 
			this.groupBox1.Controls.Add(this.label7);
			this.groupBox1.Controls.Add(this.label6);
			this.groupBox1.Controls.Add(this.butUpdateDbms);
			this.groupBox1.Controls.Add(this.label5);
			this.groupBox1.Controls.Add(this.butUpdateServer);
			this.groupBox1.Controls.Add(this.label4);
			this.groupBox1.Controls.Add(this.butWorkstation);
			this.groupBox1.Controls.Add(this.label2);
			this.groupBox1.Controls.Add(this.butNewServer);
			this.groupBox1.Controls.Add(this.labelFullInstall);
			this.groupBox1.Controls.Add(this.butFullInstall);
			this.groupBox1.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.groupBox1.Location = new System.Drawing.Point(19, 7);
			this.groupBox1.Name = "groupBox1";
			this.groupBox1.Size = new System.Drawing.Size(536, 175);
			this.groupBox1.TabIndex = 17;
			this.groupBox1.TabStop = false;
			this.groupBox1.Text = "Special installation types";
			// 
			// label7
			// 
			this.label7.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, 0);
			this.label7.Location = new System.Drawing.Point(6, 18);
			this.label7.Name = "label7";
			this.label7.Size = new System.Drawing.Size(527, 19);
			this.label7.TabIndex = 20;
			this.label7.Text = "New users can ignore this section and simply click the Install button at the lower right.";
			// 
			// label6
			// 
			this.label6.Location = new System.Drawing.Point(102, 121);
			this.label6.Name = "label6";
			this.label6.Size = new System.Drawing.Size(185, 15);
			this.label6.TabIndex = 19;
			this.label6.Text = "MariaDB server";
			// 
			// butUpdateDbms
			// 
			this.butUpdateDbms.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.butUpdateDbms.Location = new System.Drawing.Point(13, 115);
			this.butUpdateDbms.Name = "butUpdateDbms";
			this.butUpdateDbms.Size = new System.Drawing.Size(85, 25);
			this.butUpdateDbms.TabIndex = 18;
			this.butUpdateDbms.Text = "MariaDB";
			this.butUpdateDbms.Click += new System.EventHandler(this.butUpdateDbms_Click);
			// 
			// label5
			// 
			this.label5.Location = new System.Drawing.Point(102, 69);
			this.label5.Name = "label5";
			this.label5.Size = new System.Drawing.Size(185, 15);
			this.label5.TabIndex = 17;
			this.label5.Text = "(or single standalone computer)";
			// 
			// butUpdateServer
			// 
			this.butUpdateServer.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.butUpdateServer.Location = new System.Drawing.Point(13, 63);
			this.butUpdateServer.Name = "butUpdateServer";
			this.butUpdateServer.Size = new System.Drawing.Size(85, 25);
			this.butUpdateServer.TabIndex = 16;
			this.butUpdateServer.Text = "Update Server";
			this.butUpdateServer.Click += new System.EventHandler(this.butUpdateServer_Click);
			// 
			// label4
			// 
			this.label4.Location = new System.Drawing.Point(102, 95);
			this.label4.Name = "label4";
			this.label4.Size = new System.Drawing.Size(185, 15);
			this.label4.TabIndex = 15;
			this.label4.Text = "(either new or update)";
			// 
			// butWorkstation
			// 
			this.butWorkstation.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.butWorkstation.Location = new System.Drawing.Point(13, 89);
			this.butWorkstation.Name = "butWorkstation";
			this.butWorkstation.Size = new System.Drawing.Size(85, 25);
			this.butWorkstation.TabIndex = 14;
			this.butWorkstation.Text = "Client";
			this.butWorkstation.Click += new System.EventHandler(this.butWorkstation_Click);
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(102, 43);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(185, 15);
			this.label2.TabIndex = 13;
			this.label2.Text = "(or single standalone computer)";
			// 
			// butNewServer
			// 
			this.butNewServer.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.butNewServer.Location = new System.Drawing.Point(13, 37);
			this.butNewServer.Name = "butNewServer";
			this.butNewServer.Size = new System.Drawing.Size(85, 25);
			this.butNewServer.TabIndex = 12;
			this.butNewServer.Text = "Server";
			this.butNewServer.Click += new System.EventHandler(this.butNewServer_Click);
			// 
			// butFullInstall
			// 
			this.butFullInstall.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.butFullInstall.Location = new System.Drawing.Point(13, 141);
			this.butFullInstall.Name = "butFullInstall";
			this.butFullInstall.Size = new System.Drawing.Size(85, 25);
			this.butFullInstall.TabIndex = 23;
			this.butFullInstall.Text = "Full Install";
			this.butFullInstall.Click += new System.EventHandler(this.butFullInstall_Click);
			// 
			// labelFullInstall
			// 
			this.labelFullInstall.Location = new System.Drawing.Point(102, 147);
			this.labelFullInstall.Name = "labelFullInstall";
			this.labelFullInstall.Size = new System.Drawing.Size(185, 15);
			this.labelFullInstall.TabIndex = 24;
			this.labelFullInstall.Text = "(install all components)";
			// 
			// textApplication
			// 
			this.textApplication.BackColor = System.Drawing.SystemColors.Window;
			this.textApplication.Location = new System.Drawing.Point(204, 208);
			this.textApplication.Name = "textApplication";
			this.textApplication.Size = new System.Drawing.Size(351, 20);
			this.textApplication.TabIndex = 20;
			this.textApplication.Text = "C:\\Program Files\\Helianz\\";
			// 
			// textBox10
			// 
			this.textBox10.BackColor = System.Drawing.SystemColors.Control;
			this.textBox10.Location = new System.Drawing.Point(21, 228);
			this.textBox10.Multiline = true;
			this.textBox10.Name = "textBox10";
			this.textBox10.Size = new System.Drawing.Size(534, 40);
			this.textBox10.TabIndex = 19;
			this.textBox10.Text = "Runs the setup for the Helianz program.";
			// 
			// checkOD
			// 
			this.checkOD.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.checkOD.Location = new System.Drawing.Point(21, 211);
			this.checkOD.Name = "checkOD";
			this.checkOD.Size = new System.Drawing.Size(162, 17);
			this.checkOD.TabIndex = 18;
			this.checkOD.Text = "Helianz Program";
			// 
			// butClose
			// 
			this.butClose.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.butClose.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.butClose.Location = new System.Drawing.Point(584, 569);
			this.butClose.Name = "butClose";
			this.butClose.Size = new System.Drawing.Size(75, 25);
			this.butClose.TabIndex = 21;
			this.butClose.Text = "Close";
			this.butClose.Click += new System.EventHandler(this.butClose_Click);
			// 
			// textGrant
			// 
			this.textGrant.BackColor = System.Drawing.SystemColors.Control;
			this.textGrant.Location = new System.Drawing.Point(204, 338);
			this.textGrant.Name = "textGrant";
			this.textGrant.ReadOnly = true;
			this.textGrant.Size = new System.Drawing.Size(351, 20);
			this.textGrant.TabIndex = 24;
			this.textGrant.Text = "C:\\mysql\\data\\mysql\\";
			// 
			// textGrantTables
			// 
			this.textGrantTables.BackColor = System.Drawing.SystemColors.Control;
			this.textGrantTables.Location = new System.Drawing.Point(21, 358);
			this.textGrantTables.Multiline = true;
			this.textGrantTables.Name = "textGrantTables";
			this.textGrantTables.Size = new System.Drawing.Size(534, 40);
			this.textGrantTables.TabIndex = 23;
			this.textGrantTables.Text = "These tables will be placed in the data\\mysql folder.  Required by MariaDB 10.5.  This will also prompt for MariaDB credentials.";
			// 
			// checkGrant
			// 
			this.checkGrant.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.checkGrant.Location = new System.Drawing.Point(21, 341);
			this.checkGrant.Name = "checkGrant";
			this.checkGrant.Size = new System.Drawing.Size(162, 16);
			this.checkGrant.TabIndex = 22;
			this.checkGrant.Text = "MariaDB 10.5 grant tables";
			// 
			// butMariaDBLicense
			// 
			this.butMariaDBLicense.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.butMariaDBLicense.Location = new System.Drawing.Point(584, 299);
			this.butMariaDBLicense.Name = "butMariaDBLicense";
			this.butMariaDBLicense.Size = new System.Drawing.Size(83, 25);
			this.butMariaDBLicense.TabIndex = 25;
			this.butMariaDBLicense.Text = "View License";
			this.butMariaDBLicense.Click += new System.EventHandler(this.butMariaDBLicense_Click);
			// 
			// FormMain
			// 
			this.AcceptButton = this.butInstall;
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.None;
			this.ClientSize = new System.Drawing.Size(692, 622);
			this.Controls.Add(this.butMariaDBLicense);
			this.Controls.Add(this.textGrant);
			this.Controls.Add(this.textGrantTables);
			this.Controls.Add(this.checkGrant);
			this.Controls.Add(this.butClose);
			this.Controls.Add(this.textApplication);
			this.Controls.Add(this.textBox10);
			this.Controls.Add(this.checkOD);
			this.Controls.Add(this.groupBox1);
			this.Controls.Add(this.textHelianzImages);
			this.Controls.Add(this.textDatabase);
			this.Controls.Add(this.textmyini);
			this.Controls.Add(this.label3);
			this.Controls.Add(this.textDbmsInstallationDir);
			this.Controls.Add(this.butInstall);
			this.Controls.Add(this.textBox4);
			this.Controls.Add(this.textBox3);
			this.Controls.Add(this.textBox2);
			this.Controls.Add(this.textServer);
			this.Controls.Add(this.checkDbmsServer);
			this.Controls.Add(this.checkODImages);
			this.Controls.Add(this.checkDatabase);
			this.Controls.Add(this.checkmyini);
			this.Controls.Add(this.label1);
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.Name = "FormMain";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "Helianz Installer";
			this.Load += new System.EventHandler(this.FormMain_Load);
			this.groupBox1.ResumeLayout(false);
			this.ResumeLayout(false);
			this.PerformLayout();
		}

		#endregion
	}
}
