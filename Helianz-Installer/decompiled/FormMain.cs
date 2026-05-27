using CodeBase;
using DataConnectionBase;
using HelianzInstaller;
using HelianzInstaller.Properties;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Reflection;
using System.ServiceProcess;
using System.Windows.Forms;

namespace FreeDentalInstaller
{
  public partial class FormMain : Form
  {
    private string _appPath;
    private string _programFilesx86;
    private string _programFiles64;
    private DbmsType _dbmsType;
    private const string WINDOWS_SERVICE_NAME = "MySQL";
    public const string PORT_NUM = "3306";
    public static Version VersionInstaller;
    public static string Architecturetype;

    public FormMain()
    {
      this.InitializeComponent();
      this._dbmsType = Utilities.GetDbmsType();
      FormMain.VersionInstaller = Assembly.GetExecutingAssembly().GetName().Version;
      FormMain.Architecturetype = this._dbmsType == DbmsType.MariaDB ? "win64" : "win32";
    }

    private void FormMain_Load(object sender, EventArgs e)
    {
      if (!ODEnvironment.IsRunningAsAdministrator())
      {
        int num = (int) MessageBox.Show("Please run as administrator then try again.");
        Application.Exit();
      }
      else
      {
        if (this._dbmsType == DbmsType.MariaDB)
          this.textServer.Text = "Runs the setup for the MariaDB program. MariaDB - Copyright 2009-" + DateTime.Now.ToString("yyyy") + ", www.mariadb.com. MariaDB Community Server (GPL)";
        else
          this.textServer.Text = "Runs the setup for the MySQL program";
        string str = string.Format("{0}.{1}", FormMain.VersionInstaller.Major, FormMain.VersionInstaller.Minor);
        this.butUpdateDbms.Text = this._dbmsType.ToString();
        this.checkDbmsServer.Text = string.Format("{0} Server", this._dbmsType);
        this.label6.Text = string.Format("{0} server", this._dbmsType);
        this.checkGrant.Text = string.Format("{0} {1} grant tables", this._dbmsType, str);
        this.textGrantTables.Text = string.Format("These tables will be placed in the data\\mysql folder.  Required by {0} {1}. This will also prompt for {2} credentials.", this._dbmsType, str, this._dbmsType);
        this.textBox2.Text = string.Format("A small file that is required for {0} to function properly.  Uses the paths entered in the \"{1} Server\" box above and the \"helianz Database\" box below.", this._dbmsType, this._dbmsType);
        this._appPath = Application.StartupPath;
        this._programFilesx86 = Environment.GetEnvironmentVariable("ProgramFiles(x86)");
        this._programFiles64 = Environment.GetEnvironmentVariable("ProgramFiles");
        if (Environment.Is64BitOperatingSystem)
          this._programFiles64 = string.Format("{0}Program Files{1}", Path.GetPathRoot(Environment.SystemDirectory), Path.DirectorySeparatorChar);
        if (string.IsNullOrEmpty(this._programFilesx86))
          this._programFilesx86 = Environment.GetEnvironmentVariable("ProgramFiles");
        this.textApplication.Text = Path.Combine(this._programFilesx86, "Helianz\\");
          this.textDbmsInstallationDir.Text = Path.Combine(this._programFilesx86, string.Format("{0}\\{1} Server {2}\\", this._dbmsType, this._dbmsType, str));
        if (this._dbmsType == DbmsType.MariaDB)
        {
          if (Environment.Is64BitOperatingSystem)
            this.textDbmsInstallationDir.Text = Path.Combine(this._programFiles64, string.Format("{0} {1}\\", this._dbmsType, str));
          else
            this.textDbmsInstallationDir.Text = Path.Combine(this._programFilesx86, "MariaDB " + str + "\\");
        }
        if (File.Exists(Application.StartupPath + "\\Helianz Setup\\Setup.exe"))
        {
          this.checkOD.Checked = true;
          this.checkDbmsServer.Checked = true;
          this.checkGrant.Checked = true;
          this.checkmyini.Checked = true;
          this.checkDatabase.Checked = true;
          this.checkODImages.Checked = true;
        }
        else
        {
          this.butFullInstall.Enabled = false;
          this.butNewServer.Enabled = false;
          this.butUpdateServer.Enabled = false;
          this.butWorkstation.Enabled = false;
          this.butUpdateDbms.Enabled = true;
          this.checkOD.Enabled = false;
          this.checkDbmsServer.Checked = true;
          this.checkGrant.Checked = true;
          this.checkmyini.Checked = true;
          this.checkDatabase.Checked = false;
          this.checkODImages.Checked = false;
        }
      }
    }

