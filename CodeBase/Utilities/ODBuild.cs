using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeBase {
	public class ODBuild {
		public static bool IsUnitTest=false;

		///<summary>Returns true if current build is for Windows OS.</summary>
		public static bool IsWindows() {
			return true;//Later this will be enhanced when we have non-Windows builds.
		}

		///<summary>Returns true if the current build is debug. Useful when you want the release code to show up when searching for references.</summary>
		public static bool IsDebug() {
			//There are some sections of code where we can't use this.  Specifically, places where a variable is a different type in debug vs not.  If anyone has a suggestion for including that pattern, let Jordan know.
#if DEBUG
			return true;
#else
			return false;
#endif
		}

		///<summary>Returns true when the current executable is running from a local source checkout instead of an installed deployment. This is used to keep developer builds from trying to self-update against production-style version metadata.</summary>
		public static bool IsLocalSourceBuild() {
			string dirCur=AppDomain.CurrentDomain.BaseDirectory;
			for(int i=0;i<6 && !string.IsNullOrEmpty(dirCur);i++) {
				if(File.Exists(Path.Combine(dirCur,"Helianz.sln"))) {
					return true;
				}
				DirectoryInfo directoryInfo=Directory.GetParent(dirCur);
				if(directoryInfo==null) {
					break;
				}
				dirCur=directoryInfo.FullName;
			}
			return false;
		}

		///<summary>Returns true when local developer builds should be allowed to connect even if the database ProgramVersion differs.</summary>
		public static bool ShouldBypassVersionChecks() {
			return IsDebug() || IsLocalSourceBuild();
		}

		///<summary>Returns true if the current build is alpha. Useful when you want the release code to show up when searching for references.</summary>
		public static bool IsAlpha() {
#if ALPHA
			return true;
#else
			return false;
#endif
		}

		///<summary>Returns true if current build is using Thinfinity Virtual UI, aka ODCloud.</summary>
		public static bool IsThinfinity() {
#if THINFINITY
			return true;
#else
			return false;
#endif
		}

		///<summary>Returns true if current build is for the trial version only.</summary>
		public static bool IsTrial() {
#if TRIALONLY
			return true;
#else
			return false;
#endif
		}

	}
}
