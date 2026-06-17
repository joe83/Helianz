namespace Helianz {
	partial class FormSupplyInventoryS {
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
			this.comboSupplier = new Helianz.UI.ComboBox();
			this.labelSupplier = new System.Windows.Forms.Label();
			this.textFind = new System.Windows.Forms.TextBox();
			this.labelFind = new System.Windows.Forms.Label();
			this.butRefresh = new Helianz.UI.Button();
			this.gridSupplyMain = new Helianz.UI.GridOD();
			this.butOK = new Helianz.UI.Button();
			this.textQty = new System.Windows.Forms.TextBox();
			this.textPrice = new System.Windows.Forms.TextBox();
			this.textProduct = new System.Windows.Forms.TextBox();
			this.SuspendLayout();
			//
			// comboSupplier
			//
			this.comboSupplier.Location = new System.Drawing.Point(92, 20);
			this.comboSupplier.Name = "comboSupplier";
			this.comboSupplier.Size = new System.Drawing.Size(200, 21);
			this.comboSupplier.TabIndex = 0;
			this.comboSupplier.SelectionChangeCommitted += new System.EventHandler(this.comboSupplier_SelectionChangeCommitted);
			//
			// labelSupplier
			//
			this.labelSupplier.Location = new System.Drawing.Point(11, 23);
			this.labelSupplier.Name = "labelSupplier";
			this.labelSupplier.Size = new System.Drawing.Size(75, 18);
			this.labelSupplier.TabIndex = 1;
			this.labelSupplier.Text = "Supplier";
			this.labelSupplier.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// textFind
			//
			this.textFind.Location = new System.Drawing.Point(450, 20);
			this.textFind.Name = "textFind";
			this.textFind.Size = new System.Drawing.Size(153, 20);
			this.textFind.TabIndex = 2;
			this.textFind.KeyDown += new System.Windows.Forms.KeyEventHandler(this.textFind_KeyDown);
			//
			// labelFind
			//
			this.labelFind.Location = new System.Drawing.Point(399, 22);
			this.labelFind.Name = "labelFind";
			this.labelFind.Size = new System.Drawing.Size(50, 18);
			this.labelFind.TabIndex = 3;
			this.labelFind.Text = "Find";
			this.labelFind.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			//
			// butRefresh
			//
			this.butRefresh.Location = new System.Drawing.Point(608, 19);
			this.butRefresh.Name = "butRefresh";
			this.butRefresh.Size = new System.Drawing.Size(64, 24);
			this.butRefresh.TabIndex = 4;
			this.butRefresh.Text = "Refresh";
			this.butRefresh.Click += new System.EventHandler(this.butRefresh_Click);
			//
			// gridSupplyMain
			//
			this.gridSupplyMain.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
			| System.Windows.Forms.AnchorStyles.Left)
			| System.Windows.Forms.AnchorStyles.Right)));
			this.gridSupplyMain.Location = new System.Drawing.Point(12, 55);
			this.gridSupplyMain.Name = "gridSupplyMain";
			this.gridSupplyMain.ScrollValue = 0;
			this.gridSupplyMain.SelectionMode = Helianz.UI.GridSelectionMode.OneRow;
			this.gridSupplyMain.Size = new System.Drawing.Size(758, 372);
			this.gridSupplyMain.TabIndex = 5;
			this.gridSupplyMain.Title = "Supplies";
			this.gridSupplyMain.TranslationName = "TableSupplies";
			this.gridSupplyMain.CellDoubleClick += new Helianz.UI.ODGridClickEventHandler(this.gridSupplyMain_CellDoubleClick);
			//
			// butOK
			//
			this.butOK.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.butOK.Location = new System.Drawing.Point(695, 438);
			this.butOK.Name = "butOK";
			this.butOK.Size = new System.Drawing.Size(75, 26);
			this.butOK.TabIndex = 6;
			this.butOK.Text = "OK";
			this.butOK.Click += new System.EventHandler(this.butOK_Click);
			//
			// textQty
			//
			this.textQty.Location = new System.Drawing.Point(400, 438);
			this.textQty.Name = "textQty";
			this.textQty.Size = new System.Drawing.Size(100, 20);
			this.textQty.TabIndex = 7;
			this.textQty.Visible = false;
			//
			// textPrice
			//
			this.textPrice.Location = new System.Drawing.Point(510, 438);
			this.textPrice.Name = "textPrice";
			this.textPrice.Size = new System.Drawing.Size(100, 20);
			this.textPrice.TabIndex = 8;
			this.textPrice.Visible = false;
			//
			// textProduct
			//
			this.textProduct.Location = new System.Drawing.Point(400, 464);
			this.textProduct.Name = "textProduct";
			this.textProduct.Size = new System.Drawing.Size(272, 20);
			this.textProduct.TabIndex = 9;
			this.textProduct.Visible = false;
			//
			// FormSupplyInventoryS
			//
			this.ClientSize = new System.Drawing.Size(782, 476);
			this.Controls.Add(this.textProduct);
			this.Controls.Add(this.textPrice);
			this.Controls.Add(this.textQty);
			this.Controls.Add(this.butOK);
			this.Controls.Add(this.gridSupplyMain);
			this.Controls.Add(this.butRefresh);
			this.Controls.Add(this.labelFind);
			this.Controls.Add(this.textFind);
			this.Controls.Add(this.labelSupplier);
			this.Controls.Add(this.comboSupplier);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "FormSupplyInventoryS";
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "Stock";
			this.Load += new System.EventHandler(this.FormSupplyInventoryS_Load);
			this.ResumeLayout(false);
			this.PerformLayout();
		}

		#endregion

		private UI.ComboBox comboSupplier;
		private System.Windows.Forms.Label labelSupplier;
		private System.Windows.Forms.TextBox textFind;
		private System.Windows.Forms.Label labelFind;
		private UI.Button butRefresh;
		private UI.GridOD gridSupplyMain;
		private UI.Button butOK;
		private System.Windows.Forms.TextBox textQty;
		private System.Windows.Forms.TextBox textPrice;
		private System.Windows.Forms.TextBox textProduct;
	}
}
