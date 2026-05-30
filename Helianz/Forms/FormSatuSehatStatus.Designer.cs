namespace Helianz {
	partial class FormSatuSehatStatus {
		private System.ComponentModel.IContainer components = null;

		protected override void Dispose(bool disposing) {
			if(disposing && (components != null)) {
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows Form Designer generated code
		private void InitializeComponent() {
			this.gridMain = new Helianz.UI.GridOD();
			this.labelFilter = new System.Windows.Forms.Label();
			this.comboFilter = new Helianz.UI.ComboBox();
			this.butSyncNow = new Helianz.UI.Button();
			this.butSettings = new Helianz.UI.Button();
			this.butDemoData = new Helianz.UI.Button();
			this.butClearDemo = new Helianz.UI.Button();
			this.butClose = new Helianz.UI.Button();
			this.SuspendLayout();
			// 
			// gridMain
			// 
			this.gridMain.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
			| System.Windows.Forms.AnchorStyles.Left)
			| System.Windows.Forms.AnchorStyles.Right)));
			this.gridMain.HScrollVisible = true;
			this.gridMain.Location = new System.Drawing.Point(12, 40);
			this.gridMain.Name = "gridMain";
			this.gridMain.Size = new System.Drawing.Size(860, 520);
			this.gridMain.TabIndex = 0;
			this.gridMain.Title = "SatuSehat Sync Status";
			this.gridMain.TranslationName = "TableSatuSehatStatus";
			// 
			// labelFilter
			// 
			this.labelFilter.Location = new System.Drawing.Point(12, 12);
			this.labelFilter.Name = "labelFilter";
			this.labelFilter.Size = new System.Drawing.Size(50, 21);
			this.labelFilter.TabIndex = 0;
			this.labelFilter.Text = "Filter";
			this.labelFilter.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// comboFilter
			// 
			this.comboFilter.Location = new System.Drawing.Point(66, 12);
			this.comboFilter.Name = "comboFilter";
			this.comboFilter.Size = new System.Drawing.Size(130, 21);
			this.comboFilter.TabIndex = 1;
			this.comboFilter.SelectionChangeCommitted += new System.EventHandler(this.comboFilter_SelectionChangeCommitted);
			// 
			// butSyncNow
			// 
			this.butSyncNow.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
			this.butSyncNow.Location = new System.Drawing.Point(12, 570);
			this.butSyncNow.Name = "butSyncNow";
			this.butSyncNow.Size = new System.Drawing.Size(100, 24);
			this.butSyncNow.TabIndex = 2;
			this.butSyncNow.Text = "Sync Now";
			this.butSyncNow.Click += new System.EventHandler(this.butSyncNow_Click);
			// 
			// butSettings
			// 
			this.butSettings.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
			this.butSettings.Location = new System.Drawing.Point(120, 570);
			this.butSettings.Name = "butSettings";
			this.butSettings.Size = new System.Drawing.Size(75, 24);
			this.butSettings.TabIndex = 3;
			this.butSettings.Text = "Settings";
			this.butSettings.Click += new System.EventHandler(this.butSettings_Click);
			// 
			// butDemoData
			// 
			this.butDemoData.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
			this.butDemoData.Location = new System.Drawing.Point(203, 570);
			this.butDemoData.Name = "butDemoData";
			this.butDemoData.Size = new System.Drawing.Size(100, 24);
			this.butDemoData.TabIndex = 5;
			this.butDemoData.Text = "Create Demo";
			this.butDemoData.Click += new System.EventHandler(this.butDemoData_Click);
			// 
			// butClearDemo
			// 
			this.butClearDemo.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
			this.butClearDemo.Location = new System.Drawing.Point(311, 570);
			this.butClearDemo.Name = "butClearDemo";
			this.butClearDemo.Size = new System.Drawing.Size(100, 24);
			this.butClearDemo.TabIndex = 6;
			this.butClearDemo.Text = "Clear Demo";
			this.butClearDemo.Click += new System.EventHandler(this.butClearDemo_Click);
			// 
			// butClose
			// 
			this.butClose.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.butClose.Location = new System.Drawing.Point(797, 570);
			this.butClose.Name = "butClose";
			this.butClose.Size = new System.Drawing.Size(75, 24);
			this.butClose.TabIndex = 4;
			this.butClose.Text = "&Close";
			this.butClose.Click += new System.EventHandler(this.butClose_Click);
			// 
			// FormSatuSehatStatus
			// 
			this.ClientSize = new System.Drawing.Size(884, 606);
			this.Controls.Add(this.gridMain);
			this.Controls.Add(this.labelFilter);
			this.Controls.Add(this.comboFilter);
			this.Controls.Add(this.butSyncNow);
			this.Controls.Add(this.butSettings);
			this.Controls.Add(this.butDemoData);
			this.Controls.Add(this.butClearDemo);
			this.Controls.Add(this.butClose);
			this.Name = "FormSatuSehatStatus";
			this.Text = "SatuSehat Sync Status";
			this.Load += new System.EventHandler(this.FormSatuSehatStatus_Load);
			this.ResumeLayout(false);
		}
		#endregion

		private Helianz.UI.GridOD gridMain;
		private System.Windows.Forms.Label labelFilter;
		private Helianz.UI.ComboBox comboFilter;
		private Helianz.UI.Button butSyncNow;
		private Helianz.UI.Button butSettings;
		private Helianz.UI.Button butDemoData;
		private Helianz.UI.Button butClearDemo;
		private Helianz.UI.Button butClose;
	}
}
