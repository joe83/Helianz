namespace Helianz {
	partial class FormPdfViewer {
		private System.ComponentModel.IContainer components = null;

		protected override void Dispose(bool disposing) {
			if(disposing && (components != null)) {
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows Form Designer generated code

		private void InitializeComponent() {
			System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FormPdfViewer));
			this.panelBottom = new System.Windows.Forms.Panel();
			this.lblFallback = new System.Windows.Forms.Label();
			this.butOpenExternal = new Helianz.UI.Button();
			this.butWhatsApp = new Helianz.UI.Button();
			this.butSaveFile = new Helianz.UI.Button();
			this.butPrint = new Helianz.UI.Button();
			this.butClose = new Helianz.UI.Button();
			this.panelViewer = new System.Windows.Forms.Panel();
			this._odWebView2 = new CodeBase.Controls.ODWebView2();
			this.panelBottom.SuspendLayout();
			this.panelViewer.SuspendLayout();
			this.SuspendLayout();
			// 
			// panelBottom
			// 
			this.panelBottom.Controls.Add(this.lblFallback);
			this.panelBottom.Controls.Add(this.butOpenExternal);
			this.panelBottom.Controls.Add(this.butWhatsApp);
			this.panelBottom.Controls.Add(this.butSaveFile);
			this.panelBottom.Controls.Add(this.butPrint);
			this.panelBottom.Controls.Add(this.butClose);
			this.panelBottom.Dock = System.Windows.Forms.DockStyle.Bottom;
			this.panelBottom.Location = new System.Drawing.Point(0, 680);
			this.panelBottom.Name = "panelBottom";
			this.panelBottom.Size = new System.Drawing.Size(980, 50);
			this.panelBottom.TabIndex = 0;
			// 
			// lblFallback
			// 
			this.lblFallback.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
			this.lblFallback.ForeColor = System.Drawing.Color.DarkRed;
			this.lblFallback.Location = new System.Drawing.Point(400, 12);
			this.lblFallback.Name = "lblFallback";
			this.lblFallback.Size = new System.Drawing.Size(460, 26);
			this.lblFallback.TabIndex = 5;
			this.lblFallback.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
			this.lblFallback.Visible = false;
			// 
			// butOpenExternal
			// 
			this.butOpenExternal.Location = new System.Drawing.Point(375, 12);
			this.butOpenExternal.Name = "butOpenExternal";
			this.butOpenExternal.Size = new System.Drawing.Size(100, 26);
			this.butOpenExternal.TabIndex = 4;
			this.butOpenExternal.Text = "Open External";
			this.butOpenExternal.UseVisualStyleBackColor = true;
			this.butOpenExternal.Visible = false;
			this.butOpenExternal.Click += new System.EventHandler(this.butOpenExternal_Click);
			// 
			// butWhatsApp
			// 
			this.butWhatsApp.Location = new System.Drawing.Point(220, 12);
			this.butWhatsApp.Name = "butWhatsApp";
			this.butWhatsApp.Size = new System.Drawing.Size(140, 26);
			this.butWhatsApp.TabIndex = 3;
			this.butWhatsApp.Text = "Share WhatsApp";
			this.butWhatsApp.UseVisualStyleBackColor = true;
			this.butWhatsApp.Click += new System.EventHandler(this.butWhatsApp_Click);
			// 
			// butSaveFile
			// 
			this.butSaveFile.Location = new System.Drawing.Point(110, 12);
			this.butSaveFile.Name = "butSaveFile";
			this.butSaveFile.Size = new System.Drawing.Size(95, 26);
			this.butSaveFile.TabIndex = 2;
			this.butSaveFile.Text = "Save to File";
			this.butSaveFile.UseVisualStyleBackColor = true;
			this.butSaveFile.Click += new System.EventHandler(this.butSaveFile_Click);
			// 
			// butPrint
			// 
			this.butPrint.Location = new System.Drawing.Point(15, 12);
			this.butPrint.Name = "butPrint";
			this.butPrint.Size = new System.Drawing.Size(85, 26);
			this.butPrint.TabIndex = 1;
			this.butPrint.Text = "Print";
			this.butPrint.UseVisualStyleBackColor = true;
			this.butPrint.Click += new System.EventHandler(this.butPrint_Click);
			// 
			// butClose
			// 
			this.butClose.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
			this.butClose.Location = new System.Drawing.Point(880, 12);
			this.butClose.Name = "butClose";
			this.butClose.Size = new System.Drawing.Size(85, 26);
			this.butClose.TabIndex = 0;
			this.butClose.Text = "Close";
			this.butClose.UseVisualStyleBackColor = true;
			this.butClose.Click += new System.EventHandler(this.butClose_Click);
			// 
			// panelViewer
			// 
			this.panelViewer.Controls.Add(this._odWebView2);
			this.panelViewer.Dock = System.Windows.Forms.DockStyle.Fill;
			this.panelViewer.Location = new System.Drawing.Point(0, 0);
			this.panelViewer.Name = "panelViewer";
			this.panelViewer.Size = new System.Drawing.Size(980, 680);
			this.panelViewer.TabIndex = 1;
			// 
			// _odWebView2
			// 
			this._odWebView2.Dock = System.Windows.Forms.DockStyle.Fill;
			this._odWebView2.Location = new System.Drawing.Point(0, 0);
			this._odWebView2.Name = "_odWebView2";
			this._odWebView2.Size = new System.Drawing.Size(980, 680);
			this._odWebView2.TabIndex = 0;
			// 
			// FormPdfViewer
			// 
			this.ClientSize = new System.Drawing.Size(980, 730);
			this.Controls.Add(this.panelViewer);
			this.Controls.Add(this.panelBottom);
			this.MinimumSize = new System.Drawing.Size(650, 450);
			this.Name = "FormPdfViewer";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "Statement Preview";
			this.Load += new System.EventHandler(this.FormPdfViewer_Load);
			this.panelBottom.ResumeLayout(false);
			this.panelViewer.ResumeLayout(false);
			this.ResumeLayout(false);

		}

		#endregion

		private System.Windows.Forms.Panel panelBottom;
		private Helianz.UI.Button butClose;
		private Helianz.UI.Button butPrint;
		private Helianz.UI.Button butSaveFile;
		private Helianz.UI.Button butWhatsApp;
		private Helianz.UI.Button butOpenExternal;
		private System.Windows.Forms.Label lblFallback;
		private System.Windows.Forms.Panel panelViewer;
		private CodeBase.Controls.ODWebView2 _odWebView2;
	}
}
