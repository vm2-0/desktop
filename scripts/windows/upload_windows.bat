@echo off
setlocal

:: Clones Desktop - Windows Upload Script (Batch wrapper)
:: Calls the PowerShell script with proper parameters

:: Check for environment parameter
if "%~1"=="" (
    echo Usage: %0 ^<environment^>
    echo   Environment: prod, test
    echo   Example: %0 prod
    echo   Example: %0 test
    exit /b 1
)

set "ENVIRONMENT=%~1"

echo Clones Desktop - Windows Upload Script
echo ======================================

:: Call the PowerShell script
powershell -ExecutionPolicy Bypass -File "scripts\windows\upload_windows.ps1" -Environment "%ENVIRONMENT%"

exit /b %ERRORLEVEL%
