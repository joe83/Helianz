using System;
using System.Drawing;
using System.Windows.Forms;
using CodeBase;

namespace Helianz {
	public partial class FormQueueTicketPopup : FormODBase {
		public string QueueLabel;
		public string PatientName;
		public string RoomName;
		public string ClinicName;
		public string AppointmentNote;
		public string SelectedColor;
		public bool PrintRequested;

		private ComboBox comboColor;
		private TextBox textCustomColor;
		private Button butPrint;
		private Button butClose;
		private Label labelQueue;
		private Label labelPatient;
		private Label labelRoom;
		private Label labelClinic;
		private Label labelNote;
		private Label labelColor;

		public FormQueueTicketPopup() {
			InitializeComponent();
			Lan.F(this);
		}

		private void InitializeComponent() {
			this.Text="Queue Ticket";
			this.StartPosition=FormStartPosition.CenterScreen;
			this.FormBorderStyle=FormBorderStyle.FixedDialog;
			this.MaximizeBox=false;
			this.MinimizeBox=false;
			this.Size=new Size(340, 330);

			labelQueue=new Label() { Location=new Point(20,15), AutoSize=true, Font=new Font("Arial",18,FontStyle.Bold) };
			labelPatient=new Label() { Location=new Point(20,55), AutoSize=true, Font=new Font("Arial",10) };
			labelRoom=new Label() { Location=new Point(20,75), AutoSize=true, Font=new Font("Arial",9) };
			labelClinic=new Label() { Location=new Point(20,95), AutoSize=true, Font=new Font("Arial",9) };
			labelNote=new Label() { Location=new Point(20,120), AutoSize=true, Font=new Font("Arial",9) };
			labelColor=new Label() { Location=new Point(20,150), AutoSize=true, Text="Color:", Font=new Font("Arial",9) };
			comboColor=new ComboBox() { Location=new Point(80,147), Width=120, DropDownStyle=ComboBoxStyle.DropDown };
			textCustomColor=new TextBox() { Location=new Point(205,147), Width=100 };
			butPrint=new Button() { Location=new Point(60,195), Width=90, Text="Print" };
			butClose=new Button() { Location=new Point(170,195), Width=90, Text="Close" };

			comboColor.Items.AddRange(new object[] { "White","Red","Blue","Green","Yellow","Orange","Pink","Purple","Black","Gray" });
			comboColor.SelectedIndex=0;

			butPrint.Click+=ButPrint_Click;
			butClose.Click+=ButClose_Click;

			this.Controls.Add(labelQueue);
			this.Controls.Add(labelPatient);
			this.Controls.Add(labelRoom);
			this.Controls.Add(labelClinic);
			this.Controls.Add(labelNote);
			this.Controls.Add(labelColor);
			this.Controls.Add(comboColor);
			this.Controls.Add(textCustomColor);
			this.Controls.Add(butPrint);
			this.Controls.Add(butClose);
		}

		public void SetInfo(string queueLabel,string patientName,string roomName,string clinicName,string note) {
			QueueLabel=queueLabel;
			PatientName=patientName;
			RoomName=roomName;
			ClinicName=clinicName;
			AppointmentNote=note;
			labelQueue.Text="Queue: "+queueLabel;
			labelPatient.Text="Patient: "+patientName;
			labelRoom.Text="Room: "+roomName;
			labelClinic.Text="Clinic: "+clinicName;
			labelNote.Text="Note: "+(string.IsNullOrEmpty(note) ? "(none)" : note);
		}

		private void ButPrint_Click(object sender,EventArgs e) {
			SelectedColor=string.IsNullOrWhiteSpace(textCustomColor.Text) ? comboColor.Text : textCustomColor.Text;
			PrintRequested=true;
			this.DialogResult=DialogResult.OK;
			this.Close();
		}

		private void ButClose_Click(object sender,EventArgs e) {
			this.DialogResult=DialogResult.Cancel;
			this.Close();
		}
	}
}
