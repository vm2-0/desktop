# PowerShell script for Flutter Web + Tauri Development
# This script handles both Flutter Web and Tauri development with Windows temp directory support

param(
    [switch]$Clean,
    [switch]$Build
)

# Set error action preference
$ErrorActionPreference = "Stop"

# Define paths
$ProjectRoot = Get-Location
$LockFile = Join-Path $ProjectRoot ".dev_lock"
$LogFile = Join-Path $ProjectRoot "flutter.log"
$TauriDir = Join-Path $ProjectRoot "src-tauri"

# Windows-specific temp directory setup
$TempBuildDir = Join-Path $env:TEMP "clones-desktop-build"
$TempTargetDir = Join-Path $env:TEMP "clones-desktop-target"

Write-Host "Starting Flutter Web + Tauri Development (PowerShell)" -ForegroundColor Green
Write-Host "Project Root: $ProjectRoot" -ForegroundColor Cyan
Write-Host "Tauri Directory: $TauriDir" -ForegroundColor Cyan
Write-Host "Temporary Build Directory: $TempBuildDir" -ForegroundColor Cyan
Write-Host "Temporary Target Directory: $TempTargetDir" -ForegroundColor Cyan

# Function to clean up temporary directory
function Clean-TempBuildDir {
    if (Test-Path $TempBuildDir) {
        Write-Host "Cleaning temporary build directory..." -ForegroundColor Yellow
        Remove-Item -Path $TempBuildDir -Recurse -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
    }
}

# Function to setup temporary build directory
function Setup-TempBuildDir {
    if (-not (Test-Path $TempBuildDir)) {
        Write-Host "Creating temporary build directory..." -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $TempBuildDir -Force | Out-Null
    }
    
    # Copy necessary files to temp directory
    Write-Host "Copying project files to temporary directory..." -ForegroundColor Yellow
    Copy-Item -Path (Join-Path $TauriDir "Cargo.toml") -Destination $TempBuildDir -Force
    Copy-Item -Path (Join-Path $TauriDir "Cargo.lock") -Destination $TempBuildDir -Force
    Copy-Item -Path (Join-Path $TauriDir "tauri.conf.json") -Destination $TempBuildDir -Force
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
}

# Function to cleanup processes
function Cleanup-Processes {
    Write-Host "Cleaning up processes..." -ForegroundColor Yellow
    
    # Kill Flutter processes
    Get-Process -Name "dart" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Get-Process -Name "flutter" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    
    # Remove lock file
    if (Test-Path $LockFile) {
        Remove-Item $LockFile -Force -ErrorAction SilentlyContinue
    }
    
    # Clean up Windows temp directory
    Clean-TempBuildDir
}

# Setup cleanup on exit
trap {
    Cleanup-Processes
    exit 1
}

# Check if already running
if (Test-Path $LockFile) {
    Write-Host "Development server already running. Please stop it first." -ForegroundColor Red
    Write-Host "   Lock file found: $LockFile" -ForegroundColor Red
    exit 1
}

# Create lock file
$PID | Out-File -FilePath $LockFile -Encoding UTF8

# Clean up any existing processes first
Write-Host "Cleaning up existing processes..." -ForegroundColor Yellow
Cleanup-Processes

# Check if Flutter is available
Write-Host "Checking Flutter availability..." -ForegroundColor Cyan
try {
    $FlutterVersion = flutter --version 2>&1
    Write-Host "Flutter found: $($FlutterVersion | Select-Object -First 1)" -ForegroundColor Green
} catch {
    Write-Host "Flutter is not installed or not in PATH" -ForegroundColor Red
    Write-Host "   Please install Flutter from: https://flutter.dev/docs/get-started/install" -ForegroundColor Red
    exit 1
}

# Check Flutter doctor
Write-Host "Running Flutter doctor..." -ForegroundColor Cyan
flutter doctor --quiet 2>&1 | Out-Null

# Setup Windows temp directory
Clean-TempBuildDir
Setup-TempBuildDir

# Set environment variable for Cargo target directory
$env:CARGO_TARGET_DIR = $TempTargetDir
Write-Host "Set CARGO_TARGET_DIR to: $env:CARGO_TARGET_DIR" -ForegroundColor Cyan

# Remove existing log file to start fresh
if (Test-Path $LogFile) {
    Remove-Item $LogFile -Force
}

# Start Flutter Web development server
Write-Host "Starting Flutter Web development server..." -ForegroundColor Green
Write-Host "Flutter will output to: $LogFile" -ForegroundColor Cyan

