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

echo ℹ️ Step 1/3: Building release...
powershell -ExecutionPolicy Bypass -Command "$env:ENVIRONMENT='%ENVIRONMENT%'; & 'scripts\windows\build_release_local.ps1'"

if errorlevel 1 (
    echo ❌ Build failed, aborting deployment
    exit /b 1
)

echo ✅ Build completed successfully!

echo ℹ️ Step 2/3: Generating manifests and appcast...
powershell -ExecutionPolicy Bypass -File "scripts\windows\generate_manifest_windows.ps1" -Environment "%ENVIRONMENT%"

if errorlevel 1 (
    echo ❌ Manifest generation failed, aborting deployment
    exit /b 1
)

echo ✅ Manifests and appcast generated successfully!

echo ℹ️ Step 3/3: Uploading to Tigris (%ENVIRONMENT%^)...
call scripts\windows\upload_windows.bat "%ENVIRONMENT%"

if errorlevel 1 (
    echo ❌ Upload failed
    exit /b 1
)

echo.
echo ✅ 🎉 Complete deployment finished!
echo ℹ️ Your app is now available:

if "%ENVIRONMENT%"=="prod" (
    echo   📱 Downloads: https://releases.clones-ai.com/latest/windows/
    echo   🔗 Version manifest: https://releases.clones-ai.com/latest/windows/version.json
    echo   🔄 Auto-updater feed: https://releases.clones-ai.com/latest/windows/appcast.xml
) else if "%ENVIRONMENT%"=="test" (
    echo   📱 Downloads: https://releases-test.clones-ai.com/latest/windows/
    echo   🔗 Version manifest: https://releases-test.clones-ai.com/latest/windows/version.json
    echo   🔄 Auto-updater feed: https://releases-test.clones-ai.com/latest/windows/appcast.xml
) else (
    echo   🌐 Unknown environment: %ENVIRONMENT%
)