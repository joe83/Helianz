using System;
using System.Collections.Generic;
using System.Data;
using System.Reflection;

namespace HelianzBusiness {
	///<summary>Data access layer for satusehatconfig table.</summary>
	public class SatuSehatConfigs {
		#region Get Methods

		///<summary>Returns the first (and typically only) SatuSehatConfig row, or null if none exists.</summary>
		public static SatuSehatConfig GetOne() {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				return Meth.GetObject<SatuSehatConfig>(MethodBase.GetCurrentMethod());
			}
			string command="SELECT * FROM satusehatconfig LIMIT 1";
			return Crud.SatuSehatConfigCrud.SelectOne(command);
		}

		///<summary>Returns a list of all SatuSehatConfig rows.</summary>
		public static List<SatuSehatConfig> GetAll() {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				return Meth.GetObject<List<SatuSehatConfig>>(MethodBase.GetCurrentMethod());
			}
			string command="SELECT * FROM satusehatconfig";
			return Crud.SatuSehatConfigCrud.SelectMany(command);
		}

		#endregion Get Methods

		#region Insert

		///<summary>Inserts a new SatuSehatConfig row.</summary>
		public static long Insert(SatuSehatConfig satuSehatConfig) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				satuSehatConfig.SatuSehatConfigNum=Meth.GetLong(MethodBase.GetCurrentMethod(),satuSehatConfig);
				return satuSehatConfig.SatuSehatConfigNum;
			}
			return Crud.SatuSehatConfigCrud.Insert(satuSehatConfig);
		}

		#endregion Insert

		#region Update

		///<summary>Updates an existing SatuSehatConfig row using old/new comparison to minimise DB writes.</summary>
		public static void Update(SatuSehatConfig satuSehatConfig,SatuSehatConfig satuSehatConfigOld) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				Meth.GetVoid(MethodBase.GetCurrentMethod(),satuSehatConfig,satuSehatConfigOld);
				return;
			}
			Crud.SatuSehatConfigCrud.Update(satuSehatConfig,satuSehatConfigOld);
		}

		///<summary>Clears the cached access token and expiry so the next sync call will re-authenticate.</summary>
		public static void ClearToken(long satuSehatConfigNum) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				Meth.GetVoid(MethodBase.GetCurrentMethod(),satuSehatConfigNum);
				return;
			}
			string command="UPDATE satusehatconfig SET AccessToken='', TokenExpiresAt="+POut.DateT(DateTime.MinValue)+" "
				+"WHERE SatuSehatConfigNum="+POut.Long(satuSehatConfigNum);
			Db.NonQ(command);
		}

		///<summary>Saves a refreshed access token and its expiry time back to the config row.</summary>
		public static void UpdateToken(long satuSehatConfigNum,string accessToken,DateTime tokenExpiresAt) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				Meth.GetVoid(MethodBase.GetCurrentMethod(),satuSehatConfigNum,accessToken,tokenExpiresAt);
				return;
			}
			string command="UPDATE satusehatconfig SET "
				+"AccessToken='"+POut.String(accessToken)+"', "
				+"TokenExpiresAt="+POut.DateT(tokenExpiresAt)+" "
				+"WHERE SatuSehatConfigNum="+POut.Long(satuSehatConfigNum);
			Db.NonQ(command);
		}

		///<summary>Caches the resolved Location IHS ID back to the config row so subsequent syncs skip the API lookup.</summary>
		public static void UpdateLocationId(long satuSehatConfigNum,string locationId) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				Meth.GetVoid(MethodBase.GetCurrentMethod(),satuSehatConfigNum,locationId);
				return;
			}
			string command="UPDATE satusehatconfig SET "
				+"LocationId='"+POut.String(locationId)+"' "
				+"WHERE SatuSehatConfigNum="+POut.Long(satuSehatConfigNum);
			Db.NonQ(command);
		}

		#endregion Update

		#region Delete

		///<summary>Deletes a SatuSehatConfig row by primary key.</summary>
		public static void Delete(long satuSehatConfigNum) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				Meth.GetVoid(MethodBase.GetCurrentMethod(),satuSehatConfigNum);
				return;
			}
			Crud.SatuSehatConfigCrud.Delete(satuSehatConfigNum);
		}

		#endregion Delete

		#region Sync Lock

		///<summary>Tries to atomically acquire the auto-sync lock for the given config row.
		///Returns true if this client now holds the lock; false if another client holds a fresh lock.
		///A lock older than 10 minutes is treated as stale and can be stolen.</summary>
		public static bool TryAcquireSyncLock(long satuSehatConfigNum,string hostName) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				return Meth.GetBool(MethodBase.GetCurrentMethod(),satuSehatConfigNum,hostName);
			}
			//Atomic conditional UPDATE: succeeds only when the lock is unclaimed or stale (>10 min old).
			string command="UPDATE satusehatconfig SET "
				+"SyncLockHost='"+POut.String(hostName)+"', "
				+"SyncLockAt=NOW() "
				+"WHERE SatuSehatConfigNum="+POut.Long(satuSehatConfigNum)+" "
				+"AND (SyncLockHost='' OR SyncLockAt < DATE_SUB(NOW(), INTERVAL 10 MINUTE))";
			long rowsAffected=Db.NonQ(command);
			return rowsAffected>0;
		}

		///<summary>Releases the auto-sync lock so other clients can acquire it.</summary>
		public static void ReleaseSyncLock(long satuSehatConfigNum) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				Meth.GetVoid(MethodBase.GetCurrentMethod(),satuSehatConfigNum);
				return;
			}
			string command="UPDATE satusehatconfig SET SyncLockHost='', SyncLockAt="+POut.DateT(DateTime.MinValue)+" "
				+"WHERE SatuSehatConfigNum="+POut.Long(satuSehatConfigNum);
			Db.NonQ(command);
		}

		#endregion Sync Lock
	}

	///<summary>Summary counts of sync queue rows by status. Returned by SatuSehatStatuses.GetSyncStats().</summary>
	[Serializable]
	public class SatuSehatSyncStats {
		public int Pending;
		public int Synced;
		public int Failed;
		public int Skipped;
	}
}
