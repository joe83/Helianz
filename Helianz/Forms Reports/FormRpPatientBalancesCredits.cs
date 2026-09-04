using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Windows.Forms;
using CodeBase;
using Helianz.ReportingComplex;
using Helianz.UI;
using HelianzBusiness;

namespace Helianz {
	public partial class FormRpPatientBalancesCredits:FormODBase {
		private DataTable _table;
		private List<long> _listClinicNums;

		public FormRpPatientBalancesCredits() {
			InitializeComponent();
			InitializeLayoutManager();
			Lan.F(this);
		}

		private void FormRpPatientBalancesCredits_Load(object sender,EventArgs e) {
			comboStatus.Items.Add(Lan.g(this,"All Non-Empty"));
			comboStatus.Items.Add(Lan.g(this,"Credits & Prepayments Only"));
			comboStatus.Items.Add(Lan.g(this,"Unpaid Only"));
			comboStatus.Items.Add(Lan.g(this,"Partially Paid Only"));
			comboStatus.SelectedIndex=0;

			if(!PrefC.HasClinicsEnabled) {
				comboBoxClinicPicker.Visible=false;
			}
			FillGrid();
		}

		private void FillGrid() {
			string statusFilter="All";
			switch(comboStatus.SelectedIndex) {
				case 1:
					statusFilter="CreditPrepay";
					break;
				case 2:
					statusFilter="Unpaid";
					break;
				case 3:
					statusFilter="PartiallyPaid";
					break;
			}

			double minThreshold=0.01;
			if(!string.IsNullOrEmpty(textMinAmt.Text)) {
				Double.TryParse(textMinAmt.Text,out minThreshold);
			}

			_listClinicNums=comboBoxClinicPicker.ListClinicNumsSelected;
			bool isGroupByFamily=checkGroupByFamily.Checked;
			bool excludeInactive=checkExcludeInactive.Checked;

			_table=RpPatientBalancesCredits.GetPatientBalancesCredits(
				_listClinicNums,
				null,
				statusFilter,
				minThreshold,
				isGroupByFamily,
				excludeInactive
			);

			gridOD.BeginUpdate();
			gridOD.ListGridRows.Clear();
			gridOD.Columns.Clear();
			gridOD.Columns.Add(new GridColumn(Lan.g(this,"Patient Name"),165,GridSortingStrategy.StringCompare));
			gridOD.Columns.Add(new GridColumn(Lan.g(this,"Phone"),95,GridSortingStrategy.StringCompare));
			gridOD.Columns.Add(new GridColumn(Lan.g(this,"Status"),110,GridSortingStrategy.StringCompare));
			gridOD.Columns.Add(new GridColumn(Lan.g(this,"Ledger Bal"),140,HorizontalAlignment.Right,GridSortingStrategy.AmountParse));
			gridOD.Columns.Add(new GridColumn(Lan.g(this,"Prepay Credit"),135,HorizontalAlignment.Right,GridSortingStrategy.AmountParse));
			gridOD.Columns.Add(new GridColumn(Lan.g(this,"Net Due/(Credit)"),140,HorizontalAlignment.Right,GridSortingStrategy.AmountParse));
			gridOD.Columns.Add(new GridColumn(Lan.g(this,"Last Pay Date"),90,HorizontalAlignment.Center,GridSortingStrategy.DateParse));
			if(PrefC.HasClinicsEnabled) {
				gridOD.Columns.Add(new GridColumn(Lan.g(this,"Clinic"),70,GridSortingStrategy.StringCompare));
			}
			gridOD.Columns.Add(new GridColumn(Lan.g(this,"Provider"),60,GridSortingStrategy.StringCompare));

			double sumBalTotal=0;
			double sumUnearned=0;
			double sumNetBal=0;

			foreach(DataRow rowCur in _table.Rows) {
				GridRow row=new GridRow() { Tag=rowCur };

				double balTotal=PIn.Double(rowCur["BalTotal"].ToString());
				double unearnedAmt=PIn.Double(rowCur["UnearnedAmt"].ToString());
				double netBal=PIn.Double(rowCur["NetBal"].ToString());
				string status=rowCur["Status"].ToString();

				sumBalTotal+=balTotal;
				sumUnearned+=unearnedAmt;
				sumNetBal+=netBal;

				row.Cells.Add(rowCur["Patient"].ToString());
				row.Cells.Add(rowCur["Phone"].ToString());
				row.Cells.Add(status);
				row.Cells.Add(balTotal.ToString("c"));
				row.Cells.Add(unearnedAmt.ToString("c"));
				row.Cells.Add(netBal.ToString("c"));
				row.Cells.Add(rowCur["DateLastPay"].ToString());
				if(PrefC.HasClinicsEnabled) {
					row.Cells.Add(rowCur["Clinic"].ToString());
				}
				row.Cells.Add(rowCur["Provider"].ToString());

				// Status-based color coding
				if(status.Contains("Credit") || status.Contains("Prepay")) {
					row.ColorBackG=Color.FromArgb(240,255,240); // Soft green
				}
				else if(status=="Unpaid") {
					row.ColorBackG=Color.FromArgb(255,240,240); // Soft red
				}
				else if(status=="Partially Paid") {
					row.ColorBackG=Color.FromArgb(255,250,235); // Soft yellow/orange
				}

				gridOD.ListGridRows.Add(row);
			}
			gridOD.EndUpdate();

			labelTotals.Text=string.Format(
				Lan.g(this,"Total Accounts: {0}   |   Ledger Balance: {1}   |   Prepayment Credits: {2}   |   Net Due/(Credit): {3}"),
				_table.Rows.Count,
				sumBalTotal.ToString("c"),
				sumUnearned.ToString("c"),
				sumNetBal.ToString("c")
			);
		}

