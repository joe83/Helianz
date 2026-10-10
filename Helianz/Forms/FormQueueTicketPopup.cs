using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;
using CodeBase;
using HelianzBusiness;

namespace Helianz {
	public partial class FormQueueTicketPopup : FormODBase {
		public long AptNum;
		public long PatNum;
		public long OpNum;
		public long ClinicNum;
		public long ProvNum;
		public string QueueLabel = "";
		public string PatientName = "";
		public string RoomName = "";
		public string DoctorName = "";
		public string ClinicName = "";
		public string WaitedTime = "";
		public string AppointmentNote = "";
		public string SelectedColor = "";
		public long CurrentConfirmedDefNum;
		public long NewConfirmedDefNum;
		public bool PrintRequested;
		public bool InRoomRequested;
		public bool StatusChangeRequested;

		private List<Def> _listConfirmedDefs;

		// UI Controls
		private Panel panelHeader;
		private Label labelQueueHero;
		private Label labelPatientHeader;
		private Label labelSubtitle;
		
		private GroupBox groupDetails;
		private Label labelRoomVal;
		private Label labelDoctorVal;
		private Label labelClinicVal;
		private Label labelWaitedVal;
		private Label labelNoteVal;

		private GroupBox groupStatus;
		private ComboBox comboConfirmed;
		private Button butSetInRoom;
		private Label labelColor;
		private ComboBox comboColor;
		private TextBox textCustomColor;

		private Panel panelActions;
		private Button butCall;
		private Button butPrint;
		private Button butSaveStatus;
		private Button butClose;
		private Label labelCallStatus;

		public FormQueueTicketPopup() {
			InitializeComponent();
			Lan.F(this);
		}

