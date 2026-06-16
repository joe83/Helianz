using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Windows.Forms;
using HelianzBusiness;
using HelianzBusiness.Crud;
using Helianz.ReportingComplex;
using CodeBase;
using System.Linq;

namespace Helianz{
///<summary></summary>
	public partial class FormRpProcSheet : FormODBase {
		private List<Clinic> _listClinics;
		private List<long> _listClinicNums;
		private List<long> _listProvNums;
		private List<Provider> _listProviders;

		///<summary></summary>
		public FormRpProcSheet(){
			InitializeComponent();
			InitializeLayoutManager();
 			Lan.F(this);
		}

		private void FormDailySummary_Load(object sender, System.EventArgs e) {
			_listProviders=Providers.GetListReports();
			date1.SelectionStart=DateTime.Today;
			date2.SelectionStart=DateTime.Today;
			if(!Security.IsAuthorized(EnumPermType.ReportDailyAllProviders,true)) {
				//They either have permission or have a provider at this point.  If they don't have permission they must have a provider.
				_listProviders=_listProviders.FindAll(x => x.ProvNum==Security.CurUser.ProvNum);
				checkAllProv.Checked=false;
				checkAllProv.Enabled=false;
			}
			listProv.Items.AddList(_listProviders,x => x.GetLongDesc());
			if(checkAllProv.Enabled==false && _listProviders.Count>0) {
				listProv.SetSelected(0);
			}
			//Bahan/Opr only available in Individual mode
			radioIndividual.CheckedChanged+=(s,ev) => {
				checkShowBahan.Enabled=radioIndividual.Checked;
				checkShowOpr.Enabled=radioIndividual.Checked;
			};
			//Load persisted Bahan/Opr visibility (default checked on first use)
			checkShowBahan.Checked=PrefC.GetBoolSilent(PrefName.ShowBahan,true);
			checkShowOpr.Checked=PrefC.GetBoolSilent(PrefName.ShowOpr,true);
			//Save on toggle, creating the pref row in DB on first use
			checkShowBahan.Click+=(s,ev) => {
				if(!PrefC.ContainsKey(nameof(PrefName.ShowBahan))) {
					Pref p=new Pref(){ PrefName=nameof(PrefName.ShowBahan),ValueString=POut.Bool(checkShowBahan.Checked) };
					PrefCrud.Insert(p);
					Prefs.UpdateValueForKey(p);
				}
				Prefs.UpdateBool(PrefName.ShowBahan,checkShowBahan.Checked);
			};
			checkShowOpr.Click+=(s,ev) => {
				if(!PrefC.ContainsKey(nameof(PrefName.ShowOpr))) {
					Pref p=new Pref(){ PrefName=nameof(PrefName.ShowOpr),ValueString=POut.Bool(checkShowOpr.Checked) };
					PrefCrud.Insert(p);
					Prefs.UpdateValueForKey(p);
				}
				Prefs.UpdateBool(PrefName.ShowOpr,checkShowOpr.Checked);
			};
			if(!PrefC.HasClinicsEnabled) {
				listClin.Visible=false;
				labelClin.Visible=false;
				checkAllClin.Visible=false;
			}
			else {
				_listClinics=Clinics.GetForUserod(Security.CurUser);
				if(!Security.CurUser.ClinicIsRestricted) {
					listClin.Items.Add(Lan.g(this,"Unassigned"));
					listClin.SetSelected(0);
				}
				for(int i=0;i<_listClinics.Count;i++) {
					listClin.Items.Add(_listClinics[i].Abbr);
					if(Clinics.ClinicNum==0) {
						listClin.SetSelected(listClin.Items.Count-1);
						checkAllClin.Checked=true;
					}
					if(_listClinics[i].ClinicNum==Clinics.ClinicNum) {
						listClin.SelectedIndices.Clear();
						listClin.SetSelected(listClin.Items.Count-1);
					}
				}
			}
		}

		private void checkAllProv_Click(object sender,EventArgs e) {
			if(checkAllProv.Checked) {
				listProv.ClearSelected();
			}
		}

		private void listProv_Click(object sender,EventArgs e) {
			if(listProv.SelectedIndices.Count>0) {
				checkAllProv.Checked=false;
			}
		}

