# rename-helianz.ps1
# Rename OpenDental/OpenDent -> Helianz throughout the codebase
# Phase 1: Replace token strings inside text files
# Phase 2: Rename files that contain OpenDental/OpenDent in the name
# Phase 3: Rename directories bottom-up (deepest first)

Set-StrictMode -Off
$ErrorActionPreference = "Continue"

$rootDir    = "D:\Project\PakRevi\opendental\Helia"
$scriptPath = $MyInvocation.MyCommand.Path
$logFile    = Join-Path $rootDir "rename-helianz.log"

# -- Init log ----------------------------------------------------------------
"$(Get-Date)  === rename-helianz.ps1 START ===" | Out-File $logFile -Encoding UTF8
$stats = @{ Updated = 0; FileRenamed = 0; DirRenamed = 0; Errors = 0 }

function Log([string]$msg, [switch]$Err) {
    $line = "$(Get-Date -Format 'HH:mm:ss')  $msg"
    Add-Content -Path $logFile -Value $line -Encoding UTF8
    if ($Err) { Write-Host $line -ForegroundColor Red; $stats.Errors++ }
    else       { Write-Host $line }
}

# -- Token replacement map (ORDER IS CRITICAL - longest/most-specific first) -
# Using array of 2-element arrays to guarantee order in PS 5.1
$replacements = @(
    ,('OpenDentalServer',    'HelianzServer'    )
    ,('OpenDentalGraph',     'HelianzGraph'     )
    ,('OpenDentalCloud',     'HelianzCloud'     )
    ,('OpenDentalWpf',       'HelianzWpf'       )
    ,('OpenDentalImaging',   'HelianzImaging'   )
    ,('OpenDentalInstaller', 'HelianzInstaller' )
    ,('OpenDentalWebCore',   'HelianzWebCore'   )
    ,('OpenDental',          'Helianz'          )
    ,('OpenDentBusiness',    'HelianzBusiness'  )
    ,('OpenDentHL7',         'HelianzHL7'       )
    ,('OpenDentServer',      'HelianzServer'    )
    ,('OpenDent',            'Helianz'          )
    ,('Open Dental',         'Helianz'          )
    ,('open dental',         'helianz'          )
    ,('opendental',          'helianz'          )
    ,('open-dent.com',       'helianz.com'      )
    ,('open-dent',           'helianz'          )
)

function Apply-Tokens([string]$s) {
    foreach ($pair in $replacements) { $s = $s.Replace($pair[0], $pair[1]) }
    return $s
}

# -- Text extensions for content replacement ---------------------------------
$textExts = @(
    '.cs','.csproj','.sln','.xml','.config','.resx','.ps1','.sh',
    '.iss','.ruleset','.txt','.htm','.html','.json','.md','.yml','.yaml',
    '.cmd','.bat','.cshtml','.razor','.aspx','.ashx','.asmx','.vb','.xaml',
    '.targets','.props','.xsl','.xslt','.user','.filters','.manpages',
    '.ini','.1','.wixproj','.wxs','.wxi','.nuspec','.nupkg.metadata'
)

function Should-ExcludeContent([string]$path) {
    return ($path -match '[\\/]\.git[\\/]')      -or
           ($path -match '[\\/]\.vs[\\/]')       -or
           ($path -match '[\\/]packages[\\/]')   -or
           ($path -match '[\\/]obj[\\/]')        -or
           ($path -match '[\\/]bin[\\/]')        -or
           ($path -eq $logFile)                  -or
           ($path -eq $scriptPath)
}

function Should-ExcludeRename([string]$path) {
    return ($path -match '[\\/]\.git[\\/]')      -or
           ($path -match '[\\/]\.vs[\\/]')       -or
           ($path -match '[\\/]packages[\\/]')   -or
           ($path -match '[\\/]obj[\\/]')        -or
           ($path -match '[\\/]bin[\\/]')
}

# -- Encoding detection (BOM-based) -------------------------------------------
function Get-FileEncoding([byte[]]$bytes) {
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        return [System.Text.UTF8Encoding]::new($true)        # UTF-8 with BOM
    }
    if ($bytes.Length -ge 2 -and $bytes[0] -eq 0xFF -and $bytes[1] -eq 0xFE) {
        return [System.Text.Encoding]::Unicode               # UTF-16 LE
    }
    if ($bytes.Length -ge 2 -and $bytes[0] -eq 0xFE -and $bytes[1] -eq 0xFF) {
        return [System.Text.Encoding]::BigEndianUnicode      # UTF-16 BE
    }
    return [System.Text.UTF8Encoding]::new($false)           # UTF-8 no BOM (default)
}

# ============================================================================
# PHASE 1 - Content Replacement (modify file contents)
# ============================================================================
Log "==============================================================="
Log "PHASE 1 - Content Replacement"
Log "==============================================================="

