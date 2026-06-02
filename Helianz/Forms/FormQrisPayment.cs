using System;
using System.Drawing;
using System.Net;
using System.IO;
using System.Threading;
using System.Windows.Forms;
using CodeBase;
using HelianzBusiness;
using HelianzBusiness.WebBridges;

namespace Helianz {
	///<summary>Displays a QRIS QR code and polls Midtrans until the payment is settled, expired, or cancelled.
	///Set IsPaymentSettled after DialogResult.OK to confirm success.</summary>
	public partial class FormQrisPayment:FormODBase {
		///<summary>True if the transaction reached Settled status before the form closed.</summary>
		public bool IsPaymentSettled=false;
		///<summary>The transaction that was created and tracked by this form.  Available after the form closes.</summary>
		public MidtransTransaction MidtransTransactionResult;

		private MidtransConfig _midtransConfig;
		private MidtransTransaction _midtransTransaction;
		private MidtransApi _midtransApi;
		///<summary>Timer fires every 3 seconds to poll for payment status.</summary>
		private System.Windows.Forms.Timer _timerPoll;
		private System.Windows.Forms.Timer _timerCloseSuccess;
		///<summary>Hard limit: 10 minutes before QR is considered expired.</summary>
		private DateTime _expireAt;
		private const int POLL_INTERVAL_MS=3000;
		private const int QR_EXPIRE_MINUTES=10;

		///<summary>Opens the QRIS payment dialog.
		///<param name="midtransConfig">Clinic Midtrans config (must be enabled).</param>
		///<param name="transaction">An already-created MidtransTransaction (status=Pending) with QrCodeUrl populated.</param>
		///</summary>
		public FormQrisPayment(MidtransConfig midtransConfig,MidtransTransaction transaction) {
			InitializeComponent();
			InitializeLayoutManager();
			Lan.F(this);
			_midtransConfig =midtransConfig;
			_midtransTransaction=transaction;
			_midtransApi    =new MidtransApi(midtransConfig);
			_expireAt       =DateTime.Now.AddMinutes(QR_EXPIRE_MINUTES);
		}

		private void FormQrisPayment_Load(object sender,EventArgs e) {
			labelAmount.Text     =Lan.g(this,"Amount")+" (IDR): "+_midtransTransaction.GrossAmount.ToString("N0");
			labelOrderId.Text    =Lan.g(this,"Order ID")+": "+_midtransTransaction.OrderId;
			labelStatus.Text     =Lan.g(this,"Status")+": "+Lan.g(this,"Waiting for payment...");
			labelInstruction.Text=Lan.g(this,"Scan the QR code below using GoPay, OVO, DANA, LinkAja, ShopeePay, or any QRIS-enabled app.");
			panelSuccessCard.Visible=false;
			//Show sandbox simulator URL row so testers can copy it to https://simulator.sandbox.midtrans.com/v2/qris/index
			if(!string.IsNullOrEmpty(_midtransTransaction.QrCodeUrl)) {
				textBoxQrUrl.Text       =_midtransTransaction.QrCodeUrl;
				labelSimulatorUrl.Visible=true;
				textBoxQrUrl.Visible    =true;
				butCopyQrUrl.Visible    =true;
			}
			LoadQrImage();
			StartPolling();
		}

		private void butCopyQrUrl_Click(object sender,EventArgs e) {
			if(!string.IsNullOrEmpty(textBoxQrUrl.Text)) {
				Clipboard.SetText(textBoxQrUrl.Text);
			}
		}

		///<summary>Downloads the QR code image from Midtrans and displays it in pictureBoxQr.</summary>
		private void LoadQrImage() {
			if(string.IsNullOrEmpty(_midtransTransaction.QrCodeUrl)) {
				pictureBoxQr.Visible=false;
				labelQrError.Visible=true;
				labelQrError.Text=Lan.g(this,"QR code URL not available.");
				return;
			}
			try {
				using(WebClient wc=new WebClient()) {
					byte[] imgBytes=wc.DownloadData(_midtransTransaction.QrCodeUrl);
					using(MemoryStream ms=new MemoryStream(imgBytes)) {
						pictureBoxQr.Image=new Bitmap(ms);
					}
				}
			}
			catch(Exception ex) {
				pictureBoxQr.Visible=false;
				labelQrError.Visible=true;
				labelQrError.Text=Lan.g(this,"Could not load QR code.")+"\r\n"+ex.Message;
			}
		}

