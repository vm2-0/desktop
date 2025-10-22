# Clones Desktop - MSI Installer Creator using WiX Toolset
# Creates a professional MSI installer from the Windows app bundle

param(
    [Parameter(Mandatory=$false)]
    [string]$AppDir,
    [Parameter(Mandatory=$false)]
    [string]$OutputDir,
    [switch]$VerboseLogging
)

$ErrorActionPreference = "Stop"

Write-Host "Clones Desktop - MSI Installer Creator" -ForegroundColor Cyan

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

# Get app version from pubspec.yaml
function Get-AppVersion {
    if (-not (Test-Path "pubspec.yaml")) {
        Write-LogError "pubspec.yaml not found"
        exit 1
    }

    try {
        $content = Get-Content "pubspec.yaml" -Raw
        if ($content -match 'version:\s*([^+\s]+)') {
            return $matches[1]
        } else {
            Write-LogError "Could not find version in pubspec.yaml"
            exit 1
        }
    } catch {
        Write-LogError "Failed to parse pubspec.yaml: $_"
        exit 1
    }
}

# Check if WiX is installed
function Test-WixInstalled {
    Write-LogInfo "Checking for WiX Toolset..."

    $wixPaths = @(
        "${env:ProgramFiles(x86)}\WiX Toolset v3.11\bin",
        "${env:ProgramFiles}\WiX Toolset v3.11\bin",
        "${env:ProgramFiles(x86)}\WiX Toolset v3.14\bin",
        "${env:ProgramFiles}\WiX Toolset v3.14\bin"
    )

    foreach ($path in $wixPaths) {
        if (Test-Path "$path\candle.exe") {
            $script:WIX_BIN = $path
            Write-LogSuccess "WiX Toolset found at: $path"
            return $true
        }
    }

    # Check in PATH
    if (Get-Command candle.exe -ErrorAction SilentlyContinue) {
        $script:WIX_BIN = Split-Path (Get-Command candle.exe).Source
        Write-LogSuccess "WiX Toolset found in PATH"
        return $true
    }

    Write-LogError "WiX Toolset not found!"
    Write-Host ""
    Write-Host "Please install WiX Toolset 3.11 or later:"
    Write-Host "  Option 1: winget install --id WixToolset.WixToolset"
    Write-Host "  Option 2: choco install wixtoolset"
    Write-Host "  Option 3: Download from https://wixtoolset.org/releases/"
    return $false
}

