@echo off
REM mklinks.bat - Wrapper for mklinks.ps1 PowerShell script
REM Usage: mklinks.bat <config-file>

setlocal enabledelayedexpansion

if "%~1"=="" (
    echo Error: Missing required argument
    echo Usage: mklinks.bat ^<config-file^>
    exit /b 1
)

set "CONFIG_FILE=%~1"
set "SCRIPT_DIR=%~dp0"

REM Check if config file exists
if not exist "%CONFIG_FILE%" (
    echo Error: Config file '%CONFIG_FILE%' not found
    exit /b 1
)

REM Check if PowerShell script exists
if not exist "%SCRIPT_DIR%mklinks.ps1" (
    echo Error: mklinks.ps1 not found in %SCRIPT_DIR%
    exit /b 1
)

REM Check PowerShell version
powershell -Command "if ($PSVersionTable.PSVersion.Major -lt 5) { exit 1 }" >nul 2>&1
if errorlevel 1 (
    echo Error: PowerShell 5.0 or higher is required
    echo Current version can be checked with: powershell -Command "$PSVersionTable.PSVersion"
    exit /b 1
)

REM Run the PowerShell script
echo Running mklinks...
echo.
powershell -ExecutionPolicy Bypass -File "%SCRIPT_DIR%mklinks.ps1" "%CONFIG_FILE%"

if errorlevel 1 (
    echo.
    echo.
    echo ================================================================
    echo mklinks failed!
    echo ================================================================
    echo.
    echo If you got a "privilege" error, try:
    echo   1. Run this batch file as Administrator, OR
    echo   2. Enable Developer Mode in Windows Settings
    echo.
    echo To run as Administrator:
    echo   - Right-click this batch file
    echo   - Select "Run as administrator"
    echo.
    echo To enable Developer Mode:
    echo   - Open Settings ^> Update ^& Security ^> For Developers
    echo   - Turn on "Developer Mode"
    echo   - Restart if prompted
    echo ================================================================
    exit /b 1
)

exit /b 0
