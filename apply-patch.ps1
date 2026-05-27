Set-Location "D:\Project\PakRevi\opendental\Helia"
$src = "Required dlls\Bridges.patched.dll"
$dst = "Required dlls\Bridges.dll"

try {
    [System.IO.File]::Copy($src, $dst, $true)
    Write-Host "SUCCESS: Copied patched DLL"
} catch {
    Write-Host "COPY FAILED: $_"
    # Try renaming original and moving
    try {
        Rename-Item $dst "Bridges.old.dll" -Force
        Copy-Item $src $dst
        Write-Host "SUCCESS via rename+copy"
    } catch {
        Write-Host "BOTH METHODS FAILED: $_"
        exit 1
    }
}

$size = (Get-Item $dst).Length
Write-Host "New Bridges.dll size: $size bytes"

# Verify references in binary
$bytes = [System.IO.File]::ReadAllBytes($dst)
$txt = [System.Text.Encoding]::ASCII.GetString($bytes)
$hb = ([regex]::Matches($txt, 'HelianzBusiness')).Count
$od = ([regex]::Matches($txt, 'OpenDentBusiness')).Count
Write-Host "HelianzBusiness refs: $hb"
Write-Host "OpenDentBusiness refs: $od"
