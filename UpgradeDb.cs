using System;
using DataConnectionBase;
using OpenDentBusiness;

/// <summary>Standalone DB upgrade tool. Connects directly to the database and runs ConvertDatabases.InvokeConvertMethods().</summary>
class UpgradeDb {
	[STAThread]
	static int Main(string[] args) {
		Console.WriteLine("=== OpenDental Database Upgrade Tool ===");
		string server   = "localhost";
		string database = "opendental";
		string user     = "root";
		string password = "J0k0m4r0k3@";
		try {
			// Set up a direct connection (same pattern as UnitTestsCore.DatabaseTools.SetDbConnection)
			DataConnection.DBtype = DatabaseType.MySql;
			new DataConnection().SetDb(server, database, user, password, user, password, DatabaseType.MySql, true);
			RemotingClient.MiddleTierRole = MiddleTierRole.ClientDirect;
			Console.WriteLine("Connected to " + server + "/" + database);
			// Read current version
			string fromVer = DataCore.GetScalar("SELECT ValueString FROM preference WHERE PrefName='DataBaseVersion'");
			Console.WriteLine("Current DB version : " + fromVer);
			Version from = new Version(fromVer);
			Version latest = ConvertDatabases.LatestVersion;
			Console.WriteLine("Latest app version : " + latest);
			if (from >= latest) {
				Console.WriteLine("Database is already up to date. No upgrade needed.");
				return 0;
			}
			Console.WriteLine("Starting upgrade from " + from + " to " + latest + " ...");
			ConvertDatabases.FromVersion = from;
			ConvertDatabases.InvokeConvertMethods();
			string toVer = DataCore.GetScalar("SELECT ValueString FROM preference WHERE PrefName='DataBaseVersion'");
			Console.WriteLine("Upgrade complete. New DB version: " + toVer);
			return 0;
		}
		catch (Exception ex) {
			Console.WriteLine("ERROR: " + ex.Message);
			if (ex.InnerException != null)
				Console.WriteLine("INNER: " + ex.InnerException.Message);
			return 1;
		}
	}
}
