using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Security;
using System.Net.Sockets;
using System.Security.Cryptography.X509Certificates;
using System.Xml;
using System.Xml.Linq;

namespace HelianzBusiness {
	/// <summary>
	/// Manages a local trust store for SSL/TLS server certificates.
	/// 
	/// When connecting to a Helianz Middle Tier server over HTTPS with a self-signed
	/// certificate, this class:
	///   1. Performs a pre-TLS handshake to inspect the server certificate.
	///   2. Checks a local trust store (TrustedServerCerts.xml in AppData).
	///   3. If untrusted, returns the certificate details so the UI can prompt the user.
	///   4. Once accepted, the certificate thumbprint is permanently stored.
	/// 
	/// After a certificate is trusted, the global ServerCertificateValidationCallback
	/// accepts it for all subsequent HTTPS connections within the same process.
	/// </summary>
	public static class CertTrustManager {

		/// <summary>Set of trusted certificate thumbprints (uppercase, no spaces).</summary>
		private static HashSet<string> _trustedThumbprints = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

		/// <summary>Lock for thread-safe access to the trust set.</summary>
		private static readonly object _lock = new object();

		/// <summary>Path to the trust store XML file.</summary>
		private static string _trustFilePath;

		/// <summary>Whether the trust store has been loaded from disk.</summary>
		private static bool _isLoaded;

		/// <summary>Indicates whether InitTrustStore() has been called.</summary>
		private static bool _isInitialized;

		// ─────────────────────────────────────────────────────────────────
		// Initialization
		// ─────────────────────────────────────────────────────────────────

		/// <summary>
		/// Must be called once before any HTTPS connections are made.
		/// Loads the trust store from disk and registers the global SSL callback.
		/// Safe to call multiple times — subsequent calls are no-ops.
		/// </summary>
		public static void InitTrustStore() {
			if(_isInitialized) return;

			// Determine trust file path: %AppData%\Helianz\TrustedServerCerts.xml
			string appData = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);
			string helianzDir = Path.Combine(appData, "Helianz");
			Directory.CreateDirectory(helianzDir);
			_trustFilePath = Path.Combine(helianzDir, "TrustedServerCerts.xml");

			LoadTrustStore();

			// Register the global SSL callback.
			// This callback runs for EVERY HTTPS ServicePoint connection.
			// It checks our local trust store in addition to the Windows cert store.
			ServicePointManager.ServerCertificateValidationCallback = ValidateServerCertificate;

			_isInitialized = true;
		}

		// ─────────────────────────────────────────────────────────────────
		// Trust store persistence (simple XML)
		// ─────────────────────────────────────────────────────────────────

		private static void LoadTrustStore() {
			lock(_lock) {
				if(_isLoaded) return;
				_trustedThumbprints.Clear();

				if(!File.Exists(_trustFilePath)) {
					_isLoaded = true;
					return;
				}

				try {
					XDocument doc = XDocument.Load(_trustFilePath);
					foreach(XElement el in doc.Root.Elements("Cert")) {
						string thumb = (string)el.Attribute("thumbprint");
						if(!string.IsNullOrWhiteSpace(thumb)) {
							_trustedThumbprints.Add(thumb.Replace(" ", "").ToUpperInvariant());
						}
					}
				}
				catch {
					// Corrupt trust file — start fresh
					_trustedThumbprints.Clear();
				}

				_isLoaded = true;
			}
		}

