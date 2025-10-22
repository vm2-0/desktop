# PowerShell script for building Flutter Native Windows App with Tauri agent integration
# Equivalent to macOS build_flutter_native.sh

param(
    [ValidateSet("dev", "test", "prod")]
    [string]$Environment = "dev",
    [switch]$DryRun,
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"

Write-Host "Building Flutter Native Windows App for environment: $Environment" -ForegroundColor Green
if ($DryRun) {
    Write-Host "DRY RUN MODE - No actual changes will be made" -ForegroundColor Yellow
}
if ($Verbose) {
    Write-Host "Verbose logging enabled" -ForegroundColor Blue
}

$ROOT_DIR = Get-Location
$BUILD_DATE = Get-Date -Format "yyyyMMdd_HHmmss"
$BUILD_DIR = if ($env:BUILD_DIR) { $env:BUILD_DIR } else { "$ROOT_DIR\build_output_$BUILD_DATE" }

# Colored output functions
function Write-LogInfo($Message) {
    Write-Host "$Message" -ForegroundColor Blue
}

function Write-LogVerbose($Message) {
    if ($Verbose) {
        Write-Host "$Message" -ForegroundColor Cyan
    }
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

# Check required tools
function Test-RequiredTools {
    Write-LogInfo "Checking required tools availability..."
    $tools = @("flutter", "cargo", "rustup")
    $missingTools = @()

    foreach ($tool in $tools) {
        if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
            $missingTools += $tool
        }
    }

    if ($missingTools.Count -gt 0) {
        Write-LogError "Required tools missing: $($missingTools -join ', ')"
        Write-LogError "Please install missing tools before running this script"
        exit 1
    }

    Write-LogSuccess "All required tools are available"
}

# Load environment variables
function Initialize-Environment {
    $envFile = "$ROOT_DIR\.env.$Environment"
    if (Test-Path $envFile) {
        Write-LogInfo "Loading environment from: $envFile"
        Get-Content $envFile | ForEach-Object {
            if ($_ -match '^\s*([^#][^=]*)\s*=\s*(.*)\s*$') {
                $name = $matches[1].Trim()
                $value = $matches[2].Trim()
                if ($name -and $value) {
                    [Environment]::SetEnvironmentVariable($name, $value, [EnvironmentVariableTarget]::Process)
                }
            }
        }
        Write-LogSuccess "Environment loaded from $envFile"
    } else {
        Write-LogError "Environment file not found: $envFile"
        exit 1
    }
}

# Build Flutter Windows app
function Build-FlutterWindows {
    Write-LogInfo "Building Flutter Windows application..."

    if ($DryRun) {
        Write-LogInfo "DRY RUN: Would clean Flutter cache"
        Write-LogInfo "DRY RUN: Would get Flutter dependencies"
        Write-LogInfo "DRY RUN: Would build Windows release"
        return
    }

    Write-LogVerbose "Cleaning Flutter cache..."
    flutter clean

    Write-LogVerbose "Getting Flutter dependencies..."
    flutter pub get

    # Build Windows release
    Write-LogInfo "Building Windows release for environment: $Environment..."

    # Extract environment variables for secure build-time injection
    $dartDefines = @("--dart-define=ENVIRONMENT=$Environment")

    # Read environment-specific variables if file exists
    $envFile = ".env.$Environment"
    if (Test-Path $envFile) {
        Write-LogVerbose "Extracting variables from $envFile for secure build..."
        Get-Content $envFile | ForEach-Object {
            if ($_ -match '^\s*([^#][^=]*)\s*=\s*(.*)\s*$') {
                $key = $matches[1].Trim()
                $value = $matches[2].Trim()

                # Only include non-sensitive environment variables
                if ($key -in @("ENV", "API_BACKEND_URL", "API_WEBSITE_URL", "PRIVACY_POLICY_URL", "BASESCAN_BASE_URL", "SUBGRAPH_URL")) {
                    $dartDefines += "--dart-define=$key=$value"
                }
            }
        }
    }

    Write-LogVerbose "Building with dart defines: $($dartDefines -join ' ')"
    flutter build windows --release @dartDefines

    # Copy the Windows build
    $appDir = "$ROOT_DIR\build\windows\x64\runner\Release"
    if ($DryRun) {
        Write-LogInfo "DRY RUN: Would copy app from $appDir to $BUILD_DIR\flutter_windows\"
    } else {
        if (Test-Path $appDir) {
            Write-LogVerbose "Creating Flutter build directory..."
            New-Item -ItemType Directory -Path "$BUILD_DIR\flutter_windows" -Force | Out-Null
            Write-LogVerbose "Copying Flutter Windows app..."
            Copy-Item -Path "$appDir\*" -Destination "$BUILD_DIR\flutter_windows" -Recurse -Force
            Write-LogSuccess "Flutter Windows app copied to build directory"
        } else {
            Write-LogError "Flutter build failed - app not found at: $appDir"
            exit 1
        }
    }

    Write-LogSuccess "Flutter Windows build completed"
}

# Build Tauri agent binary only (no bundle)
function Build-TauriAgent {
    param(
        [string]$Target,
        [string]$Arch
    )

    Write-LogInfo "Building Tauri agent for $Arch ($Target)..."

    Push-Location "$ROOT_DIR\src-tauri"
    try {
        # Add target if not already added
        Write-LogVerbose "Adding Rust target: $Target"
        $oldErrorAction = $ErrorActionPreference
        $ErrorActionPreference = "Continue"
        rustup target add $Target 2>&1 | Out-Null
        $ErrorActionPreference = $oldErrorAction

        # Determine config file based on environment
        $configFile = switch ($Environment) {
            "test" { "tauri.conf.test.json" }
            "prod" { "tauri.conf.prod.json" }
            default { "tauri.conf.json" }
        }

        Write-LogInfo "Using agent config: $configFile"

        if ($DryRun) {
            Write-LogInfo "DRY RUN: Would build Tauri agent with config $configFile for target $Target"
            Write-LogInfo "DRY RUN: Would copy agent binary to build directory"
            return
        }

        # Build the agent binary ONLY (no bundle)
        Write-LogVerbose "Building Tauri agent binary..."
        $env:TAURI_CONFIG_PATH = $configFile
        
        Write-Host "Running: cargo build --release --target $Target" -ForegroundColor Cyan
        
        # Temporarily disable strict error handling for cargo (which may output to stderr)
        $oldErrorAction = $ErrorActionPreference
        $ErrorActionPreference = "Continue"
        $cargoOutput = cargo build --release --target $Target 2>&1
        $cargoExitCode = $LASTEXITCODE
        $ErrorActionPreference = $oldErrorAction
        
        # Display full cargo output for debugging
        Write-Host "Cargo output:" -ForegroundColor Yellow
        $cargoOutput | ForEach-Object { Write-Host $_ }
        
        if ($cargoExitCode -ne 0) {
            Write-LogError "Cargo build failed with exit code: $cargoExitCode"
            Write-LogError "See cargo output above for details"
            return $false
        }
        
        Write-LogSuccess "Cargo build completed successfully"

        # Copy agent binary to build directory
        $agentBinary = "$ROOT_DIR\src-tauri\target\$Target\release\clones_desktop.exe"
        $agentDir = "$BUILD_DIR\tauri_agent_$Arch"

        if (Test-Path $agentBinary) {
            Write-LogVerbose "Creating agent directory: $agentDir"
            New-Item -ItemType Directory -Path $agentDir -Force | Out-Null
            Write-LogVerbose "Copying agent binary..."
            Copy-Item -Path $agentBinary -Destination "$agentDir\clones-desktop.exe" -Force
            Write-LogSuccess "Tauri agent built for $Arch`: $agentDir\clones-desktop.exe"
        } else {
            Write-LogError "Agent binary not found at: $agentBinary"
            return $false
        }
    } finally {
        Pop-Location
    }

    return $true
}

# Create final Windows app bundle
function New-WindowsAppBundle {
    Write-LogInfo "Creating Windows app bundle with agent..."

    $flutterApp = "$BUILD_DIR\flutter_windows"
    $agentBinary = "$BUILD_DIR\tauri_agent_x64\clones-desktop.exe"
    $finalApp = "$BUILD_DIR\clones_windows"

    if ($DryRun) {
        Write-LogInfo "DRY RUN: Would create app bundle from Flutter app and agent binary"
        Write-LogInfo "DRY RUN: Final app would be created at: $finalApp"
        return
    }

    if (-not (Test-Path $flutterApp)) {
        Write-LogError "Flutter app not found at: $flutterApp"
        return $false
    }

    # Copy Flutter app as base
    New-Item -ItemType Directory -Path $finalApp -Force | Out-Null
    Copy-Item -Path "$flutterApp\*" -Destination $finalApp -Recurse -Force

    # Create agent directory and copy agent
    $agentDir = "$finalApp\agent"
    New-Item -ItemType Directory -Path $agentDir -Force | Out-Null

    if (Test-Path $agentBinary) {
        Write-LogInfo "Copying agent binary to app bundle..."
        Copy-Item -Path $agentBinary -Destination "$agentDir\clones-desktop.exe" -Force
        Write-LogSuccess "Agent binary copied to app bundle"
    } else {
        Write-LogError "Agent binary not found at: $agentBinary"
        return $false
    }

    Write-LogSuccess "Windows app bundle created at: $finalApp"
    return $true
}

# Create MSI installer using WiX Toolset
function New-WindowsInstallers {
    Write-LogInfo "Creating MSI installer..."

    if ($DryRun) {
        Write-LogInfo "DRY RUN: Would check for MSI creation capability"
        return $true
    }

    # Check if WiX is installed
    $wixInstalled = $false
    $wixPaths = @(
        "${env:ProgramFiles(x86)}\WiX Toolset v3.11\bin",
        "${env:ProgramFiles}\WiX Toolset v3.11\bin",
        "${env:ProgramFiles(x86)}\WiX Toolset v3.14\bin",
        "${env:ProgramFiles}\WiX Toolset v3.14\bin"
    )

    foreach ($path in $wixPaths) {
        if (Test-Path "$path\candle.exe") {
            $wixInstalled = $true
            break
        }
    }

    # Check PATH as well
    if (-not $wixInstalled) {
        if (Get-Command candle.exe -ErrorAction SilentlyContinue) {
            $wixInstalled = $true
        }
    }

    if (-not $wixInstalled) {
        Write-LogError "WiX Toolset not found!"
        Write-LogError "MSI installer creation requires WiX Toolset"
        Write-LogError ""
        Write-LogError "To install WiX Toolset:"
        Write-LogError "  1. Open PowerShell as Administrator"
        Write-LogError "  2. Run: winget install --id WixToolset.WixToolset"
        Write-LogError "  3. Rebuild the project"
        return $false
    }

    $createMsiScript = "$ROOT_DIR\scripts\windows\create_msi.ps1"
    
    if (-not (Test-Path $createMsiScript)) {
        Write-LogError "MSI creation script not found: $createMsiScript"
        return $false
    }

    Write-LogInfo "WiX Toolset found - creating MSI installer..."

    # Create MSI output directory
    $msiOutputDir = "$BUILD_DIR\msi_output"
    New-Item -ItemType Directory -Path $msiOutputDir -Force | Out-Null

    $oldErrorAction = $ErrorActionPreference
    $ErrorActionPreference = "Continue"

    # Call create_msi.ps1 with proper arguments
    $msiArgs = @{
        AppDir = "$BUILD_DIR\clones_windows"
        OutputDir = $msiOutputDir
    }

    if ($Verbose) {
        $msiArgs.VerboseLogging = $true
    }

    & $createMsiScript @msiArgs
    $msiExitCode = $LASTEXITCODE

    $ErrorActionPreference = $oldErrorAction

    if ($msiExitCode -ne 0) {
        Write-LogError "MSI creation failed"
        return $false
    }

    Write-LogSuccess "MSI installer created successfully"
    return $true
}

# Main build process
function Invoke-MainBuild {
    # Check required tools
    Test-RequiredTools

    # Load environment
    Initialize-Environment

    Write-LogInfo "Starting Flutter Native + Tauri Agent build process..."

    if ($DryRun) {
        Write-LogInfo "DRY RUN: Would create build directory: $BUILD_DIR"
    } else {
        Write-LogVerbose "Creating build directory: $BUILD_DIR"
        New-Item -ItemType Directory -Path $BUILD_DIR -Force | Out-Null
    }

    # Build Flutter Windows app
    Build-FlutterWindows

    # Build Tauri agent for x64
    $success = Build-TauriAgent -Target "x86_64-pc-windows-msvc" -Arch "x64"
    if (-not $success -and -not $DryRun) {
        Write-LogError "Failed to build Tauri agent"
        exit 1
    }

    # Create final app bundle
    $success = New-WindowsAppBundle
    if (-not $success -and -not $DryRun) {
        Write-LogError "Failed to create app bundle"
        exit 1
    }

    # Create installers
    New-WindowsInstallers

    Write-LogSuccess "Build completed!"
    Write-LogInfo "Build artifacts located in: $BUILD_DIR"

    Write-Host ""
    Write-LogInfo "Built artifacts:"
    Get-ChildItem -Path $BUILD_DIR -Directory | ForEach-Object {
        Write-Host "$($_.Name)" -ForegroundColor Cyan
    }
}

# Run main build
try {
    Invoke-MainBuild
} catch {
    Write-LogError "Build failed: $($_.Exception.Message)"
    exit 1
}
