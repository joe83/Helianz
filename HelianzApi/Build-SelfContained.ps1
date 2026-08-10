<#
.SYNOPSIS
    Builds HelianzApi as a self-contained executable for deployment.
    Run this ONCE on your dev machine, then copy the output to the server.

.DESCRIPTION
    Creates a self-contained Windows x64 build that includes the .NET runtime.
    No .NET installation needed on the target server.

.OUTPUTS
    Output folder: .\publish\HelianzApi-win-x64\
    Contains HelianzApi.exe + all dependencies — ready to copy to server.
#>

param(
    [string]$OutputDir = "$PSScriptRoot\publish\HelianzApi-win-x64"
)

$ErrorActionPreference = "Stop"

Write-Host "=== Building Self-Contained HelianzApi ===" -ForegroundColor Cyan

Push-Location $PSScriptRoot
try {
    dotnet publish -c Release -r win-x64 --self-contained true `
        -p:PublishSingleFile=false `
        -p:IncludeNativeLibrariesForSelfExtract=true `
        -o "$OutputDir"
    
    Write-Host "`nBuild complete: $OutputDir" -ForegroundColor Green
    Write-Host "Folder size: $((Get-ChildItem $OutputDir -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB) MB" -ForegroundColor Gray
    Write-Host ""
    Write-Host "To deploy to server:" -ForegroundColor Yellow
    Write-Host "  1. Copy this folder to the server (e.g. C:\HelianzApi)" -ForegroundColor White
    Write-Host "  2. Run: .\Install-HelianzApi.ps1 -SourcePath C:\HelianzApi" -ForegroundColor White
}
finally {
    Pop-Location
}