# Generate WiX XML file
function New-WixFile {
    param(
        [string]$AppDir,
        [string]$Version,
        [string]$OutputPath
    )

    Write-LogInfo "Generating WiX XML configuration..."

    $upgradeCode = "12345678-1234-1234-1234-123456789012"  # Generate a unique GUID for your app
    $manufacturer = "Clones AI"
    $productName = "Clones Desktop"

    # Create WiX XML
    $wixXml = @"
<?xml version='1.0' encoding='windows-1252'?>
<Wix xmlns='http://schemas.microsoft.com/wix/2006/wi'>
  <Product Name='$productName'
           Id='*'
           UpgradeCode='$upgradeCode'
           Language='1033'
           Codepage='1252'
           Version='$Version'
           Manufacturer='$manufacturer'>

    <Package Id='*'
             Keywords='Installer'
             Description='$productName Installer'
             Manufacturer='$manufacturer'
             InstallerVersion='200'
             Languages='1033'
             Compressed='yes'
             SummaryCodepage='1252' />

    <MajorUpgrade DowngradeErrorMessage='A newer version of $productName is already installed.' />

    <Media Id='1' Cabinet='clones.cab' EmbedCab='yes' />

    <Directory Id='TARGETDIR' Name='SourceDir'>
      <Directory Id='ProgramFilesFolder'>
        <Directory Id='ManufacturerFolder' Name='$manufacturer'>
          <Directory Id='INSTALLFOLDER' Name='$productName'>
            <!-- Files will be added here by heat.exe -->
          </Directory>
        </Directory>
      </Directory>

      <Directory Id='ProgramMenuFolder'>
        <Directory Id='ApplicationProgramsFolder' Name='$productName'/>
      </Directory>

      <Directory Id='DesktopFolder' Name='Desktop'/>
    </Directory>

    <!-- Feature definition -->
    <Feature Id='Complete' Level='1'>
      <ComponentGroupRef Id='AppFiles' />
      <ComponentRef Id='ApplicationShortcut' />
      <ComponentRef Id='DesktopShortcut' />
    </Feature>

    <!-- Start Menu Shortcut -->
    <DirectoryRef Id='ApplicationProgramsFolder'>
      <Component Id='ApplicationShortcut' Guid='*'>
        <Shortcut Id='ApplicationStartMenuShortcut'
                  Name='$productName'
                  Description='Launch $productName'
                  Target='[INSTALLFOLDER]clones.exe'
                  WorkingDirectory='INSTALLFOLDER'/>
        <RemoveFolder Id='CleanUpShortCut' Directory='ApplicationProgramsFolder' On='uninstall'/>
        <RegistryValue Root='HKCU' Key='Software\$manufacturer\$productName' Name='installed' Type='integer' Value='1' KeyPath='yes'/>
      </Component>
    </DirectoryRef>

    <!-- Desktop Shortcut -->
    <DirectoryRef Id='DesktopFolder'>
      <Component Id='DesktopShortcut' Guid='*'>
        <Shortcut Id='ApplicationDesktopShortcut'
                  Name='$productName'
                  Description='Launch $productName'
                  Target='[INSTALLFOLDER]clones.exe'
                  WorkingDirectory='INSTALLFOLDER'/>
        <RegistryValue Root='HKCU' Key='Software\$manufacturer\$productName' Name='desktop_shortcut' Type='integer' Value='1' KeyPath='yes'/>
      </Component>
    </DirectoryRef>

    <!-- UI -->
    <UIRef Id='WixUI_InstallDir' />
    <Property Id='WIXUI_INSTALLDIR' Value='INSTALLFOLDER' />

  </Product>
</Wix>
"@

    Set-Content -Path $OutputPath -Value $wixXml -Encoding UTF8
    Write-LogSuccess "WiX XML file created: $OutputPath"
}

# Harvest files from app directory
function Invoke-HeatHarvest {
    param(
        [string]$AppDir,
        [string]$OutputWxs
    )

    Write-LogInfo "Harvesting files from app directory..."

    $heatExe = Join-Path $WIX_BIN "heat.exe"

    $heatArgs = @(
        "dir", $AppDir,
        "-cg", "AppFiles",
        "-gg",
        "-sfrag",
        "-srd",
        "-dr", "INSTALLFOLDER",
        "-out", $OutputWxs,
        "-var", "var.SourceDir"
    )

    Write-LogInfo "Running: heat.exe $($heatArgs -join ' ')"

    & $heatExe @heatArgs

    if ($LASTEXITCODE -ne 0) {
        Write-LogError "heat.exe failed with exit code $LASTEXITCODE"
        return $false
    }

    Write-LogSuccess "Files harvested successfully"
    return $true
}

# Compile WiX files
function Invoke-Candle {
    param(
        [string[]]$WxsFiles,
        [string]$OutputDir,
        [string]$SourceDir
    )

    Write-LogInfo "Compiling WiX files..."

    $candleExe = Join-Path $WIX_BIN "candle.exe"

    $candleArgs = @(
        "-dSourceDir=$SourceDir",
        "-out", "$OutputDir\",
        "-arch", "x64"
    ) + $WxsFiles

    Write-LogInfo "Running: candle.exe"

    & $candleExe @candleArgs

    if ($LASTEXITCODE -ne 0) {
        Write-LogError "candle.exe failed with exit code $LASTEXITCODE"
        return $false
    }

    Write-LogSuccess "WiX files compiled successfully"
    return $true
}

