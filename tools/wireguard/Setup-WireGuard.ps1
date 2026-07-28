<#
.SYNOPSIS
    Generates WireGuard keypairs and configuration files for the Helianz MT server
    and all clinic peers.
.DESCRIPTION
    Creates:
      - Server wg0.conf       (C:\WireGuard\wg0.conf on the MT server)
      - Clinic .conf files    (one per clinic, e.g. Clinic-01.conf)
      - Clinic summary CSV    (for distribution tracking)
    All keys are generated fresh each run and stored in .\keys\.
.PARAMETER ClinicCount
    Number of clinic peers to generate. Default: 10.
.PARAMETER ServerEndpoint
    Public IP or domain of the MT server (clinics connect to this).
.PARAMETER VpnSubnet
    VPN subnet in CIDR notation. Default: 10.0.0.0/24.
    Server = .1, Clinics = .2 through .(ClinicCount + 1).
.PARAMETER WgListenPort
    WireGuard UDP listen port on the server. Default: 51820.
.PARAMETER OutputDir
    Where to write generated configs. Default: .\output\.
.EXAMPLE
    .\Setup-WireGuard.ps1 -ServerEndpoint "103.12.34.56"
.EXAMPLE
    .\Setup-WireGuard.ps1 -ServerEndpoint "mt.helianz.co.id" -ClinicCount 5 -VpnSubnet "172.16.0.0/24"
#>

param(
    [int]$ClinicCount = 10,
    [Parameter(Mandatory=$true)]
    [string]$ServerEndpoint,
    [string]$VpnSubnet = "10.0.0.0/24",
    [int]$WgListenPort = 51820,
    [string]$OutputDir = "$PSScriptRoot\output"
)

$ErrorActionPreference = "Stop"

# --- Parse subnet --------------------------------------------------------------
if ($VpnSubnet -notmatch '^(\d+\.\d+\.\d+)\.(\d+)/(\d+)$') {
    throw "Invalid subnet: $VpnSubnet. Use format like 10.0.0.0/24"
}
$subnetBase = $Matches[1]
$serverOctet = [int]$Matches[2] + 1          # .0 → server = .1
$firstClinicOctet = $serverOctet + 1          # .1 → clinic 1 = .2
$cidrSuffix = $VpnSubnet.Substring($VpnSubnet.IndexOf('/'))  # e.g. /24

$serverVpnIp = "$subnetBase.$serverOctet"

# --- WireGuard key generation -------------------------------------------------
# Requires wireguard.exe (comes with WireGuard for Windows).
# Install once: https://www.wireguard.com/install/ or winget install WireGuard.WireGuard

function Get-WgExe {
    # `wg.exe` is the CLI tool (genkey, pubkey, show, set, etc.)
    # `wireguard.exe` is the GUI — newer versions also support CLI commands.
    # Try wg.exe first, then wireguard.exe.

    $paths = @(
        "C:\Program Files\WireGuard\wg.exe",
        "${env:ProgramFiles(x86)}\WireGuard\wg.exe",
        "C:\Program Files\WireGuard\wireguard.exe",
        "${env:ProgramFiles(x86)}\WireGuard\wireguard.exe"
    )
    foreach ($p in $paths) {
        if (Test-Path $p) {
            Write-Host "  Found: $p" -ForegroundColor DarkGray
            return $p
        }
    }

    # Fall back to PATH
    foreach ($name in @('wg.exe', 'wireguard.exe')) {
        $fromPath = (Get-Command $name -ErrorAction SilentlyContinue)
        if ($fromPath) {
            Write-Host "  Found on PATH: $($fromPath.Source)" -ForegroundColor DarkGray
            return $fromPath.Source
        }
    }

    Write-Host ""
    Write-Host "ERROR: Neither wg.exe nor wireguard.exe found." -ForegroundColor Red
    Write-Host ""
    Write-Host "Install WireGuard on this machine:" -ForegroundColor Yellow
    Write-Host "  winget install --id WireGuard.WireGuard -e --silent" -ForegroundColor White
    Write-Host "  Or: https://www.wireguard.com/install/" -ForegroundColor White
    Write-Host ""
    throw "WireGuard CLI tools not found."
}

