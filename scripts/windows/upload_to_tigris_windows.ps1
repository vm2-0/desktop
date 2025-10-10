# Clones Desktop - Windows Tigris Upload Script
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("prod", "test")]
    [string]$Environment,
    [switch]$Verbose
)

# Environment configuration
function Set-EnvironmentConfig {
    param([string]$Env)
    
    switch ($Env) {
        "prod" {
            $script:TIGRIS_BUCKET = "clones-desktop-release-prod"
            $script:BUCKET_URL = "https://releases.clones-ai.com"
        }
        "test" {
            $script:TIGRIS_BUCKET = "clones-desktop-release-test"
            $script:BUCKET_URL = "https://releases-test.clones-ai.com"
        }
        default {
            Write-Error "Invalid environment: $Env"
            Write-Host "  Valid environments: prod, test"
            exit 1
        }
    }
    
    $script:TIGRIS_ENDPOINT = "https://fly.storage.tigris.dev"
    $script:AWS_CLI_PATH = "C:\Program Files\Amazon\AWSCLIV2\aws.exe"
    Write-Info "Environment set to: $Env (bucket: $script:TIGRIS_BUCKET)"
}

# Functions for colored output
function Write-Info($Message) {
    Write-Host "ℹ️  $Message" -ForegroundColor Blue
}

