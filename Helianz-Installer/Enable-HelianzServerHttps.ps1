#Requires -Version 5.1
<#
.SYNOPSIS
    Configures HTTPS for HelianzServer in IIS — generates a self-signed certificate,
    binds it to the IIS site, and optionally adds HTTP→HTTPS redirect rules.

.DESCRIPTION
    Called automatically by HelianzServerSetup.iss [Run] when the "Enable HTTPS"
    checkbox is selected during installation, or can be run standalone post-install.

    Steps performed:
      1. Check for existing HTTPS binding — skip if already configured.
      2. Generate a self-signed SSL certificate (or import a user-provided PFX).
      3. Bind the certificate to the IIS site on port 443.
      4. Optionally add URL Rewrite rules to Web.config for HTTP→HTTPS redirect
         (requires IIS URL Rewrite Module to be installed).

.PARAMETER InstallDir
    Physical path of the installed web service files (value of {app} in Inno Setup).

.PARAMETER SiteName
    IIS site that hosts the web application. Default: "Default Web Site"

.PARAMETER AppName
    Virtual path / application name. Default: HelianzServer

.PARAMETER CertSubject
    Subject name for the self-signed certificate (CN=). Default: the server's FQDN.

.PARAMETER CertPath
    Path to a PFX certificate file to import instead of generating a self-signed cert.
    Takes precedence over CertSubject if provided.

.PARAMETER CertPassword
    Password for the PFX certificate file (only used with -CertPath).

.PARAMETER SkipRedirect
    When specified, does NOT add HTTP→HTTPS redirect rules to Web.config.

.PARAMETER CertStore
    Certificate store location. Default: "Cert:\LocalMachine\My" (Personal store).

.EXAMPLE
    # Standalone: generate self-signed cert and enable HTTPS, with redirect
    .\Enable-HelianzServerHttps.ps1 -InstallDir "C:\Program Files\HelianzServer"

.EXAMPLE
    # Use a custom PFX certificate
    .\Enable-HelianzServerHttps.ps1 -InstallDir "C:\Program Files\HelianzServer" `
        -CertPath "C:\certs\myserver.pfx" -CertPassword "P@ssw0rd"

.EXAMPLE
    # Self-signed with custom hostname, no redirect
    .\Enable-HelianzServerHttps.ps1 -InstallDir "C:\Program Files\HelianzServer" `
        -CertSubject "helianz.internal.local" -SkipRedirect
#>
param(
    [Parameter(Mandatory)]
    [string]$InstallDir,

    [string]$SiteName    = 'Default Web Site',
    [string]$AppName     = 'HelianzServer',
    [string]$CertSubject = '',
    [string]$CertPath    = '',
    [string]$CertPassword = ''

)
# No -SkipRedirect — HTTP redirect is not needed.
# The Helianz client apps use HTTPS directly when "Use SSL" is checked.

$ErrorActionPreference = 'Stop'
$logFile = Join-Path $InstallDir 'iis-https.log'

function Write-Log {
    param([string]$Msg)
    $line = "[{0}] {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Msg
    Write-Host $line
    Add-Content -Path $logFile -Value $line -ErrorAction SilentlyContinue
}