		private void InitializeComponent() {
			this.Text = "Manajemen Antrian Pasien";
			this.StartPosition = FormStartPosition.CenterScreen;
			this.FormBorderStyle = FormBorderStyle.FixedDialog;
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.ClientSize = new Size(520, 515);
			this.BackColor = Color.FromArgb(248, 249, 250);

			// --- 1. Header Banner ---
			panelHeader = new Panel() {
				Dock = DockStyle.Top,
				Height = 85,
				BackColor = Color.FromArgb(24, 60, 120),
				Padding = new Padding(15, 10, 15, 10)
			};

			labelQueueHero = new Label() {
				Text = "A-00",
				ForeColor = Color.FromArgb(255, 215, 0),
				Font = new Font("Segoe UI", 24, FontStyle.Bold),
				Location = new Point(18, 12),
				Size = new Size(125, 55),
				TextAlign = ContentAlignment.MiddleLeft
			};

			labelPatientHeader = new Label() {
				Text = "Nama Pasien",
				ForeColor = Color.White,
				Font = new Font("Segoe UI", 12.5f, FontStyle.Bold),
				Location = new Point(150, 15),
				Size = new Size(350, 26),
				AutoEllipsis = true
			};

			labelSubtitle = new Label() {
				Text = "Layanan Antrian Klinik Gigi",
				ForeColor = Color.FromArgb(180, 210, 255),
				Font = new Font("Segoe UI", 9.5f, FontStyle.Regular),
				Location = new Point(150, 44),
				Size = new Size(350, 22),
				AutoEllipsis = true
			};

			panelHeader.Controls.Add(labelQueueHero);
			panelHeader.Controls.Add(labelPatientHeader);
			panelHeader.Controls.Add(labelSubtitle);

			// --- 2. Details GroupBox ---
			groupDetails = new GroupBox() {
				Text = " Detail Kunjungan & Pemeriksaan ",
				Font = new Font("Segoe UI", 9, FontStyle.Bold),
				ForeColor = Color.FromArgb(40, 50, 70),
				Location = new Point(16, 95),
				Size = new Size(488, 165),
				BackColor = Color.White
			};

			Font fontLbl = new Font("Segoe UI", 9, FontStyle.Regular);
			Font fontVal = new Font("Segoe UI", 9, FontStyle.Bold);

			Label lblRoomTitle = new Label() { Text = "Ruang / Poli:", Font = fontLbl, ForeColor = Color.DimGray, Location = new Point(16, 26), Size = new Size(110, 20), TextAlign = ContentAlignment.MiddleLeft };
			labelRoomVal = new Label() { Text = "-", Font = fontVal, Location = new Point(135, 26), Size = new Size(335, 20), TextAlign = ContentAlignment.MiddleLeft, AutoEllipsis = true };

			Label lblDocTitle = new Label() { Text = "Dokter Gigi:", Font = fontLbl, ForeColor = Color.DimGray, Location = new Point(16, 52), Size = new Size(110, 20), TextAlign = ContentAlignment.MiddleLeft };
			labelDoctorVal = new Label() { Text = "-", Font = fontVal, Location = new Point(135, 52), Size = new Size(335, 20), TextAlign = ContentAlignment.MiddleLeft, AutoEllipsis = true };

			Label lblClinicTitle = new Label() { Text = "Klinik Cabang:", Font = fontLbl, ForeColor = Color.DimGray, Location = new Point(16, 78), Size = new Size(110, 20), TextAlign = ContentAlignment.MiddleLeft };
			labelClinicVal = new Label() { Text = "-", Font = fontVal, Location = new Point(135, 78), Size = new Size(335, 20), TextAlign = ContentAlignment.MiddleLeft, AutoEllipsis = true };

			Label lblWaitTitle = new Label() { Text = "Waktu Tunggu:", Font = fontLbl, ForeColor = Color.DimGray, Location = new Point(16, 104), Size = new Size(110, 20), TextAlign = ContentAlignment.MiddleLeft };
			labelWaitedVal = new Label() { Text = "00:00:00", Font = fontVal, ForeColor = Color.FromArgb(190, 50, 30), Location = new Point(135, 104), Size = new Size(335, 20), TextAlign = ContentAlignment.MiddleLeft };

			Label lblNoteTitle = new Label() { Text = "Catatan:", Font = fontLbl, ForeColor = Color.DimGray, Location = new Point(16, 130), Size = new Size(110, 20), TextAlign = ContentAlignment.MiddleLeft };
			labelNoteVal = new Label() { Text = "(tidak ada)", Font = fontLbl, Location = new Point(135, 130), Size = new Size(335, 26), AutoEllipsis = true };

			groupDetails.Controls.Add(lblRoomTitle);
			groupDetails.Controls.Add(labelRoomVal);
			groupDetails.Controls.Add(lblDocTitle);
			groupDetails.Controls.Add(labelDoctorVal);
			groupDetails.Controls.Add(lblClinicTitle);
			groupDetails.Controls.Add(labelClinicVal);
			groupDetails.Controls.Add(lblWaitTitle);
			groupDetails.Controls.Add(labelWaitedVal);
			groupDetails.Controls.Add(lblNoteTitle);
			groupDetails.Controls.Add(labelNoteVal);

			// --- 3. Status & Options GroupBox ---
			groupStatus = new GroupBox() {
				Text = " Status Pasien & Opsi Cetak ",
				Font = new Font("Segoe UI", 9, FontStyle.Bold),
				ForeColor = Color.FromArgb(40, 50, 70),
				Location = new Point(16, 270),
				Size = new Size(488, 115),
				BackColor = Color.White
			};

			Label lblStatusTitle = new Label() { Text = "Status Pasien:", Font = fontLbl, ForeColor = Color.DimGray, Location = new Point(16, 28), Size = new Size(110, 22), TextAlign = ContentAlignment.MiddleLeft };
			comboConfirmed = new ComboBox() {
				Location = new Point(135, 26),
				Size = new Size(195, 25),
				DropDownStyle = ComboBoxStyle.DropDownList,
				Font = new Font("Segoe UI", 9)
			};

			butSetInRoom = new Button() {
				Text = "🚪 Masuk Ruang",
				Location = new Point(340, 24),
				Size = new Size(130, 28),
				BackColor = Color.FromArgb(230, 245, 235),
				ForeColor = Color.FromArgb(20, 120, 50),
				Font = new Font("Segoe UI", 9, FontStyle.Bold),
				FlatStyle = FlatStyle.Flat,
				Cursor = Cursors.Hand
			};
			butSetInRoom.FlatAppearance.BorderColor = Color.FromArgb(140, 200, 160);
			butSetInRoom.Click += ButSetInRoom_Click;

			labelColor = new Label() { Text = "Warna Orto:", Font = fontLbl, ForeColor = Color.DimGray, Location = new Point(16, 68), Size = new Size(110, 22), TextAlign = ContentAlignment.MiddleLeft };
			comboColor = new ComboBox() {
				Location = new Point(135, 66),
				Size = new Size(135, 25),
				DropDownStyle = ComboBoxStyle.DropDownList,
				Font = new Font("Segoe UI", 9)
			};
			comboColor.Items.AddRange(new object[] { "White", "Red", "Blue", "Green", "Yellow", "Orange", "Pink", "Purple", "Black", "Gray" });
			comboColor.SelectedIndex = 0;

			textCustomColor = new TextBox() {
				Location = new Point(280, 66),
				Size = new Size(190, 25),
				Font = new Font("Segoe UI", 9),
				Text = ""
			};

			groupStatus.Controls.Add(lblStatusTitle);
			groupStatus.Controls.Add(comboConfirmed);
			groupStatus.Controls.Add(butSetInRoom);
			groupStatus.Controls.Add(labelColor);
			groupStatus.Controls.Add(comboColor);
			groupStatus.Controls.Add(textCustomColor);

			// --- Call Status Message Banner ---
			labelCallStatus = new Label() {
				Text = "",
				Font = new Font("Segoe UI", 9, FontStyle.Bold),
				ForeColor = Color.FromArgb(20, 120, 40),
				Location = new Point(16, 395),
				Size = new Size(488, 22),
				TextAlign = ContentAlignment.MiddleCenter
			};

			// --- 4. Action Buttons ---
			panelActions = new Panel() {
				Dock = DockStyle.Bottom,
				Height = 65,
				BackColor = Color.FromArgb(235, 238, 242),
				Padding = new Padding(15, 12, 15, 12)
			};

			butCall = new Button() {
				Text = "🔊 Panggil Pasien",
				Font = new Font("Segoe UI", 9.5f, FontStyle.Bold),
				ForeColor = Color.White,
				BackColor = Color.FromArgb(0, 122, 255),
				Size = new Size(150, 38),
				Location = new Point(16, 12),
				FlatStyle = FlatStyle.Flat,
				Cursor = Cursors.Hand
			};
			butCall.FlatAppearance.BorderSize = 0;
			butCall.Click += ButCall_Click;

			butPrint = new Button() {
				Text = "🖨️ Cetak Slip",
				Font = new Font("Segoe UI", 9, FontStyle.Regular),
				ForeColor = Color.FromArgb(40, 40, 40),
				BackColor = Color.White,
				Size = new Size(105, 38),
				Location = new Point(176, 12),
				FlatStyle = FlatStyle.Flat,
				Cursor = Cursors.Hand
			};
			butPrint.FlatAppearance.BorderColor = Color.FromArgb(200, 205, 215);
			butPrint.Click += ButPrint_Click;

			butSaveStatus = new Button() {
				Text = "💾 Simpan",
				Font = new Font("Segoe UI", 9, FontStyle.Regular),
				ForeColor = Color.FromArgb(40, 40, 40),
				BackColor = Color.White,
				Size = new Size(95, 38),
				Location = new Point(291, 12),
				FlatStyle = FlatStyle.Flat,
				Cursor = Cursors.Hand
			};
			butSaveStatus.FlatAppearance.BorderColor = Color.FromArgb(200, 205, 215);
			butSaveStatus.Click += ButSaveStatus_Click;

			butClose = new Button() {
				Text = "Tutup",
				Font = new Font("Segoe UI", 9, FontStyle.Regular),
				ForeColor = Color.FromArgb(80, 80, 80),
				BackColor = Color.FromArgb(240, 240, 240),
				Size = new Size(95, 38),
				Location = new Point(396, 12),
				FlatStyle = FlatStyle.Flat,
				Cursor = Cursors.Hand
			};
			butClose.FlatAppearance.BorderColor = Color.FromArgb(210, 210, 210);
			butClose.Click += ButClose_Click;

			panelActions.Controls.Add(butCall);
			panelActions.Controls.Add(butPrint);
			panelActions.Controls.Add(butSaveStatus);
			panelActions.Controls.Add(butClose);

			this.Controls.Add(panelHeader);
			this.Controls.Add(groupDetails);
			this.Controls.Add(groupStatus);
			this.Controls.Add(labelCallStatus);
			this.Controls.Add(panelActions);
		}

