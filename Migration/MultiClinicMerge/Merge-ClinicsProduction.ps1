#Requires -Version 5.1
<#
.SYNOPSIS
	Production Multi-Clinic Database Merge Automation Wrapper.

.DESCRIPTION
	Executes the Python merge automation script with full parameterization.
	If credentials or databases are not specified, prompts are requested.

.PARAMETER TargetDb
	Target database name (e.g. helianz).

.PARAMETER Sources
	Comma-separated source databases in sequential clinic order (e.g. helianz_klt,helianz_byl,helianz_jog).

.PARAMETER User
	MariaDB username. Default: root.

.PARAMETER Password
	MariaDB password. If omitted, Python will securely prompt for password.

.PARAMETER BinDir
	Path to MariaDB/MySQL bin directory. If omitted, auto-detected.

.PARAMETER AutoIncStart
	Post-merge auto_increment start value. Default: 10000000.

.PARAMETER Step
	Offset round-up step. Default: 1000000.

.PARAMETER DryRun
	Preview calculated offsets and steps without executing modifications.

.PARAMETER SkipBackup
	Skip backing up the existing target database before merge.

.PARAMETER NoWipe
	Skip wiping the target database before merge (default: target is wiped clean first).
#>

[CmdletBinding()]
param(
	[string]$TargetDb,
	[string]$Sources,
	[string]$User = "root",
	[string]$Password,
	[string]$BinDir,
	[int]$AutoIncStart = 10000000,
	[int]$Step = 1000000,
	[switch]$DryRun,
	[switch]$SkipBackup,
	[switch]$NoWipe
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Dynamically locate repo root containing .venv or Helianz.sln
$Current = $ScriptDir
$RepoRoot = $null
while ($Current) {
	if ((Test-Path (Join-Path $Current ".venv")) -or (Test-Path (Join-Path $Current "Helianz.sln"))) {
		$RepoRoot = $Current
		break
	}
	$Parent = Split-Path -Parent $Current
	if ($Parent -eq $Current) { break }
	$Current = $Parent
}
if (-not $RepoRoot) { $RepoRoot = Split-Path -Parent (Split-Path -Parent $ScriptDir) }

$PythonExe = Join-Path $RepoRoot ".venv\Scripts\python.exe"

if (-not (Test-Path $PythonExe)) {
	$PythonExe = "python.exe"
}

$MergeScript = Join-Path $ScriptDir "merge_mysql_clinics.py"

$ArgsList = @(
	"`"$MergeScript`"",
	"--user", "`"$User`"",
	"--step", "$Step",
	"--autoinc-start", "$AutoIncStart"
)

if ($TargetDb) {
	$ArgsList += @("--target", "`"$TargetDb`"")
}
if ($Sources) {
	$ArgsList += @("--sources", "`"$Sources`"")
}
if ($Password) {
	$ArgsList += @("--password", "`"$Password`"")
}
if ($BinDir) {
	$ArgsList += @("--bin-dir", "`"$BinDir`"")
}
if ($DryRun) {
	$ArgsList += "--dry-run"
}
if ($SkipBackup) {
	$ArgsList += "--skip-backup"
}
if ($NoWipe) {
	$ArgsList += "--no-wipe"
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Launching Helianz Multi-Clinic Merge Automation" -ForegroundColor Cyan
Write-Host "  Python : $PythonExe" -ForegroundColor Gray
Write-Host "  Script : $MergeScript" -ForegroundColor Gray
if ($TargetDb) { Write-Host "  Target : $TargetDb" -ForegroundColor Gray }
if ($Sources)  { Write-Host "  Sources: $Sources" -ForegroundColor Gray }
Write-Host "  User   : $User" -ForegroundColor Gray
Write-Host "==========================================================" -ForegroundColor Cyan

& $PythonExe $ArgsList

if ($LASTEXITCODE -ne 0) {
	Write-Error "Merge script exited with code $LASTEXITCODE"
}
