namespace Helianz {
	partial class FormProcShareFix {
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
			System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FormProcShareFix));
			this.groupCriteria = new Helianz.UI.GroupBox();
			this.dateRangePicker = new Helianz.UI.ODDateRangePicker();
			this.butThisMonth = new Helianz.UI.Button();
			this.butLastMonth = new Helianz.UI.Button();
			this.butToday = new Helianz.UI.Button();
			this.labelClinic = new System.Windows.Forms.Label();
			this.comboClinic = new Helianz.UI.ComboBoxClinicPicker();
			this.labelProvider = new System.Windows.Forms.Label();
			this.comboProvider = new Helianz.UI.ComboBox();
			this.butScan = new Helianz.UI.Button();
			this.gridMain = new Helianz.UI.GridOD();
			this.butSelectAll = new Helianz.UI.Button();
			this.butDeselectAll = new Helianz.UI.Button();
			this.labelSummary = new System.Windows.Forms.Label();
			this.butFix = new Helianz.UI.Button();
			this.butClose = new Helianz.UI.Button();
			this.groupCriteria.SuspendLayout();
			this.SuspendLayout();
			// 
			// groupCriteria
			// 
			this.groupCriteria.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
			this.groupCriteria.Controls.Add(this.dateRangePicker);
			this.groupCriteria.Controls.Add(this.butThisMonth);
			this.groupCriteria.Controls.Add(this.butLastMonth);
			this.groupCriteria.Controls.Add(this.butToday);
			this.groupCriteria.Controls.Add(this.labelClinic);
			this.groupCriteria.Controls.Add(this.comboClinic);
			this.groupCriteria.Controls.Add(this.labelProvider);
			this.groupCriteria.Controls.Add(this.comboProvider);
			this.groupCriteria.Controls.Add(this.butScan);
			this.groupCriteria.Location = new System.Drawing.Point(12, 8);
			this.groupCriteria.Name = "groupCriteria";
			this.groupCriteria.Size = new System.Drawing.Size(1030, 85);
			this.groupCriteria.TabIndex = 0;
			this.groupCriteria.TabStop = false;
			this.groupCriteria.Text = "Filter Criteria";
			// 
			// dateRangePicker
			// 
			this.dateRangePicker.BackColor = System.Drawing.SystemColors.Control;
			this.dateRangePicker.EnableWeekButtons = false;
			this.dateRangePicker.IsVertical = false;
			this.dateRangePicker.Location = new System.Drawing.Point(10, 18);
			this.dateRangePicker.Name = "dateRangePicker";
			this.dateRangePicker.Size = new System.Drawing.Size(445, 26);
			this.dateRangePicker.TabIndex = 1;
			// 
			// butThisMonth
			// 
			this.butThisMonth.Location = new System.Drawing.Point(10, 48);
			this.butThisMonth.Name = "butThisMonth";
			this.butThisMonth.Size = new System.Drawing.Size(75, 24);
			this.butThisMonth.TabIndex = 2;
			this.butThisMonth.Text = "This Month";
			this.butThisMonth.Click += new System.EventHandler(this.butThisMonth_Click);
			// 
			// butLastMonth
			// 
			this.butLastMonth.Location = new System.Drawing.Point(90, 48);
			this.butLastMonth.Name = "butLastMonth";
			this.butLastMonth.Size = new System.Drawing.Size(75, 24);
			this.butLastMonth.TabIndex = 3;
			this.butLastMonth.Text = "Last Month";
			this.butLastMonth.Click += new System.EventHandler(this.butLastMonth_Click);
			// 
			// butToday
			// 
			this.butToday.Location = new System.Drawing.Point(170, 48);
			this.butToday.Name = "butToday";
			this.butToday.Size = new System.Drawing.Size(65, 24);
			this.butToday.TabIndex = 4;
			this.butToday.Text = "Today";
			this.butToday.Click += new System.EventHandler(this.butToday_Click);
			// 
			// labelProvider
			// 
			this.labelProvider.Location = new System.Drawing.Point(465, 20);
			this.labelProvider.Name = "labelProvider";
			this.labelProvider.Size = new System.Drawing.Size(60, 20);
			this.labelProvider.TabIndex = 5;
			this.labelProvider.Text = "Provider";
			this.labelProvider.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// comboProvider
			// 
			this.comboProvider.Location = new System.Drawing.Point(530, 20);
			this.comboProvider.Name = "comboProvider";
			this.comboProvider.Size = new System.Drawing.Size(180, 21);
			this.comboProvider.TabIndex = 6;
			// 
			// labelClinic
			// 
			this.labelClinic.Location = new System.Drawing.Point(465, 48);
			this.labelClinic.Name = "labelClinic";
			this.labelClinic.Size = new System.Drawing.Size(60, 20);
			this.labelClinic.TabIndex = 7;
			this.labelClinic.Text = "Clinic";
			this.labelClinic.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// comboClinic
			// 
			this.comboClinic.IncludeAll = true;
			this.comboClinic.IncludeUnassigned = true;
			this.comboClinic.Location = new System.Drawing.Point(530, 48);
			this.comboClinic.Name = "comboClinic";
			this.comboClinic.Size = new System.Drawing.Size(180, 21);
			this.comboClinic.TabIndex = 8;
			// 
			// butScan
			// 
			this.butScan.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
			this.butScan.Location = new System.Drawing.Point(920, 24);
			this.butScan.Name = "butScan";
			this.butScan.Size = new System.Drawing.Size(95, 36);
			this.butScan.TabIndex = 9;
			this.butScan.Text = "&Scan";
			this.butScan.Click += new System.EventHandler(this.butScan_Click);
			// 
			// gridMain
			// 
			this.gridMain.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
			this.gridMain.Location = new System.Drawing.Point(12, 100);
			this.gridMain.Name = "gridMain";
			this.gridMain.SelectionMode = Helianz.UI.GridSelectionMode.MultiExtended;
			this.gridMain.Size = new System.Drawing.Size(1030, 430);
			this.gridMain.TabIndex = 10;
			this.gridMain.Title = "Procedures with Zero / Mismatched Doctor Shares";
			this.gridMain.TranslationName = "TableProcShareFix";
			// 
			// butSelectAll
			// 
			this.butSelectAll.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
			this.butSelectAll.Location = new System.Drawing.Point(12, 540);
			this.butSelectAll.Name = "butSelectAll";
			this.butSelectAll.Size = new System.Drawing.Size(85, 24);
			this.butSelectAll.TabIndex = 11;
			this.butSelectAll.Text = "Select All";
			this.butSelectAll.Click += new System.EventHandler(this.butSelectAll_Click);
			// 
			// butDeselectAll
			// 
			this.butDeselectAll.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
			this.butDeselectAll.Location = new System.Drawing.Point(103, 540);
			this.butDeselectAll.Name = "butDeselectAll";
			this.butDeselectAll.Size = new System.Drawing.Size(85, 24);
			this.butDeselectAll.TabIndex = 12;
			this.butDeselectAll.Text = "Deselect All";
			this.butDeselectAll.Click += new System.EventHandler(this.butDeselectAll_Click);
			// 
			// labelSummary
			// 
			this.labelSummary.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
			this.labelSummary.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.labelSummary.Location = new System.Drawing.Point(200, 540);
			this.labelSummary.Name = "labelSummary";
			this.labelSummary.Size = new System.Drawing.Size(590, 24);
			this.labelSummary.TabIndex = 13;
			this.labelSummary.Text = "Ready to scan.";
			this.labelSummary.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
			// 
			// butFix
			// 
			this.butFix.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.butFix.Enabled = false;
			this.butFix.Location = new System.Drawing.Point(820, 538);
			this.butFix.Name = "butFix";
			this.butFix.Size = new System.Drawing.Size(120, 26);
			this.butFix.TabIndex = 14;
			this.butFix.Text = "&Apply Share Fix";
			this.butFix.Click += new System.EventHandler(this.butFix_Click);
			// 
			// butClose
			// 
			this.butClose.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.butClose.Location = new System.Drawing.Point(955, 538);
			this.butClose.Name = "butClose";
			this.butClose.Size = new System.Drawing.Size(85, 26);
			this.butClose.TabIndex = 15;
			this.butClose.Text = "&Close";
			this.butClose.Click += new System.EventHandler(this.butClose_Click);
			// 
			// FormProcShareFix
			// 
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.None;
			this.ClientSize = new System.Drawing.Size(1054, 574);
			this.Controls.Add(this.butClose);
			this.Controls.Add(this.butFix);
			this.Controls.Add(this.labelSummary);
			this.Controls.Add(this.butDeselectAll);
			this.Controls.Add(this.butSelectAll);
			this.Controls.Add(this.gridMain);
			this.Controls.Add(this.groupCriteria);
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.MinimumSize = new System.Drawing.Size(800, 450);
			this.Name = "FormProcShareFix";
			this.Text = "Fix Procedure Doctor Shares";
			this.Load += new System.EventHandler(this.FormProcShareFix_Load);
			this.groupCriteria.ResumeLayout(false);
			this.ResumeLayout(false);

		}

		#endregion

		private Helianz.UI.GroupBox groupCriteria;
		private Helianz.UI.ODDateRangePicker dateRangePicker;
		private Helianz.UI.Button butThisMonth;
		private Helianz.UI.Button butLastMonth;
		private Helianz.UI.Button butToday;
		private System.Windows.Forms.Label labelClinic;
		private Helianz.UI.ComboBoxClinicPicker comboClinic;
		private System.Windows.Forms.Label labelProvider;
		private Helianz.UI.ComboBox comboProvider;
		private Helianz.UI.Button butScan;
		private Helianz.UI.GridOD gridMain;
		private Helianz.UI.Button butSelectAll;
		private Helianz.UI.Button butDeselectAll;
		private System.Windows.Forms.Label labelSummary;
		private Helianz.UI.Button butFix;
		private Helianz.UI.Button butClose;
	}
}
