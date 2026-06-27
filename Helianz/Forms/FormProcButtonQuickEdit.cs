using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using HelianzBusiness;

namespace Helianz {
	public partial class FormProcButtonQuickEdit:FormODBase {
		public ProcButtonQuick ProcButtonQuickCur;
		public bool IsNew;


		public FormProcButtonQuickEdit() {
			InitializeComponent();
			InitializeLayoutManager();
			Lan.F(this);
		}

		private void FormProcButtonQuickEdit_Load(object sender,EventArgs e) {
			textDescript.Text=ProcButtonQuickCur.Description;
			textProcedureCode.Text=ProcButtonQuickCur.CodeValue;
			textSurfaces.Text=ProcButtonQuickCur.Surf;
			checkIsLabel.Checked=ProcButtonQuickCur.IsLabel;
			if(Clinics.IsMedicalPracticeOrClinic(Clinics.ClinicNum)) {
				labelSurfaces.Visible=false;
				textSurfaces.Visible=false;
			}
		}

		private void checkIsLabel_CheckedChanged(object sender,EventArgs e) {
			textProcedureCode.Enabled=!checkIsLabel.Checked;
			textSurfaces.Enabled=!checkIsLabel.Checked;
			butPickProc.Enabled=!checkIsLabel.Checked;
		}

		private void butPickProc_Click(object sender,EventArgs e) {
			using FormProcCodes formProcCodes=new FormProcCodes();
			formProcCodes.IsSelectionMode=true;
			formProcCodes.ShowDialog();
			if(formProcCodes.DialogResult!=DialogResult.OK) {
				return;
			}
			textProcedureCode.Text=ProcedureCodes.GetProcCode(formProcCodes.CodeNumSelected).ProcCode;
		}

		private void butDelete_Click(object sender,EventArgs e) {
			if(IsNew) {
				ProcButtonQuickCur=null;
				DialogResult=DialogResult.Cancel;
				return;
			}
			ProcButtonQuicks.Delete(ProcButtonQuickCur.ProcButtonQuickNum);
			ProcButtonQuickCur=null;
			DialogResult=DialogResult.OK;
		}

		private void butSave_Click(object sender,EventArgs e) {
			ProcButtonQuickCur.Description=textDescript.Text;
			ProcButtonQuickCur.CodeValue=textProcedureCode.Text;
			ProcButtonQuickCur.Surf=textSurfaces.Text;
			ProcButtonQuickCur.IsLabel=checkIsLabel.Checked;
			if(!checkIsLabel.Checked && !string.IsNullOrWhiteSpace(textProcedureCode.Text)) {
				//Validate that the procedure code exists and is not in a hidden category.
				long codeNum=ProcedureCodes.GetCodeNum(textProcedureCode.Text);
				if(codeNum==0) {
					MessageBox.Show(this,Lan.g(this,"Procedure code does not exist in database")+": "+textProcedureCode.Text);
					return;
				}
				if(ProcedureCodes.AreAnyProcCodesHidden(codeNum)) {
					MessageBox.Show(this,Lan.g(this,"Cannot use this procedure because it is in a hidden category")+": "+textProcedureCode.Text);
					return;
				}
			}
			if(IsNew) {
				ProcButtonQuicks.Insert(ProcButtonQuickCur);
			}
			else {
				ProcButtonQuicks.Update(ProcButtonQuickCur);
			}
			DialogResult=DialogResult.OK;
		}

	}
}