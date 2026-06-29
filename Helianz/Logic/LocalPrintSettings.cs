using System;
using System.Collections.Generic;
using System.Drawing.Printing;
using System.IO;
using CodeBase;
using Newtonsoft.Json;

namespace Helianz {
	///<summary>
	///Manages local (per-workstation) print preferences for paper size, margins, and orientation per PrintSituation.
	///Stored as JSON in %AppData%\Helianz\LocalPrintSettings.json.
	///These settings complement the server-side Printer table (which handles printer device name only).
	///If no local file exists, the printer driver's default paper size is used — preserving original behavior.
	///</summary>
	public static class LocalPrintSettings {
		///<summary>Path to the local settings JSON file.</summary>
		private static string FilePath {
			get {
				string appData=Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);
				string dir=Path.Combine(appData,"Helianz");
				if(!Directory.Exists(dir)) {
					Directory.CreateDirectory(dir);
				}
				return Path.Combine(dir,"LocalPrintSettings.json");
			}
		}

		///<summary>In-memory cache of all per-situation settings. Lazy-loaded.</summary>
		private static LocalPrintSettingsData _settings;
		private static readonly object _lock=new object();

		///<summary>Loads settings from disk, or returns defaults if file doesn't exist.</summary>
		public static LocalPrintSettingsData Load() {
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
						_settings=JsonConvert.DeserializeObject<LocalPrintSettingsData>(json) ?? new LocalPrintSettingsData();
					}
					else {
						_settings=new LocalPrintSettingsData();
					}
				}
				catch {
					_settings=new LocalPrintSettingsData();
				}
				return _settings;
			}
		}

		///<summary>Saves current settings to disk.</summary>
		public static void Save(LocalPrintSettingsData data) {
			lock(_lock) {
				_settings=data;
				try {
					string json=JsonConvert.SerializeObject(data,Formatting.Indented);
					File.WriteAllText(FilePath,json);
				}
				catch(Exception ex) {
					//Silently fail — printing should never break because settings can't be saved.
					ex.DoNothing();
				}
			}
		}

		///<summary>Gets the local print config for a specific PrintSituation. Returns null if none configured.</summary>
		public static LocalPrintConfig GetForSit(PrintSituation sit) {
			LocalPrintSettingsData data=Load();
			if(data.PrintSituations.TryGetValue(sit.ToString(),out LocalPrintConfig config)) {
				return config;
			}
			return null;
		}

		///<summary>Sets the local print config for a specific PrintSituation and saves.</summary>
		public static void SetForSit(PrintSituation sit,LocalPrintConfig config) {
			LocalPrintSettingsData data=Load();
			if(config==null || config.IsEmpty) {
				data.PrintSituations.Remove(sit.ToString());
			}
			else {
				data.PrintSituations[sit.ToString()]=config;
			}
			Save(data);
		}

		///<summary>Applies the local paper size, margins, and orientation for the given PrintSituation to the PrinterSettings.
		///If no local setting exists for this situation, does nothing (preserves printer driver defaults).</summary>
		public static void ApplyTo(PrinterSettings printerSettings,PrintSituation sit) {
			LocalPrintConfig config=GetForSit(sit);
			if(config==null || config.IsEmpty) {
				return;
			}
			//Apply paper size
			if(config.PaperWidth>0 && config.PaperHeight>0) {
				string paperName=!string.IsNullOrEmpty(config.PaperName) ? config.PaperName : "Custom";
				printerSettings.DefaultPageSettings.PaperSize=new PaperSize(paperName,config.PaperWidth,config.PaperHeight);
			}
			//Apply margins (only if explicitly set — all non-negative)
			if(config.MarginLeft>=0 && config.MarginRight>=0 && config.MarginTop>=0 && config.MarginBottom>=0) {
				printerSettings.DefaultPageSettings.Margins=new Margins(
					config.MarginLeft,config.MarginRight,config.MarginTop,config.MarginBottom);
			}
			//Apply orientation
			if(config.Orientation==PrintOrientation.Landscape) {
				printerSettings.DefaultPageSettings.Landscape=true;
			}
			else if(config.Orientation==PrintOrientation.Portrait) {
				printerSettings.DefaultPageSettings.Landscape=false;
			}
			//Orientation.Default means don't touch it.
		}

		///<summary>Clears the in-memory cache, forcing a reload from disk next time.</summary>
		public static void ClearCache() {
			lock(_lock) {
				_settings=null;
			}
		}
	}

	///<summary>Top-level container for all local print settings.</summary>
	[Serializable]
	public class LocalPrintSettingsData {
		///<summary>Key = PrintSituation name (e.g. "Statement", "Default"), Value = config.</summary>
		public Dictionary<string,LocalPrintConfig> PrintSituations { get; set; }=new Dictionary<string,LocalPrintConfig>();
	}

	///<summary>Per-situation local print configuration.</summary>
	[Serializable]
	public class LocalPrintConfig {
		///<summary>Paper width in 1/100ths of an inch (same unit as .NET PaperSize). A4 ≈ 827, A5 ≈ 583.</summary>
		public int PaperWidth { get; set; }
		///<summary>Paper height in 1/100ths of an inch. A4 ≈ 1169, A5 ≈ 827.</summary>
		public int PaperHeight { get; set; }
		///<summary>Human-readable paper name, e.g. "A4", "A5", "Letter".</summary>
		public string PaperName { get; set; }
		///<summary>Left margin in 1/100ths of an inch. Set to -1 to use printer default.</summary>
		public int MarginLeft { get; set; }=-1;
		///<summary>Right margin in 1/100ths of an inch.</summary>
		public int MarginRight { get; set; }=-1;
		///<summary>Top margin in 1/100ths of an inch.</summary>
		public int MarginTop { get; set; }=-1;
		///<summary>Bottom margin in 1/100ths of an inch.</summary>
		public int MarginBottom { get; set; }=-1;
		///<summary>Page orientation override.</summary>
		public PrintOrientation Orientation { get; set; }=PrintOrientation.Default;

		///<summary>Returns true if no meaningful settings are configured (all at defaults).</summary>
		public bool IsEmpty {
			get {
				return PaperWidth<=0 && PaperHeight<=0
					&& MarginLeft<0 && MarginRight<0 && MarginTop<0 && MarginBottom<0
					&& Orientation==PrintOrientation.Default;
			}
		}
	}

	///<summary>Orientation override for local print settings.</summary>
	public enum PrintOrientation {
		///<summary>Use printer default — don't override.</summary>
		Default=0,
		///<summary>Force portrait.</summary>
		Portrait=1,
		///<summary>Force landscape.</summary>
		Landscape=2
	}
}
