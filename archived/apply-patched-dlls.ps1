Set-Location "D:\Project\PakRevi\opendental\Helia\Required dlls"

foreach ($name in @("ODApi", "ODR")) {
    $patched = "$name.patched.dll"
    $dst = "$name.dll"
    if (Test-Path $patched) {
        $bytes = [System.IO.File]::ReadAllBytes((Resolve-Path $patched).Path)
        $txt = [System.Text.Encoding]::ASCII.GetString($bytes)
        $od = ([regex]::Matches($txt,'OpenDent')).Count
        Write-Host "$name.patched.dll: $od OpenDent refs, size $((Get-Item $patched).Length)"
        
        # Apply it
        $old = "$name.old.dll"
        if (Test-Path $old) { Remove-Item $old -Force }
        Rename-Item $dst $old
        Copy-Item $patched $dst
        Write-Host "Applied $name.dll from patched. New size: $((Get-Item $dst).Length)"
    } else {
        Write-Host "No patched dll found for $name"
    }
}
