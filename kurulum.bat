@echo off
chcp 65001 >nul
:: ==============================================================================
:: Windows Baslangicina Ekleme (Gorev Zamanlayici Kurucu)
:: ==============================================================================
echo ===================================================
echo   Otomatik Temp Temizleme - Baslangic Kurulumu
echo ===================================================
echo.

:: Yonetici haklarini kontrol et
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [BILGI] Yonetici haklari isteniyor...
    powershell -NoProfile -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs"
    exit /b
)

set "SCRIPT_DIR=%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%setup_task.ps1"

echo.
pause
