using CodeBase;
using Microsoft.Win32;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.ServiceProcess;

namespace FreeDentalInstaller
{
  public class Utilities
  {
    public static ServiceController GetWindowsService(
      string windowServiceName,
      bool isCaseSensitive = true,
      bool canPartialMatch = false)
    {
      return ServicesHelper.GetServiceByServiceName(windowServiceName, isCaseSensitive, canPartialMatch);
    }

    public static string GetWindowsInstallerPath()
    {
      foreach (ServiceController serviceController in ServicesHelper.GetServicesByExe("msiexec.exe"))
      {
        RegistryKey registryKey = Registry.LocalMachine.OpenSubKey(Path.Combine("System\\CurrentControlSet\\Services\\", serviceController.ServiceName));
        if (registryKey.GetValue("ImagePath") != null)
        {
          string path = registryKey.GetValue("ImagePath").ToString();
          string[] source = path.Split(' ');
          if (source.Length > 0)
            path = source[0];
          if (File.Exists(path))
            return path;
        }
      }
      return "";
    }

    public static CommandResult ProcessCommand(
      string fileName,
      string arguments,
      string fromDir = "")
    {
      return Utilities.GetCommandResult(fileName, arguments, true, fromDir);
    }

    private static CommandResult GetCommandResult(
      string fileName,
      string arguments,
      bool redirectStdOut,
      string fromDir = "")
    {
      CommandResult commandResult = new CommandResult();
      using (Process process = new Process())
      {
        ProcessStartInfo processStartInfo = new ProcessStartInfo(fileName);
        processStartInfo.UseShellExecute = false;
        if (redirectStdOut)
        {
          processStartInfo.RedirectStandardError = true;
          processStartInfo.RedirectStandardOutput = true;
        }
        if (fromDir != "")
          processStartInfo.WorkingDirectory = fromDir;
        processStartInfo.Arguments = arguments;
        process.StartInfo = processStartInfo;
        process.Start();
        process.WaitForExit();
        if (redirectStdOut)
        {
          commandResult.StandardOutput = process.StandardOutput.ReadToEnd();
          commandResult.StandardError = process.StandardError.ReadToEnd();
        }
        commandResult.ExitCode = process.ExitCode;
      }
      return commandResult;
    }

    public static DbmsType GetDbmsType() => DbmsType.MariaDB;
  }
}