    private void butNewServer_Click(object sender, EventArgs e)
    {
      this.checkOD.Checked = true;
      this.checkDbmsServer.Checked = true;
      this.checkGrant.Checked = true;
      this.checkmyini.Checked = true;
      this.checkDatabase.Checked = true;
      this.checkODImages.Checked = true;
    }

    private void butUpdateServer_Click(object sender, EventArgs e)
    {
      this.checkOD.Checked = true;
      if (Directory.Exists(this.textDbmsInstallationDir.Text))
      {
        this.checkDbmsServer.Checked = false;
        this.checkGrant.Checked = false;
        this.checkmyini.Checked = false;
      }
      else
      {
        this.checkDbmsServer.Checked = true;
        this.checkGrant.Checked = true;
        this.checkmyini.Checked = true;
      }
      this.checkDatabase.Checked = false;
      this.checkODImages.Checked = false;
    }

    private void butWorkstation_Click(object sender, EventArgs e)
    {
      this.checkOD.Checked = true;
      this.checkDbmsServer.Checked = false;
      this.checkGrant.Checked = false;
      this.checkmyini.Checked = false;
      this.checkDatabase.Checked = false;
      this.checkODImages.Checked = false;
    }

    private void butUpdateDbms_Click(object sender, EventArgs e)
    {
      this.checkOD.Checked = false;
      this.checkDbmsServer.Checked = true;
      this.checkGrant.Checked = true;
      this.checkmyini.Checked = true;
      this.checkDatabase.Checked = false;
      this.checkODImages.Checked = false;
    }

    private void butFullInstall_Click(object sender, EventArgs e)
    {
      this.checkOD.Checked = true;
      this.checkDbmsServer.Checked = true;
      this.checkGrant.Checked = true;
      this.checkmyini.Checked = true;
      this.checkDatabase.Checked = true;
      this.checkODImages.Checked = true;
    }

