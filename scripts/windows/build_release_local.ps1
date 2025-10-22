# PowerShell script for Windows Release Build
# Equivalent to macOS build_release_local.sh

param(
    [switch]$Clean,
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"

Write-Host "🚀 Building Clones Desktop for Windows Release (Local)" -ForegroundColor Green

# Define paths
$ProjectRoot = Get-Location
$BuildDate = Get-Date -Format "yyyyMMdd_HHmmss"
$BuildDir = Join-Path $ProjectRoot "build_output_$BuildDate"
$LogFile = Join-Path $ProjectRoot "build_log_$BuildDate.txt"

Write-Host "Project Root: $ProjectRoot" -ForegroundColor Cyan
Write-Host "Build Directory: $BuildDir" -ForegroundColor Cyan
Write-Host "Log File: $LogFile" -ForegroundColor Cyan

# Colored output functions
function Write-LogInfo($Message) {
    $LogMessage = "[INFO] $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Message"
    Write-Host "$Message" -ForegroundColor Blue
    Add-Content -Path $LogFile -Value $LogMessage
}

function Write-LogSuccess($Message) {
    $LogMessage = "[SUCCESS] $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Message"
    Write-Host "$Message" -ForegroundColor Green
    Add-Content -Path $LogFile -Value $LogMessage
}

function Write-LogWarning($Message) {
    $LogMessage = "[WARNING] $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Message"
    Write-Host "$Message" -ForegroundColor Yellow
    Add-Content -Path $LogFile -Value $LogMessage
}

function Write-LogError($Message) {
    $LogMessage = "[ERROR] $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Message"
    Write-Host "$Message" -ForegroundColor Red
    Add-Content -Path $LogFile -Value $LogMessage
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

    # Check environment files based on ENVIRONMENT variable
    if ($env:ENVIRONMENT) {
        $envFile = ".env.$($env:ENVIRONMENT)"
        if (-not (Test-Path $envFile)) {
            Write-LogError "$envFile file not found. Please create it with your environment variables."
            exit 1
        }
        Write-LogInfo "Will use environment file: $envFile"
    } else {
        # Fallback to generic .env for dev/local usage
        if (-not (Test-Path ".env")) {
            Write-LogError ".env file not found. Please create it with your environment variables."
            exit 1
        }
        Write-LogInfo "Will use generic .env file"
    }

    Write-LogSuccess "Prerequisites check passed"
}

# Setup environment
function Initialize-Environment {
    Write-LogInfo "Setting up environment..."

    # Load environment variables from environment-specific .env file
    $envFile = ".env"

    if ($env:ENVIRONMENT) {
        $envSpecificFile = ".env.$($env:ENVIRONMENT)"
        if (Test-Path $envSpecificFile) {
            $envFile = $envSpecificFile
            Write-LogInfo "Loading environment variables from $envFile (from ENVIRONMENT variable)..."
        } else {
            Write-LogWarning "Environment file $envSpecificFile not found, checking for .env.test..."
        }
    }

    # If no specific environment set or not found, try .env.test
    if ($envFile -eq ".env" -and (Test-Path ".env.test")) {
        $envFile = ".env.test"
        Write-LogInfo "Loading environment variables from .env.test..."
    } elseif ($envFile -eq ".env") {
        Write-LogInfo "Loading environment variables from .env..."
    }

    if (Test-Path $envFile) {
        Get-Content $envFile | ForEach-Object {
            if ($_ -match '^\s*([^#][^=]*)\s*=\s*(.*)\s*$') {
                $name = $matches[1].Trim()
                $value = $matches[2].Trim()
                [Environment]::SetEnvironmentVariable($name, $value, [EnvironmentVariableTarget]::Process)
            }
        }
        Write-LogSuccess "Loaded environment variables from $envFile"
    } else {
        Write-LogWarning "No .env file found"
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

# Build Flutter Windows Native app
function Build-FlutterWindows {
    Write-LogInfo "Building Flutter Windows Native app..."

    $nativeScript = ".\scripts\windows\build_flutter_windows.ps1"
    if (-not (Test-Path $nativeScript)) {
        Write-LogError "Flutter Windows build script not found: $nativeScript"
        exit 1
    }

    $env:BUILD_DIR = $BuildDir
    $env:ENVIRONMENT = if ($env:ENVIRONMENT) { $env:ENVIRONMENT } else { "dev" }

    # Build arguments for the native script
    $scriptArgs = @{
        Environment = $env:ENVIRONMENT
    }
    
    if ($Verbose) {
        $scriptArgs.Verbose = $true
    }

    & $nativeScript @scriptArgs

    if ($LASTEXITCODE -ne 0) {
        throw "Flutter Windows build failed"
    }

    Write-LogSuccess "Flutter Windows build completed"
}

# Main build function
function Invoke-MainBuild {
    Write-LogInfo "Starting main build process..."

    Build-FlutterWindows

    Write-LogSuccess "Build completed!"
    Write-LogInfo "Build artifacts located in: $BuildDir"

    Write-Host ""
    Write-LogInfo "Built artifacts:"
    Get-ChildItem -Path $BuildDir -Recurse -Directory | Where-Object { $_.Name -match "flutter_windows|clones_windows|tauri_agent" } | ForEach-Object {
        Write-Host "  $($_.Name)" -ForegroundColor Cyan
    }
}

# Clean old builds function
function Remove-OldBuilds {
    Write-LogInfo "Cleaning old build artifacts..."

    # Clean old build_output directories
    $oldBuildDirs = Get-ChildItem -Path $ProjectRoot -Directory -Filter "build_output_*" |
                    Sort-Object LastWriteTime -Descending |
                    Select-Object -Skip 1

    if ($oldBuildDirs) {
        foreach ($dir in $oldBuildDirs) {
            Write-LogInfo "Removing old build directory: $($dir.Name)"
            Remove-Item -Path $dir.FullName -Recurse -Force -ErrorAction SilentlyContinue
        }
        Write-LogSuccess "Cleaned $($oldBuildDirs.Count) old build directories"
    } else {
        Write-LogInfo "No old build directories to clean"
    }

    Write-LogSuccess "Old builds cleanup completed"
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
    Write-Host "Clones Desktop - Local Windows Build Script" -ForegroundColor Green
    Write-Host "==============================================" -ForegroundColor Green

    # Initialize log file
    "==============================================================" | Out-File -FilePath $LogFile
    "Clones Desktop - Windows Build Log" | Out-File -FilePath $LogFile -Append
    "Build Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Out-File -FilePath $LogFile -Append
    "==============================================================" | Out-File -FilePath $LogFile -Append
    "" | Out-File -FilePath $LogFile -Append

    Test-Prerequisites
    Initialize-Environment
    Install-Dependencies
    Invoke-MainBuild
    Remove-OldBuilds
    Invoke-Cleanup

    Write-Host ""
    Write-LogSuccess "Build process completed successfully!"
    Write-LogInfo "Your Windows apps are ready for distribution"
    Write-LogInfo "Log file saved to: $LogFile"

} catch {
    Handle-Error $_
}
