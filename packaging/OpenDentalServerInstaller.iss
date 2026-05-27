; =============================================================================
;  OpenDental Server - Inno Setup 6 Installer
;
;  Prerequisites:
;    1. Run Build-OpenDentalServer.ps1 first -> populates Output\OpenDentalServer\
;    2. Install Inno Setup 6 (https://jrsoftware.org/isinfo.php)
;    3. Compile this script: iscc OpenDentalServerInstaller.iss
;       Output: ..\Output\Installer\OpenDentalServerSetup-24.3.exe
;
;  What the installer does on the target machine:
;    - Copies pre-built web app files to the install directory
;    - Installs MySQL Community Server 8 via winget (if not present)
;    - Sets MySQL root password to "opendental" and creates the opendental DB
;    - Locks MySQL to localhost (bind-address = 127.0.0.1)
;    - Optionally adds a Windows Firewall rule to block external TCP:3306
;    - Enables required IIS Windows features
;    - Creates the OpenDentalServerPool application pool (.NET 4, 32-bit)
;    - Registers /OpenDentalServer under "Default Web Site"
;    - Writes OpenDentServerConfig.xml with the default credentials
; =============================================================================

#define MyAppName      "OpenDental Server"
#define MyAppVersion   "24.3"
#define MyAppPublisher "Open Dental Software"
#define MyAppURL       "https://www.opendental.com"
#define MyAppGUID      "{{8F3A2B1C-D4E5-4F67-89AB-CDEF01234567}"

[Setup]
AppId={#MyAppGUID}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={commonpf64}\OpenDentalServer
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
; Uncomment if you have a LICENSE file at repo root:
; LicenseFile=..\LICENSE
OutputDir=..\Output\Installer
OutputBaseFilename=OpenDentalServerSetup-{#MyAppVersion}
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=admin
MinVersion=10.0.17763
ArchitecturesInstallIn64BitMode=x64os
UninstallDisplayName={#MyAppName} {#MyAppVersion}
; Keep IIS serving during uninstall before files are removed
CloseApplications=no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "firewall"; Description: "Block MySQL port 3306 from external network access (recommended)"; GroupDescription: "Security:"

[Files]
; --- Pre-built OpenDentalServer web application ---
; Run Build-OpenDentalServer.ps1 before compiling this installer.
Source: "..\Output\OpenDentalServer\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

; --- Baseline database schema (loaded into MySQL on first install) ---
Source: "..\packaging\opendentaldata\mysql.sql"; DestDir: "{tmp}"

; --- Setup helper (called step-by-step from [Code], lives in {tmp} until installer closes) ---
Source: "scripts\Install-Server.ps1"; DestDir: "{tmp}"

[Run]
; --- Pre-requisite: .NET Framework 4.5+ (required for ASP.NET web service) ---
; Skipped automatically if .NET 4.5 or later is already installed.
Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -NonInteractive -Command ""winget install --id Microsoft.DotNet.Framework.DeveloperPack_4 --silent --accept-package-agreements --accept-source-agreements"" "; Check: NeedsDotNetInstall; StatusMsg: "Installing .NET Framework 4.8 (required, this may take several minutes)..."; Flags: runhidden waituntilterminated

; NOTE: MySQL, IIS, and config setup is handled step-by-step via TOutputProgressWizardPage in [Code] / CurStepChanged(ssPostInstall).

[UninstallRun]
; Remove IIS web application, app pool, and optional firewall rule on uninstall.
; Does NOT uninstall MySQL or drop the database (data preservation).
Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -NonInteractive -Command ""Import-Module WebAdministration -ErrorAction SilentlyContinue; Remove-WebApplication -Name 'OpenDentalServer' -Site 'Default Web Site' -ErrorAction SilentlyContinue; Remove-WebAppPool -Name 'OpenDentalServerPool' -ErrorAction SilentlyContinue; Remove-NetFirewallRule -DisplayName 'Block MySQL 3306 (OpenDental)' -ErrorAction SilentlyContinue"""; Flags: runhidden waituntilterminated; RunOnceId: "CleanupIIS"

[Messages]
; Shown at the end of the wizard
FinishedLabel=Setup has finished installing [name] on your computer.%n%nThe middle-tier service is now registered at:%n%n    http://localhost/OpenDentalServer/ServiceMain.asmx%n%nPoint your OpenDental clients to this URL.%n%nIf any step failed, review the log at:%n    %%TEMP%%\OpenDentalServer-install.log

[Code]
// ===========================================================================
// Helper: launch a PowerShell script step and capture its exit code.
//   ShowCmd 0 = hidden (SW_HIDE)
//   ShowCmd 5 = normal visible window (SW_SHOW) — used for MySQL so the user
//               can watch the winget download progress.
// ===========================================================================
function RunPSStep(const ScriptPath, Args: String;
                   const ShowCmd: Integer;
                   out ExitCode: Integer): Boolean;
begin
  Result := Exec(
    'powershell.exe',
    '-NoProfile -ExecutionPolicy Bypass -NonInteractive -File "' + ScriptPath + '" ' + Args,
    '',
    ShowCmd,
    ewWaitUntilTerminated,
    ExitCode);
end;

// Builds the common argument string for Install-Server.ps1
function BuildArgs(const InstallDir, SchemaFile, StepName: String;
                   const AddFirewall: Boolean): String;
begin
  Result := '-InstallDir "' + InstallDir + '"' +
            ' -SchemaFile "' + SchemaFile + '"' +
            ' -Step '        + StepName;
  if AddFirewall then
    Result := Result + ' -AddFirewallRule:$true'
  else
    Result := Result + ' -AddFirewallRule:$false';
end;

// ===========================================================================
// .NET Framework detection  (Release DWORD thresholds: 378389=4.5  528040=4.8)
// ===========================================================================
function GetDotNetRelease: Cardinal;
var
  Release: Cardinal;
begin
  Release := 0;
  RegQueryDWordValue(HKLM,
    'SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full',
    'Release', Release);
  Result := Release;
end;

function NeedsDotNetInstall: Boolean;
begin
  Result := GetDotNetRelease < 378389;
end;

function InitializeSetup: Boolean;
begin
  Result := True;
  if NeedsDotNetInstall then
    MsgBox(
      '.NET Framework 4.8 is required but not found.' + #13#10 +
      'The installer will download it via winget (internet required).' + #13#10 + #13#10 +
      'Click OK to continue.',
      mbInformation, MB_OK);
end;

// ===========================================================================
// Post-install: 6-step progress page
// ssPostInstall fires AFTER [Run] entries and BEFORE the Finish page.
// {tmp} is still valid here; files without deleteafterinstall are present.
// ===========================================================================
procedure DoPostInstall;
var
  ScriptPath, InstallDir, SchemaFile, Args, FailedSteps, LogPath: String;
  ExitCode: Integer;
  AddFirewall: Boolean;
  Page: TOutputProgressWizardPage;
begin
  InstallDir  := ExpandConstant('{app}');
  ScriptPath  := ExpandConstant('{tmp}\Install-Server.ps1');
  SchemaFile  := ExpandConstant('{tmp}\mysql.sql');
  AddFirewall := WizardIsTaskSelected('firewall');
  FailedSteps := '';
  LogPath     := ExpandConstant('{%TEMP%}\OpenDentalServer-install.log');

  Page := CreateOutputProgressPage(
    'Configuring OpenDentalServer',
    'Setting up MySQL, IIS, and server configuration. Please wait...');
  Page.Show;
  try
    // -----------------------------------------------------------------------
    // Step 1 — MySQL install (SW_SHOW so the winget console is visible)
    // -----------------------------------------------------------------------
    Page.SetText(
      'Step 1 of 6 — Installing / locating MySQL Community Server...',
      'A console window will appear showing download progress');
    Page.SetProgress(0, 6);
    Args := BuildArgs(InstallDir, SchemaFile, 'MySQL', AddFirewall);
    RunPSStep(ScriptPath, Args, 5, ExitCode);  // 5 = SW_SHOW
    if ExitCode <> 0 then
      FailedSteps := FailedSteps +
        '  Step 1: MySQL install (exit ' + IntToStr(ExitCode) + ')' + #13#10;

    // -----------------------------------------------------------------------
    // Step 2 — Start MySQL service
    // -----------------------------------------------------------------------
    Page.SetText('Step 2 of 6 — Starting MySQL service...', '');
    Page.SetProgress(1, 6);
    Args := BuildArgs(InstallDir, SchemaFile, 'StartMySQL', AddFirewall);
    RunPSStep(ScriptPath, Args, 0, ExitCode);
    if ExitCode <> 0 then
      FailedSteps := FailedSteps + '  Step 2: MySQL service start' + #13#10;

    // -----------------------------------------------------------------------
    // Step 3 — Configure MySQL (bind-address, root password, create DB)
    // -----------------------------------------------------------------------
    Page.SetText('Step 3 of 6 — Configuring MySQL and creating database...', '');
    Page.SetProgress(2, 6);
    Args := BuildArgs(InstallDir, SchemaFile, 'ConfigMySQL', AddFirewall);
    RunPSStep(ScriptPath, Args, 0, ExitCode);
    if ExitCode <> 0 then
      FailedSteps := FailedSteps + '  Step 3: MySQL configuration / database' + #13#10;

    // -----------------------------------------------------------------------
    // Step 4 — Firewall rule
    // -----------------------------------------------------------------------
    if AddFirewall then
      Page.SetText('Step 4 of 6 — Adding firewall rule (block TCP:3306)...', '')
    else
      Page.SetText('Step 4 of 6 — Skipping firewall (not selected)...', '');
    Page.SetProgress(3, 6);
    Args := BuildArgs(InstallDir, SchemaFile, 'Firewall', AddFirewall);
    RunPSStep(ScriptPath, Args, 0, ExitCode);
    if ExitCode <> 0 then
      FailedSteps := FailedSteps + '  Step 4: Firewall rule' + #13#10;

    // -----------------------------------------------------------------------
    // Step 5 — IIS registration
    // -----------------------------------------------------------------------
    Page.SetText('Step 5 of 6 — Registering OpenDentalServer in IIS...', '');
    Page.SetProgress(4, 6);
    Args := BuildArgs(InstallDir, SchemaFile, 'IIS', AddFirewall);
    RunPSStep(ScriptPath, Args, 0, ExitCode);
    if ExitCode <> 0 then
      FailedSteps := FailedSteps + '  Step 5: IIS registration' + #13#10;

    // -----------------------------------------------------------------------
    // Step 6 — Write OpenDentServerConfig.xml
    // -----------------------------------------------------------------------
    Page.SetText('Step 6 of 6 — Writing server configuration...', '');
    Page.SetProgress(5, 6);
    Args := BuildArgs(InstallDir, SchemaFile, 'Config', AddFirewall);
    RunPSStep(ScriptPath, Args, 0, ExitCode);
    if ExitCode <> 0 then
      FailedSteps := FailedSteps + '  Step 6: Config XML write' + #13#10;

    Page.SetProgress(6, 6);
    if FailedSteps = '' then
      Page.SetText('All steps completed successfully!', '')
    else
      Page.SetText('Completed with errors — see details below', '');
    Sleep(1500);
  finally
    Page.Hide;
  end;

  // Show summary
  if FailedSteps <> '' then
    MsgBox(
      'The following steps reported errors:' + #13#10 + #13#10 +
      FailedSteps + #13#10 +
      'Full log:  ' + LogPath + #13#10 + #13#10 +
      'The IIS endpoint may not be working.' + #13#10 +
      'Fix the issues above, then re-run the installer.',
      mbError, MB_OK)
  else
    MsgBox(
      'OpenDentalServer installed and configured!' + #13#10 + #13#10 +
      'Endpoint:' + #13#10 +
      '  http://localhost/OpenDentalServer/ServiceMain.asmx' + #13#10 + #13#10 +
      'Point your OpenDental clients to this address.',
      mbInformation, MB_OK);
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
    DoPostInstall;
end;
