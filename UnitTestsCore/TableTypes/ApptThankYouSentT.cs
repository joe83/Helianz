using System.Collections.Generic;
using HelianzBusiness;

namespace UnitTestsCore {
	public class ApptThankYouSentT {
		///<summary>Deletes everything from the apptremindersent table.  Does not truncate the table so that PKs are not reused on accident.</summary>
		public static void ClearApptThankYouSentTable() {
			string command="DELETE FROM apptthankyousent WHERE ApptThankYouSentNum > 0";
			DataCore.NonQ(command);
		}

		///<summary></summary>
		public static List<ApptThankYouSent> GetAll() {
			string command="SELECT * FROM apptthankyousent";
			return DataAction.GetPractice(() => HelianzBusiness.Crud.ApptThankYouSentCrud.SelectMany(command));
		}
	}
}
