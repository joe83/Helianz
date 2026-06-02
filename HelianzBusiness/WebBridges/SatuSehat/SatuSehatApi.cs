using CodeBase;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;

namespace HelianzBusiness.WebBridges.SatuSehat {
	///<summary>Handles OAuth2 token acquisition and FHIR R4 REST calls to the SatuSehat (Kemkes) platform.</summary>
	public class SatuSehatApi {
		///<summary>Production base URL.</summary>
		private const string BASE_URL_PROD    ="https://api-satusehat.kemkes.go.id";
		///<summary>Staging/sandbox base URL.</summary>
		private const string BASE_URL_STAGING ="https://api-satusehat-stg.dto.kemkes.go.id";
		///<summary>Token endpoint path (appended to base URL).</summary>
		private const string TOKEN_PATH       ="/oauth2/v1/accesstoken?grant_type=client_credentials";
		///<summary>FHIR R4 base path.</summary>
		private const string FHIR_PATH        ="/fhir-r4/v1";
		///<summary>Buffer in seconds before expiry to trigger a proactive token refresh.</summary>
		private const int TOKEN_REFRESH_BUFFER_SECONDS=60;

		private readonly SatuSehatConfig _config;
		private static readonly HttpClient _httpClient=new HttpClient();

		///<summary>Initialises the API with the given config.  Call SatuSehatConfigs.GetOne() to obtain it.</summary>
		public SatuSehatApi(SatuSehatConfig config) {
			if(config==null) {
				throw new ArgumentNullException("config");
			}
			_config=config;
		}

		///<summary>Returns the base URL for the current environment.</summary>
		private string BaseUrl {
			get {
				return _config.Environment==SatuSehatEnvironment.Production ? BASE_URL_PROD : BASE_URL_STAGING;
			}
		}

		///<summary>Returns a valid access token, refreshing it from the auth server when needed.
		///Persists the new token back to the database so subsequent calls reuse it.</summary>
		public string GetAccessToken() {
			//Return cached token if it's still valid with buffer.
			if(!string.IsNullOrEmpty(_config.AccessToken)
				&& _config.TokenExpiresAt > DateTime.UtcNow.AddSeconds(TOKEN_REFRESH_BUFFER_SECONDS))
			{
				return _config.AccessToken;
			}
			//Fetch a new token.
			//SatuSehat expects client_id and client_secret in the POST body, not Basic auth.
			string tokenUrl=BaseUrl+TOKEN_PATH;
			HttpWebRequest request=(HttpWebRequest)WebRequest.Create(tokenUrl);
			request.Method="POST";
			request.ContentType="application/x-www-form-urlencoded";
			string bodyStr="client_id="+Uri.EscapeDataString(_config.ClientId)
				+"&client_secret="+Uri.EscapeDataString(_config.ClientSecret);
			byte[] bodyBytes=Encoding.UTF8.GetBytes(bodyStr);
			request.ContentLength=bodyBytes.Length;
			using(Stream stream=request.GetRequestStream()) {
				stream.Write(bodyBytes,0,bodyBytes.Length);
			}
			string responseJson=GetResponseString(request);
			JObject jObj=JObject.Parse(responseJson);
			string accessToken=(string)jObj["access_token"];
			int expiresIn=jObj["expires_in"]!=null ? (int)jObj["expires_in"] : 3600;
			DateTime expiresAt=DateTime.UtcNow.AddSeconds(expiresIn);
			if(string.IsNullOrEmpty(accessToken)) {
				throw new ODException("SatuSehat token response did not contain access_token.\r\nResponse: "+responseJson);
			}
			//Persist the new token.
			SatuSehatConfigs.UpdateToken(_config.SatuSehatConfigNum,accessToken,expiresAt);
			_config.AccessToken=accessToken;
			_config.TokenExpiresAt=expiresAt;
			return accessToken;
		}

		///<summary>Searches for a patient in SatuSehat using their NIK (national ID).
		///Returns the IHS Patient ID string, or empty string if no match found.</summary>
		public string SearchPatientByNik(string nik) {
			if(string.IsNullOrWhiteSpace(nik)) {
				return "";
			}
			string url=BaseUrl+FHIR_PATH+"/Patient?identifier=https://fhir.kemkes.go.id/id/nik%7C"+Uri.EscapeDataString(nik);
			string responseJson=FhirGet(url);
			JObject bundle=JObject.Parse(responseJson);
			int total=bundle["total"]!=null ? (int)bundle["total"] : 0;
			if(total==0) {
				return "";
			}
			JToken entry=bundle.SelectToken("entry[0].resource.id");
			return entry!=null ? entry.ToString() : "";
		}

		///<summary>Searches for a practitioner in SatuSehat using their NIK.
		///Returns the IHS Practitioner ID string, or empty string if no match found.</summary>
		public string SearchPractitionerByNik(string nik) {
			if(string.IsNullOrWhiteSpace(nik)) {
				return "";
			}
			string url=BaseUrl+FHIR_PATH+"/Practitioner?identifier=https://fhir.kemkes.go.id/id/nik%7C"+Uri.EscapeDataString(nik);
			string responseJson=FhirGet(url);
			JObject bundle=JObject.Parse(responseJson);
			JToken entry=bundle.SelectToken("entry[0].resource.id");
			return entry!=null ? entry.ToString() : "";
		}

