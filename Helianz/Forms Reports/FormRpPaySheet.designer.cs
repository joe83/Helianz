using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Helianz {
	public partial class FormRpPaySheet {
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
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FormRpPaySheet));
			this.date2 = new System.Windows.Forms.MonthCalendar();
			this.date1 = new System.Windows.Forms.MonthCalendar();
			this.listProv = new Helianz.UI.ListBox();
			this.label1 = new System.Windows.Forms.Label();
			this.checkAllProv = new Helianz.UI.CheckBox();
			this.groupBox1 = new Helianz.UI.GroupBox();
			this.checkShowProvSeparate = new Helianz.UI.CheckBox();
			this.radioPatient = new System.Windows.Forms.RadioButton();
			this.radioCheck = new System.Windows.Forms.RadioButton();
			this.checkPatientTypes = new Helianz.UI.CheckBox();
			this.listPatientTypes = new Helianz.UI.ListBox();
			this.checkInsuranceTypes = new Helianz.UI.CheckBox();
			this.checkAllClin = new Helianz.UI.CheckBox();
			this.listClin = new Helianz.UI.ListBox();
			this.labelClin = new System.Windows.Forms.Label();
			this.butOK = new Helianz.UI.Button();
			this.listInsuranceTypes = new Helianz.UI.ListBox();
			this.checkAllClaimPayGroups = new Helianz.UI.CheckBox();
			this.listClaimPayGroups = new Helianz.UI.ListBox();
			this.checkUnearned = new Helianz.UI.CheckBox();
			this.checkReportDisplayUnearnedTP = new Helianz.UI.CheckBox();
			this.checkShowOnlinePatientPaymentsSeparately = new Helianz.UI.CheckBox();
			this.checkShowCareCreditFees = new Helianz.UI.CheckBox();
			this.checkShowPayConnectFees = new Helianz.UI.CheckBox();
			this.groupBox1.SuspendLayout();
			this.SuspendLayout();
			// 
			// date2
			// 
			this.date2.Location = new System.Drawing.Point(252, 36);
			this.date2.Name = "date2";
			this.date2.TabIndex = 2;
			// 
			// date1
			// 
			this.date1.Location = new System.Drawing.Point(16, 36);
			this.date1.Name = "date1";
			this.date1.TabIndex = 1;
			// 
			// listProv
			// 
			this.listProv.Location = new System.Drawing.Point(493, 54);
			this.listProv.Name = "listProv";
			this.listProv.SelectionMode = Helianz.UI.SelectionMode.MultiExtended;
			this.listProv.Size = new System.Drawing.Size(160, 199);
			this.listProv.TabIndex = 36;
			this.listProv.Click += new System.EventHandler(this.listProv_Click);
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(491, 15);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(104, 16);
			this.label1.TabIndex = 35;
			this.label1.Text = "Providers";
			this.label1.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
			// 
			// checkAllProv
			// 
			this.checkAllProv.Checked = true;
			this.checkAllProv.CheckState = System.Windows.Forms.CheckState.Checked;
			this.checkAllProv.Location = new System.Drawing.Point(494, 35);
			this.checkAllProv.Name = "checkAllProv";
			this.checkAllProv.Size = new System.Drawing.Size(40, 16);
			this.checkAllProv.TabIndex = 43;
			this.checkAllProv.Text = "All";
			this.checkAllProv.Click += new System.EventHandler(this.checkAllProv_Click);
			// 
			// groupBox1
			// 
			this.groupBox1.Controls.Add(this.checkShowProvSeparate);
			this.groupBox1.Controls.Add(this.radioPatient);
			this.groupBox1.Controls.Add(this.radioCheck);
			this.groupBox1.Location = new System.Drawing.Point(18, 263);
			this.groupBox1.Name = "groupBox1";
			this.groupBox1.Size = new System.Drawing.Size(173, 101);
			this.groupBox1.TabIndex = 44;
			this.groupBox1.Text = "Group By";
			// 
			// checkShowProvSeparate
			// 
			this.checkShowProvSeparate.Checked = true;
			this.checkShowProvSeparate.CheckState = System.Windows.Forms.CheckState.Checked;
			this.checkShowProvSeparate.Location = new System.Drawing.Point(8, 61);
			this.checkShowProvSeparate.Name = "checkShowProvSeparate";
			this.checkShowProvSeparate.Size = new System.Drawing.Size(159, 34);
			this.checkShowProvSeparate.TabIndex = 55;
			this.checkShowProvSeparate.Text = "Show splits by provider separately";
			// 
			// radioPatient
			// 
			this.radioPatient.Location = new System.Drawing.Point(8, 37);
			this.radioPatient.Name = "radioPatient";
			this.radioPatient.Size = new System.Drawing.Size(104, 18);
			this.radioPatient.TabIndex = 1;
			this.radioPatient.Text = "Patient";
			this.radioPatient.UseVisualStyleBackColor = true;
			// 
			// radioCheck
			// 
			this.radioCheck.Checked = true;
			this.radioCheck.Location = new System.Drawing.Point(8, 18);
			this.radioCheck.Name = "radioCheck";
			this.radioCheck.Size = new System.Drawing.Size(104, 18);
			this.radioCheck.TabIndex = 0;
			this.radioCheck.TabStop = true;
			this.radioCheck.Text = "Check";
			this.radioCheck.UseVisualStyleBackColor = true;
			// 
			// checkPatientTypes
			// 
			this.checkPatientTypes.Checked = true;
			this.checkPatientTypes.CheckState = System.Windows.Forms.CheckState.Checked;
			this.checkPatientTypes.Location = new System.Drawing.Point(382, 263);
			this.checkPatientTypes.Name = "checkPatientTypes";
			this.checkPatientTypes.Size = new System.Drawing.Size(166, 16);
			this.checkPatientTypes.TabIndex = 47;
			this.checkPatientTypes.Text = "All patient payment types";
			this.checkPatientTypes.Click += new System.EventHandler(this.checkAllTypes_Click);
			// 
			// listPatientTypes
			// 
			this.listPatientTypes.Location = new System.Drawing.Point(382, 285);
			this.listPatientTypes.Name = "listPatientTypes";
			this.listPatientTypes.SelectionMode = Helianz.UI.SelectionMode.MultiExtended;
			this.listPatientTypes.Size = new System.Drawing.Size(163, 186);
			this.listPatientTypes.TabIndex = 46;
			// 
			// checkInsuranceTypes
			// 
			this.checkInsuranceTypes.Checked = true;
			this.checkInsuranceTypes.CheckState = System.Windows.Forms.CheckState.Checked;
			this.checkInsuranceTypes.Location = new System.Drawing.Point(210, 263);
			this.checkInsuranceTypes.Name = "checkInsuranceTypes";
			this.checkInsuranceTypes.Size = new System.Drawing.Size(166, 16);
			this.checkInsuranceTypes.TabIndex = 48;
			this.checkInsuranceTypes.Text = "All insurance payment types";
			this.checkInsuranceTypes.Click += new System.EventHandler(this.checkIns_Click);
			// 
			// checkAllClin
			// 
			this.checkAllClin.Location = new System.Drawing.Point(662, 35);
			this.checkAllClin.Name = "checkAllClin";
			this.checkAllClin.Size = new System.Drawing.Size(160, 16);
			this.checkAllClin.TabIndex = 54;
			this.checkAllClin.Text = "All (Includes hidden)";
			this.checkAllClin.Click += new System.EventHandler(this.checkAllClin_Click);
			// 
			// listClin
			// 
			this.listClin.Location = new System.Drawing.Point(662, 54);
			this.listClin.Name = "listClin";
			this.listClin.SelectionMode = Helianz.UI.SelectionMode.MultiExtended;
			this.listClin.Size = new System.Drawing.Size(160, 199);
			this.listClin.TabIndex = 53;
			this.listClin.Click += new System.EventHandler(this.listClin_Click);
			// 
			// labelClin
			// 
			this.labelClin.Location = new System.Drawing.Point(659, 17);
			this.labelClin.Name = "labelClin";
			this.labelClin.Size = new System.Drawing.Size(104, 16);
			this.labelClin.TabIndex = 52;
			this.labelClin.Text = "Clinics";
			this.labelClin.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
			// 
			// butOK
			// 
			this.butOK.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.butOK.Location = new System.Drawing.Point(747, 457);
			this.butOK.Name = "butOK";
			this.butOK.Size = new System.Drawing.Size(75, 26);
			this.butOK.TabIndex = 3;
			this.butOK.Text = "&OK";
			this.butOK.Click += new System.EventHandler(this.butOK_Click);
			// 
			// listInsuranceTypes
			// 
			this.listInsuranceTypes.Location = new System.Drawing.Point(210, 285);
			this.listInsuranceTypes.Name = "listInsuranceTypes";
			this.listInsuranceTypes.SelectionMode = Helianz.UI.SelectionMode.MultiExtended;
			this.listInsuranceTypes.Size = new System.Drawing.Size(163, 186);
			this.listInsuranceTypes.TabIndex = 55;
			// 
			// checkAllClaimPayGroups
			// 
			this.checkAllClaimPayGroups.Checked = true;
			this.checkAllClaimPayGroups.CheckState = System.Windows.Forms.CheckState.Checked;
			this.checkAllClaimPayGroups.Location = new System.Drawing.Point(551, 263);
			this.checkAllClaimPayGroups.Name = "checkAllClaimPayGroups";
			this.checkAllClaimPayGroups.Size = new System.Drawing.Size(166, 16);
			this.checkAllClaimPayGroups.TabIndex = 58;
			this.checkAllClaimPayGroups.Text = "All claim payment groups";
			this.checkAllClaimPayGroups.Click += new System.EventHandler(this.checkAllClaimPayGroups_Click);
			// 
			// listClaimPayGroups
			// 
			this.listClaimPayGroups.Location = new System.Drawing.Point(551, 285);
			this.listClaimPayGroups.Name = "listClaimPayGroups";
			this.listClaimPayGroups.SelectionMode = Helianz.UI.SelectionMode.MultiExtended;
			this.listClaimPayGroups.Size = new System.Drawing.Size(163, 186);
			this.listClaimPayGroups.TabIndex = 57;
			// 
			// checkUnearned
			// 
			this.checkUnearned.Checked = true;
			this.checkUnearned.CheckState = System.Windows.Forms.CheckState.Checked;
			this.checkUnearned.Location = new System.Drawing.Point(535, 35);
			this.checkUnearned.Name = "checkUnearned";
			this.checkUnearned.Size = new System.Drawing.Size(118, 16);
			this.checkUnearned.TabIndex = 59;
			this.checkUnearned.Text = "Include Unearned";
			// 
			// checkReportDisplayUnearnedTP
			// 
			this.checkReportDisplayUnearnedTP.CheckAlign = System.Drawing.ContentAlignment.TopLeft;
			this.checkReportDisplayUnearnedTP.Location = new System.Drawing.Point(26, 370);
			this.checkReportDisplayUnearnedTP.Name = "checkReportDisplayUnearnedTP";
			this.checkReportDisplayUnearnedTP.Size = new System.Drawing.Size(159, 30);
			this.checkReportDisplayUnearnedTP.TabIndex = 60;
			this.checkReportDisplayUnearnedTP.Text = "Include hidden treatment planned prepayments";
			// 
			// checkShowOnlinePatientPaymentsSeparately
			// 
			this.checkShowOnlinePatientPaymentsSeparately.CheckAlign = System.Drawing.ContentAlignment.TopLeft;
			this.checkShowOnlinePatientPaymentsSeparately.Location = new System.Drawing.Point(26, 406);
			this.checkShowOnlinePatientPaymentsSeparately.Name = "checkShowOnlinePatientPaymentsSeparately";
			this.checkShowOnlinePatientPaymentsSeparately.Size = new System.Drawing.Size(159, 30);
			this.checkShowOnlinePatientPaymentsSeparately.TabIndex = 61;
			this.checkShowOnlinePatientPaymentsSeparately.Text = "Show online patient payments separately";
			// 
			// checkShowCareCreditFees
			// 
			this.checkShowCareCreditFees.CheckAlign = System.Drawing.ContentAlignment.TopLeft;
			this.checkShowCareCreditFees.Location = new System.Drawing.Point(26, 442);
			this.checkShowCareCreditFees.Name = "checkShowCareCreditFees";
			this.checkShowCareCreditFees.Size = new System.Drawing.Size(159, 18);
			this.checkShowCareCreditFees.TabIndex = 62;
			this.checkShowCareCreditFees.Text = "Show CareCredit fees";
			// 
			// checkShowPayConnectFees
			// 
			this.checkShowPayConnectFees.CheckAlign = System.Drawing.ContentAlignment.TopLeft;
			this.checkShowPayConnectFees.Location = new System.Drawing.Point(26, 465);
			this.checkShowPayConnectFees.Name = "checkShowPayConnectFees";
			this.checkShowPayConnectFees.Size = new System.Drawing.Size(159, 18);
			this.checkShowPayConnectFees.TabIndex = 63;
			this.checkShowPayConnectFees.Text = "Show PayConnect fees";
			// 
			// FormRpPaySheet
			// 
			this.ClientSize = new System.Drawing.Size(844, 507);
			this.Controls.Add(this.checkShowPayConnectFees);
			this.Controls.Add(this.checkShowCareCreditFees);
			this.Controls.Add(this.checkShowOnlinePatientPaymentsSeparately);
			this.Controls.Add(this.checkReportDisplayUnearnedTP);
			this.Controls.Add(this.checkUnearned);
			this.Controls.Add(this.checkAllClaimPayGroups);
			this.Controls.Add(this.listClaimPayGroups);
			this.Controls.Add(this.listInsuranceTypes);
			this.Controls.Add(this.checkAllClin);
			this.Controls.Add(this.listClin);
			this.Controls.Add(this.labelClin);
			this.Controls.Add(this.checkInsuranceTypes);
			this.Controls.Add(this.checkPatientTypes);
			this.Controls.Add(this.listPatientTypes);
			this.Controls.Add(this.groupBox1);
			this.Controls.Add(this.checkAllProv);
			this.Controls.Add(this.listProv);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.butOK);
			this.Controls.Add(this.date2);
			this.Controls.Add(this.date1);
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "FormRpPaySheet";
			this.ShowInTaskbar = false;
			this.Text = "Daily Payments Report";
			this.Load += new System.EventHandler(this.FormPaymentSheet_Load);
			this.groupBox1.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion
		private Helianz.UI.Button butOK;
		private System.Windows.Forms.MonthCalendar date2;
		private System.Windows.Forms.MonthCalendar date1;
		private Helianz.UI.ListBox listProv;
		private Label label1;
		private Helianz.UI.GroupBox groupBox1;
		private RadioButton radioPatient;
		private RadioButton radioCheck;
		private Helianz.UI.CheckBox checkPatientTypes;
		private Helianz.UI.ListBox listPatientTypes;
		private Helianz.UI.CheckBox checkInsuranceTypes;
		private Helianz.UI.CheckBox checkAllClin;
		private Helianz.UI.ListBox listClin;
		private Label labelClin;
		private Helianz.UI.ListBox listInsuranceTypes;
		private Helianz.UI.CheckBox checkAllProv;
		private Helianz.UI.CheckBox checkAllClaimPayGroups;
		private Helianz.UI.ListBox listClaimPayGroups;
		private Helianz.UI.CheckBox checkUnearned;
		private Helianz.UI.CheckBox checkShowProvSeparate;
		private Helianz.UI.CheckBox checkReportDisplayUnearnedTP;
		private UI.CheckBox checkShowOnlinePatientPaymentsSeparately;
		private UI.CheckBox checkShowCareCreditFees;
		private UI.CheckBox checkShowPayConnectFees;
	}
}
