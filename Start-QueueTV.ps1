<#
.SYNOPSIS
    Starts the Helianz TV Patient Queue Display & Education system with local database helianz_klt.
.DESCRIPTION
    1. Seeds/refreshes today's demo appointments in helianz_klt.
    2. Builds & launches HelianzApi web server on port 5000.
    3. Opens the Big TV Screen display in the default web browser (Edge/Chrome).
#>

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   HELIANZ DENTAL - TV PATIENT QUEUE & EDUCATION DEMO     " -ForegroundColor Yellow
Write-Host "   Database: helianz_klt | Port: 5000                     " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Seed demo appointments in helianz_klt
Write-Host "`n[1/3] Memeriksa & mengisi data antrian demo hari ini di helianz_klt..." -ForegroundColor Green
$SeedScript = Join-Path $PSScriptRoot "Seed-QueueDemoData.ps1"
if (Test-Path $SeedScript) {
    & powershell -ExecutionPolicy Bypass -File $SeedScript
}

# 2. Build & Start HelianzApi
Write-Host "`n[2/3] Menjalankan HelianzApi server..." -ForegroundColor Green
$ApiProject = Join-Path $PSScriptRoot "HelianzApi\HelianzApi.csproj"

# Check if port 5000 is already running
$PortActive = Get-NetTCPConnection -LocalPort 5000 -ErrorAction SilentlyContinue
if (-not $PortActive) {
    Start-Process dotnet -ArgumentList "run --project `"$ApiProject`" --urls `"http://0.0.0.0:5000`"" -WindowStyle Minimized
    Start-Sleep -Seconds 4
} else {
    Write-Host "Server sudah aktif di port 5000." -ForegroundColor Yellow
}

# 3. Open Browser
Write-Host "`n[3/3] Membuka Layar TV Antrian di Browser..." -ForegroundColor Green
Start-Process "http://localhost:5000/"

Write-Host "`n----------------------------------------------------------" -ForegroundColor Cyan
Write-Host "Sistem Antrian TV Berhasil Dijalankan!" -ForegroundColor Green
Write-Host "• Layar TV Pasien:      http://localhost:5000/" -ForegroundColor White
Write-Host "• Panel Panggil Petugas: http://localhost:5000/?role=caller" -ForegroundColor White
Write-Host "• Swagger API Docs:      http://localhost:5000/swagger" -ForegroundColor White
Write-Host "----------------------------------------------------------`n" -ForegroundColor Cyan
