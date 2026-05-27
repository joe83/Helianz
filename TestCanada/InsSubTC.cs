using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Helianz;
using HelianzBusiness;
using Helianz.Eclaims;

namespace TestCanada {
	public class InsSubTC {
		

		public static void SetAssignBen(bool assignBen,long subNum) {
			InsSub sub=InsSubs.GetOne(subNum);
			if(sub.AssignBen==assignBen){
				return;//no change needed
			}
			sub.AssignBen=assignBen;
			InsSubs.Update(sub);
		}

		


	}
}
