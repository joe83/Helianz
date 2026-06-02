namespace Helianz {
        partial class FormMidtransSetup {
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
                        this.labelServerKey = new System.Windows.Forms.Label();
                        this.textServerKey = new System.Windows.Forms.TextBox();
                        this.labelClientKey = new System.Windows.Forms.Label();
                        this.textClientKey = new System.Windows.Forms.TextBox();
                        this.labelMerchantName = new System.Windows.Forms.Label();
                        this.textMerchantName = new System.Windows.Forms.TextBox();
                        this.labelNote = new System.Windows.Forms.Label();
                        this.textNote = new System.Windows.Forms.TextBox();
                        this.checkIsEnabled = new Helianz.UI.CheckBox();
                        this.groupEnvironment = new Helianz.UI.GroupBox();
                        this.radioSandbox = new System.Windows.Forms.RadioButton();
                        this.radioProduction = new System.Windows.Forms.RadioButton();
                        this.butSave = new Helianz.UI.Button();
                        this.butCancel = new Helianz.UI.Button();
                        this.groupEnvironment.SuspendLayout();
                        this.SuspendLayout();
                        // 
                        // labelServerKey
                        // 
                        this.labelServerKey.Location = new System.Drawing.Point(12, 18);
                        this.labelServerKey.Name = "labelServerKey";
                        this.labelServerKey.Size = new System.Drawing.Size(110, 20);
                        this.labelServerKey.TabIndex = 0;
                        this.labelServerKey.Text = "Server Key";
                        this.labelServerKey.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
                        // 
                        // textServerKey
                        // 
                        this.textServerKey.Location = new System.Drawing.Point(128, 18);
                        this.textServerKey.Name = "textServerKey";
                        this.textServerKey.Size = new System.Drawing.Size(310, 20);
                        this.textServerKey.TabIndex = 1;
                        // 
                        // labelClientKey
                        // 
                        this.labelClientKey.Location = new System.Drawing.Point(12, 44);
                        this.labelClientKey.Name = "labelClientKey";
                        this.labelClientKey.Size = new System.Drawing.Size(110, 20);
                        this.labelClientKey.TabIndex = 2;
                        this.labelClientKey.Text = "Client Key";
                        this.labelClientKey.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
                        // 
                        // textClientKey
                        // 
                        this.textClientKey.Location = new System.Drawing.Point(128, 44);
                        this.textClientKey.Name = "textClientKey";
                        this.textClientKey.Size = new System.Drawing.Size(310, 20);
                        this.textClientKey.TabIndex = 3;
                        // 
                        // labelMerchantName
                        // 
                        this.labelMerchantName.Location = new System.Drawing.Point(12, 70);
                        this.labelMerchantName.Name = "labelMerchantName";
                        this.labelMerchantName.Size = new System.Drawing.Size(110, 20);
                        this.labelMerchantName.TabIndex = 4;
                        this.labelMerchantName.Text = "Merchant Name";
                        this.labelMerchantName.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
                        // 
                        // textMerchantName
                        // 
                        this.textMerchantName.Location = new System.Drawing.Point(128, 70);
                        this.textMerchantName.Name = "textMerchantName";
                        this.textMerchantName.Size = new System.Drawing.Size(310, 20);
                        this.textMerchantName.TabIndex = 5;
                        // 
                        // labelNote
                        // 
                        this.labelNote.Location = new System.Drawing.Point(12, 96);
                        this.labelNote.Name = "labelNote";
                        this.labelNote.Size = new System.Drawing.Size(110, 20);
                        this.labelNote.TabIndex = 6;
                        this.labelNote.Text = "Note";
                        this.labelNote.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
                        // 
                        // textNote
                        // 
                        this.textNote.Location = new System.Drawing.Point(128, 96);
                        this.textNote.Multiline = true;
                        this.textNote.Name = "textNote";
                        this.textNote.Size = new System.Drawing.Size(310, 60);
                        this.textNote.TabIndex = 7;
                        // 
                        // checkIsEnabled
                        // 
                        this.checkIsEnabled.Location = new System.Drawing.Point(128, 162);
                        this.checkIsEnabled.Name = "checkIsEnabled";
                        this.checkIsEnabled.Size = new System.Drawing.Size(200, 20);
                        this.checkIsEnabled.TabIndex = 8;
                        this.checkIsEnabled.Text = "Enabled";
                        // 
                        // groupEnvironment
                        // 
                        this.groupEnvironment.Controls.Add(this.radioSandbox);
                        this.groupEnvironment.Controls.Add(this.radioProduction);
                        this.groupEnvironment.Location = new System.Drawing.Point(128, 188);
                        this.groupEnvironment.Name = "groupEnvironment";
                        this.groupEnvironment.Size = new System.Drawing.Size(200, 60);
                        this.groupEnvironment.TabIndex = 9;
                        this.groupEnvironment.Text = "Environment";
                        // 
                        // radioSandbox
                        // 
                        this.radioSandbox.Checked = true;
                        this.radioSandbox.Location = new System.Drawing.Point(6, 16);
                        this.radioSandbox.Name = "radioSandbox";
                        this.radioSandbox.Size = new System.Drawing.Size(90, 20);
                        this.radioSandbox.TabIndex = 0;
                        this.radioSandbox.TabStop = true;
                        this.radioSandbox.Text = "Sandbox";
                        // 
                        // radioProduction
                        // 
                        this.radioProduction.Location = new System.Drawing.Point(100, 16);
                        this.radioProduction.Name = "radioProduction";
                        this.radioProduction.Size = new System.Drawing.Size(94, 20);
                        this.radioProduction.TabIndex = 1;
                        this.radioProduction.Text = "Production";
                        // 
                        // butSave
                        // 
                        this.butSave.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
                        this.butSave.Location = new System.Drawing.Point(282, 264);
                        this.butSave.Name = "butSave";
                        this.butSave.Size = new System.Drawing.Size(75, 24);
                        this.butSave.TabIndex = 10;
                        this.butSave.Text = "Save";
                        this.butSave.Click += new System.EventHandler(this.butSave_Click);
                        // 
                        // butCancel
                        // 
                        this.butCancel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
                        this.butCancel.Location = new System.Drawing.Point(363, 264);
                        this.butCancel.Name = "butCancel";
                        this.butCancel.Size = new System.Drawing.Size(75, 24);
                        this.butCancel.TabIndex = 11;
                        this.butCancel.Text = "Cancel";
                        this.butCancel.Click += new System.EventHandler(this.butCancel_Click);
                        // 
                        // FormMidtransSetup
                        // 
                        this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.None;
                        this.ClientSize = new System.Drawing.Size(450, 300);
                        this.Controls.Add(this.labelServerKey);
                        this.Controls.Add(this.textServerKey);
                        this.Controls.Add(this.labelClientKey);
                        this.Controls.Add(this.textClientKey);
                        this.Controls.Add(this.labelMerchantName);
                        this.Controls.Add(this.textMerchantName);
                        this.Controls.Add(this.labelNote);
                        this.Controls.Add(this.textNote);
                        this.Controls.Add(this.checkIsEnabled);
                        this.Controls.Add(this.groupEnvironment);
                        this.Controls.Add(this.butSave);
                        this.Controls.Add(this.butCancel);
                        this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
                        this.MaximizeBox = false;
                        this.MinimizeBox = false;
                        this.Name = "FormMidtransSetup";
                        this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                        this.Text = "Midtrans QRIS Setup";
                        this.Load += new System.EventHandler(this.FormMidtransSetup_Load);
                        this.groupEnvironment.ResumeLayout(false);
                        this.ResumeLayout(false);
                        this.PerformLayout();
                }

                #endregion

                private System.Windows.Forms.Label labelServerKey;
                private System.Windows.Forms.TextBox textServerKey;
                private System.Windows.Forms.Label labelClientKey;
                private System.Windows.Forms.TextBox textClientKey;
                private System.Windows.Forms.Label labelMerchantName;
                private System.Windows.Forms.TextBox textMerchantName;
                private System.Windows.Forms.Label labelNote;
                private System.Windows.Forms.TextBox textNote;
                private Helianz.UI.CheckBox checkIsEnabled;
                private Helianz.UI.GroupBox groupEnvironment;
                private System.Windows.Forms.RadioButton radioSandbox;
                private System.Windows.Forms.RadioButton radioProduction;
                private Helianz.UI.Button butSave;
                private Helianz.UI.Button butCancel;
        }
}