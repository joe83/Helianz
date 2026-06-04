Set-Location "D:\Project\PakRevi\opendental\Helia"
# Check all DLLs in Required dlls for OpenDent references
$dllDir = "Required dlls"
Get-ChildItem $dllDir -Filter "*.dll" | Where-Object { $_.Name -notlike "*.original.*" -and $_.Name -notlike "*.old.*" } | ForEach-Object {
    $bytes = [System.IO.File]::ReadAllBytes($_.FullName)
    $txt = [System.Text.Encoding]::ASCII.GetString($bytes)
    $odCount = ([regex]::Matches($txt, 'OpenDent')).Count
    if ($odCount -gt 0) {
        Write-Host "$($_.Name): $odCount OpenDent refs"
    }
}