function Write-Success($Message) {
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Write-Warning($Message) {
    Write-Host "⚠️  $Message" -ForegroundColor Yellow
}

function Write-Error($Message) {
    Write-Host "❌ $Message" -ForegroundColor Red
}

# Load environment variables from environment-specific .env files
function Load-Env {
    param([string]$Environment)
    
    $envFile = ".env.$Environment"
    
    # Try environment-specific file first
    if (Test-Path $envFile) {
        Write-Info "Loading environment variables from $envFile..."
        Get-Content $envFile | ForEach-Object {
            if ($_ -match '^([^=]+)=(.*)$') {
                $name = $matches[1].Trim()
                $value = $matches[2].Trim()
                if ($name -and $value) {
                    [Environment]::SetEnvironmentVariable($name, $value, "Process")
                }
            }
        }
        Write-Success "Environment variables loaded from $envFile"
    # Fallback to generic .env for backward compatibility
    } elseif (Test-Path ".env") {
        Write-Info "Loading environment variables from .env..."
        Get-Content ".env" | ForEach-Object {
            if ($_ -match '^([^=]+)=(.*)$') {
                $name = $matches[1].Trim()
                $value = $matches[2].Trim()
                if ($name -and $value) {
                    [Environment]::SetEnvironmentVariable($name, $value, "Process")
                }
            }
        }
        Write-Warning "Using generic .env file. Consider using .env.$Environment for better security"
    } else {
        Write-Warning "No .env files found, using system environment variables"
    }
}

# Check prerequisites
function Test-Prerequisites {
    Write-Info "Checking prerequisites..."

    # Check AWS CLI
    try {
        $null = & $AWS_CLI_PATH --version 2>$null
    } catch {
        Write-Error "AWS CLI not found. Please install AWS CLI"
        Write-Host "  Download from: https://aws.amazon.com/cli/"
        return $false
    }

    # Check Tigris credentials
    if (-not $env:TIGRIS_ACCESS_KEY_ID) {
        Write-Error "TIGRIS_ACCESS_KEY_ID not found"
        Write-Host "  Either:"
        Write-Host "    1. Add TIGRIS_ACCESS_KEY_ID=your_key to .env"
        Write-Host "    2. Or set `$env:TIGRIS_ACCESS_KEY_ID='your_access_key'"
        return $false
    }

    if (-not $env:TIGRIS_SECRET_ACCESS_KEY) {
        Write-Error "TIGRIS_SECRET_ACCESS_KEY not found"
        Write-Host "  Either:"
        Write-Host "    1. Add TIGRIS_SECRET_ACCESS_KEY=your_secret to .env"
        Write-Host "    2. Or set `$env:TIGRIS_SECRET_ACCESS_KEY='your_secret_key'"
        return $false
    }

    Write-Success "Prerequisites check passed"
    return $true
}

# Find latest build directory
function Find-LatestBuild {
    $buildDirs = Get-ChildItem -Directory -Name "build_output_*" | Sort-Object -Descending

    if (-not $buildDirs) {
        Write-Error "No build output directory found. Please run build_release_local.ps1 first"
        return $null
    }

    return $buildDirs[0]
}

# Extract version from Tauri config
function Get-AppVersion {
    if (-not (Test-Path "src-tauri\tauri.conf.json")) {
        Write-Error "src-tauri\tauri.conf.json not found"
        exit 1
    }

    try {
        $config = Get-Content "src-tauri\tauri.conf.json" | ConvertFrom-Json
        $version = $config.version

        if (-not $version) {
            Write-Error "Could not extract version from src-tauri\tauri.conf.json"
            exit 1
        }

        return $version
    } catch {
        Write-Error "Failed to parse src-tauri\tauri.conf.json: $_"
        exit 1
    }
}

# Configure AWS environment for Tigris
function Set-TigrisEnvironment {
    $env:AWS_ACCESS_KEY_ID = $env:TIGRIS_ACCESS_KEY_ID
    $env:AWS_SECRET_ACCESS_KEY = $env:TIGRIS_SECRET_ACCESS_KEY
    $env:AWS_ENDPOINT_URL = $TIGRIS_ENDPOINT
    $env:AWS_REGION = "auto"
}

# Clear the 'latest/windows' directory on Tigris
function Clear-LatestDirectory {
    Write-Info "Clearing 'latest/windows' directory on Tigris..."

    Set-TigrisEnvironment

    try {
        & $AWS_CLI_PATH s3 rm "s3://$TIGRIS_BUCKET/latest/windows/" --recursive | Out-Null
        Write-Success "Successfully cleared 'latest/windows' directory."
    } catch {
        Write-Warning "Could not clear 'latest/windows' directory. Proceeding with upload anyway."
    }
}

# Upload file to Tigris with metadata
function Upload-File {
    param(
        [string]$FilePath,
        [string]$S3Key,
        [string]$Version,
        [string]$Arch,
        [string]$FileType
    )

    $fileName = Split-Path $FilePath -Leaf
    Write-Info "Uploading $fileName to $S3Key..."

    Set-TigrisEnvironment

    $uploadDate = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

    try {
        & $AWS_CLI_PATH s3 cp $FilePath "s3://$TIGRIS_BUCKET/$S3Key" `
            --metadata "version=$Version" `
            --metadata "arch=$Arch" `
            --metadata "type=$FileType" `
            --metadata "uploaded=$uploadDate" `
            --content-type "application/octet-stream" `
            --no-progress

        if ($LASTEXITCODE -eq 0) {
            Write-Success "Uploaded: $BUCKET_URL/$S3Key"
        } else {
            Write-Error "Failed to upload $FilePath"
            return $false
        }
    } catch {
        Write-Error "Failed to upload ${FilePath}: $($_.Exception.Message)"
        return $false
    }

    return $true
}

# Create version manifest
function New-VersionManifest {
    param(
        [string]$Version,
        [string]$BuildDir
    )

    $manifestFile = [System.IO.Path]::GetTempFileName()
    $uploadDate = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

    $manifest = @{
        version = $Version
        uploadDate = $uploadDate
        files = @{}
    }

    # Process MSI files
    $msiFiles = Get-ChildItem "$BuildDir\msi_*\*.msi" -ErrorAction SilentlyContinue
    foreach ($msiFile in $msiFiles) {
        $fileName = $msiFile.Name
        $size = $msiFile.Length

        $manifest.files["windows_x64_msi"] = @{
            filename = $fileName
            url = "$BUCKET_URL/latest/windows/$fileName"
            size = $size
            arch = "x64"
            type = "msi"
        }
    }

    # Process EXE files
    $exeFiles = Get-ChildItem "$BuildDir\nsis_*\*.exe" -ErrorAction SilentlyContinue
    foreach ($exeFile in $exeFiles) {
        $fileName = $exeFile.Name
        $size = $exeFile.Length

        $manifest.files["windows_x64_exe"] = @{
            filename = $fileName
            url = "$BUCKET_URL/latest/windows/$fileName"
            size = $size
            arch = "x64"
            type = "exe"
        }
    }

    # Save manifest to file
    $manifest | ConvertTo-Json -Depth 4 | Set-Content $manifestFile -Encoding UTF8

    return $manifestFile
}

# Create Tauri updater manifest
function New-TauriManifest {
    param(
        [string]$Version,
        [string]$BuildDir
    )

    $manifestFile = [System.IO.Path]::GetTempFileName()
    $uploadDate = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

    # Look for .msi.zip and .nsis.zip files for Tauri updater
    $updaterFiles = @()
    $updaterFiles += Get-ChildItem "$BuildDir\msi_*\*.msi.zip" -ErrorAction SilentlyContinue
    $updaterFiles += Get-ChildItem "$BuildDir\nsis_*\*.nsis.zip" -ErrorAction SilentlyContinue
    $updaterFiles += Get-ChildItem "$BuildDir\msi_*\*.sig" -ErrorAction SilentlyContinue
    $updaterFiles += Get-ChildItem "$BuildDir\nsis_*\*.sig" -ErrorAction SilentlyContinue

    $manifest = @{
        version = $Version
        notes = "Update to version $Version"
        pub_date = $uploadDate
        platforms = @{}
    }

    # Process Windows x64 updates (prefer .nsis.zip over .msi.zip)
    $windowsFile = $updaterFiles | Where-Object { 
        ($_.Name -like "*x64*" -or $_.Name -like "*windows*") -and 
        ($_.Name -like "*.nsis.zip" -or $_.Name -like "*.msi.zip") 
    } | Sort-Object { if ($_.Name -like "*.nsis.zip") { 0 } else { 1 } } | Select-Object -First 1
    if ($windowsFile) {
        $fileName = $windowsFile.Name
        $url = "$BUCKET_URL/latest/windows/$fileName"

        # Try to find signature file (check both msi and nsis directories)
        $sigFile = "$($windowsFile.BaseName).sig"
        $signature = ""
        $sigPath1 = "$BuildDir\msi_*\$sigFile"
        $sigPath2 = "$BuildDir\nsis_*\$sigFile"
        $sigFiles = @()
        $sigFiles += Get-ChildItem $sigPath1 -ErrorAction SilentlyContinue
        $sigFiles += Get-ChildItem $sigPath2 -ErrorAction SilentlyContinue
        if ($sigFiles) {
            $signature = Get-Content $sigFiles[0].FullName -Raw
        }

        $manifest.platforms["windows-x86_64"] = @{
            signature = $signature
            url = $url
        }
    }

    # Save manifest to file
    $manifest | ConvertTo-Json -Depth 4 | Set-Content $manifestFile -Encoding UTF8

    return $manifestFile
}

# Main upload function
function Start-Upload {
    Clear-LatestDirectory

    $buildDir = Find-LatestBuild
    if (-not $buildDir) {
        Write-Error "Cannot proceed without a build directory. Aborting upload."
        exit 1
    }

    $version = Get-AppVersion

    Write-Info "Found build directory: $buildDir"
    Write-Info "App version: $version"

    # Upload MSI files
    $msiFiles = Get-ChildItem "$buildDir\msi_*\*.msi" -ErrorAction SilentlyContinue
    foreach ($msiFile in $msiFiles) {
        $fileName = $msiFile.Name

        # Upload to versioned path
        if (-not (Upload-File $msiFile.FullName "versions/$version/windows/$fileName" $version "x64" "msi")) {
            exit 1
        }

        # Upload to latest path
        if (-not (Upload-File $msiFile.FullName "latest/windows/$fileName" $version "x64" "msi")) {
            exit 1
        }
    }

    # Upload EXE files
    $exeFiles = Get-ChildItem "$buildDir\nsis_*\*.exe" -ErrorAction SilentlyContinue
    foreach ($exeFile in $exeFiles) {
        $fileName = $exeFile.Name

        # Upload to versioned path
        if (-not (Upload-File $exeFile.FullName "versions/$version/windows/$fileName" $version "x64" "exe")) {
            exit 1
        }

        # Upload to latest path
        if (-not (Upload-File $exeFile.FullName "latest/windows/$fileName" $version "x64" "exe")) {
            exit 1
        }
    }

    # Upload Tauri updater files (.msi.zip, .nsis.zip, .sig)
    $updaterFiles = @()
    $updaterFiles += Get-ChildItem "$buildDir\msi_*\*.msi.zip" -ErrorAction SilentlyContinue
    $updaterFiles += Get-ChildItem "$buildDir\nsis_*\*.nsis.zip" -ErrorAction SilentlyContinue
    $updaterFiles += Get-ChildItem "$buildDir\msi_*\*.sig" -ErrorAction SilentlyContinue
    $updaterFiles += Get-ChildItem "$buildDir\nsis_*\*.sig" -ErrorAction SilentlyContinue

    foreach ($updaterFile in $updaterFiles) {
        $fileName = $updaterFile.Name

        # Upload to versioned path
        if (-not (Upload-File $updaterFile.FullName "versions/$version/windows/$fileName" $version "x64" "updater")) {
            exit 1
        }

        # Upload to latest path
        if (-not (Upload-File $updaterFile.FullName "latest/windows/$fileName" $version "x64" "updater")) {
            exit 1
        }
    }

    # Create and upload version manifest
    Write-Info "Creating version manifest..."
    $manifestFile = New-VersionManifest $version $buildDir

    if (-not (Test-Path $manifestFile)) {
        Write-Error "Failed to create manifest file: $manifestFile"
        exit 1
    }

    Write-Info "Created manifest file: $manifestFile"
    if ($Verbose) {
        Write-Info "Manifest content preview:"
        Get-Content $manifestFile | Select-Object -First 10
    }

    if (-not (Upload-File $manifestFile "latest/windows/version.json" $version "all" "manifest")) {
        exit 1
    }
    if (-not (Upload-File $manifestFile "versions/$version/windows/version.json" $version "all" "manifest")) {
        exit 1
    }
    Remove-Item $manifestFile -Force

    # Create and upload Tauri updater manifest
    Write-Info "Creating Tauri updater manifest..."
    $tauriManifestFile = New-TauriManifest $version $buildDir

    if (-not (Test-Path $tauriManifestFile)) {
        Write-Warning "Failed to create Tauri manifest, updater will not work"
    } else {
        Write-Info "Created Tauri manifest file: $tauriManifestFile"
        if ($Verbose) {
            Write-Info "Tauri manifest content:"
            Get-Content $tauriManifestFile
        }

        # Upload Tauri manifest
        # {{target}} will be replaced by 'windows' for Windows
        if (-not (Upload-File $tauriManifestFile "latest/windows/latest.json" $version "all" "tauri_manifest")) {
            Write-Warning "Failed to upload Tauri manifest to latest/windows/"
        }
        if (-not (Upload-File $tauriManifestFile "versions/$version/windows/latest.json" $version "all" "tauri_manifest")) {
            Write-Warning "Failed to upload Tauri manifest to versions/"
        }
        Remove-Item $tauriManifestFile -Force
    }

    Write-Success "🎉 Upload completed successfully!"
    Write-Host ""
    Write-Info "Files available at:"
    Write-Host "  📦 Latest builds: $BUCKET_URL/latest/windows/"
    Write-Host "  📋 Version manifest: $BUCKET_URL/latest/windows/version.json"
    Write-Host "  📚 All versions: $BUCKET_URL/versions/"
}

# Main execution
function Main {
    Write-Host "🚀 Clones Desktop - Tigris Upload Script" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan

    Set-EnvironmentConfig $Environment
    Load-Env $Environment

    if (-not (Test-Prerequisites)) {
        exit 1
    }

    Start-Upload
}

# Run if executed directly
if ($MyInvocation.InvocationName -ne '.') {
    Main
}