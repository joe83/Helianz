using System;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Text;
using System.Threading;

namespace HelianzBusiness {
	///<summary>High-detail, thread-safe logger for Middle Tier SOAP calls and XML serialization payloads.</summary>
	public static class SoapLogger {
		///<summary>Master switch to enable/disable diagnostic logging.</summary>
		public static bool IsEnabled=false;

		private static readonly object _fileLock=new object();
		private static long _callSequence=0;
		private static string _primaryLogPath;
		private static string _appLogPath;

		[ThreadStatic]
		private static long _currentCallId;

		///<summary>Thread-static current Call ID for correlating SOAP extension stages with RemotingClient calls.</summary>
		public static long CurrentCallId {
			get => _currentCallId;
			set => _currentCallId=value;
		}

		static SoapLogger() {
			try {
				_primaryLogPath=Path.Combine(Path.GetTempPath(),"Helianz_Soap.log");
				string appDir=AppDomain.CurrentDomain.BaseDirectory;
				if(!string.IsNullOrEmpty(appDir)) {
					_appLogPath=Path.Combine(appDir,"Helianz_Soap.log");
				}
			}
			catch { }
		}

		///<summary>Primary log file location (typically %TEMP%\Helianz_Soap.log).</summary>
		public static string PrimaryLogPath => _primaryLogPath;

		///<summary>Next monotonic call ID for grouping request/response pairs.</summary>
		public static long GetNextCallId() {
			return Interlocked.Increment(ref _callSequence);
		}

		///<summary>Logs a formatted block to the log file with immediate flush.</summary>
		public static void Log(string message) {
			if(!IsEnabled) {
				return;
			}
			try {
				lock(_fileLock) {
					if(!string.IsNullOrEmpty(_primaryLogPath)) {
						File.AppendAllText(_primaryLogPath,message);
					}
					// Also attempt writing to app directory if different and writable
					if(!string.IsNullOrEmpty(_appLogPath) && _appLogPath!=_primaryLogPath) {
						try {
							File.AppendAllText(_appLogPath,message);
						}
						catch {
							// Ignored if app directory is read-only (e.g. Program Files)
						}
					}
				}
			}
			catch { }
		}

		///<summary>Logs start of a DTO request before SOAP invocation.</summary>
		public static void LogDtoRequest(long callId,string methodName,string serverUri,string dtoString) {
			if(!IsEnabled) return;
			StringBuilder sb=new StringBuilder();
			sb.AppendLine(new string('=',80));
			sb.AppendLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss.fff}] [Call #{callId}] [Thread {Thread.CurrentThread.ManagedThreadId}] METHOD: {methodName}");
			sb.AppendLine($"URL: {serverUri}");
			sb.AppendLine(new string('-',80));
			sb.AppendLine($">>> OUTGOING DTO PAYLOAD (Length: {dtoString?.Length ?? 0} chars):");
			sb.AppendLine(dtoString ?? "(null)");
			sb.AppendLine();
			Log(sb.ToString());
		}

		///<summary>Logs the raw outgoing SOAP Envelope XML sent over the wire.</summary>
		public static void LogRawSoapRequest(long callId,string soapXml,string url) {
			if(!IsEnabled) return;
			StringBuilder sb=new StringBuilder();
			sb.AppendLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss.fff}] [Call #{callId}] [Thread {Thread.CurrentThread.ManagedThreadId}] >>> RAW SOAP REQUEST XML (Length: {soapXml?.Length ?? 0} chars):");
			sb.AppendLine(soapXml ?? "(null)");
			sb.AppendLine();
			Log(sb.ToString());
		}

		///<summary>Logs the raw incoming SOAP Envelope XML received over the wire.</summary>
		public static void LogRawSoapResponse(long callId,string soapXml,long elapsedMs) {
			if(!IsEnabled) return;
			StringBuilder sb=new StringBuilder();
			sb.AppendLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss.fff}] [Call #{callId}] [Thread {Thread.CurrentThread.ManagedThreadId}] <<< RAW SOAP RESPONSE XML (Elapsed: {elapsedMs}ms, Length: {soapXml?.Length ?? 0} chars):");
			sb.AppendLine(soapXml ?? "(null)");
			sb.AppendLine();
			Log(sb.ToString());
		}

		///<summary>Logs the extracted ProcessRequestResult string.</summary>
		public static void LogDtoResponse(long callId,string methodName,string resultString,long elapsedMs) {
			if(!IsEnabled) return;
			StringBuilder sb=new StringBuilder();
			sb.AppendLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss.fff}] [Call #{callId}] [Thread {Thread.CurrentThread.ManagedThreadId}] <<< PARSED SOAP RESULT (Method: {methodName}, Elapsed: {elapsedMs}ms, Length: {resultString?.Length ?? 0} chars):");
			sb.AppendLine(resultString ?? "(null)");
			sb.AppendLine();
			Log(sb.ToString());
		}

		///<summary>Logs successful deserialization of DTO result object.</summary>
		public static void LogDeserializedResult(long callId,string methodName,Type targetType,object resultObj) {
			if(!IsEnabled) return;
			StringBuilder sb=new StringBuilder();
			sb.AppendLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss.fff}] [Call #{callId}] [Thread {Thread.CurrentThread.ManagedThreadId}] <<< DESERIALIZED OBJECT:");
			sb.AppendLine($"Target Type: {targetType?.FullName}");
			if(resultObj==null) {
				sb.AppendLine("Result: null");
			}
			else if(resultObj is System.Data.DataTable dt) {
				sb.AppendLine($"Result: DataTable '{dt.TableName}', Rows: {dt.Rows.Count}, Columns: {dt.Columns.Count}");
			}
			else if(resultObj is System.Data.DataSet ds) {
				sb.AppendLine($"Result: DataSet '{ds.DataSetName}', Tables: {ds.Tables.Count}");
			}
			else {
				sb.AppendLine($"Result: {resultObj}");
			}
			sb.AppendLine(new string('=',80));
			sb.AppendLine();
			Log(sb.ToString());
		}

		///<summary>Logs an error or exception that occurred during any phase of MT communication or deserialization.</summary>
		public static void LogError(long callId,string stage,string methodName,Exception ex,string rawPayload=null) {
			if(!IsEnabled) return;
			StringBuilder sb=new StringBuilder();
			sb.AppendLine(new string('!',80));
			sb.AppendLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss.fff}] [Call #{callId}] [Thread {Thread.CurrentThread.ManagedThreadId}] !!! ERROR AT STAGE: {stage}");
			sb.AppendLine($"Method: {methodName}");
			sb.AppendLine($"Exception Type: {ex?.GetType().FullName}");
			sb.AppendLine($"Message: {ex?.Message}");
			if(ex?.InnerException!=null) {
				sb.AppendLine($"Inner Exception: {ex.InnerException.GetType().FullName} - {ex.InnerException.Message}");
			}
			sb.AppendLine($"Stack Trace:\n{ex?.StackTrace}");
			if(!string.IsNullOrEmpty(rawPayload)) {
				sb.AppendLine($"Raw Payload at Error:\n{rawPayload}");
			}
			sb.AppendLine(new string('!',80));
			sb.AppendLine();
			Log(sb.ToString());
		}
	}
}
