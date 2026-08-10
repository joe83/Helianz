<#
.SYNOPSIS
    Installs HelianzApi from pre-built self-contained files onto a Windows server.
    No .NET SDK or build tools needed on the target machine.

.PARAMETER SourcePath
    Path to the self-contained build folder (from Build-SelfContained.ps1 output).
    Default: copies from current script directory's publish folder if available.

.PARAMETER InstallPath
    Target installation directory. Default: C:\HelianzApi

.PARAMETER Port
    HTTP port. Default: 5000

.PARAMETER DbServer
    MySQL server. Default: localhost

.PARAMETER DbPort
    MySQL port. Default: 3306

.PARAMETER DbName
    MySQL database name. Default: helianz_klt

.PARAMETER DbUser
    MySQL user. Default: root

.PARAMETER DbPassword
    MySQL password.

.PARAMETER JwtKey
    JWT key (min 32 chars). Auto-generated if blank.

.PARAMETER ServiceName
    Windows Service name. Default: HelianzApi

.EXAMPLE
    # Full install with all params
    .\Install-HelianzApi.ps1 -SourcePath C:\Temp\HelianzApi-win-x64 -DbServer 192.168.1.50 -DbName helianz_prod -DbUser apiuser -DbPassword "secret"

.EXAMPLE
    # Install from default publish folder
    .\Install-HelianzApi.ps1 -DbPassword "secret"
#>

param(
    [string]$SourcePath = "",
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

# ═══════════════════════════════════════════
# 1. Pre-flight
# ═══════════════════════════════════════════

Write-Host "=== HelianzApi Server Install ===" -ForegroundColor Cyan

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Run as Administrator." -ForegroundColor Red
    exit 1
}

# Find source files
if ([string]::IsNullOrEmpty($SourcePath)) {
    # Try default publish locations
    $candidates = @(
        (Join-Path $ScriptDir "publish\HelianzApi-win-x64"),
        (Join-Path $ScriptDir "bin\Release\net8.0\publish"),
        (Join-Path $ScriptDir "bin\Release\net8.0\win-x64\publish")
    )
    foreach ($c in $candidates) {
        if (Test-Path (Join-Path $c "HelianzApi.exe")) {
            $SourcePath = $c
            break
        }
    }
}

if ([string]::IsNullOrEmpty($SourcePath) -or -not (Test-Path (Join-Path $SourcePath "HelianzApi.exe"))) {
    Write-Host "ERROR: HelianzApi.exe not found in source path." -ForegroundColor Red
    Write-Host "  Build first: .\Build-SelfContained.ps1" -ForegroundColor Yellow
    Write-Host "  Or specify:  -SourcePath <folder-with-exe>" -ForegroundColor Yellow
    exit 1
}

Write-Host "Source: $SourcePath" -ForegroundColor Gray

# Generate JWT key
if ([string]::IsNullOrEmpty($JwtKey)) {
    $rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::new()
    $bytes = New-Object byte[] 32
    $rng.GetBytes($bytes)
    $JwtKey = [Convert]::ToBase64String($bytes)
    Write-Host "Generated random JWT key." -ForegroundColor Green
}

# ═══════════════════════════════════════════
# 2. Stop existing service
# ═══════════════════════════════════════════

$svc = Get-Service $ServiceName -ErrorAction SilentlyContinue
if ($svc) {
    Write-Host "Stopping existing service..." -ForegroundColor Yellow
    Stop-Service $ServiceName -Force -ErrorAction SilentlyContinue
    sc.exe delete $ServiceName 2>&1 | Out-Null
    Start-Sleep -Seconds 2
}

# ═══════════════════════════════════════════
# 3. Install files
# ═══════════════════════════════════════════

Write-Host "Installing to $InstallPath ..." -ForegroundColor Cyan

if (Test-Path $InstallPath) {
    Remove-Item -Recurse -Force $InstallPath -ErrorAction SilentlyContinue
}
New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $InstallPath "logs") -Force | Out-Null

Copy-Item -Path "$SourcePath\*" -Destination $InstallPath -Recurse -Force
Write-Host "Files copied." -ForegroundColor Green

# ═══════════════════════════════════════════
# 4. Create appsettings.json
# ═══════════════════════════════════════════

