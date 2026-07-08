namespace HelianzBusiness {
	///<summary>Data transfer object for local (per-workstation) read-only server settings.
	///Used by PrefC.ReadOnlyServer.GetLocalOverride delegate to provide client-specific configuration.
	///When returned as non-null with Enabled=true, these values override global database preferences.</summary>
	public class LocalReadOnlyServerOverride {
		///<summary>Whether this client should use a separate read-only server.</summary>
		public bool Enabled;

		///<summary>True if using Middle Tier connection; false if using Direct Connection.</summary>
		public bool UseMiddleTier;

		///<summary>Server hostname for direct connection.</summary>
		public string ServerName;

		///<summary>Database name for direct connection.</summary>
		public string Database;

		///<summary>MySQL user for direct connection.</summary>
		public string MySqlUser;

		///<summary>Encrypted/hashed MySQL password for direct connection.</summary>
		public string MySqlPassHash;

		///<summary>Middle Tier URI.</summary>
		public string URI;

		///<summary>SSL CA certificate (PEM) for SkySQL connections.</summary>
		public string SslCa;

		///<summary>Creates a LocalReadOnlyServerOverride from a Helianz.LocalReadOnlyServerData object.
		///This bridge method avoids a direct project dependency.</summary>
		public static LocalReadOnlyServerOverride FromLocalData(bool enabled,bool useMiddleTier,
			string serverName,string database,string mySqlUser,string mySqlPassHash,string uri,string sslCa)
		{
			return new LocalReadOnlyServerOverride {
				Enabled=enabled,
				UseMiddleTier=useMiddleTier,
				ServerName=serverName ?? "",
				Database=database ?? "",
				MySqlUser=mySqlUser ?? "",
				MySqlPassHash=mySqlPassHash ?? "",
				URI=uri ?? "",
				SslCa=sslCa ?? "",
			};
		}
	}
}
