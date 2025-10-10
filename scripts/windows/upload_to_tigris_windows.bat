@echo off
setlocal enabledelayedexpansion

:: Check for environment parameter
if "%~1"=="" (
    echo ❌ Usage: %0 ^<environment^>
    echo   Environment: prod, test
    echo   Example: %0 prod
    echo   Example: %0 test
    exit /b 1
)

set "ENVIRONMENT=%~1"

:: Environment configuration
call :set_environment_config "%ENVIRONMENT%"
if errorlevel 1 exit /b 1

set "AWS_CLI_PATH=C:\Program Files\Amazon\AWSCLIV2\aws.exe"

:: Load environment variables from environment-specific .env files
call :load_env "%ENVIRONMENT%"

:: Check prerequisites
call :check_prerequisites
if errorlevel 1 exit /b 1

:: Main upload
call :main_upload
if errorlevel 1 exit /b 1

echo.
echo ✅ Upload completed successfully!
echo.
echo Files available at:
echo   📦 Latest builds: %BUCKET_URL%/latest/windows/
echo   📋 Version manifest: %BUCKET_URL%/latest/windows/version.json
echo   🔄 Tauri updater: %BUCKET_URL%/latest/windows/latest.json
echo   📚 All versions: %BUCKET_URL%/versions/
goto :eof

:set_environment_config
set "env=%~1"
if "%env%"=="prod" (
    set "TIGRIS_BUCKET=clones-desktop-release-prod"
    set "TIGRIS_ENDPOINT=https://fly.storage.tigris.dev"
    set "BUCKET_URL=https://releases.clones-ai.com"
    echo ℹ️ Environment set to: prod (bucket: %TIGRIS_BUCKET%^)
) else if "%env%"=="test" (
    set "TIGRIS_BUCKET=clones-desktop-release-test"
    set "TIGRIS_ENDPOINT=https://fly.storage.tigris.dev"
    set "BUCKET_URL=https://releases-test.clones-ai.com"
    echo ℹ️ Environment set to: test (bucket: %TIGRIS_BUCKET%^)
) else (
    echo ❌ Invalid environment: %env%
    echo   Valid environments: prod, test
    exit /b 1
)
goto :eof

:load_env
set "environment=%~1"
set "env_file=.env.%environment%"

:: Try environment-specific file first
if exist "%env_file%" (
    echo ℹ️ Loading environment variables from %env_file%...
    for /f "usebackq tokens=1,* delims==" %%a in ("%env_file%") do (
        if not "%%a"=="" if not "%%b"=="" (
            set "%%a=%%b"
        )
    )
    echo ✅ Environment variables loaded from %env_file%
) else if exist ".env" (
    echo ℹ️ Loading environment variables from .env...
    for /f "usebackq tokens=1,* delims==" %%a in (".env") do (
        if not "%%a"=="" if not "%%b"=="" (
            set "%%a=%%b"
        )
    )
    echo ⚠️ Using generic .env file. Consider using .env.%environment% for better security
) else (
    echo ⚠️ No .env files found, using system environment variables
)
goto :eof

:check_prerequisites
echo ℹ️ Checking prerequisites...

:: Check AWS CLI
"%AWS_CLI_PATH%" --version >nul 2>&1
if errorlevel 1 (
    echo ❌ AWS CLI not found. Please install AWS CLI
    echo   Download from: https://aws.amazon.com/cli/
    exit /b 1
)

:: Check Tigris credentials
if "%TIGRIS_ACCESS_KEY_ID%"=="" (
    echo ❌ TIGRIS_ACCESS_KEY_ID not found
    echo   Either:
    echo     1. Add TIGRIS_ACCESS_KEY_ID=your_key to .env
    echo     2. Or set TIGRIS_ACCESS_KEY_ID=your_access_key
    exit /b 1
)

if "%TIGRIS_SECRET_ACCESS_KEY%"=="" (
    echo ❌ TIGRIS_SECRET_ACCESS_KEY not found
    echo   Either:
    echo     1. Add TIGRIS_SECRET_ACCESS_KEY=your_secret to .env
    echo     2. Or set TIGRIS_SECRET_ACCESS_KEY=your_secret_key
    exit /b 1
)

echo ✅ Prerequisites check passed
goto :eof

