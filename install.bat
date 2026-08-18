@echo off
chcp 65001 >nul
:: ==============================================================================
:: AutoDelete_Temp - 1-Click Startup Task Installer
:: ==============================================================================
echo ===================================================
echo   AutoDelete_Temp - Startup Task Setup
echo ===================================================
echo.

:: Check for administrative privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [INFO] Requesting administrative privileges...
    powershell -NoProfile -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs"
    exit /b
)

set "SCRIPT_DIR=%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%setup_task.ps1"

echo.
pause
