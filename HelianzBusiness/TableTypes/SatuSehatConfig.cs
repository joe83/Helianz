using System;

namespace HelianzBusiness {
	///<summary>Stores SatuSehat API credentials and integration configuration.</summary>
	[Serializable]
	public class SatuSehatConfig:TableBase {
		///<summary>Primary Key</summary>
		[CrudColumn(IsPriKey=true)]
		public long SatuSehatConfigNum;
		///<summary>OAuth2 Client ID from the SatuSehat/Kemkes developer platform.</summary>
		public string ClientId;
		///<summary>OAuth2 Client Secret. Should be encrypted at rest using SecurityHash.</summary>
		public string ClientSecret;
		///<summary>Organization IHS ID registered in SatuSehat for this clinic.</summary>
		public string OrganizationId;
		///<summary>Enum:SatuSehatEnvironment 0=Staging, 1=Production.</summary>
		[CrudColumn(SpecialType=CrudSpecialColType.EnumAsString)]
		public SatuSehatEnvironment Environment;
		///<summary>Cached OAuth2 access token. Refreshed automatically before expiry.</summary>
		[CrudColumn(SpecialType=CrudSpecialColType.IsText)]
		public string AccessToken;
		///<summary>UTC date and time when the cached AccessToken expires.</summary>
		[CrudColumn(SpecialType=CrudSpecialColType.DateT)]
		public DateTime TokenExpiresAt;
		///<summary>When true, SatuSehat sync is active.</summary>
		public bool IsEnabled;
		///<summary>Optional notes about this configuration.</summary>
		[CrudColumn(SpecialType=CrudSpecialColType.IsText)]
		public string Note;
		///<summary>SatuSehat Location IHS ID for the primary clinic location.  Used as Encounter.location reference.
		///If empty the sync will attempt to auto-fetch the first location registered under OrganizationId.</summary>
		public string LocationId;
		///<summary>Hostname of the client that currently holds the auto-sync lock. Empty when unlocked.</summary>
		public string SyncLockHost;
		///<summary>UTC time when the sync lock was acquired. Used to detect stale locks (older than 10 minutes).</summary>
		[CrudColumn(SpecialType=CrudSpecialColType.DateT)]
		public DateTime SyncLockAt;

		///<summary></summary>
		public SatuSehatConfig Copy() {
			return (SatuSehatConfig)this.MemberwiseClone();
		}
	}

	///<summary>SatuSehat API target environment.</summary>
	public enum SatuSehatEnvironment {
		///<summary>0 - Sandbox/Staging environment (api-satusehat-stg.dto.kemkes.go.id).</summary>
		Staging,
		///<summary>1 - Production environment (api-satusehat.kemkes.go.id).</summary>
		Production,
	}
}
