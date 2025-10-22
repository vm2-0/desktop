# Clones Desktop - Windows Manifest Generation Script
# Equivalent to macOS generate_appcast.sh
# Generates manifests BEFORE upload for better consistency

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("dev", "test", "prod")]
    [string]$Environment,
    [switch]$VerboseLogging
)

$ErrorActionPreference = "Stop"

Write-Host "Generating Windows Manifests for $Environment" -ForegroundColor Cyan

$ROOT_DIR = Get-Location

# Colored output functions
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

# Find latest build directory
function Find-LatestBuild {
    $buildDirs = Get-ChildItem -Directory -Filter "build_output_*" | Sort-Object Name -Descending

    if (-not $buildDirs) {
        Write-LogError "No build output directory found. Please run build_release_local.ps1 first"
        return $null
    }

    return $buildDirs[0].Name
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
            $version = $matches[1]

            if (-not $version) {
                Write-LogError "Could not extract version from pubspec.yaml"
                exit 1
            }

            return $version
        } else {
            Write-LogError "Could not find version in pubspec.yaml"
            exit 1
        }
    } catch {
        Write-LogError "Failed to parse pubspec.yaml: $_"
        exit 1
    }
}

# Calculate SHA256 checksum
function Get-FileHash256 {
    param([string]$FilePath)

    if (-not (Test-Path $FilePath)) {
        Write-LogError "File not found for checksum: $FilePath"
        return $null
    }

    $hash = Get-FileHash -Path $FilePath -Algorithm SHA256
    return $hash.Hash.ToLower()
}

# Create release directory structure
function Initialize-ReleaseDirectory {
    param(
        [string]$Environment,
        [string]$BuildDir
    )

    $releaseDir = "$ROOT_DIR\releases\$Environment\windows"

    Write-LogInfo "Creating release directory: $releaseDir"

    if (Test-Path $releaseDir) {
        Write-LogWarning "Release directory already exists, cleaning..."
        Remove-Item -Path "$releaseDir\*" -Recurse -Force -ErrorAction SilentlyContinue
    }

    New-Item -ItemType Directory -Path $releaseDir -Force | Out-Null

    return $releaseDir
}

# Create ZIP archive with checksum
function New-ReleaseArchive {
    param(
        [string]$BuildDir,
        [string]$Version,
        [string]$ReleaseDir
    )

    $appDir = "$BuildDir\clones_windows"
    if (-not (Test-Path $appDir)) {
        Write-LogError "App bundle not found at: $appDir"
        return $null
    }

    $zipFileName = "clones-desktop-$Version-windows-x64.zip"
    $zipFile = "$ReleaseDir\$zipFileName"

    Write-LogInfo "Creating release ZIP archive: $zipFileName..."

    try {
        # Create ZIP
        Compress-Archive -Path "$appDir\*" -DestinationPath $zipFile -Force

        # Calculate checksum
        $checksum = Get-FileHash256 $zipFile
        $checksumFile = "$zipFile.sha256"
        $checksum | Set-Content -Path $checksumFile -NoNewline

        Write-LogSuccess "ZIP archive created with SHA256 checksum"
        Write-LogInfo "Checksum: $checksum"

        return @{
            ZipFile = $zipFile
            ChecksumFile = $checksumFile
            Checksum = $checksum
        }
    } catch {
        Write-LogError "Failed to create ZIP archive: $_"
        return $null
    }
}

# Create MSI installer (if available)
function New-MSIInstaller {
    param(
        [string]$BuildDir,
        [string]$Version,
        [string]$ReleaseDir
    )

    # Check multiple possible locations for MSI
    $msiLocations = @(
        "$BuildDir\msi_output",
        "$BuildDir\msi_x64"
    )

    foreach ($msiSource in $msiLocations) {
        if (Test-Path $msiSource) {
            Write-LogInfo "MSI installer found in $msiSource, copying to release directory..."

            $msiFiles = Get-ChildItem -Path $msiSource -Filter "*.msi"
            
            if ($msiFiles) {
                foreach ($file in $msiFiles) {
                    $msiFile = "$ReleaseDir\$($file.Name)"
                    Copy-Item -Path $file.FullName -Destination $msiFile -Force

                    # Calculate checksum
                    $checksum = Get-FileHash256 $msiFile
                    $checksumFile = "$msiFile.sha256"
                    $checksum | Set-Content -Path $checksumFile -NoNewline

                    Write-LogSuccess "MSI installer copied with checksum: $($file.Name)"
                    Write-LogInfo "Checksum: $checksum"

                    return @{
                        MsiFile = $msiFile
                        Checksum = $checksum
                    }
                }
            }
        }
    }

    Write-LogWarning "No MSI installer found in build output"
    Write-LogInfo "Searched in: $($msiLocations -join ', ')"
    return $null
}

