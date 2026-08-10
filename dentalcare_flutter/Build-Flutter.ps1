# Build-HelianzFlutter.ps1
# Builds the DentalCare Flutter Android APK from any terminal (no VS Code needed)
# Output: build\app\outputs\flutter-apk\app-debug.apk

param(
    [switch]$Release,
    [switch]$Clean,
    [switch]$Install
)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

# Kill stale Gradle daemons to free memory
Write-Host "Cleaning up stale Java processes..." -ForegroundColor Cyan
Get-Process -Name "java", "javaw" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

if ($Clean) {
    Write-Host "Cleaning build artifacts..." -ForegroundColor Cyan
    flutter clean
}

Write-Host "Getting dependencies..." -ForegroundColor Cyan
flutter pub get

if ($Release) {
    Write-Host "Building release APK..." -ForegroundColor Cyan
    flutter build apk --release --android-skip-build-dependency-validation
} else {
    Write-Host "Building debug APK..." -ForegroundColor Cyan
    flutter build apk --debug --android-skip-build-dependency-validation
}

$apkPath = if ($Release) {
    "build\app\outputs\flutter-apk\app-release.apk"
} else {
    "build\app\outputs\flutter-apk\app-debug.apk"
}

if (Test-Path $apkPath) {
    $size = [math]::Round((Get-Item $apkPath).Length / 1MB, 2)
    Write-Host "`nBUILD SUCCESS!" -ForegroundColor Green
    Write-Host "APK: $apkPath ($size MB)" -ForegroundColor Green
} else {
    Write-Host "`nBUILD FAILED - APK not found" -ForegroundColor Red
    exit 1
}

if ($Install) {
    Write-Host "Installing to device..." -ForegroundColor Cyan
    flutter install
}
