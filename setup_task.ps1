# ==============================================================================
# Windows Task Scheduler Setup Script (UTF-8 & Elevated Privileges)
# ==============================================================================

# Source directory
$sourceDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Permanent installation target directory (User's Local AppData)
$installDir = Join-Path $env:LOCALAPPDATA "AutoDelete_Temp"
New-Item -ItemType Directory -Path $installDir -Force | Out-Null

# Copy essential files to permanent directory
Copy-Item (Join-Path $sourceDir "clean_temp.ps1") -Destination $installDir -Force -ErrorAction SilentlyContinue
Copy-Item (Join-Path $sourceDir "launcher.vbs") -Destination $installDir -Force -ErrorAction SilentlyContinue

$installedScript = Join-Path $installDir "clean_temp.ps1"

# Define task action (Hidden PowerShell execution on the permanent script)
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$installedScript`""

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
    Write-Host "`n[SUCCESS] AutoDelete_Temp installed and configured successfully!" -ForegroundColor Green
    Write-Host "Installed Path : $installedScript" -ForegroundColor Cyan
    Write-Host "Trigger        : At User Logon (ONLOGON)" -ForegroundColor Cyan
    Write-Host "Privilege      : Highest (Administrator)" -ForegroundColor Cyan
    Write-Host "Power Setting  : Runs on Battery (AllowStartIfOnBatteries)`n" -ForegroundColor Cyan
    Write-Host "You can now safely delete the downloaded folder/ZIP if you wish.`n" -ForegroundColor Yellow
} else {
    Write-Host "`n[ERROR] Failed to create scheduled task. Please run as Administrator.`n" -ForegroundColor Red
}