		private void checkAllClin_Click(object sender,EventArgs e) {
			if(checkAllClin.Checked) {
				listClin.SetAll(true);
			}
			else {
				listClin.ClearSelected();
			}
		}

		private void listClin_Click(object sender,EventArgs e) {
			if(listClin.SelectedIndices.Count>0) {
				checkAllClin.Checked=false;
			}
		}

		private void butOK_Click(object sender,System.EventArgs e) {
			if(date2.SelectionStart<date1.SelectionStart) {
				MsgBox.Show(this,"End date cannot be before start date.");
				return;
			}
			if(!checkAllProv.Checked && listProv.SelectedIndices.Count==0) {
				MsgBox.Show(this,"At least one provider must be selected.");
				return;
			}
			if(PrefC.HasClinicsEnabled) {
				if(!checkAllClin.Checked && listClin.SelectedIndices.Count==0) {
					MsgBox.Show(this,"At least one clinic must be selected.");
					return;
				}
			}
			_listProvNums=new List<long>();
			_listClinicNums=new List<long>();
			for(int i=0;i<listProv.SelectedIndices.Count;i++) {
				_listProvNums.Add(_listProviders[listProv.SelectedIndices[i]].ProvNum);
			}
			if(PrefC.HasClinicsEnabled) {
				for(int i=0;i<listClin.SelectedIndices.Count;i++) {
					if(Security.CurUser.ClinicIsRestricted) {
						_listClinicNums.Add(_listClinics[listClin.SelectedIndices[i]].ClinicNum);//we know that the list is a 1:1 to _listClinics
					}
					else {
						if(listClin.SelectedIndices[i]==0) {
							_listClinicNums.Add(0);
						}
						else {
							_listClinicNums.Add(_listClinics[listClin.SelectedIndices[i]-1].ClinicNum);//Minus 1 from the selected index
						}
					}
				}
				if(checkAllClin.Checked) {//All Clinics selected; add all visible or hidden unrestricted clinics to the list
					_listClinicNums=_listClinicNums.Union(Clinics.GetAllForUserod(Security.CurUser).Select(x => x.ClinicNum)).ToList();
				}
			}
			if(radioIndividual.Checked){
				CreateIndividual();
			}
			else{
				CreateGrouped();
			}
		}

