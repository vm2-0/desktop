#requires -Version 7
<#
.SYNOPSIS
    Flutter Web + Tauri development script for Windows.
.DESCRIPTION
    Launches the Flutter Web dev server and then starts Tauri.
    Handles locking, logging, and clean shutdown of all processes.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "🚀 Starting Flutter Web + Tauri Development" -ForegroundColor Cyan

# --- Global Variables ---
$RootDir  = Get-Location
$LockFile = Join-Path $RootDir ".dev_lock"
$LogFile  = Join-Path $RootDir "flutter.log"

# --- Cleanup Function ---
function Cleanup {
    Write-Host "🧹 Cleaning up..." -ForegroundColor Yellow

    # Kill Flutter process if still running
    if ($FlutterProcess -and !$FlutterProcess.HasExited) {
        $FlutterProcess.Kill()
    }

    # Kill Tauri process if still running
    if ($TauriProcess -and !$TauriProcess.HasExited) {
        $TauriProcess.Kill()
    }

    # Stop background log tail job
    if ($TailJob) {
        Stop-Job $TailJob -ErrorAction SilentlyContinue
        Remove-Job $TailJob -Force -ErrorAction SilentlyContinue
    }

    # Kill any stray Flutter or tail processes
    Get-Process | Where-Object { $_.ProcessName -match "flutter" -or $_.ProcessName -match "tail" } `
        | ForEach-Object { try { $_.Kill() } catch {} }

    # Remove the lock file if it exists
    if (Test-Path $LockFile) { Remove-Item $LockFile -Force }

    Write-Host "✅ Cleanup complete."
}

# Ensure Cleanup runs when PowerShell exits or user presses Ctrl+C
Register-EngineEvent PowerShell.Exiting -Action { Cleanup }

# --- Check if a dev server is already running ---
if (Test-Path $LockFile) {
    Write-Host "❌ Development server already running. Please stop it first." -ForegroundColor Red
    Write-Host "   Lock file found: $LockFile"
    exit 1
}

# Create the lock file (stores current process ID)
$PID | Out-File -FilePath $LockFile -Encoding ascii -Force

# --- Kill any previous processes just in case ---
Write-Host "🧹 Cleaning up existing processes..."
Get-Process | Where-Object { $_.ProcessName -match "flutter" -or $_.ProcessName -match "tail" -or $_.ProcessName -match "dartaotruntime" } `
    | ForEach-Object { try { $_.Kill() } catch {} }

# Remove old log file
if (Test-Path $LogFile) { Remove-Item $LogFile -Force }

# Give the system a few seconds to fully release ports
Start-Sleep -Seconds 2

# --- 1. Start Flutter Web server ---
Write-Host "📱 Starting Flutter Web development server..." -ForegroundColor Green
$FlutterArgs = "run -d web-server --web-port 3000 --web-hostname 127.0.0.1"
$FlutterProcess = Start-Process pwsh -ArgumentList "-Command", "flutter $FlutterArgs *> '$LogFile'" -NoNewWindow -PassThru

# --- 2. Wait for Flutter to serve the app ---
Write-Host "⏳ Waiting for Flutter to serve lib/main.dart..."
$Ready = $false
while (-not $Ready) {
    Start-Sleep -Seconds 4
    if (Test-Path $LogFile) {
        $Content = Get-Content $LogFile -Raw -ErrorAction SilentlyContinue
        if ($Content -match "lib[/\\]main.dart is being served at") {
            $Ready = $true
        } else {
            Write-Host "⌛ Still waiting for Flutter output..."
        }
    }
}
Write-Host "✅ Flutter is ready!" -ForegroundColor Green
Start-Sleep -Seconds 2

# --- 3. Start Tauri development server ---
Write-Host "🦀 Starting Tauri development..." -ForegroundColor Magenta
Push-Location "$RootDir\src-tauri"
$TauriProcess = Start-Process cargo -ArgumentList "tauri dev --config tauri.conf.json" -NoNewWindow -PassThru
Pop-Location

Write-Host "✅ Development servers started!"
Write-Host "🌐 Flutter Web: http://localhost:3000"
Write-Host "🖥️  Tauri App: Starting..."
Write-Host "🛑 Press Ctrl+C to stop all servers"

# --- 4. Tail Flutter log output in the background ---
$TailJob = Start-Job -ScriptBlock {
    Get-Content -Path $using:LogFile -Wait
}

# --- Keep script running until user stops it ---
try {
    while ($true) { Start-Sleep -Seconds 1 }
}
finally {
    Cleanup
}
