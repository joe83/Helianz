using System;
using System.Windows.Forms;

namespace FreeDentalInstaller
{
  internal static class Program
  {
    [STAThread]
    private static void Main()
    {
      Application.EnableVisualStyles();
      Application.DoEvents();
      Application.Run(new FormMain());
    }
  }
}
