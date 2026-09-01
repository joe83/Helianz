namespace Helianz {
	partial class FormIdriveS3Setup {
		private System.ComponentModel.IContainer components = null;

		protected override void Dispose(bool disposing) {
			if(disposing && (components != null)) {
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows Form Designer generated code

		private void InitializeComponent() {
			System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FormIdriveS3Setup));
			this.checkEnable = new Helianz.UI.CheckBox();
			this.checkShortLink = new Helianz.UI.CheckBox();
			this.label1 = new System.Windows.Forms.Label();
			this.textEndpoint = new System.Windows.Forms.TextBox();
			this.label2 = new System.Windows.Forms.Label();
			this.textBucket = new System.Windows.Forms.TextBox();
			this.label3 = new System.Windows.Forms.Label();
			this.textAccessKey = new System.Windows.Forms.TextBox();
			this.label4 = new System.Windows.Forms.Label();
			this.textSecretKey = new System.Windows.Forms.TextBox();
			this.label5 = new System.Windows.Forms.Label();
			this.textRegion = new System.Windows.Forms.TextBox();
			this.label6 = new System.Windows.Forms.Label();
			this.textPublicUrl = new System.Windows.Forms.TextBox();
			this.label7 = new System.Windows.Forms.Label();
			this.textExpiresDays = new Helianz.ValidNum();
			this.labelDays = new System.Windows.Forms.Label();
			this.labelHelp = new System.Windows.Forms.Label();
			this.butTest = new Helianz.UI.Button();
			this.butOK = new Helianz.UI.Button();
			this.butCancel = new Helianz.UI.Button();
			this.SuspendLayout();
			// 
			// checkEnable
			// 
			this.checkEnable.Location = new System.Drawing.Point(30, 20);
			this.checkEnable.Name = "checkEnable";
			this.checkEnable.Size = new System.Drawing.Size(460, 24);
			this.checkEnable.TabIndex = 0;
			this.checkEnable.Text = "Enable IDrive e2 S3 Cloud Storage for PDF Statements (WhatsApp Direct Link)";
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(28, 60);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(150, 18);
			this.label1.TabIndex = 1;
			this.label1.Text = "S3 Endpoint URL:";
			this.label1.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// textEndpoint
			// 
			this.textEndpoint.Location = new System.Drawing.Point(184, 59);
			this.textEndpoint.Name = "textEndpoint";
			this.textEndpoint.Size = new System.Drawing.Size(320, 20);
			this.textEndpoint.TabIndex = 2;
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(28, 92);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(150, 18);
			this.label2.TabIndex = 3;
			this.label2.Text = "Bucket Name:";
			this.label2.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// textBucket
			// 
			this.textBucket.Location = new System.Drawing.Point(184, 91);
			this.textBucket.Name = "textBucket";
			this.textBucket.Size = new System.Drawing.Size(320, 20);
			this.textBucket.TabIndex = 4;
			// 
			// label3
			// 
			this.label3.Location = new System.Drawing.Point(28, 124);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(150, 18);
			this.label3.TabIndex = 5;
			this.label3.Text = "Access Key ID:";
			this.label3.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// textAccessKey
			// 
			this.textAccessKey.Location = new System.Drawing.Point(184, 123);
			this.textAccessKey.Name = "textAccessKey";
			this.textAccessKey.Size = new System.Drawing.Size(320, 20);
			this.textAccessKey.TabIndex = 6;
			// 
			// label4
			// 
			this.label4.Location = new System.Drawing.Point(28, 156);
			this.label4.Name = "label4";
			this.label4.Size = new System.Drawing.Size(150, 18);
			this.label4.TabIndex = 7;
			this.label4.Text = "Secret Access Key:";
			this.label4.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// textSecretKey
			// 
			this.textSecretKey.Location = new System.Drawing.Point(184, 155);
			this.textSecretKey.Name = "textSecretKey";
			this.textSecretKey.PasswordChar = '•';
			this.textSecretKey.Size = new System.Drawing.Size(320, 20);
			this.textSecretKey.TabIndex = 8;
			this.textSecretKey.UseSystemPasswordChar = true;
			// 
			// label5
			// 
			this.label5.Location = new System.Drawing.Point(28, 188);
			this.label5.Name = "label5";
			this.label5.Size = new System.Drawing.Size(150, 18);
			this.label5.TabIndex = 9;
			this.label5.Text = "Region (default us-east-1):";
			this.label5.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// textRegion
			// 
			this.textRegion.Location = new System.Drawing.Point(184, 187);
			this.textRegion.Name = "textRegion";
			this.textRegion.Size = new System.Drawing.Size(160, 20);
			this.textRegion.TabIndex = 10;
			// 
			// label6
			// 
			this.label6.Location = new System.Drawing.Point(28, 220);
			this.label6.Name = "label6";
			this.label6.Size = new System.Drawing.Size(150, 18);
			this.label6.TabIndex = 11;
			this.label6.Text = "Public CDN / Custom URL:";
			this.label6.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// textPublicUrl
			// 
			this.textPublicUrl.Location = new System.Drawing.Point(184, 219);
			this.textPublicUrl.Name = "textPublicUrl";
			this.textPublicUrl.Size = new System.Drawing.Size(320, 20);
			this.textPublicUrl.TabIndex = 12;
			// 
			// label7
			// 
			this.label7.Location = new System.Drawing.Point(28, 252);
			this.label7.Name = "label7";
			this.label7.Size = new System.Drawing.Size(150, 18);
			this.label7.TabIndex = 13;
			this.label7.Text = "Link Expiry Period:";
			this.label7.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// textExpiresDays
			// 
			this.textExpiresDays.Location = new System.Drawing.Point(184, 251);
			this.textExpiresDays.MaxVal = 7;
			this.textExpiresDays.MinVal = 1;
			this.textExpiresDays.Name = "textExpiresDays";
			this.textExpiresDays.Size = new System.Drawing.Size(60, 20);
			this.textExpiresDays.TabIndex = 14;
			// 
			// labelDays
			// 
			this.labelDays.Location = new System.Drawing.Point(250, 252);
			this.labelDays.Name = "labelDays";
			this.labelDays.Size = new System.Drawing.Size(250, 18);
			this.labelDays.TabIndex = 15;
			this.labelDays.Text = "days (max 7 days for Presigned URLs)";
			this.labelDays.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
			// 
			// checkShortLink
			// 
			this.checkShortLink.Location = new System.Drawing.Point(184, 280);
			this.checkShortLink.Name = "checkShortLink";
			this.checkShortLink.Size = new System.Drawing.Size(320, 24);
			this.checkShortLink.TabIndex = 16;
			this.checkShortLink.Text = "Shorten link using URL shortener (TinyURL / is.gd)";
			// 
			// labelHelp
			// 
			this.labelHelp.ForeColor = System.Drawing.Color.DimGray;
			this.labelHelp.Location = new System.Drawing.Point(184, 310);
			this.labelHelp.Name = "labelHelp";
			this.labelHelp.Size = new System.Drawing.Size(320, 36);
			this.labelHelp.TabIndex = 17;
			this.labelHelp.Text = "When enabled, generated statement PDFs are automatically uploaded to your IDrive S3 bucket and a direct link is sent via WhatsApp.";
			// 
			// butTest
			// 
			this.butTest.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
			this.butTest.Location = new System.Drawing.Point(31, 365);
			this.butTest.Name = "butTest";
			this.butTest.Size = new System.Drawing.Size(120, 26);
			this.butTest.TabIndex = 18;
			this.butTest.Text = "Test Connection";
			this.butTest.UseVisualStyleBackColor = true;
			this.butTest.Click += new System.EventHandler(this.butTest_Click);
			// 
			// butOK
			// 
			this.butOK.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.butOK.Location = new System.Drawing.Point(344, 365);
			this.butOK.Name = "butOK";
			this.butOK.Size = new System.Drawing.Size(80, 26);
			this.butOK.TabIndex = 19;
			this.butOK.Text = "OK";
			this.butOK.UseVisualStyleBackColor = true;
			this.butOK.Click += new System.EventHandler(this.butOK_Click);
			// 
			// butCancel
			// 
			this.butCancel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.butCancel.Location = new System.Drawing.Point(434, 365);
			this.butCancel.Name = "butCancel";
			this.butCancel.Size = new System.Drawing.Size(80, 26);
			this.butCancel.TabIndex = 20;
			this.butCancel.Text = "Cancel";
			this.butCancel.UseVisualStyleBackColor = true;
			this.butCancel.Click += new System.EventHandler(this.butCancel_Click);
			// 
			// FormIdriveS3Setup
			// 
			this.ClientSize = new System.Drawing.Size(534, 410);
			this.Controls.Add(this.checkShortLink);
			this.Controls.Add(this.labelHelp);
			this.Controls.Add(this.labelDays);
			this.Controls.Add(this.textExpiresDays);
			this.Controls.Add(this.label7);
			this.Controls.Add(this.textPublicUrl);
			this.Controls.Add(this.label6);
			this.Controls.Add(this.textRegion);
			this.Controls.Add(this.label5);
			this.Controls.Add(this.textSecretKey);
			this.Controls.Add(this.label4);
			this.Controls.Add(this.textAccessKey);
			this.Controls.Add(this.label3);
			this.Controls.Add(this.textBucket);
			this.Controls.Add(this.label2);
			this.Controls.Add(this.textEndpoint);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.checkEnable);
			this.Controls.Add(this.butTest);
			this.Controls.Add(this.butOK);
			this.Controls.Add(this.butCancel);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "FormIdriveS3Setup";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "IDrive e2 S3 Cloud Storage Setup";
			this.Load += new System.EventHandler(this.FormIdriveS3Setup_Load);
			this.ResumeLayout(false);
			this.PerformLayout();

		}

		#endregion

		private Helianz.UI.CheckBox checkEnable;
		private Helianz.UI.CheckBox checkShortLink;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.TextBox textEndpoint;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.TextBox textBucket;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.TextBox textAccessKey;
		private System.Windows.Forms.Label label4;
		private System.Windows.Forms.TextBox textSecretKey;
		private System.Windows.Forms.Label label5;
		private System.Windows.Forms.TextBox textRegion;
		private System.Windows.Forms.Label label6;
		private System.Windows.Forms.TextBox textPublicUrl;
		private System.Windows.Forms.Label label7;
		private Helianz.ValidNum textExpiresDays;
		private System.Windows.Forms.Label labelDays;
		private System.Windows.Forms.Label labelHelp;
		private Helianz.UI.Button butTest;
		private Helianz.UI.Button butOK;
		private Helianz.UI.Button butCancel;
	}
}