:find_latest_build
set "latest_build="
for /f "delims=" %%d in ('dir /b /ad build_output_* 2^>nul ^| sort /r') do (
    set "latest_build=%%d"
    goto :found_build
)

:found_build
if "%latest_build%"=="" (
    echo ❌ No build output directory found. Please run build_release_local.ps1 first
    exit /b 1
)
goto :eof

:get_app_version
if not exist "src-tauri\tauri.conf.json" (
    echo ❌ src-tauri\tauri.conf.json not found
    exit /b 1
)

:: Extract version using PowerShell
for /f "usebackq delims=" %%v in (`powershell -Command "(Get-Content 'src-tauri\tauri.conf.json' | ConvertFrom-Json).version"`) do (
    set "app_version=%%v"
)

if "%app_version%"=="" (
    echo ❌ Could not extract version from src-tauri\tauri.conf.json
    exit /b 1
)
goto :eof

:clear_latest_directory
echo ℹ️ Clearing 'latest/windows' directory on Tigris...

:: Set AWS environment for Tigris
set "AWS_ACCESS_KEY_ID=%TIGRIS_ACCESS_KEY_ID%"
set "AWS_SECRET_ACCESS_KEY=%TIGRIS_SECRET_ACCESS_KEY%"
set "AWS_ENDPOINT_URL=%TIGRIS_ENDPOINT%"
set "AWS_REGION=auto"

:: Clear latest/windows directory
"%AWS_CLI_PATH%" s3 rm "s3://%TIGRIS_BUCKET%/latest/windows/" --recursive >nul 2>&1
if errorlevel 1 (
    echo ⚠️ Could not clear 'latest/windows' directory. Proceeding with upload anyway.
) else (
    echo ✅ Successfully cleared 'latest/windows' directory.
)
goto :eof

:upload_file
set "file_path=%~1"
set "s3_key=%~2"
set "version=%~3"
set "arch=%~4"
set "file_type=%~5"

echo ℹ️ Uploading %~nx1 to %s3_key%...

:: Get file size and current date
for %%F in ("%file_path%") do set "file_size=%%~zF"
for /f "usebackq delims=" %%d in (`powershell -Command "Get-Date -Format 'yyyy-MM-ddTHH:mm:ssZ'"`) do set "upload_date=%%d"

:: Upload file with metadata
"%AWS_CLI_PATH%" s3 cp "%file_path%" "s3://%TIGRIS_BUCKET%/%s3_key%" --metadata "version=%version%" --metadata "arch=%arch%" --metadata "type=%file_type%" --metadata "uploaded=%upload_date%" --content-type "application/octet-stream" --no-progress

if errorlevel 1 (
    echo ❌ Failed to upload %file_path%
    exit /b 1
) else (
    echo ✅ Uploaded: %BUCKET_URL%/%s3_key%
)
goto :eof

:create_version_manifest
set "version=%~1"
set "build_dir=%~2"
set "manifest_file=%temp%\version_manifest_%random%.json"

:: Get current date for manifest
for /f "usebackq delims=" %%d in (`powershell -Command "Get-Date -Format 'yyyy-MM-ddTHH:mm:ssZ'"`) do set "upload_date=%%d"

:: Start JSON
echo { > "%manifest_file%"
echo   "version": "%version%", >> "%manifest_file%"
echo   "uploadDate": "%upload_date%", >> "%manifest_file%"
echo   "files": { >> "%manifest_file%"

set "entries_added=false"

:: Process MSI files
for /d %%d in ("%build_dir%\msi_*") do (
    for %%f in ("%%d\*.msi") do (
        if exist "%%f" (
            set "filename=%%~nxf"
            for %%s in ("%%f") do set "size=%%~zs"

            if !entries_added!==true echo , >> "%manifest_file%"
            echo     "windows_x64_msi": { >> "%manifest_file%"
            echo       "filename": "!filename!", >> "%manifest_file%"
            echo       "url": "%BUCKET_URL%/latest/windows/!filename!", >> "%manifest_file%"
            echo       "size": !size!, >> "%manifest_file%"
            echo       "arch": "x64", >> "%manifest_file%"
            echo       "type": "msi" >> "%manifest_file%"
            echo     } >> "%manifest_file%"
            set "entries_added=true"
        )
    )
)

:: Process EXE files
for /d %%d in ("%build_dir%\nsis_*") do (
    for %%f in ("%%d\*.exe") do (
        if exist "%%f" (
            set "filename=%%~nxf"
            for %%s in ("%%f") do set "size=%%~zs"

            if !entries_added!==true echo , >> "%manifest_file%"
            echo     "windows_x64_exe": { >> "%manifest_file%"
            echo       "filename": "!filename!", >> "%manifest_file%"
            echo       "url": "%BUCKET_URL%/latest/windows/!filename!", >> "%manifest_file%"
            echo       "size": !size!, >> "%manifest_file%"
            echo       "arch": "x64", >> "%manifest_file%"
            echo       "type": "exe" >> "%manifest_file%"
            echo     } >> "%manifest_file%"
            set "entries_added=true"
        )
    )
)

:: Close JSON
echo   } >> "%manifest_file%"
echo } >> "%manifest_file%"

