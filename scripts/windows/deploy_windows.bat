@echo off
setlocal

:: Check for environment parameter
if "%~1"=="" (
    echo ❌ Usage: %0 ^<environment^>
    echo   Environment: prod, test
    echo   Example: %0 prod
    echo   Example: %0 test
    exit /b 1
)

set "ENVIRONMENT=%~1"

echo 🚀 Clones Desktop - Complete Build ^& Deploy
echo ===========================================

echo ℹ️ Step 1/2: Building release...
powershell -ExecutionPolicy Bypass -Command "$env:ENVIRONMENT='%ENVIRONMENT%'; & 'scripts\windows\build_release_local.ps1'"

if errorlevel 1 (
    echo ❌ Build failed, aborting deployment
    exit /b 1
)

echo ✅ Build completed successfully!

echo ℹ️ Step 2/2: Uploading to Tigris (%ENVIRONMENT%^)...
call scripts\windows\upload_to_tigris_windows.bat "%ENVIRONMENT%"

if errorlevel 1 (
    echo ❌ Upload failed
    exit /b 1
)

echo ✅ Complete deployment finished!
echo ℹ️ Your app is now available for download at:

if "%ENVIRONMENT%"=="prod" (
    echo   🌐 https://releases.clones-ai.com/latest/windows/
) else if "%ENVIRONMENT%"=="test" (
    echo   🌐 https://releases-test.clones-ai.com/latest/windows/
) else (
    echo   🌐 Unknown environment: %ENVIRONMENT%
)