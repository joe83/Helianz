using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web.Services.Protocols;
using System.Xml;

namespace HelianzBusiness {
	///<summary>This is a helper class that allows the real HelianzServer.ServiceMain class implement IHelianzServer.
	///This also gives us a place to add code if we ever need to configure the HTTP/SOAP connection.</summary>
	public class HelianzServerReal:HelianzBusiness.HelianzServer.ServiceMain, IHelianzServer {

		protected override WebRequest GetWebRequest(Uri uri) {
			// Ensure TLS 1.2 is enabled across the application
			try {
				ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12;
			}
			catch { }

			WebRequest req=base.GetWebRequest(uri);
			if(req is HttpWebRequest httpReq) {
				// Avoid 100-Continue roundtrip delay
				httpReq.ServicePoint.Expect100Continue=false;
				httpReq.ServicePoint.UseNagleAlgorithm=false;
				httpReq.ServicePoint.ConnectionLimit=20;
				httpReq.ServicePoint.MaxIdleTime=30000;
				httpReq.Timeout=60000;
				// If no proxy configured, disable WPAD auto-detection which hangs on Win7
				if(RemotingClient.MidTierProxyAddress==null || RemotingClient.MidTierProxyAddress=="") {
					httpReq.Proxy=GlobalProxySelection.GetEmptyWebProxy();
				}
			}
			return req;
		}

		protected override WebResponse GetWebResponse(WebRequest request) {
			try {
				WebResponse response=base.GetWebResponse(request);
				Diag("GetWebResponse",$"OK URL={request.RequestUri}");
				return response;
			}
			catch(Exception ex) {
				Diag("GetWebResponse ERROR",$"{ex.GetType().Name}: {ex.Message} URL={request.RequestUri}");
				throw;
			}
		}

		private static void Diag(string tag,string msg) {
			try {
				string logPath=Path.Combine(Path.GetTempPath(),"Helianz_Diag.log");
				File.AppendAllText(logPath,$"{DateTime.Now:HH:mm:ss.fff} [Real.{tag}] {msg}\n");
			}
			catch { }
		}
	}
}