# Create NSIS installer (if available)
function New-NSISInstaller {
    param(
        [string]$BuildDir,
        [string]$Version,
        [string]$ReleaseDir
    )

    # Check if NSIS was built
    $nsisSource = "$BuildDir\nsis_x64"
    if (Test-Path $nsisSource) {
        Write-LogInfo "NSIS installer found, copying to release directory..."

        Get-ChildItem -Path $nsisSource -Filter "*.exe" | ForEach-Object {
            $exeFile = "$ReleaseDir\$($_.Name)"
            Copy-Item -Path $_.FullName -Destination $exeFile -Force

            # Calculate checksum
            $checksum = Get-FileHash256 $exeFile
            $checksumFile = "$exeFile.sha256"
            $checksum | Set-Content -Path $checksumFile -NoNewline

            Write-LogSuccess "NSIS installer copied with checksum"

            return @{
                ExeFile = $exeFile
                Checksum = $checksum
            }
        }
    } else {
        Write-LogWarning "No NSIS installer found in build output"
        return $null
    }
}

# Generate version.json manifest
function New-VersionManifest {
    param(
        [string]$Version,
        [hashtable]$Archives,
        [string]$ReleaseDir
    )

    $uploadDate = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

    $manifest = @{
        version = $Version
        uploadDate = $uploadDate
        files = @{}
    }

    # Add ZIP
    if ($Archives.Zip) {
        $zipInfo = $Archives.Zip
        $fileName = Split-Path $zipInfo.ZipFile -Leaf
        $size = (Get-Item $zipInfo.ZipFile).Length

        $manifest.files["windows_x64_zip"] = @{
            filename = $fileName
            url = "{{BASE_URL}}/latest/windows/$fileName"
            size = $size
            arch = "x64"
            type = "zip"
            sha256 = $zipInfo.Checksum
        }
    }

    # Add MSI if available
    if ($Archives.Msi) {
        $msiInfo = $Archives.Msi
        $fileName = Split-Path $msiInfo.MsiFile -Leaf
        $size = (Get-Item $msiInfo.MsiFile).Length

        $manifest.files["windows_x64_msi"] = @{
            filename = $fileName
            url = "{{BASE_URL}}/latest/windows/$fileName"
            size = $size
            arch = "x64"
            type = "msi"
            sha256 = $msiInfo.Checksum
        }
    }

    # Add NSIS if available
    if ($Archives.Nsis) {
        $nsisInfo = $Archives.Nsis
        $fileName = Split-Path $nsisInfo.ExeFile -Leaf
        $size = (Get-Item $nsisInfo.ExeFile).Length

        $manifest.files["windows_x64_exe"] = @{
            filename = $fileName
            url = "{{BASE_URL}}/latest/windows/$fileName"
            size = $size
            arch = "x64"
            type = "exe"
            sha256 = $nsisInfo.Checksum
        }
    }

    # Save manifest
    $manifestFile = "$ReleaseDir\version.json"
    $manifest | ConvertTo-Json -Depth 4 | Set-Content $manifestFile -Encoding UTF8

    Write-LogSuccess "Version manifest created: version.json"
    if ($VerboseLogging) {
        Write-LogInfo "Manifest content:"
        Get-Content $manifestFile
    }

    return $manifestFile
}

