# Build MSIX package for Windows Store submission
# This script creates a Store-ready MSIX package

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("dev", "test", "prod")]
    [string]$Environment = "prod"
)

$ErrorActionPreference = "Stop"

# Functions for colored output

function Write-LogInfo($Message) {
    Write-Host "$Message" -ForegroundColor Blue
}

function Write-LogSuccess($Message) {
    Write-Host "$Message" -ForegroundColor Green
}

function Write-LogWarning($Message) {
    Write-Host "$Message" -ForegroundColor Yellow
}

function Write-LogError($Message) {
    Write-Host "$Message" -ForegroundColor Red
}

# Main execution
function Main {
    Write-Host "Clones Desktop - Windows Store Build" -ForegroundColor Cyan
    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host ""

    # Check prerequisites
    Write-LogInfo "Checking prerequisites..."
    
    # Check Flutter
    try {
        $flutterVersion = flutter --version 2>&1 | Select-Object -First 1
        Write-LogInfo "Flutter: $flutterVersion"
    } catch {
        Write-LogError "Flutter not found. Please install Flutter."
        exit 1
    }

    # Check if MSIX package is available
    try {
        $result = flutter pub deps | Select-String "msix"
        if (-not $result) {
            Write-LogError "MSIX package not found in dependencies"
            exit 1
        }
        Write-LogInfo "MSIX package found in dependencies"
    } catch {
        Write-LogError "Failed to check MSIX package"
        exit 1
    }

    # Load environment variables if needed
    if ($Environment -ne "dev") {
        $envFile = ".env.$Environment"
        if (Test-Path $envFile) {
            Write-LogInfo "Loading environment from $envFile"
            Get-Content $envFile | ForEach-Object {
                if ($_ -match '^\s*([^#][^=]*)\s*=\s*(.*)\s*$') {
                    $name = $matches[1].Trim()
                    $value = $matches[2].Trim()
                    [Environment]::SetEnvironmentVariable($name, $value, [EnvironmentVariableTarget]::Process)
                }
            }
        } else {
            Write-LogWarning "Environment file $envFile not found"
        }
    }

    # Clean previous builds
    Write-LogInfo "Cleaning previous builds..."
    if (Test-Path "build\windows\runner\Release") {
        Remove-Item -Path "build\windows\runner\Release" -Recurse -Force -ErrorAction SilentlyContinue
    }
    if (Test-Path "build\windows\x64\runner\Release") {
        Remove-Item -Path "build\windows\x64\runner\Release" -Recurse -Force -ErrorAction SilentlyContinue
    }

    # Get Flutter dependencies
    Write-LogInfo "Getting Flutter dependencies..."
    flutter pub get
    if ($LASTEXITCODE -ne 0) {
        Write-LogError "Failed to get Flutter dependencies"
        exit 1
    }

    # Generate code if needed
    Write-LogInfo "Generating Dart code..."
    dart run build_runner build --delete-conflicting-outputs
    if ($LASTEXITCODE -ne 0) {
        Write-LogWarning "Code generation had issues, continuing..."
    }

    # Build Flutter Windows release
    Write-LogInfo "Building Flutter Windows release..."
    flutter build windows --release
    if ($LASTEXITCODE -ne 0) {
        Write-LogError "Flutter Windows build failed"
        exit 1
    }

    Write-LogSuccess "Flutter build completed"

    # Create MSIX package for Store
    Write-LogInfo "Creating MSIX package for Windows Store..."
    
    # Set environment for Store build
    $env:FLUTTER_BUILD_MODE = "release"
    
    # Run MSIX creation with Store flag
    dart run msix:create --store
    
    if ($LASTEXITCODE -ne 0) {
        Write-LogError "MSIX Store package creation failed"
        Write-LogError "Common issues:"
        Write-LogError "  1. Check msix_config in pubspec.yaml"
        Write-LogError "  2. Ensure all required icons exist"
        Write-LogError "  3. Verify version format (x.y.z.w)"
        exit 1
    }

    Write-LogSuccess "MSIX Store package created successfully!"

    # Find the generated MSIX file
    $msixFiles = Get-ChildItem -Path "." -Filter "*.msix" -Recurse | Sort-Object LastWriteTime -Descending
    
    if ($msixFiles) {
        $latestMsix = $msixFiles[0]
        Write-Host ""
        Write-LogSuccess "Store package ready for submission:"
        Write-Host "  File: $($latestMsix.FullName)" -ForegroundColor Cyan
        Write-Host "  Size: $([math]::Round($latestMsix.Length / 1MB, 2)) MB" -ForegroundColor Cyan
        Write-Host ""
        
        # Create releases directory structure
        $releaseDir = "releases\$Environment\windows\store"
        if (-not (Test-Path $releaseDir)) {
            New-Item -ItemType Directory -Path $releaseDir -Force | Out-Null
        }
        
        # Copy MSIX to releases directory
        $destPath = Join-Path $releaseDir $latestMsix.Name
        Copy-Item -Path $latestMsix.FullName -Destination $destPath -Force
        Write-LogInfo "MSIX copied to: $destPath"
        
        Write-LogInfo "Next steps for Windows Store submission:"
        Write-LogInfo "  1. Login to Microsoft Partner Center"
        Write-LogInfo "  2. Create new app submission"
        Write-LogInfo "  3. Upload the MSIX package: $($latestMsix.Name)"
        Write-LogInfo "  4. Fill in app metadata and description"
        Write-LogInfo "  5. Configure pricing and availability"
        Write-LogInfo "  6. Submit for certification"
        Write-Host ""
        Write-LogInfo "Partner Center: https://partner.microsoft.com/dashboard"
        
    } else {
        Write-LogWarning "No MSIX file found after creation"
    }

    Write-LogSuccess "Windows Store build process completed!"
}

# Error handling
trap {
    Write-LogError "Build failed: $_"
    Write-LogError "Check the output above for specific errors"
    exit 1
}

# Run main function
Main