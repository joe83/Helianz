namespace Helianz {
	partial class FormSatuSehatSetup {
		private System.ComponentModel.IContainer components = null;

		protected override void Dispose(bool disposing) {
			if(disposing && (components != null)) {
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows Form Designer generated code
		private void InitializeComponent() {
			this.labelClientId = new System.Windows.Forms.Label();
			this.textClientId = new System.Windows.Forms.TextBox();
			this.labelClientSecret = new System.Windows.Forms.Label();
			this.textClientSecret = new System.Windows.Forms.TextBox();
			this.labelOrganizationId = new System.Windows.Forms.Label();
			this.textOrganizationId = new System.Windows.Forms.TextBox();
			this.labelLocationId = new System.Windows.Forms.Label();
			this.textLocationId = new System.Windows.Forms.TextBox();
			this.labelEnvironment = new System.Windows.Forms.Label();
			this.comboEnvironment = new Helianz.UI.ComboBox();
			this.checkIsEnabled = new Helianz.UI.CheckBox();
			this.labelNote = new System.Windows.Forms.Label();
			this.textNote = new System.Windows.Forms.TextBox();
			this.labelConnectionStatus = new System.Windows.Forms.Label();
			this.butTestConnection = new Helianz.UI.Button();
			this.butSave = new Helianz.UI.Button();
			this.butCancel = new Helianz.UI.Button();
			this.SuspendLayout();
			// 
			// labelClientId
			// 
			this.labelClientId.Location = new System.Drawing.Point(20, 26);
			this.labelClientId.Name = "labelClientId";
			this.labelClientId.Size = new System.Drawing.Size(130, 20);
			this.labelClientId.TabIndex = 0;
			this.labelClientId.Text = "Client ID";
			this.labelClientId.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// textClientId
			// 
			this.textClientId.Location = new System.Drawing.Point(155, 26);
			this.textClientId.Name = "textClientId";
			this.textClientId.Size = new System.Drawing.Size(280, 20);
			this.textClientId.TabIndex = 1;
			// 
			// labelClientSecret
			// 
			this.labelClientSecret.Location = new System.Drawing.Point(20, 52);
			this.labelClientSecret.Name = "labelClientSecret";
			this.labelClientSecret.Size = new System.Drawing.Size(130, 20);
			this.labelClientSecret.TabIndex = 0;
			this.labelClientSecret.Text = "Client Secret";
			this.labelClientSecret.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// textClientSecret
			// 
			this.textClientSecret.Location = new System.Drawing.Point(155, 52);
			this.textClientSecret.Name = "textClientSecret";
			this.textClientSecret.PasswordChar = '*';
			this.textClientSecret.Size = new System.Drawing.Size(280, 20);
			this.textClientSecret.TabIndex = 2;
			// 
			// labelOrganizationId
			// 
			this.labelOrganizationId.Location = new System.Drawing.Point(20, 78);
			this.labelOrganizationId.Name = "labelOrganizationId";
			this.labelOrganizationId.Size = new System.Drawing.Size(130, 20);
			this.labelOrganizationId.TabIndex = 0;
			this.labelOrganizationId.Text = "Organization ID (IHS)";
			this.labelOrganizationId.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// textOrganizationId
			// 
			this.textOrganizationId.Location = new System.Drawing.Point(155, 78);
			this.textOrganizationId.Name = "textOrganizationId";
			this.textOrganizationId.Size = new System.Drawing.Size(280, 20);
			this.textOrganizationId.TabIndex = 3;
			// 
			// 
			// labelLocationId
			// 
			this.labelLocationId.Location = new System.Drawing.Point(20, 104);
			this.labelLocationId.Name = "labelLocationId";
			this.labelLocationId.Size = new System.Drawing.Size(130, 20);
			this.labelLocationId.TabIndex = 0;
			this.labelLocationId.Text = "Location ID (IHS)";
			this.labelLocationId.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// textLocationId
			// 
			this.textLocationId.Location = new System.Drawing.Point(155, 104);
			this.textLocationId.Name = "textLocationId";
			this.textLocationId.Size = new System.Drawing.Size(280, 20);
			this.textLocationId.TabIndex = 4;
			// 
			// labelEnvironment
			// 
			this.labelEnvironment.Location = new System.Drawing.Point(20, 130);
			this.labelEnvironment.Name = "labelEnvironment";
			this.labelEnvironment.Size = new System.Drawing.Size(130, 20);
			this.labelEnvironment.TabIndex = 0;
			this.labelEnvironment.Text = "Environment";
			this.labelEnvironment.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// comboEnvironment
			// 
			this.comboEnvironment.Location = new System.Drawing.Point(155, 130);
			this.comboEnvironment.Name = "comboEnvironment";
			this.comboEnvironment.Size = new System.Drawing.Size(150, 21);
			this.comboEnvironment.TabIndex = 5;
			// 
			// checkIsEnabled
			// 
			this.checkIsEnabled.Location = new System.Drawing.Point(155, 156);
			this.checkIsEnabled.Name = "checkIsEnabled";
			this.checkIsEnabled.Size = new System.Drawing.Size(200, 20);
			this.checkIsEnabled.TabIndex = 6;
			this.checkIsEnabled.Text = "Enabled";
			// 
			// labelNote
			// 
			this.labelNote.Location = new System.Drawing.Point(20, 182);
			this.labelNote.Name = "labelNote";
			this.labelNote.Size = new System.Drawing.Size(130, 20);
			this.labelNote.TabIndex = 0;
			this.labelNote.Text = "Note";
			this.labelNote.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// textNote
			// 
			this.textNote.Location = new System.Drawing.Point(155, 182);
			this.textNote.Multiline = true;
			this.textNote.Name = "textNote";
			this.textNote.Size = new System.Drawing.Size(280, 60);
			this.textNote.TabIndex = 7;
			// 
			// labelConnectionStatus
			// 
			this.labelConnectionStatus.Anchor = ((System.Windows.Forms.AnchorStyles)(System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left));
			this.labelConnectionStatus.AutoSize = true;
			this.labelConnectionStatus.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.5f, System.Drawing.FontStyle.Bold);
			this.labelConnectionStatus.Location = new System.Drawing.Point(148, 262);
			this.labelConnectionStatus.Name = "labelConnectionStatus";
			this.labelConnectionStatus.Size = new System.Drawing.Size(100, 16);
			this.labelConnectionStatus.TabIndex = 0;
			this.labelConnectionStatus.Text = "";
			this.labelConnectionStatus.Visible = false;
			// butTestConnection
			// 
			this.butTestConnection.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
			this.butTestConnection.Location = new System.Drawing.Point(20, 258);
			this.butTestConnection.Name = "butTestConnection";
			this.butTestConnection.Size = new System.Drawing.Size(120, 24);
			this.butTestConnection.TabIndex = 8;
			this.butTestConnection.Text = "Test Connection";
			this.butTestConnection.Click += new System.EventHandler(this.butTestConnection_Click);
			// textClientId - wire TextChanged to clear status
			// (already declared above; add event wires here)
			this.textClientId.TextChanged += new System.EventHandler(this.textClientId_TextChanged);
			this.textClientSecret.TextChanged += new System.EventHandler(this.textClientSecret_TextChanged);
			// 
			// butSave
			// 
			this.butSave.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.butSave.Location = new System.Drawing.Point(355, 258);
			this.butSave.Name = "butSave";
			this.butSave.Size = new System.Drawing.Size(75, 24);
			this.butSave.TabIndex = 8;
			this.butSave.Text = "&Save";
			this.butSave.Click += new System.EventHandler(this.butSave_Click);
			// 
			// butCancel
			// 
			this.butCancel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.butCancel.Location = new System.Drawing.Point(355, 288);
			this.butCancel.Name = "butCancel";
			this.butCancel.Size = new System.Drawing.Size(75, 24);
			this.butCancel.TabIndex = 10;
			this.butCancel.Text = "&Cancel";
			this.butCancel.Click += new System.EventHandler(this.butCancel_Click);
			// 
			// FormSatuSehatSetup
			// 
			this.ClientSize = new System.Drawing.Size(460, 328);
			this.Controls.Add(this.labelClientId);
			this.Controls.Add(this.textClientId);
			this.Controls.Add(this.labelClientSecret);
			this.Controls.Add(this.textClientSecret);
			this.Controls.Add(this.labelOrganizationId);
			this.Controls.Add(this.textOrganizationId);
			this.Controls.Add(this.labelLocationId);
			this.Controls.Add(this.textLocationId);
			this.Controls.Add(this.labelEnvironment);
			this.Controls.Add(this.comboEnvironment);
			this.Controls.Add(this.checkIsEnabled);
			this.Controls.Add(this.labelNote);
			this.Controls.Add(this.textNote);
			this.Controls.Add(this.labelConnectionStatus);
			this.Controls.Add(this.butTestConnection);
			this.Controls.Add(this.butSave);
			this.Controls.Add(this.butCancel);
			this.Name = "FormSatuSehatSetup";
			this.Text = "SatuSehat Setup";
			this.Load += new System.EventHandler(this.FormSatuSehatSetup_Load);
			this.ResumeLayout(false);
			this.PerformLayout();
		}
		#endregion

		private System.Windows.Forms.Label labelClientId;
		private System.Windows.Forms.TextBox textClientId;
		private System.Windows.Forms.Label labelClientSecret;
		private System.Windows.Forms.TextBox textClientSecret;
		private System.Windows.Forms.Label labelOrganizationId;
		private System.Windows.Forms.TextBox textOrganizationId;
		private System.Windows.Forms.Label labelLocationId;
		private System.Windows.Forms.TextBox textLocationId;
		private System.Windows.Forms.Label labelEnvironment;
		private Helianz.UI.ComboBox comboEnvironment;
		private Helianz.UI.CheckBox checkIsEnabled;
		private System.Windows.Forms.Label labelNote;
		private System.Windows.Forms.TextBox textNote;
		private System.Windows.Forms.Label labelConnectionStatus;
		private Helianz.UI.Button butTestConnection;
		private Helianz.UI.Button butSave;
		private Helianz.UI.Button butCancel;
	}
}
