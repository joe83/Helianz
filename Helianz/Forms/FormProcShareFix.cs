using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Windows.Forms;
using CodeBase;
using Helianz.UI;
using HelianzBusiness;

namespace Helianz {
	public partial class FormProcShareFix : FormODBase {
		private DataTable _tableMismatched;
		private List<Provider> _listProviders;

		public FormProcShareFix() {
			InitializeComponent();
			InitializeLayoutManager();
			Lan.F(this);
		}

		private void FormProcShareFix_Load(object sender, EventArgs e) {
			//Set default date range to current month
			DateTime firstDayOfMonth = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1);
			dateRangePicker.SetDateTimeFrom(firstDayOfMonth);
			dateRangePicker.SetDateTimeTo(DateTime.Today);

			//Setup Clinic filter
			if(!PrefC.HasClinicsEnabled) {
				labelClinic.Visible = false;
				comboClinic.Visible = false;
			}
			else {
				comboClinic.IsAllSelected = true;
			}

			//Setup Provider filter
			_listProviders = Providers.GetListReports();
			comboProvider.Items.Clear();
			comboProvider.Items.Add(Lan.g(this, "All"));
			for(int i = 0; i < _listProviders.Count; i++) {
				comboProvider.Items.Add(_listProviders[i].GetLongDesc());
			}
			comboProvider.SelectedIndex = 0;

			labelSummary.Text = Lan.g(this, "Click 'Scan' to find procedures with missing/zero doctor shares.");
		}