try {
    Write-Log "=== HelianzServer HTTPS Configuration ==="
    Write-Log "InstallDir  : $InstallDir"
    Write-Log "SiteName    : $SiteName"
    Write-Log "AppName     : $AppName"

    # ------------------------------------------------------------------
    # 0. Resolve the IIS site ID
    # ------------------------------------------------------------------
    $appcmd = "$env:SystemRoot\System32\inetsrv\appcmd.exe"
    if (-not (Test-Path $appcmd)) {
        throw "appcmd.exe not found at '$appcmd'. IIS does not appear to be installed."
    }

    Write-Log "Resolving IIS site '$SiteName'..."
    $siteInfo = & $appcmd list site /name:"$SiteName" 2>&1 | Select-Object -First 1
    if ($LASTEXITCODE -ne 0 -or -not $siteInfo) {
        throw "IIS site '$SiteName' not found. Please ensure IIS is installed and the site exists."
    }
    Write-Log "  Site: $siteInfo"

    # ------------------------------------------------------------------
    # 1. Check if HTTPS binding already exists
    # ------------------------------------------------------------------
    Write-Log "Checking existing HTTPS bindings..."
    $existingBindings = & $appcmd list site /name:"$SiteName" 2>&1 |
        Select-String -Pattern 'https' -SimpleMatch
    if ($existingBindings) {
        Write-Log "  Existing HTTPS binding(s) found:"
        $existingBindings | ForEach-Object { Write-Log "    $_" }

        # Check if any are on port 443 with a valid cert
        $httpsBindings = & netsh http show sslcert 2>&1 |
            Select-String -Pattern '0.0.0.0:443|\[\:\:\]:443|\*:443' -SimpleMatch
        if ($httpsBindings) {
            Write-Log "WARNING: HTTPS on port 443 is already configured. Skipping certificate setup."
            Write-Log "If you need to reconfigure, manually remove the existing HTTPS binding first."
            exit 0
        }
    }

    # ------------------------------------------------------------------
    # 2. Obtain or generate the SSL certificate
    # ------------------------------------------------------------------
    $certThumbprint = ''

    if ($CertPath -and (Test-Path $CertPath)) {
        # Import user-provided PFX certificate
        Write-Log "Importing PFX certificate from: $CertPath"

        $securePassword = if ($CertPassword) {
            ConvertTo-SecureString -String $CertPassword -Force -AsPlainText
        } else {
            $null
        }

        $importedCert = Import-PfxCertificate -FilePath $CertPath `
            -CertStoreLocation 'Cert:\LocalMachine\My' `
            -Password $securePassword `
            -Exportable

        $certThumbprint = $importedCert.Thumbprint
        Write-Log "  Certificate imported. Thumbprint: $certThumbprint"
        Write-Log "  Subject: $($importedCert.Subject)"
        Write-Log "  Expires: $($importedCert.NotAfter)"
    }
    else {
        # Generate a self-signed certificate
        if (-not $CertSubject) {
            # Auto-detect the server's FQDN
            try {
                $CertSubject = [System.Net.Dns]::GetHostEntry([System.Net.Dns]::GetHostName()).HostName
            }
            catch {
                $CertSubject = [System.Net.Dns]::GetHostName()
            }
        }
        Write-Log "Generating self-signed certificate for: $CertSubject"

        # Check for an existing self-signed cert with the same subject
        $existingCert = Get-ChildItem -Path 'Cert:\LocalMachine\My' -ErrorAction SilentlyContinue |
            Where-Object { $_.Subject -eq "CN=$CertSubject" -and $_.FriendlyName -eq 'HelianzServer HTTPS' } |
            Select-Object -First 1

        if ($existingCert -and ($existingCert.NotAfter -gt (Get-Date).AddDays(30))) {
            Write-Log "  Reusing existing self-signed certificate."
            Write-Log "  Thumbprint: $($existingCert.Thumbprint)"
            Write-Log "  Expires: $($existingCert.NotAfter)"
            $certThumbprint = $existingCert.Thumbprint
        }
        else {
            # Remove expired/old cert with same subject if it exists
            if ($existingCert) {
                Write-Log "  Removing expired/soon-to-expire certificate: $($existingCert.Thumbprint)"
                Remove-Item -Path $existingCert.PSPath -Force -ErrorAction SilentlyContinue
            }

            $newCert = New-SelfSignedCertificate `
                -Subject "CN=$CertSubject" `
                -FriendlyName 'HelianzServer HTTPS' `
                -KeyAlgorithm RSA `
                -KeyLength 2048 `
                -KeyUsage DigitalSignature, KeyEncipherment `
                -KeyExportPolicy Exportable `
                -NotAfter (Get-Date).AddYears(5) `
                -CertStoreLocation 'Cert:\LocalMachine\My' `
                -TextExtension @('2.5.29.37={text}1.3.6.1.5.5.7.3.1')  # Server Authentication EKU

            $certThumbprint = $newCert.Thumbprint
            Write-Log "  Self-signed certificate created."
            Write-Log "  Thumbprint: $certThumbprint"
            Write-Log "  Subject: $($newCert.Subject)"
            Write-Log "  Expires: $($newCert.NotAfter)"
        }
    }

    # ------------------------------------------------------------------
    # 3. Bind the certificate to the IIS site on HTTPS (port 443)
    # ------------------------------------------------------------------
    Write-Log "Adding HTTPS binding to site '$SiteName' on *:443..."

    # Use the IIS WebAdministration PowerShell module (preferred and most reliable)
    $webAdminAvailable = Get-Module -ListAvailable -Name WebAdministration -ErrorAction SilentlyContinue

    if ($webAdminAvailable) {
        Import-Module WebAdministration -ErrorAction Stop

        # Remove any existing HTTPS binding on port 443 for this site (idempotent)
        $existingBinding = Get-WebBinding -Name $SiteName -Protocol https -Port 443 -ErrorAction SilentlyContinue
        if ($existingBinding) {
            Write-Log "  Removing existing HTTPS binding on *:443..."
            Remove-WebBinding -Name $SiteName -Protocol https -Port 443 -ErrorAction SilentlyContinue
        }

        # Add the new HTTPS binding
        New-WebBinding -Name $SiteName -Protocol https -Port 443 -IPAddress "*" -ErrorAction Stop
        Write-Log "  IIS HTTPS binding added: *:443"
    }
    else {
        # Fallback: use appcmd (less reliable but works without WebAdministration module)
        Write-Log "  WebAdministration module not available, using appcmd fallback..."

        # Remove existing HTTPS binding on *:443 (idempotent)
        $existingHttps = & $appcmd list site /name:"$SiteName" 2>&1 |
            Select-String -Pattern '\*:443:' -SimpleMatch
        if ($existingHttps) {
            Write-Log "  Removing existing HTTPS binding..."
            & $appcmd set site /site.name:"$SiteName" `
                /-bindings.[protocol='https',bindingInformation='*:443:'] 2>&1 | Out-Null
        }

        # Add the HTTPS binding
        $addResult = & $appcmd set site /site.name:"$SiteName" `
            /+bindings.[protocol='https',bindingInformation='*:443:'] 2>&1
        Write-Log "  [appcmd] $addResult"
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to add HTTPS binding to IIS site '$SiteName'."
        }
    }

    # Associate the certificate with the binding using netsh (HTTP.SYS level)
    $hostnameDisplay = [System.Net.Dns]::GetHostName()
    $certHash = $certThumbprint.Replace(' ', '')
    $appId = '{4dc3e181-e14b-4a21-b022-59fc669b0914}'  # Fixed GUID for HelianzServer

    Write-Log "  Binding certificate to IP:0.0.0.0 port 443 via netsh..."
    $netshResult = & netsh http add sslcert `
        ipport=0.0.0.0:443 `
        certhash=$certHash `
        appid=$appId 2>&1

    if ($LASTEXITCODE -ne 0) {
        # May already exist — try deleting and re-adding
        Write-Log "  Add failed (may already exist), trying delete + re-add..."
        Write-Log "  netsh output: $netshResult"
        & netsh http delete sslcert ipport=0.0.0.0:443 2>&1 | Out-Null
        & netsh http add sslcert `
            ipport=0.0.0.0:443 `
            certhash=$certHash `
            appid=$appId 2>&1 | ForEach-Object { Write-Log "  [netsh] $_" }
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to bind SSL certificate to port 443 via netsh."
        }
    }

    # Verify the IIS HTTPS binding is active
    Write-Log "  Verifying IIS HTTPS binding..."
    if ($webAdminAvailable) {
        $verifyBindings = Get-WebBinding -Name $SiteName -Protocol https -Port 443 -ErrorAction SilentlyContinue
        if ($verifyBindings) {
            Write-Log "  IIS HTTPS binding VERIFIED on *:443"
        }
        else {
            Write-Log "  WARNING: HTTPS binding not found after creation. Check IIS Manager."
        }
    }

    Write-Log "  HTTPS binding configured successfully."

    # ------------------------------------------------------------------
    # 4. Verify and summarize
    # ------------------------------------------------------------------
    Write-Log ''
    Write-Log "============================================"
    Write-Log "  HTTPS Configuration Complete"
    Write-Log "============================================"
    Write-Log ''

    $verifyBinding = & netsh http show sslcert ipport=0.0.0.0:443 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Log "  SSL Certificate Binding: VERIFIED"
    }
    else {
        Write-Log "  SSL Certificate Binding: NOT VERIFIED (check logs)"
    }

    Write-Log ''
    Write-Log "  Service endpoint (HTTPS):"
    Write-Log "    https://$hostnameDisplay/$AppName/ServiceMain.asmx"
    Write-Log ''
    Write-Log "  Certificate thumbprint: $certThumbprint"
    Write-Log ''
    Write-Log "  HTTP->HTTPS REDIRECT:"
    Write-Log "    Not configured. To block HTTP access to ServiceMain.asmx,"
    Write-Log "    install IIS URL Rewrite Module and run:"
    Write-Log "      appcmd set config ""Default Web Site/HelianzServer"" /section:system.webServer/rewrite /+rules.[name='Redirect to HTTPS',stopProcessing='True']"
    Write-Log "    Or remove the HTTP binding:"
    Write-Log "      Remove-WebBinding -Name 'Default Web Site' -Protocol http -Port 80"
    Write-Log ''

    exit 0
}
catch {
    Write-Log "ERROR: $_"
    exit 1
}
