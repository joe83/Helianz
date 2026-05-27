using System.Collections.Generic;
using System.IO;

namespace HelianzInstaller
{
  public class MySQL
  {
    public string Version;

    public MySQL(string version) => this.Version = version;

    public string PathMysqld
    {
      get
      {
        if (this.Version == "4.0")
          return "mysql\\bin\\mysqld.exe";
        return this.Version == "4.1" ? "MySQL\\MySQL Server 4.1\\bin\\mysqld-nt.exe" : "MySQL\\MySQL Server " + this.Version + "\\bin\\mysqld.exe";
      }
    }

    public bool HasVersionInstalled(string pathRootInstallPath)
    {
      if (this.Version == "4.0")
        pathRootInstallPath = "C:\\";
      return File.Exists(Path.Combine(pathRootInstallPath, this.PathMysqld));
    }

    public static List<MySQL> GetMySQLVersions() => new List<MySQL>()
    {
      new MySQL("4.0"),
      new MySQL("4.1"),
      new MySQL("5.0"),
      new MySQL("5.5"),
      new MySQL("5.6")
    };
  }
}
