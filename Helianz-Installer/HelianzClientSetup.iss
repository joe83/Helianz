; Helianz Client Setup — Inno Setup 6 script
; ---------------------------------------------------------------------------
; Compile manually:
;   ISCC.exe HelianzClientSetup.iss
;   ISCC.exe HelianzClientSetup.iss /DMyAppVersion=24.1.0
;
; Compiled by Build-HelianzSetup.ps1 (preferred — builds the app first).
;
; Called silently by HelianzInstaller.exe:
;   Setup.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /DIR="<install path>"
; ---------------------------------------------------------------------------

#ifndef MyAppVersion
  #define MyAppVersion "1.0"
#endif

#define MyAppName      "Helianz"
#define MyAppPublisher "Helianz"
#define MyAppExeName   "Helianz.exe"
#define SourceDir      "..\Output\Helianz"

[Setup]
; NOTE: Do NOT change AppId once released — it identifies this product in the registry.
AppId={{8F3A2B1C-4D5E-6F70-8192-A3B4C5D6E7F8}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
; Default install dir matches HelianzInstaller textApplication default (Program Files x86)
DefaultDirName={commonpf32}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
; Output goes into the Helianz-Installer\Release\Helianz Client Setup\ folder
; so HelianzInstaller.exe can find it at startup.
OutputDir=Release\Helianz Client Setup
OutputBaseFilename=Setup
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=admin
DisableFinishedPage=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; All binaries and resources — always overwrite on upgrade
; Logger\ contains runtime log files; tempCompNames.txt is a dev artifact — exclude both.
Source: "{#SourceDir}\*"; DestDir: "{app}"; Excludes: "FreeDentalConfig.xml,Logger,tempCompNames.txt"; Flags: ignoreversion recursesubdirs createallsubdirs
; FreeDentalConfig.xml stores the user's database connection — never overwrite on upgrade
; Source is the installer-directory copy (not the build output), so it survives a clean build.
Source: "FreeDentalConfig.xml"; DestDir: "{app}"; Flags: onlyifdoesntexist

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

; ---------------------------------------------------------------------------
; Maintenance mode — show Repair / Remove options when app is already installed
; ---------------------------------------------------------------------------
[Code]
var
  MaintenancePage: TInputOptionWizardPage;

function GetUninstallString(): String;
var
  sKey: String;
  sVal: String;
begin
  sKey := 'Software\Microsoft\Windows\CurrentVersion\Uninstall\{8F3A2B1C-4D5E-6F70-8192-A3B4C5D6E7F8}_is1';
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
  // Skip Welcome so the maintenance page is shown first
  if PageID = wpWelcome then begin Result := True; Exit; end;
  // If Remove is selected, skip every page except the maintenance page itself
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
      // Remove selected
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
    // Repair: Result stays True, normal installation proceeds
  end;
end;
