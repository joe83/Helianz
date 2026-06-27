using CodeBase;
using DataConnectionBase;
using System;
using System.ComponentModel;
using System.Drawing;
using System.Windows.Forms;

namespace FreeDentalInstaller
{
  public partial class FormMysqlCredentials : Form
  {
    private DataConnection _conRoot = null;

    /// <summary>The MySQL root password entered by the user (blank if left blank).</summary>
    public string RootPassword => this.textPassword.Text;

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

  }
}
