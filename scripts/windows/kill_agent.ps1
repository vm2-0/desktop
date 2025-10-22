# PowerShell script to kill all running Clones agent instances
# This script helps clean up when agents get stuck or fail to exit properly

$ErrorActionPreference = "Stop"

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Clones Agent Cleanup Tool" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Find all clones_desktop processes
Write-Host "Searching for running Clones agent processes..." -ForegroundColor Yellow
$Processes = Get-Process -Name "clones_desktop" -ErrorAction SilentlyContinue

if ($Processes) {
    Write-Host "Found $($Processes.Count) running instance(s):" -ForegroundColor Yellow
    Write-Host ""

    foreach ($Process in $Processes) {
        Write-Host "  PID: $($Process.Id)" -ForegroundColor White
        Write-Host "  Name: $($Process.ProcessName)" -ForegroundColor White
        Write-Host "  Start Time: $($Process.StartTime)" -ForegroundColor White
        Write-Host ""
    }

    Write-Host "Terminating all instances..." -ForegroundColor Red
    Stop-Process -Name "clones_desktop" -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1

    # Verify they're gone
    $RemainingProcesses = Get-Process -Name "clones_desktop" -ErrorAction SilentlyContinue
    if ($RemainingProcesses) {
        Write-Host "Warning: Some processes could not be terminated!" -ForegroundColor Red
    } else {
        Write-Host "All Clones agent processes terminated successfully!" -ForegroundColor Green
    }
} else {
    Write-Host "No running Clones agent processes found." -ForegroundColor Green
}

Write-Host ""

# Check if port 19847 is still in use
Write-Host "Checking if port 19847 is in use..." -ForegroundColor Yellow
$PortCheck = netstat -ano | Select-String ":19847"

if ($PortCheck) {
    Write-Host "Port 19847 is still in use:" -ForegroundColor Yellow
    Write-Host $PortCheck -ForegroundColor White

    # Extract PIDs from netstat output
    $PIDs = $PortCheck | ForEach-Object {
        if ($_ -match '\s+(\d+)\s*$') {
            $matches[1]
        }
    } | Select-Object -Unique

    Write-Host ""
    Write-Host "Attempting to terminate processes holding port 19847..." -ForegroundColor Red
    foreach ($PID in $PIDs) {
        try {
            $Process = Get-Process -Id $PID -ErrorAction SilentlyContinue
            if ($Process) {
                Write-Host "  Killing process $PID ($($Process.ProcessName))..." -ForegroundColor Yellow
                Stop-Process -Id $PID -Force -ErrorAction SilentlyContinue
            }
        } catch {
            Write-Host "  Could not kill process $PID" -ForegroundColor Red
        }
    }

    Start-Sleep -Seconds 1

    # Check again
    $PortCheck2 = netstat -ano | Select-String ":19847"
    if ($PortCheck2) {
        Write-Host ""
        Write-Host "Warning: Port 19847 is still in use. Manual intervention may be required." -ForegroundColor Red
    } else {
        Write-Host ""
        Write-Host "Port 19847 is now free!" -ForegroundColor Green
    }
} else {
    Write-Host "Port 19847 is free." -ForegroundColor Green
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Cleanup Complete" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
