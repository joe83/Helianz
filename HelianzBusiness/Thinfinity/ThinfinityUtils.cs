using System;

namespace Helianz.Thinfinity {
	///<summary>Stub for Thinfinity web remote-desktop SDK methods.
	///Replace with actual Thinfinity SDK assembly reference when that SDK is available.</summary>
	public static class ThinfinityUtils {
		///<summary>Exports a file for browser download in Thinfinity cloud sessions.</summary>
		public static void ExportForDownload(string path) {
			throw new NotImplementedException("Thinfinity SDK is not present. ExportForDownload(path) is unavailable outside a Thinfinity cloud session.");
		}

		///<summary>Exports data as a file for browser download in Thinfinity cloud sessions.</summary>
		public static void ExportForDownload(string path, string data) {
			throw new NotImplementedException("Thinfinity SDK is not present. ExportForDownload(path, data) is unavailable outside a Thinfinity cloud session.");
		}

		///<summary>Opens a file via the Thinfinity virtual file handler.</summary>
		public static void HandleFile(string path) {
			throw new NotImplementedException("Thinfinity SDK is not present. HandleFile is unavailable outside a Thinfinity cloud session.");
		}

		///<summary>Returns a temporary local path mapped to a Thinfinity virtual path.</summary>
		public static string GetTempLocalPathForFile(string filepath) {
			throw new NotImplementedException("Thinfinity SDK is not present. GetTempLocalPathForFile is unavailable outside a Thinfinity cloud session.");
		}
	}
}
