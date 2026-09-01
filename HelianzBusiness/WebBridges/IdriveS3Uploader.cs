using System;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using CodeBase;

namespace HelianzBusiness {
	/// <summary>
	/// Standalone AWS Signature Version 4 (SigV4) S3 uploader and presigned URL generator.
	/// Fully compatible with IDrive e2, AWS S3, Cloudflare R2, MinIO, Wasabi, and all S3-compatible cloud storage.
	/// Uses standard .NET cryptography with zero external DLL dependencies.
	/// </summary>
	public static class IdriveS3Uploader {
		private static readonly HttpClient _httpClient = new HttpClient();

		/// <summary>
		/// Uploads a local PDF statement to the configured IDrive / S3 bucket and returns the direct online download link.
		/// </summary>
		public static async System.Threading.Tasks.Task<string> UploadStatementPdfAsync(string localPdfPath, string patientName, long statementNum) {
			if(!PrefC.GetBoolSilent(PrefName.IdriveS3Enabled, false)) {
				throw new Exception("IDrive S3 is not enabled in preferences.");
			}

			string endpoint = PrefC.GetStringSilent(PrefName.IdriveS3Endpoint)?.Trim();
			string bucket = PrefC.GetStringSilent(PrefName.IdriveS3BucketName)?.Trim();
			string accessKey = PrefC.GetStringSilent(PrefName.IdriveS3AccessKey)?.Trim();
			string secretKey = PrefC.GetStringSilent(PrefName.IdriveS3SecretKey)?.Trim();
			string region = PrefC.GetStringSilent(PrefName.IdriveS3Region)?.Trim();
			string publicUrl = PrefC.GetStringSilent(PrefName.IdriveS3PublicUrl)?.Trim();
			int expiresDays = PrefC.GetIntSilent(PrefName.IdriveS3ExpiresDays, 7);
			if(expiresDays <= 0 || expiresDays > 7) {
				expiresDays = 7; // S3 SigV4 strictly limits presigned URL expiry to max 7 days (604800 seconds)
			}
			if(string.IsNullOrWhiteSpace(region)) {
				region = "us-east-1";
			}

			if(string.IsNullOrWhiteSpace(endpoint) || string.IsNullOrWhiteSpace(bucket) || string.IsNullOrWhiteSpace(accessKey) || string.IsNullOrWhiteSpace(secretKey)) {
				throw new Exception("IDrive S3 credentials (Endpoint, Bucket, Access Key, Secret Key) are not fully configured.");
			}

			if(!File.Exists(localPdfPath)) {
				throw new FileNotFoundException("Local PDF file does not exist: " + localPdfPath);
			}

			byte[] fileBytes = File.ReadAllBytes(localPdfPath);

			// Format object key: statements/202609/stmt_12345_a1b2c3d4.pdf
			string randomSuffix = Guid.NewGuid().ToString("N").Substring(0, 8);
			string s3Key = $"statements/{DateTime.Today:yyyyMM}/stmt_{statementNum}_{randomSuffix}.pdf";

			await PutObjectAsync(endpoint, bucket, s3Key, fileBytes, "application/pdf", accessKey, secretKey, region);

			string finalUrl = "";
			// If a custom public domain is provided, return that URL
			if(!string.IsNullOrWhiteSpace(publicUrl)) {
				finalUrl = $"{publicUrl.TrimEnd('/')}/{s3Key.TrimStart('/')}";
			}
			else {
				// Otherwise return Presigned URL (clamped to max 7 days)
				finalUrl = GeneratePresignedGetUrl(endpoint, bucket, s3Key, accessKey, secretKey, region, TimeSpan.FromDays(expiresDays));
			}

			// Automatically shorten URL if enabled in preferences (default true)
			if(PrefC.GetBoolSilent(PrefName.IdriveS3UseShortLink, true)) {
				finalUrl = await ShortenUrlAsync(finalUrl);
			}

			return finalUrl;
		}

		/// <summary>
		/// Shortens a URL using public shortener services (TinyURL / is.gd) with automatic fallback to original URL.
		/// </summary>
		public static async System.Threading.Tasks.Task<string> ShortenUrlAsync(string longUrl) {
			if(string.IsNullOrWhiteSpace(longUrl)) {
				return longUrl;
			}
			try {
				string requestUrl = $"https://tinyurl.com/api-create.php?url={Uri.EscapeDataString(longUrl)}";
				using HttpResponseMessage response = await _httpClient.GetAsync(requestUrl);
				if(response.IsSuccessStatusCode) {
					string shortUrl = (await response.Content.ReadAsStringAsync())?.Trim();
					if(!string.IsNullOrWhiteSpace(shortUrl) && shortUrl.StartsWith("http", StringComparison.OrdinalIgnoreCase)) {
						return shortUrl;
					}
				}
			}
			catch { }

			try {
				string requestUrl = $"https://is.gd/create.php?format=simple&url={Uri.EscapeDataString(longUrl)}";
				using HttpResponseMessage response = await _httpClient.GetAsync(requestUrl);
				if(response.IsSuccessStatusCode) {
					string shortUrl = (await response.Content.ReadAsStringAsync())?.Trim();
					if(!string.IsNullOrWhiteSpace(shortUrl) && shortUrl.StartsWith("http", StringComparison.OrdinalIgnoreCase)) {
						return shortUrl;
					}
				}
			}
			catch { }

			return longUrl;
		}

