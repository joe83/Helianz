namespace FreeDentalInstaller {
	partial class FormMysqlCredentials {
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
			System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FormMysqlCredentials));
			this.textUserName = new System.Windows.Forms.TextBox();
			this.labelUserName = new System.Windows.Forms.Label();
			this.label1 = new System.Windows.Forms.Label();
			this.textPassword = new System.Windows.Forms.TextBox();
			this.butOK = new System.Windows.Forms.Button();
			this.butCancel = new System.Windows.Forms.Button();
			this.label2 = new System.Windows.Forms.Label();
			this.textPasswordVerify = new System.Windows.Forms.TextBox();
			this.label3 = new System.Windows.Forms.Label();
			this.labelRecommend = new System.Windows.Forms.Label();
			this.butUseBlank = new System.Windows.Forms.Button();
			this.SuspendLayout();
			// 
			// textUserName
			// 
			this.textUserName.Location = new System.Drawing.Point(139, 39);
			this.textUserName.Name = "textUserName";
			this.textUserName.Size = new System.Drawing.Size(154, 20);
			this.textUserName.TabIndex = 1;
			this.textUserName.Text = "root";
			// 
			// labelUserName
			// 
			this.labelUserName.Location = new System.Drawing.Point(23, 39);
			this.labelUserName.Name = "labelUserName";
			this.labelUserName.Size = new System.Drawing.Size(113, 20);
			this.labelUserName.TabIndex = 0;
			this.labelUserName.Text = "MySQL UserName";
			this.labelUserName.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(20, 65);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(116, 20);
			this.label1.TabIndex = 0;
			this.label1.Text = "MySQL Password";
			this.label1.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// textPassword
			// 
			this.textPassword.Location = new System.Drawing.Point(139, 65);
			this.textPassword.Name = "textPassword";
			this.textPassword.Size = new System.Drawing.Size(154, 20);
			this.textPassword.TabIndex = 2;
			this.textPassword.UseSystemPasswordChar = true;
			this.textPassword.KeyUp += new System.Windows.Forms.KeyEventHandler(this.textPassword_KeyUp);
			// 
			// butOK
			// 
			this.butOK.Anchor = ((System.Windows.Forms.AnchorStyles)(System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right));
			this.butOK.Location = new System.Drawing.Point(139, 162);
			this.butOK.Name = "butOK";
			this.butOK.Size = new System.Drawing.Size(75, 23);
			this.butOK.TabIndex = 4;
			this.butOK.Text = "OK";
			this.butOK.UseVisualStyleBackColor = true;
			this.butOK.Click += new System.EventHandler(this.butOK_Click);
			// 
			// butCancel
			// 
			this.butCancel.Anchor = ((System.Windows.Forms.AnchorStyles)(System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right));
			this.butCancel.Location = new System.Drawing.Point(220, 162);
			this.butCancel.Name = "butCancel";
			this.butCancel.Size = new System.Drawing.Size(75, 23);
			this.butCancel.TabIndex = 5;
			this.butCancel.Text = "Cancel";
			this.butCancel.UseVisualStyleBackColor = true;
			this.butCancel.Click += new System.EventHandler(this.butCancel_Click);
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(20, 91);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(116, 20);
			this.label2.TabIndex = 0;
			this.label2.Text = "Verify Password";
			this.label2.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// textPasswordVerify
			// 
			this.textPasswordVerify.Location = new System.Drawing.Point(139, 91);
			this.textPasswordVerify.Name = "textPasswordVerify";
			this.textPasswordVerify.Size = new System.Drawing.Size(154, 20);
			this.textPasswordVerify.TabIndex = 3;
			this.textPasswordVerify.UseSystemPasswordChar = true;
			// 
			// label3
			// 
			this.label3.Location = new System.Drawing.Point(23, 9);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(291, 20);
			this.label3.TabIndex = 6;
			this.label3.Text = "Invalid characters are: quotes, slashes, newlines, tabs";
			this.label3.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			// 
			// labelRecommend
			// 
			this.labelRecommend.ForeColor = System.Drawing.Color.Red;
			this.labelRecommend.Location = new System.Drawing.Point(26, 114);
			this.labelRecommend.Name = "labelRecommend";
			this.labelRecommend.Size = new System.Drawing.Size(269, 45);
			this.labelRecommend.TabIndex = 7;
			this.labelRecommend.Text = "Helianz highly recommends you set a password for the root user.  Failing to set a root user password can cause security vulnerabilities.";
			this.labelRecommend.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
			this.labelRecommend.Visible = false;
			// 
			// butUseBlank
			// 
			this.butUseBlank.Anchor = ((System.Windows.Forms.AnchorStyles)(System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right));
			this.butUseBlank.Location = new System.Drawing.Point(12, 162);
			this.butUseBlank.Name = "butUseBlank";
			this.butUseBlank.Size = new System.Drawing.Size(121, 23);
			this.butUseBlank.TabIndex = 6;
			this.butUseBlank.Text = "Use Blank Password";
			this.butUseBlank.UseVisualStyleBackColor = true;
			this.butUseBlank.Visible = false;
			this.butUseBlank.Click += new System.EventHandler(this.butUseBlank_Click);
			// 
			// FormMysqlCredentials
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(326, 197);
			this.Controls.Add(this.butUseBlank);
			this.Controls.Add(this.label3);
			this.Controls.Add(this.label2);
			this.Controls.Add(this.textPasswordVerify);
			this.Controls.Add(this.butCancel);
			this.Controls.Add(this.butOK);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.textPassword);
			this.Controls.Add(this.labelUserName);
			this.Controls.Add(this.textUserName);
			this.Controls.Add(this.labelRecommend);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.Name = "FormMysqlCredentials";
			this.Text = "MySQL Credentials";
			this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.FormMysqlCredentials_FormClosing);
			this.Load += new System.EventHandler(this.FormMysqlCredentials_Load);
			this.ResumeLayout(false);
			this.PerformLayout();
		}

		#endregion

		private System.Windows.Forms.TextBox textUserName;
		private System.Windows.Forms.Label labelUserName;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.TextBox textPassword;
		private System.Windows.Forms.Button butOK;
		private System.Windows.Forms.Button butCancel;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.TextBox textPasswordVerify;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.Label labelRecommend;
		private System.Windows.Forms.Button butUseBlank;
	}
}
