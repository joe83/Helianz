using CodeBase;
using DataConnectionBase;
using System;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Security;
using System.Windows.Forms;

namespace FreeDentalInstaller
{
  public partial class FormHelianzServerConfig : Form
  {
    private string _mariaDbInstallDir = "";
    private string _helianzServerDir = "";
    private DataConnection _conRoot = null;
    private bool _rootHasBlankPassword;

    /// <summary>MariaDB installation directory containing bin\mysql.exe.</summary>
    public string MariaDbInstallDir
    {
      get => _mariaDbInstallDir;
      set => _mariaDbInstallDir = value.TrimEnd('\\');
    }

    /// <summary>HelianzServer directory where HelianzServerConfig.xml will be written.</summary>
    public string HelianzServerDir
    {
      get => _helianzServerDir;
      set => _helianzServerDir = value.TrimEnd('\\');
    }

    public FormHelianzServerConfig() => this.InitializeComponent();

    private void FormHelianzServerConfig_Load(object sender, EventArgs e)
    {
      textRootUser.Text = "root";
      textHost.Text = "localhost";
      textPort.Text = "3306";
      textDatabase.Text = "helianz";
      textAppUser.Text = "oduser";
      textServerPort.Text = "9390";
      textHelianzServerPath.Text = _helianzServerDir;
      butOK.Enabled = false;

      // Probe: try connecting as root with blank password to detect the current state.
      _rootHasBlankPassword = false;
      ODException.SwallowAnyException((Action)(() =>
      {
        _conRoot = DbAdminMysql.ConnectAndTest("root", "");
        if (_conRoot != null)
          _rootHasBlankPassword = true;
      }));

      if (_rootHasBlankPassword)
      {
        // Root has blank password — user MUST set a new one (security best practice).
        // Hide the "current root password" field, show "new root password" section.
        grpRootCurrent.Visible = false;
        grpRootNew.Visible = true;
        labelRootStatus.Text = "Root has a blank password. Set a new password below.";
        labelRootStatus.ForeColor = Color.OrangeRed;
      }
      else
      {
        // Root already has a password — user enters it to authenticate.
        // Optionally they can change it via the "new password" section.
        grpRootCurrent.Visible = true;
        grpRootNew.Visible = false;
        labelRootStatus.Text = "Root password is already set. Enter it to continue.";
        labelRootStatus.ForeColor = Color.DarkGray;
      }
    }

    private void textAppPassword_KeyUp(object sender, KeyEventArgs e)
    {
      butOK.Enabled = textAppPassword.Text.Length > 0;
    }

    private void butTestConnection_Click(object sender, EventArgs e)
    {
      try
      {
        Cursor = Cursors.WaitCursor;
        ExecuteMySql("SELECT 1;");
        Cursor = Cursors.Default;
        MessageBox.Show("MySQL connection successful.", "Test Connection",
          MessageBoxButtons.OK, MessageBoxIcon.Information);
      }
      catch (Exception ex)
      {
        Cursor = Cursors.Default;
        MessageBox.Show("Connection failed:\r\n" + ex.Message, "Test Connection",
          MessageBoxButtons.OK, MessageBoxIcon.Error);
      }
    }

