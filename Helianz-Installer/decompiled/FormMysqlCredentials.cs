using CodeBase;
using DataConnectionBase;
using System;
using System.ComponentModel;
using System.Drawing;
using System.Windows.Forms;

namespace FreeDentalInstaller
{
  public class FormMysqlCredentials : Form
  {
    private DataConnection _conRoot = null;
    private IContainer components = null;
    private TextBox textUserName;
    private Label labelUserName;
    private Label label1;
    private TextBox textPassword;
    private Button butOK;
    private Button butCancel;
    private Label label2;
    private TextBox textPasswordVerify;
    private Label label3;
    private Label labelRecommend;
    private Button butUseBlank;

    public FormMysqlCredentials() => this.InitializeComponent();

    private void FormMysqlCredentials_Load(object sender, EventArgs e)
    {
      ODException.SwallowAnyException((Action) (() => this._conRoot = DbAdminMysql.ConnectAndTest("root", "")));
      if (this._conRoot != null)
        return;
      this.DialogResult = DialogResult.Cancel;
      this.Close();
    }

    private void textPassword_KeyUp(object sender, KeyEventArgs e) => this.butOK.Enabled = true;

    private void ClickOK(bool useBlankPassword)
    {
      if (this.textPassword.Text != this.textPasswordVerify.Text)
      {
        MessageBox.Show("MySQL Password does not match Verify Password.");
      }
      else
      {
        string text = DbAdminMysql.ModifyUser(this._conRoot, this.textUserName.Text, this.textPassword.Text, "root");
        if (text != null)
        {
          MessageBox.Show(text);
        }
        else if (string.IsNullOrEmpty(this.textPassword.Text) && !useBlankPassword)
        {
          this.butOK.Enabled = false;
          this.labelRecommend.Visible = true;
          this.butUseBlank.Visible = true;
        }
        else
        {
          this.DialogResult = DialogResult.OK;
          this.Close();
        }
      }
    }

    private void butUseBlank_Click(object sender, EventArgs e)
    {
      this.textPassword.Clear();
      this.textPasswordVerify.Clear();
      this.ClickOK(true);
    }

    private void butOK_Click(object sender, EventArgs e) => this.ClickOK(false);

    private void butCancel_Click(object sender, EventArgs e)
    {
      this.DialogResult = DialogResult.Cancel;
      this.Close();
    }

    private void FormMysqlCredentials_FormClosing(object sender, FormClosingEventArgs e)
    {
      if (this._conRoot == null)
        return;
      this._conRoot.Dispose();
    }

    protected override void Dispose(bool disposing)
    {
      if (disposing && this.components != null)
        this.components.Dispose();
      base.Dispose(disposing);
    }

