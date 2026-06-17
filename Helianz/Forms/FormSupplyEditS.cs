using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;
using HelianzBusiness;

namespace Helianz {
	public partial class FormSupplyEditS : FormODBase {
		public Supply Supp;
		public List<Supplier> ListSuppliers;

		public string dataFormY1 => textSub.Text;

		public string dataFormY2 => textPrice.Text;

		public string dataFormY3 => textDescript.Text;

		public FormSupplyEditS() {
			InitializeComponent();
			InitializeLayoutManager();
			Lan.F(this);
		}

		private void FormSupplyEditS_Load(object sender,EventArgs e) {
			textSupplier.Text=Suppliers.GetName(ListSuppliers,Supp.SupplierNum);
			comboCategory.Items.AddDefs(Defs.GetDefsForCategory(DefCat.SupplyCats,true));
			comboCategory.SetSelectedDefNum(Supp.Category);
			comboCategory.Enabled=false;
			textCatalogNumber.Text=Supp.CatalogNumber;
			textDescript.Text=Supp.Descript;
			if(Supp.LevelDesired!=0) {
				textLevelDesired.Text=Supp.LevelDesired.ToString();
			}
			if(Supp.Price!=0) {
				textPrice.Text=Supp.Price.ToString("n");
			}
		}

		private void butOK_Click(object sender,EventArgs e) {
			if(!textSub.IsValid()) {
				MsgBox.Show(this,"Please fix data entry errors first.");
				return;
			}
			if(textDescript.Text=="") {
				MsgBox.Show(this,"Please enter a description.");
				return;
			}
			Supp.Category=comboCategory.GetSelectedDefNum();
			Supp.CatalogNumber=textCatalogNumber.Text;
			Supp.Descript=textDescript.Text;
			Supp.Price=PIn.Double(textPrice.Text);
			//Subtract from stock
			float subQty=PIn.Float(textSub.Text);
			Supp.LevelDesired=PIn.Float(textLevelDesired.Text)-subQty;
			if(Supp.IsNew) {
				Supplies.Insert(Supp);
			}
			else {
				Supplies.Update(Supp);
			}
			DialogResult=DialogResult.OK;
		}

		private void butCancel_Click(object sender,EventArgs e) {
			DialogResult=DialogResult.Cancel;
		}
	}
}