		private static void SaveTrustStore() {
			lock(_lock) {
				try {
					XDocument doc = new XDocument(
						new XElement("TrustedServerCerts",
							System.Linq.Enumerable.Select(_trustedThumbprints,
								t => new XElement("Cert",
									new XAttribute("thumbprint", t),
									new XAttribute("trustedOn", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"))
								)
							)
						)
					);
					doc.Save(_trustFilePath);
				}
				catch {
					// Best-effort — trust is still held in memory for this session
				}
			}
		}

		// ─────────────────────────────────────────────────────────────────
		// Public API
		// ─────────────────────────────────────────────────────────────────

		/// <summary>Returns true if the certificate thumbprint is in the local trust store.</summary>
		public static bool IsTrusted(string thumbprint) {
			if(string.IsNullOrWhiteSpace(thumbprint)) return false;
			string normalized = thumbprint.Replace(" ", "").ToUpperInvariant();
			lock(_lock) {
				return _trustedThumbprints.Contains(normalized);
			}
		}

		/// <summary>
		/// Permanently trusts a certificate by storing its thumbprint.
		/// The cert will be accepted for all future connections.
		/// </summary>
		public static void TrustCertificate(string thumbprint, string host) {
			if(string.IsNullOrWhiteSpace(thumbprint)) return;
			string normalized = thumbprint.Replace(" ", "").ToUpperInvariant();
			bool added;
			lock(_lock) {
				added = _trustedThumbprints.Add(normalized);
			}
			if(added) {
				SaveTrustStore();
			}
		}

		/// <summary>
		/// Convenience method: validates the server certificate at the given HTTPS URI.
		/// If the certificate is untrusted (e.g. self-signed), shows a warning dialog
		/// asking the user whether to trust it (similar to SSH host-key prompting).
		/// 
		/// Returns true if the connection should proceed (cert is valid or user accepted),
		/// false if the user rejected the certificate.
		/// </summary>
		/// <param name="serviceUri">Full HTTPS service URI string.</param>
		public static bool HandleUntrustedCertificate(string serviceUri) {
			InitTrustStore();
			Uri serverUri;
			if(!Uri.TryCreate(serviceUri,UriKind.Absolute,out serverUri)) {
				return true; // Can't parse URI — let the normal connection attempt handle errors
			}
			if(serverUri.Scheme!="https") {
				return true;
			}

			var certResult=PreviewServerCertificate(serverUri);
			if(certResult==null || certResult.Certificate==null || certResult.IsValid) {
				return true; // Cert is valid or server unreachable — let normal flow handle it
			}

			// Already trusted from a previous session?
			if(IsTrusted(certResult.Thumbprint)) {
				return true;
			}

			// Show warning dialog
			System.Windows.Forms.DialogResult userChoice=System.Windows.Forms.MessageBox.Show(
				"The server's security certificate is not trusted.\n\n"+
				certResult.GetDisplayText()+"\n\n"+
				"Do you want to trust this certificate and continue connecting?\n\n"+
				"WARNING: Only accept certificates from servers you recognize.\n"+
				"Accepting an untrusted certificate could allow a third party\n"+
				"to intercept your connection.",
				"Certificate Trust Warning",
				System.Windows.Forms.MessageBoxButtons.YesNo,
				System.Windows.Forms.MessageBoxIcon.Warning);

			if(userChoice==System.Windows.Forms.DialogResult.Yes) {
				TrustCertificate(certResult.Thumbprint,certResult.HostName);
				return true;
			}

			return false;
		}

		/// <summary>
		/// Performs a pre-TLS handshake to the server and returns the certificate
		/// along with validation errors. Does NOT send an HTTP request — only
		/// completes the TLS handshake.
		/// 
		/// Returns null if the server cannot be reached or doesn't speak TLS.
		/// </summary>
		/// <param name="uri">The HTTPS URI of the server (e.g. https://server:443/HelianzServer)</param>
		public static CertValidationResult PreviewServerCertificate(Uri uri) {
			if(uri == null) throw new ArgumentNullException(nameof(uri));
			if(uri.Scheme != "https") return null;

			string host = uri.Host;
			int port = uri.Port > 0 ? uri.Port : 443;

			try {
				using(TcpClient tcp = new TcpClient()) {
					// Connect with a short timeout
					var ar = tcp.BeginConnect(host, port, null, null);
					if(!ar.AsyncWaitHandle.WaitOne(5000)) {
						return null; // timeout
					}
					tcp.EndConnect(ar);

					using(SslStream ssl = new SslStream(
						tcp.GetStream(),
						false,
						// We use a permissive callback here just to capture the cert.
						// The actual trust decision is made by the caller after inspecting the result.
						(sender, cert, chain, errors) => true
					)) {
						ssl.AuthenticateAsClient(host);

						X509Certificate2 serverCert = new X509Certificate2(ssl.RemoteCertificate);

						// Now validate properly using X509Chain
						X509Chain chain = new X509Chain();
						chain.ChainPolicy.RevocationMode = X509RevocationMode.NoCheck;
						chain.ChainPolicy.VerificationFlags = X509VerificationFlags.NoFlag;

						bool isValid = chain.Build(serverCert);

						SslPolicyErrors policyErrors = SslPolicyErrors.None;
						if(!isValid) {
							// Check chain status for specific errors
							foreach(X509ChainStatus status in chain.ChainStatus) {
								if(status.Status == X509ChainStatusFlags.UntrustedRoot) {
									policyErrors |= SslPolicyErrors.RemoteCertificateChainErrors;
								}
								else if(status.Status != X509ChainStatusFlags.NoError) {
									policyErrors |= SslPolicyErrors.RemoteCertificateChainErrors;
								}
							}
						}

						// Also validate the hostname
						if(!string.Equals(host, GetCertificateHostName(serverCert), StringComparison.OrdinalIgnoreCase)) {
							// Check SAN (Subject Alternative Name)
							bool nameMatches = false;
							foreach(X509Extension ext in serverCert.Extensions) {
								if(ext.Oid.Value == "2.5.29.17") { // Subject Alternative Name
									string san = ext.Format(false);
									if(san != null && san.IndexOf(host, StringComparison.OrdinalIgnoreCase) >= 0) {
										nameMatches = true;
										break;
									}
								}
							}
							if(!nameMatches) {
								policyErrors |= SslPolicyErrors.RemoteCertificateNameMismatch;
							}
						}

						return new CertValidationResult {
							Certificate = serverCert,
							Thumbprint = serverCert.Thumbprint,
							Subject = serverCert.Subject,
							Issuer = serverCert.Issuer,
							ValidFrom = serverCert.NotBefore,
							ValidTo = serverCert.NotAfter,
							HostName = host,
							PolicyErrors = policyErrors,
							IsValid = (policyErrors == SslPolicyErrors.None),
						};
					}
				}
			}
			catch(Exception ex) {
				// Could not establish TLS — server may not have HTTPS configured
				return new CertValidationResult {
					Certificate = null,
					Thumbprint = null,
					Subject = null,
					Issuer = null,
					ValidFrom = DateTime.MinValue,
					ValidTo = DateTime.MinValue,
					HostName = host,
					PolicyErrors = SslPolicyErrors.RemoteCertificateNotAvailable,
					IsValid = false,
					ErrorMessage = ex.Message,
				};
			}
		}

		// ─────────────────────────────────────────────────────────────────
		// Global SSL callback
		// ─────────────────────────────────────────────────────────────────

		/// <summary>
		/// Global callback registered with ServicePointManager.
		/// Called for every HTTPS connection. Checks our local trust store
		/// in addition to the Windows certificate store.
		/// </summary>
		private static bool ValidateServerCertificate(
			object sender,
			X509Certificate certificate,
			X509Chain chain,
			SslPolicyErrors sslPolicyErrors)
		{
			// If the cert passes standard validation, accept immediately
			if(sslPolicyErrors == SslPolicyErrors.None) {
				return true;
			}

			// If the cert is in our local trust store, accept it
			X509Certificate2 cert2 = certificate as X509Certificate2
				?? new X509Certificate2(certificate);

			if(IsTrusted(cert2.Thumbprint)) {
				return true;
			}

			// If there are other callbacks in the chain that accept it, let them
			// (We can't easily check — just reject and let the UI handle it)
			return false;
		}

		// ─────────────────────────────────────────────────────────────────
		// Helpers
		// ─────────────────────────────────────────────────────────────────

		/// <summary>Extracts the CN from a certificate's Subject.</summary>
		private static string GetCertificateHostName(X509Certificate2 cert) {
			if(cert == null) return "";
			string subject = cert.Subject;
			// Subject format: "CN=hostname, O=..., ..."
			foreach(string part in subject.Split(',')) {
				string trimmed = part.Trim();
				if(trimmed.StartsWith("CN=", StringComparison.OrdinalIgnoreCase)) {
					return trimmed.Substring(3);
				}
			}
			return "";
		}
	}

