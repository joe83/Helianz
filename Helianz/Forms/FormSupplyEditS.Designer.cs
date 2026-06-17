namespace Helianz {
	partial class FormSupplyEditS {
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
			this.textSupplier = new System.Windows.Forms.TextBox();
			this.labelSupplier = new System.Windows.Forms.Label();
			this.comboCategory = new Helianz.UI.ComboBox();
			this.labelCategory = new System.Windows.Forms.Label();
			this.textCatalogNumber = new System.Windows.Forms.TextBox();
			this.labelCatalog = new System.Windows.Forms.Label();
			this.textDescript = new System.Windows.Forms.TextBox();
			this.labelDescript = new System.Windows.Forms.Label();
			this.textLevelDesired = new Helianz.ValidDouble();
			this.labelStockQty = new System.Windows.Forms.Label();
			this.textPrice = new Helianz.ValidDouble();
			this.labelPrice = new System.Windows.Forms.Label();
			this.textSub = new Helianz.ValidDouble();
			this.labelSub = new System.Windows.Forms.Label();
			this.butOK = new Helianz.UI.Button();
			this.butCancel = new Helianz.UI.Button();
			this.SuspendLayout();
			//
			// textSupplier
			//
			this.textSupplier.Location = new System.Drawing.Point(178, 18);
			this.textSupplier.Name = "textSupplier";
			this.textSupplier.ReadOnly = true;
			this.textSupplier.Size = new System.Drawing.Size(295, 20);
			this.textSupplier.TabIndex = 0;
			//
			// labelSupplier
			//
			this.labelSupplier.Location = new System.Drawing.Point(43, 19);
			this.labelSupplier.Name = "labelSupplier";
			this.labelSupplier.Size = new System.Drawing.Size(132, 18);
			this.labelSupplier.TabIndex = 1;
			this.labelSupplier.Text = "Supplier";
			this.labelSupplier.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// comboCategory
			//
			this.comboCategory.Location = new System.Drawing.Point(178, 44);
			this.comboCategory.Name = "comboCategory";
			this.comboCategory.Size = new System.Drawing.Size(228, 21);
			this.comboCategory.TabIndex = 2;
			//
			// labelCategory
			//
			this.labelCategory.Location = new System.Drawing.Point(43, 45);
			this.labelCategory.Name = "labelCategory";
			this.labelCategory.Size = new System.Drawing.Size(132, 18);
			this.labelCategory.TabIndex = 3;
			this.labelCategory.Text = "Category";
			this.labelCategory.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textCatalogNumber
			//
			this.textCatalogNumber.Location = new System.Drawing.Point(178, 71);
			this.textCatalogNumber.Name = "textCatalogNumber";
			this.textCatalogNumber.ReadOnly = true;
			this.textCatalogNumber.Size = new System.Drawing.Size(144, 20);
			this.textCatalogNumber.TabIndex = 4;
			//
			// labelCatalog
			//
			this.labelCatalog.Location = new System.Drawing.Point(19, 72);
			this.labelCatalog.Name = "labelCatalog";
			this.labelCatalog.Size = new System.Drawing.Size(156, 18);
			this.labelCatalog.TabIndex = 5;
			this.labelCatalog.Text = "Catalog Item Number";
			this.labelCatalog.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textDescript
			//
			this.textDescript.Location = new System.Drawing.Point(178, 97);
			this.textDescript.MaxLength = 255;
			this.textDescript.Name = "textDescript";
			this.textDescript.ReadOnly = true;
			this.textDescript.Size = new System.Drawing.Size(401, 20);
			this.textDescript.TabIndex = 6;
			//
			// labelDescript
			//
			this.labelDescript.Location = new System.Drawing.Point(18, 98);
			this.labelDescript.Name = "labelDescript";
			this.labelDescript.Size = new System.Drawing.Size(157, 18);
			this.labelDescript.TabIndex = 7;
			this.labelDescript.Text = "Description";
			this.labelDescript.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textLevelDesired
			//
			this.textLevelDesired.BackColor = System.Drawing.SystemColors.Window;
			this.textLevelDesired.Enabled = false;
			this.textLevelDesired.ForeColor = System.Drawing.SystemColors.WindowText;
			this.textLevelDesired.Location = new System.Drawing.Point(178, 123);
			this.textLevelDesired.MaxVal = 100000000D;
			this.textLevelDesired.MinVal = -100000000D;
			this.textLevelDesired.Name = "textLevelDesired";
			this.textLevelDesired.Size = new System.Drawing.Size(62, 20);
			this.textLevelDesired.TabIndex = 8;
			//
			// labelStockQty
			//
			this.labelStockQty.Location = new System.Drawing.Point(44, 123);
			this.labelStockQty.Name = "labelStockQty";
			this.labelStockQty.Size = new System.Drawing.Size(132, 18);
			this.labelStockQty.TabIndex = 9;
			this.labelStockQty.Text = "Stock Quantity";
			this.labelStockQty.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textPrice
			//
			this.textPrice.BackColor = System.Drawing.SystemColors.Window;
			this.textPrice.Enabled = false;
			this.textPrice.ForeColor = System.Drawing.SystemColors.WindowText;
			this.textPrice.Location = new System.Drawing.Point(178, 149);
			this.textPrice.MaxVal = 100000000D;
			this.textPrice.MinVal = -100000000D;
			this.textPrice.Name = "textPrice";
			this.textPrice.Size = new System.Drawing.Size(80, 20);
			this.textPrice.TabIndex = 10;
			//
			// labelPrice
			//
			this.labelPrice.Location = new System.Drawing.Point(44, 149);
			this.labelPrice.Name = "labelPrice";
			this.labelPrice.Size = new System.Drawing.Size(132, 18);
			this.labelPrice.TabIndex = 11;
			this.labelPrice.Text = "Price";
			this.labelPrice.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textSub
			//
			this.textSub.BackColor = System.Drawing.SystemColors.Window;
			this.textSub.ForeColor = System.Drawing.SystemColors.WindowText;
			this.textSub.Location = new System.Drawing.Point(178, 198);
			this.textSub.MaxVal = 100000000D;
			this.textSub.MinVal = -100000000D;
			this.textSub.Name = "textSub";
			this.textSub.Size = new System.Drawing.Size(62, 20);
			this.textSub.TabIndex = 12;
			this.textSub.Text = "0";
			this.textSub.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
			//
			// labelSub
			//
			this.labelSub.Location = new System.Drawing.Point(100, 198);
			this.labelSub.Name = "labelSub";
			this.labelSub.Size = new System.Drawing.Size(72, 18);
			this.labelSub.TabIndex = 13;
			this.labelSub.Text = "Sub";
			this.labelSub.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// butOK
			//
			this.butOK.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.butOK.Location = new System.Drawing.Point(594, 189);
			this.butOK.Name = "butOK";
			this.butOK.Size = new System.Drawing.Size(75, 26);
			this.butOK.TabIndex = 14;
			this.butOK.Text = "&OK";
			this.butOK.Click += new System.EventHandler(this.butOK_Click);
			//
			// butCancel
			//
			this.butCancel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.butCancel.Location = new System.Drawing.Point(594, 230);
			this.butCancel.Name = "butCancel";
			this.butCancel.Size = new System.Drawing.Size(75, 26);
			this.butCancel.TabIndex = 15;
			this.butCancel.Text = "&Cancel";
			this.butCancel.Click += new System.EventHandler(this.butCancel_Click);
			//
			// FormSupplyEditS
			//
			this.ClientSize = new System.Drawing.Size(686, 275);
			this.Controls.Add(this.butCancel);
			this.Controls.Add(this.butOK);
			this.Controls.Add(this.labelSub);
			this.Controls.Add(this.textSub);
			this.Controls.Add(this.labelPrice);
			this.Controls.Add(this.textPrice);
			this.Controls.Add(this.labelStockQty);
			this.Controls.Add(this.textLevelDesired);
			this.Controls.Add(this.labelDescript);
			this.Controls.Add(this.textDescript);
			this.Controls.Add(this.labelCatalog);
			this.Controls.Add(this.textCatalogNumber);
			this.Controls.Add(this.labelCategory);
			this.Controls.Add(this.comboCategory);
			this.Controls.Add(this.labelSupplier);
			this.Controls.Add(this.textSupplier);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "FormSupplyEditS";
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "Stock Sub";
			this.Load += new System.EventHandler(this.FormSupplyEditS_Load);
			this.ResumeLayout(false);
			this.PerformLayout();
		}

		#endregion

		private System.Windows.Forms.TextBox textSupplier;
		private System.Windows.Forms.Label labelSupplier;
		private UI.ComboBox comboCategory;
		private System.Windows.Forms.Label labelCategory;
		private System.Windows.Forms.TextBox textCatalogNumber;
		private System.Windows.Forms.Label labelCatalog;
		private System.Windows.Forms.TextBox textDescript;
		private System.Windows.Forms.Label labelDescript;
		private ValidDouble textLevelDesired;
		private System.Windows.Forms.Label labelStockQty;
		private ValidDouble textPrice;
		private System.Windows.Forms.Label labelPrice;
		private ValidDouble textSub;
		private System.Windows.Forms.Label labelSub;
		private UI.Button butOK;
		private UI.Button butCancel;
	}
}
