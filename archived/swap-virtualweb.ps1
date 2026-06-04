Set-Location "D:\Project\PakRevi\opendental\Helia\Required dlls"
$src = "VirtualWeb.patched.dll"
$dst = "VirtualWeb.dll"
$old = "VirtualWeb.old.dll"

if (Test-Path $old) { Remove-Item $old -Force -ErrorAction SilentlyContinue }
Rename-Item $dst $old
Copy-Item $src $dst
Write-Host "VirtualWeb.dll replaced. Size: $((Get-Item $dst).Length)"
$bytes = [System.IO.File]::ReadAllBytes($dst)
$txt = [System.Text.Encoding]::ASCII.GetString($bytes)
Write-Host "OpenDental refs: $(([regex]::Matches($txt,'OpenDental')).Count)"
Write-Host "Helianz refs: $(([regex]::Matches($txt,'Helianz')).Count)"