# Link object files to create MSI
function Invoke-Light {
    param(
        [string]$OutputDir,
        [string]$MsiPath
    )

    Write-LogInfo "Linking to create MSI..."

    $lightExe = Join-Path $WIX_BIN "light.exe"

    $wixobjFiles = Get-ChildItem -Path $OutputDir -Filter "*.wixobj" | Select-Object -ExpandProperty FullName

    $lightArgs = @(
        "-out", $MsiPath,
        "-ext", "WixUIExtension",
        "-sw1076"  # Suppress ICE warning about sequence
    ) + $wixobjFiles

    Write-LogInfo "Running: light.exe"

    & $lightExe @lightArgs

    # Exit code 204 means warnings treated as errors, we'll allow it
    if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne 204) {
        Write-LogError "light.exe failed with exit code $LASTEXITCODE"
        return $false
    }

    if ($LASTEXITCODE -eq 204) {
        Write-LogWarning "light.exe completed with warnings (exit code 204)"
        # Reset exit code since we accept warnings
        $global:LASTEXITCODE = 0
    }

    # Verify MSI was actually created
    if (-not (Test-Path $MsiPath)) {
        Write-LogError "MSI file was not created at: $MsiPath"
        return $false
    }

    Write-LogSuccess "MSI created successfully: $MsiPath"
    return $true
}

# Main execution
function Main {
    # Check WiX installation
    if (-not (Test-WixInstalled)) {
        exit 1
    }

    # Find latest build directory if not specified
    if (-not $AppDir) {
        $buildDirs = Get-ChildItem -Directory -Name "build_output_*" | Sort-Object -Descending
        if (-not $buildDirs) {
            Write-LogError "No build directory found. Please run build script first."
            exit 1
        }
        $latestBuild = $buildDirs[0]
        $AppDir = Join-Path (Get-Location) "$latestBuild\clones_windows"
    }

    if (-not (Test-Path $AppDir)) {
        Write-LogError "App directory not found: $AppDir"
        exit 1
    }

    Write-LogInfo "Using app directory: $AppDir"

    # Get version
    $version = Get-AppVersion
    Write-LogInfo "App version: $version"

    # Create output directory
    if (-not $OutputDir) {
        $OutputDir = Join-Path (Get-Location) "msi_output"
    }

    if (-not (Test-Path $OutputDir)) {
        New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
    }

    $tempDir = Join-Path $OutputDir "temp"
    if (-not (Test-Path $tempDir)) {
        New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
    }

    # Generate WiX files
    $productWxs = Join-Path $tempDir "Product.wxs"
    $filesWxs = Join-Path $tempDir "Files.wxs"

    New-WixFile -AppDir $AppDir -Version $version -OutputPath $productWxs

    # Harvest files
    if (-not (Invoke-HeatHarvest -AppDir $AppDir -OutputWxs $filesWxs)) {
        exit 1
    }

    # Compile
    $wxsFiles = @($productWxs, $filesWxs)
    if (-not (Invoke-Candle -WxsFiles $wxsFiles -OutputDir $tempDir -SourceDir $AppDir)) {
        exit 1
    }

    # Link
    $msiPath = Join-Path $OutputDir "clones-desktop-$version-windows-x64.msi"
    if (-not (Invoke-Light -OutputDir $tempDir -MsiPath $msiPath)) {
        exit 1
    }

    Write-Host ""
    Write-LogSuccess "MSI installer created successfully!"
    Write-Host ""
    Write-LogInfo "MSI Location: $msiPath"
    Write-LogInfo "Size: $([math]::Round((Get-Item $msiPath).Length / 1MB, 2)) MB"
    Write-Host ""
    Write-LogInfo "Next steps:"
    Write-LogInfo "  1. Test the MSI: msiexec /i `"$msiPath`""
    Write-LogInfo "  2. Sign the MSI (recommended for production)"
    Write-LogInfo "  3. Upload to Tigris via deploy script"

    # Ensure exit code is 0 for success
    exit 0
}

# Run main
try {
    Main
} catch {
    Write-LogError "MSI creation failed"
    Write-LogError $_.ScriptStackTrace
    exit 1
}
