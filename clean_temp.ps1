# ==============================================================================
# %TEMP% ve Windows Temp Klasörlerini Otomatik Temizleme Betiği
# ==============================================================================

# Hata yakalama modunu ayarla
$ErrorActionPreference = "SilentlyContinue"

# Temizlenecek dizinler
$TargetFolders = @(
    $env:TEMP,
    "$env:SystemDrive\Windows\Temp"
)

$TotalDeletedFiles = 0
$TotalDeletedDirs = 0
$TotalFreedBytes = 0

foreach ($folder in $TargetFolders) {
    if (Test-Path $folder) {
        # Doğrudan klasörün birinci derece çocuklarını alıp altlarıyla beraber silelim
        $items = Get-ChildItem -Path $folder -Force -ErrorAction SilentlyContinue

        foreach ($item in $items) {
            try {
                $itemLength = 0
                if (-not $item.PSIsContainer) {
                    $itemLength = $item.Length
                }

                # Kalıcı silme işlemi (Shift + Delete eşdeğeri)
                Remove-Item -Path $item.FullName -Force -Recurse -ErrorAction Stop

                if ($item.PSIsContainer) {
                    $TotalDeletedDirs++
                } else {
                    $TotalDeletedFiles++
                    $TotalFreedBytes += $itemLength
                }
            } catch {
                # Kullanımda olan / kilitli dosyalar sessizce atlanır
            }
        }
    }
}

# Açığa çıkarılan boyutu formatla
function Format-FileSize($bytes) {
    if ($bytes -ge 1GB) {
        return ("{0:N2} GB" -f ($bytes / 1GB))
    } elseif ($bytes -ge 1MB) {
        return ("{0:N2} MB" -f ($bytes / 1MB))
    } elseif ($bytes -ge 1KB) {
        return ("{0:N2} KB" -f ($bytes / 1KB))
    } else {
        return "$bytes Bayt"
    }
}

$FreedFormatted = Format-FileSize $TotalFreedBytes

# Windows Bildirimi Göster (Türkçe karakterler %100 uyumlu UTF-8 decode ile yüklenir)
try {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $Notify = New-Object System.Windows.Forms.NotifyIcon
    $Notify.Icon = [System.Drawing.SystemIcons]::Information
    $Notify.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info

    # Türkçe metinleri encoding sorunlarına karşı Base64 UTF-8 olarak çözelim
    $titleUtf8 = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("R2XDp2ljaSBEb3N5YWxhciBUZW1pemxlbmRp"))
    $bodyPrefix = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("S3VsbGFuxLFsbWF5YW4g"))
    $bodySuffix = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("IGRvc3lhIHNpbGluZGkuCkHDp8SxbGFuIGFsYW46IA=="))

    $Notify.BalloonTipTitle = $titleUtf8
    $Notify.BalloonTipText = "$bodyPrefix$TotalDeletedFiles$bodySuffix$FreedFormatted"
    $Notify.Visible = $true

    $Notify.ShowBalloonTip(4000)
    Start-Sleep -Seconds 4
    $Notify.Dispose()
} catch {
    # Bildirim oluşturulamazsa sessizce geç
}
