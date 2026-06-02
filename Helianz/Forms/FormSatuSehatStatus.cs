using System;
using System.Collections.Generic;
using System.Windows.Forms;
using CodeBase;
using Helianz.UI;
using HelianzBusiness;
using HelianzBusiness.WebBridges.SatuSehat;

namespace Helianz {
	public partial class FormSatuSehatStatus:FormODBase {

		public FormSatuSehatStatus() {
			InitializeComponent();
			InitializeLayoutManager();
			Lan.F(this);
		}

		private void FormSatuSehatStatus_Load(object sender,EventArgs e) {
			comboFilter.Items.Add(Lan.g(this,"All"));
			comboFilter.Items.AddEnums<SatuSehatSyncStatus>();
			comboFilter.SelectedIndex=0;
			FillGrid();
			UpdateStats();
			timerRefresh.Start();
		}

		private void FillGrid() {
			List<SatuSehatStatus> listStatuses=SatuSehatStatuses.GetPage(0,500);
			if(comboFilter.SelectedIndex>0) {
				SatuSehatSyncStatus filterStatus=comboFilter.GetSelected<SatuSehatSyncStatus>();
				listStatuses=listStatuses.FindAll(x => x.SyncStatus==filterStatus);
			}
			gridMain.BeginUpdate();
			gridMain.Columns.Clear();
			GridColumn col;
			col=new GridColumn(Lan.g(this,"PatNum"),65);
			gridMain.Columns.Add(col);
			col=new GridColumn(Lan.g(this,"Resource Type"),110);
			gridMain.Columns.Add(col);
			col=new GridColumn(Lan.g(this,"Local Resource ID"),120);
			gridMain.Columns.Add(col);
			col=new GridColumn(Lan.g(this,"IHS ID"),180);
			gridMain.Columns.Add(col);
			col=new GridColumn(Lan.g(this,"Status"),80);
			gridMain.Columns.Add(col);
			col=new GridColumn(Lan.g(this,"Last Sync"),140);
			gridMain.Columns.Add(col);
			col=new GridColumn(Lan.g(this,"Retry"),45);
			gridMain.Columns.Add(col);
			col=new GridColumn(Lan.g(this,"Error"),200);
			gridMain.Columns.Add(col);
			gridMain.ListGridRows.Clear();
			for(int i=0;i<listStatuses.Count;i++) {
				GridRow row=new GridRow();
				row.Cells.Add(listStatuses[i].PatNum.ToString());
				row.Cells.Add(listStatuses[i].ResourceType.ToString());
				row.Cells.Add(listStatuses[i].LocalResourceId.ToString());
				row.Cells.Add(listStatuses[i].IhsId);
				row.Cells.Add(listStatuses[i].SyncStatus.ToString());
				if(listStatuses[i].LastSyncAt.Year>1880) {
					row.Cells.Add(listStatuses[i].LastSyncAt.ToString());
				}
				else {
					row.Cells.Add("");
				}
				row.Cells.Add(listStatuses[i].RetryCount.ToString());
				row.Cells.Add(listStatuses[i].ErrorMessage);
				row.Tag=listStatuses[i];
				gridMain.ListGridRows.Add(row);
			}
			gridMain.EndUpdate();
		}

		private void comboFilter_SelectionChangeCommitted(object sender,EventArgs e) {
			FillGrid();
		}

		private void timerRefresh_Tick(object sender,EventArgs e) {
			FillGrid();
			UpdateStats();
		}

		private void UpdateStats() {
			try {
				SatuSehatSyncStats stats=SatuSehatStatuses.GetSyncStats();
				labelStats.Text=Lan.g(this,"Pending")+": "+stats.Pending
					+"  |  "+Lan.g(this,"Synced")+": "+stats.Synced
					+"  |  "+Lan.g(this,"Failed")+": "+stats.Failed
					+"  |  "+Lan.g(this,"Skipped")+": "+stats.Skipped
					+"  \u2014  "+Lan.g(this,"Auto-sync every 5 min");
			}
			catch { }
		}

		private void butSyncNow_Click(object sender,EventArgs e) {
			SatuSehatConfig config=SatuSehatConfigs.GetOne();
			if(config==null || !config.IsEnabled) {
				MsgBox.Show(this,"SatuSehat integration is not enabled. Open Settings, fill in your credentials, check 'Enable', then click Save.");
				return;
			}
			Cursor=Cursors.WaitCursor;
			try {
				int count=SatuSehatSync.ProcessPendingQueue();
				Cursor=Cursors.Default;
				MsgBox.Show(this,"Sync complete. Processed "+count.ToString()+" item(s).");
			}
			catch(Exception ex) {
				Cursor=Cursors.Default;
				MsgBox.Show(this,"Sync error: "+ex.Message);
			}
			FillGrid();
		}

		private void butSettings_Click(object sender,EventArgs e) {
			using FormSatuSehatSetup formSatuSehatSetup=new FormSatuSehatSetup();
			formSatuSehatSetup.ShowDialog();
		}

		private void butDemoData_Click(object sender,EventArgs e) {
			if(!MsgBox.Show(this,MsgBoxButtons.OKCancel,"This will insert 5 demo Indonesian patients with appointments and procedures, "
				+"then enqueue them for SatuSehat sync.\r\nContinue?"))
			{
				return;
			}
			Cursor=Cursors.WaitCursor;
			try {
				int created=SatuSehatDemoData.CreateDemoData();
				Cursor=Cursors.Default;
				if(created==0) {
					MsgBox.Show(this,"All demo patients already exist (identified by NIK). No new records were inserted.");
				}
				else {
					MsgBox.Show(this,created.ToString()+" demo patient(s) created with appointments, procedures, and sync queue entries.");
				}
			}
			catch(Exception ex) {
				Cursor=Cursors.Default;
				MsgBox.Show(this,"Error creating demo data: "+ex.ToString());
			}
			FillGrid();
		}

		private void butClearDemo_Click(object sender,EventArgs e) {
			if(!MsgBox.Show(this,MsgBoxButtons.OKCancel,"This will soft-delete all demo patients (identified by demo NIK numbers) "
				+"and remove their appointments, procedures, and sync queue entries.\r\nContinue?"))
			{
				return;
			}
			Cursor=Cursors.WaitCursor;
			try {
				int removed=SatuSehatDemoData.ClearDemoData();
				Cursor=Cursors.Default;
				MsgBox.Show(this,removed.ToString()+" demo patient(s) cleared.");
			}
			catch(Exception ex) {
				Cursor=Cursors.Default;
				MsgBox.Show(this,"Error clearing demo data: "+ex.Message);
			}
			FillGrid();
		}

		private void butClose_Click(object sender,EventArgs e) {
			timerRefresh.Stop();
			Close();
		}
	}
}
