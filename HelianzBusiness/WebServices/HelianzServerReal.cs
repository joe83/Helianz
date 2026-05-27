using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HelianzBusiness {
	///<summary>This is a helper class that allows the real HelianzServer.ServiceMain class implement IHelianzServer.
	///This also gives us a place to add code in the future if we ever need to add anything to HelianzServer.ServiceMain.</summary>
	public class HelianzServerReal:HelianzBusiness.HelianzServer.ServiceMain, IHelianzServer {
	}
}
