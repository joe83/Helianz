<#
.SYNOPSIS
    Updates HelianzApi database configuration and restarts the service.

.PARAMETER DbServer
    MySQL server hostname.

.PARAMETER DbName
    MySQL database name.

.PARAMETER DbUser
    MySQL user.

.PARAMETER DbPassword
    MySQL password.

.PARAMETER DbPort
    MySQL port. Default: 3306

.PARAMETER Port
    API HTTP port. Default: 5000

.PARAMETER JwtKey
    JWT signing key.

.PARAMETER InstallPath
    Installation directory. Default: C:\HelianzApi

.PARAMETER ServiceName
    Windows Service name. Default: HelianzApi

.EXAMPLE
    .\Update-HelianzApi.ps1 -DbServer 192.168.1.100 -DbName helianz_new -DbUser apiuser -DbPassword "newpass"
#>

param(
    [string]$DbServer,
    [string]$DbName,
    [string]$DbUser,
    [string]$DbPassword,
    [int]$DbPort = 3306,
    [int]$Port = 5000,
    [string]$JwtKey,
    [string]$InstallPath = "C:\HelianzApi",
    [string]$ServiceName = "HelianzApi"
)

$ErrorActionPreference = "Stop"

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Run as Administrator." -ForegroundColor Red
    exit 1
}

$configPath = Join-Path $InstallPath "appsettings.json"
if (-not (Test-Path $configPath)) {
    Write-Host "ERROR: $configPath not found." -ForegroundColor Red
    exit 1
}

$config = Get-Content $configPath -Raw | ConvertFrom-Json

if ($DbServer)     { $config.Database.Server = $DbServer }
if ($DbName)       { $config.Database.Database = $DbName }
if ($DbUser)       { $config.Database.User = $DbUser }
if ($DbPassword -ne "")  { $config.Database.Password = $DbPassword }
if ($DbPort)       { $config.Database.Port = $DbPort }
if ($JwtKey)       { $config.Jwt.Key = $JwtKey }

$config | ConvertTo-Json -Depth 5 | Set-Content -Path $configPath -Encoding UTF8
Write-Host "Configuration updated: $configPath" -ForegroundColor Green
Write-Host "  Server:   $($config.Database.Server)"
Write-Host "  Database: $($config.Database.Database)"
Write-Host "  User:     $($config.Database.User)"

# Update service binpath if port changed
if ($Port) {
    $exe = Join-Path $InstallPath "HelianzApi.exe"
    $binPath = "`"$exe`" --urls `"http://0.0.0.0:$Port`" --contentRoot `"$InstallPath`""
    sc.exe config $ServiceName binPath= $binPath | Out-Null
}

Write-Host "Restarting service..." -ForegroundColor Yellow
Restart-Service $ServiceName
Start-Sleep -Seconds 3

$svc = Get-Service $ServiceName
if ($svc.Status -eq 'Running') {
    Write-Host "Service running on http://localhost:$Port" -ForegroundColor Green
} else {
    Write-Host "WARNING: Service did not start. Check logs at $InstallPath\logs" -ForegroundColor Red
}
