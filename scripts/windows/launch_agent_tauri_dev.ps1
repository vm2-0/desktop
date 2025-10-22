# PowerShell script to launch Tauri agent in development mode
# This script sets the necessary environment variables and runs cargo run

param(
    [string]$RustLog = "debug",
    [string]$PrimaryLogger = "true",
    [string]$ClonesDevMode = "true"
)

# Set error action preference
$ErrorActionPreference = "Stop"

# Define paths
$ProjectRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$TauriDir = Join-Path $ProjectRoot "src-tauri"

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Tauri Agent Development Launcher" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Project Root: $ProjectRoot" -ForegroundColor Yellow
Write-Host "Tauri Directory: $TauriDir" -ForegroundColor Yellow
Write-Host ""
Write-Host "Environment Variables:" -ForegroundColor Cyan
Write-Host "  PRIMARY_LOGGER = $PrimaryLogger" -ForegroundColor White
Write-Host "  RUST_LOG = $RustLog" -ForegroundColor White
Write-Host "  CLONES_DEV_MODE = $ClonesDevMode" -ForegroundColor White
Write-Host ""

# Check if Tauri directory exists
if (-not (Test-Path $TauriDir)) {
    Write-Host "Error: Tauri directory not found at $TauriDir" -ForegroundColor Red
    exit 1
}

# Check if Cargo is available
if (-not (Get-Command "cargo" -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Cargo not found. Please install Rust and Cargo." -ForegroundColor Red
    exit 1
}

Write-Host "Cargo found: $(cargo --version)" -ForegroundColor Green
Write-Host ""

# Clean up any existing agent instances
Write-Host "Checking for existing agent instances..." -ForegroundColor Yellow
$ExistingProcesses = Get-Process -Name "clones_desktop" -ErrorAction SilentlyContinue

if ($ExistingProcesses) {
    Write-Host "Found $($ExistingProcesses.Count) running instance(s). Terminating..." -ForegroundColor Yellow
    Stop-Process -Name "clones_desktop" -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
    Write-Host "Existing instances terminated." -ForegroundColor Green
} else {
    Write-Host "No existing instances found." -ForegroundColor Green
}

# Check if port 19847 is in use
$PortInUse = netstat -ano | Select-String ":19847"
if ($PortInUse) {
    Write-Host "Warning: Port 19847 is still in use. Attempting to free it..." -ForegroundColor Yellow

    # Extract PIDs and kill them
    $PIDs = $PortInUse | ForEach-Object {
        if ($_ -match '\s+(\d+)\s*$') {
            $matches[1]
        }
    } | Select-Object -Unique

    foreach ($ProcessID in $PIDs) {
        try {
            Stop-Process -Id $ProcessID -Force -ErrorAction SilentlyContinue
        } catch {
            Write-Host "Could not kill process $ProcessID" -ForegroundColor Red
        }
    }

    Start-Sleep -Seconds 1
    Write-Host "Port cleanup completed." -ForegroundColor Green
}

Write-Host ""

# Change to Tauri directory
Set-Location $TauriDir
Write-Host "Changed directory to: $(Get-Location)" -ForegroundColor Yellow
Write-Host ""

# Set environment variables
$env:PRIMARY_LOGGER = $PrimaryLogger
$env:RUST_LOG = $RustLog
$env:CLONES_DEV_MODE = $ClonesDevMode

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Starting Tauri Agent..." -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Run cargo
try {
    cargo run
} catch {
    Write-Host ""
    Write-Host "Error running cargo: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
} finally {
    # Return to original directory
    Set-Location $ProjectRoot
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Tauri Agent Stopped" -ForegroundColor Yellow
Write-Host "=====================================" -ForegroundColor Cyan