$configPath = Join-Path $InstallPath "appsettings.json"
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
$appsettings | ConvertTo-Json -Depth 5 | Set-Content -Path $configPath -Encoding UTF8
Write-Host "Configuration saved." -ForegroundColor Green

# ═══════════════════════════════════════════
# 5. Test run (verify everything works)
# ═══════════════════════════════════════════

Write-Host "Testing API..." -ForegroundColor Cyan
$exe = Join-Path $InstallPath "HelianzApi.exe"
$testJob = Start-Job -ScriptBlock {
    param($exe, $port, $installPath)
    & $exe --urls "http://localhost:$port" --contentRoot $installPath 2>&1
} -ArgumentList $exe, $Port, $InstallPath

Start-Sleep -Seconds 5
try {
    $r = Invoke-WebRequest -Uri "http://localhost:$Port/api/auth/debug-token" -UseBasicParsing -TimeoutSec 5
    Write-Host "  API test OK (health check passed)" -ForegroundColor Green
} catch {
    $err = Receive-Job $testJob 2>&1 | Out-String
    Write-Host "  API test failed:" -ForegroundColor Red
    Write-Host $err -ForegroundColor Gray
    Write-Host ""
    Write-Host "Common causes:" -ForegroundColor Yellow
    Write-Host "  - Port $Port already in use (change -Port)" -ForegroundColor Gray
    Write-Host "  - Missing VC++ runtime (install vc_redist.x64.exe)" -ForegroundColor Gray
    Write-Host "  - Database connection failed (check appsettings.json)" -ForegroundColor Gray
    Stop-Job $testJob -ErrorAction SilentlyContinue
    Remove-Job $testJob -Force -ErrorAction SilentlyContinue
    exit 1
}
Stop-Job $testJob -ErrorAction SilentlyContinue
Remove-Job $testJob -Force -ErrorAction SilentlyContinue

# Kill any remaining test process
Get-Process HelianzApi -ErrorAction SilentlyContinue | Stop-Process -Force

# ═══════════════════════════════════════════
# 6. Register Windows Service
# ═══════════════════════════════════════════

Write-Host "Registering service: $ServiceName ..." -ForegroundColor Cyan

# Use New-Service (cleaner than sc.exe)
$binPathArgs = "--urls `"http://0.0.0.0:$Port`" --contentRoot `"$InstallPath`""
New-Service -Name $ServiceName -BinaryPathName "`"$exe`" $binPathArgs" `
    -DisplayName "HelianzApi" -Description "Helianz Dental Practice Management API" `
    -StartupType Automatic 2>&1 | Out-Null

# Configure auto-restart on failure
sc.exe failure $ServiceName reset= 86400 actions= restart/10000/restart/30000/restart/60000 2>&1 | Out-Null

# ═══════════════════════════════════════════
# 7. Start service
# ═══════════════════════════════════════════

Start-Service $ServiceName
Start-Sleep -Seconds 5

$svc = Get-Service $ServiceName -ErrorAction SilentlyContinue
if ($svc -and $svc.Status -eq 'Running') {
    Write-Host "`n=== INSTALL SUCCESSFUL ===" -ForegroundColor Green
    Write-Host "  Service : $ServiceName (Running)" -ForegroundColor White
    Write-Host "  URL     : http://localhost:$Port" -ForegroundColor White
    Write-Host "  Swagger : http://localhost:$Port/swagger" -ForegroundColor White
    Write-Host "  Path    : $InstallPath" -ForegroundColor White
    Write-Host ""
    Write-Host "Firewall (if remote access needed):" -ForegroundColor Yellow
    Write-Host "  netsh advfirewall firewall add rule name=`"HelianzApi`" dir=in action=allow protocol=TCP localport=$Port" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Management:" -ForegroundColor Cyan
    Write-Host "  Stop      : Stop-Service $ServiceName" -ForegroundColor Gray
    Write-Host "  Start     : Start-Service $ServiceName" -ForegroundColor Gray
    Write-Host "  Restart   : Restart-Service $ServiceName" -ForegroundColor Gray
    Write-Host "  Config    : notepad $configPath" -ForegroundColor Gray
    Write-Host "  Remove    : sc.exe delete $ServiceName" -ForegroundColor Gray
} else {
    Write-Host "WARNING: Service didn't start. Check logs:" -ForegroundColor Red
    Write-Host "  Get-Content $InstallPath\logs\* -Tail 50" -ForegroundColor Gray
}
