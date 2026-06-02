using System;
using System.Globalization;

namespace HelianzBusiness {
	public class Currency {
		
		///<summary>Gets StringFormat for currency. "F2" for customers, "F4" for HQ. "N0" for Indonesian locale (id-ID).</summary>
		public static string GetCurrencyFormat() {
			if(PrefC.IsODHQ) {
				return "0.00##";
			}
			if(IsIndonesianLocale()) {
				return "N0";//IDR uses no decimal places; thousands separator inserted by N0 format.
			}
			return "F2";
		}

		///<summary>Returns true when the practice LanguageAndRegion preference is set to Indonesian (id-ID).</summary>
		public static bool IsIndonesianLocale() {
			try {
				string lang=PrefC.GetString(PrefName.LanguageAndRegion);
				return lang=="id-ID";
			}
			catch {
				return false;
			}
		}

		///<summary>Formats an amount as a display string. For Indonesian locale, prepends "Rp " and uses no decimal places.
		///For all other locales, uses the standard GetCurrencyFormat format string.</summary>
		public static string FormatAmount(double amt) {
			if(IsIndonesianLocale()) {
				return "Rp "+amt.ToString("N0",new CultureInfo("id-ID"));
			}
			return amt.ToString(GetCurrencyFormat());
		}

		/// <summary>Rounds amt to 2 places for customers, and 4 places for HQ. For Indonesian locale, rounds to nearest whole number.</summary>
		public static double Round(double amt) {
			if(IsIndonesianLocale()) {
				return Math.Round(amt,0,MidpointRounding.AwayFromZero);
			}
			return PIn.Double(amt.ToString(GetCurrencyFormat()));
		}

	}
}