	/// <summary>
	/// Result of a pre-TLS certificate inspection.
	/// </summary>
	public class CertValidationResult {
		/// <summary>The X509 certificate (null if TLS handshake failed).</summary>
		public X509Certificate2 Certificate;

		/// <summary>SHA1 thumbprint of the certificate.</summary>
		public string Thumbprint;

		/// <summary>Certificate subject (e.g. "CN=server.local").</summary>
		public string Subject;

		/// <summary>Certificate issuer (e.g. "CN=server.local" for self-signed).</summary>
		public string Issuer;

		/// <summary>Certificate validity start date.</summary>
		public DateTime ValidFrom;

		/// <summary>Certificate validity end date.</summary>
		public DateTime ValidTo;

		/// <summary>The hostname that was being connected to.</summary>
		public string HostName;

		/// <summary>SSL policy errors detected.</summary>
		public SslPolicyErrors PolicyErrors;

		/// <summary>True if no policy errors were detected.</summary>
		public bool IsValid;

		/// <summary>Error message if the TLS handshake itself failed.</summary>
		public string ErrorMessage;

		/// <summary>Returns a human-readable summary of the certificate for display in a dialog.</summary>
		public string GetDisplayText() {
			if(Certificate == null) {
				return "Could not retrieve server certificate.\n\n" +
					(ErrorMessage ?? "The server may not have HTTPS configured.");
			}

			var sb = new System.Text.StringBuilder();
			sb.AppendLine("Server: " + HostName);
			sb.AppendLine("Subject: " + (Subject ?? "(unknown)"));
			sb.AppendLine("Issuer: " + (Issuer ?? "(unknown)"));
			sb.AppendLine("Thumbprint (SHA1): " + FormatThumbprint(Thumbprint));
			sb.AppendLine("Valid: " + ValidFrom.ToString("yyyy-MM-dd") + " to " + ValidTo.ToString("yyyy-MM-dd"));

			if(PolicyErrors != SslPolicyErrors.None) {
				sb.AppendLine();
				sb.AppendLine("Trust Errors:");
				if((PolicyErrors & SslPolicyErrors.RemoteCertificateChainErrors) != 0) {
					sb.AppendLine("  - The certificate chain is not trusted (self-signed or unknown CA).");
				}
				if((PolicyErrors & SslPolicyErrors.RemoteCertificateNameMismatch) != 0) {
					sb.AppendLine("  - The certificate name does not match the server hostname.");
				}
				if((PolicyErrors & SslPolicyErrors.RemoteCertificateNotAvailable) != 0) {
					sb.AppendLine("  - No certificate was provided by the server.");
				}
			}

			return sb.ToString();
		}

		private static string FormatThumbprint(string thumbprint) {
			if(string.IsNullOrWhiteSpace(thumbprint)) return "(none)";
			string clean = thumbprint.Replace(" ", "");
			var sb = new System.Text.StringBuilder();
			for(int i = 0; i < clean.Length; i += 2) {
				if(i > 0 && i % 8 == 0) sb.Append(' ');
				if(i + 1 < clean.Length) {
					sb.Append(clean.Substring(i, 2).ToUpperInvariant());
				}
				else {
					sb.Append(clean.Substring(i, 1).ToUpperInvariant());
				}
			}
			return sb.ToString();
		}
	}
}
