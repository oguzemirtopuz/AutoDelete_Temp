@echo off
chcp 65001 >nul
:: ==============================================================================
:: AutoDelete_Temp - 1-Click Startup Task Uninstaller
:: ==============================================================================
echo ===================================================
echo   AutoDelete_Temp - Remove Startup Task
echo ===================================================
echo.

:: Check for administrative privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [INFO] Requesting administrative privileges...
    powershell -NoProfile -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs"
    exit /b
)

set "TASK_NAME=AutoDeleteTempCleaning"

schtasks /delete /tn "%TASK_NAME%" /f >nul 2>&1

if %errorLevel% equ 0 (
    echo [SUCCESS] Startup task has been removed successfully.
) else (
    echo [INFO] No active scheduled task found to remove.
)

echo.
pause
