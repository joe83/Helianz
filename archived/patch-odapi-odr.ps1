Set-Location "D:\Project\PakRevi\opendental\Helia"

$ildasm = 'C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.8 Tools\x64\ildasm.exe'
$ilasm  = 'C:\Windows\Microsoft.NET\Framework64\v4.0.30319\ilasm.exe'

function Patch-Dll {
    param([string]$name)
    $dllPath = "Required dlls\$name.dll"
    $bakPath = "Required dlls\$name.original.dll"
    $ilPath  = "Required dlls\$name.il"
    $resPath = "Required dlls\$name.res"
    $tmpPath = "Required dlls\$name.patched.dll"
    $oldPath = "Required dlls\$name.old.dll"

    if (-not (Test-Path $bakPath)) {
        Copy-Item $dllPath $bakPath
    }

    Write-Host "Disassembling $name..."
    & $ildasm $dllPath /out=$ilPath /nobar
    if (-not (Test-Path $ilPath)) { Write-Host "ERROR: no IL for $name"; return }

    $content = [System.IO.File]::ReadAllText($ilPath)
    $before = ([regex]::Matches($content, 'OpenDent')).Count

    $content = $content -replace '\bOpenDentBusiness\b', 'HelianzBusiness'
    $content = $content -replace '\bOpenDentalCloud\b', 'HelianzCloud'
    $content = $content -replace '\bOpenDentalHelp\b', 'HelianzHelp'
    $content = $content -replace '\bOpenDentalConnStr\b', 'HelianzConnStr'
    $content = $content -replace '\bOpenDental\b', 'Helianz'
    $content = $content -replace '\bOpenDent\b', 'Helianz'
    # Remove version constraints on renamed extern refs
    $content = $content -replace '(\.assembly extern Helianz\w*\s*\{)[^}]*(})', '$1 $2'

    $after = ([regex]::Matches($content, 'OpenDent')).Count
    [System.IO.File]::WriteAllText($ilPath, $content)
    Write-Host "${name}: $before -> $after OpenDent refs"

    Write-Host "Reassembling $name..."
    if (Test-Path $resPath) {
        & $ilasm $ilPath /dll /output=$tmpPath /quiet /resource=$resPath
    } else {
        & $ilasm $ilPath /dll /output=$tmpPath /quiet
    }
    Write-Host "  ilasm exit: $LASTEXITCODE"

    if ($LASTEXITCODE -eq 0 -and (Test-Path $tmpPath)) {
        if (Test-Path $oldPath) { Remove-Item $oldPath -Force -ErrorAction SilentlyContinue }
        try {
            [System.IO.File]::Copy($tmpPath, $dllPath, $true)
            Remove-Item $tmpPath -ErrorAction SilentlyContinue
            Write-Host "  SUCCESS via copy. Size: $((Get-Item $dllPath).Length)"
        } catch {
            Rename-Item $dllPath $oldPath -ErrorAction SilentlyContinue
            Rename-Item $tmpPath $dllPath -ErrorAction SilentlyContinue
            Write-Host "  SUCCESS via rename. Size: $((Get-Item $dllPath).Length)"
        }
    } else {
        Write-Host "  ERROR: ilasm failed for $name"
    }
}

Patch-Dll "ODApi"
Patch-Dll "ODR"
