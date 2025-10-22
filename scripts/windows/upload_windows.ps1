# Clones Desktop - Windows Upload Script
# Equivalent to macOS upload_sparkle_macos.sh
# Uses pre-generated manifests from generate_manifest_windows.ps1

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("prod", "test")]
    [string]$Environment,
    [switch]$VerboseLogging
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
    Write-Host "$Message" -ForegroundColor Blue
}

function Write-Success($Message) {
    Write-Host "$Message" -ForegroundColor Green
}

function Write-Warning($Message) {
    Write-Host "$Message" -ForegroundColor Yellow
}

function Write-Error($Message) {
    Write-Host "$Message" -ForegroundColor Red
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

# Get app version from pubspec.yaml
function Get-AppVersion {
    if (-not (Test-Path "pubspec.yaml")) {
        Write-Error "pubspec.yaml not found"
        exit 1
    }

    try {
        $content = Get-Content "pubspec.yaml" -Raw

        # Extract version line (format: "version: 0.2.33+1")
        if ($content -match 'version:\s*([^+\s]+)') {
            $version = $matches[1]

            if (-not $version) {
                Write-Error "Could not extract version from pubspec.yaml"
                exit 1
            }

            return $version
        } else {
            Write-Error "Could not find version in pubspec.yaml"
            exit 1
        }
    } catch {
        Write-Error "Failed to parse pubspec.yaml: $_"
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
        [string]$Version
    )

    $fileName = Split-Path $FilePath -Leaf
    Write-Info "Uploading $fileName to $S3Key..."

    Set-TigrisEnvironment

    $uploadDate = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

    try {
        & $AWS_CLI_PATH s3 cp $FilePath "s3://$TIGRIS_BUCKET/$S3Key" `
            --metadata "version=$Version" `
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

# Update manifest URLs with actual bucket URL
function Update-ManifestURLs {
    param(
        [string]$ManifestPath
    )

    if (-not (Test-Path $ManifestPath)) {
        return
    }

    $content = Get-Content $ManifestPath -Raw
    $content = $content -replace '\{\{BASE_URL\}\}', $BUCKET_URL
    Set-Content -Path $ManifestPath -Value $content -NoNewline
}

# Main upload function
function Start-Upload {
    Clear-LatestDirectory

    $version = Get-AppVersion
    $releaseDir = "releases\$Environment\windows"

    Write-Info "App version: $version"
    Write-Info "Release directory: $releaseDir"

    # Check if release directory exists
    if (-not (Test-Path $releaseDir)) {
        Write-Error "Release directory not found: $releaseDir"
        Write-Error "Please run generate_manifest_windows.ps1 first"
        exit 1
    }

    # Upload all files from release directory
    Write-Info "Uploading files from release directory..."

    Get-ChildItem -Path $releaseDir -File | ForEach-Object {
        $file = $_
        $fileName = $file.Name

        # Update manifest URLs before upload
        if ($fileName -match '\.(json)$') {
            Update-ManifestURLs -ManifestPath $file.FullName
        }

        # Upload to both latest and versioned paths
        if (-not (Upload-File $file.FullName "versions/$version/windows/$fileName" $version)) {
            Write-Error "Failed to upload $fileName to versions/"
            exit 1
        }

        if (-not (Upload-File $file.FullName "latest/windows/$fileName" $version)) {
            Write-Error "Failed to upload $fileName to latest/"
            exit 1
        }
    }

    Write-Success "🎉 Upload completed successfully!"
    Write-Host ""
    Write-Info "Files available at:"
    Write-Host "  Latest builds: $BUCKET_URL/latest/windows/" -ForegroundColor Cyan
    Write-Host "  Version manifest: $BUCKET_URL/latest/windows/version.json" -ForegroundColor Cyan
    Write-Host "  Tauri updater: $BUCKET_URL/latest/windows/latest.json" -ForegroundColor Cyan
    Write-Host "  All versions: $BUCKET_URL/versions/" -ForegroundColor Cyan
}

# Main execution
function Main {
    Write-Host "Clones Desktop - Windows Upload Script" -ForegroundColor Cyan

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
