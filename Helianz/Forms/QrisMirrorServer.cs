using System;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;

namespace Helianz {
	///<summary>Persistent singleton LAN HTTP server that mirrors the current QRIS payment session to mobile devices.
	///Started lazily on the first QRIS payment form and stays alive for the lifetime of the Helianz session.
	///The Android phone connects once using BaseUrl; the session data updates automatically each payment cycle.</summary>
	internal sealed class QrisMirrorServer {
		private static readonly Lazy<QrisMirrorServer> _instance=new Lazy<QrisMirrorServer>(() => new QrisMirrorServer());
		public static QrisMirrorServer Instance => _instance.Value;

		private readonly object _lock=new object();
		private TcpListener _listener;
		private Thread _serverThread;
		private volatile bool _isRunning;
		private Func<string> _jsonProvider;   // null = standby state
		private Func<byte[]> _imageProvider;
		private string _baseUrl="";

		private const int PORT_START=43123;
		private const int PORT_END=43130;

		private QrisMirrorServer() { }

		///<summary>The persistent base URL (e.g. http://192.168.1.x:43123/qris/current).
		///Empty if the server has not started or failed to start.</summary>
		public string BaseUrl => _baseUrl;

		///<summary>Starts the server if it is not already running.
		///Finds a free port in the range 43123-43130.
		///Returns true on success, false if no port was available or the LAN IP could not be detected.</summary>
		public bool EnsureStarted() {
			if(_isRunning) {
				return true;
			}
			lock(_lock) {
				if(_isRunning) {
					return true;
				}
				try {
					string lanIp=GetPreferredLanIpAddress();
					if(string.IsNullOrEmpty(lanIp)) {
						return false;
					}
					for(int port=PORT_START;port<=PORT_END;port++) {
						try {
							TcpListener candidate=new TcpListener(IPAddress.Any,port);
							candidate.Start();
							_listener=candidate;
							_baseUrl="http://"+lanIp+":"+port+"/qris/current";
							break;
						}
						catch(SocketException) {
							if(port==PORT_END) {
								return false;
							}
							// Try next port.
						}
					}
					_isRunning=true;
					_serverThread=new Thread(ServerLoop) { IsBackground=true,Name="QrisMirrorServer" };
					_serverThread.Start();
					return true;
				}
				catch {
					_listener=null;
					_baseUrl="";
					return false;
				}
			}
		}

		///<summary>Registers the active session providers called per HTTP request.
		///Called when a QRIS payment form opens.</summary>
		public void SetSession(Func<string> jsonProvider,Func<byte[]> imageProvider) {
			lock(_lock) {
				_jsonProvider=jsonProvider;
				_imageProvider=imageProvider;
			}
		}

		///<summary>Clears the active session so the server returns standby state.
		///Called when the QRIS payment form closes.</summary>
		public void ClearSession() {
			lock(_lock) {
				_jsonProvider=null;
				_imageProvider=null;
			}
		}

		private void ServerLoop() {
			while(_isRunning && _listener!=null) {
				TcpClient client=null;
				try {
					client=_listener.AcceptTcpClient();
					HandleClient(client);
				}
				catch(SocketException) {
					if(!_isRunning) {
						break;
					}
				}
				catch(ObjectDisposedException) {
					break;
				}
				catch {
					if(client!=null) {
						try { client.Close(); }
						catch { }
					}
				}
			}
		}

