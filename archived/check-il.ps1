Set-Location "D:\Project\PakRevi\opendental\Helia\Required dlls"
Select-String -Path "HelianzHelp.il" -Pattern "OpenDent" | Select-Object -First 10 | ForEach-Object { $_.Line.Trim() }