    private void butInstall_Click(object sender, EventArgs e)
    {
      if (!this.checkOD.Checked && !this.checkDbmsServer.Checked && !this.checkGrant.Checked && !this.checkmyini.Checked && !this.checkDatabase.Checked && !this.checkODImages.Checked)
      {
        MessageBox.Show("Please select installation items first.");
      }
      else
      {
        if (this.textHelianzImages.Text.Substring(this.textHelianzImages.Text.Length - 1) != "\\")
          this.textHelianzImages.Text += "\\";
        if (this.textDatabase.Text.Substring(this.textDatabase.Text.Length - 1) != "\\")
          this.textDatabase.Text += "\\";
        if (this.IsModifyingDataDir() && !Directory.Exists(this.textDatabase.Text))
        {
          try
          {
            Directory.CreateDirectory(this.textDatabase.Text);
          }
          catch (Exception ex)
          {
            MessageBox.Show("Failed to create '" + this.checkDatabase.Text + "' folder:\r\n" + ex.Message);
            return;
          }
        }
        if (this.checkODImages.Checked && !Directory.Exists(this.textHelianzImages.Text))
        {
          try
          {
            Directory.CreateDirectory(this.textHelianzImages.Text);
          }
          catch (Exception ex)
          {
            MessageBox.Show("Failed to create '" + this.checkODImages.Text + "' folder:\r\n" + ex.Message);
            return;
          }
        }
        if (this.checkOD.Checked && !this.CheckODhelper() || this.checkDbmsServer.Checked && !this.IsDbmsServerValid() || (this.checkDbmsServer.Checked || this.checkGrant.Checked || this.checkmyini.Checked) && !this.TryRemoveService() || this.checkDbmsServer.Checked && !this.CheckDbmsHelper() || this.checkGrant.Checked && !this.CheckGrantHelper() || this.checkmyini.Checked && !this.CheckMyIniHelper())
          return;
        string targetDB = "";
        if (this.checkDatabase.Checked && !this.CheckDatabaseHelper(out targetDB) || this.checkODImages.Checked && !this.CheckODImagesHelper())
          return;
        if ((this.checkDbmsServer.Checked || this.checkGrant.Checked || this.checkmyini.Checked) && !this.TryInstallService())
        {
          this.Cursor = Cursors.Default;
        }
        else
        {
          if (!string.IsNullOrEmpty(targetDB) && this.checkODImages.Checked && this.textHelianzImages.Text != "C:\\HelianzImages\\")
            this.TryUpdateDataPath(targetDB);
          if (this.checkGrant.Checked)
          {
            FormMysqlCredentials mysqlCredentials = new FormMysqlCredentials();
            mysqlCredentials.StartPosition = FormStartPosition.CenterParent;
            mysqlCredentials.ShowDialog(this);
          }
          this.Cursor = Cursors.Default;
          MessageBox.Show("Installation complete.  You can now close this program and start Helianz by clicking on the shortcut on your desktop.");
        }
      }
    }

    private bool IsDbmsServerValid()
    {
      string directoryName = Path.GetDirectoryName(this.textDatabase.Text);
      if (!string.IsNullOrEmpty(directoryName))
      {
        if (Directory.EnumerateFileSystemEntries(directoryName.TrimEnd('\\') + "\\\\").Any())
        {
          MessageBox.Show("The " + this.checkDatabase.Text + " directory is not empty. Please contact support to assist with updating your database.");
          return false;
        }
      }
      return true;
    }

    private bool IsModifyingDataDir() => this.checkGrant.Checked || this.checkDatabase.Checked;

    private bool CheckDbmsHelper() => this._dbmsType == DbmsType.MariaDB ? this.CheckMariaDBHelper() : this.CheckMySQLHelper();

    private bool CheckMariaDBHelper()
    {
      if (this.HasMySQLInstalled() || this.HasMariaDBInstalled())
        return false;
      try
      {
        CommandResult commandResult = Utilities.ProcessCommand("msiexec.exe", "/i \"" + (this._appPath + string.Format("\\mysql\\{0}-{1}.{2}.{3}-{4}.msi", this._dbmsType.ToString().ToLower(), FormMain.VersionInstaller.Major, FormMain.VersionInstaller.Minor, FormMain.VersionInstaller.Build, FormMain.Architecturetype)) + "\" INSTALLDIR=\"" + this.textDbmsInstallationDir.Text + "\" DATADIR=\"" + this.textDatabase.Text + "\" ADDLOCAL=ALL REMOVE=DEVEL,HeidiSQL,DBInstance /passive");
        if (commandResult.ExitCode != 0)
        {
          string message = commandResult.StandardError;
          message = string.IsNullOrEmpty(message) ? "Unknown error. " : throw new ApplicationException(message);
          if (this._dbmsType == DbmsType.MariaDB)
            message += "MariaDB can only be installed on Windows 8.1, Windows Server 2012 R2, or higher.";
        }
      }
      catch (Exception ex)
      {
        MessageBox.Show(string.Format("Failed to install {0} {1}.{2}. Error:\r\n", this._dbmsType, FormMain.VersionInstaller.Major, FormMain.VersionInstaller.Minor) + ex.Message);
        return false;
      }
      bool flag = false;
      if (MariaDB.IsInboundFirewallAvailable() && MariaDB.SetFirewallRuleToDefault())
        flag = true;
      if (!flag)
      {
        MessageBox.Show("Failed to modify the Windows Firewall exception for " + MariaDB.FirewallName + ". Please consider modifying that Windows Firewall exception.");
      }
      return true;
    }

