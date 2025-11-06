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
    
    log_info "Step 1/2: Building release..."
    ENVIRONMENT="$environment" ./scripts/macos/build_release_local.sh
    
    if [ $? -ne 0 ]; then
        log_error "Build failed, aborting deployment"
        exit 1
    fi
    
    log_success "Build completed successfully!"
    
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