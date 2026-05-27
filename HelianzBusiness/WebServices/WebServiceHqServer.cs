using System;

namespace HelianzBusiness.WebServices {
	public class WebServiceHqServer {
			public string ServerName;
			public long Port=49999;//HTTP
			public DateTime Heartbeat;
			public string ServiceUrl => $"http://{ServerName}:{Port}/HelianzWebServiceHQ/WebServiceMainHQ.asmx";

		public WebServiceHqServer() {

		}

		public WebServiceHqServer(string serverName) {
			ServerName=serverName;
		}
	}
}
