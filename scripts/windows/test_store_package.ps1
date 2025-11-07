# Test Windows Store MSIX package locally
# Requires Windows Developer Mode to be enabled

param(
    [switch]$Verbose,
    [switch]$Uninstall
)

$ErrorActionPreference = "Stop"

# Functions for colored output
function Write-LogInfo($Message) {
    Write-Host "ℹ️  $Message" -ForegroundColor Blue
}

function Write-LogSuccess($Message) {
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Write-LogWarning($Message) {
    Write-Host "⚠️  $Message" -ForegroundColor Yellow
}

function Write-LogError($Message) {
    Write-Host "❌ $Message" -ForegroundColor Red
}

function Test-DeveloperMode {
    Write-LogInfo "Checking Windows Developer Mode..."
    
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
    $developerUnlock = $false
    $sideloadUnlock = $false
    
    try {
        $developerUnlock = (Get-ItemProperty -Path $regPath -Name "AllowDevelopmentWithoutDevLicense" -ErrorAction SilentlyContinue).AllowDevelopmentWithoutDevLicense -eq 1
        $sideloadUnlock = (Get-ItemProperty -Path $regPath -Name "AllowAllTrustedApps" -ErrorAction SilentlyContinue).AllowAllTrustedApps -eq 1
    } catch {
        # Registry keys might not exist
    }
    
    if ($developerUnlock) {
        Write-LogSuccess "Developer Mode is enabled"
        return $true
    } elseif ($sideloadUnlock) {
        Write-LogSuccess "Sideload apps is enabled"
        return $true
    } else {
        Write-LogError "Developer Mode or Sideload apps must be enabled"
        Write-LogInfo "To enable Developer Mode:"
        Write-LogInfo "  1. Open Settings → Update & Security → For developers"
        Write-LogInfo "  2. Select 'Developer mode' or 'Sideload apps'"
        Write-LogInfo "  3. Restart this script"
        return $false
    }
}

function Find-LatestMsix {
    # Look for MSIX files in common locations
    $searchPaths = @(
        ".\*.msix",
        ".\releases\*\windows\store\*.msix",
        ".\build\windows\*.msix"
    )
    
    $msixFiles = @()
    foreach ($path in $searchPaths) {
        $files = Get-ChildItem -Path $path -ErrorAction SilentlyContinue
        $msixFiles += $files
    }
    
    if ($msixFiles.Count -eq 0) {
        return $null
    }
    
    # Return the most recent MSIX file
    return ($msixFiles | Sort-Object LastWriteTime -Descending)[0]
}

function Test-AppxPackage {
    param([string]$PackageName)
    
    try {
        $package = Get-AppxPackage -Name "*$PackageName*" -ErrorAction SilentlyContinue
        return $package -ne $null
    } catch {
        return $false
    }
}

function Uninstall-ExistingPackage {
    Write-LogInfo "Checking for existing Clones Desktop installation..."
    
    $packages = Get-AppxPackage -Name "*clones*" -ErrorAction SilentlyContinue
    if ($packages) {
        foreach ($package in $packages) {
            Write-LogInfo "Uninstalling existing package: $($package.Name)"
            try {
                Remove-AppxPackage -Package $package.PackageFullName -ErrorAction Stop
                Write-LogSuccess "Uninstalled: $($package.Name)"
            } catch {
                Write-LogWarning "Failed to uninstall $($package.Name): $_"
            }
        }
    } else {
        Write-LogInfo "No existing Clones Desktop packages found"
    }
}

function Install-MsixPackage {
    param([string]$MsixPath)
    
    Write-LogInfo "Installing MSIX package: $MsixPath"
    
    try {
        # Install with developer mode flag
        Add-AppxPackage -Path $MsixPath -ForceApplicationShutdown
        Write-LogSuccess "MSIX package installed successfully!"
        return $true
    } catch {
        Write-LogError "Failed to install MSIX package: $_"
        Write-LogInfo "Common solutions:"
        Write-LogInfo "  1. Ensure Developer Mode is enabled"
        Write-LogInfo "  2. Check if package is properly signed"
        Write-LogInfo "  3. Verify package is not corrupted"
        return $false
    }
}

function Test-AppLaunch {
    Write-LogInfo "Testing app launch..."
    
    # Wait a moment for installation to complete
    Start-Sleep -Seconds 2
    
    # Look for the installed app
    $apps = Get-AppxPackage -Name "*clones*" | Get-AppxPackageManifest
    
    if ($apps) {
        foreach ($app in $apps) {
            $appId = $app.Package.Applications.Application.Id
            $packageFamilyName = (Get-AppxPackage -Name "*clones*").PackageFamilyName
            
            if ($packageFamilyName -and $appId) {
                Write-LogInfo "Attempting to launch app..."
                try {
                    Start-Process "shell:AppsFolder\$packageFamilyName!$appId"
                    Write-LogSuccess "App launched successfully!"
                    Write-LogInfo "App should open in a few seconds..."
                    return $true
                } catch {
                    Write-LogWarning "Failed to launch app via shell: $_"
                }
            }
        }
    }
    
    Write-LogWarning "Could not automatically launch the app"
    Write-LogInfo "Try launching manually from Start Menu: 'Clones Desktop'"
    return $false
}

# Main execution
function Main {
    Write-Host "🧪 Windows Store Package Tester" -ForegroundColor Cyan
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host ""
    
    # Handle uninstall request
    if ($Uninstall) {
        Uninstall-ExistingPackage
        Write-LogSuccess "Uninstall completed"
        return
    }
    
    # Check Developer Mode
    if (-not (Test-DeveloperMode)) {
        exit 1
    }
    
    # Find MSIX package
    $msixFile = Find-LatestMsix
    if (-not $msixFile) {
        Write-LogError "No MSIX package found"
        Write-LogInfo "Run 'scripts\windows\build_store.ps1' first to create MSIX package"
        exit 1
    }
    
    Write-LogInfo "Found MSIX package: $($msixFile.Name)"
    Write-LogInfo "Size: $([math]::Round($msixFile.Length / 1MB, 2)) MB"
    Write-LogInfo "Last Modified: $($msixFile.LastWriteTime)"
    
    # Uninstall existing package
    Uninstall-ExistingPackage
    
    # Install new package
    if (Install-MsixPackage -MsixPath $msixFile.FullName) {
        Write-Host ""
        Write-LogSuccess "Installation completed successfully!"
        
        # Test launch
        if (Test-AppLaunch) {
            Write-Host ""
            Write-LogSuccess "Local testing completed successfully!"
            Write-LogInfo "The app is ready for Windows Store submission"
        }
        
        Write-Host ""
        Write-LogInfo "To uninstall: .\scripts\windows\test_store_package.ps1 -Uninstall"
    }
}

# Error handling
trap {
    Write-LogError "Testing failed: $_"
    exit 1
}

# Check if running as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-LogWarning "This script should be run as Administrator for best results"
    Write-LogInfo "Right-click PowerShell and select 'Run as Administrator'"
    Write-Host ""
}

# Run main function
Main