    private bool CheckMySQLHelper()
    {
      if (this.HasMySQLInstalled())
        return false;
      MessageBox.Show("Ready to install MySQL version 5.5.  At the end, uncheck the box that says \"Launch the MySQL Instance Configuration Wizard\".  Then Finish.");
      string str = this._appPath + string.Format("\\mysql\\{0}-{1}.{2}.{3}-{4}.msi", this._dbmsType.ToString().ToLower(), FormMain.VersionInstaller.Major, FormMain.VersionInstaller.Minor, FormMain.VersionInstaller.Build, FormMain.Architecturetype);
      Utilities.ProcessCommand(Utilities.GetWindowsInstallerPath(), "/i " + str);
      return true;
    }

    private bool HasMySQLInstalled()
    {
      List<MySQL> mySqlVersions = MySQL.GetMySQLVersions();
      bool flag = mySqlVersions.Any(x => x.HasVersionInstalled(this._programFilesx86)) || mySqlVersions.Any(x => x.HasVersionInstalled(this._programFiles64));
      if (flag)
      {
        MessageBox.Show("Please uninstall the previous version of \"MySQL Server\" from your Control Panel | Programs and Features.  It will not remove your data files.  Once that has been done, run this installer again.");
      }
      return flag;
    }

    private bool HasMariaDBInstalled()
    {
      List<MariaDB> mariaDbVersions = MariaDB.GetMariaDBVersions();
      bool flag = mariaDbVersions.Any(x => x.HasVersionInstalled(this._programFilesx86)) || mariaDbVersions.Any(x => x.HasVersionInstalled(this._programFiles64));
      if (flag)
      {
        MessageBox.Show("Please uninstall the previous version of \"MariaDB Server\" from your Control Panel | Programs and Features.  Once that has been done, run this installer again.");
      }
      return flag;
    }

    private bool CheckGrantHelper()
    {
      if (Directory.Exists(this.textGrant.Text))
        Directory.Delete(this.textGrant.Text, true);
      Directory.CreateDirectory(this.textGrant.Text);
      FileInfo[] files1 = new DirectoryInfo(this._appPath + "\\GrantTables").GetFiles();
      for (int index = 0; index < files1.Length; ++index)
      {
        File.Copy(this._appPath + "\\GrantTables\\" + files1[index].Name, this.textGrant.Text + files1[index].Name);
        File.SetAttributes(this.textGrant.Text + files1[index].Name, FileAttributes.Normal);
      }
      if (this._dbmsType == DbmsType.MariaDB)
      {
        FileInfo[] files2 = new DirectoryInfo(this._appPath + "\\Performance Schema").GetFiles();
        string str1 = Path.Combine(this.textDatabase.Text, "performance_schema");
        if (Directory.Exists(str1))
          Directory.Delete(str1, true);
        Directory.CreateDirectory(str1);
        for (int index = 0; index < files2.Length; ++index)
        {
          string str2 = Path.Combine(str1, files2[index].Name);
          File.Copy(this._appPath + "\\Performance Schema\\" + files2[index].Name, str2);
          File.SetAttributes(str2, FileAttributes.Normal);
        }
        string sourceFileName1 = Path.Combine(this._appPath, "ib_logfile0");
        string str3 = Path.Combine(this.textDatabase.Text, "ib_logfile0");
        if (File.Exists(str3))
          File.Delete(str3);
        File.Copy(sourceFileName1, str3);
        File.SetAttributes(str3, FileAttributes.Normal);
        string sourceFileName2 = Path.Combine(this._appPath, "ibdata1");
        string str4 = Path.Combine(this.textDatabase.Text, "ibdata1");
        if (File.Exists(str4))
          File.Delete(str4);
        File.Copy(sourceFileName2, str4);
        File.SetAttributes(str4, FileAttributes.Normal);
      }
      return true;
    }