		private void StartPolling() {
			_timerPoll=new System.Windows.Forms.Timer();
			_timerPoll.Interval=POLL_INTERVAL_MS;
			_timerPoll.Tick+=TimerPoll_Tick;
			_timerPoll.Start();
		}

		private void TimerPoll_Tick(object sender,EventArgs e) {
			if(DateTime.Now>=_expireAt) {
				StopPolling();
				labelStatus.Text=Lan.g(this,"Status")+": "+Lan.g(this,"QR code expired. Please try again.");
				butCancel.Text=Lan.g(this,"Close");
				return;
			}
			try {
				bool settled=_midtransApi.RefreshTransactionStatus(_midtransTransaction);
				UpdateStatusLabel();
				if(settled) {
					StopPolling();
					IsPaymentSettled=true;
					MidtransTransactionResult=_midtransTransaction;
					ShowSuccessAndCloseSoon();
					return;
				}
				if(_midtransTransaction.TransactionStatus==MidtransTransactionStatus.Expire
					||_midtransTransaction.TransactionStatus==MidtransTransactionStatus.Cancel
					||_midtransTransaction.TransactionStatus==MidtransTransactionStatus.Deny)
				{
					StopPolling();
					UpdateStatusLabel();
					butCancel.Text=Lan.g(this,"Close");
				}
			}
			catch(Exception ex) {
				//Don't crash on poll failure — just show the error and retry next tick
				labelStatus.Text=Lan.g(this,"Status")+": "+Lan.g(this,"Poll error: ")+ex.Message;
			}
		}

		private void UpdateStatusLabel() {
			string statusText=_midtransTransaction.TransactionStatus.ToString();
			labelStatus.Text=Lan.g(this,"Status")+": "+statusText;
		}

		private void ShowSuccessAndCloseSoon() {
			labelInstruction.Text=Lan.g(this,"Payment received. Finalizing QRIS transaction...");
			labelStatus.Text=Lan.g(this,"Status")+": "+Lan.g(this,"Paid successfully");
			labelStatus.ForeColor=Color.FromArgb(0,136,82);
			pictureBoxQr.Visible=false;
			labelQrError.Visible=false;
			panelSuccessCard.Visible=true;
			labelSuccessTitle.Text=Lan.g(this,"Payment Successful");
			labelSuccessSubtitle.Text=Lan.g(this,"QRIS payment has been confirmed and recorded.");
			labelSuccessDetail.Text=Lan.g(this,"Closing this window...");
			labelSimulatorUrl.Visible=false;
			textBoxQrUrl.Visible=false;
			butCopyQrUrl.Visible=false;
			butCancel.Enabled=false;
			_timerCloseSuccess=new System.Windows.Forms.Timer();
			_timerCloseSuccess.Interval=1200;
			_timerCloseSuccess.Tick+=TimerCloseSuccess_Tick;
			_timerCloseSuccess.Start();
		}

		private void TimerCloseSuccess_Tick(object sender,EventArgs e) {
			if(_timerCloseSuccess!=null) {
				_timerCloseSuccess.Stop();
				_timerCloseSuccess.Dispose();
				_timerCloseSuccess=null;
			}
			DialogResult=DialogResult.OK;
			Close();
		}

		private void StopPolling() {
			if(_timerPoll!=null) {
				_timerPoll.Stop();
				_timerPoll.Dispose();
				_timerPoll=null;
			}
		}

		private void butCancel_Click(object sender,EventArgs e) {
			StopPolling();
			if(_midtransTransaction.TransactionStatus==MidtransTransactionStatus.Pending
				||_midtransTransaction.TransactionStatus==MidtransTransactionStatus.Created)
			{
				try {
					_midtransApi.CancelTransaction(_midtransTransaction);
				}
				catch {
					//Best effort — don't block the user from closing
				}
			}
			MidtransTransactionResult=_midtransTransaction;
			DialogResult=DialogResult.Cancel;
			Close();
		}

		protected override void OnFormClosing(FormClosingEventArgs e) {
			StopPolling();
			if(_timerCloseSuccess!=null) {
				_timerCloseSuccess.Stop();
				_timerCloseSuccess.Dispose();
				_timerCloseSuccess=null;
			}
			base.OnFormClosing(e);
		}
	}
}
