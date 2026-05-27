#Requires -Version 5.1
<#
.SYNOPSIS
	Builds the OpenDentalServer (middle-tier) ASP.NET Web Service, publishes it to a
	dedicated output folder, and registers it as an IIS Web Application / IIS Windows
	Service so it is runnable as a cloud-server application.

.DESCRIPTION
	Steps performed:
	  1. Locate MSBuild
	  2. Restore NuGet packages
	  3. Build & publish the OpenDentalServer project
	  4. Copy published files to the output folder
	  5. (Optional) Register the site in IIS as a Web Application under the
		 Default Web Site (or a dedicated site), and create an IIS Application Pool.

	Run as Administrator when using the -RegisterIIS or -RegisterService switches.

.PARAMETER Configuration
	Build configuration: Debug or Release (default: Release)

.PARAMETER Platform
	Build platform: x86 or AnyCPU (default: x86)

.PARAMETER OutputDir
	Root folder where the published web application will be placed.
	Default: .\Output\OpenDentalServer

.PARAMETER IISSiteName
	Name of the IIS site that will host OpenDentalServer.
	Default: "Default Web Site"

.PARAMETER IISAppName
	Virtual path / application name under the IIS site.
	Default: OpenDentalServer

.PARAMETER IISPort
	TCP port for a *new* dedicated IIS site (only used when -CreateDedicatedSite is set).
	Default: 8080

.PARAMETER AppPoolName
	IIS Application Pool name. Default: OpenDentalServerPool

.PARAMETER RegisterIIS
	Switch: when set, creates/updates the IIS Application Pool and Web Application.
	Requires running as Administrator and IIS installed.

.PARAMETER CreateDedicatedSite
	Switch: when set together with -RegisterIIS, creates a brand-new IIS site instead
	of adding an application under an existing site.

.PARAMETER MsBuildPath
	Full path to MSBuild.exe. Auto-detected from Visual Studio if not provided.

.PARAMETER ConfigureServer
	Switch: when set, opens an interactive dialog to configure the MySQL database
	connection and middle-tier port, then writes OpenDentalServerConfig.xml to the
	output folder. Existing credential values in the source config are shown as
	defaults; leave a password field blank to keep the existing value.

.PARAMETER MySqlHost
	MySQL / MariaDB server hostname or IP. Used as the default in the configuration
	dialog when -ConfigureServer is set. Default: localhost.

.PARAMETER MySqlDatabase
	MySQL database name. Used as the default in the dialog. Default: opendental.

.PARAMETER MySqlUser
	MySQL admin (read/write) username. Used as the default in the dialog.

.PARAMETER MySqlUserLow
	MySQL low-privilege (read-only) username. Leave blank to skip that entry.

.PARAMETER ServerPort
	Middle-tier ServerPort written into OpenDentalServerConfig.xml. Default: 9390.

.PARAMETER BackupDir
	Folder where timestamped config backups (and optional output-dir archives)
	are stored. Default: .\ConfigBackups

.PARAMETER BackupOutputDir
	Switch: when set, archives the current contents of -OutputDir into -BackupDir
	before overwriting with the new build.

.EXAMPLE
	# Build only
	.\Build-OpenDentalServer.ps1

	# Build + register in IIS (run as Administrator)
	.\Build-OpenDentalServer.ps1 -RegisterIIS

	# Build + register in IIS + configure DB connection interactively (run as Administrator)
	.\Build-OpenDentalServer.ps1 -RegisterIIS -ConfigureServer

	# Build + configure DB + backup existing output dir before overwriting
	.\Build-OpenDentalServer.ps1 -ConfigureServer -BackupOutputDir

	# Build + create a dedicated IIS site on port 8080 (run as Administrator)
	.\Build-OpenDentalServer.ps1 -RegisterIIS -CreateDedicatedSite -IISPort 8080
