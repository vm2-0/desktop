# Clones Desktop - Windows Appcast Generation Script
# Generates Sparkle-compatible appcast.xml for Windows auto_updater

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("dev", "test", "prod")]
    [string]$Environment,
    [switch]$VerboseLogging
)

$ErrorActionPreference = "Stop"

Write-Host "Generating Windows Appcast for $Environment" -ForegroundColor Cyan

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

# Read version.json manifest
function Get-VersionManifest {
    param([string]$Environment)
    
    $manifestPath = "releases\$Environment\windows\version.json"
    
    if (-not (Test-Path $manifestPath)) {
        Write-LogError "Version manifest not found: $manifestPath"
        Write-LogError "Please run generate_manifest_windows.ps1 first"
        exit 1
    }

    try {
        $manifestContent = Get-Content $manifestPath -Raw | ConvertFrom-Json
        return $manifestContent
    } catch {
        Write-LogError "Failed to parse version manifest: $_"
        exit 1
    }
}

# Get base URL for environment
function Get-BaseUrl {
    param([string]$Environment)
    
    switch ($Environment) {
        "prod" {
            return "https://releases.clones-ai.com"
        }
        "test" {
            return "https://releases-test.clones-ai.com"
        }
        "dev" {
            return "https://releases-test.clones-ai.com"
        }
        default {
            Write-LogError "Invalid environment: $Environment"
            exit 1
        }
    }
}

# Generate Sparkle appcast.xml
function New-AppcastXML {
    param(
        [string]$Version,
        [object]$VersionManifest,
        [string]$BaseUrl,
        [string]$Environment
    )

    $pubDate = [DateTime]::UtcNow.ToString("ddd, dd MMM yyyy HH:mm:ss 'GMT'")
    $releaseNotesUrl = "$BaseUrl/release-notes/$Version.html"
    
    # Prefer MSI installer, fallback to EXE, then ZIP
    $downloadUrl = ""
    $fileSize = 0
    $fileName = ""
    
    if ($VersionManifest.files.PSObject.Properties["windows_x64_msi"]) {
        $file = $VersionManifest.files.windows_x64_msi
        $downloadUrl = $file.url -replace '\{\{BASE_URL\}\}', $BaseUrl
        $fileSize = $file.size
        $fileName = $file.filename
        Write-LogInfo "Using MSI installer for appcast: $fileName"
    } elseif ($VersionManifest.files.PSObject.Properties["windows_x64_exe"]) {
        $file = $VersionManifest.files.windows_x64_exe
        $downloadUrl = $file.url -replace '\{\{BASE_URL\}\}', $BaseUrl
        $fileSize = $file.size
        $fileName = $file.filename
        Write-LogInfo "Using NSIS installer for appcast: $fileName"
    } elseif ($VersionManifest.files.PSObject.Properties["windows_x64_zip"]) {
        $file = $VersionManifest.files.windows_x64_zip
        $downloadUrl = $file.url -replace '\{\{BASE_URL\}\}', $BaseUrl
        $fileSize = $file.size
        $fileName = $file.filename
        Write-LogInfo "Using ZIP archive for appcast: $fileName"
    } else {
        Write-LogError "No suitable Windows files found in version manifest"
        exit 1
    }

    $appcastXml = @"
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" xmlns:dc="http://purl.org/dc/elements/1.1/">
  <channel>
    <title>Clones Desktop</title>
    <link>$BaseUrl/latest/windows/appcast.xml</link>
    <description>Clones Desktop update feed</description>
    <language>en</language>
    <item>
      <title>Version $Version</title>
      <sparkle:releaseNotesLink>$releaseNotesUrl</sparkle:releaseNotesLink>
      <pubDate>$pubDate</pubDate>
      <enclosure 
        url="$downloadUrl"
        sparkle:version="$Version"
        sparkle:shortVersionString="$Version"
        length="$fileSize"
        type="application/octet-stream" />
    </item>
  </channel>
</rss>
"@

    return $appcastXml
}

# Main execution
function Main {
    Write-LogInfo "Starting appcast generation for environment: $Environment"

    # Get version and base URL
    $version = Get-AppVersion
    $baseUrl = Get-BaseUrl -Environment $Environment
    Write-LogInfo "App version: $version"
    Write-LogInfo "Base URL: $baseUrl"

    # Read version manifest
    $versionManifest = Get-VersionManifest -Environment $Environment

    # Generate appcast XML
    $appcastXml = New-AppcastXML -Version $version -VersionManifest $versionManifest -BaseUrl $baseUrl -Environment $Environment

    # Save appcast.xml
    $releaseDir = "releases\$Environment\windows"
    $appcastPath = "$releaseDir\appcast.xml"
    
    $appcastXml | Set-Content -Path $appcastPath -Encoding UTF8

    Write-LogSuccess "Appcast XML generated: $appcastPath"
    
    if ($VerboseLogging) {
        Write-LogInfo "Appcast content:"
        Write-Host $appcastXml -ForegroundColor Gray
    }

    Write-Host ""
    Write-LogSuccess "Appcast generation completed!"
    Write-LogInfo "Appcast file: $appcastPath"
    Write-LogInfo "Feed URL: $baseUrl/latest/windows/appcast.xml"
}

# Run main
try {
    Main
} catch {
    Write-LogError "Appcast generation failed: $_"
    exit 1
}