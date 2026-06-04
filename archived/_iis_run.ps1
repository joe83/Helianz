Start-Transcript -Path "D:\Project\PakRevi\helianz\Old\iis-register.log" -Force
try {
    & "D:\Project\PakRevi\helianz\Old\Build-HelianzServer.ps1" -Configuration Release -RegisterIIS -IISSiteName "Default Web Site" -IISAppName "HelianzServer"
} catch {
    Write-Host "ERROR: $_"
}
Stop-Transcript
