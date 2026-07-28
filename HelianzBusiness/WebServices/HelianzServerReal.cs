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
	///This also gives us a place to add code in the future if we ever need to add anything to HelianzServer.ServiceMain.</summary>
	public class HelianzServerReal:HelianzBusiness.HelianzServer.ServiceMain, IHelianzServer {
		private static readonly object _diagLock=new object();

		///<summary>Minimal fix: only buffer enough to fix the XML declaration (6 chars).
		///We DON'T buffer the entire response — just read the first 1KB, fix if needed,
		///then stream the rest directly. This avoids IIS timeout on slow connections.</summary>
		protected override WebResponse GetWebResponse(WebRequest request) {
			WebResponse response=base.GetWebResponse(request);
			try {
				Stream realStream=response.GetResponseStream();
				if(realStream==null) return response;
				//Read just the first 1KB to check/fix encoding
				byte[] prefix=new byte[1024];
				int prefixLen=0;
				int totalRead=0;
				while(totalRead<prefix.Length) {
					int n=realStream.Read(prefix,totalRead,prefix.Length-totalRead);
					if(n<=0) break;
					totalRead+=n;
				}
				byte[] actualPrefix=new byte[totalRead];
				Array.Copy(prefix,actualPrefix,totalRead);
				string prefixText=Encoding.UTF8.GetString(actualPrefix);
				bool hadFix=false;
				if(prefixText.Contains("encoding=\"utf-16\"")) {
					prefixText=prefixText.Replace("encoding=\"utf-16\"","encoding=\"utf-8\"");
					hadFix=true;
					actualPrefix=Encoding.UTF8.GetBytes(prefixText);
				}
				Diag("GetWebResponse",$"prefix={totalRead}b fixed={hadFix}");
				return new PrefixStreamResponse(actualPrefix,realStream,response);
			}
			catch(Exception ex) {
				Diag("GetWebResponse ERROR",$"{ex.GetType().Name}: {ex.Message}");
				throw;
			}
		}

		///<summary>Response that streams: fixed prefix bytes first, then the original network stream.</summary>
		private class PrefixStreamResponse : WebResponse {
			byte[] _prefix;
			Stream _rest;
			WebResponse _inner;
			long _length;
			public PrefixStreamResponse(byte[] prefix,Stream rest,WebResponse inner) {
				_prefix=prefix; _rest=rest; _inner=inner;
				_length=prefix.Length+(_inner.ContentLength>0 ? _inner.ContentLength : 0);
			}
			public override Stream GetResponseStream() {
				return new CombinedStream(_prefix,_rest);
			}
			public override long ContentLength => _length;
			public override string ContentType => _inner.ContentType;
			public override WebHeaderCollection Headers => _inner.Headers;
			public override Uri ResponseUri => _inner.ResponseUri;
			public override void Close() { _rest?.Close(); _inner?.Close(); }
		}

		///<summary>Reads prefix bytes first, then delegates to the original stream.</summary>
		private class CombinedStream : Stream {
			byte[] _prefix;
			Stream _rest;
			int _prefixPos;
			public CombinedStream(byte[] prefix,Stream rest) { _prefix=prefix; _rest=rest; }
			public override int Read(byte[] buffer,int offset,int count) {
				if(_prefixPos<_prefix.Length) {
					int n=Math.Min(count,_prefix.Length-_prefixPos);
					Array.Copy(_prefix,_prefixPos,buffer,offset,n);
					_prefixPos+=n;
					return n;
				}
				return _rest.Read(buffer,offset,count);
			}
			public override bool CanRead => true;
			public override bool CanSeek => false;
			public override bool CanWrite => false;
			public override long Length => throw new NotSupportedException();
			public override long Position { get => throw new NotSupportedException(); set => throw new NotSupportedException(); }
			public override void Flush() { }
			public override long Seek(long offset,SeekOrigin origin) => throw new NotSupportedException();
			public override void SetLength(long value) => throw new NotSupportedException();
			public override void Write(byte[] buffer,int offset,int count) => throw new NotSupportedException();
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
