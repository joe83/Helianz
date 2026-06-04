Set-Location "D:\Project\PakRevi\opendental\Helia\Required dlls"
$ilasm = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\ilasm.exe"
$ilFile = "HelianzHelp.il"
$resFile = "HelianzHelp.res"
$tmpFile = "HelianzHelp.patched.dll"
$dstFile = "HelianzHelp.dll"

& $ilasm $ilFile /dll /output=$tmpFile /quiet /resource=$resFile
Write-Host "ilasm exit: $LASTEXITCODE"

if ($LASTEXITCODE -eq 0 -and (Test-Path $tmpFile)) {
    $oldFile = "HelianzHelp.old.dll"
    if (Test-Path $oldFile) { Remove-Item $oldFile -Force }
    Rename-Item $dstFile $oldFile
    Rename-Item $tmpFile $dstFile
    Write-Host "SUCCESS: HelianzHelp.dll patched. Size: $((Get-Item $dstFile).Length)"
    # Verify
    $bytes = [System.IO.File]::ReadAllBytes($dstFile)
    $txt = [System.Text.Encoding]::ASCII.GetString($bytes)
    Write-Host "HelianzHelp refs: $(([regex]::Matches($txt,'HelianzHelp')).Count)"
    Write-Host "OpenDentalHelp refs: $(([regex]::Matches($txt,'OpenDentalHelp')).Count)"
} else {
    Write-Host "ERROR: ilasm failed or output not found"
}
