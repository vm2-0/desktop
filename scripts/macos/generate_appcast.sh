#!/bin/bash

set -euo pipefail

# Enable verbose debug output if requested
if [ "${VERBOSE:-false}" = true ]; then
    set -x
    echo "VERBOSE MODE ENABLED"
fi

echo "🔗 Generating Sparkle Appcast"

ROOT_DIR=$(pwd)
ENVIRONMENT="${1:-test}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}INFO: $1${NC}"
}

log_success() {
    echo -e "${GREEN}SUCCESS: $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}WARNING: $1${NC}"
}

log_error() {
    echo -e "${RED}ERROR: $1${NC}"
}

# Resolve Sparkle CLI path robustly
resolve_generate_appcast() {
    # Explicit override via env var
    if [ -n "${GENERATE_APPCAST_BIN:-}" ] && [ -x "$GENERATE_APPCAST_BIN" ]; then
        echo "$GENERATE_APPCAST_BIN"
        return 0
    fi
    # Try in PATH first
    if command -v generate_appcast >/dev/null 2>&1; then
        echo "$(command -v generate_appcast)"
        return 0
    fi
    # Common Homebrew locations
    for p in /opt/homebrew/bin /usr/local/bin; do
        if [ -x "$p/generate_appcast" ]; then
            echo "$p/generate_appcast"
            return 0
        fi
    done
    # Homebrew prefix
    if command -v brew >/dev/null 2>&1; then
        local bp
        bp=$(brew --prefix 2>/dev/null || true)
        if [ -n "$bp" ] && [ -x "$bp/bin/generate_appcast" ]; then
            echo "$bp/bin/generate_appcast"
            return 0
        fi
        # Some formulae expose via opt path
        if [ -x "/opt/homebrew/opt/sparkle/bin/generate_appcast" ]; then
            echo "/opt/homebrew/opt/sparkle/bin/generate_appcast"
            return 0
        fi
        if [ -x "/usr/local/opt/sparkle/bin/generate_appcast" ]; then
            echo "/usr/local/opt/sparkle/bin/generate_appcast"
            return 0
        fi
        # Fallback to Cellar latest
        local cellar
        cellar=$(brew --cellar sparkle 2>/dev/null || true)
        if [ -n "$cellar" ]; then
            local latest
            latest=$(ls -1dt "$cellar"/* 2>/dev/null | head -n1)
            if [ -n "$latest" ] && [ -x "$latest/bin/generate_appcast" ]; then
                echo "$latest/bin/generate_appcast"
                return 0
            fi
        fi
    fi
    # xcrun fallback (unlikely)
    if command -v xcrun >/dev/null 2>&1; then
        local xr
        xr=$(xcrun --find generate_appcast 2>/dev/null || true)
        if [ -n "$xr" ] && [ -x "$xr" ]; then
            echo "$xr"
            return 0
        fi
    fi
    echo ""  # not found
}

# Global for resolved CLI path
GEN_APPCAST=""

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Verify Xcode Command Line Tools
    if ! xcode-select -p >/dev/null 2>&1; then
        log_error "Xcode Command Line Tools not found"
        log_info "Install with: xcode-select --install"
        exit 1
    fi
    
    # Check xcrun availability and version
    if ! command -v xcrun >/dev/null 2>&1; then
        log_error "xcrun not found"
        exit 1
    fi
    
    local xcode_version
    xcode_version=$(xcrun xcodebuild -version 2>/dev/null | head -1 | awk '{print $2}' || echo "unknown")
    log_info "Xcode version: $xcode_version"
    
    # Check if Sparkle's generate_appcast tool is available
    GEN_APPCAST=$(resolve_generate_appcast)
    if [ -z "$GEN_APPCAST" ]; then
        log_error "Sparkle's generate_appcast tool not found"
        log_info "Install it with: brew install sparkle"
        log_info "Recommended version: 2.8.x"
        exit 1
    fi
    
    # Check Sparkle version if possible
    local sparkle_version
    sparkle_version=$("$GEN_APPCAST" --version 2>/dev/null | head -1 || echo "unknown")
    log_info "Sparkle generate_appcast: $sparkle_version"
    
    # Check if we have signing keys for the environment
    local env_file=".env.${ENVIRONMENT}"
    if [ ! -f "$env_file" ]; then
        log_error "$env_file file not found"
        exit 1
    fi
    
    # Load environment variables
    set -a
    source "$env_file"
    set +a
    
    if [ -z "${SPARKLE_PRIVATE_KEY:-}" ]; then
        log_error "SPARKLE_PRIVATE_KEY not found in $env_file"
        exit 1
    fi
    
    log_success "Prerequisites check passed"
}

# Generate EdDSA signing key pair if not exists
generate_signing_keys() {
    local private_key_file="sparkle_${ENVIRONMENT}_private.pem"
    local public_key_file="sparkle_${ENVIRONMENT}_public.pem"
    
    if [ ! -f "$private_key_file" ]; then
        log_info "Generating EdDSA signing key pair for $ENVIRONMENT..."
        
        # Generate EdDSA key pair
        generate_keys -f "$private_key_file"
        
        log_success "Generated signing keys:"
        log_info "Private key: $private_key_file (keep this secret!)"
        log_info "Public key: $public_key_file (include in app)"
        
        # Show public key for configuration
        echo ""
        log_warning "Add this public key to your Tauri configuration:"
        cat "$public_key_file"
        echo ""
    else
        log_info "Using existing signing keys for $ENVIRONMENT"
    fi
}

# Generate appcast from build artifacts (renamed to avoid clashing with Sparkle's CLI)
generate_appcast_from_build() {
    log_info "Generating appcast for $ENVIRONMENT environment..."
    
    # Set up secure cleanup trap for temporary files
    local temp_key_file=""
    cleanup_temp_files() {
        if [ -n "${temp_key_file:-}" ] && [ -f "${temp_key_file:-}" ]; then
            shred -u "$temp_key_file" 2>/dev/null || rm -f "$temp_key_file"
        fi
    }
    trap cleanup_temp_files EXIT INT TERM
    
    # Determine build directory (latest)
    local latest_build=$(find . -maxdepth 1 -name "build_output_*" -type d | sort -r | head -n 1)
    if [ -z "$latest_build" ]; then
        log_error "No build output directory found. Run build script first."
        exit 1
    fi
    
    log_info "Using build directory: $latest_build"
    
    # Create releases directory structure
    local releases_dir="releases/${ENVIRONMENT}/darwin"
    mkdir -p "$releases_dir"
    
    # Copy only the expected final DMG, fallback to newest non-temp DMG
    local dmg_files=()
    if [ -f "$latest_build/clones-desktop-universal.dmg" ]; then
        dmg_files=("$latest_build/clones-desktop-universal.dmg")
    else
        dmg_files=($(find "$latest_build" -maxdepth 1 -type f -name "*.dmg" -not -name "rw.*" -print | sort -r | head -n 1))
    fi
    if [ ${#dmg_files[@]} -eq 0 ]; then
        log_error "No DMG files found in $latest_build"
        exit 1
    fi
    
    for dmg in "${dmg_files[@]}"; do
        local dmg_name=$(basename "$dmg")
        local version_dmg="${releases_dir}/${dmg_name}"
        
        cp "$dmg" "$version_dmg"
        log_info "Copied $dmg_name to releases directory"
    done
    
    # Get app version from Info.plist or config
    local app_version
    if [ -f "pubspec.yaml" ]; then
        app_version=$(grep "^version:" pubspec.yaml | cut -d' ' -f2 | cut -d'+' -f1)
    else
        app_version="0.1.0"
    fi
    
    log_info "App version: $app_version"
    
    # Generate appcast using Sparkle's tool
    local appcast_file="${releases_dir}/appcast.xml"
    local private_key_file="sparkle_${ENVIRONMENT}_private.pem"
    
    # Create temporary private key file from environment variable (secure)
    temp_key_file="/tmp/sparkle_private_$$_$(date +%s).pem"
    umask 077  # Ensure only owner can read/write
    echo "$SPARKLE_PRIVATE_KEY" > "$temp_key_file"
    chmod 600 "$temp_key_file"
    
    # Use Sparkle's generate_appcast tool (resolved absolute path)
    local download_url_prefix
    case "$ENVIRONMENT" in
        "prod")
            download_url_prefix="https://releases.clones-ai.com/latest/darwin/"
            ;;
        "test")
            download_url_prefix="https://releases-test.clones-ai.com/latest/darwin/"
            ;;
        *)
            download_url_prefix="https://releases-${ENVIRONMENT}.clones-ai.com/latest/darwin/"
            ;;
    esac
    
    # Clean existing appcast to ensure fresh generation
    rm -f "${releases_dir}/appcast.xml"
    
    "$GEN_APPCAST" --ed-key-file "$temp_key_file" --download-url-prefix "$download_url_prefix" "$releases_dir"
    
    # Clean up temporary key file securely
    shred -u "$temp_key_file" 2>/dev/null || rm -f "$temp_key_file"
    
    if [ -f "$appcast_file" ]; then
        log_success "Appcast generated: $appcast_file"
        
        # Show appcast preview
        echo ""
        log_info "Appcast preview:"
        head -20 "$appcast_file"
        echo ""
    else
        log_error "Failed to generate appcast"
        exit 1
    fi
}

# Upload to release server (informational - actual upload handled by upload_sparkle_macos.sh)
upload_appcast() {
    local releases_dir="releases/${ENVIRONMENT}/darwin"
    
    log_info "Appcast files ready for upload..."
    log_info "Target destination:"
    
    case "$ENVIRONMENT" in
        "prod")
            echo "  📡 URL: https://releases.clones-ai.com/latest/darwin/"
            ;;
        "test")
            echo "  📡 URL: https://releases-test.clones-ai.com/latest/darwin/"
            ;;
    esac
    
    echo ""
    log_info "Generated files:"
    find "$releases_dir" -type f | while read -r file; do
        echo "  📄 $(basename "$file")"
    done
    
    echo ""
    log_info "ℹ️  Upload will be handled automatically by upload_sparkle_macos.sh"
}

# Main execution
main() {
    echo "Sparkle Appcast Generator"
    echo "========================="
    
    if [ -z "${1:-}" ]; then
        log_error "Usage: $0 <environment>"
        echo "  Environment: prod, test"
        echo "  Example: $0 prod"
        echo "  Example: $0 test"
        exit 1
    fi
    
    check_prerequisites
    generate_signing_keys
    generate_appcast_from_build
    upload_appcast
    
    echo ""
    log_success "Appcast generation completed!"
    log_info "Your Sparkle appcast is ready for distribution"
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi