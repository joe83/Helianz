using CodeBase;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text;

namespace HelianzBusiness.WebBridges {
	///<summary>Handles Midtrans Core API calls for QRIS payment via GoPay charge.
	///When a customer scans the QR with any QRIS-compatible app, Midtrans settles with payment_type="qris".</summary>
	public class MidtransApi {
		///<summary>Charge endpoint (Sandbox).</summary>
		private const string BASE_URL_SANDBOX   ="https://api.sandbox.midtrans.com";
		///<summary>Charge endpoint (Production).</summary>
		private const string BASE_URL_PRODUCTION="https://api.midtrans.com";
		///<summary>Charge path.</summary>
		private const string CHARGE_PATH        ="/v2/charge";

		private readonly MidtransConfig _config;

		///<summary>Creates an API instance for the given clinic config.</summary>
		public MidtransApi(MidtransConfig config) {
			if(config==null) {
				throw new ArgumentNullException("config");
			}
			if(!config.IsEnabled) {
				throw new ODException("Midtrans is not enabled for this clinic.");
			}
			_config=config;
		}

		///<summary>Returns the base URL depending on the environment setting.</summary>
		private string BaseUrl {
			get {
				return _config.Environment==MidtransEnvironment.Production ? BASE_URL_PRODUCTION : BASE_URL_SANDBOX;
			}
		}

		///<summary>Creates a GoPay/QRIS charge and persists the transaction row.
		///The returned MidtransTransaction is already inserted into the database (status = Pending).
		///Throws ODException on API error.</summary>
		public MidtransTransaction CreateQrisCharge(long patNum,long clinicNum,long amountIdr,string payNote) {
			if(amountIdr<=0) {
				throw new ODException("Payment amount must be greater than zero.");
			}
			string orderId="helianz-"+patNum+"-"+DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();
			string body=JsonConvert.SerializeObject(new {
				payment_type="gopay",
				transaction_details=new {
					order_id=orderId,
					gross_amount=amountIdr,
				},
				gopay=new {
					enable_callback=false,
				},
			});
			string responseJson=PostRequest(CHARGE_PATH,body);
			JObject jObj=JObject.Parse(responseJson);
			string statusCode  =jObj["status_code"]!=null  ? (string)jObj["status_code"]  : "";
			string statusMsg   =jObj["status_message"]!=null? (string)jObj["status_message"]: "";
			//201 = pending (charge created), 200 = already settled
			if(statusCode!="201" && statusCode!="200") {
				throw new ODException("Midtrans charge failed.\r\nStatus: "+statusCode+"\r\n"+statusMsg);
			}
			//Parse actions array for QR code URL and status URL
			string qrCodeUrl="";
			string statusUrl="";
			JArray actions=jObj["actions"] as JArray;
			if(actions!=null) {
				foreach(JObject action in actions) {
					string name=(string)action["name"];
					string url =(string)action["url"];
					if(name=="generate-qr-code") {
						qrCodeUrl=url??string.Empty;
					}
					else if(name=="get-status") {
						statusUrl=url??string.Empty;
					}
				}
			}
			string transactionId=(string)(jObj["transaction_id"]??jObj["order_id"]??orderId);
			MidtransTransaction tx=new MidtransTransaction {
				PatNum          =patNum,
				PayNum          =0,//Will be linked after payment record is created
				OrderId         =orderId,
				TransactionId   =transactionId,
				PaymentType     =(string)(jObj["payment_type"]??"gopay"),
				GrossAmount     =amountIdr,
				QrCodeUrl       =qrCodeUrl,
				StatusUrl       =statusUrl,
				TransactionStatus=MidtransTransactionStatus.Pending,
				LastResponseJson=responseJson,
				DateTimeCreated =DateTime.Now,
				DateTimeSettled =DateTime.MinValue,
				ClinicNum       =clinicNum,
				PayNote         =payNote??string.Empty,
			};
			MidtransTransactions.Insert(tx);
			return tx;
		}

