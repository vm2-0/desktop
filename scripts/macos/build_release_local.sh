#!/bin/bash

set -euo pipefail

echo "🚀 Building Clones Desktop for macOS Release (Local)"

ROOT_DIR=$(pwd)
BUILD_DATE=$(date +"%Y%m%d_%H%M%S")
BUILD_DIR="$ROOT_DIR/build_output_$BUILD_DATE"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Read required Flutter version from .tool-versions
    if [ ! -f ".tool-versions" ]; then
        log_error ".tool-versions file not found"
        exit 1
    fi
    
    REQUIRED_FLUTTER_VERSION=$(grep "^flutter " .tool-versions | cut -d' ' -f2)
    if [ -z "$REQUIRED_FLUTTER_VERSION" ]; then
        log_error "Flutter version not found in .tool-versions"
        exit 1
    fi
    
    if ! command -v flutter &> /dev/null; then
        log_error "Flutter not found. Please install Flutter $REQUIRED_FLUTTER_VERSION"
        exit 1
    fi
    
    if ! command -v cargo &> /dev/null; then
        log_error "Cargo not found. Please install Rust"
        exit 1
    fi
    
    if ! command -v security &> /dev/null; then
        log_error "macOS security command not found"
        exit 1
    fi
    
    # Check Flutter version
    FLUTTER_VERSION=$(flutter --version | head -n 1 | cut -d' ' -f2)
    log_info "Flutter version: $FLUTTER_VERSION (required: $REQUIRED_FLUTTER_VERSION)"
    
    # Check environment files based on ENVIRONMENT variable
    if [ -n "${ENVIRONMENT:-}" ]; then
        local env_file=".env.${ENVIRONMENT}"
        if [ ! -f "$env_file" ]; then
            log_error "$env_file file not found. Please create it with your environment variables."
            exit 1
        fi
        log_info "Will use environment file: $env_file"
    else
        # Fallback to generic .env for dev/local usage
        if [ ! -f ".env" ]; then
            log_error ".env file not found. Please create it with your environment variables."
            exit 1
        fi
        log_info "Will use generic .env file"
    fi
    
    log_success "Prerequisites check passed"
}

# Load environment variables from environment-specific .env files
load_env() {
    local environment="$1"
    local env_file=".env.${environment}"
    
    # Try environment-specific file first
    if [ -f "$env_file" ]; then
        log_info "Loading environment variables from $env_file..."
        set -a  # automatically export all variables
        source "$env_file"
        set +a  # stop auto-export
        log_success "Environment variables loaded from $env_file"
    # Fallback to generic .env for backward compatibility
    elif [ -f ".env" ]; then
        log_info "Loading environment variables from .env..."
        set -a  # automatically export all variables
        source .env
        set +a  # stop auto-export
        log_warning "Using generic .env file. Consider using .env.$environment for better security"
    else
        log_warning "No .env files found, using system environment variables"
    fi
}

# Setup environment
setup_environment() {
    log_info "Setting up environment..."
    
    # Load environment variables based on ENVIRONMENT variable
    if [ -n "${ENVIRONMENT:-}" ]; then
        load_env "$ENVIRONMENT"
    else
        # Fallback for dev/local usage
        if [ -f ".env" ]; then
            log_info "Loading environment variables from .env..."
            set -a  # automatically export all variables
            source .env
            set +a  # stop auto-export
            log_info "Loaded environment variables from .env"
        fi
    fi
    
    # Create build directory
    mkdir -p "$BUILD_DIR"
    log_info "Created build directory: $BUILD_DIR"
}

# Install dependencies
install_dependencies() {
    log_info "Installing Flutter dependencies..."
    flutter pub get
    
    log_info "Installing Tauri CLI (if not already installed)..."
    if ! command -v cargo-tauri &> /dev/null; then
        cargo install tauri-cli --version "^2.0"
        log_success "Tauri CLI installed"
    else
        log_info "Tauri CLI already installed"
    fi
}

