Set-Location "D:\Project\PakRevi\opendental\Helia"

$dlls = @("ODApi", "ODR", "PasswordVaultWrapper", "RS232")

foreach ($name in $dlls) {
    $dll = "Required dlls\$name.dll"
    $bytes = [System.IO.File]::ReadAllBytes($dll)
    $txt = [System.Text.Encoding]::ASCII.GetString($bytes)
    $matches = [regex]::Matches($txt, 'OpenDent\w*')
    Write-Host "$name.dll ($($matches.Count) refs):"
    $matches | ForEach-Object { $_.Value } | Sort-Object -Unique | ForEach-Object { Write-Host "  $_" }
}
