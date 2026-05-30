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

		private void butSyncNow_Click(object sender,EventArgs e) {
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

		private void butClose_Click(object sender,EventArgs e) {
			Close();
		}
	}
}