		public void SetInfo(long aptNum, string queueLabel, string patientName, string roomName, string doctorName, string clinicName, string waitedTime, string note, long currentConfirmedDefNum, long opNum = 0, long clinicNum = 0, long provNum = 0) {
			AptNum = aptNum;
			QueueLabel = queueLabel;
			PatientName = patientName;
			RoomName = roomName;
			DoctorName = doctorName;
			ClinicName = clinicName;
			WaitedTime = waitedTime;
			AppointmentNote = note;
			CurrentConfirmedDefNum = currentConfirmedDefNum;
			OpNum = opNum;
			ClinicNum = clinicNum;
			ProvNum = provNum;

			labelQueueHero.Text = string.IsNullOrWhiteSpace(queueLabel) ? $"#{aptNum}" : queueLabel;
			labelPatientHeader.Text = patientName;
			labelSubtitle.Text = $"Klinik: {clinicName}";

			labelRoomVal.Text = string.IsNullOrWhiteSpace(roomName) ? "(belum diatur)" : roomName;
			labelDoctorVal.Text = string.IsNullOrWhiteSpace(doctorName) ? "(dokter gigi)" : doctorName;
			labelClinicVal.Text = string.IsNullOrWhiteSpace(clinicName) ? "(klinik utama)" : clinicName;
			labelWaitedVal.Text = string.IsNullOrWhiteSpace(waitedTime) ? "00:00:00" : waitedTime;
			labelNoteVal.Text = string.IsNullOrWhiteSpace(note) ? "(tidak ada)" : note;

			// Populate Confirmed Status
			_listConfirmedDefs = Defs.GetDefsForCategory(DefCat.ApptConfirmed, true);
			comboConfirmed.Items.Clear();
			int selectedIdx = -1;
			for (int i = 0; i < _listConfirmedDefs.Count; i++) {
				comboConfirmed.Items.Add(_listConfirmedDefs[i].ItemName);
				if (_listConfirmedDefs[i].DefNum == currentConfirmedDefNum) {
					selectedIdx = i;
				}
			}
			if (selectedIdx >= 0) {
				comboConfirmed.SelectedIndex = selectedIdx;
			}
			else if (comboConfirmed.Items.Count > 0) {
				comboConfirmed.SelectedIndex = 0;
			}
		}

