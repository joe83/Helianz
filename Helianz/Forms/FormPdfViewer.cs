using System;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Windows.Forms;
using CodeBase;
using CodeBase.Controls;
using Helianz.UI;
using Helianz.Thinfinity;
using HelianzBusiness;

namespace Helianz {
	public partial class FormPdfViewer : FormODBase {
		public string PdfFilePath;
		public Statement StatementCur;
		public Patient PatientCur;
		public Sheet SheetCur;
		public DataSet DataSet_;

		public FormPdfViewer() {
			InitializeComponent();
			InitializeLayoutManager();
			Lan.F(this);
		}

		private async void FormPdfViewer_Load(object sender, EventArgs e) {
			if(StatementCur != null) {
				Text = Lan.g(this, "Statement Preview") + " - " + StatementCur.DateSent.ToShortDateString();
			}
			else {
				Text = Lan.g(this, "PDF Preview");
			}

			if(string.IsNullOrEmpty(PdfFilePath) || !File.Exists(PdfFilePath)) {
				lblFallback.Text = Lans.g(this, "PDF file was not found.");
				lblFallback.Visible = true;
				return;
			}

			try {
				if(!ODBuild.IsThinfinity()) {
					if(_odWebView2.CoreWebView2 == null) {
						await _odWebView2.Init();
					}
					_odWebView2.ODWebView2Navigate(PdfFilePath);
				}
				else {
					ThinfinityUtils.HandleFile(PdfFilePath);
				}
			}
			catch(Exception) {
				lblFallback.Text = Lans.g(this, "Embedded preview is unavailable. You can still Print, Save, or Share below.");
				lblFallback.Visible = true;
				butOpenExternal.Visible = true;
			}
		}

		private void butPrint_Click(object sender, EventArgs e) {
			if(SheetCur != null) {
				SheetPrinting.Print(SheetCur, DataSet_, 1, false, StatementCur);
				return;
			}

			if(!string.IsNullOrEmpty(PdfFilePath) && File.Exists(PdfFilePath)) {
				try {
					FileAtoZ.StartProcess(PdfFilePath);
				}
				catch(Exception ex) {
					FriendlyException.Show(Lans.g(this, "Unable to print file:") + " " + PdfFilePath, ex);
				}
			}
		}

		private void butSaveFile_Click(object sender, EventArgs e) {
			if(string.IsNullOrEmpty(PdfFilePath) || !File.Exists(PdfFilePath)) {
				MsgBox.Show(this, "No PDF file available to save.");
				return;
			}

			using SaveFileDialog saveFileDialog = new SaveFileDialog();
			saveFileDialog.Filter = "PDF Files (*.pdf)|*.pdf|All Files (*.*)|*.*";
			string sanitizedPatName = "Patient";
			if(PatientCur != null) {
				sanitizedPatName = PatientCur.GetNameLF().Replace(" ", "_").Replace(",", "").Replace("/", "_");
			}
			saveFileDialog.FileName = $"Statement_{sanitizedPatName}_{DateTime.Today:yyyyMMdd}.pdf";

			if(saveFileDialog.ShowDialog() == DialogResult.OK) {
				try {
					File.Copy(PdfFilePath, saveFileDialog.FileName, true);
					MsgBox.Show(this, "Statement file saved successfully.");
				}
				catch(Exception ex) {
					FriendlyException.Show(Lans.g(this, "Unable to save file: ") + ex.Message, ex);
				}
			}
		}

