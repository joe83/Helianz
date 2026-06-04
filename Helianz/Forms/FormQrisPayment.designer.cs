namespace Helianz {
	partial class FormQrisPayment {
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
			this.panelTopBar = new System.Windows.Forms.Panel();
			this.labelHeroTitle = new System.Windows.Forms.Label();
			this.butToggleConnection = new Helianz.UI.Button();
			this.labelInstruction = new System.Windows.Forms.Label();
			this.labelAmount = new System.Windows.Forms.Label();
			this.labelOrderId = new System.Windows.Forms.Label();
			this.labelStatus = new System.Windows.Forms.Label();
			this.pictureBoxQr = new System.Windows.Forms.PictureBox();
			this.panelConnectionDrawer = new System.Windows.Forms.Panel();
			this.labelConnectionTitle = new System.Windows.Forms.Label();
			this.labelConnectionHint = new System.Windows.Forms.Label();
			this.panelSuccessCard = new System.Windows.Forms.Panel();
			this.panelSuccessIcon = new System.Windows.Forms.Panel();
			this.labelSuccessIcon = new System.Windows.Forms.Label();
			this.labelSuccessTitle = new System.Windows.Forms.Label();
			this.labelSuccessSubtitle = new System.Windows.Forms.Label();
			this.labelSuccessDetail = new System.Windows.Forms.Label();
			this.labelQrError = new System.Windows.Forms.Label();
			this.labelSimulatorUrl = new System.Windows.Forms.Label();
			this.textBoxQrUrl = new System.Windows.Forms.TextBox();
			this.butCopyQrUrl = new Helianz.UI.Button();
			this.labelPhoneMirror = new System.Windows.Forms.Label();
			this.textBoxPhoneMirrorUrl = new System.Windows.Forms.TextBox();
			this.butCopyPhoneMirrorUrl = new Helianz.UI.Button();
			this.labelPhoneMirrorQr = new System.Windows.Forms.Label();
			this.pictureBoxPhoneMirrorQr = new System.Windows.Forms.PictureBox();
			this.butCancel = new Helianz.UI.Button();
			this.panelTopBar.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.pictureBoxQr)).BeginInit();
			this.panelConnectionDrawer.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.pictureBoxPhoneMirrorQr)).BeginInit();
			this.panelSuccessCard.SuspendLayout();
			this.panelSuccessIcon.SuspendLayout();
			this.SuspendLayout();
			// 
			// panelTopBar
			// 
			this.panelTopBar.BackColor = System.Drawing.Color.FromArgb(20, 93, 99);
			this.panelTopBar.Controls.Add(this.labelHeroTitle);
			this.panelTopBar.Controls.Add(this.butToggleConnection);
			this.panelTopBar.Location = new System.Drawing.Point(0, 0);
			this.panelTopBar.Name = "panelTopBar";
			this.panelTopBar.Size = new System.Drawing.Size(484, 50);
			this.panelTopBar.TabIndex = 0;
			// 
			// labelHeroTitle
			// 
			this.labelHeroTitle.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Bold);
			this.labelHeroTitle.ForeColor = System.Drawing.Color.White;
			this.labelHeroTitle.Location = new System.Drawing.Point(14, 13);
			this.labelHeroTitle.Name = "labelHeroTitle";
			this.labelHeroTitle.Size = new System.Drawing.Size(250, 24);
			this.labelHeroTitle.TabIndex = 0;
			this.labelHeroTitle.Text = "QRIS Payment";
			// 
			// butToggleConnection
			// 
			this.butToggleConnection.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
			this.butToggleConnection.Location = new System.Drawing.Point(434, 9);
			this.butToggleConnection.Name = "butToggleConnection";
			this.butToggleConnection.Size = new System.Drawing.Size(38, 32);
			this.butToggleConnection.TabIndex = 1;
			this.butToggleConnection.UseVisualStyleBackColor = true;
			this.butToggleConnection.Click += new System.EventHandler(this.butToggleConnection_Click);
			// 
			// labelInstruction
			// 
			this.labelInstruction.Font = new System.Drawing.Font("Segoe UI", 9.5F);
			this.labelInstruction.ForeColor = System.Drawing.Color.FromArgb(72, 88, 92);
			this.labelInstruction.Location = new System.Drawing.Point(18, 64);
			this.labelInstruction.Name = "labelInstruction";
			this.labelInstruction.Size = new System.Drawing.Size(448, 38);
			this.labelInstruction.TabIndex = 0;
			this.labelInstruction.Text = "Scan the QR code below using GoPay, OVO, DANA, LinkAja, ShopeePay, or any QRIS-enabled app.";
			// 
			// labelAmount
			// 
			this.labelAmount.Font = new System.Drawing.Font("Segoe UI", 10F, System.Drawing.FontStyle.Bold);
			this.labelAmount.ForeColor = System.Drawing.Color.FromArgb(24, 52, 56);
			this.labelAmount.Location = new System.Drawing.Point(18, 118);
			this.labelAmount.Name = "labelAmount";
			this.labelAmount.Size = new System.Drawing.Size(448, 20);
			this.labelAmount.TabIndex = 1;
			this.labelAmount.Text = "Amount (IDR):";
			// 
			// labelOrderId
			// 
			this.labelOrderId.Font = new System.Drawing.Font("Segoe UI", 10F);
			this.labelOrderId.ForeColor = System.Drawing.Color.FromArgb(56, 72, 77);
			this.labelOrderId.Location = new System.Drawing.Point(18, 144);
			this.labelOrderId.Name = "labelOrderId";
			this.labelOrderId.Size = new System.Drawing.Size(448, 20);
			this.labelOrderId.TabIndex = 2;
			this.labelOrderId.Text = "Order ID:";
			// 
			// pictureBoxQr
			// 
			this.pictureBoxQr.BackColor = System.Drawing.Color.White;
			this.pictureBoxQr.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			this.pictureBoxQr.Location = new System.Drawing.Point(92, 184);
			this.pictureBoxQr.Name = "pictureBoxQr";
			this.pictureBoxQr.Padding = new System.Windows.Forms.Padding(10);
			this.pictureBoxQr.Size = new System.Drawing.Size(300, 300);
			this.pictureBoxQr.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
			this.pictureBoxQr.TabIndex = 3;
			this.pictureBoxQr.TabStop = false;
			// 
			// panelConnectionDrawer
			// 
			this.panelConnectionDrawer.BackColor = System.Drawing.Color.FromArgb(248, 250, 252);
			this.panelConnectionDrawer.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			this.panelConnectionDrawer.Controls.Add(this.labelConnectionTitle);
			this.panelConnectionDrawer.Controls.Add(this.labelConnectionHint);
			this.panelConnectionDrawer.Controls.Add(this.labelSimulatorUrl);
			this.panelConnectionDrawer.Controls.Add(this.textBoxQrUrl);
			this.panelConnectionDrawer.Controls.Add(this.butCopyQrUrl);
			this.panelConnectionDrawer.Controls.Add(this.labelPhoneMirror);
			this.panelConnectionDrawer.Controls.Add(this.textBoxPhoneMirrorUrl);
			this.panelConnectionDrawer.Controls.Add(this.butCopyPhoneMirrorUrl);
			this.panelConnectionDrawer.Controls.Add(this.labelPhoneMirrorQr);
			this.panelConnectionDrawer.Controls.Add(this.pictureBoxPhoneMirrorQr);
			this.panelConnectionDrawer.Location = new System.Drawing.Point(0, 50);
			this.panelConnectionDrawer.Name = "panelConnectionDrawer";
			this.panelConnectionDrawer.Size = new System.Drawing.Size(484, 535);
			this.panelConnectionDrawer.TabIndex = 4;
			this.panelConnectionDrawer.Visible = false;
			// 
			// labelConnectionTitle
			// 
			this.labelConnectionTitle.Font = new System.Drawing.Font("Segoe UI", 15F, System.Drawing.FontStyle.Bold);
			this.labelConnectionTitle.ForeColor = System.Drawing.Color.FromArgb(24, 52, 56);
			this.labelConnectionTitle.Location = new System.Drawing.Point(24, 22);
			this.labelConnectionTitle.Name = "labelConnectionTitle";
			this.labelConnectionTitle.Size = new System.Drawing.Size(250, 30);
			this.labelConnectionTitle.TabIndex = 0;
			this.labelConnectionTitle.Text = "Connect Phone";
			// 
			// labelConnectionHint
			// 
			this.labelConnectionHint.Font = new System.Drawing.Font("Segoe UI", 10F);
			this.labelConnectionHint.ForeColor = System.Drawing.Color.FromArgb(88, 103, 110);
			this.labelConnectionHint.Location = new System.Drawing.Point(24, 58);
			this.labelConnectionHint.Name = "labelConnectionHint";
			this.labelConnectionHint.Size = new System.Drawing.Size(434, 44);
			this.labelConnectionHint.TabIndex = 1;
			this.labelConnectionHint.Text = "Scan this QR from the Android viewer, or copy the LAN link manually if needed.";
			// 
			// panelSuccessCard
			// 
			this.panelSuccessCard.BackColor = System.Drawing.Color.FromArgb(247, 251, 248);
			this.panelSuccessCard.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			this.panelSuccessCard.Controls.Add(this.panelSuccessIcon);
			this.panelSuccessCard.Controls.Add(this.labelSuccessTitle);
			this.panelSuccessCard.Controls.Add(this.labelSuccessSubtitle);
			this.panelSuccessCard.Controls.Add(this.labelSuccessDetail);
			this.panelSuccessCard.Location = new System.Drawing.Point(76, 194);
			this.panelSuccessCard.Name = "panelSuccessCard";
			this.panelSuccessCard.Size = new System.Drawing.Size(332, 280);
			this.panelSuccessCard.TabIndex = 10;
			this.panelSuccessCard.Visible = false;
			// 
			// panelSuccessIcon
			// 
			this.panelSuccessIcon.BackColor = System.Drawing.Color.FromArgb(222, 245, 232);
			this.panelSuccessIcon.Controls.Add(this.labelSuccessIcon);
			this.panelSuccessIcon.Location = new System.Drawing.Point(116, 28);
			this.panelSuccessIcon.Name = "panelSuccessIcon";
			this.panelSuccessIcon.Size = new System.Drawing.Size(100, 100);
			this.panelSuccessIcon.TabIndex = 0;
			// 
			// labelSuccessIcon
			// 
			this.labelSuccessIcon.Dock = System.Windows.Forms.DockStyle.Fill;
			this.labelSuccessIcon.Font = new System.Drawing.Font("Segoe UI Symbol", 28F, System.Drawing.FontStyle.Bold);
			this.labelSuccessIcon.ForeColor = System.Drawing.Color.FromArgb(0, 136, 82);
			this.labelSuccessIcon.Location = new System.Drawing.Point(0, 0);
			this.labelSuccessIcon.Name = "labelSuccessIcon";
			this.labelSuccessIcon.Size = new System.Drawing.Size(100, 100);
			this.labelSuccessIcon.TabIndex = 0;
			this.labelSuccessIcon.Text = "✓";
			this.labelSuccessIcon.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			// 
			// labelSuccessTitle
			// 
			this.labelSuccessTitle.Font = new System.Drawing.Font("Segoe UI", 18F, System.Drawing.FontStyle.Bold);
			this.labelSuccessTitle.ForeColor = System.Drawing.Color.FromArgb(32, 50, 39);
			this.labelSuccessTitle.Location = new System.Drawing.Point(20, 145);
			this.labelSuccessTitle.Name = "labelSuccessTitle";
			this.labelSuccessTitle.Size = new System.Drawing.Size(290, 36);
			this.labelSuccessTitle.TabIndex = 1;
			this.labelSuccessTitle.Text = "Payment Successful";
			this.labelSuccessTitle.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			// 
			// labelSuccessSubtitle
			// 
			this.labelSuccessSubtitle.Font = new System.Drawing.Font("Segoe UI", 10F);
			this.labelSuccessSubtitle.ForeColor = System.Drawing.Color.FromArgb(86, 102, 92);
			this.labelSuccessSubtitle.Location = new System.Drawing.Point(20, 186);
			this.labelSuccessSubtitle.Name = "labelSuccessSubtitle";
			this.labelSuccessSubtitle.Size = new System.Drawing.Size(290, 44);
			this.labelSuccessSubtitle.TabIndex = 2;
			this.labelSuccessSubtitle.Text = "QRIS payment has been confirmed and recorded.";
			this.labelSuccessSubtitle.TextAlign = System.Drawing.ContentAlignment.TopCenter;
			// 
			// labelSuccessDetail
			// 
			this.labelSuccessDetail.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Bold);
			this.labelSuccessDetail.ForeColor = System.Drawing.Color.FromArgb(0, 136, 82);
			this.labelSuccessDetail.Location = new System.Drawing.Point(20, 238);
			this.labelSuccessDetail.Name = "labelSuccessDetail";
			this.labelSuccessDetail.Size = new System.Drawing.Size(290, 22);
			this.labelSuccessDetail.TabIndex = 3;
			this.labelSuccessDetail.Text = "Closing this window...";
			this.labelSuccessDetail.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			// 
			// labelQrError
			// 
			this.labelQrError.ForeColor = System.Drawing.Color.Red;
			this.labelQrError.Location = new System.Drawing.Point(22, 194);
			this.labelQrError.Name = "labelQrError";
			this.labelQrError.Size = new System.Drawing.Size(438, 80);
			this.labelQrError.TabIndex = 4;
			this.labelQrError.Text = "Could not load QR code.";
			this.labelQrError.Visible = false;
			// 
			// labelStatus
			// 
			this.labelStatus.Font = new System.Drawing.Font("Segoe UI", 10F, System.Drawing.FontStyle.Bold);
			this.labelStatus.ForeColor = System.Drawing.Color.FromArgb(24, 52, 56);
			this.labelStatus.Location = new System.Drawing.Point(18, 500);
			this.labelStatus.Name = "labelStatus";
			this.labelStatus.Size = new System.Drawing.Size(448, 24);
			this.labelStatus.TabIndex = 5;
			this.labelStatus.Text = "Status:";
			// 
			// butCancel
			// 
			this.butCancel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.butCancel.Location = new System.Drawing.Point(391, 545);
			this.butCancel.Name = "butCancel";
			this.butCancel.Size = new System.Drawing.Size(81, 28);
			this.butCancel.TabIndex = 6;
			this.butCancel.Text = "Cancel";
			this.butCancel.Click += new System.EventHandler(this.butCancel_Click);
			// 
			// labelSimulatorUrl
			// 
			this.labelSimulatorUrl.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Bold);
			this.labelSimulatorUrl.ForeColor = System.Drawing.Color.FromArgb(24, 52, 56);
			this.labelSimulatorUrl.Location = new System.Drawing.Point(24, 126);
			this.labelSimulatorUrl.Name = "labelSimulatorUrl";
			this.labelSimulatorUrl.Size = new System.Drawing.Size(150, 18);
			this.labelSimulatorUrl.TabIndex = 7;
			this.labelSimulatorUrl.Text = "Simulator";
			this.labelSimulatorUrl.Visible = false;
			// 
			// textBoxQrUrl
			// 
			this.textBoxQrUrl.BackColor = System.Drawing.Color.White;
			this.textBoxQrUrl.Font = new System.Drawing.Font("Segoe UI", 10F);
			this.textBoxQrUrl.Location = new System.Drawing.Point(24, 150);
			this.textBoxQrUrl.Name = "textBoxQrUrl";
			this.textBoxQrUrl.ReadOnly = true;
			this.textBoxQrUrl.Size = new System.Drawing.Size(334, 25);
			this.textBoxQrUrl.TabIndex = 8;
			this.textBoxQrUrl.Visible = false;
			// 
			// butCopyQrUrl
			// 
			this.butCopyQrUrl.Location = new System.Drawing.Point(370, 149);
			this.butCopyQrUrl.Name = "butCopyQrUrl";
			this.butCopyQrUrl.Size = new System.Drawing.Size(88, 27);
			this.butCopyQrUrl.TabIndex = 9;
			this.butCopyQrUrl.Text = "Copy";
			this.butCopyQrUrl.Visible = false;
			this.butCopyQrUrl.Click += new System.EventHandler(this.butCopyQrUrl_Click);
			// 
			// labelPhoneMirror
			// 
			this.labelPhoneMirror.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Bold);
			this.labelPhoneMirror.ForeColor = System.Drawing.Color.FromArgb(24, 52, 56);
			this.labelPhoneMirror.Location = new System.Drawing.Point(24, 198);
			this.labelPhoneMirror.Name = "labelPhoneMirror";
			this.labelPhoneMirror.Size = new System.Drawing.Size(150, 18);
			this.labelPhoneMirror.TabIndex = 10;
			this.labelPhoneMirror.Text = "Phone Link:";
			this.labelPhoneMirror.Visible = false;
			// 
			// textBoxPhoneMirrorUrl
			// 
			this.textBoxPhoneMirrorUrl.BackColor = System.Drawing.Color.White;
			this.textBoxPhoneMirrorUrl.Font = new System.Drawing.Font("Segoe UI", 10F);
			this.textBoxPhoneMirrorUrl.Location = new System.Drawing.Point(24, 222);
			this.textBoxPhoneMirrorUrl.Name = "textBoxPhoneMirrorUrl";
			this.textBoxPhoneMirrorUrl.ReadOnly = true;
			this.textBoxPhoneMirrorUrl.Size = new System.Drawing.Size(334, 25);
			this.textBoxPhoneMirrorUrl.TabIndex = 11;
			this.textBoxPhoneMirrorUrl.Visible = false;
			// 
			// butCopyPhoneMirrorUrl
			// 
			this.butCopyPhoneMirrorUrl.Location = new System.Drawing.Point(370, 221);
			this.butCopyPhoneMirrorUrl.Name = "butCopyPhoneMirrorUrl";
			this.butCopyPhoneMirrorUrl.Size = new System.Drawing.Size(88, 27);
			this.butCopyPhoneMirrorUrl.TabIndex = 12;
			this.butCopyPhoneMirrorUrl.Text = "Copy";
			this.butCopyPhoneMirrorUrl.Visible = false;
			this.butCopyPhoneMirrorUrl.Click += new System.EventHandler(this.butCopyPhoneMirrorUrl_Click);
			// 
			// labelPhoneMirrorQr
			// 
			this.labelPhoneMirrorQr.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Bold);
			this.labelPhoneMirrorQr.ForeColor = System.Drawing.Color.FromArgb(24, 52, 56);
			this.labelPhoneMirrorQr.Location = new System.Drawing.Point(24, 276);
			this.labelPhoneMirrorQr.Name = "labelPhoneMirrorQr";
			this.labelPhoneMirrorQr.Size = new System.Drawing.Size(150, 18);
			this.labelPhoneMirrorQr.TabIndex = 13;
			this.labelPhoneMirrorQr.Text = "Connect QR:";
			this.labelPhoneMirrorQr.Visible = false;
			// 
			// pictureBoxPhoneMirrorQr
			// 
			this.pictureBoxPhoneMirrorQr.BackColor = System.Drawing.Color.White;
			this.pictureBoxPhoneMirrorQr.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			this.pictureBoxPhoneMirrorQr.Location = new System.Drawing.Point(102, 312);
			this.pictureBoxPhoneMirrorQr.Name = "pictureBoxPhoneMirrorQr";
			this.pictureBoxPhoneMirrorQr.Size = new System.Drawing.Size(280, 180);
			this.pictureBoxPhoneMirrorQr.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
			this.pictureBoxPhoneMirrorQr.TabIndex = 14;
			this.pictureBoxPhoneMirrorQr.TabStop = false;
			this.pictureBoxPhoneMirrorQr.Visible = false;
			// 
			// FormQrisPayment
			// 
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.None;
			this.BackColor = System.Drawing.Color.FromArgb(245, 247, 249);
			this.ClientSize = new System.Drawing.Size(484, 585);
			this.Controls.Add(this.panelTopBar);
			this.Controls.Add(this.labelInstruction);
			this.Controls.Add(this.labelAmount);
			this.Controls.Add(this.labelOrderId);
			this.Controls.Add(this.pictureBoxQr);
			this.Controls.Add(this.panelConnectionDrawer);
			this.Controls.Add(this.panelSuccessCard);
			this.Controls.Add(this.labelQrError);
			this.Controls.Add(this.labelStatus);
			this.Controls.Add(this.butCancel);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "FormQrisPayment";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
			this.Text = "QRIS Payment";
			this.Load += new System.EventHandler(this.FormQrisPayment_Load);
			this.panelTopBar.ResumeLayout(false);
			((System.ComponentModel.ISupportInitialize)(this.pictureBoxQr)).EndInit();
			this.panelConnectionDrawer.ResumeLayout(false);
			this.panelConnectionDrawer.PerformLayout();
			((System.ComponentModel.ISupportInitialize)(this.pictureBoxPhoneMirrorQr)).EndInit();
			this.panelSuccessCard.ResumeLayout(false);
			this.panelSuccessIcon.ResumeLayout(false);
			this.ResumeLayout(false);
		}

		#endregion

		private System.Windows.Forms.Panel panelTopBar;
		private System.Windows.Forms.Label labelHeroTitle;
		private Helianz.UI.Button butToggleConnection;
		private System.Windows.Forms.Label labelInstruction;
		private System.Windows.Forms.Label labelAmount;
		private System.Windows.Forms.Label labelOrderId;
		private System.Windows.Forms.Label labelStatus;
		private System.Windows.Forms.PictureBox pictureBoxQr;
		private System.Windows.Forms.Panel panelConnectionDrawer;
		private System.Windows.Forms.Label labelConnectionTitle;
		private System.Windows.Forms.Label labelConnectionHint;
		private System.Windows.Forms.Panel panelSuccessCard;
		private System.Windows.Forms.Panel panelSuccessIcon;
		private System.Windows.Forms.Label labelSuccessIcon;
		private System.Windows.Forms.Label labelSuccessTitle;
		private System.Windows.Forms.Label labelSuccessSubtitle;
		private System.Windows.Forms.Label labelSuccessDetail;
		private System.Windows.Forms.Label labelQrError;
		private System.Windows.Forms.Label labelSimulatorUrl;
		private System.Windows.Forms.TextBox textBoxQrUrl;
		private Helianz.UI.Button butCopyQrUrl;
		private System.Windows.Forms.Label labelPhoneMirror;
		private System.Windows.Forms.TextBox textBoxPhoneMirrorUrl;
		private Helianz.UI.Button butCopyPhoneMirrorUrl;
		private System.Windows.Forms.Label labelPhoneMirrorQr;
		private System.Windows.Forms.PictureBox pictureBoxPhoneMirrorQr;
		private Helianz.UI.Button butCancel;
	}
}
