using System;

namespace HelianzBusiness {
	///<summary>Stores Midtrans payment gateway credentials and configuration for QRIS payments.</summary>
	[Serializable]
	public class MidtransConfig:TableBase {
		///<summary>Primary Key</summary>
		[CrudColumn(IsPriKey=true)]
		public long MidtransConfigNum;
		///<summary>Midtrans Server Key. Used for server-side API calls. Store encrypted via SecurityHash.</summary>
		public string ServerKey;
		///<summary>Midtrans Client Key. Used only if a client-side SDK is ever needed.</summary>
		public string ClientKey;
		///<summary>Enum:MidtransEnvironment 0=Sandbox, 1=Production.</summary>
		[CrudColumn(SpecialType=CrudSpecialColType.EnumAsString)]
		public MidtransEnvironment Environment;
		///<summary>When true, Midtrans QRIS payments are enabled in the payment window.</summary>
		public bool IsEnabled;
		///<summary>FK to clinic.ClinicNum. 0 indicates this is the practice-wide configuration.
		///Each clinic may have its own Midtrans merchant account.</summary>
		public long ClinicNum;
		///<summary>Optional merchant name displayed on the QR payment screen.</summary>
		public string MerchantName;
		///<summary>FK to definition.DefNum. The payment type (DefCat.PaymentTypes) used when posting QRIS payments to the account ledger.
		///Must be configured before QRIS payments can be saved.</summary>
		public long PayTypeDefNum;
		///<summary>Optional notes about this configuration.</summary>
		[CrudColumn(SpecialType=CrudSpecialColType.IsText)]
		public string Note;

		///<summary></summary>
		public MidtransConfig Copy() {
			return (MidtransConfig)this.MemberwiseClone();
		}
	}

	///<summary>Midtrans API target environment.</summary>
	public enum MidtransEnvironment {
		///<summary>0 - Sandbox environment (api.sandbox.midtrans.com). Use for testing.</summary>
		Sandbox,
		///<summary>1 - Production environment (api.midtrans.com).</summary>
		Production,
	}
}
