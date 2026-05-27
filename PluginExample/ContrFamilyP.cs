using System;
using System.Collections.Generic;
using System.Text;
using HelianzBusiness;

namespace PluginExample {
	class ContrFamilyP {
		public static void gridPat_CellDoubleClick(Helianz.ControlFamily sender,Patient patient) {//again, named much like the original
			FormPatientEditP formPatientEditP=new FormPatientEditP();
			formPatientEditP.PatientCur=patient;
			formPatientEditP.ShowDialog();
			sender.ModuleSelected(patient.PatNum);
		}
	}
}