		/// <summary>
		/// Tests IDrive S3 credentials by uploading and deleting a test file.
		/// </summary>
		public static async System.Threading.Tasks.Task<bool> TestConnectionAsync(string endpoint, string bucket, string accessKey, string secretKey, string region) {
			if(string.IsNullOrWhiteSpace(region)) {
				region = "us-east-1";
			}
			string testKey = $"test_connection_{Guid.NewGuid():N}.txt";
			byte[] testBytes = Encoding.UTF8.GetBytes("Helianz IDrive S3 Connection Test - " + DateTime.UtcNow.ToString("O"));

			await PutObjectAsync(endpoint, bucket, testKey, testBytes, "text/plain", accessKey, secretKey, region);
			await DeleteObjectAsync(endpoint, bucket, testKey, accessKey, secretKey, region);
			return true;
		}

		#region Core S3 SigV4 Methods

		private static Uri BuildBucketUri(string endpoint, string bucket, string key) {
			endpoint = endpoint.Trim().TrimEnd('/');
			if(!endpoint.StartsWith("http://", StringComparison.OrdinalIgnoreCase) && !endpoint.StartsWith("https://", StringComparison.OrdinalIgnoreCase)) {
				endpoint = "https://" + endpoint;
			}
			Uri baseUri = new Uri(endpoint);
			string path = $"/{bucket.Trim()}/{key.TrimStart('/')}";
			return new Uri(baseUri, path);
		}

		private static async System.Threading.Tasks.Task PutObjectAsync(string endpoint, string bucket, string key, byte[] content, string contentType, string accessKey, string secretKey, string region) {
			Uri requestUri = BuildBucketUri(endpoint, bucket, key);
			DateTime now = DateTime.UtcNow;
			string amzDate = now.ToString("yyyyMMddTHHmmssZ", CultureInfo.InvariantCulture);
			string dateStamp = now.ToString("yyyyMMdd", CultureInfo.InvariantCulture);

			byte[] payloadHashBytes = SHA256.Create().ComputeHash(content);
			string payloadHash = ToHexString(payloadHashBytes);

			using HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Put, requestUri);
			request.Content = new ByteArrayContent(content);
			request.Content.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue(contentType);

			request.Headers.Host = requestUri.Authority;
			request.Headers.Add("x-amz-date", amzDate);
			request.Headers.Add("x-amz-content-sha256", payloadHash);

			// SigV4 Canonical Request
			string canonicalUri = requestUri.AbsolutePath;
			string canonicalQuery = "";
			string canonicalHeaders = $"host:{requestUri.Authority}\nx-amz-content-sha256:{payloadHash}\nx-amz-date:{amzDate}\n";
			string signedHeaders = "host;x-amz-content-sha256;x-amz-date";

			string canonicalRequest = $"PUT\n{canonicalUri}\n{canonicalQuery}\n{canonicalHeaders}\n{signedHeaders}\n{payloadHash}";
			string stringToSign = $"AWS4-HMAC-SHA256\n{amzDate}\n{dateStamp}/{region}/s3/aws4_request\n{ToHexString(SHA256.Create().ComputeHash(Encoding.UTF8.GetBytes(canonicalRequest)))}";

			byte[] signingKey = GetSignatureKey(secretKey, dateStamp, region, "s3");
			byte[] signatureBytes = HmacSha256(signingKey, stringToSign);
			string signature = ToHexString(signatureBytes);

			string authHeader = $"AWS4-HMAC-SHA256 Credential={accessKey}/{dateStamp}/{region}/s3/aws4_request, SignedHeaders={signedHeaders}, Signature={signature}";
			request.Headers.TryAddWithoutValidation("Authorization", authHeader);

			using HttpResponseMessage response = await _httpClient.SendAsync(request);
			if(!response.IsSuccessStatusCode) {
				string errContent = await response.Content.ReadAsStringAsync();
				throw new Exception($"S3 Upload failed (HTTP {(int)response.StatusCode} {response.ReasonPhrase}): {errContent}");
			}
		}

		private static async System.Threading.Tasks.Task DeleteObjectAsync(string endpoint, string bucket, string key, string accessKey, string secretKey, string region) {
			Uri requestUri = BuildBucketUri(endpoint, bucket, key);
			DateTime now = DateTime.UtcNow;
			string amzDate = now.ToString("yyyyMMddTHHmmssZ", CultureInfo.InvariantCulture);
			string dateStamp = now.ToString("yyyyMMdd", CultureInfo.InvariantCulture);

			byte[] payloadHashBytes = SHA256.Create().ComputeHash(new byte[0]);
			string payloadHash = ToHexString(payloadHashBytes);

			using HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Delete, requestUri);
			request.Headers.Host = requestUri.Authority;
			request.Headers.Add("x-amz-date", amzDate);
			request.Headers.Add("x-amz-content-sha256", payloadHash);

