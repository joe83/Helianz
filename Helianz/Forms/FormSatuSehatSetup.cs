using System;
using System.Windows.Forms;
using CodeBase;
using Helianz.UI;
using HelianzBusiness;
using HelianzBusiness.WebBridges.SatuSehat;

namespace Helianz {
	public partial class FormSatuSehatSetup:FormODBase {
		private SatuSehatConfig _satuSehatConfigCur;

		public FormSatuSehatSetup() {
			InitializeComponent();
			InitializeLayoutManager();
			Lan.F(this);
		}

		private void FormSatuSehatSetup_Load(object sender,EventArgs e) {
			_satuSehatConfigCur=SatuSehatConfigs.GetOne();
			if(_satuSehatConfigCur==null) {
				_satuSehatConfigCur=new SatuSehatConfig();
				_satuSehatConfigCur.IsNew=true;
				_satuSehatConfigCur.Environment=SatuSehatEnvironment.Staging;
			}
			textClientId.Text=_satuSehatConfigCur.ClientId;
			textClientSecret.Text=_satuSehatConfigCur.ClientSecret;
			textOrganizationId.Text=_satuSehatConfigCur.OrganizationId;
			textLocationId.Text=_satuSehatConfigCur.LocationId;
			comboEnvironment.Items.AddEnums<SatuSehatEnvironment>();
			comboEnvironment.SetSelectedEnum(_satuSehatConfigCur.Environment);
			checkIsEnabled.Checked=_satuSehatConfigCur.IsEnabled;
			textNote.Text=_satuSehatConfigCur.Note;
		}

		private void SetConnectionStatus(bool isSuccess,string message="") {
			if(isSuccess) {
				labelConnectionStatus.Text="\u2714 "+( string.IsNullOrEmpty(message) ? "Connected" : message);
				labelConnectionStatus.ForeColor=System.Drawing.Color.FromArgb(0,102,204);//Blue
			}
			else {
				labelConnectionStatus.Text="\u2718 "+(string.IsNullOrEmpty(message) ? "Failed" : message);
				labelConnectionStatus.ForeColor=System.Drawing.Color.Red;
			}
			labelConnectionStatus.Visible=true;
		}

		private void textClientId_TextChanged(object sender,EventArgs e) {
			labelConnectionStatus.Visible=false;
		}

		private void textClientSecret_TextChanged(object sender,EventArgs e) {
			labelConnectionStatus.Visible=false;
		}

		private void butTestConnection_Click(object sender,EventArgs e) {
			if(string.IsNullOrWhiteSpace(textClientId.Text) || string.IsNullOrWhiteSpace(textClientSecret.Text)) {
				MsgBox.Show(this,"Client ID and Client Secret are required.");
				return;
			}
			SatuSehatConfig configTest=new SatuSehatConfig();
			configTest.ClientId=textClientId.Text.Trim();
			configTest.ClientSecret=textClientSecret.Text.Trim();
			configTest.OrganizationId=textOrganizationId.Text.Trim();
			configTest.Environment=comboEnvironment.GetSelected<SatuSehatEnvironment>();
			Cursor=Cursors.WaitCursor;
			labelConnectionStatus.Visible=false;
			try {
				SatuSehatApi api=new SatuSehatApi(configTest);
				string token=api.GetAccessToken();
				Cursor=Cursors.Default;
				if(string.IsNullOrEmpty(token)) {
					SetConnectionStatus(false,"No token returned");
				}
				else {
					SetConnectionStatus(true,"Connected");
				}
			}
			catch(Exception ex) {
				Cursor=Cursors.Default;
				string msg=ex.Message;
				if(msg.Length>60) { msg=msg.Substring(0,60)+"..."; }
				SetConnectionStatus(false,msg);
			}
		}

		private void butSave_Click(object sender,EventArgs e) {
			if(string.IsNullOrWhiteSpace(textClientId.Text)) {
				MsgBox.Show(this,"Client ID is required.");
				return;
			}
			SatuSehatConfig configNew=_satuSehatConfigCur.Copy();
			configNew.ClientId=textClientId.Text.Trim();
			configNew.ClientSecret=textClientSecret.Text.Trim();
			configNew.OrganizationId=textOrganizationId.Text.Trim();
			configNew.LocationId=textLocationId.Text.Trim();
			configNew.Environment=comboEnvironment.GetSelected<SatuSehatEnvironment>();
			configNew.IsEnabled=checkIsEnabled.Checked;
			configNew.Note=textNote.Text;
			if(_satuSehatConfigCur.IsNew) {
				SatuSehatConfigs.Insert(configNew);
			}
			else {
				SatuSehatConfigs.Update(configNew,_satuSehatConfigCur);
			}
			DialogResult=DialogResult.OK;
		}

		private void butCancel_Click(object sender,EventArgs e) {
			DialogResult=DialogResult.Cancel;
		}
	}
}