goto :eof

:create_tauri_manifest
set "version=%~1"
set "build_dir=%~2"
set "tauri_manifest_file=%temp%\tauri_manifest_%random%.json"

:: Get current date for manifest
for /f "usebackq delims=" %%d in (`powershell -Command "Get-Date -Format 'yyyy-MM-ddTHH:mm:ssZ'"`) do set "upload_date=%%d"

:: Start JSON
echo { > "%tauri_manifest_file%"
echo   "version": "%version%", >> "%tauri_manifest_file%"
echo   "notes": "Update to version %version%", >> "%tauri_manifest_file%"
echo   "pub_date": "%upload_date%", >> "%tauri_manifest_file%"
echo   "platforms": { >> "%tauri_manifest_file%"

set "platform_added=false"

:: Look for .msi.zip and .nsis.zip files for Tauri updater
for /d %%d in ("%build_dir%\msi_*") do (
    for %%f in ("%%d\*.msi.zip") do (
        if exist "%%f" (
            set "filename=%%~nxf"
            set "url=%BUCKET_URL%/latest/windows/!filename!"
            
            :: Try to find signature file
            set "sig_file=%%~dpnf.sig"
            set "signature="
            if exist "!sig_file!" (
                for /f "usebackq delims=" %%s in ("!sig_file!") do set "signature=%%s"
            )
            
            if !platform_added!==true echo , >> "%tauri_manifest_file%"
            echo     "windows-x86_64": { >> "%tauri_manifest_file%"
            echo       "signature": "!signature!", >> "%tauri_manifest_file%"
            echo       "url": "!url!" >> "%tauri_manifest_file%"
            echo     } >> "%tauri_manifest_file%"
            set "platform_added=true"
        )
    )
)

:: Look for .nsis.zip files for Tauri updater
for /d %%d in ("%build_dir%\nsis_*") do (
    for %%f in ("%%d\*.nsis.zip") do (
        if exist "%%f" (
            set "filename=%%~nxf"
            set "url=%BUCKET_URL%/latest/windows/!filename!"
            
            :: Try to find signature file
            set "sig_file=%%~dpnf.sig"
            set "signature="
            if exist "!sig_file!" (
                for /f "usebackq delims=" %%s in ("!sig_file!") do set "signature=%%s"
            )
            
            if !platform_added!==true echo , >> "%tauri_manifest_file%"
            echo     "windows-x86_64": { >> "%tauri_manifest_file%"
            echo       "signature": "!signature!", >> "%tauri_manifest_file%"
            echo       "url": "!url!" >> "%tauri_manifest_file%"
            echo     } >> "%tauri_manifest_file%"
            set "platform_added=true"
        )
    )
)

:: Close JSON
echo   } >> "%tauri_manifest_file%"
echo } >> "%tauri_manifest_file%"

goto :eof

:main_upload
call :clear_latest_directory
call :find_latest_build
call :get_app_version

echo ℹ️ Found build directory: %latest_build%
echo ℹ️ App version: %app_version%

:: Set AWS environment for Tigris
set "AWS_ACCESS_KEY_ID=%TIGRIS_ACCESS_KEY_ID%"
set "AWS_SECRET_ACCESS_KEY=%TIGRIS_SECRET_ACCESS_KEY%"
set "AWS_ENDPOINT_URL=%TIGRIS_ENDPOINT%"
set "AWS_REGION=auto"

