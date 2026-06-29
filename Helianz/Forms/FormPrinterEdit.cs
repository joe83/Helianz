using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Drawing.Printing;
using System.Text;
using System.Windows.Forms;
using CodeBase;
using HelianzBusiness;

namespace Helianz {
	public partial class FormPrinterEdit:FormODBase {
		private PrintSituation _printSituation;

		///<summary>Paper preset names in the combo. The index maps to widths/heights below.</summary>
		private static readonly string[] _paperNames = {
			"Default (printer setting)",
			"A4 (210x297 mm)",
			"A5 (148x210 mm)",
			"A6 (105x148 mm)",
			"Letter (8.5x11 in)",
			"Legal (8.5x14 in)"
		};
		private static readonly int[] _paperWidths = { 0, 827, 583, 413, 850, 850 };
		private static readonly int[] _paperHeights = { 0, 1169, 827, 583, 1100, 1400 };

		public FormPrinterEdit(Printer printer) {
			InitializeComponent();
			InitializeLayoutManager();
			Lan.F(this);
			if(ODCloudClient.IsAppStream) {
				labelExtension.Visible=false;
				labelExtensionNote.Visible=false;
				textFileExtension.Visible=false;
				checkVirtualPrinter.Visible=false;
			}
			_printSituation=printer.PrintSit;
			textFileExtension.Text=printer.FileExtension;
			checkPrompt.Checked=printer.DisplayPrompt;
			checkVirtualPrinter.Checked=printer.IsVirtualPrinter;
			textSituation.Text=_printSituation.GetDescription();
			FillComboPrinter(printer.PrinterName);
			FillComboPaper();
		}

		///<summary>Fills the paper size combo from local settings. Stored per-workstation in %AppData%.</summary>
		private void FillComboPaper() {
			comboPaper.Items.Clear();
			foreach(string name in _paperNames) {
				comboPaper.Items.Add(name);
			}
			LocalPrintConfig localConfig=LocalPrintSettings.GetForSit(_printSituation);
			if(localConfig!=null && !localConfig.IsEmpty) {
				int matchedIdx=-1;
				for(int i=1;i<_paperNames.Length;i++) {//Skip index 0 (Default)
					if(_paperWidths[i]==localConfig.PaperWidth && _paperHeights[i]==localConfig.PaperHeight) {
						matchedIdx=i;
						break;
					}
				}
				comboPaper.SelectedIndex=matchedIdx>=0 ? matchedIdx : 0;
			}
			else {
				comboPaper.SelectedIndex=0;//Default
			}
		}

		private void FillComboPrinter(string printerName) {
			PrinterSettings.StringCollection installedPrinters=null;
			try {
				installedPrinters=PrinterSettings.InstalledPrinters;
			}
			catch(Exception ex) {//do not let the window open if printers cannot be accessed
				FriendlyException.Show(Lan.g(this,"Unable to access installed printers."),ex);
				DialogResult=DialogResult.Cancel;
				return;
			}
			comboPrinter.Items.Clear();
			if(_printSituation==PrintSituation.Default){
				comboPrinter.Items.Add(Lan.g(this,"Windows default"));
			}
			else{
				comboPrinter.Items.Add(Lan.g(this,"default"));
			}
			for(int i=0;i<installedPrinters.Count;i++){
				comboPrinter.Items.Add(installedPrinters[i]);
				if(printerName==installedPrinters[i]){
					comboPrinter.SelectedIndex=i+1;
				}
			}
			if(comboPrinter.SelectedIndex==-1){
				comboPrinter.SelectedIndex=0;
			}
		}

		private void butSave_Click(object sender,EventArgs e) {
			string compName=ODEnvironment.MachineName;
			string printerName="";
			bool isChecked=checkPrompt.Checked;
			//PrintSituation sit=PrintSituation.Default;
			//first: main Default, since not in panel Simple
			if(comboPrinter.SelectedIndex>0){
				printerName=comboPrinter.SelectedItem.ToString();
			}
			Printers.PutForSit(_printSituation,compName,printerName,isChecked,isVirtual:checkVirtualPrinter.Checked,fileExtension:textFileExtension.Text);
			//Save paper size to local JSON (per-workstation, not DB)
			SavePaperSize();
			DataValid.SetInvalid(InvalidType.Computers);
			Printers.RefreshCache();//the other computers don't care
			DialogResult=DialogResult.OK;
		}

		///<summary>Saves the selected paper size to the local JSON settings file.</summary>
		private void SavePaperSize() {
			int idx=comboPaper.SelectedIndex;
			if(idx<=0) {
				//Index 0 = "Default" — clear local settings for this situation
				LocalPrintSettings.SetForSit(_printSituation,null);
			}
			else if(idx<_paperWidths.Length) {
				LocalPrintConfig config=new LocalPrintConfig {
					PaperWidth=_paperWidths[idx],
					PaperHeight=_paperHeights[idx],
					PaperName=_paperNames[idx].Split(' ')[0]
				};
				LocalPrintSettings.SetForSit(_printSituation,config);
			}
		}
	}
}