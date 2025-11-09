#!/bin/bash

set -euo pipefail

# Enable verbose debug output if requested
if [ "${VERBOSE:-false}" = true ]; then
    set -x
    echo "VERBOSE MODE ENABLED"
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Main execution
main() {
    echo "🚀 Clones Desktop - Complete Build & Deploy"
    echo "==========================================="
    
    if [ -z "${1:-}" ]; then
        log_error "Usage: $0 <environment> [--verbose]"
        echo "  Environment: prod, test"
        echo "  Options:"
        echo "    --verbose    Enable verbose debug output"
        echo "  Example: $0 prod"
        echo "  Example: $0 test --verbose"
        exit 1
    fi
    
    local environment="$1"
    
    # Check for verbose flag
    if [ "${2:-}" = "--verbose" ]; then
        export VERBOSE=true
        log_info "Verbose mode enabled for all scripts"
    fi
    
    log_info "Cleaning previous build artifacts..."
    if ls build_output_* 1> /dev/null 2>&1; then
        log_info "Removing existing build_output_* directories..."
        rm -rf build_output_*
        log_success "Previous builds cleaned"
    else
        log_info "No previous builds found"
    fi
    
    log_info "Step 1/3: Building release..."
    ENVIRONMENT="$environment" ./scripts/macos/build_release_local.sh
    
    if [ $? -ne 0 ]; then
        log_error "Build failed, aborting deployment"
        exit 1
    fi
    
    log_success "Build completed successfully!"
    
    # Post-build verification - ensure no mutation after signing
    log_info "Running post-build code signing verification..."
    latest_build_dir="$(ls -1d build_output_* 2>/dev/null | sort | tail -n1 || true)"
    if [ -z "$latest_build_dir" ]; then
        log_error "No build_output_* directory found after build"
        exit 1
    fi
    app_path="$latest_build_dir/universal/clones.app"
    dmg_path="$latest_build_dir/clones-desktop-universal.dmg"
    
    if [ ! -d "$app_path" ]; then
        log_error "App bundle not found: $app_path"
        exit 1
    fi
    if [ ! -f "$dmg_path" ]; then
        log_error "DMG not found: $dmg_path"
        exit 1
    fi
    
    # Require helper present and universal
    helper_path="$app_path/Contents/Helpers/screen_recorder"
    if [ ! -f "$helper_path" ]; then
        log_error "Missing helper in bundle: $helper_path"
        exit 1
    fi
    helper_archs="$(lipo -archs "$helper_path" 2>/dev/null || echo "")"
    if ! echo "$helper_archs" | grep -q "arm64" || ! echo "$helper_archs" | grep -q "x86_64"; then
        log_error "Helper is not universal (got: ${helper_archs:-unknown})"
        exit 1
    fi
    
    # Strict codesign verification (deep)
    if ! codesign --verify --deep --strict --verbose=2 "$app_path" 2>/dev/null; then
        log_error "Code signature verification failed for app bundle"
        # Show diagnostic
        codesign --verify --deep --strict --verbose=2 "$app_path" || true
        exit 1
    fi
    log_success "App bundle codesign verified"
    
    # Validate notarization on DMG (stapled earlier)
    if ! xcrun stapler validate "$dmg_path" >/dev/null 2>&1; then
        log_warning "DMG stapler validation did not pass; continuing (may be environment-related)"
        xcrun stapler validate "$dmg_path" || true
    else
        log_success "DMG stapler validation passed"
    fi
    
    log_info "Step 2/3: Generating Sparkle appcast..."
    # Set Sparkle generate_appcast path (same as build script)
    if [ -z "${GENERATE_APPCAST_BIN:-}" ]; then
        if [ -x "/opt/homebrew/Caskroom/sparkle/2.8.0/bin/generate_appcast" ]; then
            export GENERATE_APPCAST_BIN="/opt/homebrew/Caskroom/sparkle/2.8.0/bin/generate_appcast"
        fi
    fi
    ./scripts/macos/generate_appcast.sh "$environment"
    
    log_info "Step 3/3: Uploading to Tigris ($environment)..."
    ./scripts/macos/upload_sparkle_macos.sh "$environment"
    
    if [ $? -ne 0 ]; then
        log_error "Upload failed"
        exit 1
    fi
    
    log_success "🎉 Complete deployment finished!"
    log_info "Your Sparkle-enabled app is now available:"
    
    case "$environment" in
        "prod")
            echo "  📱 Downloads: https://releases.clones-ai.com/latest/darwin/"
            echo "  🔗 Appcast: https://releases.clones-ai.com/latest/darwin/appcast.xml"
            ;;
        "test")
            echo "  📱 Downloads: https://releases-test.clones-ai.com/latest/darwin/"
            echo "  🔗 Appcast: https://releases-test.clones-ai.com/latest/darwin/appcast.xml"
            ;;
    esac
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi