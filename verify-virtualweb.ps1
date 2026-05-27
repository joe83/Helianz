Set-Location "D:\Project\PakRevi\opendental\Helia"

# Check VirtualWeb.dll status
$dll = "Required dlls\VirtualWeb.dll"
$patched = "Required dlls\VirtualWeb.patched.dll"

Write-Host "VirtualWeb.dll size: $((Get-Item $dll).Length)"
if (Test-Path $patched) { Write-Host "patched.dll size: $((Get-Item $patched).Length)" }

$bytes = [System.IO.File]::ReadAllBytes($dll)
$txt = [System.Text.Encoding]::ASCII.GetString($bytes)
Write-Host "OpenDental in VirtualWeb.dll: $(([regex]::Matches($txt,'OpenDental')).Count)"
Write-Host "Helianz in VirtualWeb.dll: $(([regex]::Matches($txt,'Helianz')).Count)"

# If patched exists and has correct content, apply it
if (Test-Path $patched) {
    $bytes2 = [System.IO.File]::ReadAllBytes($patched)
    $txt2 = [System.Text.Encoding]::ASCII.GetString($bytes2)
    $odInPatched = ([regex]::Matches($txt2,'OpenDental')).Count
    $hzInPatched = ([regex]::Matches($txt2,'Helianz')).Count
    Write-Host "OpenDental in patched: $odInPatched, Helianz: $hzInPatched"
    if ($odInPatched -eq 0 -and $hzInPatched -gt 0) {
        [System.IO.File]::Copy($patched, $dll, $true)
        Write-Host "Applied patched DLL"
    }
}
