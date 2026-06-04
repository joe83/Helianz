Get-Content "D:\Project\PakRevi\opendental\Helia\build3.log" | Where-Object { $_ -match "error CS|Build FAILED|errors," } | Select-Object -Last 30
