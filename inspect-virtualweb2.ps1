Set-Location "D:\Project\PakRevi\opendental\Helia"
$dll = "Required dlls\VirtualWeb.dll"
$asm = [System.Reflection.Assembly]::ReflectionOnlyLoadFrom((Resolve-Path $dll).Path)

foreach ($type in $asm.GetTypes() | Where-Object { $_.IsPublic }) {
    Write-Host "`nType: $($type.FullName)"
    foreach ($m in $type.GetMembers()) {
        Write-Host "  $($m.MemberType): $($m.ToString())"
    }
}
