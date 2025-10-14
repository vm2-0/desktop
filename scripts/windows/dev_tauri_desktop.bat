@echo off
REM Windows wrapper for dev_tauri_desktop.ps1
REM This script runs only the Tauri desktop app for testing wallet functionality

echo Starting Tauri Desktop Development (Windows)...

REM Check if we're in the right directory
if not exist "scripts\windows\dev_tauri_desktop.ps1" (
    echo Script not found. Please run this from the desktop directory.
    pause
    exit /b 1
)

REM Run the PowerShell script
echo Using PowerShell script with Windows temp directories
powershell -ExecutionPolicy Bypass -File "%~dp0dev_tauri_desktop.ps1" %*

REM Pause to see any error messages
if errorlevel 1 (
    echo Script failed with error code %errorlevel%
    pause
) 