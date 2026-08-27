@echo off
chcp 65001 >nul
:: ==============================================================================
:: AutoDelete_Temp - 1-Click Startup Task Installer
:: ==============================================================================
echo ===================================================
echo   AutoDelete_Temp - Startup Task Setup
echo ===================================================
echo.

:: Check if user is trying to run directly inside a ZIP file
echo "%~dp0" | findstr /i "AppData\\Local\\Temp \.zip" >nul 2>&1
if %errorLevel% equ 0 (
    echo [ERROR] Do NOT run directly from inside the ZIP archiver!
    echo.
    echo Please extract the ZIP file first:
    echo 1. Right-click the downloaded ZIP file.
    echo 2. Click "Extract All..." (Tumunu Ayikla).
    echo 3. Open the extracted folder and run install.bat.
    echo.
    pause
    exit /b
)

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