		private void CreateIndividual() {
			ReportComplex report=new ReportComplex(true,false);
			bool isAnyClinicMedical=false;//Used to determine whether or not to display 'Tooth' column
			if(AnyClinicSelectedIsMedical()) {
				isAnyClinicMedical=true;
			}
			DataTable table=new DataTable();
			try {
				table=RpProcSheet.GetIndividualTable(date1.SelectionStart,date2.SelectionStart,_listProvNums,_listClinicNums,textCode.Text,
					isAnyClinicMedical,checkAllProv.Checked,PrefC.HasClinicsEnabled);
			}
			catch (Exception ex) {
				report.CloseProgressBar();
				string text=Lan.g(this,"Error getting report data:")+" "+ex.Message+"\r\n\r\n"+ex.StackTrace;
				using MsgBoxCopyPaste msgBox=new MsgBoxCopyPaste(text);
				msgBox.ShowDialog();
				return;
			}
			if(table.Columns.Contains("ToothNum")) {
				foreach(DataRow row in table.Rows) {
					row["ToothNum"]=Tooth.Display(row["ToothNum"].ToString());
				}
			}

			/*
			//Compute totals and append a total row to the table
			DataRow totRow=table.NewRow();
			double totFee=0,totShare=0,totBahan=0,totOpr=0;
			foreach(DataRow r in table.Rows) {
				totFee+=PIn.Double(r["$fee"].ToString());
				totShare+=PIn.Double(r["Share"].ToString());
				totBahan+=PIn.Double(r["Bahan"].ToString());
				totOpr+=PIn.Double(r["Opr"].ToString());
			}
			//Put "TOTAL" label under Clinic if present, otherwise under Description
			if(table.Columns.Contains("Clinic"))
				totRow["Clinic"]=Lan.g(this,"TOTAL");
			else
				totRow["Descript"]=Lan.g(this,"TOTAL");
			totRow["$fee"]=totFee;
			totRow["Share"]=totShare;
			if(checkShowBahan.Checked) totRow["Bahan"]=totBahan;
			if(checkShowOpr.Checked) totRow["Opr"]=totOpr;
			table.Rows.Add(totRow);

			*/
			string subtitleProvs=ConstructProviderSubtitle();
			string subtitleClinics=ConstructClinicSubtitle();
			Font font=new Font("Tahoma",8);
			Font fontTitle=new Font("Tahoma",14,FontStyle.Bold);
			Font fontSubTitle=new Font("Tahoma",9,FontStyle.Bold);
			report.ReportName=Lan.g(this,"Daily Procedures");
			report.AddTitle("Title",Lan.g(this,"Daily Procedures"),fontTitle);
			report.AddSubTitle("Practice Title",PrefC.GetString(PrefName.PracticeTitle),fontSubTitle);
			report.AddSubTitle("Dates of Report",date1.SelectionStart.ToString("d")+" - "+date2.SelectionStart.ToString("d"),fontSubTitle);
			report.AddSubTitle("Providers",subtitleProvs,fontSubTitle);
			if(PrefC.HasClinicsEnabled) {
				report.AddSubTitle("Clinics",subtitleClinics,fontSubTitle);
			}
			QueryObject query=report.AddQuery(table,Lan.g(this,"Date")+": "+DateTime.Today.ToString("d"));
			query.AddColumn(Lan.g(this,"Date"),75,FieldValueType.Date,font);
			query.GetColumnDetail(Lan.g(this,"Date")).StringFormat="d";
			query.AddColumn(Lan.g(this,"Patient Name"),120,FieldValueType.String,font);
			if(isAnyClinicMedical) {
				query.AddColumn(Lan.g(this,"Code"),100,FieldValueType.String,font);
			}
			else {
				query.AddColumn(Lan.g(this,"Code"),60,FieldValueType.String,font);
				query.AddColumn("Tooth",30,FieldValueType.String,font);
			}
			query.AddColumn("Area",40,FieldValueType.String,font);
			query.AddColumn(Lan.g(this,"Description"),110,FieldValueType.String,font);
			query.AddColumn(Lan.g(this,"Prov"),50,FieldValueType.String,font);
			if(PrefC.HasClinicsEnabled) {
				query.AddColumn(Lan.g(this,"Clinic"),85,FieldValueType.String,font);
			}
			query.AddColumn(Lan.g(this,"Fee"),70,FieldValueType.Number,font,"n0");
			query.AddColumn("Share",70,FieldValueType.Number,font,"n0");
			if(checkShowBahan.Checked) query.AddColumn("Bahan",70,FieldValueType.Number,font,"n0");
			if(checkShowOpr.Checked) query.AddColumn("Opr",70,FieldValueType.Number,font,"n0");
			report.AddPageNum(font);
			if(!report.SubmitQueries()) {
				return;
			}
			using FormReportComplex FormR=new FormReportComplex(report);
			FormR.ShowDialog();
			DialogResult=DialogResult.OK;
		}

