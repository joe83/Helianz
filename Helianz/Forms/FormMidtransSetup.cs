using System;
using System.Windows.Forms;
using CodeBase;
using HelianzBusiness;

namespace Helianz {
	///<summary>Setup form for configuring Midtrans API credentials per clinic.</summary>
	public partial class FormMidtransSetup:FormODBase {
		private MidtransConfig _midtransConfig;
		///<summary>True if a new record should be inserted; false to update an existing one.</summary>
		private bool _isNew;

		///<summary>Opens the Midtrans setup form.
		///Pass the existing config for the clinic (or null to create a new one).</summary>
		public FormMidtransSetup(MidtransConfig midtransConfig=null) {
			InitializeComponent();
			InitializeLayoutManager();
			Lan.F(this);
			if(midtransConfig==null) {
				_midtransConfig=new MidtransConfig();
				_isNew=true;
			}
			else {
				_midtransConfig=midtransConfig;
				_isNew=false;
			}
		}

		private void FormMidtransSetup_Load(object sender,EventArgs e) {
			MidtransConfigs.EnsureTables();//Create tables if they don't exist yet
			//Fill controls from config
			textServerKey.Text      =_midtransConfig.ServerKey;
			textClientKey.Text      =_midtransConfig.ClientKey;
			textMerchantName.Text   =_midtransConfig.MerchantName;
			textNote.Text           =_midtransConfig.Note;
			checkIsEnabled.Checked  =_midtransConfig.IsEnabled;
			if(_midtransConfig.Environment==MidtransEnvironment.Production) {
				radioProduction.Checked=true;
			}
			else {
				radioSandbox.Checked=true;
			}
		}

		private void butSave_Click(object sender,EventArgs e) {
			if(string.IsNullOrWhiteSpace(textServerKey.Text)) {
				MsgBox.Show(this,"Server Key is required.");
				return;
			}
			if(string.IsNullOrWhiteSpace(textClientKey.Text)) {
				MsgBox.Show(this,"Client Key is required.");
				return;
			}
			_midtransConfig.ServerKey    =textServerKey.Text.Trim();
			_midtransConfig.ClientKey    =textClientKey.Text.Trim();
			_midtransConfig.MerchantName =textMerchantName.Text.Trim();
			_midtransConfig.Note         =textNote.Text;
			_midtransConfig.IsEnabled    =checkIsEnabled.Checked;
			_midtransConfig.Environment  =radioProduction.Checked ? MidtransEnvironment.Production : MidtransEnvironment.Sandbox;
			if(_isNew) {
				MidtransConfigs.Insert(_midtransConfig);
			}
			else {
				MidtransConfigs.Update(_midtransConfig);
			}
			DialogResult=DialogResult.OK;
			Close();
		}

		private void butCancel_Click(object sender,EventArgs e) {
			DialogResult=DialogResult.Cancel;
			Close();
		}
	}
}
