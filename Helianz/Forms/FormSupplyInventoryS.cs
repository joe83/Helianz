using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Windows.Forms;
using HelianzBusiness;
using Helianz.UI;
using CodeBase;

namespace Helianz {
	public partial class FormSupplyInventoryS : FormODBase {
		private List<Supply> _listSupplies;
		private List<Supplier> _listSuppliers;

		public string dataFormX1 => textQty.Text;

		public string dataFormX2 => textPrice.Text;

		public string dataFormX3 => textProduct.Text;

		public FormSupplyInventoryS() {
			InitializeComponent();
			InitializeLayoutManager();
			Lan.F(this);
		}

		private void FormSupplyInventoryS_Load(object sender,EventArgs e) {
			FillSuppliers();
			if(comboSupplier.Items.Count>0) {
				comboSupplier.SelectedIndex=0;
			}
			FillGridSupplyMain();
		}

		private void FillSuppliers() {
			_listSuppliers=Suppliers.GetAll();
			comboSupplier.Items.Clear();
			for(int i=0;i<_listSuppliers.Count;i++) {
				comboSupplier.Items.Add(_listSuppliers[i].Name);
			}
		}

		private void FillGridSupplyMain() {
			long supplierNum=0;
			if(comboSupplier.SelectedIndex!=-1) {
				supplierNum=_listSuppliers[comboSupplier.SelectedIndex].SupplierNum;
			}
			List<long> listSupplierNums=new List<long>();
			if(supplierNum>0) {
				listSupplierNums.Add(supplierNum);
			}
			else {
				listSupplierNums=null;
			}
			_listSupplies=Supplies.GetList(listSupplierNums,false,textFind.Text,null);
			gridSupplyMain.BeginUpdate();
			gridSupplyMain.Columns.Clear();
			GridColumn col;
			col=new GridColumn(Lan.g(this,"Category"),130);
			gridSupplyMain.Columns.Add(col);
			col=new GridColumn(Lan.g(this,"Catalog #"),80);
			gridSupplyMain.Columns.Add(col);
			col=new GridColumn(Lan.g(this,"Description"),340);
			gridSupplyMain.Columns.Add(col);
			col=new GridColumn(Lan.g(this,"Price"),60,HorizontalAlignment.Right);
			gridSupplyMain.Columns.Add(col);
			col=new GridColumn(Lan.g(this,"StockQty"),60,HorizontalAlignment.Center);
			gridSupplyMain.Columns.Add(col);
			gridSupplyMain.ListGridRows.Clear();
			GridRow row;
			for(int i=0;i<_listSupplies.Count;i++) {
				row=new GridRow();
				//Only show category name on the first row of each category
				if(i==0 || _listSupplies[i].Category!=_listSupplies[i-1].Category) {
					row.Cells.Add(Defs.GetName(DefCat.SupplyCats,_listSupplies[i].Category));
				}
				else {
					row.Cells.Add("");
				}
				row.Cells.Add(_listSupplies[i].CatalogNumber);
				row.Cells.Add(_listSupplies[i].Descript);
				if(_listSupplies[i].Price==0) {
					row.Cells.Add("");
				}
				else {
					row.Cells.Add(_listSupplies[i].Price.ToString("n"));
				}
				if(_listSupplies[i].LevelDesired==0) {
					row.Cells.Add("");
				}
				else {
					row.Cells.Add(_listSupplies[i].LevelDesired.ToString());
				}
				gridSupplyMain.ListGridRows.Add(row);
			}
			gridSupplyMain.EndUpdate();
		}

		private void gridSupplyMain_CellDoubleClick(object sender,ODGridClickEventArgs e) {
			using FormSupplyEditS formSupplyEditS=new FormSupplyEditS();
			formSupplyEditS.Supp=_listSupplies[e.Row];
			formSupplyEditS.ListSuppliers=_listSuppliers;
			if(formSupplyEditS.ShowDialog()==DialogResult.OK) {
				//Append to existing selections so multiple items can be selected in one session
				if(!string.IsNullOrEmpty(textQty.Text)) {
					textQty.Text+=";"+formSupplyEditS.dataFormY1;
					textPrice.Text+=";"+formSupplyEditS.dataFormY2;
					textProduct.Text+=";"+formSupplyEditS.dataFormY3;
				}
				else {
					textQty.Text=formSupplyEditS.dataFormY1;
					textPrice.Text=formSupplyEditS.dataFormY2;
					textProduct.Text=formSupplyEditS.dataFormY3;
				}
			}
			FillGridSupplyMain();
		}

		private void butRefresh_Click(object sender,EventArgs e) {
			FillGridSupplyMain();
		}

		private void comboSupplier_SelectionChangeCommitted(object sender,EventArgs e) {
			FillGridSupplyMain();
		}

		private void textFind_KeyDown(object sender,KeyEventArgs e) {
			if(e.KeyCode==Keys.Return) {
				butRefresh_Click(this,new EventArgs());
			}
		}

		private void butOK_Click(object sender,EventArgs e) {
			DialogResult=DialogResult.OK;
			Close();
		}
	}
}