    private void checkDbmsServer_CheckedChanged(object sender, EventArgs e)
    {
      this.checkGrant.Checked = this.checkDbmsServer.Checked;
      this.checkGrant.Enabled = this.checkDbmsServer.Checked;
    }

    private bool CheckMyIniHelper()
    {
      if (!Directory.Exists(this.textmyini.Text))
      {
        string str = "";
        if (this._dbmsType == DbmsType.MySQL)
          str = string.Format("When the {0} installer prompts you to choose a setup type, click Custom to verify the \"Location\" path exactly matches the path in the {1} Server box.", this._dbmsType, this._dbmsType);
        if (MessageBox.Show(string.Format("{0} was not installed to the expected directory.  You should click Cancel, uninstall {1}  if it was successfully installed, and reinstall it with this installer.  {2}\r\nThe {3} Windows service will most likely have trouble starting if you continue.\r\nContinue anyway?", this._dbmsType, this._dbmsType, str, "MySQL"), "", MessageBoxButtons.OKCancel) != DialogResult.OK)
          return false;
        Directory.CreateDirectory(this.textmyini.Text);
      }
      string path2_1 = "my.ini";
      if (File.Exists(Path.Combine(this.textmyini.Text, path2_1)))
      {
        if ((File.GetAttributes(Path.Combine(this.textmyini.Text, path2_1)) & FileAttributes.ReadOnly) == FileAttributes.ReadOnly)
          File.SetAttributes(Path.Combine(this.textmyini.Text, path2_1), FileAttributes.Normal);
        string str = DateTime.Now.ToString("yyyyMMdd");
        string path2_2 = "my_" + str + ".ini";
        int num1;
        for (num1 = 1; File.Exists(Path.Combine(this.textmyini.Text, path2_2)) && num1 < 100; ++num1)
          path2_2 = "my_" + str + "_" + num1.ToString() + ".ini";
        if (num1 >= 100)
        {
          MessageBox.Show("Unable to backup the existing my.ini. Please review the my.ini files found in " + this.textmyini.Text);
          return false;
        }
        string path2_3 = path2_2;
        File.Copy(Path.Combine(this.textmyini.Text, "my.ini"), Path.Combine(this.textmyini.Text, path2_3));
      }
      File.Delete(Environment.GetEnvironmentVariable("windir") + "\\my.ini");
      File.Delete(this.textmyini.Text + "\\my.ini");
      using (StreamWriter streamWriter = new StreamWriter(Path.Combine(this.textmyini.Text, "my.ini"), false))
      {
        streamWriter.WriteLine("[mysqld]");
        streamWriter.WriteLine("basedir=\"" + this.textDbmsInstallationDir.Text.Replace("\\", "/") + "\"");
        streamWriter.WriteLine("datadir=\"" + this.textDatabase.Text.Replace("\\", "/") + "\"");
        streamWriter.WriteLine("default-storage-engine=MyISAM");
        streamWriter.WriteLine("max_allowed_packet=40M");
        streamWriter.WriteLine("max_connections=3000");
        streamWriter.WriteLine("port=3306");
        if (this._dbmsType == DbmsType.MariaDB)
        {
          streamWriter.WriteLine("sql_mode=''");
          streamWriter.WriteLine("explicit_defaults_for_timestamp=1");
          streamWriter.WriteLine("innodb_file_per_table=1");
          streamWriter.WriteLine("myisam_recover_options=OFF");
          streamWriter.WriteLine("optimizer_switch=split_materialized=OFF");
        }
      }
      return true;
    }

