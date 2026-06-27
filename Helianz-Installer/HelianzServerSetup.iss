; Helianz Server Setup — Inno Setup 6 script
; ---------------------------------------------------------------------------
; Compile manually:
;   ISCC.exe HelianzServerSetup.iss
;   ISCC.exe HelianzServerSetup.iss /DMyAppVersion=24.1.0
;
; Compiled by Build-HelianzSetup.ps1 (preferred — builds the server first).
;
; Called silently by HelianzInstaller.exe:
;   Setup.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /DIR="<install path>"
;
; NOTE: After copying files, the [Run] section automatically:
;   1. Installs IIS (if absent) via Install-IIS.ps1
;   2. Registers HelianzServer as an IIS Web Application under "Default Web Site" via Register-HelianzServerIIS.ps1.
; ---------------------------------------------------------------------------

#ifndef MyAppVersion
  #define MyAppVersion "1.0"
#endif

#define MyAppName      "Helianz Server"
#define MyAppPublisher "Helianz"
#define SourceDir      "..\Output\HelianzServer"

[Setup]
; NOTE: Do NOT change AppId once released — it identifies this product in the registry.
AppId={{9E4B3C2D-5E6F-7081-9293-B4C5D6E7F8A9}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
; Install as 64-bit so {commonpf} resolves to C:\Program Files on x64 Windows.
; This matches HelianzInstaller textApplicationServer default (_programFiles64\HelianzServer).
ArchitecturesInstallIn64BitMode=x64compatible
DefaultDirName={commonpf}\HelianzServer
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
DisableProgramGroupPage=yes
; Output goes into Helianz-Installer\Release\Helianz Server Setup\
; so HelianzInstaller.exe can find it at startup.
OutputDir=Release\Helianz Server Setup
OutputBaseFilename=Setup
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=admin
DisableFinishedPage=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
; All web service files — always overwrite on upgrade
Source: "{#SourceDir}\*"; DestDir: "{app}"; Excludes: "Web.config,HelianzServerConfig.xml"; Flags: ignoreversion recursesubdirs createallsubdirs
; Web.config may contain site-specific IIS settings — never overwrite on upgrade
Source: "{#SourceDir}\Web.config"; DestDir: "{app}"; Flags: onlyifdoesntexist
; HelianzServerConfig.xml holds the DB connection — never overwrite; skip if not built yet
Source: "{#SourceDir}\HelianzServerConfig.xml"; DestDir: "{app}"; Flags: skipifsourcedoesntexist onlyifdoesntexist
; IIS installation helper script
Source: "Install-IIS.ps1"; DestDir: "{app}"; Flags: ignoreversion
; IIS registration helper script
Source: "Register-HelianzServerIIS.ps1"; DestDir: "{app}"; Flags: ignoreversion
; .NET Framework 4.8 offline installer — extracted to {tmp} and run only if needed
Source: "NDP48-x86-x64-AllOS-ENU.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall nocompression

[Run]
; Install IIS (if not already present) before registering the web application.
; Runs even during silent installs (HelianzInstaller.exe uses /VERYSILENT).
Filename: "powershell.exe"; Parameters: "-NoProfile -ExecutionPolicy Bypass -File ""{app}\Install-IIS.ps1"" -LogDir ""{app}"""; Flags: runhidden waituntilterminated; StatusMsg: "Installing IIS (this may take a few minutes)..."

; Register the web service as an IIS application under Default Web Site.
; Runs even during silent installs (HelianzInstaller.exe uses /VERYSILENT).
Filename: "powershell.exe"; Parameters: "-NoProfile -ExecutionPolicy Bypass -File ""{app}\Register-HelianzServerIIS.ps1"" -InstallDir ""{app}"""; Flags: runhidden; StatusMsg: "Registering HelianzServer in IIS..."

[UninstallRun]
; Remove the IIS web application on uninstall
Filename: "{sys}\inetsrv\appcmd.exe"; Parameters: "delete app ""Default Web Site/HelianzServer"""; Flags: runhidden; RunOnceId: "RemoveIISApp"
; Stop and delete the application pool (only if no other apps are using it)
Filename: "{sys}\inetsrv\appcmd.exe"; Parameters: "stop apppool ""HelianzServerPool"""; Flags: runhidden; RunOnceId: "StopIISPool"
Filename: "{sys}\inetsrv\appcmd.exe"; Parameters: "delete apppool ""HelianzServerPool"""; Flags: runhidden; RunOnceId: "DeleteIISPool"

[Icons]
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

; ---------------------------------------------------------------------------
; Maintenance mode — show Repair / Remove options when app is already installed
; ---------------------------------------------------------------------------
[Code]

// ---------------------------------------------------------------------------
// .NET Framework 4.8 prerequisite check (Windows 7 minimum)
// ---------------------------------------------------------------------------

function IsDotNet48Installed: Boolean;
var
  Release: Cardinal;
begin
  // .NET 4.8 release DWORD >= 528040
  Result := RegQueryDWordValue(HKLM, 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full', 'Release', Release);
  if Result then
    Result := (Release >= 528040);
end;

function InitializeSetup: Boolean;
var
  ResultCode: Integer;
  NetFxPath: String;
begin
  // Minimum OS: Windows 7 (6.1)
  if GetWindowsVersion < $06010000 then
  begin
    SuppressibleMsgBox('This application requires Windows 7 or later.', mbCriticalError, MB_OK, IDOK);
    Result := False;
    Exit;
  end;

  // Check for .NET Framework 4.8
  if not IsDotNet48Installed then
  begin
    if SuppressibleMsgBox(
      'Microsoft .NET Framework 4.8 is required but was not detected on this system.' + #13#10 + #13#10 +
      'Click Yes to install it now (the computer may need to restart afterwards).' + #13#10 +
      'Click No to cancel the installation.',
      mbConfirmation, MB_YESNO, IDYES) = IDYES then
    begin
      ExtractTemporaryFile('NDP48-x86-x64-AllOS-ENU.exe');
      NetFxPath := ExpandConstant('{tmp}\NDP48-x86-x64-AllOS-ENU.exe');
      if Exec(NetFxPath, '/q /norestart', '', SW_SHOW, ewWaitUntilTerminated, ResultCode) then
      begin
        // 0 = success, 1641 = reboot initiated, 3010 = reboot required
        if (ResultCode = 0) or (ResultCode = 1641) or (ResultCode = 3010) then
        begin
          // Re-verify after install
          if not IsDotNet48Installed then
          begin
            SuppressibleMsgBox('.NET Framework 4.8 installation completed but the system still reports it as missing.' + #13#10 +
              'A system restart may be required before proceeding.', mbError, MB_OK, IDOK);
            Result := False;
          end
          else
            Result := True;
        end
        else
        begin
          SuppressibleMsgBox('.NET Framework 4.8 installation failed with exit code ' + IntToStr(ResultCode) + '.',
            mbCriticalError, MB_OK, IDOK);
          Result := False;
        end;
      end
      else
      begin
        SuppressibleMsgBox('Failed to launch the .NET Framework 4.8 installer.', mbCriticalError, MB_OK, IDOK);
        Result := False;
      end;
    end
    else
    begin
      SuppressibleMsgBox('Cannot install Helianz Server without .NET Framework 4.8. Setup will now exit.',
        mbCriticalError, MB_OK, IDOK);
      Result := False;
    end;
    Exit;
  end;

  Result := True;
end;

var
  MaintenancePage: TInputOptionWizardPage;

function GetUninstallString(): String;
var
  sKey: String;
  sVal: String;
begin
  sKey := 'Software\Microsoft\Windows\CurrentVersion\Uninstall\{9E4B3C2D-5E6F-7081-9293-B4C5D6E7F8A9}_is1';
  sVal := '';
  if not RegQueryStringValue(HKLM, sKey, 'UninstallString', sVal) then
    RegQueryStringValue(HKCU, sKey, 'UninstallString', sVal);
  Result := sVal;
end;

function IsUpgrade(): Boolean;
begin
  Result := (GetUninstallString() <> '');
end;

procedure InitializeWizard();
begin
  if IsUpgrade() then
  begin
    MaintenancePage := CreateInputOptionPage(wpWelcome,
      'Maintenance Mode',
      'An existing installation was found',
      '{#MyAppName} is already installed on this computer. Please select an option:',
      True, False);
    MaintenancePage.Add('&Repair  - Reinstall all files, keep existing settings');
    MaintenancePage.Add('&Remove  - Uninstall {#MyAppName} from this computer');
    MaintenancePage.Values[0] := True;
  end;
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := False;
  if MaintenancePage = nil then Exit;
  if PageID = wpWelcome then begin Result := True; Exit; end;
  if MaintenancePage.Values[1] and (PageID <> MaintenancePage.ID) then
    Result := True;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  ResultCode: Integer;
  sPath: String;
begin
  Result := True;
  if (MaintenancePage <> nil) and (CurPageID = MaintenancePage.ID) then
  begin
    if MaintenancePage.Values[1] then
    begin
      if MsgBox('Are you sure you want to remove {#MyAppName}?',
                mbConfirmation, MB_YESNO) = IDNO then
      begin
        Result := False;
        Exit;
      end;
      sPath := RemoveQuotes(GetUninstallString());
      if (sPath <> '') and FileExists(sPath) then
        Exec(sPath, '/SILENT /NORESTART', '', SW_SHOW, ewWaitUntilTerminated, ResultCode)
      else
        MsgBox('Uninstaller not found. Please use Control Panel to remove {#MyAppName}.',
               mbError, MB_OK);
      Result := False;
      WizardForm.Close;
    end;
  end;
end;