$textFiles = Get-ChildItem -Path $rootDir -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object {
        -not (Should-ExcludeContent $_.FullName) -and
        ($textExts -contains $_.Extension.ToLower())
    }

Log "Scanning $($textFiles.Count) text files..."

foreach ($f in $textFiles) {
    try {
        $bytes   = [System.IO.File]::ReadAllBytes($f.FullName)
        $enc     = Get-FileEncoding $bytes
        $content = $enc.GetString($bytes)

        $newContent = Apply-Tokens $content

        if ($newContent -ne $content) {
            [System.IO.File]::WriteAllBytes($f.FullName, $enc.GetBytes($newContent))
            Log "  UPD  $($f.FullName.Substring($rootDir.Length))"
            $stats.Updated++
        }
    }
    catch {
        Log "  ERR  $($f.FullName.Substring($rootDir.Length)) - $_" -Err
    }
}

Log "Phase 1 complete - files updated: $($stats.Updated)  errors: $($stats.Errors)"

# ============================================================================
# PHASE 2 - File Renames
# ============================================================================
Log ""
Log "==============================================================="
Log "PHASE 2 - File Renames"
Log "==============================================================="

$filesToRename = Get-ChildItem -Path $rootDir -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object {
        -not (Should-ExcludeRename $_.FullName) -and
        ($_.Name -match 'OpenDental|OpenDent')
    } |
    Sort-Object { $_.FullName.Length } -Descending   # deepest paths first

foreach ($f in $filesToRename) {
    $newName = Apply-Tokens $f.Name
    if ($newName -ne $f.Name -and (Test-Path $f.FullName)) {
        try {
            Rename-Item -Path $f.FullName -NewName $newName -ErrorAction Stop
            Log "  RNF  $($f.Name)  ->  $newName"
            $stats.FileRenamed++
        }
        catch {
            Log "  ERR  $($f.FullName.Substring($rootDir.Length)) - $_" -Err
        }
    }
}

Log "Phase 2 complete - files renamed: $($stats.FileRenamed)  errors: $($stats.Errors)"

# ============================================================================
# PHASE 3 - Directory Renames (deepest first to avoid path invalidation)
# ============================================================================
Log ""
Log "==============================================================="
Log "PHASE 3 - Directory Renames"
Log "==============================================================="

$dirsToRename = Get-ChildItem -Path $rootDir -Recurse -Directory -ErrorAction SilentlyContinue |
    Where-Object {
        -not (Should-ExcludeRename $_.FullName) -and
        ($_.Name -match 'OpenDental|OpenDent')
    } |
    Sort-Object { $_.FullName.Length } -Descending   # deepest first

foreach ($d in $dirsToRename) {
    $newName = Apply-Tokens $d.Name
    if ($newName -ne $d.Name -and (Test-Path $d.FullName)) {
        try {
            Rename-Item -Path $d.FullName -NewName $newName -ErrorAction Stop
            Log "  RND  $($d.Name)  ->  $newName   [in $($d.Parent.FullName.Substring($rootDir.Length))]"
            $stats.DirRenamed++
        }
        catch {
            Log "  ERR  $($d.FullName.Substring($rootDir.Length)) - $_" -Err
        }
    }
}

# -- Phase 3b: Rename Helia-Installer -> Helianz-Installer --------------------
$heliaInst = Join-Path $rootDir "Helia-Installer"
if (Test-Path $heliaInst) {
    # First rename any OpenDent* subdirectories inside it
    $innerDirs = Get-ChildItem -Path $heliaInst -Recurse -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match 'OpenDental|OpenDent' } |
        Sort-Object { $_.FullName.Length } -Descending
    foreach ($d in $innerDirs) {
        $newName = Apply-Tokens $d.Name
        if ($newName -ne $d.Name -and (Test-Path $d.FullName)) {
            try {
                Rename-Item -Path $d.FullName -NewName $newName -ErrorAction Stop
                Log "  RND  $($d.Name)  ->  $newName  [Helia-Installer]"
                $stats.DirRenamed++
            }
            catch { Log "  ERR  $_" -Err }
        }
    }
    try {
        Rename-Item -Path $heliaInst -NewName "Helianz-Installer" -ErrorAction Stop
        Log "  RND  Helia-Installer  ->  Helianz-Installer"
        $stats.DirRenamed++
    }
    catch { Log "  ERR  Helia-Installer rename: $_" -Err }
}

Log "Phase 3 complete - dirs renamed: $($stats.DirRenamed)  errors: $($stats.Errors)"

# ============================================================================
# SUMMARY
# ============================================================================
Log ""
Log "=================== RENAME COMPLETE ==========================="
Log "  Files with content updated : $($stats.Updated)"
Log "  Files renamed              : $($stats.FileRenamed)"
Log "  Directories renamed        : $($stats.DirRenamed)"
Log "  Errors                     : $($stats.Errors)"
Log "  Log file                   : $logFile"
Log "==============================================================="