		///<summary>Legacy helper for backward compatibility</summary>
		public void SetInfo(string queueLabel, string patientName, string roomName, string clinicName, string note) {
			SetInfo(0, queueLabel, patientName, roomName, "", clinicName, "", note, 0);
		}

		private void ButCall_Click(object sender, EventArgs e) {
			if (AptNum <= 0) {
				MsgBox.Show(this, "Data appointment tidak valid.");
				return;
			}
			try {
				bool success = Appointments.CallQueuePatient(AptNum, OpNum, ClinicNum, RoomName);
				if (success) {
					labelCallStatus.ForeColor = Color.FromArgb(20, 130, 40);
					labelCallStatus.Text = $"✓ Suara Panggilan ({labelQueueHero.Text}) Terkirim ke Layar TV!";
					butCall.BackColor = Color.FromArgb(30, 160, 60);
					butCall.Text = "🔊 Panggil Ulang";
				} else {
					labelCallStatus.ForeColor = Color.FromArgb(200, 50, 40);
					labelCallStatus.Text = "Gagal memanggil pasien.";
				}
			} catch (Exception ex) {
				labelCallStatus.ForeColor = Color.FromArgb(200, 50, 40);
				labelCallStatus.Text = "Error panggil: " + ex.Message;
			}
		}

		private void ButSetInRoom_Click(object sender, EventArgs e) {
			long defNumSeated = PrefC.GetLong(PrefName.AppointmentTimeSeatedTrigger);
			if (defNumSeated == 0) {
				// Fallback to searching defs for "In Room" or "Seated"
				foreach (var def in _listConfirmedDefs) {
					if (def.ItemName.ToLower().Contains("in room") || def.ItemName.ToLower().Contains("seated") || def.ItemName.ToLower().Contains("ruang")) {
						defNumSeated = def.DefNum;
						break;
					}
				}
			}
			if (defNumSeated != 0) {
				NewConfirmedDefNum = defNumSeated;
			} else if (comboConfirmed.SelectedIndex >= 0 && comboConfirmed.SelectedIndex < _listConfirmedDefs.Count) {
				NewConfirmedDefNum = _listConfirmedDefs[comboConfirmed.SelectedIndex].DefNum;
			}
			InRoomRequested = true;
			StatusChangeRequested = true;
			this.DialogResult = DialogResult.OK;
			this.Close();
		}

		private void ButPrint_Click(object sender, EventArgs e) {
			SelectedColor = string.IsNullOrWhiteSpace(textCustomColor.Text) ? comboColor.Text : textCustomColor.Text;
			PrintRequested = true;
			this.DialogResult = DialogResult.OK;
			this.Close();
		}

		private void ButSaveStatus_Click(object sender, EventArgs e) {
			if (comboConfirmed.SelectedIndex >= 0 && comboConfirmed.SelectedIndex < _listConfirmedDefs.Count) {
				NewConfirmedDefNum = _listConfirmedDefs[comboConfirmed.SelectedIndex].DefNum;
				StatusChangeRequested = true;
			}
			this.DialogResult = DialogResult.OK;
			this.Close();
		}

		private void ButClose_Click(object sender, EventArgs e) {
			this.DialogResult = DialogResult.Cancel;
			this.Close();
		}
	}
}
