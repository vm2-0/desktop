# Clones Desktop - Complete Build & Deploy (Windows)
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("prod", "test")]
    [string]$Environment,
    [switch]$Verbose
)

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

# Main execution
function Main {
    Write-Host "Clones Desktop - Complete Build & Deploy" -ForegroundColor Cyan
    Write-Host "===========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Info "Note: If WiX Toolset is installed, an MSI installer will be created"
    Write-Info "      Otherwise, only ZIP package will be available"
    Write-Host ""

    Write-Info "Step 1/3: Building release..."

    # Execute build script
    try {
        $env:ENVIRONMENT = $Environment
        if ($Verbose) {
            & "scripts\windows\build_release_local.ps1" -Verbose
        } else {
            & "scripts\windows\build_release_local.ps1"
        }

        if ($LASTEXITCODE -ne 0) {
            Write-Error "Build failed, aborting deployment"
            exit 1
        }
    } catch {
        Write-Error "Build script execution failed: $_"
        exit 1
    }

    Write-Success "Build completed successfully!"

    Write-Info "Step 2/3: Generating manifests..."

    # Execute manifest generation script
    try {
        if ($Verbose) {
            & "scripts\windows\generate_manifest_windows.ps1" -Environment $Environment -VerboseLogging
        } else {
            & "scripts\windows\generate_manifest_windows.ps1" -Environment $Environment
        }

        if ($LASTEXITCODE -ne 0) {
            Write-Error "Manifest generation failed, aborting deployment"
            exit 1
        }
    } catch {
        Write-Error "Manifest generation script execution failed: $_"
        exit 1
    }

    Write-Success "Manifests generated successfully!"

    Write-Info "Step 3/3: Uploading to Tigris ($Environment)..."

    # Execute upload script
    try {
        if ($Verbose) {
            & "scripts\windows\upload_windows.ps1" -Environment $Environment -VerboseLogging
        } else {
            & "scripts\windows\upload_windows.ps1" -Environment $Environment
        }

        if ($LASTEXITCODE -ne 0) {
            Write-Error "Upload failed"
            exit 1
        }
    } catch {
        Write-Error "Upload script execution failed: $_"
        exit 1
    }

    Write-Success "Complete deployment finished!"
    Write-Host ""
    
    # Check what was deployed
    $releaseDir = "releases\$Environment\windows"
    if (Test-Path $releaseDir) {
        $msiFiles = Get-ChildItem -Path $releaseDir -Filter "*.msi" -ErrorAction SilentlyContinue
        $zipFiles = Get-ChildItem -Path $releaseDir -Filter "*.zip" -ErrorAction SilentlyContinue
        
        if ($msiFiles) {
            Write-Success "MSI Installer deployed: $($msiFiles[0].Name)"
        }
        if ($zipFiles) {
            Write-Info "ZIP Package also available: $($zipFiles[0].Name)"
        }
    }
    
    Write-Host ""
    Write-Info "Your app is now available:"

    switch ($Environment) {
        "prod" {
            Write-Host "  Downloads: https://releases.clones-ai.com/latest/windows/" -ForegroundColor Cyan
            Write-Host "  Version manifest: https://releases.clones-ai.com/latest/windows/version.json" -ForegroundColor Cyan
            Write-Host "  Tauri updater: https://releases.clones-ai.com/latest/windows/latest.json" -ForegroundColor Cyan
        }
        "test" {
            Write-Host "  Downloads: https://releases-test.clones-ai.com/latest/windows/" -ForegroundColor Cyan
            Write-Host "  Version manifest: https://releases-test.clones-ai.com/latest/windows/version.json" -ForegroundColor Cyan
            Write-Host "  Tauri updater: https://releases-test.clones-ai.com/latest/windows/latest.json" -ForegroundColor Cyan
        }
    }
}

# Run if executed directly
if ($MyInvocation.InvocationName -ne '.') {
    Main
}