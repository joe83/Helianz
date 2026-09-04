using System;
using System.Collections.Generic;
using System.Windows.Forms;

namespace Helianz {
	public partial class FormRpPatientBalancesCredits {
		private System.ComponentModel.IContainer components = null;

		///<summary></summary>
		protected override void Dispose(bool disposing) {
			if(disposing && (components != null)) {
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows Form Designer generated code
		private void InitializeComponent() {
			this.components = new System.ComponentModel.Container();
			System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FormRpPatientBalancesCredits));
			this.labelStatus = new System.Windows.Forms.Label();
			this.comboStatus = new System.Windows.Forms.ComboBox();
			this.comboBoxClinicPicker = new Helianz.UI.ComboBoxClinicPicker();
			this.labelMinAmt = new System.Windows.Forms.Label();
			this.textMinAmt = new System.Windows.Forms.TextBox();
			this.checkGroupByFamily = new System.Windows.Forms.CheckBox();
			this.checkExcludeInactive = new System.Windows.Forms.CheckBox();
			this.butRefresh = new Helianz.UI.Button();
			this.gridOD = new Helianz.UI.GridOD();
			this.contextMenuStrip1 = new System.Windows.Forms.ContextMenuStrip(this.components);
			this.toolStripMenuItemSeeAccount = new System.Windows.Forms.ToolStripMenuItem();
			this.butPrint = new Helianz.UI.Button();
			this.butExport = new Helianz.UI.Button();
			this.butClose = new Helianz.UI.Button();
			this.labelTotals = new System.Windows.Forms.Label();
			this.contextMenuStrip1.SuspendLayout();
			this.SuspendLayout();
			// 
			// labelStatus
			// 
			this.labelStatus.Location = new System.Drawing.Point(12, 13);
			this.labelStatus.Name = "labelStatus";
			this.labelStatus.Size = new System.Drawing.Size(46, 18);
			this.labelStatus.TabIndex = 1;
			this.labelStatus.Text = "Status:";
			this.labelStatus.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// comboStatus
			// 
			this.comboStatus.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.comboStatus.FormattingEnabled = true;
			this.comboStatus.Location = new System.Drawing.Point(62, 12);
			this.comboStatus.Name = "comboStatus";
			this.comboStatus.Size = new System.Drawing.Size(175, 21);
			this.comboStatus.TabIndex = 2;
			// 
			// comboBoxClinicPicker
			// 
			this.comboBoxClinicPicker.IncludeAll = true;
			this.comboBoxClinicPicker.IncludeHiddenInAll = true;
			this.comboBoxClinicPicker.IncludeUnassigned = true;
			this.comboBoxClinicPicker.IsMultiSelect = true;
			this.comboBoxClinicPicker.Location = new System.Drawing.Point(245, 12);
			this.comboBoxClinicPicker.Name = "comboBoxClinicPicker";
			this.comboBoxClinicPicker.Size = new System.Drawing.Size(190, 21);
			this.comboBoxClinicPicker.TabIndex = 3;
			// 
			// labelMinAmt
			// 
			this.labelMinAmt.Location = new System.Drawing.Point(440, 13);
			this.labelMinAmt.Name = "labelMinAmt";
			this.labelMinAmt.Size = new System.Drawing.Size(55, 18);
			this.labelMinAmt.TabIndex = 4;
			this.labelMinAmt.Text = "Min $:";
			this.labelMinAmt.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// textMinAmt
			// 
			this.textMinAmt.Location = new System.Drawing.Point(498, 12);
			this.textMinAmt.Name = "textMinAmt";
			this.textMinAmt.Size = new System.Drawing.Size(55, 20);
			this.textMinAmt.TabIndex = 5;
			this.textMinAmt.Text = "0.01";
			// 
			// checkGroupByFamily
			// 
			this.checkGroupByFamily.Checked = true;
			this.checkGroupByFamily.CheckState = System.Windows.Forms.CheckState.Checked;
			this.checkGroupByFamily.Location = new System.Drawing.Point(565, 13);
			this.checkGroupByFamily.Name = "checkGroupByFamily";
			this.checkGroupByFamily.Size = new System.Drawing.Size(160, 20);
			this.checkGroupByFamily.TabIndex = 6;
			this.checkGroupByFamily.Text = "Group by Family (Guarantor)";
			this.checkGroupByFamily.UseVisualStyleBackColor = true;
			// 
			// checkExcludeInactive
			// 
			this.checkExcludeInactive.Checked = true;
			this.checkExcludeInactive.CheckState = System.Windows.Forms.CheckState.Checked;
			this.checkExcludeInactive.Location = new System.Drawing.Point(730, 13);
			this.checkExcludeInactive.Name = "checkExcludeInactive";
			this.checkExcludeInactive.Size = new System.Drawing.Size(120, 20);
			this.checkExcludeInactive.TabIndex = 7;
			this.checkExcludeInactive.Text = "Exclude Inactive";
			this.checkExcludeInactive.UseVisualStyleBackColor = true;
			// 
			// butRefresh
			// 
			this.butRefresh.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
			this.butRefresh.Location = new System.Drawing.Point(895, 10);
			this.butRefresh.Name = "butRefresh";
			this.butRefresh.Size = new System.Drawing.Size(75, 24);
			this.butRefresh.TabIndex = 8;
			this.butRefresh.Text = "&Refresh";
			this.butRefresh.Click += new System.EventHandler(this.butRefresh_Click);
			// 
			// gridOD
			// 
			this.gridOD.AllowSortingByColumn = true;
			this.gridOD.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
			this.gridOD.ContextMenuStrip = this.contextMenuStrip1;
			this.gridOD.Location = new System.Drawing.Point(12, 42);
			this.gridOD.Name = "gridOD";
			this.gridOD.Size = new System.Drawing.Size(958, 480);
			this.gridOD.TabIndex = 9;
			this.gridOD.TitleVisible = false;
			this.gridOD.TranslationName = "TableReport";
			this.gridOD.CellDoubleClick += new Helianz.UI.ODGridClickEventHandler(this.gridOD_CellDoubleClick);
			// 
			// contextMenuStrip1
			// 
			this.contextMenuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripMenuItemSeeAccount});
			this.contextMenuStrip1.Name = "contextMenuStrip1";
			this.contextMenuStrip1.Size = new System.Drawing.Size(141, 26);
			// 
			// toolStripMenuItemSeeAccount
			// 
			this.toolStripMenuItemSeeAccount.Name = "toolStripMenuItemSeeAccount";
			this.toolStripMenuItemSeeAccount.Size = new System.Drawing.Size(140, 22);
			this.toolStripMenuItemSeeAccount.Text = "See Account";
			this.toolStripMenuItemSeeAccount.Click += new System.EventHandler(this.menuItemAccount_Click);
			// 
			// butPrint
			// 
			this.butPrint.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
			this.butPrint.Location = new System.Drawing.Point(12, 532);
			this.butPrint.Name = "butPrint";
			this.butPrint.Size = new System.Drawing.Size(75, 24);
			this.butPrint.TabIndex = 10;
			this.butPrint.Text = "&Print";
			this.butPrint.Click += new System.EventHandler(this.butPrint_Click);
			// 
			// butExport
			// 
			this.butExport.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
			this.butExport.Location = new System.Drawing.Point(95, 532);
			this.butExport.Name = "butExport";
			this.butExport.Size = new System.Drawing.Size(75, 24);
			this.butExport.TabIndex = 11;
			this.butExport.Text = "&Export";
			this.butExport.Click += new System.EventHandler(this.butExport_Click);
			// 
			// butClose
			// 
			this.butClose.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.butClose.Location = new System.Drawing.Point(895, 532);
			this.butClose.Name = "butClose";
			this.butClose.Size = new System.Drawing.Size(75, 24);
			this.butClose.TabIndex = 12;
			this.butClose.Text = "&Close";
			this.butClose.Click += new System.EventHandler(this.butClose_Click);
			// 
			// labelTotals
			// 
			this.labelTotals.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
			this.labelTotals.Location = new System.Drawing.Point(180, 534);
			this.labelTotals.Name = "labelTotals";
			this.labelTotals.Size = new System.Drawing.Size(700, 20);
			this.labelTotals.TabIndex = 13;
			this.labelTotals.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// FormRpPatientBalancesCredits
			// 
			this.ClientSize = new System.Drawing.Size(1024, 580);
			this.Controls.Add(this.labelTotals);
			this.Controls.Add(this.butClose);
			this.Controls.Add(this.butExport);
			this.Controls.Add(this.butPrint);
			this.Controls.Add(this.gridOD);
			this.Controls.Add(this.butRefresh);
			this.Controls.Add(this.checkExcludeInactive);
			this.Controls.Add(this.checkGroupByFamily);
			this.Controls.Add(this.textMinAmt);
			this.Controls.Add(this.labelMinAmt);
			this.Controls.Add(this.comboBoxClinicPicker);
			this.Controls.Add(this.comboStatus);
			this.Controls.Add(this.labelStatus);
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.MinimumSize = new System.Drawing.Size(800, 500);
			this.Name = "FormRpPatientBalancesCredits";
			this.Text = "Patient Balances and Credits Report";
			this.Load += new System.EventHandler(this.FormRpPatientBalancesCredits_Load);
			this.contextMenuStrip1.ResumeLayout(false);
			this.ResumeLayout(false);
			this.PerformLayout();

		}
		#endregion

		private System.Windows.Forms.Label labelStatus;
		private System.Windows.Forms.ComboBox comboStatus;
		private UI.ComboBoxClinicPicker comboBoxClinicPicker;
		private System.Windows.Forms.Label labelMinAmt;
		private System.Windows.Forms.TextBox textMinAmt;
		private System.Windows.Forms.CheckBox checkGroupByFamily;
		private System.Windows.Forms.CheckBox checkExcludeInactive;
		private UI.Button butRefresh;
		private UI.GridOD gridOD;
		private System.Windows.Forms.ContextMenuStrip contextMenuStrip1;
		private System.Windows.Forms.ToolStripMenuItem toolStripMenuItemSeeAccount;
		private UI.Button butPrint;
		private UI.Button butExport;
		private UI.Button butClose;
		private System.Windows.Forms.Label labelTotals;
	}
}