    private bool CheckDatabaseHelper(out string targetDB)
    {
      targetDB = "helianz";
      string directoryName = Path.GetDirectoryName(this.textDatabase.Text);
      if (string.IsNullOrEmpty(directoryName))
      {
        MessageBox.Show("Invalid Helianz database path");
        return false;
      }
      string str1 = directoryName.TrimEnd('\\') + "\\";
      if (Directory.Exists(str1 + targetDB))
      {
        string str2 = DateTime.Now.ToString("yyyyMMdd");
        string str3 = targetDB + "_" + str2;
        int num1;
        for (num1 = 1; Directory.Exists(str1 + str3) && num1 < 100; ++num1)
          str3 = targetDB + "_" + str2 + "_" + num1.ToString();
        if (num1 >= 100)
        {
          MessageBox.Show("Unable to create new database. Please review databases found in " + str1);
          return false;
        }
        targetDB = str3;
        MessageBox.Show("Database \"helianz\" already exists, creating \"" + targetDB + "\" database instead.");
      }
      string str4 = CultureInfo.CurrentCulture.Name.Substring(3, 2) == "CA" ? "canada" : "blank";
      if (!Directory.Exists(this._appPath + "\\Databases\\" + str4))
        str4 = "blank";
      if (Directory.Exists(this._appPath + "\\Databases\\" + str4))
      {
        Directory.CreateDirectory(str1 + targetDB);
        FileInfo[] files = new DirectoryInfo(this._appPath + "\\Databases\\" + str4).GetFiles();
        for (int index = 0; index < files.Length; ++index)
        {
          File.Copy(this._appPath + "\\Databases\\" + str4 + "\\" + files[index].Name, str1 + targetDB + "\\" + files[index].Name);
          File.SetAttributes(str1 + targetDB + "\\" + files[index].Name, FileAttributes.Normal);
        }
      }
      if (Directory.Exists(this._appPath + "\\Databases\\demo"))
      {
        if (Directory.Exists(str1 + "\\demo"))
          Directory.Delete(str1 + "\\demo", true);
        Directory.CreateDirectory(str1 + "\\demo");
        FileInfo[] files = new DirectoryInfo(this._appPath + "\\Databases\\demo").GetFiles();
        for (int index = 0; index < files.Length; ++index)
        {
          File.Copy(this._appPath + "\\Databases\\demo\\" + files[index].Name, str1 + "\\demo\\" + files[index].Name);
          File.SetAttributes(str1 + "\\demo\\" + files[index].Name, FileAttributes.Normal);
        }
      }
      return true;
    }

    private bool CheckODhelper()
    {
      Utilities.ProcessCommand(this._appPath + "\\Helianz Setup\\Setup.exe", "-sp\"INSTALLDIR=\"\"" + this.textApplication.Text + "\"\"\"");
      return true;
    }

    private bool CheckODImagesHelper()
    {
      string directoryName = Path.GetDirectoryName(this.textHelianzImages.Text);
      Directory.CreateDirectory(directoryName);
      DirectoryInfo directoryInfo = new DirectoryInfo(this._appPath + "\\HelianzImages");
      FileInfo[] files1 = directoryInfo.GetFiles();
      for (int index = 0; index < files1.Length; ++index)
      {
        File.Copy(this._appPath + "\\HelianzImages\\" + files1[index].Name, directoryName + "\\" + files1[index].Name, true);
        File.SetAttributes(directoryName + "\\" + files1[index].Name, FileAttributes.Normal);
      }
      DirectoryInfo[] directories = directoryInfo.GetDirectories();
      for (int index1 = 0; index1 < directories.Length; ++index1)
      {
        Directory.CreateDirectory(directoryName + "\\" + directories[index1].Name);
        FileInfo[] files2 = new DirectoryInfo(this._appPath + "\\HelianzImages\\" + directories[index1].Name).GetFiles();
        for (int index2 = 0; index2 < files2.Length; ++index2)
        {
          File.Copy(this._appPath + "\\HelianzImages\\" + directories[index1].Name + "\\" + files2[index2].Name, directoryName + "\\" + directories[index1].Name + "\\" + files2[index2].Name);
          File.SetAttributes(directoryName + "\\" + directories[index1].Name + "\\" + files2[index2].Name, FileAttributes.Normal);
        }
      }
      return true;
    }

