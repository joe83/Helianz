using System.Collections.Generic;
using CodeBase;
using HelianzBusiness;

namespace UnitTestsCore {
	public class UserOdPrefT {

		public static List<UserOdPref> GetByUser(long userNum) {
			string command="SELECT * FROM userodpref WHERE UserNum="+POut.Long(userNum);
			return HelianzBusiness.Crud.UserOdPrefCrud.SelectMany(command);
		}
	}
}