#>
param(
	[ValidateSet('Debug','Release')]
	[string]$Configuration = 'Release',

	[ValidateSet('x86','AnyCPU')]
	[string]$Platform = 'x86',

	[string]$OutputDir = "$PSScriptRoot\Output\OpenDentalServer",

	[string]$IISSiteName = 'Default Web Site',

	[string]$IISAppName = 'OpenDentalServer',

	[int]$IISPort = 8080,

	[string]$AppPoolName = 'OpenDentalServerPool',

	[switch]$RegisterIIS,

	[switch]$CreateDedicatedSite,

	# --- Interactive configuration & backup ---
	[switch]$ConfigureServer,

	[string]$MySqlHost = '',

	[string]$MySqlDatabase = '',

	[string]$MySqlUser = '',

	[string]$MySqlUserLow = '',

	[int]$ServerPort = 9390,

	[string]$BackupDir = "$PSScriptRoot\ConfigBackups",

	[switch]$BackupOutputDir,

	[string]$MsBuildPath = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Helper: Locate MSBuild
# ---------------------------------------------------------------------------
function Find-MsBuild {
	$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
	if (-not (Test-Path $vswhere)) {
		$vswhere = "${env:ProgramFiles}\Microsoft Visual Studio\Installer\vswhere.exe"
	}
	if (Test-Path $vswhere) {
		$vsPath = & $vswhere -latest -products * -requires Microsoft.Component.MSBuild -property installationPath 2>$null
		if ($vsPath) {
			$candidate = Join-Path $vsPath 'MSBuild\Current\Bin\MSBuild.exe'
			if (Test-Path $candidate) { return $candidate }
		}
	}

	$candidates = @(
		"${env:ProgramFiles}\Microsoft Visual Studio\2026\Community\MSBuild\Current\Bin\MSBuild.exe",
		"${env:ProgramFiles}\Microsoft Visual Studio\2026\Professional\MSBuild\Current\Bin\MSBuild.exe",
		"${env:ProgramFiles}\Microsoft Visual Studio\2026\Enterprise\MSBuild\Current\Bin\MSBuild.exe",
		"${env:ProgramFiles}\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe",
		"${env:ProgramFiles}\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe",
		"${env:ProgramFiles}\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe",
		"${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\MSBuild.exe",
		"${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\MSBuild.exe",
		"${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\MSBuild.exe"
	)
	foreach ($c in $candidates) {
		if (Test-Path $c) { return $c }
	}
	throw "MSBuild.exe not found. Install Visual Studio or specify -MsBuildPath."
}

# ---------------------------------------------------------------------------
# Helper: Require Administrator for IIS operations
# ---------------------------------------------------------------------------
function Assert-Administrator {
	$id = [Security.Principal.WindowsIdentity]::GetCurrent()
	$p  = New-Object Security.Principal.WindowsPrincipal($id)
	if (-not $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
		throw "The -RegisterIIS switch requires running PowerShell as Administrator."
	}
}

# ---------------------------------------------------------------------------
# Helper: Ensure IIS Windows Features are installed, then load the module
# ---------------------------------------------------------------------------
function Assert-IISInstalled {
	# Check if WebAdministration module is already loadable
	if (Get-Module -ListAvailable -Name WebAdministration -ErrorAction SilentlyContinue) {
		return  # already installed
	}

	Write-Host "  IIS / WebAdministration module not found." -ForegroundColor DarkYellow
	Write-Host "  Attempting to install required Windows Features (IIS)..." -ForegroundColor Yellow

	# Determine if we are on a Server OS or Desktop OS
	$os = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
	$isServer = $os -and ($os.ProductType -ne 1)   # 1 = Workstation, 2/3 = Server/DC

	if ($isServer) {
		# Windows Server - use Add-WindowsFeature (ServerManager)
		Import-Module ServerManager -ErrorAction Stop
		$features = @(
			'Web-Server',           # IIS base
			'Web-WebServer',
			'Web-Common-Http',
			'Web-Asp-Net45',        # ASP.NET 4.x
			'Web-ISAPI-Ext',
			'Web-ISAPI-Filter',
			'Web-Mgmt-Console',     # IIS Manager
			'Web-Scripting-Tools'   # WebAdministration PowerShell module
		)
		Write-Host "  Installing Server features: $($features -join ', ')" -ForegroundColor DarkCyan
		$result = Add-WindowsFeature -Name $features -IncludeManagementTools
		if (-not $result.Success) {
			throw "Failed to install IIS Windows Features. Run Windows Update or install IIS manually."
		}
		Write-Host "  IIS features installed successfully." -ForegroundColor Green
		if ($result.RestartNeeded -eq 'Yes') {
			Write-Host "  [WARN] A restart is required to complete IIS installation." -ForegroundColor DarkYellow
		}
	} else {
		# Windows 10/11 Desktop - use DISM / Enable-WindowsOptionalFeature
		# Order matters: parents must come before children.
		# The -All switch auto-enables parent features, so we use it to be safe.
		$features = @(
			'IIS-WebServerRole',            # top-level parent - must be first
			'IIS-WebServer',
			'IIS-CommonHttpFeatures',
			'IIS-DefaultDocument',
			'IIS-StaticContent',
			'IIS-HttpErrors',
			'IIS-HttpLogging',
			'IIS-ApplicationDevelopment',
			'IIS-ISAPIExtensions',
			'IIS-ISAPIFilter',
			'IIS-ASPNET45',
			'IIS-NetFxExtensibility45',
			'IIS-ManagementConsole',
			'IIS-ManagementScriptingTools'  # installs WebAdministration module
		)
		foreach ($f in $features) {
			$state = Get-WindowsOptionalFeature -Online -FeatureName $f -ErrorAction SilentlyContinue
			if ($null -eq $state) {
				Write-Host "  [SKIP] Feature not available on this edition: $f" -ForegroundColor DarkGray
				continue
			}
			if ($state.State -ne 'Enabled') {
				Write-Host "  Enabling: $f" -ForegroundColor DarkCyan
				# -All ensures parent features are also enabled automatically
				Enable-WindowsOptionalFeature -Online -FeatureName $f -All -NoRestart -ErrorAction Stop | Out-Null
			}
		}
		Write-Host "  IIS optional features enabled." -ForegroundColor Green
	}
}

function Import-WebAdministration {
	Assert-IISInstalled

	# Refresh module path after potential installation
	if (-not (Get-Module -Name WebAdministration -ErrorAction SilentlyContinue)) {
		# Try explicit path used on both Server and Desktop
		$modulePaths = @(
			"$env:SystemRoot\system32\WindowsPowerShell\v1.0\Modules\WebAdministration\WebAdministration.psd1",
			"$env:ProgramFiles\IIS\PowerShellSnapIn\WebAdministration.psd1"
		)
		$loaded = $false
		foreach ($mp in $modulePaths) {
			if (Test-Path $mp) {
				Import-Module $mp -ErrorAction Stop
				$loaded = $true
				break
			}
		}
		if (-not $loaded) {
			Import-Module WebAdministration -ErrorAction Stop
		}
	}
}

function Assert-AspNetRegistered {
	# Ensure IIS-ASPNET45 Windows feature is enabled so that .asmx / ASP.NET
	# handler mappings exist in applicationHost.config.
	$os = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
	$isServer = $os -and ($os.ProductType -ne 1)
	$featuresChanged = $false

	if ($isServer) {
		$feat = Get-WindowsFeature -Name 'Web-Asp-Net45' -ErrorAction SilentlyContinue
		if ($feat -and $feat.InstallState -ne 'Installed') {
			Write-Host "  Installing IIS feature: Web-Asp-Net45..." -ForegroundColor DarkCyan
			Add-WindowsFeature -Name 'Web-Asp-Net45' -IncludeAllSubFeature | Out-Null
			Write-Host "  Web-Asp-Net45 installed." -ForegroundColor Green
			$featuresChanged = $true
		}
	} else {
		foreach ($f in @('IIS-ASPNET45', 'IIS-NetFxExtensibility45', 'IIS-ISAPIExtensions', 'IIS-ISAPIFilter')) {
			$state = Get-WindowsOptionalFeature -Online -FeatureName $f -ErrorAction SilentlyContinue
			if ($state -and $state.State -ne 'Enabled') {
				Write-Host "  Enabling IIS feature: $f..." -ForegroundColor DarkCyan
				Enable-WindowsOptionalFeature -Online -FeatureName $f -All -NoRestart -ErrorAction Stop | Out-Null
				Write-Host "  $f enabled." -ForegroundColor Green
				$featuresChanged = $true
			}
		}
	}

	if ($featuresChanged) {
		# Handler mappings are added by enabling the features above.
		# On Windows Server, aspnet_regiis may also be needed; on Win10/11 it is
		# deprecated - the DISM feature enable is sufficient and correct.
		if ($isServer) {
			$aspnetRegiis = "$env:SystemRoot\Microsoft.NET\Framework\v4.0.30319\aspnet_regiis.exe"
			if (Test-Path $aspnetRegiis) {
				Write-Host "  Registering ASP.NET 4.x handlers (aspnet_regiis -iru)..." -ForegroundColor DarkCyan
				& $aspnetRegiis -iru 2>&1 | Out-Null
			}
		}
		# Restart IIS so new handler mappings take effect immediately.
		Write-Host "  Restarting IIS to apply new handler mappings..." -ForegroundColor DarkCyan
		& "$env:SystemRoot\System32\inetsrv\appcmd.exe" stop site "Default Web Site" 2>&1 | Out-Null
		net stop W3SVC 2>&1 | Out-Null
		net start W3SVC 2>&1 | Out-Null
		& "$env:SystemRoot\System32\inetsrv\appcmd.exe" start site "Default Web Site" 2>&1 | Out-Null
		Write-Host "  IIS restarted." -ForegroundColor Green
	} else {
		Write-Host "  ASP.NET 4.5 IIS features already enabled." -ForegroundColor DarkGray
	}
}

function Get-OpenDentalServerConfigSourcePath {
	$preferredPaths = @(
		(Join-Path $PSScriptRoot 'OpenDentalServerConfig.xml'),
		(Join-Path $PSScriptRoot 'OpenDentServerConfig.xml')
	)
	foreach ($path in $preferredPaths) {
		if (Test-Path $path) {
			return $path
		}
	}
	return $null
}

function Get-SiteBaseUrl {
	param(
		[string]$SiteName
	)

	$site = Get-Website -Name $SiteName -ErrorAction SilentlyContinue
	if (-not $site) {
		return 'http://localhost'
	}
	$binding = $site.Bindings.Collection | Where-Object { $_.protocol -eq 'http' } | Select-Object -First 1
	if (-not $binding) {
		$binding = $site.Bindings.Collection | Select-Object -First 1
	}
	if (-not $binding) {
		return 'http://localhost'
	}
	$bindingParts = $binding.bindingInformation.Split(':')
	$ip = if ($bindingParts.Length -gt 0) { $bindingParts[0] } else { '' }
	$port = if ($bindingParts.Length -gt 1) { $bindingParts[1] } else { '' }
	$hostHeader = if ($bindingParts.Length -gt 2) { $bindingParts[2] } else { '' }
	$scheme = if ($binding.protocol) { $binding.protocol } else { 'http' }
	$urlHost = if (-not [string]::IsNullOrWhiteSpace($hostHeader)) {
		$hostHeader
	} elseif (-not [string]::IsNullOrWhiteSpace($ip) -and $ip -ne '*' -and $ip -ne '0.0.0.0' -and $ip -ne '[::]') {
		$ip
	} else {
		'localhost'
	}
	$baseUrl = "${scheme}://${urlHost}"
	if (-not [string]::IsNullOrWhiteSpace($port) -and $port -ne '80' -and $port -ne '443') {
		$baseUrl = "${baseUrl}:$port"
	}
	return $baseUrl.TrimEnd('/')
}

# ---------------------------------------------------------------------------
# Helper: Read a password securely (prompt + optional confirmation)
# ---------------------------------------------------------------------------
function Read-SecurePassword {
	param(
		[string]$Prompt,
		[switch]$Confirm
	)
	while ($true) {
		$ss = Read-Host -Prompt $Prompt -AsSecureString
		$plain = [Runtime.InteropServices.Marshal]::PtrToStringBSTR(
			[Runtime.InteropServices.Marshal]::SecureStringToBSTR($ss))
		if (-not $Confirm) { return $plain }
		$ss2  = Read-Host -Prompt "Confirm $Prompt" -AsSecureString
		$plain2 = [Runtime.InteropServices.Marshal]::PtrToStringBSTR(
			[Runtime.InteropServices.Marshal]::SecureStringToBSTR($ss2))
		if ($plain -eq $plain2) { return $plain }
		Write-Host "  Passwords do not match. Please try again." -ForegroundColor Red
	}
}

# ---------------------------------------------------------------------------
# Helper: Parse an existing OpenDentalServerConfig.xml into a PSCustomObject
# ---------------------------------------------------------------------------
function Read-ExistingServerConfig {
	param([string]$XmlPath)
	if (-not $XmlPath -or -not (Test-Path $XmlPath)) { return $null }
	try {
		[xml]$xml = Get-Content $XmlPath -Encoding UTF8
		$conn = $xml.SelectSingleNode('//DatabaseConnection')
		return [PSCustomObject]@{
			ServerPort  = if ($xml.ConnectionSettings.ServerPort) { [int]$xml.ConnectionSettings.ServerPort } else { 9390 }
			Host        = if ($conn -and $conn.ComputerName) { $conn.ComputerName.Trim() } else { 'localhost' }
			Database    = if ($conn -and $conn.Database)      { $conn.Database.Trim() }      else { 'opendental' }
			User        = if ($conn -and $conn.User)           { $conn.User.Trim() }           else { 'root' }
			Password    = if ($conn -and $conn.SelectSingleNode('Password'))    { $conn.SelectSingleNode('Password').InnerText.Trim() }    else { '' }
			UserLow     = if ($conn -and $conn.UserLow)        { $conn.UserLow.Trim() }        else { '' }
			PasswordLow = if ($conn -and $conn.SelectSingleNode('PasswordLow')) { $conn.SelectSingleNode('PasswordLow').InnerText.Trim() } else { '' }
		}
	} catch {
		Write-Host "  [WARN] Could not parse existing config: $_" -ForegroundColor DarkYellow
		return $null
	}
}

# ---------------------------------------------------------------------------
# Helper: Interactive dialog - collect server / DB connection settings
# ---------------------------------------------------------------------------
function Invoke-ServerConfigDialog {
	param(
		[string]$ParamHost,
		[string]$ParamDatabase,
		[string]$ParamUser,
		[string]$ParamUserLow,
		[int]   $ParamPort,
		[string]$ExistingConfigPath
	)

	$existing = Read-ExistingServerConfig -XmlPath $ExistingConfigPath

	Write-Host ""
	Write-Host "  --------------------------------------------------------" -ForegroundColor Cyan
	Write-Host "  OpenDentalServer Configuration Setup" -ForegroundColor Cyan
	Write-Host "  --------------------------------------------------------" -ForegroundColor Cyan
	Write-Host "  Press Enter to accept the [default] value shown." -ForegroundColor DarkGray
	Write-Host "  For password fields, press Enter to keep the existing value." -ForegroundColor DarkGray
	Write-Host ""

	# Inner helper: prompt with default
	function p {
		param([string]$Label, [string]$Param, [string]$Existing, [string]$Fallback)
		$default = if (-not [string]::IsNullOrWhiteSpace($Param))     { $Param }
		           elseif (-not [string]::IsNullOrWhiteSpace($Existing)) { $Existing }
		           else                                                    { $Fallback }
		$displayDefault = if ($default) { " [$default]" } else { '' }
		$val = Read-Host -Prompt "  $Label$displayDefault"
		if ([string]::IsNullOrWhiteSpace($val)) { return $default }
		return $val.Trim()
	}

	# --- Middle-tier port ---
	$existingPort = if ($existing) { $existing.ServerPort } else { 9390 }
	$portStr   = p -Label 'Middle-tier ServerPort' -Param $(if ($ParamPort -gt 0) { "$ParamPort" } else { '' }) -Existing "$existingPort" -Fallback '9390'
	$resolvedPort = 9390
	[int]::TryParse($portStr, [ref]$resolvedPort) | Out-Null

	Write-Host ""
	Write-Host "  --- MySQL / Database Connection ---" -ForegroundColor DarkCyan

	$resolvedHost = p -Label 'MySQL Host'     -Param $ParamHost     -Existing $(if ($existing) { $existing.Host }     else { '' }) -Fallback 'localhost'
	$resolvedDb   = p -Label 'Database Name'  -Param $ParamDatabase  -Existing $(if ($existing) { $existing.Database } else { '' }) -Fallback 'opendental'

	Write-Host ""
	Write-Host "  --- Admin (Read/Write) User ---" -ForegroundColor DarkCyan

	$resolvedUser = p -Label 'Admin User' -Param $ParamUser -Existing $(if ($existing) { $existing.User } else { '' }) -Fallback 'root'

	$newPwd = Read-SecurePassword -Prompt '  Admin Password (Enter to keep existing)'
	$resolvedPwd = if (-not [string]::IsNullOrEmpty($newPwd)) { $newPwd }
	               elseif ($existing) { $existing.Password; Write-Host "  (admin password unchanged)" -ForegroundColor DarkGray }
	               else { '' }

	Write-Host ""
	Write-Host "  --- Low-Privilege (Read-Only) User ---" -ForegroundColor DarkCyan
	Write-Host "  Leave blank to omit the low-privilege account." -ForegroundColor DarkGray

	$resolvedUserLow = p -Label 'Low-Privilege User' -Param $ParamUserLow -Existing $(if ($existing) { $existing.UserLow } else { '' }) -Fallback ''

	$resolvedPwdLow = ''
	if (-not [string]::IsNullOrWhiteSpace($resolvedUserLow)) {
		$newPwdLow = Read-SecurePassword -Prompt '  Low-Privilege Password (Enter to keep existing)'
		$resolvedPwdLow = if (-not [string]::IsNullOrEmpty($newPwdLow)) { $newPwdLow }
		                  elseif ($existing) { $existing.PasswordLow; Write-Host "  (low password unchanged)" -ForegroundColor DarkGray }
		                  else { '' }
	}

	Write-Host ""
	return [PSCustomObject]@{
		ServerPort  = $resolvedPort
		Host        = $resolvedHost
		Database    = $resolvedDb
		User        = $resolvedUser
		Password    = $resolvedPwd
		UserLow     = $resolvedUserLow
		PasswordLow = $resolvedPwdLow
	}
}

# ---------------------------------------------------------------------------
# Helper: Write OpenDentalServerConfig.xml from a config object
# ---------------------------------------------------------------------------
function Write-ServerConfigXml {
	param(
		[PSCustomObject]$Config,
		[string]$DestinationPath
	)
	$esc = { param($s) [System.Security.SecurityElement]::Escape($s) }
	$lines = [System.Collections.Generic.List[string]]::new()
	$lines.Add('<?xml version="1.0"?>')
	$lines.Add('<ConnectionSettings>')
	$lines.Add("	<ServerPort>$($Config.ServerPort)</ServerPort>")
	$lines.Add("	<DatabaseConnection>")
	$lines.Add("		<ComputerName>$(& $esc $Config.Host)</ComputerName>")
	$lines.Add("		<Database>$(& $esc $Config.Database)</Database>")
	$lines.Add("		<User>$(& $esc $Config.User)</User>")
	$lines.Add("		<Password>$(& $esc $Config.Password)</Password>")
	$lines.Add("		<UserLow>$(& $esc $Config.UserLow)</UserLow>")
	$lines.Add("		<PasswordLow>$(& $esc $Config.PasswordLow)</PasswordLow>")
	$lines.Add("	</DatabaseConnection>")
	$lines.Add('</ConnectionSettings>')
	Set-Content -Path $DestinationPath -Value $lines -Encoding UTF8
}

# ---------------------------------------------------------------------------
# Helper: Backup a single file with a timestamp suffix
# ---------------------------------------------------------------------------
function Invoke-ConfigBackup {
	param([string]$SourcePath, [string]$BackupDir)
	if (-not (Test-Path $SourcePath)) { return }
	if (-not (Test-Path $BackupDir)) { New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null }
	$ts   = Get-Date -Format 'yyyyMMdd_HHmmss'
	$base = [System.IO.Path]::GetFileNameWithoutExtension($SourcePath)
	$ext  = [System.IO.Path]::GetExtension($SourcePath)
	$dest = Join-Path $BackupDir "${base}_${ts}${ext}"
	Copy-Item -Path $SourcePath -Destination $dest -Force
	Write-Host "  [Backup] $SourcePath  ->  $dest" -ForegroundColor DarkGray
}

# ---------------------------------------------------------------------------
# Helper: Archive the output directory before overwriting
# ---------------------------------------------------------------------------
function Invoke-OutputDirBackup {
	param([string]$OutputDir, [string]$BackupDir)
	if (-not (Test-Path $OutputDir)) { return }
	if (-not (Test-Path $BackupDir)) { New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null }
	$ts   = Get-Date -Format 'yyyyMMdd_HHmmss'
	$dest = Join-Path $BackupDir "OpenDentalServer_$ts"
	Write-Host "  [Backup] Archiving output dir -> $dest" -ForegroundColor DarkGray
	Copy-Item -Path $OutputDir -Destination $dest -Recurse -Force
	Write-Host "  [Backup] Archive complete." -ForegroundColor DarkGray
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
$stopwatch = [Diagnostics.Stopwatch]::StartNew()

Write-Host ""
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  OpenDentalServer (Middle-Tier) Build Script" -ForegroundColor Cyan
Write-Host "  Configuration : $Configuration" -ForegroundColor Cyan
Write-Host "  Platform      : $Platform" -ForegroundColor Cyan
Write-Host "  Output Dir    : $OutputDir" -ForegroundColor Cyan
if ($RegisterIIS) {
	Write-Host "  IIS Site      : $IISSiteName" -ForegroundColor Cyan
	Write-Host "  IIS App       : $IISAppName" -ForegroundColor Cyan
	Write-Host "  App Pool      : $AppPoolName" -ForegroundColor Cyan
}
if ($ConfigureServer) {
	Write-Host "  Configure DB  : YES (interactive dialog)" -ForegroundColor Cyan
}
if ($BackupOutputDir) {
	Write-Host "  Backup Dir    : $BackupDir" -ForegroundColor Cyan
}
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

if ($RegisterIIS) { Assert-Administrator }

# ---------------------------------------------------------------------------
# Step 1 - Locate MSBuild
# ---------------------------------------------------------------------------
if (-not $MsBuildPath) { $MsBuildPath = Find-MsBuild }
Write-Host "[INFO] Using MSBuild: $MsBuildPath" -ForegroundColor Green

$projectFile = Join-Path $PSScriptRoot "OpenDentalServer\OpenDentalServer.csproj"
if (-not (Test-Path $projectFile)) {
	throw "Project not found: $projectFile"
}

# Publish profile temp directory and known PackageTmp fallback
$publishDir    = Join-Path $PSScriptRoot "_publish_OpenDentalServer"
$packageTmpDir = Join-Path $PSScriptRoot "OpenDentalServer\obj\$Platform\$Configuration\Package\PackageTmp"
$fallbackPublishDir = Join-Path $PSScriptRoot "_publish_OpenDentalServer_fallback"

# ---------------------------------------------------------------------------
# Step 2 - Restore NuGet packages
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "[STEP 1/4] Restoring NuGet packages..." -ForegroundColor Yellow

$sln = Get-ChildItem -Path $PSScriptRoot -Filter "*.sln" -File | Select-Object -First 1
if ($sln) {
	& $MsBuildPath $sln.FullName /t:Restore /p:Configuration=$Configuration /p:Platform=$Platform /verbosity:minimal
	if ($LASTEXITCODE -ne 0) { throw "NuGet restore failed." }
} else {
	Write-Host "[WARN] No .sln found; skipping NuGet restore." -ForegroundColor DarkYellow
}

# ---------------------------------------------------------------------------
# Step 3 - Build & Publish
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "[STEP 2/4] Building and publishing OpenDentalServer ($Configuration)..." -ForegroundColor Yellow

# Clean temp publish directory
if (Test-Path $publishDir) { Remove-Item $publishDir -Recurse -Force }
New-Item -ItemType Directory -Path $publishDir -Force | Out-Null

$buildArgs = @(
	$projectFile,
	"/t:Clean;Build",
	"/p:Configuration=$Configuration",
	"/p:Platform=$Platform",
	"/p:DeployOnBuild=true",
	"/p:WebPublishMethod=FileSystem",
	"/p:PublishUrl=`"$publishDir`"",
	"/p:DeleteExistingFiles=True",
	"/m",
	"/verbosity:minimal",
	"/fl",
	"/flp:LogFile=`"$PSScriptRoot\build-opendentalserver.log`";Verbosity=normal"
)

& $MsBuildPath @buildArgs
if ($LASTEXITCODE -ne 0) {
	Write-Host ""
	Write-Error "Build FAILED. Check build-opendentalserver.log for details."
	exit 1
}

Write-Host "[INFO] Build & publish succeeded." -ForegroundColor Green

# ---------------------------------------------------------------------------
# Step 4 - Copy published output to dedicated output folder
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "[STEP 3/4] Copying published files to output folder..." -ForegroundColor Yellow

$configSourcePath = Get-OpenDentalServerConfigSourcePath
$preservedConfigPath = $null

if (-not $configSourcePath -and (Test-Path (Join-Path $OutputDir 'OpenDentalServerConfig.xml'))) {
	$preservedConfigPath = Join-Path $PSScriptRoot '_publish_OpenDentalServer_config.xml'
	Copy-Item -Path (Join-Path $OutputDir 'OpenDentalServerConfig.xml') -Destination $preservedConfigPath -Force
}

if (-not (Test-Path $OutputDir)) {
	New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

if (Test-Path $fallbackPublishDir) {
	Remove-Item $fallbackPublishDir -Recurse -Force
}

# Determine actual source: prefer explicit FileSystem publish dir,
# fall back to PackageTmp produced by the Web Deploy package pipeline.
$sourceDir = $null
if (Test-Path "$publishDir\Web.config") {
	$sourceDir = $publishDir
} elseif (Test-Path "$packageTmpDir\Web.config") {
	Write-Host "[INFO] Using PackageTmp output: $packageTmpDir" -ForegroundColor DarkCyan
	$sourceDir = $packageTmpDir
} else {
	# Last resort: assemble a deployable web root from project content + bin output.
	$binFallback = Join-Path $PSScriptRoot "OpenDentalServer\bin"
	if (Test-Path "$binFallback\OpenDentalServer.dll") {
		Write-Host "[WARN] Publish output not found; assembling fallback web root from project files." -ForegroundColor DarkYellow
		New-Item -ItemType Directory -Path $fallbackPublishDir -Force | Out-Null
		New-Item -ItemType Directory -Path (Join-Path $fallbackPublishDir 'bin') -Force | Out-Null
		Copy-Item -Path "$binFallback\*" -Destination (Join-Path $fallbackPublishDir 'bin') -Recurse -Force
		Copy-Item -Path (Join-Path $PSScriptRoot 'OpenDentalServer\ServiceMain.asmx') -Destination $fallbackPublishDir -Force
		Copy-Item -Path (Join-Path $PSScriptRoot 'OpenDentalServer\Web.config') -Destination $fallbackPublishDir -Force
		$appDataDir = Join-Path $PSScriptRoot 'OpenDentalServer\App_Data'
		if (Test-Path $appDataDir) {
			Copy-Item -Path $appDataDir -Destination $fallbackPublishDir -Recurse -Force
		}
		$sourceDir = $fallbackPublishDir
	}
}

if (-not $sourceDir) {
	Write-Error "Could not locate published output. Check build-opendentalserver.log for details."
	exit 1
}

if (-not (Test-Path (Join-Path $sourceDir 'Web.config')) -or -not (Test-Path (Join-Path $sourceDir 'ServiceMain.asmx'))) {
	Write-Error "Deployment source is incomplete. Expected Web.config and ServiceMain.asmx in: $sourceDir"
	exit 1
}

if (Test-Path $OutputDir) {
	if ($BackupOutputDir) {
		Write-Host "  Backing up existing output directory..." -ForegroundColor DarkGray
		Invoke-OutputDirBackup -OutputDir $OutputDir -BackupDir $BackupDir
	}
	Get-ChildItem -Path $OutputDir -Force | Remove-Item -Recurse -Force
}

Copy-Item -Path "$sourceDir\*" -Destination $OutputDir -Recurse -Force

$targetConfigPath = Join-Path $OutputDir 'OpenDentalServerConfig.xml'

# Back up the existing deployed config (if any) before deciding what to write
if (Test-Path $targetConfigPath) {
	Invoke-ConfigBackup -SourcePath $targetConfigPath -BackupDir $BackupDir
}

if ($ConfigureServer) {
	# Prefer the source-tree config as the starting point for defaults;
	# fall back to whatever is already in the output folder.
	$dialogSeedPath = if ($configSourcePath) { $configSourcePath }
	                  elseif ($preservedConfigPath -and (Test-Path $preservedConfigPath)) { $preservedConfigPath }
	                  else { $targetConfigPath }

	$serverCfg = Invoke-ServerConfigDialog `
		-ParamHost      $MySqlHost `
		-ParamDatabase  $MySqlDatabase `
		-ParamUser      $MySqlUser `
		-ParamUserLow   $MySqlUserLow `
		-ParamPort      $ServerPort `
		-ExistingConfigPath $dialogSeedPath

	Write-ServerConfigXml -Config $serverCfg -DestinationPath $targetConfigPath
	Write-Host "[INFO] OpenDentalServerConfig.xml written with configured settings." -ForegroundColor Green
} elseif ($configSourcePath) {
	Copy-Item -Path $configSourcePath -Destination $targetConfigPath -Force
	Write-Host "[INFO] Copied config file to: $targetConfigPath" -ForegroundColor DarkCyan
} elseif ($preservedConfigPath -and (Test-Path $preservedConfigPath)) {
	Copy-Item -Path $preservedConfigPath -Destination $targetConfigPath -Force
	Write-Host "[INFO] Preserved existing OpenDentalServerConfig.xml" -ForegroundColor DarkCyan
} else {
	Write-Host "[WARN] No OpenDentalServerConfig.xml source found. The middle tier will not connect to MySQL until this file is added." -ForegroundColor DarkYellow
	Write-Host "[TIP]  Re-run with -ConfigureServer to set up the database connection interactively." -ForegroundColor DarkYellow
}

# Clean up temp publish directory
Remove-Item $publishDir -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item $fallbackPublishDir -Recurse -Force -ErrorAction SilentlyContinue
if ($preservedConfigPath) {
	Remove-Item $preservedConfigPath -Force -ErrorAction SilentlyContinue
}

Write-Host "[INFO] Files copied to: $OutputDir" -ForegroundColor Green

# ---------------------------------------------------------------------------
# Step 5 - Register in IIS (optional)
# ---------------------------------------------------------------------------
if ($RegisterIIS) {
	Write-Host ""
	Write-Host "[STEP 4/4] Registering OpenDentalServer in IIS..." -ForegroundColor Yellow
	$url = ''

	Import-WebAdministration
	Assert-AspNetRegistered

	# --- Application Pool ---
	if (-not (Test-Path "IIS:\AppPools\$AppPoolName")) {
		Write-Host "  Creating Application Pool: $AppPoolName" -ForegroundColor DarkCyan
		New-WebAppPool -Name $AppPoolName | Out-Null
	} else {
		Write-Host "  Application Pool already exists: $AppPoolName" -ForegroundColor DarkGray
	}

	# Configure pool: .NET CLR v4, Integrated pipeline, always-running
	$pool = Get-Item "IIS:\AppPools\$AppPoolName"
	$pool.managedRuntimeVersion = 'v4.0'
	$pool.managedPipelineMode   = 'Integrated'
	$pool.startMode             = 'AlwaysRunning'
	$pool.enable32BitAppOnWin64 = ($Platform -eq 'x86')
	$pool.processModel.idleTimeout = [TimeSpan]::Zero
	$pool | Set-Item

	Write-Host "  App Pool configured: .NET v4.0, Integrated, AlwaysRunning, 32-bit=$($Platform -eq 'x86')" -ForegroundColor DarkCyan

	if ($CreateDedicatedSite) {
		# --- Create a brand-new IIS site ---
		if (Get-Website -Name $IISAppName -ErrorAction SilentlyContinue) {
			Write-Host "  IIS site '$IISAppName' already exists - updating physical path." -ForegroundColor DarkGray
			Set-ItemProperty "IIS:\Sites\$IISAppName" -Name physicalPath -Value $OutputDir
			Set-ItemProperty "IIS:\Sites\$IISAppName" -Name applicationPool -Value $AppPoolName
		} else {
			Write-Host "  Creating IIS site: $IISAppName on port $IISPort" -ForegroundColor DarkCyan
			New-Website -Name $IISAppName `
						-PhysicalPath $OutputDir `
						-Port $IISPort `
						-ApplicationPool $AppPoolName | Out-Null
		}
		$url = "http://localhost:$IISPort/ServiceMain.asmx"
		Write-Host "  Site URL: $url" -ForegroundColor Green
	} else {
		# --- Add as application under an existing site (via appcmd.exe for reliability) ---
		$appcmd = "$env:SystemRoot\System32\inetsrv\appcmd.exe"
		if (-not (Test-Path $appcmd)) {
			throw "appcmd.exe not found at '$appcmd'. IIS may not be installed correctly."
		}

		# Always delete then recreate for a clean, idempotent registration
		Write-Host "  Removing any existing '$IISAppName' web application (if present)..." -ForegroundColor DarkGray
		& $appcmd delete app "$IISSiteName/$IISAppName" 2>&1 | Out-Null
		# Exit code non-zero here just means it didn't exist - that's fine.

		Write-Host "  Creating Web Application: /$IISAppName under '$IISSiteName'" -ForegroundColor DarkCyan
		Write-Host "  Physical path: $OutputDir" -ForegroundColor DarkCyan
		$addOut = & $appcmd add app /site.name:"$IISSiteName" /path:"/$IISAppName" /physicalPath:"$OutputDir" 2>&1
		$addOut | ForEach-Object { Write-Host "  [appcmd] $_" -ForegroundColor DarkGray }
		if ($LASTEXITCODE -ne 0) {
			throw "appcmd.exe failed to create web application '$IISAppName'. Exit code: $LASTEXITCODE"
		}

		$setOut = & $appcmd set app "$IISSiteName/$IISAppName" /applicationPool:"$AppPoolName" 2>&1
		$setOut | ForEach-Object { Write-Host "  [appcmd] $_" -ForegroundColor DarkGray }
		if ($LASTEXITCODE -ne 0) {
			throw "appcmd.exe failed to assign application pool '$AppPoolName'. Exit code: $LASTEXITCODE"
		}

		# Verify: print the registered physical path so the log confirms the right path
		$verifyOut = & $appcmd list app "$IISSiteName/$IISAppName" 2>&1
		Write-Host "  [verify] $verifyOut" -ForegroundColor DarkGray

		$url = "http://localhost/$IISAppName/ServiceMain.asmx"
		Write-Host "  App URL: $url" -ForegroundColor Green
	}

	# --- Start the application pool ---
	$appPool = Get-WebAppPoolState -Name $AppPoolName -ErrorAction SilentlyContinue
	if ($appPool -and $appPool.Value -ne 'Started') {
		Start-WebAppPool -Name $AppPoolName
		Write-Host "  Application Pool started." -ForegroundColor DarkCyan
	}

	if (-not $url) {
		if ($CreateDedicatedSite) {
			$url = "$(Get-SiteBaseUrl -SiteName $IISAppName)/ServiceMain.asmx"
		} else {
			$url = "$(Get-SiteBaseUrl -SiteName $IISSiteName)/$IISAppName/ServiceMain.asmx"
		}
	}

	Write-Host ""
	Write-Host "  IIS registration complete." -ForegroundColor Green
	Write-Host "  Service endpoint: $url" -ForegroundColor Green
	Write-Host ""
	Write-Host "  NOTE: To verify the service is running, open a browser and navigate to:" -ForegroundColor DarkYellow
	Write-Host "        $url" -ForegroundColor DarkYellow
	Write-Host ""
	Write-Host "  TIP:  To auto-start IIS on Windows boot (cloud server), ensure the" -ForegroundColor DarkYellow
	Write-Host "        'World Wide Web Publishing Service' (W3SVC) is set to Automatic:" -ForegroundColor DarkYellow
	Write-Host "        Set-Service -Name W3SVC -StartupType Automatic; Start-Service W3SVC" -ForegroundColor DarkYellow
} else {
	Write-Host ""
	Write-Host "[STEP 4/4] IIS registration skipped (use -RegisterIIS to enable)." -ForegroundColor DarkGray
}

$stopwatch.Stop()
Write-Host ""
Write-Host "========================================================" -ForegroundColor Green
Write-Host "  BUILD COMPLETE" -ForegroundColor Green
Write-Host "  Time    : $($stopwatch.Elapsed.ToString('hh\:mm\:ss'))" -ForegroundColor Green
Write-Host "  Output  : $OutputDir" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
Write-Host ""

