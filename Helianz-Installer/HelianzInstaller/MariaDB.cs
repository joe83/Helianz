using CodeBase;
using System;
using System.Collections.Generic;
using System.IO;

namespace FreeDentalInstaller
{
  public class MariaDB
  {
    public string Version;

    public MariaDB(string version) => this.Version = version;

    public string PathMysqld => "MariaDB " + this.Version + "\\bin\\mysqld.exe";

    public static string FirewallName
    {
      get
      {
        string str = FormMain.Architecturetype.Replace("win", "x");
        return string.Format("MariaDB {0}.{1} ({2})", FormMain.VersionInstaller.Major, FormMain.VersionInstaller.Minor, str);
      }
    }

    public bool HasVersionInstalled(string pathRootInstallPath) => File.Exists(Path.Combine(pathRootInstallPath, this.PathMysqld));

    public static List<MariaDB> GetMariaDBVersions() => new List<MariaDB>()
    {
      new MariaDB("5.1"),
      new MariaDB("5.2"),
      new MariaDB("5.3"),
      new MariaDB("5.5"),
      new MariaDB("10.0"),
      new MariaDB("10.1"),
      new MariaDB("10.2"),
      new MariaDB("10.3"),
      new MariaDB("10.4"),
      new MariaDB("10.5")
    };

    public static bool IsInboundFirewallAvailable()
    {
      string arguments = "/C netsh advfirewall firewall show rule name=all dir=in | find \"" + MariaDB.FirewallName + "\"";
      try
      {
        return Utilities.ProcessCommand("CMD.exe", arguments).ExitCode == 0;
      }
      catch (Exception ex)
      {
        ex.DoNothing();
        return false;
      }
    }

    public static bool SetFirewallRuleToDefault()
    {
      string arguments = "/C netsh advfirewall firewall set rule name=\"" + MariaDB.FirewallName + "\" new profile=private,domain description=\"" + "Port 3306 for MariaDB" + "\" protocol=tcp localport=3306";
      try
      {
        return Utilities.ProcessCommand("CMD.exe", arguments).ExitCode == 0;
      }
      catch (Exception ex)
      {
        ex.DoNothing();
        return false;
      }
    }
  }
}
