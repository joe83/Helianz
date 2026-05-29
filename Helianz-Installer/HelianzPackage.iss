; HelianzPackage.iss — Self-extracting distribution launcher
; ---------------------------------------------------------------------------
; Bundles the HelianzInstaller.exe and all its supporting files into a single
; executable (HelianzSetup.exe).  When the user runs it:
;   1. All files are extracted to a Windows temp subfolder ({tmp})
;   2. HelianzInstaller.exe is launched and the setup waits for it to close
;   3. The temp folder is automatically deleted when this setup exits
;
; Compile manually:
;   ISCC.exe HelianzPackage.iss
;   ISCC.exe HelianzPackage.iss /DMyAppVersion=24.1.0
;
; Preferred: let Build-HelianzFull.ps1 drive the full pipeline.
; ---------------------------------------------------------------------------

#ifndef MyAppVersion
  #define MyAppVersion "1.0"
#endif

#define MyAppName "Helianz"
#define SourceDir "Release"

[Setup]
AppName={#MyAppName} Setup
AppVersion={#MyAppVersion}
; No install directory — all files land in {tmp} and are cleaned up on exit
CreateAppDir=no
Uninstallable=no
; Output sits alongside the sub-installers in Release\
OutputDir=Release
OutputBaseFilename=HelianzSetup
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=admin
; Suppress all interactive wizard pages — this is a transparent launcher
DisableWelcomePage=yes
DisableDirPage=yes
DisableProgramGroupPage=yes
DisableReadyPage=yes
DisableFinishedPage=yes
ShowLanguageDialog=no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
; Everything in Release\ goes to {tmp}, excluding the output file itself and debug symbols.
; {tmp} is Inno Setup's per-run temp folder and is cleaned up automatically on exit.
Source: "{#SourceDir}\*"; DestDir: "{tmp}"; Excludes: "HelianzSetup.exe,*.pdb"; Flags: ignoreversion recursesubdirs createallsubdirs

[Run]
; Launch HelianzInstaller.exe from the temp folder and wait until the user closes it.
; When HelianzInstaller exits this setup exits too, which triggers {tmp} cleanup.
Filename: "{tmp}\HelianzInstaller.exe"; Flags: waituntilterminated; StatusMsg: "Running Helianz Installer..."