		private void butWhatsApp_Click(object sender, EventArgs e) {
			Patient patient = PatientCur;
			if(patient == null && StatementCur != null && StatementCur.PatNum != 0) {
				patient = Patients.GetPat(StatementCur.PatNum);
			}

			string rawPhone = "";
			if(patient != null) {
				rawPhone = patient.WirelessPhone;
				if(string.IsNullOrWhiteSpace(rawPhone) && patient.Guarantor != 0 && patient.Guarantor != patient.PatNum) {
					Patient guarantor = Patients.GetPat(patient.Guarantor);
					rawPhone = guarantor?.WirelessPhone;
				}
				if(string.IsNullOrWhiteSpace(rawPhone)) {
					rawPhone = patient.HmPhone;
				}
				if(string.IsNullOrWhiteSpace(rawPhone)) {
					rawPhone = patient.WkPhone;
				}
			}

			// Normalize phone number to local Indonesian format (starts with '0') for display/editing
			string localPhone = new string((rawPhone ?? "").Where(char.IsDigit).ToArray());
			if(localPhone.StartsWith("62") && localPhone.Length > 2) {
				localPhone = "0" + localPhone.Substring(2);
			}
			else if(localPhone.StartsWith("8")) {
				localPhone = "0" + localPhone;
			}

			// Auto-copy the PDF file to Windows clipboard as a File Drop list
			// This enables instant Ctrl+V attachment in WhatsApp Web / WhatsApp Desktop.
			if(!string.IsNullOrEmpty(PdfFilePath) && File.Exists(PdfFilePath)) {
				try {
					string cleanFileName = $"Statement_{patient?.GetNameLF().Replace(" ", "_").Replace(",", "").Replace("/", "_") ?? "Patient"}_{DateTime.Today:yyyyMMdd}.pdf";
					string tempNamedPdf = Path.Combine(PrefC.GetTempFolderPath(), cleanFileName);
					File.Copy(PdfFilePath, tempNamedPdf, true);
					System.Collections.Specialized.StringCollection fileList = new System.Collections.Specialized.StringCollection();
					fileList.Add(tempNamedPdf);
					Clipboard.SetFileDropList(fileList);
				}
				catch {
					try {
						System.Collections.Specialized.StringCollection fileList = new System.Collections.Specialized.StringCollection();
						fileList.Add(PdfFilePath);
						Clipboard.SetFileDropList(fileList);
					}
					catch { }
				}
			}

			string promptInstruction = Lans.g(this, "Nomor WhatsApp Pasien:\n\n* File PDF telah otomatis disalin ke clipboard.\n  Silakan tekan Ctrl+V pada chat WhatsApp untuk melampirkan file PDF.");
			InputBox inputBox = new InputBox(promptInstruction, localPhone);
			inputBox.ShowDialog();
			if(inputBox.IsDialogCancel) {
				return;
			}

			// Retrieve the text entered from InputBox.StringResult
			string enteredPhone = inputBox.StringResult;
			string cleanPhone = new string((enteredPhone ?? "").Where(char.IsDigit).ToArray());
			if(string.IsNullOrWhiteSpace(cleanPhone)) {
				MsgBox.Show(this, Lans.g(this, "Nomor telepon tidak boleh kosong."));
				return;
			}

			// Normalize to international prefix (62) for WhatsApp Web URL
			if(cleanPhone.StartsWith("0")) {
				cleanPhone = "62" + cleanPhone.Substring(1);
			}
			else if(cleanPhone.StartsWith("8")) {
				cleanPhone = "62" + cleanPhone;
			}

			string clinicName = Clinics.GetClinic(patient?.ClinicNum ?? 0)?.Description;
			if(string.IsNullOrWhiteSpace(clinicName)) {
				clinicName = PrefC.GetString(PrefName.PracticeTitle);
			}
			string patName = patient != null ? patient.GetNameFirstOrPreferred() : "";
			string balanceStr = StatementCur != null ? StatementCur.BalTotal.ToString("N0") : "0";
			string stmtDate = StatementCur != null ? StatementCur.DateSent.ToShortDateString() : DateTime.Today.ToShortDateString();

			string message = $"Halo {patName},\n\nBerikut terlampir rincian tagihan / statement dari {clinicName} per tanggal {stmtDate}:\nTotal: Rp {balanceStr}\n\nTerima kasih.";

			string encodedMsg = Uri.EscapeDataString(message);
			string waUrl = $"https://web.whatsapp.com/send?phone={cleanPhone}&text={encodedMsg}";

			try {
				Process.Start(new ProcessStartInfo(waUrl) { UseShellExecute = true });
			}
			catch {
				try {
					string fallbackUrl = $"https://wa.me/{cleanPhone}?text={encodedMsg}";
					Process.Start(new ProcessStartInfo(fallbackUrl) { UseShellExecute = true });
				}
				catch(Exception ex) {
					FriendlyException.Show(Lans.g(this, "Unable to open browser for WhatsApp"), ex);
				}
			}
		}

		private void butOpenExternal_Click(object sender, EventArgs e) {
			if(!string.IsNullOrEmpty(PdfFilePath) && File.Exists(PdfFilePath)) {
				try {
					FileAtoZ.StartProcess(PdfFilePath);
				}
				catch(Exception ex) {
					FriendlyException.Show(Lans.g(this, "Unable to open file:") + " " + PdfFilePath, ex);
				}
			}
		}

		private void butClose_Click(object sender, EventArgs e) {
			DialogResult = DialogResult.OK;
			Close();
		}
	}
}