# Generate latest.json (Tauri updater manifest)
function New-TauriManifest {
    param(
        [string]$Version,
        [hashtable]$Archives,
        [string]$ReleaseDir
    )

    $uploadDate = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

    $manifest = @{
        version = $Version
        notes = "Update to version $Version"
        pub_date = $uploadDate
        platforms = @{}
    }

    # Prefer MSI if available, fallback to ZIP for Tauri updater
    if ($Archives.Msi) {
        $msiInfo = $Archives.Msi
        $fileName = Split-Path $msiInfo.MsiFile -Leaf

        $manifest.platforms["windows-x86_64"] = @{
            signature = ""  # Will be added when we implement signing
            url = "{{BASE_URL}}/latest/windows/$fileName"  # Placeholder, will be replaced during upload
        }

        Write-LogInfo "Using MSI installer for Tauri updater: $fileName"
    } elseif ($Archives.Zip) {
        $zipInfo = $Archives.Zip
        $fileName = Split-Path $zipInfo.ZipFile -Leaf

        $manifest.platforms["windows-x86_64"] = @{
            signature = ""  # Will be added when we implement signing
            url = "{{BASE_URL}}/latest/windows/$fileName"  # Placeholder, will be replaced during upload
        }

        Write-LogInfo "Using ZIP archive for Tauri updater (no MSI available): $fileName"
    }

    # Save manifest
    $manifestFile = "$ReleaseDir\latest.json"
    $manifest | ConvertTo-Json -Depth 4 | Set-Content $manifestFile -Encoding UTF8

    Write-LogSuccess "Tauri updater manifest created: latest.json"
    if ($VerboseLogging) {
        Write-LogInfo "Manifest content:"
        Get-Content $manifestFile
    }

    return $manifestFile
}

# Main execution
function Main {
    Write-LogInfo "Starting manifest generation for environment: $Environment"

    # Find build directory
    $buildDir = Find-LatestBuild
    if (-not $buildDir) {
        Write-LogError "No build directory found"
        exit 1
    }

    $fullBuildDir = Join-Path $ROOT_DIR $buildDir
    Write-LogInfo "Using build directory: $buildDir"

    # Get version
    $version = Get-AppVersion
    Write-LogInfo "App version: $version"

    # Initialize release directory
    $releaseDir = Initialize-ReleaseDirectory -Environment $Environment -BuildDir $fullBuildDir

    # Create archives and installers
    $archives = @{}

    # Create ZIP (always)
    Write-LogInfo "Creating ZIP archive..."
    $zipInfo = New-ReleaseArchive -BuildDir $fullBuildDir -Version $version -ReleaseDir $releaseDir
    if ($zipInfo) {
        $archives["Zip"] = $zipInfo
    } else {
        Write-LogError "Failed to create ZIP archive"
        exit 1
    }

    # Create MSI if available
    $msiInfo = New-MSIInstaller -BuildDir $fullBuildDir -Version $version -ReleaseDir $releaseDir
    if ($msiInfo) {
        $archives["Msi"] = $msiInfo
    }

    # Create NSIS if available
    $nsisInfo = New-NSISInstaller -BuildDir $fullBuildDir -Version $version -ReleaseDir $releaseDir
    if ($nsisInfo) {
        $archives["Nsis"] = $nsisInfo
    }

    # Generate manifests
    Write-LogInfo "Generating manifests..."
    $versionManifest = New-VersionManifest -Version $version -Archives $archives -ReleaseDir $releaseDir
    $tauriManifest = New-TauriManifest -Version $version -Archives $archives -ReleaseDir $releaseDir

    Write-Host ""
    Write-LogSuccess "Manifest generation completed!"
    Write-LogInfo "Release directory: $releaseDir"
    Write-Host ""
    Write-LogInfo "Generated files:"
    Get-ChildItem -Path $releaseDir | ForEach-Object {
        $icon = switch ($_.Extension) {
            ".zip" { "Zip" }
            ".msi" { "Msi" }
            ".exe" { "Nsis" }
            ".json" { "Json" }
            ".sha256" { "Sha256" }
            default { "File" }
        }
        Write-Host "  $($icon) $($_.Name)" -ForegroundColor Cyan
    }
}

# Run main
try {
    Main
} catch {
    Write-LogError "Manifest generation failed"
    exit 1
}
