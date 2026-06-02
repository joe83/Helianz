using System;
using System.Collections.Generic;
using System.Data;
using System.Reflection;

namespace HelianzBusiness {
	///<summary>Data access layer for satusehatstatus table.</summary>
	public class SatuSehatStatuses {
		///<summary>Maximum number of retry attempts before a record is permanently skipped.</summary>
		public const int MAX_RETRY_COUNT=5;

		#region Get Methods

		///<summary>Returns all pending or previously failed records that are eligible for retry, ordered oldest-first.
		///Records with RetryCount >= MAX_RETRY_COUNT are excluded.</summary>
		public static List<SatuSehatStatus> GetPendingQueue(int maxBatch=50) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				return Meth.GetObject<List<SatuSehatStatus>>(MethodBase.GetCurrentMethod(),maxBatch);
			}
			string command="SELECT * FROM satusehatstatus "
				+"WHERE SyncStatus IN ('"+POut.String(SatuSehatSyncStatus.Pending.ToString())+"','"+POut.String(SatuSehatSyncStatus.Failed.ToString())+"') "
				+"AND RetryCount < "+POut.Int(MAX_RETRY_COUNT)+" "
			//Patient rows must come before their dependent resources (Encounter, Procedure, etc.) so the IHS ID
			//is resolved before dependents are processed in the same batch.
			+"ORDER BY CASE ResourceType WHEN 'Patient' THEN 0 WHEN 'Encounter' THEN 1 WHEN 'Condition' THEN 2 ELSE 3 END ASC, DateTimeInsert ASC "
				+"LIMIT "+POut.Int(maxBatch);
			return Crud.SatuSehatStatusCrud.SelectMany(command);
		}

		///<summary>Returns all status rows for a given patient.</summary>
		public static List<SatuSehatStatus> GetForPatient(long patNum) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				return Meth.GetObject<List<SatuSehatStatus>>(MethodBase.GetCurrentMethod(),patNum);
			}
			string command="SELECT * FROM satusehatstatus "
				+"WHERE PatNum="+POut.Long(patNum)+" "
				+"ORDER BY DateTimeInsert DESC";
			return Crud.SatuSehatStatusCrud.SelectMany(command);
		}

		///<summary>Returns the existing status row for a specific resource, or null if none exists.</summary>
		public static SatuSehatStatus GetForResource(long patNum,SatuSehatResourceType resourceType,long localResourceId) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				return Meth.GetObject<SatuSehatStatus>(MethodBase.GetCurrentMethod(),patNum,resourceType,localResourceId);
			}
			string command="SELECT * FROM satusehatstatus "
				+"WHERE PatNum="+POut.Long(patNum)+" "
				+"AND ResourceType='"+POut.String(resourceType.ToString())+"' "
				+"AND LocalResourceId="+POut.Long(localResourceId)+" "
				+"LIMIT 1";
			return Crud.SatuSehatStatusCrud.SelectOne(command);
		}

		///<summary>Returns all status rows with a paged result for the status grid.</summary>
		public static List<SatuSehatStatus> GetPage(int pageIndex,int pageSize=100) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				return Meth.GetObject<List<SatuSehatStatus>>(MethodBase.GetCurrentMethod(),pageIndex,pageSize);
			}
			string command="SELECT * FROM satusehatstatus "
				+"ORDER BY DateTimeInsert DESC "
				+"LIMIT "+POut.Int(pageSize)+" OFFSET "+POut.Int(pageIndex*pageSize);
			return Crud.SatuSehatStatusCrud.SelectMany(command);
		}

		///<summary>Returns a count per SyncStatus for display in the stats bar.</summary>
		public static SatuSehatSyncStats GetSyncStats() {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				return Meth.GetObject<SatuSehatSyncStats>(MethodBase.GetCurrentMethod());
			}
			string command="SELECT SyncStatus,COUNT(*) cnt FROM satusehatstatus GROUP BY SyncStatus";
			DataTable table=Db.GetTable(command);
			SatuSehatSyncStats stats=new SatuSehatSyncStats();
			foreach(DataRow row in table.Rows) {
				int count=PIn.Int(row["cnt"].ToString());
				string status=row["SyncStatus"].ToString();
				if(status==SatuSehatSyncStatus.Pending.ToString()) { stats.Pending=count; }
				else if(status==SatuSehatSyncStatus.Synced.ToString())  { stats.Synced=count;  }
				else if(status==SatuSehatSyncStatus.Failed.ToString())  { stats.Failed=count;  }
				else if(status==SatuSehatSyncStatus.Skipped.ToString()) { stats.Skipped=count; }
			}
			return stats;
		}

		#endregion Get Methods

		#region Insert

		///<summary>Inserts a new SatuSehatStatus row and sets DateTimeInsert to now.</summary>
		public static long Insert(SatuSehatStatus satuSehatStatus) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				satuSehatStatus.SatuSehatStatusNum=Meth.GetLong(MethodBase.GetCurrentMethod(),satuSehatStatus);
				return satuSehatStatus.SatuSehatStatusNum;
			}
			satuSehatStatus.DateTimeInsert=DateTime.Now;
			return Crud.SatuSehatStatusCrud.Insert(satuSehatStatus);
		}

		#endregion Insert

		#region Update

		///<summary>Updates an existing SatuSehatStatus row using old/new comparison.</summary>
		public static void Update(SatuSehatStatus satuSehatStatus,SatuSehatStatus satuSehatStatusOld) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				Meth.GetVoid(MethodBase.GetCurrentMethod(),satuSehatStatus,satuSehatStatusOld);
				return;
			}
			Crud.SatuSehatStatusCrud.Update(satuSehatStatus,satuSehatStatusOld);
		}

		///<summary>Enqueues a resource for sync. If a row already exists for this resource it is reset to Pending;
		///otherwise a new row is inserted. Call this from trigger points (appointment complete, procedure complete, etc.).</summary>
		public static void Enqueue(long patNum,SatuSehatResourceType resourceType,long localResourceId) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				Meth.GetVoid(MethodBase.GetCurrentMethod(),patNum,resourceType,localResourceId);
				return;
			}
			SatuSehatStatus existing=GetForResource(patNum,resourceType,localResourceId);
			if(existing==null) {
				SatuSehatStatus satuSehatStatus=new SatuSehatStatus();
				satuSehatStatus.PatNum=patNum;
				satuSehatStatus.ResourceType=resourceType;
				satuSehatStatus.LocalResourceId=localResourceId;
				satuSehatStatus.SyncStatus=SatuSehatSyncStatus.Pending;
				satuSehatStatus.RetryCount=0;
				Insert(satuSehatStatus);
			}
			else {
				SatuSehatStatus old=existing.Copy();
				existing.SyncStatus=SatuSehatSyncStatus.Pending;
				existing.RetryCount=0;
				existing.ErrorMessage="";
				Crud.SatuSehatStatusCrud.Update(existing,old);
			}
		}

		///<summary>Marks a sync as successful, storing the returned IHS resource ID.</summary>
		public static void MarkSynced(long satuSehatStatusNum,string ihsId) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				Meth.GetVoid(MethodBase.GetCurrentMethod(),satuSehatStatusNum,ihsId);
				return;
			}
			string command="UPDATE satusehatstatus SET "
				+"SyncStatus='"+POut.String(SatuSehatSyncStatus.Synced.ToString())+"', "
				+"IhsId='"+POut.String(ihsId)+"', "
				+"LastSyncAt="+POut.DateT(DateTime.Now)+", "
				+"ErrorMessage='', "
				+"RetryCount=0 "
				+"WHERE SatuSehatStatusNum="+POut.Long(satuSehatStatusNum);
			Db.NonQ(command);
		}

		///<summary>Increments RetryCount and records the error. Marks as Failed unless retry limit reached, in which case marks Skipped.</summary>
		public static void MarkFailed(long satuSehatStatusNum,string errorMessage) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				Meth.GetVoid(MethodBase.GetCurrentMethod(),satuSehatStatusNum,errorMessage);
				return;
			}
			//Read current RetryCount first.
			SatuSehatStatus current=Crud.SatuSehatStatusCrud.SelectOne(satuSehatStatusNum);
			if(current==null) {
				return;
			}
			int newRetry=current.RetryCount+1;
			string newStatus=newRetry>=MAX_RETRY_COUNT
				? POut.String(SatuSehatSyncStatus.Skipped.ToString())
				: POut.String(SatuSehatSyncStatus.Failed.ToString());
			string command="UPDATE satusehatstatus SET "
				+"SyncStatus='"+newStatus+"', "
				+"ErrorMessage='"+POut.String(errorMessage)+"', "
				+"RetryCount="+POut.Int(newRetry)+" "
				+"WHERE SatuSehatStatusNum="+POut.Long(satuSehatStatusNum);
			Db.NonQ(command);
		}

		#endregion Update

		#region Delete

		///<summary>Deletes a SatuSehatStatus row by primary key.</summary>
		public static void Delete(long satuSehatStatusNum) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				Meth.GetVoid(MethodBase.GetCurrentMethod(),satuSehatStatusNum);
				return;
			}
			Crud.SatuSehatStatusCrud.Delete(satuSehatStatusNum);
		}

		///<summary>Deletes all status rows for a patient.</summary>
		public static void DeleteForPatient(long patNum) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				Meth.GetVoid(MethodBase.GetCurrentMethod(),patNum);
				return;
			}
			string command="DELETE FROM satusehatstatus WHERE PatNum="+POut.Long(patNum);
			Db.NonQ(command);
		}

		#endregion Delete
	}
}
