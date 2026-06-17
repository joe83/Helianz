using CodeBase;
using DataConnectionBase;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace HelianzBusiness {
	public partial class ConvertDatabases {
		private static Version _latestVersion;
		private static List<ConvertDatabasesMethodInfo> _listConvertMethods;

		///<summary>Gets a list of convert databases method infos and their corresponding version information based on their method name.</summary>
		private static List<ConvertDatabasesMethodInfo> ListConvertMethods {
			get {
				if(_listConvertMethods==null) {
					_listConvertMethods=GetAllVersions();
				}
				return _listConvertMethods;
			}
		}
		
		///<summary>Returns a version object that correlates to the last convert databases method on file.</summary>
		public static Version LatestVersion {
			get {
				if(_latestVersion==null) {
					_latestVersion=ListConvertMethods[ListConvertMethods.Count-1].VersionCur;
				}
				return _latestVersion;
			}
		}

		///<summary>Uses reflection to get all "version" methods from the ConvertDatabasesX classes that match the "ToX_X_X" pattern.
		///Also sorts the methods in the correct order of which they should be invoked.</summary>
		private static List<ConvertDatabasesMethodInfo> GetAllVersions() {
			//Get all the private methods from the ConvertDatabases class via reflection.
			MethodInfo[] arrayConvertDbMethods=(typeof(ConvertDatabases)).GetMethods(BindingFlags.Static | BindingFlags.NonPublic);
			//Sort the methods so that they are numerically in the order that we require they be invoked in.
			List<ConvertDatabasesMethodInfo> listConvertMethods=new List<ConvertDatabasesMethodInfo>();
			foreach(MethodInfo methodInfo in arrayConvertDbMethods) {
				//Make sure that the only methods we add to our list match our ToX_X_X pattern.
				if(!Regex.Match(methodInfo.Name,ConvertDatabasesMethodInfo.PATTERN_METHOD_INFO,RegexOptions.IgnoreCase).Success) {
					continue;//This method does not follow our pattern and is most likely a helper method.
				}
				listConvertMethods.Add(new ConvertDatabasesMethodInfo(methodInfo));
			}
			//Make sure that the list of methods are sorted in ascending order (least to greatest).
			listConvertMethods.Sort((ConvertDatabasesMethodInfo x,ConvertDatabasesMethodInfo y) => { return x.VersionCur.CompareTo(y.VersionCur); });
			return listConvertMethods;
		}

		///<summary>Uses reflection to invoke private methods of the ConvertDatabase class in order from least to greatest if needed.
		///The old way of converting the database was to manually daisy chain methods together.
		///The new way is to just add a method that follows a strict naming pattern which this method will invoke when needed.</summary>
		public static void InvokeConvertMethods() {
			DataConnection.CommandTimeout=43200;//12 hours, because conversion commands may take longer to run.
			ConvertDatabases.To2_8_2();//begins going through the chain of conversion steps
			Logger.DoVerboseLoggingArgs doVerboseLogging=Logger.DoVerboseLogging;
			ODException.SwallowAnyException(() => {
				//Need to run queries here because PrefC has not been initialized.
				string command="SELECT ValueString FROM preference WHERE PrefName='HasVerboseLogging'";
				string valueString=Db.GetScalar(command);
				if(valueString.ToLower().Split(',').ToList().Exists(x => x==Environment.MachineName.ToLower())) {
					Logger.DoVerboseLogging=() => true;
					//Switch logger to a directory that won't have permissions issues.
					Logger.UseMyDocsDirectory();
				}
				Logger.LogVerbose("Starting convert script");
			});
			//Continue going through the chain of conversion methods starting at v17.1.1 via reflection.
			//Loop through the list of convert databases methods from front to back because it has already been sorted (least to greatest).
			foreach(ConvertDatabasesMethodInfo convertMethodInfo in ListConvertMethods) {
				//This pattern of using reflection to invoke our convert methods started in v17.1 so we will skip all methods prior to that version.
				if(convertMethodInfo.VersionCur < new Version(17,1)) {
					continue;
				}
				//Skip all methods that are below or equal to our "from" version.
				if(convertMethodInfo.VersionCur<=FromVersion) {
					continue;
				}
				//This convert method needs to be invoked.
				ODEvent.Fire(ODEventType.ConvertDatabases,"Upgrading database to version: " //No translations in convert script.
					+convertMethodInfo.VersionCur.ToString(3));//Only show the major, minor, build (preserves old functionality).
				try {
					//Use reflection to invoke the private static method.
					convertMethodInfo.MethodInfoCur.Invoke(null,new object[] { });
				}
				catch(Exception ex) {
					string message=Lans.g("ClassConvertDatabase","Convert Database failed ");
					try { 
						string methodName=convertMethodInfo.MethodInfoCur.Name;
						if(!string.IsNullOrEmpty(methodName)) {
							message+=Lans.g("ClassConvertDatabase","during: ")+methodName+"() ";
						}
						string command=Db.LastCommand;
						if(!string.IsNullOrEmpty(command)) {
							message+=Lans.g("ClassConvertDatabase","while running: ")+command+";";
						}
					}
					catch(Exception e) {
						e.DoNothing();//If this fails for any reason then just continue.
					}
					throw new Exception(message+"  "+ex.Message+"  "+ex.InnerException.Message,ex.InnerException);
				}
				//Update the preference that keeps track of what version Helianz has successfully upgraded to.
				//Always require major, minor, build, revision.  Will throw an exception if the revision was not explicitly set (which we always set).
				Prefs.UpdateStringNoCache(PrefName.DataBaseVersion,convertMethodInfo.VersionCur.ToString(4));
			}
			ODException.SwallowAnyException(() => {
				Logger.LogVerbose("Ending convert script");
				Logger.DoVerboseLogging=doVerboseLogging;
			});
			//After all migrations complete, sync ProgramVersion to the new DataBaseVersion.
			//This ensures the Middle Tier version check in DtoProcessor passes without requiring
			//the full client-side update infrastructure (SetupHelianz.exe / CheckProgramVersion).
			ODException.SwallowAnyException(() => {
				string dbVer=Db.GetScalar("SELECT ValueString FROM preference WHERE PrefName='DataBaseVersion'");
				string progVer=Db.GetScalar("SELECT ValueString FROM preference WHERE PrefName='ProgramVersion'");
				Version vDb, vProg;
				if(Version.TryParse(dbVer,out vDb) && Version.TryParse(progVer,out vProg) && vProg < vDb) {
					Prefs.UpdateStringNoCache(PrefName.ProgramVersion,dbVer);
				}
			});
			//Pre-17.1 conversion methods are skipped when the database version already exceeds the method's
			//target version, which can leave some preferences missing from the preference table.
			//This ensures all PrefName enum values (that should exist) have corresponding rows.
			ODException.SwallowAnyException(() => EnsureAllPrefsExist());
			DataConnection.CommandTimeout=3600;//Set back to default of 1 hour.
		}

		///<summary>Ensures all PrefName enum values (that should exist) have corresponding rows in the preference table.
		///Pre-17.1 conversion methods are skipped when the database version already exceeds the method's target version,
		///which can leave some preferences missing. This method fills in any gaps using sensible defaults.</summary>
		///<summary>These prefs are intentionally not stored in the database for most installations (marked "Missing in general").</summary>
		private static readonly HashSet<string> _missingInGeneralPrefs=new HashSet<string> {
			"AsteriskConferenceApplication",
			"AsteriskHighVolumeMode",
			"ConnectionSettingsHQ",
			"HelianzHelpCaptureFormName",
			"IntrospectionItems",
		};

		private static void EnsureAllPrefsExist() {
			//Get all PrefName enum values.
			Array allPrefNames=Enum.GetValues(typeof(PrefName));
			//Get all existing prefs from the database into a HashSet for fast lookup.
			string cmd="SELECT PrefName FROM preference";
			DataTable table=Db.GetTable(cmd);
			HashSet<string> existingPrefs=new HashSet<string>();
			foreach(DataRow row in table.Rows) {
				existingPrefs.Add(row["PrefName"].ToString());
			}
			//Determine which prefs are missing.
			List<string> missingPrefs=new List<string>();
			foreach(PrefName prefName in allPrefNames) {
				string name=prefName.ToString();
				if(name=="NotApplicable") {
					continue;//This pref is never stored in the database.
				}
				//Skip prefs intentionally not in the database (marked "Missing in general").
				if(_missingInGeneralPrefs.Contains(name)) {
					continue;
				}
				//Skip prefs marked with PrefValueType.NONE (like NotApplicable).
				MemberInfo mi=typeof(PrefName).GetMember(name)[0];
				PrefNameAttribute attr=mi.GetCustomAttribute<PrefNameAttribute>();
				if(attr!=null && attr.ValueType==PrefValueType.NONE) {
					continue;
				}
				//Skip obsolete prefs that are marked with error:true (they cause compile errors if used).
				ObsoleteAttribute obs=mi.GetCustomAttribute<ObsoleteAttribute>();
				if(obs!=null && obs.IsError) {
					continue;
				}
				if(!existingPrefs.Contains(name)) {
					missingPrefs.Add(name);
				}
			}
			//Insert each missing pref with a sensible default value.
			foreach(string prefName in missingPrefs) {
				string defaultValue=GetDefaultValueForPref(prefName);
				string insertCmd;
				if(DataConnection.DBtype==DatabaseType.MySql) {
					insertCmd="INSERT INTO preference (PrefName,ValueString) "
						+"SELECT '"+POut.String(prefName)+"','"+POut.String(defaultValue)+"' "
						+"FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM preference WHERE PrefName='"+POut.String(prefName)+"')";
				}
				else {//Oracle
					insertCmd="INSERT INTO preference (PrefNum,PrefName,ValueString) "
						+"SELECT (SELECT MAX(PrefNum)+1 FROM preference),'"+POut.String(prefName)+"','"+POut.String(defaultValue)+"' "
						+"FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM preference WHERE PrefName='"+POut.String(prefName)+"')";
				}
				Db.NonQ(insertCmd);
			}
		}

		///<summary>Returns a sensible default ValueString for a given PrefName based on its PrefValueType attribute.</summary>
		private static string GetDefaultValueForPref(string prefName) {
			MemberInfo mi=typeof(PrefName).GetMember(prefName)[0];
			PrefNameAttribute attr=mi.GetCustomAttribute<PrefNameAttribute>();
			if(attr==null) {
				return "0";//Default for most prefs without an explicit attribute.
			}
			switch(attr.ValueType) {
				case PrefValueType.NONE:
					return "0";
				case PrefValueType.BOOL:
					return "0";
				case PrefValueType.STRING:
					return "";
				case PrefValueType.ENUM:
					return "0";
				case PrefValueType.INT:
					return "0";
				case PrefValueType.LONG:
					return "0";
				case PrefValueType.LONG_NEG_ONE_AS_ZERO:
					return "0";
				case PrefValueType.LONG_NEG_ONE_AS_BLANK:
					return "";
				case PrefValueType.BYTE:
					return "0";
				case PrefValueType.DOUBLE:
					return "0";
				case PrefValueType.DATE:
					return "0001-01-01";
				case PrefValueType.DATETIME:
					return "0001-01-01 00:00:00";
				case PrefValueType.COLOR:
					return "0";
				case PrefValueType.YN_DEFAULT_TRUE:
					return "1";
				default:
					return "0";
			}
		}
	}

	///<summary>A helper class to quickly manage convert databases methods.  Provides access to the corresponding MethodInfo and Version.</summary>
	public class ConvertDatabasesMethodInfo {
		///<summary>This is the regular expression pattern used to match our convert databases method version pattern of "ToX_X_X".</summary>
		public const string PATTERN_METHOD_INFO=@"^To([0-9]+)_([0-9]+)_([0-9]+)$";
		private MethodInfo _methodInfo;
		private Version _version;

		public MethodInfo MethodInfoCur {
			get {
				return _methodInfo;
			}
		}

		public Version VersionCur {
			get {
				return _version;
			}
		}

		///<summary>The method info passed in should have a name that follows the ToX_X_X pattern.
		///Throws an exception if pattern not followed.</summary>
		public ConvertDatabasesMethodInfo(MethodInfo methodInfo) {
			_methodInfo=methodInfo;
			_version=GetVersionFromConvertMethod(methodInfo);
		}

		///<summary>Uses a regular expression to extract a version from the name of the method passed in.
		///The method info passed in should have a name that follows the ToX_X_X pattern.
		///Throws an exception if the method name pattern was not followed.</summary>
		private Version GetVersionFromConvertMethod(MethodInfo methodInfo) {
			Match match=Regex.Match(methodInfo.Name,ConvertDatabasesMethodInfo.PATTERN_METHOD_INFO,RegexOptions.IgnoreCase);
			if(!match.Success) {
				throw new ApplicationException("Invalid convert databases method passed into GetVersionFromConvertMethod.");
			}
			int major=PIn.Int(match.Result("$1"));
			int minor=PIn.Int(match.Result("$2"));
			int build=PIn.Int(match.Result("$3"));
			return new Version(major,minor,build,0);
		}
	}
}