		///<summary>Fetches the IHS ID of the first Location registered under the given Organization.
		///Tries both FHIR parameter names used by SatuSehat staging vs production.
		///Returns empty string if none found or on error.</summary>
		public string GetOrganizationFirstLocationId(string orgId) {
			if(string.IsNullOrWhiteSpace(orgId)) {
				return "";
			}
			//SatuSehat uses 'organization' with a plain ID (not a full reference).
			string[] paramNames=new string[] { "organization","managingOrganization" };
			foreach(string param in paramNames) {
				try {
					string url=BaseUrl+FHIR_PATH+"/Location?"+param+"="+Uri.EscapeDataString(orgId);
					string responseJson=FhirGet(url);
					JObject bundle=JObject.Parse(responseJson);
					JToken entry=bundle.SelectToken("entry[0].resource.id");
					if(entry!=null && !string.IsNullOrEmpty(entry.ToString())) {
						return entry.ToString();
					}
				}
				catch { }
			}
			return "";
		}

		///<summary>Creates a dental clinic Location resource under the given Organization on SatuSehat.
		///Called automatically during sync when no Location is configured and none is found via query.
		///Returns the IHS Location ID, or empty string on failure.</summary>
		public string CreateOrganizationLocation(string orgId) {
			var obj=new JObject {
				["resourceType"]="Location",
				["identifier"]=new JArray(new JObject {
					["system"]="http://sys-ids.kemkes.go.id/location/"+orgId,
					["value"]="poli-gigi"
				}),
				["status"]="active",
				["name"]="Poli Gigi",
				["mode"]="instance",
				["physicalType"]=new JObject {
					["coding"]=new JArray(new JObject {
						["system"]="http://terminology.hl7.org/CodeSystem/location-physical-type",
						["code"]="ro",
						["display"]="Room"
					})
				},
				["managingOrganization"]=new JObject { ["reference"]="Organization/"+orgId }
			};
			try {
				string responseJson=FhirSend(BaseUrl+FHIR_PATH+"/Location","POST",obj.ToString());
				JObject resource=JObject.Parse(responseJson);
				return resource["id"]!=null ? resource["id"].ToString() : "";
			}
			catch {
				return "";
			}
		}

		///<summary>Creates or updates a FHIR resource on SatuSehat.
		///<para>If ihsId is non-empty a PUT (update) is performed; otherwise a POST (create) is used.</para>
		///Returns the IHS resource ID assigned by SatuSehat.</summary>
		public string SendResource(string resourceType,string fhirJson,string ihsId="") {
			bool isUpdate=!string.IsNullOrEmpty(ihsId);
			string url=BaseUrl+FHIR_PATH+"/"+resourceType+(isUpdate ? "/"+ihsId : "");
			string method=isUpdate ? "PUT" : "POST";
			string responseJson=FhirSend(url,method,fhirJson);
			JObject resource=JObject.Parse(responseJson);
			string returnedId=resource["id"]!=null ? resource["id"].ToString() : "";
			if(string.IsNullOrEmpty(returnedId)) {
				throw new ODException("SatuSehat did not return a resource id for "+resourceType+".\r\nResponse: "+responseJson);
			}
			return returnedId;
		}

		///<summary>Performs a FHIR GET request with Bearer auth.  Returns the raw JSON response.</summary>
		private string FhirGet(string url) {
			string token=GetAccessToken();
			HttpWebRequest request=(HttpWebRequest)WebRequest.Create(url);
			request.Method="GET";
			request.Headers["Authorization"]="Bearer "+token;
			request.Accept="application/json";
			return GetResponseString(request);
		}

		///<summary>Performs a FHIR POST or PUT request with Bearer auth.  Returns the raw JSON response.</summary>
		private string FhirSend(string url,string method,string body) {
			string token=GetAccessToken();
			HttpWebRequest request=(HttpWebRequest)WebRequest.Create(url);
			request.Method=method;
			request.ContentType="application/json";
			request.Headers["Authorization"]="Bearer "+token;
			request.Accept="application/json";
			byte[] bodyBytes=Encoding.UTF8.GetBytes(body);
			request.ContentLength=bodyBytes.Length;
			using(Stream stream=request.GetRequestStream()) {
				stream.Write(bodyBytes,0,bodyBytes.Length);
			}
			return GetResponseString(request);
		}

		///<summary>Executes an HttpWebRequest and returns the response body as a string.
		///Throws ODException for HTTP error responses, including the raw body for diagnostics.</summary>
		private string GetResponseString(HttpWebRequest request) {
			try {
				using(HttpWebResponse response=(HttpWebResponse)request.GetResponse())
				using(StreamReader reader=new StreamReader(response.GetResponseStream(),Encoding.UTF8)) {
					return reader.ReadToEnd();
				}
			}
			catch(WebException wex) {
				string body="";
				if(wex.Response!=null) {
					using(StreamReader reader=new StreamReader(wex.Response.GetResponseStream(),Encoding.UTF8)) {
						body=reader.ReadToEnd();
					}
				}
				throw new ODException("SatuSehat API error: "+wex.Message+(string.IsNullOrEmpty(body) ? "" : "\r\nResponse: "+body),wex);
			}
		}
	}
}
