@echo off
chcp 65001 >nul
:: ==============================================================================
:: Baslangic Gorevini Kaldirma
:: ==============================================================================
echo ===================================================
echo   Otomatik Temp Temizleme - Gorevi Kaldir
echo ===================================================
echo.

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [BILGI] Yonetici haklari isteniyor...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs"
    exit /b
)

set "TASK_NAME=AutoDeleteTempCleaning"

schtasks /delete /tn "%TASK_NAME%" /f

if %errorLevel% equ 0 (
    echo.
    echo [BASARILI] Otomatik baslangic gorevi basariyla kaldirildi.
) else (
    echo.
    echo [BILGI] Zaten yuklu boyle bir gorev bulunamadi.
)

echo.
pause
