<#
.SYNOPSIS
    Installs HelianzApi as a Windows Service.

.DESCRIPTION
    Copies API files, configures settings, and registers as a Windows Service.
    Requires Administrator privileges.

.PARAMETER InstallPath
    Target installation directory. Default: C:\HelianzApi

.PARAMETER Port
    HTTP port to listen on. Default: 5000

.PARAMETER DbServer
    MySQL server hostname. Default: localhost

.PARAMETER DbName
    MySQL database name. Default: helianz_klt

.PARAMETER DbUser
    MySQL user. Default: root

.PARAMETER JwtKey
    JWT signing key (min 32 chars). A random key is generated if not provided.

.PARAMETER ServiceName
    Windows Service name. Default: HelianzApi

.EXAMPLE
    .\Setup-HelianzApi.ps1 -Port 5000 -DbServer 192.168.1.100 -DbName helianz
#>

param(
    [string]$InstallPath = "C:\HelianzApi",
    [int]$Port = 5000,
    [string]$DbServer = "localhost",
    [int]$DbPort = 3306,
    [string]$DbName = "helianz_klt",
    [string]$DbUser = "root",
    [string]$DbPassword = "",
    [string]$JwtKey = "",
    [string]$ServiceName = "HelianzApi"
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PublishDir = Join-Path $ScriptDir "bin\Release\net10.0\publish"

# ═══════════════════════════════════════════════════════
# 1. Pre-flight checks
# ═══════════════════════════════════════════════════════

Write-Host "=== HelianzApi Setup ===" -ForegroundColor Cyan

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: This script requires Administrator privileges. Run as Administrator." -ForegroundColor Red
    exit 1
}

# Check .NET Runtime
$dotnet = Get-Command dotnet -ErrorAction SilentlyContinue
if (-not $dotnet) {
    Write-Host ".NET Runtime not found. Checking winget..." -ForegroundColor Yellow
    $winget = Get-Command winget -ErrorAction SilentlyContinue
    if ($winget) {
        Write-Host "Installing .NET 8 Runtime via winget..." -ForegroundColor Yellow
        winget install Microsoft.DotNet.Runtime.8 --silent --accept-package-agreements
    } else {
        Write-Host "ERROR: .NET 8 Runtime required. Download from https://dotnet.microsoft.com/en-us/download/dotnet/8.0" -ForegroundColor Red
        exit 1
    }
}

# Generate JWT key if not provided
if ([string]::IsNullOrEmpty($JwtKey)) {
    $rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::new()
    $bytes = New-Object byte[] 32
    $rng.GetBytes($bytes)
    $JwtKey = [Convert]::ToBase64String($bytes)
    Write-Host "Generated random JWT key." -ForegroundColor Green
}

# ═══════════════════════════════════════════════════════
# 2. Publish API (if not already published)
# ═══════════════════════════════════════════════════════

if (-not (Test-Path (Join-Path $PublishDir "HelianzApi.dll"))) {
    Write-Host "Publishing HelianzApi..." -ForegroundColor Cyan
    $proj = Join-Path $ScriptDir "HelianzApi.csproj"
    if (-not (Test-Path $proj)) {
        Write-Host "ERROR: HelianzApi.csproj not found at $ScriptDir" -ForegroundColor Red
        exit 1
    }
    Push-Location $ScriptDir
    dotnet publish -c Release -o "$PublishDir" --no-self-contained
    Pop-Location
    Write-Host "Publish complete." -ForegroundColor Green
}

# ═══════════════════════════════════════════════════════
# 3. Stop existing service if running
# ═══════════════════════════════════════════════════════

$svc = Get-Service $ServiceName -ErrorAction SilentlyContinue
if ($svc) {
    Write-Host "Stopping existing service..." -ForegroundColor Yellow
    Stop-Service $ServiceName -Force
    sc.exe delete $ServiceName | Out-Null
    Start-Sleep -Seconds 2
}

# ═══════════════════════════════════════════════════════
# 4. Copy files to target directory
# ═══════════════════════════════════════════════════════

Write-Host "Installing to $InstallPath ..." -ForegroundColor Cyan

if (Test-Path $InstallPath) {
    Remove-Item -Recurse -Force $InstallPath
}
New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null

# Copy all published files
Copy-Item -Path "$PublishDir\*" -Destination $InstallPath -Recurse -Force

# Create logs directory
New-Item -ItemType Directory -Path (Join-Path $InstallPath "logs") -Force | Out-Null

# ═══════════════════════════════════════════════════════
# 5. Create appsettings.json
# ═══════════════════════════════════════════════════════

$appsettings = @{
    Database = @{
        Server = $DbServer
        Port = $DbPort
        Database = $DbName
        User = $DbUser
        Password = $DbPassword
        Pooling = $true
        MinPoolSize = 2
        MaxPoolSize = 50
    }
    Jwt = @{
        Key = $JwtKey
        ExpiryHours = 24
    }
    Logging = @{
        LogLevel = @{
            Default = "Information"
            "Microsoft.AspNetCore" = "Warning"
        }
    }
}

$appsettingsPath = Join-Path $InstallPath "appsettings.json"
$appsettings | ConvertTo-Json -Depth 5 | Set-Content -Path $appsettingsPath -Encoding UTF8
Write-Host "Configuration saved to $appsettingsPath" -ForegroundColor Green

# ═══════════════════════════════════════════════════════
# 6. Register Windows Service
# ═══════════════════════════════════════════════════════

Write-Host "Registering Windows Service: $ServiceName ..." -ForegroundColor Cyan

$exe = Join-Path $InstallPath "HelianzApi.exe"
$binPath = "`"$exe`" --urls `"http://0.0.0.0:$Port`" --contentRoot `"$InstallPath`""

sc.exe create $ServiceName binPath= $binPath start= auto | Out-Null
sc.exe description $ServiceName "Helianz Dental Practice Management API" | Out-Null
sc.exe failure $ServiceName reset= 86400 actions= restart/60000/restart/60000/restart/60000 | Out-Null

# ═══════════════════════════════════════════════════════
# 7. Start service
# ═══════════════════════════════════════════════════════

Start-Service $ServiceName
Start-Sleep -Seconds 3

$svc = Get-Service $ServiceName
if ($svc.Status -eq 'Running') {
    Write-Host "`n=== INSTALLATION COMPLETE ===" -ForegroundColor Green
    Write-Host "Service:  $ServiceName" -ForegroundColor White
    Write-Host "URL:     http://localhost:$Port" -ForegroundColor White
    Write-Host "Swagger: http://localhost:$Port/swagger" -ForegroundColor White
    Write-Host "Path:    $InstallPath" -ForegroundColor White
    Write-Host "Logs:    $InstallPath\logs" -ForegroundColor White
    Write-Host ""
    Write-Host "Firewall rule needed:" -ForegroundColor Yellow
    Write-Host "  netsh advfirewall firewall add rule name=`"HelianzApi`" dir=in action=allow protocol=TCP localport=$Port" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Service commands:" -ForegroundColor Cyan
    Write-Host "  Stop:    Stop-Service $ServiceName" -ForegroundColor Gray
    Write-Host "  Start:   Start-Service $ServiceName" -ForegroundColor Gray
    Write-Host "  Restart: Restart-Service $ServiceName" -ForegroundColor Gray
    Write-Host "  Remove:  sc.exe delete $ServiceName" -ForegroundColor Gray
} else {
    Write-Host "WARNING: Service did not start. Check logs at $InstallPath\logs" -ForegroundColor Red
}