		private void butThisMonth_Click(object sender, EventArgs e) {
			DateTime start = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1);
			DateTime end = start.AddMonths(1).AddDays(-1);
			dateRangePicker.SetDateTimeFrom(start);
			dateRangePicker.SetDateTimeTo(end > DateTime.Today ? DateTime.Today : end);
		}

		private void butLastMonth_Click(object sender, EventArgs e) {
			DateTime start = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1).AddMonths(-1);
			DateTime end = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1).AddDays(-1);
			dateRangePicker.SetDateTimeFrom(start);
			dateRangePicker.SetDateTimeTo(end);
		}

		private void butToday_Click(object sender, EventArgs e) {
			dateRangePicker.SetDateTimeFrom(DateTime.Today);
			dateRangePicker.SetDateTimeTo(DateTime.Today);
		}

		private void butScan_Click(object sender, EventArgs e) {
			if(!dateRangePicker.IsValid()) {
				MsgBox.Show(this, "Please enter valid dates.");
				return;
			}
			DateTime dateFrom = dateRangePicker.GetDateTimeFrom();
			DateTime dateTo = dateRangePicker.GetDateTimeTo();
			if(dateTo < dateFrom) {
				MsgBox.Show(this, "End date cannot be before start date.");
				return;
			}

			List<long> listClinicNums = new List<long>();
			if(PrefC.HasClinicsEnabled) {
				if(comboClinic.IsAllSelected) {
					listClinicNums = comboClinic.ListClinicNumsSelected;
				}
				else {
					listClinicNums.Add(comboClinic.ClinicNumSelected);
				}
			}

			bool hasAllProvs = (comboProvider.SelectedIndex == 0);
			List<long> listProvNums = new List<long>();
			if(!hasAllProvs && comboProvider.SelectedIndex > 0) {
				listProvNums.Add(_listProviders[comboProvider.SelectedIndex - 1].ProvNum);
			}

			Cursor = Cursors.WaitCursor;
			try {
				_tableMismatched = ProcedureDoctorShares.GetMismatchedShares(dateFrom, dateTo, listClinicNums, listProvNums, hasAllProvs, PrefC.HasClinicsEnabled);
				FillGrid();
			}
			catch(Exception ex) {
				Cursor = Cursors.Default;
				MsgBox.Show(this, "Error scanning procedures: " + ex.Message);
				return;
			}
			Cursor = Cursors.Default;
		}

		private void FillGrid() {
			gridMain.BeginUpdate();
			gridMain.Columns.Clear();
			gridMain.Columns.Add(new GridColumn(Lan.g(this, "Date"), 75, HorizontalAlignment.Center, GridSortingStrategy.DateParse));
			gridMain.Columns.Add(new GridColumn(Lan.g(this, "Patient"), 150, GridSortingStrategy.StringCompare));
			gridMain.Columns.Add(new GridColumn(Lan.g(this, "Performing Doctor"), 130, GridSortingStrategy.StringCompare));
			gridMain.Columns.Add(new GridColumn(Lan.g(this, "Primary Doctor"), 130, GridSortingStrategy.StringCompare));
			gridMain.Columns.Add(new GridColumn(Lan.g(this, "Code"), 55, GridSortingStrategy.StringCompare));
			gridMain.Columns.Add(new GridColumn(Lan.g(this, "Description"), 160, GridSortingStrategy.StringCompare));
			gridMain.Columns.Add(new GridColumn(Lan.g(this, "Tooth"), 40, HorizontalAlignment.Center, GridSortingStrategy.StringCompare));
			if(PrefC.HasClinicsEnabled) {
				gridMain.Columns.Add(new GridColumn(Lan.g(this, "Clinic"), 80, GridSortingStrategy.StringCompare));
			}
			gridMain.Columns.Add(new GridColumn(Lan.g(this, "Fee"), 80, HorizontalAlignment.Right, GridSortingStrategy.AmountParse));
			gridMain.Columns.Add(new GridColumn(Lan.g(this, "Current Share"), 90, HorizontalAlignment.Right, GridSortingStrategy.AmountParse));
			gridMain.Columns.Add(new GridColumn(Lan.g(this, "Expected Share"), 95, HorizontalAlignment.Right, GridSortingStrategy.AmountParse));
			gridMain.Columns.Add(new GridColumn(Lan.g(this, "Fee Schedule"), 95, GridSortingStrategy.StringCompare));

			gridMain.ListGridRows.Clear();
			if(_tableMismatched != null) {
				double totalFee = 0;
				double totalExpectedShare = 0;

				for(int i = 0; i < _tableMismatched.Rows.Count; i++) {
					DataRow row = _tableMismatched.Rows[i];
					GridRow gRow = new GridRow();
					DateTime procDate = PIn.Date(row["ProcDate"].ToString());
					double procFee = PIn.Double(row["ProcFee"].ToString());
					double curShare = PIn.Double(row["CurrentShare"].ToString());
					double expShare = PIn.Double(row["ExpectedShare"].ToString());
					string toothNum = Tooth.Display(row["ToothNum"].ToString());

					totalFee += procFee;
					totalExpectedShare += expShare;

					gRow.Cells.Add(procDate.ToShortDateString());
					gRow.Cells.Add(row["PatName"].ToString());
					gRow.Cells.Add(row["ProcProvAbbr"].ToString());
					gRow.Cells.Add(row["PatPriProvAbbr"].ToString());
					gRow.Cells.Add(row["ProcCode"].ToString());
					gRow.Cells.Add(row["Descript"].ToString());
					gRow.Cells.Add(toothNum);
					if(PrefC.HasClinicsEnabled) {
						gRow.Cells.Add(row["ClinicAbbr"].ToString());
					}
					gRow.Cells.Add(procFee.ToString("n0"));
					gRow.Cells.Add(curShare.ToString("n0"));
					gRow.Cells.Add(expShare.ToString("n0"));
					gRow.Cells.Add(row["FeeSchedDesc"].ToString());

					gRow.Tag = PIn.Long(row["ProcNum"].ToString());
					gridMain.ListGridRows.Add(gRow);
				}

				gridMain.EndUpdate();

				//Select all by default
				gridMain.SetAll(true);

				if(_tableMismatched.Rows.Count == 0) {
					labelSummary.Text = Lan.g(this, "No mismatched zero-share procedures found for the selected criteria.");
					butFix.Enabled = false;
				}
				else {
					labelSummary.Text = string.Format(Lan.g(this, "Found {0} procedure(s). Total Fee: Rp {1:n0} | Total Expected Doctor Share: Rp {2:n0}"),
						_tableMismatched.Rows.Count, totalFee, totalExpectedShare);
					butFix.Enabled = true;
				}
			}
			else {
				gridMain.EndUpdate();
				butFix.Enabled = false;
			}
		}

		private void butSelectAll_Click(object sender, EventArgs e) {
			gridMain.SetAll(true);
		}

		private void buttDeselectAll_Click(object sender, EventArgs e) {
			gridMain.SetAll(false);
		}

		private void butDeselectAll_Click(object sender, EventArgs e) {
			gridMain.SetAll(false);
		}

		private void butFix_Click(object sender, EventArgs e) {
			if(!Security.IsAuthorized(EnumPermType.ProcComplCreate)) {
				return;
			}
			List<long> listProcNumsToFix = new List<long>();
			for(int i = 0; i < gridMain.SelectedIndices.Length; i++) {
				int index = gridMain.SelectedIndices[i];
				if(gridMain.ListGridRows[index].Tag != null) {
					listProcNumsToFix.Add((long)gridMain.ListGridRows[index].Tag);
				}
			}

			if(listProcNumsToFix.Count == 0) {
				MsgBox.Show(this, "Please select at least one procedure to fix.");
				return;
			}

			string message = string.Format(Lan.g(this, "Are you sure you want to update the Doctor Share for {0} selected procedure(s)?"), listProcNumsToFix.Count);
			if(MessageBox.Show(this, message, Lan.g(this, "Confirm Fix"), MessageBoxButtons.YesNo, MessageBoxIcon.Question) != DialogResult.Yes) {
				return;
			}

			Cursor = Cursors.WaitCursor;
			try {
				int fixedCount = ProcedureDoctorShares.FixProcedureShares(listProcNumsToFix, Security.CurUser.UserNum);
				Cursor = Cursors.Default;
				MsgBox.Show(this, string.Format(Lan.g(this, "Successfully updated doctor share for {0} procedure(s)."), fixedCount));
				//Re-scan to refresh grid
				butScan_Click(this, EventArgs.Empty);
			}
			catch(Exception ex) {
				Cursor = Cursors.Default;
				MsgBox.Show(this, "Error applying doctor share fix: " + ex.Message);
			}
		}

		private void butClose_Click(object sender, EventArgs e) {
			DialogResult = DialogResult.OK;
			Close();
		}

	}
}
