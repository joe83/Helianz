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
			this.labelInstruction = new System.Windows.Forms.Label();
			this.labelAmount = new System.Windows.Forms.Label();
			this.labelOrderId = new System.Windows.Forms.Label();
			this.labelStatus = new System.Windows.Forms.Label();
			this.pictureBoxQr = new System.Windows.Forms.PictureBox();
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
			this.butCancel = new Helianz.UI.Button();
			((System.ComponentModel.ISupportInitialize)(this.pictureBoxQr)).BeginInit();
			this.panelSuccessCard.SuspendLayout();
			this.panelSuccessIcon.SuspendLayout();
			this.SuspendLayout();
			// 
			// labelInstruction
			// 
			this.labelInstruction.Location = new System.Drawing.Point(12, 9);
			this.labelInstruction.Name = "labelInstruction";
			this.labelInstruction.Size = new System.Drawing.Size(460, 36);
			this.labelInstruction.TabIndex = 0;
			this.labelInstruction.Text = "Scan the QR code below using GoPay, OVO, DANA, LinkAja, ShopeePay, or any QRIS-enabled app.";
			// 
			// labelAmount
			// 
			this.labelAmount.Location = new System.Drawing.Point(12, 52);
			this.labelAmount.Name = "labelAmount";
			this.labelAmount.Size = new System.Drawing.Size(460, 20);
			this.labelAmount.TabIndex = 1;
			this.labelAmount.Text = "Amount (IDR):";
			// 
			// labelOrderId
			// 
			this.labelOrderId.Location = new System.Drawing.Point(12, 74);
			this.labelOrderId.Name = "labelOrderId";
			this.labelOrderId.Size = new System.Drawing.Size(460, 20);
			this.labelOrderId.TabIndex = 2;
			this.labelOrderId.Text = "Order ID:";
			// 
			// pictureBoxQr
			// 
			this.pictureBoxQr.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			this.pictureBoxQr.Location = new System.Drawing.Point(100, 100);
			this.pictureBoxQr.Name = "pictureBoxQr";
			this.pictureBoxQr.Size = new System.Drawing.Size(280, 280);
			this.pictureBoxQr.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
			this.pictureBoxQr.TabIndex = 3;
			this.pictureBoxQr.TabStop = false;
			// 
			// panelSuccessCard
			// 
			this.panelSuccessCard.BackColor = System.Drawing.Color.FromArgb(247, 251, 248);
			this.panelSuccessCard.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			this.panelSuccessCard.Controls.Add(this.panelSuccessIcon);
			this.panelSuccessCard.Controls.Add(this.labelSuccessTitle);
			this.panelSuccessCard.Controls.Add(this.labelSuccessSubtitle);
			this.panelSuccessCard.Controls.Add(this.labelSuccessDetail);
			this.panelSuccessCard.Location = new System.Drawing.Point(76, 100);
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
			this.labelQrError.Location = new System.Drawing.Point(12, 100);
			this.labelQrError.Name = "labelQrError";
			this.labelQrError.Size = new System.Drawing.Size(460, 80);
			this.labelQrError.TabIndex = 4;
			this.labelQrError.Text = "Could not load QR code.";
			this.labelQrError.Visible = false;
			// 
			// labelStatus
			// 
			this.labelStatus.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Bold);
			this.labelStatus.Location = new System.Drawing.Point(12, 392);
			this.labelStatus.Name = "labelStatus";
			this.labelStatus.Size = new System.Drawing.Size(460, 24);
			this.labelStatus.TabIndex = 5;
			this.labelStatus.Text = "Status:";
			// 
			// butCancel
			// 
			this.butCancel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.butCancel.Location = new System.Drawing.Point(397, 456);
			this.butCancel.Name = "butCancel";
			this.butCancel.Size = new System.Drawing.Size(75, 24);
			this.butCancel.TabIndex = 6;
			this.butCancel.Text = "Cancel";
			this.butCancel.Click += new System.EventHandler(this.butCancel_Click);
			// 
			// labelSimulatorUrl
			// 
			this.labelSimulatorUrl.Location = new System.Drawing.Point(12, 424);
			this.labelSimulatorUrl.Name = "labelSimulatorUrl";
			this.labelSimulatorUrl.Size = new System.Drawing.Size(80, 20);
			this.labelSimulatorUrl.TabIndex = 7;
			this.labelSimulatorUrl.Text = "Simulator URL:";
			this.labelSimulatorUrl.Visible = false;
			// 
			// textBoxQrUrl
			// 
			this.textBoxQrUrl.Location = new System.Drawing.Point(96, 422);
			this.textBoxQrUrl.Name = "textBoxQrUrl";
			this.textBoxQrUrl.ReadOnly = true;
			this.textBoxQrUrl.Size = new System.Drawing.Size(285, 20);
			this.textBoxQrUrl.TabIndex = 8;
			this.textBoxQrUrl.Visible = false;
			// 
			// butCopyQrUrl
			// 
			this.butCopyQrUrl.Location = new System.Drawing.Point(387, 420);
			this.butCopyQrUrl.Name = "butCopyQrUrl";
			this.butCopyQrUrl.Size = new System.Drawing.Size(85, 24);
			this.butCopyQrUrl.TabIndex = 9;
			this.butCopyQrUrl.Text = "Copy URL";
			this.butCopyQrUrl.Visible = false;
			this.butCopyQrUrl.Click += new System.EventHandler(this.butCopyQrUrl_Click);
			// 
			// FormQrisPayment
			// 
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.None;
			this.ClientSize = new System.Drawing.Size(484, 492);
			this.Controls.Add(this.labelInstruction);
			this.Controls.Add(this.labelAmount);
			this.Controls.Add(this.labelOrderId);
			this.Controls.Add(this.pictureBoxQr);
			this.Controls.Add(this.panelSuccessCard);
			this.Controls.Add(this.labelQrError);
			this.Controls.Add(this.labelStatus);
			this.Controls.Add(this.labelSimulatorUrl);
			this.Controls.Add(this.textBoxQrUrl);
			this.Controls.Add(this.butCopyQrUrl);
			this.Controls.Add(this.butCancel);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "FormQrisPayment";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
			this.Text = "QRIS Payment";
			this.Load += new System.EventHandler(this.FormQrisPayment_Load);
			((System.ComponentModel.ISupportInitialize)(this.pictureBoxQr)).EndInit();
			this.panelSuccessCard.ResumeLayout(false);
			this.panelSuccessIcon.ResumeLayout(false);
			this.ResumeLayout(false);
		}

		#endregion

		private System.Windows.Forms.Label labelInstruction;
		private System.Windows.Forms.Label labelAmount;
		private System.Windows.Forms.Label labelOrderId;
		private System.Windows.Forms.Label labelStatus;
		private System.Windows.Forms.PictureBox pictureBoxQr;
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
		private Helianz.UI.Button butCancel;
	}
}
