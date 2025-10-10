# PowerShell script for Windows Release Build
# This script builds the release version of the Windows app

param(
    [switch]$Clean
)

# Set error action preference
$ErrorActionPreference = "Stop"

Write-Host "🚀 Building Clones Desktop for Windows Release (Local)" -ForegroundColor Green

# Define paths
$ProjectRoot = Get-Location
$BuildDate = Get-Date -Format "yyyyMMdd_HHmmss"
$BuildDir = Join-Path $ProjectRoot "build_output_$BuildDate"
$TauriDir = Join-Path $ProjectRoot "src-tauri"

# Windows-specific temp directory setup
$TempBuildDir = Join-Path $env:TEMP "clones-desktop-build"
$TempTargetDir = Join-Path $env:TEMP "clones-desktop-target"

Write-Host "Project Root: $ProjectRoot" -ForegroundColor Cyan
Write-Host "Build Directory: $BuildDir" -ForegroundColor Cyan
Write-Host "Temporary Build Directory: $TempBuildDir" -ForegroundColor Cyan
Write-Host "Temporary Target Directory: $TempTargetDir" -ForegroundColor Cyan

function Write-LogInfo {
    param($Message)
    Write-Host "ℹ️  $Message" -ForegroundColor Blue
}

function Write-LogSuccess {
    param($Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Write-LogWarning {
    param($Message)
    Write-Host "⚠️  $Message" -ForegroundColor Yellow
}

function Write-LogError {
    param($Message)
    Write-Host "❌ $Message" -ForegroundColor Red
}

# Function to clean up temporary directory
function Clean-TempBuildDir {
    if (Test-Path $TempBuildDir) {
        Write-LogInfo "Cleaning temporary build directory..."
        Remove-Item -Path $TempBuildDir -Recurse -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
    }
    if (Test-Path $TempTargetDir) {
        Write-LogInfo "Cleaning temporary target directory..."
        Remove-Item -Path $TempTargetDir -Recurse -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
    }
}

# Function to setup temporary build directory
function Setup-TempBuildDir {
    Write-LogInfo "🪟 Setting up Windows temporary build directory"

    if (-not (Test-Path $TempBuildDir)) {
        Write-LogInfo "Creating temporary build directory..."
        New-Item -ItemType Directory -Path $TempBuildDir -Force | Out-Null
    }

    if (-not (Test-Path $TempTargetDir)) {
        Write-LogInfo "Creating temporary target directory..."
        New-Item -ItemType Directory -Path $TempTargetDir -Force | Out-Null
    }

    # Copy necessary files to temp directory
    Write-LogInfo "📋 Copying project files to temporary directory..."
    Copy-Item -Path (Join-Path $TauriDir "Cargo.toml") -Destination $TempBuildDir -Force
    Copy-Item -Path (Join-Path $TauriDir "Cargo.lock") -Destination $TempBuildDir -Force
    Copy-Item -Path (Join-Path $TauriDir "build.rs") -Destination $TempBuildDir -Force

    # Copy src directory
    $SrcDir = Join-Path $TauriDir "src"
    if (Test-Path $SrcDir) {
        Copy-Item -Path $SrcDir -Destination $TempBuildDir -Recurse -Force
    }

    # Copy other necessary directories
    $DirsToCopy = @("icons", "capabilities")
    foreach ($Dir in $DirsToCopy) {
        $SourceDir = Join-Path $TauriDir $Dir
        if (Test-Path $SourceDir) {
            Copy-Item -Path $SourceDir -Destination $TempBuildDir -Recurse -Force
        }
    }

    Write-LogInfo "🎯 Set CARGO_TARGET_DIR to: $TempTargetDir"
}

# Check prerequisites
function Test-Prerequisites {
    Write-LogInfo "Checking prerequisites..."

    # Check for .tool-versions file
    if (-not (Test-Path ".tool-versions")) {
        Write-LogError ".tool-versions file not found"
        exit 1
    }

    # Read required Flutter version
    $ToolVersions = Get-Content ".tool-versions"
    $FlutterLine = $ToolVersions | Where-Object { $_ -match "^flutter " }
    if (-not $FlutterLine) {
        Write-LogError "Flutter version not found in .tool-versions"
        exit 1
    }
    $RequiredFlutterVersion = ($FlutterLine -split " ")[1]

    # Check if Flutter is available
    try {
        $FlutterVersion = flutter --version 2>&1
        Write-LogInfo "Flutter found: $($FlutterVersion | Select-Object -First 1)"
        Write-LogInfo "Required Flutter version: $RequiredFlutterVersion"
    } catch {
        Write-LogError "Flutter is not installed or not in PATH"
        Write-LogError "Please install Flutter $RequiredFlutterVersion"
        exit 1
    }

    # Check if Cargo is available
    try {
        $CargoVersion = cargo --version 2>&1
        Write-LogInfo "Cargo found: $CargoVersion"
    } catch {
        Write-LogError "Cargo not found. Please install Rust"
        exit 1
    }

    # Check if .env exists
    if (-not (Test-Path ".env")) {
        Write-LogError ".env file not found. Please create it with your environment variables."
        exit 1
    }

    # Check if trusted-signing-cli is available for code signing
    try {
        $TrustedSigningVersion = trusted-signing-cli --version 2>&1
        Write-LogInfo "Trusted Signing CLI found: $TrustedSigningVersion"
    } catch {
        Write-LogWarning "Trusted Signing CLI not found. Code signing will be skipped."
        Write-LogWarning "To enable code signing, install trusted-signing-cli from: https://www.nuget.org/packages/Microsoft.Trusted.Signing.Client"
    }

    Write-LogSuccess "Prerequisites check passed"
}


# Setup environment
function Initialize-Environment {
    Write-LogInfo "Setting up environment..."

    # Load environment variables from .env
    if (Test-Path ".env") {
        Get-Content ".env" | ForEach-Object {
            if ($_ -match "^\s*([^#][^=]*)\s*=\s*(.*)\s*$") {
                $name = $matches[1].Trim()
                $value = $matches[2].Trim()
                [Environment]::SetEnvironmentVariable($name, $value, [EnvironmentVariableTarget]::Process)
            }
        }
        Write-LogInfo "Loaded environment variables from .env"
    }

    # Create build directory
    if (-not (Test-Path $BuildDir)) {
        New-Item -ItemType Directory -Path $BuildDir -Force | Out-Null
        Write-LogInfo "Created build directory: $BuildDir"
    }

    Write-LogInfo "Environment setup completed"
}

# Install dependencies
function Install-Dependencies {
    Write-LogInfo "Installing Flutter dependencies..."
    flutter pub get

    Write-LogInfo "Installing Tauri CLI (if not already installed)..."
    
    # Check if Tauri CLI is installed
    $tauriInstalled = $false
    try {
        $result = cargo tauri --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            $tauriInstalled = $true
            Write-LogInfo "Tauri CLI already installed: $result"
        }
    } catch {
        # Command failed, Tauri CLI not installed
    }
    
    if (-not $tauriInstalled) {
        Write-LogInfo "Installing Tauri CLI..."
        cargo install tauri-cli --version "^2.0"
        if ($LASTEXITCODE -eq 0) {
            Write-LogSuccess "Tauri CLI installed successfully"
        } else {
            throw "Failed to install Tauri CLI"
        }
    }
}

# Build Flutter Web
function Build-Flutter {
    Write-LogInfo "Building Flutter Web..."
    flutter build web --base-href="/"
    Write-LogSuccess "Flutter Web build completed"
}

# Build Tauri for specific target
function Build-TauriTarget {
    param(
        [string]$Target,
        [string]$Arch
    )

    Write-LogInfo "Building Tauri app for $Arch ($Target)..."

    # Build directly from src-tauri directory instead of using temp directory
    Push-Location (Join-Path $ProjectRoot "src-tauri")
    try {
        # Add target if not already added
        Write-LogInfo "Adding Rust target $Target..."
        rustup target add $Target

        # Build the Windows application
        # Use environment-specific config if provided, otherwise use base config
        $ConfigFile = "tauri.conf.json"
        if ($env:ENVIRONMENT) {
            $EnvConfig = "tauri.$($env:ENVIRONMENT).conf.json"
            if (Test-Path "src-tauri\$EnvConfig") {
                $ConfigFile = $EnvConfig
                Write-LogInfo "Using environment-specific config: $ConfigFile"
            } else {
                Write-LogWarning "Environment config $EnvConfig not found, using base config"
            }
        }
        
        # Ensure Tauri signing variables are exported for the build process
        if ($env:TAURI_SIGNING_PRIVATE_KEY) {
            Write-LogInfo "TAURI_SIGNING_PRIVATE_KEY exported for build"
        }
        if ($env:TAURI_SIGNING_PRIVATE_KEY_PASSWORD) {
            Write-LogInfo "TAURI_SIGNING_PRIVATE_KEY_PASSWORD exported for build"
        } else {
            Write-LogWarning "TAURI_SIGNING_PRIVATE_KEY_PASSWORD not found - signing may require manual password input"
        }
        
        Write-LogInfo "Running: cargo tauri build --target $Target --config $ConfigFile"
        Write-LogInfo "Current working directory: $(Get-Location)"

        # Run the build command directly without capturing output to avoid issues
        cargo tauri build --target $Target --config $ConfigFile

        if ($LASTEXITCODE -ne 0) {
            throw "Tauri build failed with exit code $LASTEXITCODE"
        }

        Write-LogSuccess "Tauri build completed successfully"

        # Define where Tauri puts the built files
        $TargetDir = Join-Path $ProjectRoot "src-tauri\target\$Target\release\bundle"

        # Copy MSI installer if it exists
        $MsiDir = Join-Path $TargetDir "msi"
        if (Test-Path $MsiDir) {
            $BuildMsiDir = Join-Path $BuildDir "msi_$Arch"
            New-Item -ItemType Directory -Path $BuildMsiDir -Force | Out-Null
            Copy-Item -Path "$MsiDir\*" -Destination $BuildMsiDir -Recurse -Force
            Write-LogSuccess "MSI installer copied to build directory: msi_$Arch"
        }

        # Copy NSIS installer if it exists
        $NsisDir = Join-Path $TargetDir "nsis"
        if (Test-Path $NsisDir) {
            $BuildNsisDir = Join-Path $BuildDir "nsis_$Arch"
            New-Item -ItemType Directory -Path $BuildNsisDir -Force | Out-Null
            Copy-Item -Path "$NsisDir\*" -Destination $BuildNsisDir -Recurse -Force
            Write-LogSuccess "NSIS installer copied to build directory: nsis_$Arch"
        }

    } finally {
        Pop-Location
    }
}


# Main build function
function Start-MainBuild {
    Write-LogInfo "Starting main build process..."

    # Build for Windows x86_64 (Intel/AMD 64-bit)
    Write-LogInfo "Building for Windows x86_64..."
    Build-TauriTarget -Target "x86_64-pc-windows-msvc" -Arch "x64"

    Write-LogSuccess "Build completed!"
    Write-LogInfo "Build artifacts located in: $BuildDir"

    # List built artifacts
    Write-Host ""
    Write-LogInfo "Built artifacts:"
    Get-ChildItem -Path $BuildDir -Recurse -Include "*.msi", "*.exe" | ForEach-Object {
        $IsSigned = "❓"
        try {
            # Check if file is signed using Get-AuthenticodeSignature
            $Signature = Get-AuthenticodeSignature -FilePath $_.FullName -ErrorAction SilentlyContinue
            if ($Signature -and $Signature.Status -eq "Valid") {
                $IsSigned = "🔒"
            } elseif ($Signature -and $Signature.Status -ne "NotSigned") {
                $IsSigned = "⚠️"
            } else {
                $IsSigned = "🔓"
            }
        } catch {
            $IsSigned = "❓"
        }
        Write-Host "  📦 $($_.Name) $IsSigned" -ForegroundColor Cyan
    }
}

# Cleanup function
function Invoke-Cleanup {
    Write-LogInfo "Cleaning up temporary files..."
    # Clean up any temporary files if needed
    Write-LogInfo "Cleanup completed"
}

# Error handling
function Handle-Error {
    param($ErrorRecord)
    Write-LogError "Build failed! Check the output above for errors."
    Write-LogError "Error: $($ErrorRecord.Exception.Message)"
    Invoke-Cleanup
    exit 1
}

# Main execution
try {
    Write-Host "📱 Clones Desktop - Local Windows Build Script" -ForegroundColor Green
    Write-Host "==============================================" -ForegroundColor Green

    Test-Prerequisites
    Initialize-Environment
    Install-Dependencies
    Build-Flutter
    Start-MainBuild
    Invoke-Cleanup

    Write-Host ""
    Write-LogSuccess "🎉 Build process completed successfully!"
    Write-LogInfo "Your Windows apps are ready for distribution"

} catch {
    Handle-Error $_
}
