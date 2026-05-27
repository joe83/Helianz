Set-Location 'D:\Project\PakRevi\opendental\Helia'

$ildasm = 'C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.8 Tools\x64\ildasm.exe'
$ilasm  = 'C:\Windows\Microsoft.NET\Framework64\v4.0.30319\ilasm.exe'
$dllSrc  = 'Required dlls\Bridges.dll'
$dllBak  = 'Required dlls\Bridges.original.dll'
$ilFile  = 'Required dlls\Bridges.il'
$resFile = 'Required dlls\Bridges.res'
$dllOut  = 'Required dlls\Bridges.dll'

# Backup original
if (-not (Test-Path $dllBak)) {
    Copy-Item $dllSrc $dllBak
    Write-Host "Backed up to $dllBak"
}

# Disassemble
Write-Host "Disassembling..."
& $ildasm $dllSrc /out=$ilFile /nobar
Write-Host "Disassembled. IL size: $((Get-Item $ilFile).Length) bytes"

# Patch: replace OpenDentBusiness -> HelianzBusiness
Write-Host "Patching IL..."
$content = [System.IO.File]::ReadAllText($ilFile)
$before = ([regex]::Matches($content, 'OpenDentBusiness')).Count
$patched = $content -replace '\bOpenDentBusiness\b', 'HelianzBusiness'
$after = ([regex]::Matches($patched, 'OpenDentBusiness')).Count
[System.IO.File]::WriteAllText($ilFile, $patched)
Write-Host "Replaced $before occurrences, $after remaining"

# Also need to update the .ver directive for the assembly reference
# The IL will have: .assembly extern OpenDentBusiness { .ver 24:3:45:0 }
# We already renamed it to HelianzBusiness, and the HelianzBusiness.dll will have its own version.
# We need to clear the version constraint so it matches any version of HelianzBusiness.
$content2 = [System.IO.File]::ReadAllText($ilFile)
# Remove version constraint from extern HelianzBusiness reference to avoid version mismatch
$content2 = $content2 -replace '(\.assembly extern HelianzBusiness\s*\{)[^}]*(})', '$1 $2'
[System.IO.File]::WriteAllText($ilFile, $content2)
Write-Host "Version constraint removed from extern HelianzBusiness reference"

# Reassemble to a temp file then replace
$dllTemp = 'Required dlls\Bridges.patched.dll'
Write-Host "Reassembling..."
& $ilasm $ilFile /dll /output=$dllTemp /quiet /resource=$resFile
Write-Host "Reassembled. Exit: $LASTEXITCODE"
if ($LASTEXITCODE -eq 0 -and (Test-Path $dllTemp)) {
    Move-Item -Force $dllTemp $dllOut
    Write-Host "New DLL size: $((Get-Item $dllOut).Length) bytes"
} else {
    Write-Host "ERROR: ilasm failed or output file not found"
    exit 1
}
