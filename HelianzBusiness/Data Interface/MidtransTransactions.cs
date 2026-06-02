using System;
using System.Collections.Generic;
using System.Data;
using System.Reflection;
using System.Text;

namespace HelianzBusiness {
	///<summary>Data interface for MidtransTransaction table. Records QRIS payment transaction lifecycle.</summary>
	public class MidtransTransactions {
		#region Get Methods
		///<summary>Gets one MidtransTransaction from the database by primary key. Returns null if not found.</summary>
		public static MidtransTransaction GetOne(long midtransTransactionNum) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				return Meth.GetObject<MidtransTransaction>(MethodBase.GetCurrentMethod(),midtransTransactionNum);
			}
			return Crud.MidtransTransactionCrud.SelectOne(midtransTransactionNum);
		}

		///<summary>Gets a MidtransTransaction by its Midtrans order ID. Returns null if not found.</summary>
		public static MidtransTransaction GetByOrderId(string orderId) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				return Meth.GetObject<MidtransTransaction>(MethodBase.GetCurrentMethod(),orderId);
			}
			string command="SELECT * FROM midtranstransaction WHERE OrderId='"+POut.String(orderId)+"'";
			return Crud.MidtransTransactionCrud.SelectOne(command);
		}

		///<summary>Gets all MidtransTransactions for a given patient, ordered newest first.</summary>
		public static List<MidtransTransaction> GetByPatNum(long patNum) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				return Meth.GetObject<List<MidtransTransaction>>(MethodBase.GetCurrentMethod(),patNum);
			}
			string command="SELECT * FROM midtranstransaction WHERE PatNum="+POut.Long(patNum)
				+" ORDER BY DateTimeCreated DESC";
			return Crud.MidtransTransactionCrud.SelectMany(command);
		}

		///<summary>Gets all MidtransTransactions linked to a given payment (PayNum).</summary>
		public static List<MidtransTransaction> GetByPayNum(long payNum) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				return Meth.GetObject<List<MidtransTransaction>>(MethodBase.GetCurrentMethod(),payNum);
			}
			string command="SELECT * FROM midtranstransaction WHERE PayNum="+POut.Long(payNum);
			return Crud.MidtransTransactionCrud.SelectMany(command);
		}

		///<summary>Gets all pending MidtransTransactions (status Created or Pending), used for polling.</summary>
		public static List<MidtransTransaction> GetAllPending() {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				return Meth.GetObject<List<MidtransTransaction>>(MethodBase.GetCurrentMethod());
			}
			string command="SELECT * FROM midtranstransaction WHERE TransactionStatus IN ("
				+"'"+MidtransTransactionStatus.Created.ToString()+"',"
				+"'"+MidtransTransactionStatus.Pending.ToString()+"')";
			return Crud.MidtransTransactionCrud.SelectMany(command);
		}
		#endregion Get Methods

		#region Insert
		///<summary></summary>
		public static long Insert(MidtransTransaction midtransTransaction) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				midtransTransaction.MidtransTransactionNum=Meth.GetLong(MethodBase.GetCurrentMethod(),midtransTransaction);
				return midtransTransaction.MidtransTransactionNum;
			}
			return Crud.MidtransTransactionCrud.Insert(midtransTransaction);
		}
		#endregion Insert

		#region Update
		///<summary></summary>
		public static void Update(MidtransTransaction midtransTransaction) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				Meth.GetVoid(MethodBase.GetCurrentMethod(),midtransTransaction);
				return;
			}
			Crud.MidtransTransactionCrud.Update(midtransTransaction);
		}
		#endregion Update
	}
}
