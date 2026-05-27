Set-Location "D:\Project\PakRevi\opendental\Helia"

$ildasm = 'C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.8 Tools\x64\ildasm.exe'
$ilasm  = 'C:\Windows\Microsoft.NET\Framework64\v4.0.30319\ilasm.exe'

$dllName = "VirtualWeb"
$dllPath = "Required dlls\$dllName.dll"
$bakPath = "Required dlls\$dllName.original.dll"
$ilPath  = "Required dlls\$dllName.il"
$resPath = "Required dlls\$dllName.res"
$tmpPath = "Required dlls\$dllName.patched.dll"

# Backup
if (-not (Test-Path $bakPath)) {
    Copy-Item $dllPath $bakPath
    Write-Host "Backed up $dllName"
}

# Disassemble
Write-Host "Disassembling $dllName..."
& $ildasm $dllPath /out=$ilPath /nobar
Write-Host "IL size: $((Get-Item $ilPath).Length) bytes"

# Patch: rename namespaces
$content = [System.IO.File]::ReadAllText($ilPath)
$beforeOD  = ([regex]::Matches($content, 'OpenDental(?!Business)')).Count
$beforeODB = ([regex]::Matches($content, 'OpenDentBusiness')).Count
Write-Host "Before: $beforeOD OpenDental refs, $beforeODB OpenDentBusiness refs"

# Replace OpenDentBusiness first (more specific)
$content = $content -replace '\bOpenDentBusiness\b', 'HelianzBusiness'
# Replace OpenDentalHelp
$content = $content -replace '\bOpenDentalHelp\b', 'HelianzHelp'
# Replace OpenDental (the namespace - not followed by Business)
$content = $content -replace '\bOpenDental\b', 'Helianz'

# Remove version constraints on renamed extern assembly refs
$content = $content -replace '(\.assembly extern Helianz\w*\s*\{)[^}]*(})', '$1 $2'

$afterOD  = ([regex]::Matches($content, 'OpenDental(?!Business)')).Count
$afterODB = ([regex]::Matches($content, 'OpenDentBusiness')).Count
Write-Host "After: $afterOD OpenDental refs, $afterODB OpenDentBusiness refs"
[System.IO.File]::WriteAllText($ilPath, $content)

# Reassemble
Write-Host "Reassembling $dllName..."
if (Test-Path $resPath) {
    & $ilasm $ilPath /dll /output=$tmpPath /quiet /resource=$resPath
} else {
    & $ilasm $ilPath /dll /output=$tmpPath /quiet
}
Write-Host "ilasm exit: $LASTEXITCODE"

if ($LASTEXITCODE -eq 0 -and (Test-Path $tmpPath)) {
    $oldPath = "Required dlls\$dllName.old.dll"
    if (Test-Path $oldPath) { Remove-Item $oldPath -Force }
    Rename-Item $dllPath $oldPath
    Rename-Item $tmpPath $dllPath
    Write-Host "SUCCESS: $dllName.dll patched. Size: $((Get-Item $dllPath).Length)"
} else {
    Write-Host "ERROR: ilasm failed for $dllName"
    exit 1
}