		private void PrintReport() {
			if(_table==null || _table.Rows.Count==0) {
				MsgBox.Show(this,Lan.g(this,"No rows to print."));
				return;
			}
			if(PrefC.HasClinicsEnabled && _listClinicNums.Count==0 && !comboBoxClinicPicker.IsAllSelected) {
				MsgBox.Show(this,Lan.g(this,"At least one clinic must be selected."));
				return;
			}
			ReportComplex report=new ReportComplex(true,false);
			report.ReportName="Patient Balances and Credits Report";
			report.AddTitle("Title",Lan.g(this,"Patient Balances and Credits"));
			report.AddSubTitle("Practice",PrefC.GetString(PrefName.PracticeTitle));

			if(PrefC.HasClinicsEnabled) {
				if(comboBoxClinicPicker.IsAllSelected) {
					report.AddSubTitle("Clinics",Lan.g(this,"All Clinics"));
				}
				else {
					List<Clinic> listClinics=Clinics.GetClinics(comboBoxClinicPicker.ListClinicNumsSelected);
					string clinNames=string.Join(", ",listClinics.Select(x => x.Abbr));
					report.AddSubTitle("Clinics",clinNames);
				}
			}

			QueryObject query=report.AddQuery(_table,"","",SplitByKind.None,1,true);
			query.AddColumn("Patient",200,FieldValueType.String);
			query.AddColumn("Phone",90,FieldValueType.String);
			query.AddColumn("Status",110,FieldValueType.String);
			query.AddColumn("Ledger Bal",85,FieldValueType.Number);
			query.AddColumn("Prepay Credit",85,FieldValueType.Number);
			query.AddColumn("Net Due/(Credit)",95,FieldValueType.Number);
			query.AddColumn("Last Pay Date",80,FieldValueType.Date);
			if(PrefC.HasClinicsEnabled) {
				query.AddColumn("Clinic",60,FieldValueType.String);
			}
			query.AddColumn("Prov",50,FieldValueType.String);

			report.AddPageNum();
			report.AddGridLines();
			if(!report.SubmitQueries()) {
				return;
			}
			using FormReportComplex formRC=new FormReportComplex(report);
			formRC.ShowDialog();
		}

		private void butRefresh_Click(object sender,EventArgs e) {
			FillGrid();
		}

		private void butPrint_Click(object sender,EventArgs e) {
			PrintReport();
		}

		private void butExport_Click(object sender,EventArgs e) {
			if(_table==null || _table.Rows.Count==0) {
				MsgBox.Show(this,Lan.g(this,"No data to export."));
				return;
			}
			string fileName=Lan.g(this,"Patient_Balances_and_Credits");
			string filePath=ODFileUtils.CombinePaths(Path.GetTempPath(),fileName);
			if(ODEnvironment.IsCloudServer) {
				filePath+=".txt";
			}
			else {
				using SaveFileDialog saveFileDialog=new SaveFileDialog();
				saveFileDialog.AddExtension=true;
				saveFileDialog.FileName=fileName;
				if(!Directory.Exists(PrefC.GetString(PrefName.ExportPath))) {
					try {
						Directory.CreateDirectory(PrefC.GetString(PrefName.ExportPath));
						saveFileDialog.InitialDirectory=PrefC.GetString(PrefName.ExportPath);
					}
					catch {
					}
				}
				else {
					saveFileDialog.InitialDirectory=PrefC.GetString(PrefName.ExportPath);
				}
				saveFileDialog.Filter="Text files(*.txt)|*.txt|Excel Files(*.xls)|*.xls|All files(*.*)|*.*";
				saveFileDialog.FilterIndex=0;
				if(saveFileDialog.ShowDialog()!=DialogResult.OK) {
					return;
				}
				filePath=saveFileDialog.FileName;
			}
			try {
				using(StreamWriter sw=new StreamWriter(filePath,false)) {
					string line="";
					for(int i=0;i<gridOD.Columns.Count;i++) {
						line+=gridOD.Columns[i].Heading+"\t";
					}
					sw.WriteLine(line);
					for(int i=0;i<gridOD.ListGridRows.Count;i++) {
						line="";
						for(int c=0;c<gridOD.Columns.Count;c++) {
							line+=gridOD.ListGridRows[i].Cells[c].Text+"\t";
						}
						sw.WriteLine(line);
					}
				}
				MsgBox.Show(this,Lan.g(this,"File exported successfully: ")+filePath);
			}
			catch(Exception ex) {
				MsgBox.Show(this,Lan.g(this,"Error exporting file: ")+ex.Message);
			}
		}

		private void menuItemAccount_Click(object sender,EventArgs e) {
			GotoSelectedAccount();
		}

		private void gridOD_CellDoubleClick(object sender,ODGridClickEventArgs e) {
			GotoSelectedAccount();
		}

		private void GotoSelectedAccount() {
			if(!Security.IsAuthorized(EnumPermType.AccountModule)) {
				return;
			}
			if(gridOD.SelectedIndices.Length==0) {
				MsgBox.Show(this,Lan.g(this,"Please select a patient first."));
				return;
			}
			long patNum=PIn.Long(gridOD.SelectedTag<DataRow>()["PatNum"].ToString());
			GlobalFormHelianz.GoToModule(EnumModuleType.Account,patNum:patNum);
		}

		private void butClose_Click(object sender,EventArgs e) {
			Close();
		}
	}
}
