using System;

namespace HelianzBusiness {
	///<summary>Records a single Midtrans QRIS payment transaction, including QR code URL,
	///polling status, and final settlement result.</summary>
	[Serializable]
	public class MidtransTransaction:TableBase {
		///<summary>Primary Key</summary>
		[CrudColumn(IsPriKey=true)]
		public long MidtransTransactionNum;
		///<summary>FK to patient.PatNum.</summary>
		public long PatNum;
		///<summary>FK to payment.PayNum. Set after the payment row is created.</summary>
		public long PayNum;
		///<summary>Unique order_id sent to Midtrans. Format: "helianz-{PatNum}-{DateTime.Ticks}".</summary>
		public string OrderId;
		///<summary>Midtrans transaction_id returned by the Charge API.</summary>
		public string TransactionId;
		///<summary>Payment type confirmed by Midtrans (e.g. "gopay" or "qris").</summary>
		public string PaymentType;
		///<summary>Amount in IDR (integer, no decimals).</summary>
		public long GrossAmount;
		///<summary>URL of the QRIS QR-code image returned in the "generate-qr-code" action.</summary>
		[CrudColumn(SpecialType=CrudSpecialColType.IsText)]
		public string QrCodeUrl;
		///<summary>URL to poll for transaction status returned in the "get-status" action.</summary>
		[CrudColumn(SpecialType=CrudSpecialColType.IsText)]
		public string StatusUrl;
		///<summary>Enum:MidtransTransactionStatus 0=Created, 1=Pending, 2=Settlement, 3=Expire, 4=Cancel, 5=Deny, 6=Error.</summary>
		[CrudColumn(SpecialType=CrudSpecialColType.EnumAsString)]
		public MidtransTransactionStatus TransactionStatus;
		///<summary>Raw JSON of the last response from Midtrans (charge or status).</summary>
		[CrudColumn(SpecialType=CrudSpecialColType.IsText)]
		public string LastResponseJson;
		///<summary>UTC datetime when the transaction was created (Charge API call).</summary>
		[CrudColumn(SpecialType=CrudSpecialColType.DateT)]
		public DateTime DateTimeCreated;
		///<summary>UTC datetime when the payment was confirmed as settled. MinValue if not yet settled.</summary>
		[CrudColumn(SpecialType=CrudSpecialColType.DateT)]
		public DateTime DateTimeSettled;
		///<summary>FK to clinic.ClinicNum.</summary>
		public long ClinicNum;
		///<summary>Optional note added by the operator.</summary>
		[CrudColumn(SpecialType=CrudSpecialColType.IsText)]
		public string PayNote;

		///<summary></summary>
		public MidtransTransaction Copy() {
			return (MidtransTransaction)this.MemberwiseClone();
		}
	}

	///<summary>Lifecycle status of a Midtrans QRIS transaction.</summary>
	public enum MidtransTransactionStatus {
		///<summary>0 - Charge API called, waiting for QR to be displayed.</summary>
		Created,
		///<summary>1 - QR displayed to patient, waiting for scan and payment.</summary>
		Pending,
		///<summary>2 - Payment confirmed by Midtrans. Transaction settled successfully.</summary>
		Settlement,
		///<summary>3 - Transaction expired without payment.</summary>
		Expire,
		///<summary>4 - Transaction cancelled.</summary>
		Cancel,
		///<summary>5 - Transaction denied by Midtrans.</summary>
		Deny,
		///<summary>6 - An error occurred communicating with Midtrans.</summary>
		Error,
	}
}
