@echo off
REM Shoebox Utilities Installation Script for Windows
REM 
REM This is a wrapper that calls the PowerShell installation script.
REM 
REM Usage:
REM   install.bat [uninstall]
REM
REM Options:
REM   uninstall    Remove installed utilities

setlocal

REM Check for uninstall parameter
set UNINSTALL_FLAG=
if /i "%~1"=="uninstall" set UNINSTALL_FLAG=-Uninstall

REM Get script directory
set SCRIPT_DIR=%~dp0

REM Check PowerShell version
powershell -NoProfile -Command "exit 0" >nul 2>&1
if errorlevel 1 (
    echo Error: PowerShell is not available or not working.
    echo.
    echo Shoebox Utilities requires PowerShell 5.1 or later.
    echo PowerShell is included with Windows 10 and 11 by default.
    pause
    exit /b 1
)

REM Run the PowerShell installation script
echo Running installation script...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%install.ps1" %UNINSTALL_FLAG%

if errorlevel 1 (
    echo.
    echo Installation failed. See error messages above.
    pause
    exit /b 1
)

echo.
pause