    private void InitializeComponent()
    {
      ComponentResourceManager componentResourceManager = new ComponentResourceManager(typeof(FormMysqlCredentials));
      this.textUserName = new TextBox();
      this.labelUserName = new Label();
      this.label1 = new Label();
      this.textPassword = new TextBox();
      this.butOK = new Button();
      this.butCancel = new Button();
      this.label2 = new Label();
      this.textPasswordVerify = new TextBox();
      this.label3 = new Label();
      this.labelRecommend = new Label();
      this.butUseBlank = new Button();
      this.SuspendLayout();
      this.textUserName.Location = new Point(139, 39);
      this.textUserName.Name = "textUserName";
      this.textUserName.Size = new Size(154, 20);
      this.textUserName.TabIndex = 1;
      this.textUserName.Text = "root";
      this.labelUserName.Location = new Point(23, 39);
      this.labelUserName.Name = "labelUserName";
      this.labelUserName.Size = new Size(113, 20);
      this.labelUserName.TabIndex = 0;
      this.labelUserName.Text = "MySQL UserName";
      this.labelUserName.TextAlign = ContentAlignment.MiddleRight;
      this.label1.Location = new Point(20, 65);
      this.label1.Name = "label1";
      this.label1.Size = new Size(116, 20);
      this.label1.TabIndex = 0;
      this.label1.Text = "MySQL Password";
      this.label1.TextAlign = ContentAlignment.MiddleRight;
      this.textPassword.Location = new Point(139, 65);
      this.textPassword.Name = "textPassword";
      this.textPassword.Size = new Size(154, 20);
      this.textPassword.TabIndex = 2;
      this.textPassword.UseSystemPasswordChar = true;
      this.textPassword.KeyUp += new KeyEventHandler(this.textPassword_KeyUp);
      this.butOK.Anchor = AnchorStyles.Bottom | AnchorStyles.Right;
      this.butOK.Location = new Point(139, 162);
      this.butOK.Name = "butOK";
      this.butOK.Size = new Size(75, 23);
      this.butOK.TabIndex = 4;
      this.butOK.Text = "OK";
      this.butOK.UseVisualStyleBackColor = true;
      this.butOK.Click += new EventHandler(this.butOK_Click);
      this.butCancel.Anchor = AnchorStyles.Bottom | AnchorStyles.Right;
      this.butCancel.Location = new Point(220, 162);
      this.butCancel.Name = "butCancel";
      this.butCancel.Size = new Size(75, 23);
      this.butCancel.TabIndex = 5;
      this.butCancel.Text = "Cancel";
      this.butCancel.UseVisualStyleBackColor = true;
      this.butCancel.Click += new EventHandler(this.butCancel_Click);
      this.label2.Location = new Point(20, 91);
      this.label2.Name = "label2";
      this.label2.Size = new Size(116, 20);
      this.label2.TabIndex = 0;
      this.label2.Text = "Verify Password";
      this.label2.TextAlign = ContentAlignment.MiddleRight;
      this.textPasswordVerify.Location = new Point(139, 91);
      this.textPasswordVerify.Name = "textPasswordVerify";
      this.textPasswordVerify.Size = new Size(154, 20);
      this.textPasswordVerify.TabIndex = 3;
      this.textPasswordVerify.UseSystemPasswordChar = true;
      this.label3.Location = new Point(23, 9);
      this.label3.Name = "label3";
      this.label3.Size = new Size(291, 20);
      this.label3.TabIndex = 6;
      this.label3.Text = "Invalid characters are: quotes, slashes, newlines, tabs";
      this.label3.TextAlign = ContentAlignment.MiddleCenter;
      this.labelRecommend.ForeColor = Color.Red;
      this.labelRecommend.Location = new Point(26, 114);
      this.labelRecommend.Name = "labelRecommend";
      this.labelRecommend.Size = new Size(269, 45);
      this.labelRecommend.TabIndex = 7;
      this.labelRecommend.Text = "Helianz highly recommends you set a password for the root user.  Failing to set a root user password can cause security vulnerabilities.";
      this.labelRecommend.TextAlign = ContentAlignment.MiddleLeft;
      this.labelRecommend.Visible = false;
      this.butUseBlank.Anchor = AnchorStyles.Bottom | AnchorStyles.Right;
      this.butUseBlank.Location = new Point(12, 162);
      this.butUseBlank.Name = "butUseBlank";
      this.butUseBlank.Size = new Size(121, 23);
      this.butUseBlank.TabIndex = 6;
      this.butUseBlank.Text = "Use Blank Password";
      this.butUseBlank.UseVisualStyleBackColor = true;
      this.butUseBlank.Visible = false;
      this.butUseBlank.Click += new EventHandler(this.butUseBlank_Click);
      this.AutoScaleDimensions = new SizeF(6f, 13f);
      this.AutoScaleMode = AutoScaleMode.Font;
      this.ClientSize = new Size(326, 197);
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
      this.FormBorderStyle = FormBorderStyle.FixedSingle;
      this.Icon = (Icon)componentResourceManager.GetObject("$this.Icon");
      this.Name = nameof (FormMysqlCredentials);
      this.Text = "MySQL Credentials";
      this.FormClosing += new FormClosingEventHandler(this.FormMysqlCredentials_FormClosing);
      this.Load += new EventHandler(this.FormMysqlCredentials_Load);
      this.ResumeLayout(false);
      this.PerformLayout();
    }
  }
}
