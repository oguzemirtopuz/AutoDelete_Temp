# ==============================================================================
# Windows Task Scheduler Setup Script (UTF-8 & Elevated Privileges)
# ==============================================================================

# Get current directory and clean_temp.ps1 path
$currentDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$scriptPath = Join-Path -Path $currentDir -ChildPath "clean_temp.ps1"

# Define task action (Hidden PowerShell execution)
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`""

# Trigger: At User Logon
$trigger = New-ScheduledTaskTrigger -AtLogOn

# Principal: Highest privilege level for the current user
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Highest

# Settings: Allow run on batteries, do not stop if going on batteries
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit (New-TimeSpan -Minutes 10)

# Unregister any existing task with the same name
Unregister-ScheduledTask -TaskName "AutoDeleteTempCleaning" -Confirm:$false -ErrorAction SilentlyContinue

# Register the new task
Register-ScheduledTask -TaskName "AutoDeleteTempCleaning" -Action $action -Trigger $trigger -Principal $principal -Settings $settings | Out-Null

# Verification
$task = Get-ScheduledTask -TaskName "AutoDeleteTempCleaning" -ErrorAction SilentlyContinue
if ($task) {
    Write-Host "`n[SUCCESS] Task Scheduler entry configured successfully!" -ForegroundColor Green
    Write-Host "Target Script : $scriptPath" -ForegroundColor Cyan
    Write-Host "Trigger       : At User Logon (ONLOGON)" -ForegroundColor Cyan
    Write-Host "Privilege     : Highest (Administrator)" -ForegroundColor Cyan
    Write-Host "Power Setting : Runs on Battery (AllowStartIfOnBatteries)`n" -ForegroundColor Cyan
} else {
    Write-Host "`n[ERROR] Failed to create scheduled task. Please run as Administrator.`n" -ForegroundColor Red
}
