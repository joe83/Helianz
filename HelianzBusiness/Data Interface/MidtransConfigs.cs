using System;
using System.Collections.Generic;
using System.Data;
using System.Reflection;
using System.Text;

namespace HelianzBusiness {
	///<summary>Data interface for MidtransConfig table. Stores Midtrans payment gateway credentials per clinic.</summary>
	public class MidtransConfigs {
		///<summary>Set to true once EnsureTables has run successfully for this process lifetime.</summary>
		private static bool _tablesVerified=false;

		#region Misc
		///<summary>Safety-net fallback: creates the Midtrans tables if they were not already created by the
		///To24_3_48 migration (e.g. existing DB that skipped startup migration). Runs at most once per session.</summary>
		public static void EnsureTables() {
			if(_tablesVerified) {
				return;
			}
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				Meth.GetVoid(MethodBase.GetCurrentMethod());
				_tablesVerified=true;
				return;
			}
			Db.NonQ(@"CREATE TABLE IF NOT EXISTS midtransconfig (
				MidtransConfigNum bigint NOT NULL auto_increment PRIMARY KEY,
				ServerKey varchar(255) NOT NULL DEFAULT '',
				ClientKey varchar(255) NOT NULL DEFAULT '',
				Environment varchar(64) NOT NULL DEFAULT 'Sandbox',
				IsEnabled tinyint(1) NOT NULL DEFAULT 0,
				ClinicNum bigint NOT NULL DEFAULT 0,
				MerchantName varchar(255) NOT NULL DEFAULT '',
				PayTypeDefNum bigint NOT NULL DEFAULT 0,
				Note text NOT NULL
			) DEFAULT CHARSET=utf8mb4");
			//Add PayTypeDefNum to midtransconfig if it was created by an older EnsureTables (pre-24.3.49)
			string countCmd="SELECT COUNT(*) FROM information_schema.COLUMNS "
				+"WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='midtransconfig' AND COLUMN_NAME='PayTypeDefNum'";
			if(Db.GetScalar(countCmd)=="0") {
				Db.NonQ("ALTER TABLE midtransconfig ADD PayTypeDefNum bigint NOT NULL DEFAULT 0");
			}
			Db.NonQ(@"CREATE TABLE IF NOT EXISTS midtranstransaction (
				MidtransTransactionNum bigint NOT NULL auto_increment PRIMARY KEY,
				PatNum bigint NOT NULL DEFAULT 0,
				PayNum bigint NOT NULL DEFAULT 0,
				OrderId varchar(255) NOT NULL DEFAULT '',
				TransactionId varchar(255) NOT NULL DEFAULT '',
				PaymentType varchar(64) NOT NULL DEFAULT '',
				GrossAmount bigint NOT NULL DEFAULT 0,
				QrCodeUrl text NOT NULL,
				StatusUrl text NOT NULL,
				TransactionStatus varchar(64) NOT NULL DEFAULT 'Created',
				LastResponseJson text NOT NULL,
				DateTimeCreated datetime NOT NULL DEFAULT '0001-01-01 00:00:00',
				DateTimeSettled datetime NOT NULL DEFAULT '0001-01-01 00:00:00',
				ClinicNum bigint NOT NULL DEFAULT 0,
				PayNote text NOT NULL
			) DEFAULT CHARSET=utf8mb4");
			_tablesVerified=true;
		}
		#endregion Misc

		#region Get Methods
		///<summary>Gets all MidtransConfig objects from the database.</summary>
		public static List<MidtransConfig> GetAll() {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				return Meth.GetObject<List<MidtransConfig>>(MethodBase.GetCurrentMethod());
			}
			return Crud.MidtransConfigCrud.SelectMany("SELECT * FROM midtransconfig");
		}

		///<summary>Gets the MidtransConfig for the given clinic. Falls back to clinic 0 if not found. Returns null if neither exists.</summary>
		public static MidtransConfig GetForClinic(long clinicNum) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				return Meth.GetObject<MidtransConfig>(MethodBase.GetCurrentMethod(),clinicNum);
			}
			string command="SELECT * FROM midtransconfig WHERE ClinicNum="+POut.Long(clinicNum);
			MidtransConfig config=Crud.MidtransConfigCrud.SelectOne(command);
			if(config!=null) {
				return config;
			}
			if(clinicNum!=0) {
				//Fall back to the default (non-clinic) config
				command="SELECT * FROM midtransconfig WHERE ClinicNum=0";
				config=Crud.MidtransConfigCrud.SelectOne(command);
			}
			return config;
		}

		///<summary>Gets one MidtransConfig from the database by its primary key. Returns null if not found.</summary>
		public static MidtransConfig GetOne(long midtransConfigNum) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				return Meth.GetObject<MidtransConfig>(MethodBase.GetCurrentMethod(),midtransConfigNum);
			}
			return Crud.MidtransConfigCrud.SelectOne(midtransConfigNum);
		}
		#endregion Get Methods

		#region Insert
		///<summary></summary>
		public static long Insert(MidtransConfig midtransConfig) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				midtransConfig.MidtransConfigNum=Meth.GetLong(MethodBase.GetCurrentMethod(),midtransConfig);
				return midtransConfig.MidtransConfigNum;
			}
			return Crud.MidtransConfigCrud.Insert(midtransConfig);
		}
		#endregion Insert

		#region Update
		///<summary></summary>
		public static void Update(MidtransConfig midtransConfig) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				Meth.GetVoid(MethodBase.GetCurrentMethod(),midtransConfig);
				return;
			}
			Crud.MidtransConfigCrud.Update(midtransConfig);
		}
		#endregion Update

		#region Delete
		///<summary></summary>
		public static void Delete(long midtransConfigNum) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				Meth.GetVoid(MethodBase.GetCurrentMethod(),midtransConfigNum);
				return;
			}
			Crud.MidtransConfigCrud.Delete(midtransConfigNum);
		}
		#endregion Delete

		#region Misc2
		///<summary>Gets the DefNum for the "QRIS" payment type definition (DefCat.PaymentTypes).
		///Creates the definition automatically if it does not already exist, so there is always a
		///dedicated QRIS line in financial reports without requiring any manual setup.</summary>
		public static long GetOrCreateQrisPayTypeDef() {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				return Meth.GetLong(MethodBase.GetCurrentMethod());
			}
			//Look for an existing "QRIS" payment type (visible or hidden).
			string command="SELECT DefNum FROM definition WHERE Category="+POut.Int((int)DefCat.PaymentTypes)
				+" AND ItemName='QRIS' LIMIT 1";
			string defNumStr=Db.GetScalar(command);
			if(!string.IsNullOrEmpty(defNumStr) && defNumStr!="0") {
				return PIn.Long(defNumStr);
			}
			//None found — create a new "QRIS" payment type appended after existing ones.
			string orderCmd="SELECT COALESCE(MAX(ItemOrder),0)+1 FROM definition WHERE Category="+POut.Int((int)DefCat.PaymentTypes);
			int itemOrder=PIn.Int(Db.GetScalar(orderCmd));
			Def defQris=new Def();
			defQris.Category=DefCat.PaymentTypes;
			defQris.ItemName="QRIS";
			defQris.ItemOrder=itemOrder;
			defQris.IsHidden=false;
			return Crud.DefCrud.Insert(defQris);
		}
		#endregion Misc2
	}
}
