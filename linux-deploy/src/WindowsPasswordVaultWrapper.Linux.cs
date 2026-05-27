// Linux/Mono stub for PasswordVaultWrapper.
// Windows.Security.Credentials (Windows.winmd / WinRT) is not available on Linux.
// All methods silently no-op or return "not found" so the server starts normally.
// The Windows Credential Manager feature (Central Manager auto-login) is simply
// unavailable on this platform; credentials must be supplied via config file instead.

using System;

namespace PasswordVaultWrapper {
	public class WindowsPasswordVaultWrapper {

		///<summary>No-op on Linux: Windows Credential Manager is not available.</summary>
		public static void ClearCredentials(string uri) {
			// Not supported on Linux.
		}

		///<summary>No-op on Linux: Windows Credential Manager is not available.</summary>
		public static void WritePassword(string uri, string username, string password) {
			// Not supported on Linux.
		}

		///<summary>Always returns false on Linux: no credential store available.</summary>
		public static bool TryRetrieveUserName(string uri, out string username) {
			username = string.Empty;
			return false;
		}

		///<summary>Always returns empty string on Linux: no credential store available.</summary>
		public static string RetrievePassword(string uri, string username) {
			return string.Empty;
		}
	}
}