    private bool TryInstallService()
    {
      this.Cursor = Cursors.WaitCursor;
      if (Utilities.GetWindowsService("MySQL") == null)
      {
        string path = this.textDbmsInstallationDir.Text + "bin\\mysqld.exe";
        if (File.Exists(path))
        {
          Process process = new Process();
          process.StartInfo.FileName = path;
          process.StartInfo.Arguments = "--install MySQL --defaults-file=\"" + this.textDbmsInstallationDir.Text + "my.ini\"";
          process.Start();
          try
          {
            process.WaitForExit(10000);
          }
          catch (Exception ex)
          {
            ex.DoNothing();
            MessageBox.Show("Error. mysqld.exe did not exit after 10 seconds. Exiting installation sequence.");
            return false;
          }
        }
        else
        {
          MessageBox.Show("Error. Could not find mysqld.exe. Exiting installation sequence.");
          return false;
        }
      }
      ServiceController windowsService = Utilities.GetWindowsService("MySQL");
      if (windowsService == null)
      {
        MessageBox.Show("MySQL Windows service not found after mysqld-nt --install. Exiting installation sequence.");
        return false;
      }
      if (windowsService.Status == ServiceControllerStatus.Running)
        return true;
      try
      {
        windowsService.WaitForStatus(ServiceControllerStatus.Stopped, TimeSpan.FromMinutes(1.0));
      }
      catch (Exception ex)
      {
        ex.DoNothing();
        MessageBox.Show("Cannot start MySQL Windows service since it is not stopped.  Restart computer and try again.");
        return false;
      }
      try
      {
        windowsService.Start();
        windowsService.WaitForStatus(ServiceControllerStatus.Running, TimeSpan.FromMinutes(1.0));
      }
      catch (Exception ex)
      {
        ex.DoNothing();
        MessageBox.Show("MySQL Windows service not starting as expected.  Restart computer and try again.");
        return false;
      }
      return true;
    }