		private void CreateGrouped() {
			ReportComplex report=new ReportComplex(true,false);
			DataTable table=RpProcSheet.GetGroupedTable(date1.SelectionStart,date2.SelectionStart,_listProvNums,_listClinicNums,textCode.Text,checkAllProv.Checked);
			string subtitleProvs=ConstructProviderSubtitle();
			string subtitleClinics=ConstructClinicSubtitle();
			Font font=new Font("Tahoma",8);
			Font fontTitle=new Font("Tahoma",14,FontStyle.Bold);
			Font fontSubTitle=new Font("Tahoma",9,FontStyle.Bold);
			report.ReportName=Lan.g(this,"Procedures By Procedure Code");
			report.AddTitle("Title",Lan.g(this,"Procedures By Procedure Code"),fontTitle);
			report.AddSubTitle("Practice Title",PrefC.GetString(PrefName.PracticeTitle),fontSubTitle);
			report.AddSubTitle("Dates of Report",date1.SelectionStart.ToString("d")+" - "+date2.SelectionStart.ToString("d"),fontSubTitle);
			report.AddSubTitle("Providers",subtitleProvs,fontSubTitle);
			if(PrefC.HasClinicsEnabled) {
				report.AddSubTitle("Clinics",subtitleClinics,fontSubTitle);
			}
			QueryObject query=report.AddQuery(table,Lan.g(this,"Date")+": "+DateTime.Today.ToString("d"));
			query.AddColumn(Lan.g(this,"Category"),130,FieldValueType.String,font);
			query.AddColumn(Lan.g(this,"Code"),110,FieldValueType.String,font);
			query.AddColumn(Lan.g(this,"Description"),110,FieldValueType.String,font);
			query.AddColumn(Lan.g(this,"Quantity"),60,FieldValueType.Integer,font);
			query.GetColumnDetail(Lan.g(this,"Quantity")).ContentAlignment=ContentAlignment.MiddleRight;
			query.AddColumn(Lan.g(this,"Average Fee"),90,FieldValueType.Number,font,"n0");
			query.GetColumnDetail(Lan.g(this,"Average Fee")).ContentAlignment=ContentAlignment.MiddleRight;
			query.AddColumn(Lan.g(this,"Total Fees"),90,FieldValueType.Number,font,"n0");
			report.AddPageNum(font);
			if(!report.SubmitQueries()) {
				return;
			}
			using FormReportComplex FormR=new FormReportComplex(report);
			FormR.ShowDialog();
			DialogResult=DialogResult.OK;
		}

		///<summary>Returns 'All Providers' or comma separated string of clinics providers selected.</summary>
		private string ConstructProviderSubtitle() {
			string subtitleProvs="";
			if(checkAllProv.Checked) {
				return Lan.g(this,"All Providers");
			}
			for(int i=0;i<listProv.SelectedIndices.Count;i++) {
				if(i>0) {
					subtitleProvs+=", ";
				}
				subtitleProvs+=_listProviders[listProv.SelectedIndices[i]].Abbr;
			}
			return subtitleProvs;
		}

		///<summary>Returns 'All Clinics' or comma separated string of clinics selected.</summary>
		private string ConstructClinicSubtitle() {
			string subtitleClinics="";
			if(!PrefC.HasClinicsEnabled) {
				return subtitleClinics;
			}
			if(checkAllClin.Checked) {
				return Lan.g(this,"All Clinics (includes hidden)");
			}
			for(int i=0;i<listClin.SelectedIndices.Count;i++) {
				if(i>0) {
					subtitleClinics+=", ";
				}
				if(Security.CurUser.ClinicIsRestricted) {
					subtitleClinics+=_listClinics[listClin.SelectedIndices[i]].Abbr;
				}
				else {
					if(listClin.SelectedIndices[i]==0) {
						subtitleClinics+=Lan.g(this,"Unassigned");
					}
					else {
						subtitleClinics+=_listClinics[listClin.SelectedIndices[i]-1].Abbr;//Minus 1 from the selected index to account for 'Unassigned' 
					}
				}
			}
			return subtitleClinics;
		}

		private bool AnyClinicSelectedIsMedical() {
			if(!PrefC.HasClinicsEnabled) {
				return Clinics.IsMedicalPracticeOrClinic(0);//Check if the practice is medical
			}
			if(Security.CurUser.ClinicIsRestricted) {//User can only view one clinic
				return Clinics.IsMedicalPracticeOrClinic(Clinics.ClinicNum);
			}
			for(int i=0;i<listClin.SelectedIndices.Count;i++) {
				if(listClin.SelectedIndices[i]==0 //The user selected 'Unassigned' 
					&& Clinics.IsMedicalPracticeOrClinic(0)) //And the practice is medical
				{
					return true;
				}
				//if(Clinics.IsMedicalPracticeOrClinic(_listClinics[listClin.SelectedIndices[i]-1].ClinicNum)) {//Minus 1 from the selected index
				if(listClin.SelectedIndices[i]!=0 && Clinics.IsMedicalPracticeOrClinic(_listClinics[listClin.SelectedIndices[i]-1].ClinicNum)) {//Minus 1 from the selected index
					return true;
				}
			}
			return false;
		}
		
	}
}