:: Upload MSI files
for /d %%d in ("%latest_build%\msi_*") do (
    for %%f in ("%%d\*.msi") do (
        if exist "%%f" (
            set "filename=%%~nxf"
            echo ℹ️ Found MSI file: %%f
            call :upload_file "%%f" "versions/%app_version%/windows/!filename!" "%app_version%" "x64" "msi"
            call :upload_file "%%f" "latest/windows/!filename!" "%app_version%" "x64" "msi"
        )
    )
)

:: Upload EXE files
for /d %%d in ("%latest_build%\nsis_*") do (
    for %%f in ("%%d\*.exe") do (
        if exist "%%f" (
            set "filename=%%~nxf"
            echo ℹ️ Found EXE file: %%f
            call :upload_file "%%f" "versions/%app_version%/windows/!filename!" "%app_version%" "x64" "exe"
            call :upload_file "%%f" "latest/windows/!filename!" "%app_version%" "x64" "exe"
        )
    )
)

:: Upload Tauri updater files (.msi.zip, .nsis.zip, .sig)
echo ℹ️ Uploading Tauri updater files...
for /d %%d in ("%latest_build%\msi_*") do (
    for %%f in ("%%d\*.msi.zip") do (
        if exist "%%f" (
            set "filename=%%~nxf"
            echo ℹ️ Found updater file: %%f
            call :upload_file "%%f" "versions/%app_version%/windows/!filename!" "%app_version%" "x64" "updater"
            call :upload_file "%%f" "latest/windows/!filename!" "%app_version%" "x64" "updater"
        )
    )
    for %%f in ("%%d\*.sig") do (
        if exist "%%f" (
            set "filename=%%~nxf"
            echo ℹ️ Found signature file: %%f
            call :upload_file "%%f" "versions/%app_version%/windows/!filename!" "%app_version%" "x64" "signature"
            call :upload_file "%%f" "latest/windows/!filename!" "%app_version%" "x64" "signature"
        )
    )
)

:: Upload NSIS updater files (.nsis.zip, .sig)
for /d %%d in ("%latest_build%\nsis_*") do (
    for %%f in ("%%d\*.nsis.zip") do (
        if exist "%%f" (
            set "filename=%%~nxf"
            echo ℹ️ Found NSIS updater file: %%f
            call :upload_file "%%f" "versions/%app_version%/windows/!filename!" "%app_version%" "x64" "updater"
            call :upload_file "%%f" "latest/windows/!filename!" "%app_version%" "x64" "updater"
        )
    )
    for %%f in ("%%d\*.sig") do (
        if exist "%%f" (
            set "filename=%%~nxf"
            echo ℹ️ Found NSIS signature file: %%f
            call :upload_file "%%f" "versions/%app_version%/windows/!filename!" "%app_version%" "x64" "signature"
            call :upload_file "%%f" "latest/windows/!filename!" "%app_version%" "x64" "signature"
        )
    )
)

:: Create and upload version manifest
echo ℹ️ Creating version manifest...
call :create_version_manifest "%app_version%" "%latest_build%"

if not exist "%manifest_file%" (
    echo ❌ Failed to create manifest file: %manifest_file%
    exit /b 1
)

echo ℹ️ Created manifest file: %manifest_file%
call :upload_file "%manifest_file%" "latest/windows/version.json" "%app_version%" "all" "manifest"
call :upload_file "%manifest_file%" "versions/%app_version%/windows/version.json" "%app_version%" "all" "manifest"
del "%manifest_file%" >nul 2>&1

:: Create and upload Tauri updater manifest
echo ℹ️ Creating Tauri updater manifest...
call :create_tauri_manifest "%app_version%" "%latest_build%"

if not exist "%tauri_manifest_file%" (
    echo ⚠️ Failed to create Tauri manifest, updater will not work
) else (
    echo ℹ️ Created Tauri manifest file: %tauri_manifest_file%
    call :upload_file "%tauri_manifest_file%" "latest/windows/latest.json" "%app_version%" "all" "tauri_manifest"
    call :upload_file "%tauri_manifest_file%" "versions/%app_version%/windows/latest.json" "%app_version%" "all" "tauri_manifest"
    del "%tauri_manifest_file%" >nul 2>&1
)

goto :eof