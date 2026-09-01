using System;
using System.Windows.Forms;
using CodeBase;
using Helianz.UI;
using HelianzBusiness;

namespace Helianz {
	public partial class FormIdriveS3Setup : FormODBase {
		public FormIdriveS3Setup() {
			InitializeComponent();
			InitializeLayoutManager();
			Lan.F(this);
		}

		private void FormIdriveS3Setup_Load(object sender, EventArgs e) {
			checkEnable.Checked = PrefC.GetBoolSilent(PrefName.IdriveS3Enabled, false);
			checkShortLink.Checked = PrefC.GetBoolSilent(PrefName.IdriveS3UseShortLink, true);
			textEndpoint.Text = PrefC.GetStringSilent(PrefName.IdriveS3Endpoint);
			textBucket.Text = PrefC.GetStringSilent(PrefName.IdriveS3BucketName);
			textAccessKey.Text = PrefC.GetStringSilent(PrefName.IdriveS3AccessKey);
			textSecretKey.Text = PrefC.GetStringSilent(PrefName.IdriveS3SecretKey);
			string region = PrefC.GetStringSilent(PrefName.IdriveS3Region);
			textRegion.Text = string.IsNullOrWhiteSpace(region) ? "us-east-1" : region;
			textPublicUrl.Text = PrefC.GetStringSilent(PrefName.IdriveS3PublicUrl);
			int expires = PrefC.GetIntSilent(PrefName.IdriveS3ExpiresDays, 7);
			if(expires <= 0 || expires > 7) {
				expires = 7;
			}
			textExpiresDays.Text = expires.ToString();
		}

		private async void butTest_Click(object sender, EventArgs e) {
			if(string.IsNullOrWhiteSpace(textEndpoint.Text) || string.IsNullOrWhiteSpace(textBucket.Text)
				|| string.IsNullOrWhiteSpace(textAccessKey.Text) || string.IsNullOrWhiteSpace(textSecretKey.Text)) 
			{
				MsgBox.Show(this, "Please enter Endpoint, Bucket Name, Access Key, and Secret Key.");
				return;
			}

			Cursor = Cursors.WaitCursor;
			try {
				await IdriveS3Uploader.TestConnectionAsync(
					textEndpoint.Text.Trim(),
					textBucket.Text.Trim(),
					textAccessKey.Text.Trim(),
					textSecretKey.Text.Trim(),
					textRegion.Text.Trim()
				);
				Cursor = Cursors.Default;
				MsgBox.Show(this, "Success! Successfully connected and verified IDrive S3 bucket.");
			}
			catch(Exception ex) {
				Cursor = Cursors.Default;
				FriendlyException.Show("IDrive S3 Connection Test Failed:\n" + ex.Message, ex);
			}
		}

		private void butOK_Click(object sender, EventArgs e) {
			int expiresDays = 7;
			int.TryParse(textExpiresDays.Text, out expiresDays);
			if(expiresDays <= 0 || expiresDays > 7) {
				expiresDays = 7;
			}

			bool hasChanged = false;
			if(Prefs.UpdateBool(PrefName.IdriveS3Enabled, checkEnable.Checked)) {
				hasChanged = true;
			}
			if(Prefs.UpdateBool(PrefName.IdriveS3UseShortLink, checkShortLink.Checked)) {
				hasChanged = true;
			}
			if(Prefs.UpdateString(PrefName.IdriveS3Endpoint, textEndpoint.Text.Trim())) {
				hasChanged = true;
			}
			if(Prefs.UpdateString(PrefName.IdriveS3BucketName, textBucket.Text.Trim())) {
				hasChanged = true;
			}
			if(Prefs.UpdateString(PrefName.IdriveS3AccessKey, textAccessKey.Text.Trim())) {
				hasChanged = true;
			}
			if(Prefs.UpdateString(PrefName.IdriveS3SecretKey, textSecretKey.Text.Trim())) {
				hasChanged = true;
			}
			if(Prefs.UpdateString(PrefName.IdriveS3Region, textRegion.Text.Trim())) {
				hasChanged = true;
			}
			if(Prefs.UpdateString(PrefName.IdriveS3PublicUrl, textPublicUrl.Text.Trim())) {
				hasChanged = true;
			}
			if(Prefs.UpdateInt(PrefName.IdriveS3ExpiresDays, expiresDays)) {
				hasChanged = true;
			}

			if(hasChanged) {
				DataValid.SetInvalid(InvalidType.Prefs);
			}

			DialogResult = DialogResult.OK;
			Close();
		}

		private void butCancel_Click(object sender, EventArgs e) {
			DialogResult = DialogResult.Cancel;
			Close();
		}
	}
}
