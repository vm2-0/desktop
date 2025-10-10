#!/bin/bash

set -euo pipefail

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
        log_error "Usage: $0 <environment>"
        echo "  Environment: prod, test"
        echo "  Example: $0 prod"
        echo "  Example: $0 test"
        exit 1
    fi
    
    local environment="$1"
    
    log_info "Step 1/2: Building release..."
    ENVIRONMENT="$environment" ./scripts/macos/build_release_local.sh
    
    if [ $? -ne 0 ]; then
        log_error "Build failed, aborting deployment"
        exit 1
    fi
    
    log_success "Build completed successfully!"
    
    log_info "Step 2/2: Uploading to Tigris ($environment)..."
    ./scripts/macos/upload_to_tigris_macos.sh "$environment"
    
    if [ $? -ne 0 ]; then
        log_error "Upload failed"
        exit 1
    fi
    
    log_success "🎉 Complete deployment finished!"
    log_info "Your app is now available for download at:"
    
    case "$environment" in
        "prod")
            echo "  🌐 https://releases.clones-ai.com/latest/darwin/"
            ;;
        "test")
            echo "  🌐 https://releases-test.clones-ai.com/latest/darwin/"
            ;;
    esac
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi