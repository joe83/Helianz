Set-Location "D:\Project\PakRevi\opendental\Helia"

$ildasm = 'C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.8 Tools\x64\ildasm.exe'
$ilasm  = 'C:\Windows\Microsoft.NET\Framework64\v4.0.30319\ilasm.exe'

function Patch-Dll {
    param($dllName)
    $dllPath = "Required dlls\$dllName.dll"
    $bakPath = "Required dlls\$dllName.original.dll"
    $ilPath  = "Required dlls\$dllName.il"
    $resPath = "Required dlls\$dllName.res"
    $tmpPath = "Required dlls\$dllName.patched.dll"

    # Quick check internal name via reflection
    try {
        $asm = [System.Reflection.Assembly]::ReflectionOnlyLoadFrom((Resolve-Path $dllPath))
        Write-Host "$dllName internal name: $($asm.GetName().Name)"
    } catch { Write-Host "${dllName}: could not load via reflection" }

    # Backup
    if (-not (Test-Path $bakPath)) {
        Copy-Item $dllPath $bakPath
        Write-Host "Backed up $dllName"
    }

    # Disassemble
    Write-Host "Disassembling $dllName..."
    & $ildasm $dllPath /out=$ilPath /nobar
    if (-not (Test-Path $ilPath)) { Write-Host "ERROR: IL not created for $dllName"; return }
    Write-Host "IL size: $((Get-Item $ilPath).Length) bytes"

    # Patch
    $content = [System.IO.File]::ReadAllText($ilPath)
    $before = ([regex]::Matches($content, 'OpenDent')).Count
    $content = $content -replace '\bOpenDentBusiness\b', 'HelianzBusiness'
    $content = $content -replace '\bOpenDentalHelp\b', 'HelianzHelp'
    $content = $content -replace '\bOpenDental\b', 'Helianz'
    $content = $content -replace '\bOpenDent\b', 'Helianz'
    # Remove version constraints on extern assembly refs we changed
    $content = $content -replace '(\.assembly extern Helianz\w*\s*\{)[^}]*(})', '$1 $2'
    $after = ([regex]::Matches($content, 'OpenDent')).Count
    [System.IO.File]::WriteAllText($ilPath, $content)
    Write-Host "Replaced (had $before OpenDent refs, now $after remain)"

    # Reassemble
    Write-Host "Reassembling $dllName..."
    $resArgs = if (Test-Path $resPath) { "/resource=$resPath" } else { "" }
    if ($resArgs) {
        & $ilasm $ilPath /dll /output=$tmpPath /quiet /resource=$resPath
    } else {
        & $ilasm $ilPath /dll /output=$tmpPath /quiet
    }
    Write-Host "ilasm exit: $LASTEXITCODE"

    if ($LASTEXITCODE -eq 0 -and (Test-Path $tmpPath)) {
        try {
            [System.IO.File]::Copy($tmpPath, $dllPath, $true)
            Remove-Item $tmpPath -ErrorAction SilentlyContinue
            Write-Host "SUCCESS: $dllName patched. Size: $((Get-Item $dllPath).Length)"
        } catch {
            # Try rename trick
            $oldPath = "Required dlls\$dllName.old.dll"
            Rename-Item $dllPath $oldPath -Force -ErrorAction SilentlyContinue
            Copy-Item $tmpPath $dllPath
            Remove-Item $tmpPath -ErrorAction SilentlyContinue
            Write-Host "SUCCESS (via rename): $dllName patched. Size: $((Get-Item $dllPath).Length)"
        }
    } else {
        Write-Host "ERROR: ilasm failed for $dllName"
    }
}

# Patch HelianzHelp.dll (was OpenDentalHelp)
Patch-Dll "HelianzHelp"
