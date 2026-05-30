using System;
using System.ComponentModel;

namespace HelianzBusiness {
	///<summary>Tracks per-resource sync status between Helianz and SatuSehat (FHIR R4).</summary>
	[Serializable]
	public class SatuSehatStatus:TableBase {
		///<summary>Primary Key</summary>
		[CrudColumn(IsPriKey=true)]
		public long SatuSehatStatusNum;
		///<summary>FK to patient.PatNum. The patient this resource belongs to.</summary>
		public long PatNum;
		///<summary>Enum:SatuSehatResourceType FHIR resource type being synced.</summary>
		[CrudColumn(SpecialType=CrudSpecialColType.EnumAsString)]
		public SatuSehatResourceType ResourceType;
		///<summary>Primary key of the local source record (e.g. AptNum for Encounter, ProcNum for Procedure).</summary>
		public long LocalResourceId;
		///<summary>IHS resource ID returned by SatuSehat after a successful sync.</summary>
		public string IhsId;
		///<summary>Enum:SatuSehatSyncStatus Current sync state.</summary>
		[CrudColumn(SpecialType=CrudSpecialColType.EnumAsString)]
		public SatuSehatSyncStatus SyncStatus;
		///<summary>Date and time of the last successful sync. Zero if never synced.</summary>
		[CrudColumn(SpecialType=CrudSpecialColType.DateT)]
		public DateTime LastSyncAt;
		///<summary>Last error message when SyncStatus is Failed. Empty on success.</summary>
		[CrudColumn(SpecialType=CrudSpecialColType.IsText)]
		public string ErrorMessage;
		///<summary>Number of failed consecutive sync attempts. Reset to 0 on success. Used for back-off logic.</summary>
		public int RetryCount;
		///<summary>Date and time when this record was first inserted.</summary>
		[CrudColumn(SpecialType=CrudSpecialColType.DateT)]
		public DateTime DateTimeInsert;

		///<summary></summary>
		public SatuSehatStatus Copy() {
			return (SatuSehatStatus)this.MemberwiseClone();
		}
	}

	///<summary>FHIR R4 resource types used in SatuSehat sync.</summary>
	public enum SatuSehatResourceType {
		///<summary>0 - Patient demographic lookup (NIK → IHS ID).</summary>
		Patient,
		///<summary>1 - Clinical encounter (mapped from appointment).</summary>
		Encounter,
		///<summary>2 - Diagnosis condition (mapped from diagnosis).</summary>
		Condition,
		///<summary>3 - Dental procedure (mapped from completed procedure).</summary>
		Procedure,
		///<summary>4 - Observation/vital sign.</summary>
		Observation,
	}

	///<summary>Sync lifecycle state for a SatuSehat resource record.</summary>
	public enum SatuSehatSyncStatus {
		///<summary>0 - Queued, waiting to be synced.</summary>
		[Description("Pending")]
		Pending,
		///<summary>1 - Successfully synced to SatuSehat.</summary>
		[Description("Synced")]
		Synced,
		///<summary>2 - Sync failed; will be retried up to the retry limit.</summary>
		[Description("Failed")]
		Failed,
		///<summary>3 - Intentionally skipped (e.g. missing NIK or incomplete data).</summary>
		[Description("Skipped")]
		Skipped,
	}
}
