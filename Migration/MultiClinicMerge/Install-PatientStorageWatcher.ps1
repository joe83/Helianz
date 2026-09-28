# =============================================================================
# Install-PatientStorageWatcher.ps1
# Creates a Windows Scheduled Task to run watch_new_patient_storage.py every 5 minutes
# =============================================================================

[CmdletBinding()]
param (
    [string]$TaskName = "Helianz-PatientStorageWatcher",
    [int]$IntervalMinutes = 5,
    [switch]$Uninstall
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$pythonScript = Join-Path $scriptDir "watch_new_patient_storage.py"

if ($Uninstall) {
    Write-Host "Removing Scheduled Task: $TaskName..." -ForegroundColor Yellow
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue
    Write-Host "[OK] Scheduled task removed." -ForegroundColor Green
    return
}

# Locate python executable
$pythonExe = (Get-Command python -ErrorAction SilentlyContinue).Source
if (-not $pythonExe) {
    $pythonExe = "python.exe"
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Helianz Patient Storage Watcher - Scheduled Task Setup" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "Script: $pythonScript"
Write-Host "Python: $pythonExe"
Write-Host "Task  : $TaskName (every $IntervalMinutes minutes)"

# Unregister existing task if present
Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue

# Create Action
$action = New-ScheduledTaskAction `
    -Execute $pythonExe `
    -Argument "`"$pythonScript`" --once" `
    -WorkingDirectory $scriptDir

# Create Trigger (repeating indefinitely every X minutes)
$trigger = New-ScheduledTaskTrigger `
    -Once `
    -At (Get-Date) `
    -RepetitionInterval (New-TimeSpan -Minutes $IntervalMinutes)

# Settings
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 10) `
    -RestartCount 3 `
    -RestartInterval (New-TimeSpan -Minutes 1)

# Register task under SYSTEM or current user
Register-ScheduledTask `
    -TaskName $TaskName `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -Description "Periodically provisions remote cloud storage folders (.keep) for new Helianz patients." `
    -User "NT AUTHORITY\SYSTEM" `
    -RunLevel Highest

Write-Host ""
Write-Host "[OK] Scheduled Task '$TaskName' registered successfully!" -ForegroundColor Green
Write-Host "To test run immediately: Start-ScheduledTask -TaskName '$TaskName'" -ForegroundColor Cyan
