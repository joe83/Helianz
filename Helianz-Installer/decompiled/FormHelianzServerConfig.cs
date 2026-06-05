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
      try
      {
        Cursor = Cursors.WaitCursor;
        CreateMySqlUser();
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

    private void CreateMySqlUser()
    {
      string appUser = textAppUser.Text.Trim();
      string appPass = textAppPassword.Text;
      string dbName = textDatabase.Text.Trim();
      string lowUser = textLowPrivUser.Text.Trim();
      string lowPass = textLowPrivPassword.Text;

      string sql = "";
      sql += "CREATE USER IF NOT EXISTS '" + EscapeSql(appUser) + "'@'%' IDENTIFIED BY '" + EscapeSql(appPass) + "';\n";
      sql += "ALTER USER '" + EscapeSql(appUser) + "'@'%' IDENTIFIED BY '" + EscapeSql(appPass) + "';\n";
      sql += "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, " +
        "CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE " +
        "ON `" + EscapeSql(dbName) + "`.* TO '" + EscapeSql(appUser) + "'@'%';\n";

      if (!string.IsNullOrWhiteSpace(lowUser))
      {
        string effectiveLowPass = string.IsNullOrEmpty(lowPass) ? appPass : lowPass;
        sql += "CREATE USER IF NOT EXISTS '" + EscapeSql(lowUser) + "'@'%' IDENTIFIED BY '" + EscapeSql(effectiveLowPass) + "';\n";
        sql += "ALTER USER '" + EscapeSql(lowUser) + "'@'%' IDENTIFIED BY '" + EscapeSql(effectiveLowPass) + "';\n";
        sql += "GRANT SELECT ON `" + EscapeSql(dbName) + "`.* TO '" + EscapeSql(lowUser) + "'@'%';\n";
      }

      sql += "FLUSH PRIVILEGES;\n";

      ExecuteMySql(sql);
    }

    /// <summary>Executes SQL against MySQL via mysql.exe CLI using stdin redirect.
    /// This avoids command-line escaping issues with passwords containing special characters.</summary>
    private void ExecuteMySql(string sql)
    {
      string host = textHost.Text.Trim();
      string port = textPort.Text.Trim();
      string dbName = textDatabase.Text.Trim();
      string rootUser = textRootUser.Text.Trim();
      string rootPass = textRootPassword.Text;

      string mysqlExe = Path.Combine(_mariaDbInstallDir, "bin", "mysql.exe");
      if (!File.Exists(mysqlExe))
        throw new FileNotFoundException(
          "mysql.exe not found at: " + mysqlExe + "\r\nPlease verify the MariaDB installation directory.");

      using (Process process = new Process())
      {
        process.StartInfo.FileName = mysqlExe;
        process.StartInfo.Arguments = "--host=" + host + " --port=" + port + " --user=" + rootUser;
        if (!string.IsNullOrEmpty(rootPass))
          process.StartInfo.Arguments += " --password=" + rootPass;
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
        process.WaitForExit(60000); // 60-second timeout for slow servers

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

      // Default low-priv credentials to the same as the application user if left blank.
      if (string.IsNullOrEmpty(userLow))
        userLow = user;
      if (string.IsNullOrEmpty(passwordLow))
        passwordLow = password;

      using (StreamWriter writer = new StreamWriter(xmlPath, false))
      {
        writer.WriteLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
        writer.WriteLine("<HelianzServerConfig>");
        writer.WriteLine("  <ComputerName>" + SecurityElement.Escape(computerName) + "</ComputerName>");
        writer.WriteLine("  <Database>" + SecurityElement.Escape(database) + "</Database>");
        writer.WriteLine("  <User>" + SecurityElement.Escape(user) + "</User>");
        writer.WriteLine("  <Password>" + SecurityElement.Escape(password) + "</Password>");
        writer.WriteLine("  <UserLow>" + SecurityElement.Escape(userLow) + "</UserLow>");
        writer.WriteLine("  <PasswordLow>" + SecurityElement.Escape(passwordLow) + "</PasswordLow>");
        writer.WriteLine("  <ServerPort>" + SecurityElement.Escape(serverPort) + "</ServerPort>");
        writer.WriteLine("</HelianzServerConfig>");
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
  }
}
