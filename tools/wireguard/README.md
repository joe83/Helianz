# WireGuard VPN Setup for Helianz Middle-Tier Server

## Prerequisites

**On the machine running this script** (your dev PC), install WireGuard first:

```powershell
winget install --id WireGuard.WireGuard -e --silent
```

Or download from: https://www.wireguard.com/install/

## Quick Start

```powershell
# Generate all keys and configs:
cd tools\wireguard
.\Setup-WireGuard.ps1 -ServerEndpoint "YOUR_PUBLIC_IP"
```

This creates `output\` with:
- `configs\wg0.conf` — server config
- `configs\Clinic-01.conf` through `Clinic-10.conf` — clinic configs
- `keys\` — all private/public keypairs (keep these secure!)
- `clinic-summary.csv` — tracking sheet

---

## MT Server (Windows Server 2022)

### 1. Install WireGuard
```powershell
Invoke-WebRequest -Uri "https://download.wireguard.com/windows-client/wireguard-amd64-0.5.3.msi" -OutFile "$env:TEMP\wireguard.msi"
Start-Process msiexec.exe -ArgumentList "/i `"$env:TEMP\wireguard.msi`" /qn /norestart" -Wait
```

### 2. Deploy Config
```powershell
mkdir C:\WireGuard -Force
# Copy generated configs\wg0.conf → C:\WireGuard\wg0.conf
```

### 3. Install as Windows Service
```powershell
& "C:\Program Files\WireGuard\wireguard.exe" /installtunnelservice C:\WireGuard\wg0.conf
```

### 4. Open Firewall
```powershell
# WireGuard tunnel
New-NetFirewallRule -Name "WireGuard" -Direction Inbound -Protocol UDP -LocalPort 51820 -Action Allow

# Helianz MT — VPN subnet ONLY
New-NetFirewallRule -Name "HelianzMT" -Direction Inbound -Protocol TCP -LocalPort 9390 -RemoteAddress 10.0.0.0/24 -Action Allow
```

### 5. Verify
```powershell
& "C:\Program Files\WireGuard\wireguard.exe" /show
ping 10.0.0.1
```

---

## Clinic PCs (Windows 10/11)

### 1. Install WireGuard
Download from: https://www.wireguard.com/install/

### 2. Import Config
- Open WireGuard → **Import Tunnel(s) From File**
- Select the clinic's `.conf` file

### 3. Activate
- Click **Activate**

### 4. Configure Helianz Client
- Host: `10.0.0.1`
- Port: `9390`

### 5. Verify
```powershell
ping 10.0.0.1
```

---

## Network Architecture

```
                    Internet
                       │
┌──────────────────────┼──────────────────────┐
│              MT Server                        │
│                                               │
│  WireGuard: 10.0.0.1/24  (UDP :51820)        │
│  IIS:       *:9390       (TCP :9390)         │
│  Firewall:  :9390 ← 10.0.0.0/24 ONLY        │
│                                               │
└──────┬────────────┬────────────┬──────────────┘
       │            │            │
  Clinic-01     Clinic-02     Clinic-10
  10.0.0.2      10.0.0.3      10.0.0.11
```

Each clinic's `AllowedIPs = 10.0.0.1/32` — only MT traffic routes through VPN.
Internet, browsing, YouTube — all stay on local ISP.

---

## Adding/Removing Clinics Later

### Add a clinic
1. Generate new keys: `wireguard genkey | Out-File new.key; Get-Content new.key | wireguard pubkey | Out-File new.pub`
2. Add `[Peer]` block to server `wg0.conf`
3. Reload server: `wireguard /uninstalltunnelservice wg0; wireguard /installtunnelservice C:\WireGuard\wg0.conf`

### Remove a clinic
1. Remove the `[Peer]` block from server `wg0.conf`
2. Reload as above

---

## Troubleshooting

| Problem | Check |
|---------|-------|
| Can't ping 10.0.0.1 | `wireguard /show` — look for "latest handshake", should be < 2 min |
| Handshake failing | Is UDP 51820 open on server firewall AND in cloud/ISP firewall? |
| Connected but no MT access | Is TCP 9390 allowed from 10.0.0.0/24? `Test-NetConnection 10.0.0.1 -Port 9390` |
| Double-NAT / CGNAT | Clinics behind carrier-grade NAT should still work — WireGuard is NAT-friendly |