# Build Flutter Web
build_flutter() {
    log_info "Building Flutter Web..."
    flutter build web --base-href="/"
    log_success "Flutter Web build completed"
}

# Build for specific target
build_tauri_target() {
    local target=$1
    local arch=$2
    
    log_info "Building Tauri app for $arch ($target)..."
    
    cd "$ROOT_DIR/src-tauri"
    
    # Add target if not already added
    rustup target add $target 2>/dev/null || true
    
    # Build without notarization (signing only)
    # Use environment-specific config if provided, otherwise use base config
    local config_file="tauri.conf.json"
    if [ -n "${ENVIRONMENT:-}" ]; then
        local env_config="tauri.${ENVIRONMENT}.conf.json"
        if [ -f "$env_config" ]; then
            config_file="$env_config"
            log_info "Using environment-specific config: $config_file"
        else
            log_warning "Environment config $env_config not found, using base config"
        fi
    fi
    
    # Ensure Tauri signing variables are exported for the build process
    if [ -n "${TAURI_SIGNING_PRIVATE_KEY:-}" ]; then
        export TAURI_SIGNING_PRIVATE_KEY
        log_info "TAURI_SIGNING_PRIVATE_KEY exported for build"
    fi
    if [ -n "${TAURI_SIGNING_PRIVATE_KEY_PASSWORD:-}" ]; then
        export TAURI_SIGNING_PRIVATE_KEY_PASSWORD
        log_info "TAURI_SIGNING_PRIVATE_KEY_PASSWORD exported for build"
    else
        log_warning "TAURI_SIGNING_PRIVATE_KEY_PASSWORD not found - signing may require manual password input"
    fi
    
    cargo tauri build --target $target --config "$config_file"
    
    local target_dir="$ROOT_DIR/src-tauri/target/$target/release/bundle"
    
    if [ -d "$target_dir/macos" ]; then
        mkdir -p "$BUILD_DIR/macos_$arch"
        # Copy only .app bundles, exclude temporary DMG files with rw.* prefix
        find "$target_dir/macos" -name "*.app" -exec cp -r {} "$BUILD_DIR/macos_$arch/" \;
        log_success "macOS app copied to build directory: macos_$arch"
    fi
    
    if [ -d "$target_dir/dmg" ]; then
        cp -r "$target_dir/dmg" "$BUILD_DIR/dmg_$arch"
        log_success "DMG copied to build directory: dmg_$arch"
    fi
    
    # Copy Tauri updater files (.app.tar.gz and .sig)
    local updater_files_dir="$BUILD_DIR/updater_$arch"
    mkdir -p "$updater_files_dir"
    
    # Copy .app.tar.gz file
    local app_targz="$target_dir/macos/clones-desktop.app.tar.gz"
    if [ -f "$app_targz" ]; then
        cp "$app_targz" "$updater_files_dir/"
        log_success "Updater .app.tar.gz copied to build directory: updater_$arch"
    fi
    
    # Copy .sig file
    local sig_file="$target_dir/macos/clones-desktop.app.tar.gz.sig"
    if [ -f "$sig_file" ]; then
        cp "$sig_file" "$updater_files_dir/"
        log_success "Updater .sig copied to build directory: updater_$arch"
    fi
    
    cd "$ROOT_DIR"
}

# Main build function
main_build() {
    log_info "Starting main build process..."
    
    # Build for both architectures
    log_info "Building for Apple Silicon (ARM64)..."
    build_tauri_target "aarch64-apple-darwin" "arm64"
    
    log_info "Building for Intel (x86_64)..."
    build_tauri_target "x86_64-apple-darwin" "intel"
    
    log_success "Build completed!"
    log_info "Build artifacts located in: $BUILD_DIR"
    
    # List built artifacts
    echo ""
    log_info "Built artifacts:"
    find "$BUILD_DIR" -name "*.app" -o -name "*.dmg" | while read -r file; do
        echo "  📦 $(basename "$file")"
    done
}