    private bool TryRemoveService()
    {
      ServiceController windowsService = Utilities.GetWindowsService("MySQL", false, true);
      if (windowsService == null)
        return true;
      if (MessageBox.Show("A service with the name of '" + windowsService.ServiceName + "' already exists. If you continue, it will be automatically removed. Any programs that rely on it may not continue to function as intended. Would you like to automatically remove the current '" + windowsService.ServiceName + "' and continue installation?", "Warning!", MessageBoxButtons.YesNo) != DialogResult.Yes)
      {
        int num = (int) MessageBox.Show("This installer cannot proceed while the '" + windowsService.ServiceName + "' service exists. Please remove it manually and try again. If you need assistance with this, call support.");
        return false;
      }
      if (windowsService.Status != ServiceControllerStatus.Stopped)
      {
        try
        {
          this.Cursor = Cursors.WaitCursor;
          windowsService.Stop();
          windowsService.WaitForStatus(ServiceControllerStatus.Stopped, new TimeSpan(0, 0, 15));
          this.Cursor = Cursors.Default;
        }
        catch (Exception ex)
        {
          ex.DoNothing();
          this.Cursor = Cursors.Default;
          MessageBox.Show("MySQL Windows service not responding.  Run this program again, except right click Run as Admin.  If that doesn't work, restart computer.");
          return false;
        }
      }
      string str = "";
      if (File.Exists("C:\\mysql\\bin\\mysqld-nt.exe"))
        str = "C:\\mysql\\bin\\mysqld-nt.exe";
      else if (File.Exists(Path.Combine(this._programFilesx86, "MySQL\\MySQL Server 4.1\\bin\\mysqld-nt.exe")))
        str = Path.Combine(this._programFilesx86, "MySQL\\MySQL Server 4.1\\bin\\mysqld-nt.exe");
      else if (File.Exists(Path.Combine(this._programFilesx86, "MySQL\\MySQL Server 5.0\\bin\\mysqld-nt.exe")))
        str = Path.Combine(this._programFilesx86, "MySQL\\MySQL Server 5.0\\bin\\mysqld-nt.exe");
      else if (File.Exists(Path.Combine(this._programFiles64, "MySQL\\MySQL Server 5.0\\bin\\mysqld-nt.exe")))
        str = Path.Combine(this._programFiles64, "MySQL\\MySQL Server 5.0\\bin\\mysqld-nt.exe");
      else if (File.Exists(Path.Combine(this._programFilesx86, "MySQL\\MySQL Server 5.5\\bin\\mysqld-nt.exe")))
        str = Path.Combine(this._programFilesx86, "MySQL\\MySQL Server 5.5\\bin\\mysqld-nt.exe");
      else if (File.Exists(Path.Combine(this._programFiles64, "MySQL\\MySQL Server 5.5\\bin\\mysqld-nt.exe")))
        str = Path.Combine(this._programFiles64, "MySQL\\MySQL Server 5.5\\bin\\mysqld-nt.exe");
      else if (File.Exists(Path.Combine(this._programFilesx86, "MySQL\\MySQL Server 5.6\\bin\\mysqld-nt.exe")))
        str = Path.Combine(this._programFilesx86, "MySQL\\MySQL Server 5.6\\bin\\mysqld-nt.exe");
      else if (File.Exists(Path.Combine(this._programFiles64, "MySQL\\MySQL Server 5.6\\bin\\mysqld-nt.exe")))
        str = Path.Combine(this._programFiles64, "MySQL\\MySQL Server 5.6\\bin\\mysqld-nt.exe");
      List<MariaDB> mariaDbVersions = MariaDB.GetMariaDBVersions();
      for (int index = 0; index < mariaDbVersions.Count; ++index)
      {
        string path2 = "MariaDB " + mariaDbVersions[index].Version + "\\bin\\mysqld.exe";
        if (File.Exists(Path.Combine(this._programFiles64, path2)))
        {
          str = Path.Combine(this._programFiles64, path2);
          break;
        }
        if (File.Exists(Path.Combine(this._programFilesx86, path2)))
        {
          str = Path.Combine(this._programFilesx86, path2);
          break;
        }
      }
      if (str == "")
      {
        MessageBox.Show("A service with the name of '" + windowsService.ServiceName + "' already exists and cannot be automatically removed. Please remove it manually and try again.");
        return false;
      }
      Process process = new Process();
      process.StartInfo.FileName = str;
      process.StartInfo.Arguments = "--remove " + windowsService.ServiceName;
      process.Start();
      try
      {
        process.WaitForExit(10000);
      }
      catch (Exception ex)
      {
        ex.DoNothing();
        MessageBox.Show("Error. mysqld-nt --remove did not exit after 10 seconds. Exiting installation sequence.");
        return false;
      }
      return true;
    }

    private void TryUpdateDataPath(string dbName)
    {
      if (string.IsNullOrEmpty(this.textHelianzImages.Text))
        return;
      try
      {
        new DataConnection("localhost", dbName, "root", "", DatabaseType.MySql).NonQ("UPDATE preference SET ValueString='" + SOut.String(this.textHelianzImages.Text) + "' WHERE PrefName='DocPath'");
      }
      catch (Exception ex)
      {
        ex.DoNothing();
      }
    }

    private void textDatabase_TextChanged(object sender, EventArgs e) => this.textGrant.Text = Path.Combine(this.textDatabase.Text, "mysql\\");

    private void textDbmsInstallationDir_TextChanged(object sender, EventArgs e) => this.textmyini.Text = this.textDbmsInstallationDir.Text;

    private void butMariaDBLicense_Click(object sender, EventArgs e)
    {
      int num = (int) new MsgBoxCopyPaste(Resources.MariaDBLicense).ShowDialog();
    }

    private void butClose_Click(object sender, EventArgs e) => this.Close();
  }
}
