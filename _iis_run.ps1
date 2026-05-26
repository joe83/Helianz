Start-Transcript -Path "D:\Project\PakRevi\opendental\Old\iis-register.log" -Force
try {
    & "D:\Project\PakRevi\opendental\Old\Build-OpenDentalServer.ps1" -Configuration Release -RegisterIIS -IISSiteName "Default Web Site" -IISAppName "OpenDentalServer"
} catch {
    Write-Host "ERROR: $_"
}
Stop-Transcript