			string canonicalUri = requestUri.AbsolutePath;
			string canonicalQuery = "";
			string canonicalHeaders = $"host:{requestUri.Authority}\nx-amz-content-sha256:{payloadHash}\nx-amz-date:{amzDate}\n";
			string signedHeaders = "host;x-amz-content-sha256;x-amz-date";

			string canonicalRequest = $"DELETE\n{canonicalUri}\n{canonicalQuery}\n{canonicalHeaders}\n{signedHeaders}\n{payloadHash}";
			string stringToSign = $"AWS4-HMAC-SHA256\n{amzDate}\n{dateStamp}/{region}/s3/aws4_request\n{ToHexString(SHA256.Create().ComputeHash(Encoding.UTF8.GetBytes(canonicalRequest)))}";

			byte[] signingKey = GetSignatureKey(secretKey, dateStamp, region, "s3");
			byte[] signatureBytes = HmacSha256(signingKey, stringToSign);
			string signature = ToHexString(signatureBytes);

			string authHeader = $"AWS4-HMAC-SHA256 Credential={accessKey}/{dateStamp}/{region}/s3/aws4_request, SignedHeaders={signedHeaders}, Signature={signature}";
			request.Headers.TryAddWithoutValidation("Authorization", authHeader);

			using HttpResponseMessage response = await _httpClient.SendAsync(request);
			if(!response.IsSuccessStatusCode && response.StatusCode != HttpStatusCode.NotFound) {
				string errContent = await response.Content.ReadAsStringAsync();
				throw new Exception($"S3 Delete failed (HTTP {(int)response.StatusCode} {response.ReasonPhrase}): {errContent}");
			}
		}

		public static string GeneratePresignedGetUrl(string endpoint, string bucket, string key, string accessKey, string secretKey, string region, TimeSpan validity) {
			Uri requestUri = BuildBucketUri(endpoint, bucket, key);
			DateTime now = DateTime.UtcNow;
			string amzDate = now.ToString("yyyyMMddTHHmmssZ", CultureInfo.InvariantCulture);
			string dateStamp = now.ToString("yyyyMMdd", CultureInfo.InvariantCulture);
			long expiresSeconds = (long)validity.TotalSeconds;
			if(expiresSeconds <= 0 || expiresSeconds > 604800) {
				expiresSeconds = 604800; // max 7 days (604800 seconds) allowed by S3 SigV4 specification
			}

			string credentialParam = $"{accessKey}/{dateStamp}/{region}/s3/aws4_request";
			string signedHeaders = "host";

			// Presigned Query Parameters in alphabetical order
			string queryParams = $"X-Amz-Algorithm=AWS4-HMAC-SHA256" +
				$"&X-Amz-Credential={Uri.EscapeDataString(credentialParam)}" +
				$"&X-Amz-Date={amzDate}" +
				$"&X-Amz-Expires={expiresSeconds}" +
				$"&X-Amz-SignedHeaders={signedHeaders}";

			string canonicalUri = requestUri.AbsolutePath;
			string canonicalHeaders = $"host:{requestUri.Authority}\n";
			string payloadHash = "UNSIGNED-PAYLOAD";

			string canonicalRequest = $"GET\n{canonicalUri}\n{queryParams}\n{canonicalHeaders}\n{signedHeaders}\n{payloadHash}";
			string stringToSign = $"AWS4-HMAC-SHA256\n{amzDate}\n{dateStamp}/{region}/s3/aws4_request\n{ToHexString(SHA256.Create().ComputeHash(Encoding.UTF8.GetBytes(canonicalRequest)))}";

			byte[] signingKey = GetSignatureKey(secretKey, dateStamp, region, "s3");
			byte[] signatureBytes = HmacSha256(signingKey, stringToSign);
			string signature = ToHexString(signatureBytes);

			return $"{requestUri.Scheme}://{requestUri.Authority}{canonicalUri}?{queryParams}&X-Amz-Signature={signature}";
		}

		private static byte[] GetSignatureKey(string key, string dateStamp, string regionName, string serviceName) {
			byte[] kSecret = Encoding.UTF8.GetBytes("AWS4" + key);
			byte[] kDate = HmacSha256(kSecret, dateStamp);
			byte[] kRegion = HmacSha256(kDate, regionName);
			byte[] kService = HmacSha256(kRegion, serviceName);
			return HmacSha256(kService, "aws4_request");
		}

		private static byte[] HmacSha256(byte[] key, string data) {
			using HMACSHA256 hmac = new HMACSHA256(key);
			return hmac.ComputeHash(Encoding.UTF8.GetBytes(data));
		}

		private static string ToHexString(byte[] bytes) {
			StringBuilder sb = new StringBuilder(bytes.Length * 2);
			foreach(byte b in bytes) {
				sb.Append(b.ToString("x2"));
			}
			return sb.ToString();
		}

		#endregion
	}
}
