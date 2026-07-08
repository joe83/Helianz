using System;
using System.IO;
using CodeBase;
using Newtonsoft.Json;

namespace Helianz {
	///<summary>
	///Manages local (per-workstation) Read-Only Server configuration.
	///Stored as JSON in %AppData%\Helianz\LocalReadOnlyServerSettings.json.
	///Each client can independently enable/disable and configure its own read-only database connection.
	///When local settings are not enabled, the global database preferences are ignored for this client.
	///</summary>
	public static class LocalReadOnlyServerSettings {
		///<summary>Path to the local settings JSON file.</summary>
		private static string FilePath {
			get {
				string appData=Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);
				string dir=Path.Combine(appData,"Helianz");
				if(!Directory.Exists(dir)) {
					Directory.CreateDirectory(dir);
				}
				return Path.Combine(dir,"LocalReadOnlyServerSettings.json");
			}
		}

		///<summary>In-memory cache of settings. Lazy-loaded.</summary>
		private static LocalReadOnlyServerData _settings;
		private static readonly object _lock=new object();

		///<summary>Loads settings from disk, or returns defaults if file doesn't exist.</summary>
		public static LocalReadOnlyServerData Load() {
			if(_settings!=null) {
				return _settings;
			}
			lock(_lock) {
				if(_settings!=null) {
					return _settings;
				}
				try {
					if(File.Exists(FilePath)) {
						string json=File.ReadAllText(FilePath);
						_settings=JsonConvert.DeserializeObject<LocalReadOnlyServerData>(json) ?? new LocalReadOnlyServerData();
					}
					else {
						_settings=new LocalReadOnlyServerData();
					}
				}
				catch {
					_settings=new LocalReadOnlyServerData();
				}
				return _settings;
			}
		}

		///<summary>Saves current settings to disk.</summary>
		public static void Save(LocalReadOnlyServerData data) {
			lock(_lock) {
				_settings=data;
				try {
					string json=JsonConvert.SerializeObject(data,Formatting.Indented);
					File.WriteAllText(FilePath,json);
				}
				catch(Exception ex) {
					ex.DoNothing();
				}
			}
		}

		///<summary>Returns true if the local read-only server is enabled and configured.</summary>
		public static bool IsEnabled() {
			LocalReadOnlyServerData data=Load();
			return data.Enabled && (
				(!string.IsNullOrEmpty(data.ServerName) && !string.IsNullOrEmpty(data.Database))
				|| !string.IsNullOrEmpty(data.URI)
			);
		}

		///<summary>Clears the in-memory cache so the next Load() re-reads from disk.</summary>
		public static void ClearCache() {
			lock(_lock) {
				_settings=null;
			}
		}
	}

	///<summary>Data model for local read-only server settings.</summary>
	[Serializable]
	public class LocalReadOnlyServerData {
		///<summary>Whether this client should use a separate read-only server.</summary>
		public bool Enabled;

		///<summary>True if using Middle Tier connection; false if using Direct Connection.</summary>
		public bool UseMiddleTier;

		///<summary>Server hostname for direct connection.</summary>
		public string ServerName="";

		///<summary>Database name for direct connection.</summary>
		public string Database="";

		///<summary>MySQL user for direct connection.</summary>
		public string MySqlUser="";

		///<summary>Encrypted MySQL password for direct connection.</summary>
		public string MySqlPassHash="";

		///<summary>Middle Tier URI.</summary>
		public string URI="";

		///<summary>SSL CA certificate (PEM) for SkySQL connections.</summary>
		public string SslCa="";
	}
}