# Use web-server device to avoid CORS issues (same as macOS script)
# web-server runs a headless server without opening a browser, which bypasses CORS restrictions
$WebDevice = "web-server"
Write-Host "Using web-server device (no CORS issues)" -ForegroundColor Cyan

# Start Flutter in background
$FlutterJob = Start-Job -ScriptBlock {
    param($LogFile, $WebDevice)
    Set-Location $using:ProjectRoot
    Write-Host "Starting Flutter with device: $WebDevice" -ForegroundColor Cyan
    flutter run -d $WebDevice --web-port 3000 --web-hostname 127.0.0.1 2>&1 | Tee-Object -FilePath $LogFile
} -ArgumentList $LogFile, $WebDevice

Write-Host "Flutter process started with Job ID: $($FlutterJob.Id)" -ForegroundColor Green

# Wait for Flutter to be ready
Write-Host "Waiting for Flutter to start..." -ForegroundColor Yellow
$Timeout = 60  # Reduced timeout since we know Flutter is running
$Elapsed = 0
$Ready = $false

while ($Elapsed -lt $Timeout -and -not $Ready) {
    if (Test-Path $LogFile) {
        $LogContent = Get-Content $LogFile -Raw -ErrorAction SilentlyContinue
        # Look for multiple possible success messages
        if ($LogContent -match "lib/main\.dart is being served at" -or 
            $LogContent -match "Flutter run key commands" -or
            $LogContent -match "An Observatory debugger and profiler" -or
            $LogContent -match "The Dart VM service is listening on" -or
            $LogContent -match "Hot reload performed" -or
            $LogContent -match "Flutter is ready" -or
            $LogContent -match "Debug service listening on") {
            $Ready = $true
            Write-Host "Flutter is ready!" -ForegroundColor Green
            break
        }
        
        # Show some debug info every 15 seconds
        if ($Elapsed % 15 -eq 0 -and $Elapsed -gt 0) {
            Write-Host "Debug: Last 3 lines of Flutter log:" -ForegroundColor DarkGray
            Get-Content $LogFile -Tail 3 | ForEach-Object { Write-Host "  $_" -ForegroundColor DarkGray }
        }
    }
    
    # Check if Flutter job is still running
    if ($FlutterJob.State -eq "Failed" -or $FlutterJob.State -eq "Completed") {
        Write-Host "Flutter process failed unexpectedly" -ForegroundColor Red
        $JobOutput = Receive-Job $FlutterJob
        Write-Host "Job output: $JobOutput" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "Still waiting for Flutter to start... ($Elapsed/$Timeout seconds)" -ForegroundColor Yellow
    Start-Sleep -Seconds 3
    $Elapsed += 3
}

# If we didn't detect the specific message but Flutter is still running, assume it's ready
if (-not $Ready -and $FlutterJob.State -eq "Running") {
    Write-Host "Flutter is running but didn't show expected message. Assuming it's ready." -ForegroundColor Yellow
    $Ready = $true
}

if (-not $Ready) {
    Write-Host "Timeout waiting for Flutter to start" -ForegroundColor Red
    if (Test-Path $LogFile) {
        Write-Host "Last 20 lines of log file:" -ForegroundColor Red
        Get-Content $LogFile -Tail 20
    }
    exit 1
}

# Optional buffer for safety
Start-Sleep -Seconds 2

# Start Tauri
Write-Host "Starting Tauri development..." -ForegroundColor Green
Write-Host "Running Tauri from temp directory: $TempBuildDir" -ForegroundColor Cyan

# Change to temp directory and start Tauri
Push-Location $TempBuildDir
try {
    $TauriJob = Start-Job -ScriptBlock {
        param($TempBuildDir)
        Set-Location $TempBuildDir
        cargo tauri dev --config tauri.conf.json
    } -ArgumentList $TempBuildDir
    
    Write-Host "Development servers started!" -ForegroundColor Green
    Write-Host "Flutter Web: http://localhost:3000" -ForegroundColor Cyan
    Write-Host "Tauri App: Starting..." -ForegroundColor Cyan
    Write-Host "Using temporary build directory: $TempBuildDir" -ForegroundColor Cyan
    Write-Host "Using temporary target directory: $TempTargetDir" -ForegroundColor Cyan
    Write-Host "Press Ctrl+C to stop all servers" -ForegroundColor Yellow
    
    # Wait for jobs to complete
    Wait-Job $FlutterJob, $TauriJob
    
} catch {
    Write-Host "Error starting Tauri: $($_.Exception.Message)" -ForegroundColor Red
    throw
} finally {
    Pop-Location
}

# Cleanup on exit
Cleanup-Processes
Write-Host "Script completed" -ForegroundColor Green 