		private void HandleClient(TcpClient tcpClient) {
			using(tcpClient)
			using(NetworkStream stream=tcpClient.GetStream())
			using(StreamReader reader=new StreamReader(stream,Encoding.ASCII,false,1024,true)) {
				string requestLine=reader.ReadLine();
				if(string.IsNullOrEmpty(requestLine)) {
					return;
				}
				// Drain headers.
				string line;
				while(!string.IsNullOrEmpty(line=reader.ReadLine())) { }
				string[] parts=requestLine.Split(' ');
				if(parts.Length<2) {
					WriteResponse(stream,"400 Bad Request","text/plain; charset=utf-8",Encoding.UTF8.GetBytes("Bad request."));
					return;
				}
				if(!string.Equals(parts[0],"GET",StringComparison.OrdinalIgnoreCase)) {
					WriteResponse(stream,"405 Method Not Allowed","text/plain; charset=utf-8",Encoding.UTF8.GetBytes("Only GET is supported."));
					return;
				}
				string path=parts[1];
				int q=path.IndexOf('?');
				if(q>=0) {
					path=path.Substring(0,q);
				}
				path=path.TrimEnd('/');
				if(string.Equals(path,"/qris/current",StringComparison.OrdinalIgnoreCase)) {
					Func<string> jsonProvider;
					lock(_lock) { jsonProvider=_jsonProvider; }
					string json;
					if(jsonProvider==null) {
						json="{\"state\":\"standby\"}";
					}
					else {
						try { json=jsonProvider(); }
						catch { json="{\"state\":\"standby\"}"; }
					}
					WriteResponse(stream,"200 OK","application/json; charset=utf-8",Encoding.UTF8.GetBytes(json));
					return;
				}
				if(string.Equals(path,"/qris/current/qr",StringComparison.OrdinalIgnoreCase)) {
					Func<byte[]> imageProvider;
					lock(_lock) { imageProvider=_imageProvider; }
					if(imageProvider==null) {
						WriteResponse(stream,"404 Not Found","text/plain; charset=utf-8",Encoding.UTF8.GetBytes("No active session."));
						return;
					}
					byte[] imageBytes=null;
					try { imageBytes=imageProvider(); } catch { }
					if(imageBytes==null||imageBytes.Length==0) {
						WriteResponse(stream,"404 Not Found","text/plain; charset=utf-8",Encoding.UTF8.GetBytes("QR image not available."));
						return;
					}
					WriteResponse(stream,"200 OK","image/png",imageBytes);
					return;
				}
				WriteResponse(stream,"404 Not Found","text/plain; charset=utf-8",Encoding.UTF8.GetBytes("Not found."));
			}
		}

		private static void WriteResponse(Stream stream,string status,string contentType,byte[] body) {
			if(body==null) {
				body=new byte[0];
			}
			string header="HTTP/1.1 "+status+"\r\n"
				+"Content-Type: "+contentType+"\r\n"
				+"Content-Length: "+body.Length+"\r\n"
				+"Cache-Control: no-store\r\n"
				+"Access-Control-Allow-Origin: *\r\n"
				+"Connection: close\r\n\r\n";
			byte[] headerBytes=Encoding.ASCII.GetBytes(header);
			stream.Write(headerBytes,0,headerBytes.Length);
			if(body.Length>0) {
				stream.Write(body,0,body.Length);
			}
		}

		private static string GetPreferredLanIpAddress() {
			try {
				using(Socket socket=new Socket(AddressFamily.InterNetwork,SocketType.Dgram,ProtocolType.Udp)) {
					socket.Connect("8.8.8.8",65530);
					IPEndPoint ep=socket.LocalEndPoint as IPEndPoint;
					if(ep!=null&&!IPAddress.IsLoopback(ep.Address)) {
						return ep.Address.ToString();
					}
				}
			}
			catch { }
			try {
				IPHostEntry hostEntry=Dns.GetHostEntry(Dns.GetHostName());
				foreach(IPAddress addr in hostEntry.AddressList) {
					if(addr.AddressFamily!=AddressFamily.InterNetwork||IPAddress.IsLoopback(addr)) {
						continue;
					}
					string a=addr.ToString();
					if(a.StartsWith("192.168.",StringComparison.Ordinal)
						||a.StartsWith("10.",StringComparison.Ordinal)
						||a.StartsWith("172.16.",StringComparison.Ordinal)
						||a.StartsWith("172.17.",StringComparison.Ordinal)
						||a.StartsWith("172.18.",StringComparison.Ordinal)
						||a.StartsWith("172.19.",StringComparison.Ordinal)
						||a.StartsWith("172.2",StringComparison.Ordinal)
						||a.StartsWith("172.30.",StringComparison.Ordinal)
						||a.StartsWith("172.31.",StringComparison.Ordinal))
					{
						return a;
					}
				}
				foreach(IPAddress addr in hostEntry.AddressList) {
					if(addr.AddressFamily==AddressFamily.InterNetwork&&!IPAddress.IsLoopback(addr)) {
						return addr.ToString();
					}
				}
			}
			catch { }
			return "";
		}
	}
}