# Automated notarization
notarize_artifacts() {
    echo ""
    log_info "🔐 Starting automated notarization..."
    
    # Check if keychain profile is configured
    local KEYCHAIN_PROFILE="${NOTARIZATION_KEYCHAIN_PROFILE:-clones-notary}"
    
    # Test if keychain profile exists
    if ! xcrun notarytool history --keychain-profile "$KEYCHAIN_PROFILE" >/dev/null 2>&1; then
        log_warning "Keychain profile '$KEYCHAIN_PROFILE' not found."
        log_info "Please configure it first:"
        echo "   xcrun notarytool store-credentials \"$KEYCHAIN_PROFILE\" --apple-id \"your@email.com\" --team-id \"TEAMID\" --password \"app-specific-password\""
        echo ""
        log_info "Skipping notarization. Build artifacts are available for manual notarization."
        return 0
    fi
    
    # Notarize DMG files (preferred format) - exclude temporary files with rw.* prefix
    local dmg_files=($(find "$BUILD_DIR" -name "*.dmg" -not -name "rw.*"))
    
    if [ ${#dmg_files[@]} -eq 0 ]; then
        log_warning "No DMG files found for notarization"
        return 0
    fi
    
    for dmg in "${dmg_files[@]}"; do
        log_info "Notarizing $(basename "$dmg")..."
        
        # Submit for notarization and capture the submission ID
        local submission_output
        submission_output=$(xcrun notarytool submit "$dmg" --keychain-profile "$KEYCHAIN_PROFILE" --wait 2>&1)
        local submit_exit_code=$?
        
        if [ $submit_exit_code -eq 0 ]; then
            # Extract submission ID and check the actual status
            local submission_id
            submission_id=$(echo "$submission_output" | grep "id:" | head -1 | awk '{print $2}')
            
            if [ -n "$submission_id" ]; then
                # Get the actual status
                local status_info
                status_info=$(xcrun notarytool info "$submission_id" --keychain-profile "$KEYCHAIN_PROFILE" 2>/dev/null)
                local actual_status
                actual_status=$(echo "$status_info" | grep "status:" | awk '{print $2}')
                
                if [ "$actual_status" = "Accepted" ]; then
                    log_success "Notarization successful for $(basename "$dmg")"
                    
                    # Staple the notarization ticket
                    log_info "Stapling notarization ticket..."
                    if xcrun stapler staple "$dmg"; then
                        log_success "Stapling successful for $(basename "$dmg")"
                    else
                        log_warning "Stapling failed for $(basename "$dmg")"
                    fi
                else
                    log_error "Notarization failed with status: $actual_status"
                    log_info "Fetching detailed error logs..."
                    xcrun notarytool log "$submission_id" --keychain-profile "$KEYCHAIN_PROFILE"
                fi
            else
                log_error "Could not extract submission ID from notarization output"
            fi
        else
            log_error "Notarization submission failed for $(basename "$dmg")"
            echo "$submission_output"
        fi
        echo ""
    done
}

# Cleanup function
cleanup() {
    log_info "Cleaning up temporary files..."
    
    # Remove temporary DMG files with rw.* prefix from build directories
    if [ -n "$BUILD_DIR" ] && [ -d "$BUILD_DIR" ]; then
        find "$BUILD_DIR" -name "rw.*.dmg" -delete 2>/dev/null || true
    fi
    
    # Clean up Tauri build cache temporary files
    find "$ROOT_DIR/src-tauri/target" -name "rw.*.dmg" -delete 2>/dev/null || true
    
    log_info "Temporary files cleaned up"
}

# Error handling
handle_error() {
    log_error "Build failed! Check the output above for errors."
    cleanup
    exit 1
}

trap handle_error ERR

# Main execution
main() {
    echo "📱 Clones Desktop - Local macOS Build Script"
    echo "=============================================="
    
    check_prerequisites
    setup_environment
    install_dependencies
    build_flutter
    main_build
    notarize_artifacts
    cleanup
    
    echo ""
    log_success "🎉 Build and notarization process completed successfully!"
    log_info "Your notarized apps are ready for distribution"
}

# Run main function
main "$@"