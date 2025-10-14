@echo off
REM Windows wrapper for build_release_local.sh
REM This script builds the release version of the Windows app

echo Building Clones Desktop for Windows Release...

REM Check if we're in the right directory
if not exist "scripts\windows\build_release_local.ps1" (
    echo Script not found. Please run this from the desktop directory.
    pause
    exit /b 1
)

REM Run the PowerShell script
echo Using PowerShell script for Windows build
powershell -ExecutionPolicy Bypass -File "%~dp0build_release_local.ps1" %*

REM Pause to see any messages
if errorlevel 1 (
    echo Build failed with error code %errorlevel%
    pause
) else (
    echo Build completed successfully!
    pause
)