function New-WgKeyPair {
    $wg = Get-WgExe

    # Step 1: Generate private key via cmd (avoids PowerShell stdout capture quirks)
    $priv = (& cmd.exe /c "`"$wg`" genkey" 2>&1 | Out-String).Trim()

    if ([string]::IsNullOrWhiteSpace($priv) -or $priv.Length -lt 40) {
        Write-Host "DEBUG: wg path  = $wg" -ForegroundColor DarkYellow
        Write-Host "DEBUG: priv raw = [$priv]" -ForegroundColor DarkYellow
        throw "wireguard genkey failed. Run manually to verify: `"$wg`" genkey"
    }

    # Step 2: Derive public key (cmd native pipe: echo $priv | wg pubkey)
    $pub = (& cmd.exe /c "echo $priv | `"$wg`" pubkey" 2>&1 | Out-String).Trim()

    if ([string]::IsNullOrWhiteSpace($pub) -or $pub.Length -lt 40) {
        Write-Host "DEBUG: priv = $priv" -ForegroundColor DarkYellow
        Write-Host "DEBUG: pub raw = [$pub]" -ForegroundColor DarkYellow
        throw "wireguard pubkey failed."
    }

    return [PSCustomObject]@{ PrivateKey = $priv; PublicKey = $pub }
}

$wgPath = Get-WgExe
Write-Host ""

# --- Prepare output folders ----------------------------------------------------
$keyDir  = Join-Path $OutputDir "keys"
$confDir = Join-Path $OutputDir "configs"
Remove-Item -Recurse -Force $OutputDir -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $keyDir  -Force | Out-Null
New-Item -ItemType Directory -Path $confDir -Force | Out-Null

# --- Generate server keys ------------------------------------------------------
Write-Host "=== Generating server keys ===" -ForegroundColor Cyan
$serverKeys = New-WgKeyPair
$serverPrivate = $serverKeys.PrivateKey
$serverPublic  = $serverKeys.PublicKey
$serverPrivate | Out-File -Encoding ascii (Join-Path $keyDir "server-private.key")
$serverPublic  | Out-File -Encoding ascii (Join-Path $keyDir "server-public.key")
Write-Host "  Public:  $serverPublic" -ForegroundColor Green

# --- Generate clinic keys ------------------------------------------------------
$clinics = @()
Write-Host ""
Write-Host "=== Generating $ClinicCount clinic keypairs ===" -ForegroundColor Cyan
for ($i = 1; $i -le $ClinicCount; $i++) {
    $keys = New-WgKeyPair
    $private = $keys.PrivateKey
    $public  = $keys.PublicKey
    $ipOctet = $firstClinicOctet + $i - 1
    $vpnIp   = "$subnetBase.$ipOctet"

    $label = "Clinic-{0:D2}" -f $i
    $private | Out-File -Encoding ascii (Join-Path $keyDir "$label-private.key")
    $public  | Out-File -Encoding ascii (Join-Path $keyDir "$label-public.key")

    $clinics += [PSCustomObject]@{
        Index      = $i
        Label      = $label
        VpnIp      = $vpnIp
        PrivateKey = $private
        PublicKey  = $public
    }

    Write-Host "  $label  VPN IP: $vpnIp  Pub: $public" -ForegroundColor DarkGray
}

# --- Build server wg0.conf -----------------------------------------------------
Write-Host ""
Write-Host "=== Building server config: wg0.conf ===" -ForegroundColor Cyan

$serverConf = @"
[Interface]
PrivateKey = $serverPrivate
Address    = $serverVpnIp$cidrSuffix
ListenPort = $WgListenPort

# ── PostUp firewall rules (run manually once or uncomment) ──────────────────
# New-NetFirewallRule -Name "WireGuard" -Direction Inbound -Protocol UDP -LocalPort $WgListenPort -Action Allow
# New-NetFirewallRule -Name "HelianzMT" -Direction Inbound -Protocol TCP -LocalPort 9390 -RemoteAddress $VpnSubnet -Action Allow

"@

foreach ($c in $clinics) {
    $serverConf += @"

# $($c.Label)
[Peer]
PublicKey  = $($c.PublicKey)
AllowedIPs = $($c.VpnIp)/32
"@
}

$serverConfPath = Join-Path $confDir "wg0.conf"
$serverConf | Out-File -Encoding ascii $serverConfPath
Write-Host "  Written: $serverConfPath" -ForegroundColor Green

# --- Build each clinic .conf ---------------------------------------------------
Write-Host ""
Write-Host "=== Building clinic configs ===" -ForegroundColor Cyan
foreach ($c in $clinics) {
    $clinicConf = @"
[Interface]
PrivateKey = $($c.PrivateKey)
Address    = $($c.VpnIp)/32
# DNS        = $serverVpnIp   # uncomment if clinics need DNS via VPN

[Peer]
PublicKey           = $serverPublic
Endpoint            = ${ServerEndpoint}:$WgListenPort
AllowedIPs          = $serverVpnIp/32
PersistentKeepalive = 25
"@
    $path = Join-Path $confDir "$($c.Label).conf"
    $clinicConf | Out-File -Encoding ascii $path
    Write-Host "  $($c.Label).conf → VPN IP: $($c.VpnIp)" -ForegroundColor DarkGray
}

# --- Build summary CSV ---------------------------------------------------------
Write-Host ""
Write-Host "=== Building summary CSV ===" -ForegroundColor Cyan
$csvPath = Join-Path $OutputDir "clinic-summary.csv"
$csvLines = @("Index,Label,VPN_IP,PublicKey,ConfigFile")
foreach ($c in $clinics) {
    $csvLines += "$($c.Index),$($c.Label),$($c.VpnIp),$($c.PublicKey),$($c.Label).conf"
}
$csvLines | Out-File -Encoding utf8 $csvPath
Write-Host "  Written: $csvPath" -ForegroundColor Green

# --- Print summary -------------------------------------------------------------
Write-Host ""
Write-Host "======================================" -ForegroundColor Magenta
Write-Host "  WireGuard Setup Complete" -ForegroundColor Magenta
Write-Host "======================================" -ForegroundColor Magenta
Write-Host ""
Write-Host "  VPN Subnet:      $VpnSubnet" -ForegroundColor White
Write-Host "  Server VPN IP:   $serverVpnIp" -ForegroundColor White
Write-Host "  Listen Port:     $WgListenPort" -ForegroundColor White
Write-Host "  Clinics:         $ClinicCount" -ForegroundColor White
Write-Host "  Server Endpoint: ${ServerEndpoint}:$WgListenPort" -ForegroundColor White
Write-Host ""
Write-Host "  Output:          $OutputDir" -ForegroundColor White
Write-Host "    configs\       → wg0.conf (server) + Clinic-XX.conf files" -ForegroundColor DarkGray
Write-Host "    keys\          → all keypairs (keep secure!)" -ForegroundColor DarkGray
Write-Host ""
Write-Host "── On the MT server ──" -ForegroundColor Yellow
Write-Host "  1. Copy configs\wg0.conf → C:\WireGuard\wg0.conf" -ForegroundColor White
Write-Host "  2. Run: wireguard /installtunnelservice C:\WireGuard\wg0.conf" -ForegroundColor White
Write-Host "  3. Open firewall: New-NetFirewallRule -Name WireGuard -Direction Inbound -Protocol UDP -LocalPort $WgListenPort -Action Allow" -ForegroundColor White
Write-Host "  4. Open firewall: New-NetFirewallRule -Name HelianzMT -Direction Inbound -Protocol TCP -LocalPort 9390 -RemoteAddress $VpnSubnet -Action Allow" -ForegroundColor White
Write-Host ""
Write-Host "── On each clinic PC ──" -ForegroundColor Yellow
Write-Host "  1. Install WireGuard from https://www.wireguard.com/install/" -ForegroundColor White
Write-Host "  2. Import Clinic-XX.conf (Import Tunnel From File)" -ForegroundColor White
Write-Host "  3. Activate the tunnel" -ForegroundColor White
Write-Host "  4. Set Helianz connection: Host=$serverVpnIp Port=9390" -ForegroundColor White
Write-Host ""
Write-Host "── Verify ──" -ForegroundColor Yellow
Write-Host "  From clinic: ping $serverVpnIp" -ForegroundColor White
Write-Host "  From clinic: curl http://${serverVpnIp}:9390/HelianzServer/ServiceMain.asmx" -ForegroundColor White
Write-Host ""
