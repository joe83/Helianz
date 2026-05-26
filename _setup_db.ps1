# _setup_db.ps1
# Run this AS ADMINISTRATOR (or right-click -> Run as Administrator).
# Logs output to setup-db.log in the same folder.
#
# -Force drops the existing database without a confirmation prompt.
# Remove -Force if you want a prompt before dropping.

Start-Transcript -Path "D:\Project\PakRevi\opendental\Old\setup-db.log" -Force
try {
    & "D:\Project\PakRevi\opendental\Old\Setup-OpenDentalDatabase.ps1" -Force
} catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
}
Stop-Transcript
