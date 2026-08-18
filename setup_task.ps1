# ==============================================================================
# Windows Gorev Zamanlayici Kurulum Betigi (UTF-8 ve Yonetici Yetkili)
# ==============================================================================

# Mevcut scriptin bulundugu tam dizin yolunu al
$currentDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$scriptPath = Join-Path -Path $currentDir -ChildPath "clean_temp.ps1"

# Gorev aksiyonunu tanimla (Penceresiz PowerShell)
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`""

# Tetikleyici: Kullanici oturum actiginda
$trigger = New-ScheduledTaskTrigger -AtLogOn

# Yetki seviyesi: En yuksek (Highest) ve kullanici kimligi
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Highest

# Ayarlar: Pildeyken de calis, durdurma
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit (New-TimeSpan -Minutes 10)

# Varsa eski gorevi sil
Unregister-ScheduledTask -TaskName "AutoDeleteTempCleaning" -Confirm:$false -ErrorAction SilentlyContinue

# Yeni gorevi kaydet
Register-ScheduledTask -TaskName "AutoDeleteTempCleaning" -Action $action -Trigger $trigger -Principal $principal -Settings $settings | Out-Null

# Kontrol et
$task = Get-ScheduledTask -TaskName "AutoDeleteTempCleaning" -ErrorAction SilentlyContinue
if ($task) {
    Write-Host "`n[BASARILI] Gorev Zamanlayici'ya basariyla kuruldu!" -ForegroundColor Green
    Write-Host "Hedef Betik : $scriptPath" -ForegroundColor Cyan
    Write-Host "Tetikleyici : Kullanici oturum actiginda (ONLOGON)" -ForegroundColor Cyan
    Write-Host "Yetki       : En Yuksek (Admin / Highest)" -ForegroundColor Cyan
    Write-Host "Guc Ayari   : Pilde de calisir (AllowStartIfOnBatteries)`n" -ForegroundColor Cyan
} else {
    Write-Host "`n[HATA] Gorev olusturulamadi. Lutfen Yonetici olarak calistirin.`n" -ForegroundColor Red
}