    private void butOK_Click(object sender, EventArgs e)
    {
      // Validate application DB password.
      if (string.IsNullOrWhiteSpace(textAppPassword.Text))
      {
        MessageBox.Show("Application DB password is required.");
        return;
      }
      if (textAppPassword.Text != textAppPasswordVerify.Text)
      {
        MessageBox.Show("Application DB password does not match verify password.");
        return;
      }
      string serverDir = textHelianzServerPath.Text.TrimEnd('\\');
      if (string.IsNullOrEmpty(serverDir) || !Directory.Exists(serverDir))
      {
        MessageBox.Show("HelianzServer path does not exist:\r\n" + serverDir);
        return;
      }

      // Validate new root password if user chose to set/change one.
      if (grpRootNew.Visible)
      {
        if (string.IsNullOrEmpty(textNewRootPassword.Text) && !chkKeepBlankRoot.Checked)
        {
          MessageBox.Show("Please set a new root password, or check \"Keep blank\".");
          return;
        }
        if (!string.IsNullOrEmpty(textNewRootPassword.Text) &&
            textNewRootPassword.Text != textNewRootVerifyPassword.Text)
        {
          MessageBox.Show("New root password does not match verify password.");
          return;
        }
      }

      try
      {
        Cursor = Cursors.WaitCursor;

        // Step 1: Connect as root and optionally change the root password.
        EnsureRootConnection();

        // Step 2: Create the oduser MySQL account with scoped privileges.
        CreateMySqlUser();

        // Step 3: Write HelianzServerConfig.xml (uses oduser, never root).
        WriteConfigXml(serverDir);

        Cursor = Cursors.Default;
        MessageBox.Show(
          "HelianzServer configuration complete.\r\n\r\n" +
          "Created MySQL user '" + textAppUser.Text.Trim() + "' with scoped privileges.\r\n" +
          "Config file: " + Path.Combine(serverDir, "HelianzServerConfig.xml"),
          "Configuration Complete",
          MessageBoxButtons.OK, MessageBoxIcon.Information);
        DialogResult = DialogResult.OK;
        Close();
      }
      catch (Exception ex)
      {
        Cursor = Cursors.Default;
        MessageBox.Show("Configuration error:\r\n" + ex.Message,
          "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
      }
    }

    /// <summary>Ensures we have a working root connection. If root had blank password
    /// and user set a new one, applies the change. If root had a password, validates it.</summary>
    private void EnsureRootConnection()
    {
      if (_rootHasBlankPassword)
      {
        // Root currently has blank password. Apply the new password (or keep blank).
        string newPass = chkKeepBlankRoot.Checked ? "" : textNewRootPassword.Text;
        string error = DbAdminMysql.ModifyUser(_conRoot, "root", newPass, "root");
        if (error != null)
          throw new Exception("Failed to set root password:\r\n" + error);
        // Reconnect with the new password for subsequent operations.
        _conRoot.Dispose();
        _conRoot = DbAdminMysql.ConnectAndTest("root", newPass);
        // Update the password field used by ExecuteMySql for subsequent calls.
        textRootPassword.Text = newPass;
      }
      else
      {
        // Root already has a password. The _conRoot from Load may be null.
        // We'll rely on ExecuteMySql using textRootPassword.Text directly.
        // Optionally change the root password if the user filled in the new section.
        if (grpRootNew.Visible && !string.IsNullOrEmpty(textNewRootPassword.Text))
        {
          // User wants to change root password — do it via mysql.exe.
          string currentPass = textRootPassword.Text;
          string newPass = textNewRootPassword.Text;
          string sql = "ALTER USER 'root'@'localhost' IDENTIFIED BY '" + EscapeSql(newPass) + "';\n" +
                       "ALTER USER 'root'@'%' IDENTIFIED BY '" + EscapeSql(newPass) + "';\n" +
                       "FLUSH PRIVILEGES;\n";
          // Connect with current password to change it.
          ExecuteMySqlWithPassword(currentPass, sql);
          textRootPassword.Text = newPass;
        }
      }
    }

    private void CreateMySqlUser()
    {
      string appUser = textAppUser.Text.Trim();
      string appPass = textAppPassword.Text;
      string dbName = textDatabase.Text.Trim();
      string lowUser = textLowPrivUser.Text.Trim();
      string lowPass = textLowPrivPassword.Text;

      string sql = "";
      // MySQL only serves locally — clinics connect via HelianzServer SOAP, not directly to MySQL.
      // Restrict all users to 'localhost' so MySQL never accepts remote connections.
      sql += "CREATE USER IF NOT EXISTS '" + EscapeSql(appUser) + "'@'localhost' IDENTIFIED BY '" + EscapeSql(appPass) + "';\n";
      sql += "ALTER USER '" + EscapeSql(appUser) + "'@'localhost' IDENTIFIED BY '" + EscapeSql(appPass) + "';\n";
      sql += "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, " +
        "CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE " +
        "ON `" + EscapeSql(dbName) + "`.* TO '" + EscapeSql(appUser) + "'@'localhost';\n";

      if (!string.IsNullOrWhiteSpace(lowUser))
      {
        string effectiveLowPass = string.IsNullOrEmpty(lowPass) ? appPass : lowPass;
        sql += "CREATE USER IF NOT EXISTS '" + EscapeSql(lowUser) + "'@'localhost' IDENTIFIED BY '" + EscapeSql(effectiveLowPass) + "';\n";
        sql += "ALTER USER '" + EscapeSql(lowUser) + "'@'localhost' IDENTIFIED BY '" + EscapeSql(effectiveLowPass) + "';\n";
        sql += "GRANT SELECT ON `" + EscapeSql(dbName) + "`.* TO '" + EscapeSql(lowUser) + "'@'localhost';\n";
      }

      sql += "FLUSH PRIVILEGES;\n";
      ExecuteMySql(sql);
    }

    /// <summary>Executes SQL via mysql.exe using the root password from the UI.</summary>
    private void ExecuteMySql(string sql)
    {
      ExecuteMySqlWithPassword(textRootPassword.Text, sql);
    }

    /// <summary>Executes SQL via mysql.exe with an explicit password (for root password changes).</summary>
    private void ExecuteMySqlWithPassword(string password, string sql)
    {
      string host = textHost.Text.Trim();
      string port = textPort.Text.Trim();
      string dbName = textDatabase.Text.Trim();
      string rootUser = textRootUser.Text.Trim();

      string mysqlExe = Path.Combine(_mariaDbInstallDir, "bin", "mysql.exe");
      if (!File.Exists(mysqlExe))
        throw new FileNotFoundException(
          "mysql.exe not found at: " + mysqlExe + "\r\nPlease verify the MariaDB installation directory.");

      using (Process process = new Process())
      {
        process.StartInfo.FileName = mysqlExe;
        process.StartInfo.Arguments = "--host=" + host + " --port=" + port + " --user=" + rootUser;
        if (!string.IsNullOrEmpty(password))
          process.StartInfo.Arguments += " --password=" + password;
        process.StartInfo.Arguments += " " + dbName;
        process.StartInfo.UseShellExecute = false;
        process.StartInfo.RedirectStandardInput = true;
        process.StartInfo.RedirectStandardError = true;
        process.StartInfo.RedirectStandardOutput = true;
        process.Start();

        process.StandardInput.Write(sql);
        process.StandardInput.Close();

        string output = process.StandardOutput.ReadToEnd();
        string error = process.StandardError.ReadToEnd();
        process.WaitForExit(60000);

        if (process.ExitCode != 0)
        {
          string errMsg = string.IsNullOrEmpty(error) ? output : error;
          throw new Exception("MySQL command failed (exit " + process.ExitCode + "):\r\n" + errMsg);
        }
      }
    }

    /// <summary>Escapes a value for safe inclusion inside MySQL string literals.</summary>
    private static string EscapeSql(string value)
    {
      if (string.IsNullOrEmpty(value))
        return value;
      return value.Replace("\\", "\\\\")
        .Replace("'", "\\'")
        .Replace("\n", "\\n")
        .Replace("\r", "\\r")
        .Replace("\0", "\\0");
    }

    private void WriteConfigXml(string serverDir)
    {
      string xmlPath = Path.Combine(serverDir, "HelianzServerConfig.xml");

      string computerName = textHost.Text.Trim();
      string database = textDatabase.Text.Trim();
      string user = textAppUser.Text.Trim();
      string password = textAppPassword.Text;
      string userLow = textLowPrivUser.Text.Trim();
      string passwordLow = textLowPrivPassword.Text;
      string serverPort = textServerPort.Text.Trim();

      if (string.IsNullOrEmpty(userLow))
        userLow = user;
      if (string.IsNullOrEmpty(passwordLow))
        passwordLow = password;

      using (StreamWriter writer = new StreamWriter(xmlPath, false))
      {
        writer.WriteLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
        writer.WriteLine("<ConnectionSettings>");
        writer.WriteLine("  <ServerPort>" + SecurityElement.Escape(serverPort) + "</ServerPort>");
        writer.WriteLine("  <DatabaseConnection>");
        writer.WriteLine("    <ComputerName>" + SecurityElement.Escape(computerName) + "</ComputerName>");
        writer.WriteLine("    <Database>" + SecurityElement.Escape(database) + "</Database>");
        writer.WriteLine("    <User>" + SecurityElement.Escape(user) + "</User>");
        writer.WriteLine("    <Password>" + SecurityElement.Escape(password) + "</Password>");
        writer.WriteLine("    <UserLow>" + SecurityElement.Escape(userLow) + "</UserLow>");
        writer.WriteLine("    <PasswordLow>" + SecurityElement.Escape(passwordLow) + "</PasswordLow>");
        writer.WriteLine("    <DatabaseType>MySql</DatabaseType>");
        writer.WriteLine("    <ApplicationName>/HelianzServer</ApplicationName>");
        writer.WriteLine("    <VerboseLogging>false</VerboseLogging>");
        writer.WriteLine("  </DatabaseConnection>");
        writer.WriteLine("</ConnectionSettings>");
      }
    }

    private void butCancel_Click(object sender, EventArgs e)
    {
      DialogResult = DialogResult.Cancel;
      Close();
    }

    private void butBrowse_Click(object sender, EventArgs e)
    {
      using (FolderBrowserDialog dlg = new FolderBrowserDialog())
      {
        dlg.Description = "Select HelianzServer installation directory";
        if (!string.IsNullOrEmpty(textHelianzServerPath.Text) && Directory.Exists(textHelianzServerPath.Text))
          dlg.SelectedPath = textHelianzServerPath.Text;
        if (dlg.ShowDialog(this) == DialogResult.OK)
          textHelianzServerPath.Text = dlg.SelectedPath;
      }
    }

    private void FormHelianzServerConfig_FormClosing(object sender, FormClosingEventArgs e)
    {
      if (_conRoot == null)
        return;
      _conRoot.Dispose();
    }

    /// <summary>Toggles the optional "New Root Password" section visibility.</summary>
    private void chkChangeRootPassword_CheckedChanged(object sender, EventArgs e)
    {
      // Show or hide the whole "Set Root Password" group when the checkbox is toggled.
      grpRootNew.Visible = chkChangeRootPassword.Checked;
      if (chkChangeRootPassword.Checked)
      {
        // Focus the new password textbox when becoming visible.
        textNewRootPassword.Focus();
      }
    }
  }
}