		///<summary>Polls Midtrans for the current status of the given transaction and updates the database row.
		///Returns true if the transaction has settled, false if still pending.
		///Throws ODException on API/network error.</summary>
		public bool RefreshTransactionStatus(MidtransTransaction tx) {
			if(tx==null) {
				throw new ArgumentNullException("tx");
			}
			string path="/v2/"+Uri.EscapeDataString(tx.OrderId)+"/status";
			string responseJson=GetRequest(path);
			JObject jObj=JObject.Parse(responseJson);
			string statusCode      =(string)(jObj["status_code"]     ??"");
			string transactionStatus=(string)(jObj["transaction_status"]??"");
			string fraudStatus     =(string)(jObj["fraud_status"]    ??"");
			tx.LastResponseJson=responseJson;
			//Update payment type in case customer scanned with QRIS (Midtrans reports "qris")
			if(jObj["payment_type"]!=null) {
				tx.PaymentType=(string)jObj["payment_type"];
			}
			MidtransTransactionStatus newStatus=tx.TransactionStatus;
			switch(transactionStatus) {
				case "settlement":
				case "capture":
					if(fraudStatus=="accept" || string.IsNullOrEmpty(fraudStatus)) {
						newStatus=MidtransTransactionStatus.Settlement;
						if(tx.DateTimeSettled==DateTime.MinValue) {
							tx.DateTimeSettled=DateTime.Now;
						}
					}
					else {
						newStatus=MidtransTransactionStatus.Deny;
					}
					break;
				case "pending":
					newStatus=MidtransTransactionStatus.Pending;
					break;
				case "expire":
					newStatus=MidtransTransactionStatus.Expire;
					break;
				case "cancel":
					newStatus=MidtransTransactionStatus.Cancel;
					break;
				case "deny":
					newStatus=MidtransTransactionStatus.Deny;
					break;
				case "refund":
				case "partial_refund":
					//Treat refund as settled (payment was received)
					newStatus=MidtransTransactionStatus.Settlement;
					break;
				default:
					newStatus=MidtransTransactionStatus.Error;
					break;
			}
			tx.TransactionStatus=newStatus;
			MidtransTransactions.Update(tx);
			return newStatus==MidtransTransactionStatus.Settlement;
		}

		///<summary>Cancels a pending Midtrans transaction.
		///Throws ODException if cancel fails.</summary>
		public void CancelTransaction(MidtransTransaction tx) {
			if(tx==null) {
				throw new ArgumentNullException("tx");
			}
			string path="/v2/"+Uri.EscapeDataString(tx.OrderId)+"/cancel";
			string responseJson=PostRequest(path,"");
			JObject jObj=JObject.Parse(responseJson);
			string statusCode=(string)(jObj["status_code"]??"");
			if(statusCode!="200") {
				string statusMsg=(string)(jObj["status_message"]??"");
				throw new ODException("Midtrans cancel failed.\r\nStatus: "+statusCode+"\r\n"+statusMsg);
			}
			tx.TransactionStatus=MidtransTransactionStatus.Cancel;
			tx.LastResponseJson=responseJson;
			MidtransTransactions.Update(tx);
		}

		///<summary>Sends a POST request to the given API path and returns the raw JSON response string.
		///Throws ODException on non-2xx HTTP status or network error.</summary>
		private string PostRequest(string path,string jsonBody) {
			string url=BaseUrl+path;
			HttpWebRequest request=(HttpWebRequest)WebRequest.Create(url);
			request.Method      ="POST";
			request.ContentType ="application/json";
			request.Accept      ="application/json";
			SetAuthorizationHeader(request);
			byte[] bodyBytes=Encoding.UTF8.GetBytes(jsonBody??"");
			request.ContentLength=bodyBytes.Length;
			using(Stream stream=request.GetRequestStream()) {
				stream.Write(bodyBytes,0,bodyBytes.Length);
			}
			return GetResponseString(request);
		}

		///<summary>Sends a GET request to the given API path and returns the raw JSON response string.</summary>
		private string GetRequest(string path) {
			string url=BaseUrl+path;
			HttpWebRequest request=(HttpWebRequest)WebRequest.Create(url);
			request.Method="GET";
			request.Accept="application/json";
			SetAuthorizationHeader(request);
			return GetResponseString(request);
		}

		///<summary>Sets the Authorization header using Basic auth with ServerKey.</summary>
		private void SetAuthorizationHeader(HttpWebRequest request) {
			//Midtrans Basic auth: Base64(ServerKey + ":")  (password is intentionally empty)
			string credentials=Convert.ToBase64String(Encoding.UTF8.GetBytes(_config.ServerKey+":"));
			request.Headers["Authorization"]="Basic "+credentials;
		}

		///<summary>Reads the response from an HttpWebRequest and returns it as a string.
		///On HTTP error responses, reads the error body (Midtrans returns JSON even for 4xx/5xx) and returns it.</summary>
		private static string GetResponseString(HttpWebRequest request) {
			try {
				using(HttpWebResponse response=(HttpWebResponse)request.GetResponse())
				using(StreamReader reader=new StreamReader(response.GetResponseStream(),Encoding.UTF8)) {
					return reader.ReadToEnd();
				}
			}
			catch(WebException ex) when(ex.Response!=null) {
				//Midtrans returns structured JSON in error responses — read body rather than throwing raw exception
				using(StreamReader reader=new StreamReader(ex.Response.GetResponseStream(),Encoding.UTF8)) {
					string errorBody=reader.ReadToEnd();
					if(!string.IsNullOrEmpty(errorBody)) {
						return errorBody;//Let caller parse status_code from it
					}
				}
				throw new ODException("Midtrans API request failed: "+ex.Message,ex);
			}
		}
	}
}
