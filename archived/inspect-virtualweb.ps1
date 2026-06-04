Set-Location "D:\Project\PakRevi\opendental\Helia"

# Check VirtualWeb.dll for Browser/Web types
$dll = "Required dlls\VirtualWeb.dll"
try {
    $asm = [System.Reflection.Assembly]::ReflectionOnlyLoadFrom((Resolve-Path $dll).Path)
    Write-Host "VirtualWeb.dll loaded. Types:"
    $asm.GetTypes() | Where-Object { $_.IsPublic } | Select-Object FullName | Sort-Object FullName | ForEach-Object { Write-Host "  $($_.FullName)" }
} catch {
    Write-Host "ERROR loading VirtualWeb.dll: $_"
    # Try binary scan
    $bytes = [System.IO.File]::ReadAllBytes($dll)
    $txt = [System.Text.Encoding]::ASCII.GetString($bytes)
    $matches = [regex]::Matches($txt, '[A-Z][a-zA-Z0-9_]+\.[A-Z][a-zA-Z0-9_]+')
    $matches | ForEach-Object { $_.Value } | Sort-Object -Unique | Where-Object { $_ -notmatch '^System\.' } | Select-Object -First 30 | ForEach-Object { Write-Host "  $_" }
}
