using System;
using System.Drawing;
using System.Net;
using System.Net.Sockets;
using System.IO;
using System.Text;
using System.Threading;
using System.Windows.Forms;
using CodeBase;
using HelianzBusiness;
using HelianzBusiness.WebBridges;
using ZXing;
using ZXing.Common;

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
		private byte[] _qrImageBytes;
		private string _mirrorBaseUrl="";
		private bool _isConnectionDrawerVisible;
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
			ApplyProfessionalTheme();
			labelAmount.Text     =Lan.g(this,"Amount")+" (IDR): "+_midtransTransaction.GrossAmount.ToString("N0");
			labelOrderId.Text    =Lan.g(this,"Order ID")+": "+_midtransTransaction.OrderId;
			SetStatusDisplay(Lan.g(this,"Waiting for payment..."),Color.FromArgb(24,52,56));
			labelInstruction.Text=Lan.g(this,"Scan the QR code below using GoPay, OVO, DANA, LinkAja, ShopeePay, or any QRIS-enabled app.");
			panelSuccessCard.Visible=false;
			labelPhoneMirror.Visible=true;
			textBoxPhoneMirrorUrl.Visible=true;
			butCopyPhoneMirrorUrl.Visible=true;
			labelPhoneMirrorQr.Visible=true;
			pictureBoxPhoneMirrorQr.Visible=true;
			bool isSandbox=_midtransConfig.Environment==MidtransEnvironment.Sandbox;
			if(isSandbox && !string.IsNullOrEmpty(_midtransTransaction.QrCodeUrl)) {
				textBoxQrUrl.Text       =_midtransTransaction.QrCodeUrl;
				labelSimulatorUrl.Visible=true;
				textBoxQrUrl.Visible    =true;
				butCopyQrUrl.Visible    =true;
			}
			else {
				labelSimulatorUrl.Visible=false;
				textBoxQrUrl.Visible=false;
				butCopyQrUrl.Visible=false;
			}
			UpdateConnectionDrawerState(false);
			LoadQrImage();
			StartMirrorServer();
			StartPolling();
		}

		private void ApplyProfessionalTheme() {
			butToggleConnection.FlatStyle=FlatStyle.Flat;
			butToggleConnection.FlatAppearance.BorderSize=0;
			butToggleConnection.BackColor=Color.FromArgb(17,77,83);
			butToggleConnection.Image=CreateConnectionGlyphBitmap(Color.White);
			butToggleConnection.ImageAlign=ContentAlignment.MiddleCenter;
			butToggleConnection.Text="";
			panelConnectionDrawer.BackColor=Color.FromArgb(251,252,253);
			pictureBoxQr.BackColor=Color.White;
			pictureBoxPhoneMirrorQr.BackColor=Color.White;
			labelQrError.ForeColor=Color.FromArgb(157,56,49);
		}

		private Bitmap CreateConnectionGlyphBitmap(Color glyphColor) {
			Bitmap bitmap=new Bitmap(18,18);
			using(Graphics graphics=Graphics.FromImage(bitmap)) {
				graphics.SmoothingMode=System.Drawing.Drawing2D.SmoothingMode.AntiAlias;
				graphics.Clear(Color.Transparent);
				using(Pen pen=new Pen(glyphColor,2.1f)) {
					graphics.DrawArc(pen,new Rectangle(2,6,7,6),90,180);
					graphics.DrawArc(pen,new Rectangle(8,6,7,6),270,180);
					graphics.DrawLine(pen,6,6,12,6);
					graphics.DrawLine(pen,6,12,12,12);
				}
			}
			return bitmap;
		}

		private void butCopyQrUrl_Click(object sender,EventArgs e) {
			if(!string.IsNullOrEmpty(textBoxQrUrl.Text)) {
				Clipboard.SetText(textBoxQrUrl.Text);
			}
		}

		private void butCopyPhoneMirrorUrl_Click(object sender,EventArgs e) {
			if(!string.IsNullOrEmpty(textBoxPhoneMirrorUrl.Text)) {
				Clipboard.SetText(textBoxPhoneMirrorUrl.Text);
			}
		}

		private void butToggleConnection_Click(object sender,EventArgs e) {
			UpdateConnectionDrawerState(!_isConnectionDrawerVisible);
		}

		private void UpdateConnectionDrawerState(bool isVisible) {
			_isConnectionDrawerVisible=isVisible;
			panelConnectionDrawer.Visible=isVisible;
			pictureBoxQr.Visible=!isVisible && pictureBoxQr.Image!=null;
			if(isVisible) {
				panelConnectionDrawer.BringToFront();
				panelTopBar.BringToFront();
				panelSuccessCard.Visible=false;
				labelQrError.Visible=false;
				butToggleConnection.BackColor=Color.FromArgb(215,232,234);
				butToggleConnection.Image=CreateConnectionGlyphBitmap(Color.FromArgb(20,93,99));
			}
			else {
				butToggleConnection.BackColor=Color.FromArgb(17,77,83);
				butToggleConnection.Image=CreateConnectionGlyphBitmap(Color.White);
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
					_qrImageBytes=wc.DownloadData(_midtransTransaction.QrCodeUrl);
					using(MemoryStream ms=new MemoryStream(_qrImageBytes)) {
						pictureBoxQr.Image=new Bitmap(ms);
					}
				}
				pictureBoxQr.Visible=!_isConnectionDrawerVisible;
			}
			catch(Exception ex) {
				_qrImageBytes=null;
				pictureBoxQr.Visible=false;
				labelQrError.Visible=true;
				labelQrError.Text=Lan.g(this,"Could not load QR code.")+"\r\n"+ex.Message;
			}
		}

		private void StartMirrorServer() {
			try {
				bool started=QrisMirrorServer.Instance.EnsureStarted();
				if(!started||string.IsNullOrEmpty(QrisMirrorServer.Instance.BaseUrl)) {
					throw new ODException("Could not start LAN mirror server.");
				}
				_mirrorBaseUrl=QrisMirrorServer.Instance.BaseUrl;
				QrisMirrorServer.Instance.SetSession(BuildMirrorSessionJson,() => _qrImageBytes);
				textBoxPhoneMirrorUrl.Text=_mirrorBaseUrl;
				ShowPhoneMirrorQr();
				butCopyPhoneMirrorUrl.Enabled=true;
			}
			catch(Exception ex) {
				_mirrorBaseUrl="";
				textBoxPhoneMirrorUrl.Text=Lan.g(this,"Phone mirror unavailable: ")+ex.Message;
				pictureBoxPhoneMirrorQr.Image=null;
				pictureBoxPhoneMirrorQr.Visible=false;
				labelPhoneMirrorQr.Visible=false;
				butCopyPhoneMirrorUrl.Enabled=false;
			}
		}

		private void ShowPhoneMirrorQr() {
			if(string.IsNullOrWhiteSpace(_mirrorBaseUrl)) {
				pictureBoxPhoneMirrorQr.Image=null;
				pictureBoxPhoneMirrorQr.Visible=false;
				labelPhoneMirrorQr.Visible=false;
				return;
			}
			BarcodeWriter barcodeWriter=new BarcodeWriter();
			barcodeWriter.Format=BarcodeFormat.QR_CODE;
			barcodeWriter.Options=new EncodingOptions() {
				Height=180,
				Width=180,
				Margin=1,
				PureBarcode=true,
			};
			pictureBoxPhoneMirrorQr.Image=barcodeWriter.Write(_mirrorBaseUrl);
			pictureBoxPhoneMirrorQr.Visible=true;
			labelPhoneMirrorQr.Visible=true;
		}





		private string BuildMirrorSessionJson() {
			string qrImageUrl=QrisMirrorServer.Instance.BaseUrl+"/qr";
			return "{"
				+"\"state\":\"active\","
				+"\"orderId\":\""+JsonEscape(_midtransTransaction.OrderId)+"\"," 
				+"\"amountIdr\":"+_midtransTransaction.GrossAmount+"," 
				+"\"status\":\""+JsonEscape(_midtransTransaction.TransactionStatus.ToString())+"\"," 
				+"\"statusDisplay\":\""+JsonEscape(GetStatusDisplayText())+"\"," 
				+"\"isSettled\":"+GetJsonBool(_midtransTransaction.TransactionStatus==MidtransTransactionStatus.Settlement)+"," 
				+"\"isExpired\":"+GetJsonBool(DateTime.Now>=_expireAt || _midtransTransaction.TransactionStatus==MidtransTransactionStatus.Expire)+"," 
				+"\"expiresAt\":\""+JsonEscape(_expireAt.ToUniversalTime().ToString("o"))+"\"," 
				+"\"qrImageUrl\":\""+JsonEscape(qrImageUrl)+"\"," 
				+"\"remoteQrCodeUrl\":\""+JsonEscape(_midtransTransaction.QrCodeUrl??"")+"\"," 
				+"\"mirrorUrl\":\""+JsonEscape(QrisMirrorServer.Instance.BaseUrl)+"\""
				+"}";
		}

		private string GetStatusDisplayText() {
			if(_midtransTransaction.TransactionStatus==MidtransTransactionStatus.Settlement) {
				return Lan.g(this,"Paid successfully");
			}
			if(DateTime.Now>=_expireAt || _midtransTransaction.TransactionStatus==MidtransTransactionStatus.Expire) {
				return Lan.g(this,"QR code expired. Please try again.");
			}
			if(_midtransTransaction.TransactionStatus==MidtransTransactionStatus.Cancel) {
				return Lan.g(this,"Transaction cancelled");
			}
			if(_midtransTransaction.TransactionStatus==MidtransTransactionStatus.Deny) {
				return Lan.g(this,"Transaction denied");
			}
			if(_midtransTransaction.TransactionStatus==MidtransTransactionStatus.Error) {
				return Lan.g(this,"Transaction status unavailable");
			}
			return Lan.g(this,"Waiting for payment...");
		}

		private string GetJsonBool(bool value) {
			return value ? "true" : "false";
		}

		private string JsonEscape(string value) {
			if(string.IsNullOrEmpty(value)) {
				return string.Empty;
			}
			StringBuilder stringBuilder=new StringBuilder(value.Length+8);
			for(int i=0;i<value.Length;i++) {
				char currentChar=value[i];
				switch(currentChar) {
					case '\\':
						stringBuilder.Append("\\\\");
						break;
					case '"':
						stringBuilder.Append("\\\"");
						break;
					case '\r':
						stringBuilder.Append("\\r");
						break;
					case '\n':
						stringBuilder.Append("\\n");
						break;
					case '\t':
						stringBuilder.Append("\\t");
						break;
					default:
						if(currentChar<32) {
							stringBuilder.Append("\\u");
							stringBuilder.Append(((int)currentChar).ToString("x4"));
						}
						else {
							stringBuilder.Append(currentChar);
						}
						break;
				}
			}
			return stringBuilder.ToString();
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
				SetStatusDisplay(Lan.g(this,"QR code expired. Please try again."),Color.FromArgb(165,90,21));
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
				SetStatusDisplay(Lan.g(this,"Poll error: ")+ex.Message,Color.FromArgb(157,56,49));
			}
		}

		private void UpdateStatusLabel() {
			string statusText=_midtransTransaction.TransactionStatus.ToString();
			Color statusColor=Color.FromArgb(24,52,56);
			if(_midtransTransaction.TransactionStatus==MidtransTransactionStatus.Settlement) {
				statusColor=Color.FromArgb(0,136,82);
			}
			else if(_midtransTransaction.TransactionStatus==MidtransTransactionStatus.Expire) {
				statusColor=Color.FromArgb(165,90,21);
			}
			else if(_midtransTransaction.TransactionStatus==MidtransTransactionStatus.Cancel
				|| _midtransTransaction.TransactionStatus==MidtransTransactionStatus.Deny
				|| _midtransTransaction.TransactionStatus==MidtransTransactionStatus.Error)
			{
				statusColor=Color.FromArgb(157,56,49);
			}
			SetStatusDisplay(statusText,statusColor);
		}

		private void SetStatusDisplay(string statusText,Color statusColor) {
			labelStatus.Text=Lan.g(this,"Status")+": "+statusText;
			labelStatus.ForeColor=statusColor;
		}

		private void ShowSuccessAndCloseSoon() {
			labelInstruction.Text=Lan.g(this,"Payment received. Finalizing QRIS transaction...");
			SetStatusDisplay(Lan.g(this,"Paid successfully"),Color.FromArgb(0,136,82));
			UpdateConnectionDrawerState(false);
			pictureBoxQr.Visible=false;
			labelQrError.Visible=false;
			panelSuccessCard.Visible=true;
			labelSuccessTitle.Text=Lan.g(this,"Payment Successful");
			labelSuccessSubtitle.Text=Lan.g(this,"QRIS payment has been confirmed and recorded.");
			labelSuccessDetail.Text=Lan.g(this,"Closing this window...");
			labelSimulatorUrl.Visible=false;
			textBoxQrUrl.Visible=false;
			butCopyQrUrl.Visible=false;
			panelConnectionDrawer.Visible=false;
			butCancel.Enabled=false;
			_timerCloseSuccess=new System.Windows.Forms.Timer();
			_timerCloseSuccess.Interval=2200;
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

		private void StopMirrorServer() {
			QrisMirrorServer.Instance.ClearSession();
			pictureBoxPhoneMirrorQr.Image=null;
		}

		private void butCancel_Click(object sender,EventArgs e) {
			StopPolling();
			StopMirrorServer();
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
			StopMirrorServer();
			if(_timerCloseSuccess!=null) {
				_timerCloseSuccess.Stop();
				_timerCloseSuccess.Dispose();
				_timerCloseSuccess=null;
			}
			base.OnFormClosing(e);
		}
	}
}
