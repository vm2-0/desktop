#!/bin/bash

set -euo pipefail

# Global options
# Respect ENVIRONMENT if provided by parent scripts; default to dev otherwise
ENVIRONMENT="${ENVIRONMENT:-dev}"
DRY_RUN=false
VERBOSE=false

# Show help
show_help() {
    cat << 'EOF'
Usage: build_flutter_native.sh [ENVIRONMENT] [OPTIONS]

Build Flutter Native macOS App with Tauri agent integration.

ARGUMENTS:
    ENVIRONMENT     Build environment (default: dev)
                   - dev: Development build
                   - test: Test environment build  
                   - prod: Production build

OPTIONS:
    --dry-run      Show what would be done without executing
    -v, --verbose  Enable verbose logging
    -h, --help     Show this help message

REQUIRED ENVIRONMENT VARIABLES:
    SPARKLE_PUBLIC_KEY      Sparkle updater public key (base64)
    APPLE_SIGNING_IDENTITY  Code signing identity (e.g., "Developer ID Application: Name (ID)")

OPTIONAL ENVIRONMENT VARIABLES:
    RUST_LOG               Rust logging level (default: info)
    MACOSX_DEPLOYMENT_TARGET  macOS deployment target (default: current)

EXAMPLES:
    ./build_flutter_native.sh dev
    ./build_flutter_native.sh prod --verbose
    ./build_flutter_native.sh test --dry-run

ENVIRONMENT FILES:
    The script loads environment-specific variables from:
    - .env.dev     (development environment)
    - .env.test    (test environment)  
    - .env.prod    (production environment)

OUTPUT:
    Build artifacts are created in: build_output_YYYYMMDD_HHMMSS/
    - flutter_macos/clones.app    Flutter app bundle
    - tauri_agent_*/clones-desktop  Architecture-specific agents
    - universal/clones.app        Universal app bundle (signed)
    - clones-desktop-universal.dmg  Distribution DMG

For more information, see the project documentation.
EOF
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -*)
                echo "Error: Unknown option $1" >&2
                echo "Use --help for usage information" >&2
                exit 1
                ;;
            *)
                # First positional argument is environment
                if [[ "$1" =~ ^(dev|test|prod)$ ]]; then
                    ENVIRONMENT="$1"
                else
                    echo "Error: Invalid environment '$1'. Must be: dev, test, or prod" >&2
                    exit 1
                fi
                shift
                ;;
        esac
    done
}

# Parse arguments first
parse_args "$@"

echo "🚀 Building Flutter Native macOS App for environment: $ENVIRONMENT"
if [ "$DRY_RUN" = true ]; then
    echo "🔍 DRY RUN MODE - No actual changes will be made"
fi
if [ "$VERBOSE" = true ]; then
    echo "📝 Verbose logging enabled"
fi

ROOT_DIR=$(pwd)
PROJECT_DIR="$ROOT_DIR"
BUILD_DATE=$(date +"%Y%m%d_%H%M%S")
BUILD_DIR="${BUILD_DIR:-$ROOT_DIR/build_output_$BUILD_DATE}"

# Global variables for cleanup
VOL_DEVICE=""
TEMP_DMG=""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_verbose() {
    if [ "$VERBOSE" = true ]; then
        echo -e "${BLUE}🔍 $1${NC}"
    fi
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

# Dry run wrapper for commands
run_cmd() {
    local cmd="$1"
    shift
    local description="$*"
    
    if [ "$DRY_RUN" = true ]; then
        echo -e "${BLUE}🔍 DRY RUN: $description${NC}"
        echo -e "${BLUE}    Command: $cmd${NC}"
        return 0
    else
        log_verbose "Executing: $cmd"
        eval "$cmd"
    fi
}

# Cleanup function
cleanup() {
    log_warning "Exiting - running cleanup..."
    
    # Restore Info.plist backup if it exists
    restore_info_plist
    
    # Detach any mounted DMG volume if present
    if [ -n "${VOL_DEVICE:-}" ]; then
        log_info "Detaching mounted DMG volume: $VOL_DEVICE"
        hdiutil detach "$VOL_DEVICE" -force -quiet 2>/dev/null || true
        VOL_DEVICE=""
    fi
    
    # Clean up temporary DMG files
    if [ -n "${TEMP_DMG:-}" ] && [ -f "${TEMP_DMG}" ]; then
        log_info "Removing temporary DMG: $TEMP_DMG"
        rm -f "${TEMP_DMG}" 2>/dev/null || true
        TEMP_DMG=""
    fi
    
    # Kill any lingering processes that might hold file locks
    pkill -f "QuickLookUIService" 2>/dev/null || true
    pkill -f "Finder" 2>/dev/null || true
    
    log_info "Cleanup completed"
}

# Set up cleanup trap for script exit, interruption, or termination
trap cleanup EXIT INT TERM

# Check required tools availability
check_tools() {
    log_info "Checking required tools availability..."
    local tools=(flutter cargo rustup lipo codesign hdiutil awk diskutil)
    local special_tools=("/usr/libexec/PlistBuddy")
    local missing_tools=()
    
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            missing_tools+=("$tool")
        fi
    done
    
    # Check special tools with full paths
    for tool in "${special_tools[@]}"; do
        if [ ! -x "$tool" ]; then
            missing_tools+=("$tool")
        fi
    done
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        log_error "Required tools missing: ${missing_tools[*]}"
        log_error "Please install missing tools before running this script"
        exit 1
    fi
    
    log_success "All required tools are available"
}

# Load environment variables
load_environment() {
    local env_file="$ROOT_DIR/.env.$ENVIRONMENT"
    if [ -f "$env_file" ]; then
        log_info "Loading environment from: $env_file"
        set -a
        source "$env_file"
        set +a
    else
        log_error "Environment file not found: $env_file"
        exit 1
    fi
}

# Inject Sparkle public key into Info.plist
inject_sparkle_key() {
    local info_plist="$ROOT_DIR/macos/Runner/Info.plist"
    
    if [ -z "${SPARKLE_PUBLIC_KEY:-}" ]; then
        log_warning "SPARKLE_PUBLIC_KEY not set, skipping Sparkle configuration"
        return 0
    fi
    
    if [ ! -f "$info_plist" ]; then
        log_error "Info.plist not found at: $info_plist"
        return 1
    fi
    
    log_info "Injecting Sparkle public key for $ENVIRONMENT environment..."
    
    # Create backup with preserved permissions
    cp -p "$info_plist" "${info_plist}.backup"
    
    # Use PlistBuddy for safer plist manipulation
    # Try to set existing key first, then add if it doesn't exist
    if ! /usr/libexec/PlistBuddy -c "Set :SUPublicEDKey $SPARKLE_PUBLIC_KEY" "$info_plist" 2>/dev/null; then
        if ! /usr/libexec/PlistBuddy -c "Add :SUPublicEDKey string $SPARKLE_PUBLIC_KEY" "$info_plist" 2>/dev/null; then
            log_error "Failed to inject Sparkle public key into Info.plist"
            # Restore backup on failure
            if [ -f "${info_plist}.backup" ]; then
                mv "${info_plist}.backup" "$info_plist"
            fi
            return 1
        fi
    fi
    
    log_success "Sparkle public key injected: ${SPARKLE_PUBLIC_KEY:0:20}..."
}

# Restore original Info.plist
restore_info_plist() {
    local info_plist="$ROOT_DIR/macos/Runner/Info.plist"
    local backup="$info_plist.backup"
    
    if [ -f "$backup" ]; then
        mv "$backup" "$info_plist"
        log_info "Info.plist restored from backup"
    fi
}

# Build Flutter macOS app
build_flutter_macos() {
    log_info "Building Flutter macOS application..."
    
    # Inject Sparkle key before build
    inject_sparkle_key
    
    if [ "$DRY_RUN" = true ]; then
        log_info "DRY RUN: Would clean Flutter cache"
        log_info "DRY RUN: Would get Flutter dependencies"
        log_info "DRY RUN: Would build universal macOS binary"
        return 0
    fi
    
    log_verbose "Cleaning Flutter cache..."
    flutter clean
    
    log_verbose "Getting Flutter dependencies..."
    flutter pub get
    
    # Build universal binary (supports both ARM64 and Intel)
    log_info "Building universal macOS binary for environment: ${ENVIRONMENT:-dev}..."
    
    # Extract environment variables for secure build-time injection
    local dart_defines=""
    dart_defines+="--dart-define=ENVIRONMENT=${ENVIRONMENT:-dev}"
    
    # Set Sparkle feed URL based on environment
    local sparkle_feed_url=""
    case "${ENVIRONMENT:-dev}" in
        "prod")
            sparkle_feed_url="https://releases.clones-ai.com/latest/darwin/appcast.xml"
            ;;
        "test")
            sparkle_feed_url="https://releases-test.clones-ai.com/latest/darwin/appcast.xml"
            ;;
        *)
            sparkle_feed_url="https://releases-${ENVIRONMENT:-dev}.clones-ai.com/latest/darwin/appcast.xml"
            ;;
    esac
    
    # Read environment-specific variables if file exists
    local env_file=".env.${ENVIRONMENT:-dev}"
    if [ -f "$env_file" ]; then
        log_verbose "Extracting variables from $env_file for secure build..."
        # Extract only public configuration (no secrets)
        while IFS='=' read -r key value; do
            # Skip comments and empty lines
            [[ "$key" =~ ^#.*$ ]] && continue
            [[ -z "$key" ]] && continue
            
            # Only include non-sensitive environment variables
            case "$key" in
                ENV|API_BACKEND_URL|API_WEBSITE_URL|PRIVACY_POLICY_URL|BASESCAN_BASE_URL|SUBGRAPH_URL)
                    dart_defines+=" --dart-define=$key=$value"
                    ;;
            esac
        done < "$env_file"
    fi
    
    log_verbose "Building with: $dart_defines"
    export SPARKLE_FEED_URL="$sparkle_feed_url"
    flutter build macos --release $dart_defines
    
    # Copy the universal build
    local app="$ROOT_DIR/build/macos/Build/Products/Release/clones.app"
    if [ "$DRY_RUN" = true ]; then
        log_info "DRY RUN: Would copy app from $app to $BUILD_DIR/flutter_macos/"
    else
        if [ -d "$app" ]; then
            log_verbose "Creating Flutter build directory..."
            mkdir -p "$BUILD_DIR/flutter_macos"
            log_verbose "Copying Flutter app bundle..."
            ditto "$app" "$BUILD_DIR/flutter_macos/clones.app"
            log_success "Universal Flutter app copied to build directory"
        else
            log_error "Flutter build failed - app not found at: $app"
            restore_info_plist
            exit 1
        fi
    fi
    
    log_success "Flutter macOS build completed"
    
    # Restore Info.plist after build
    restore_info_plist
}

# Build Tauri agent for specific target
build_tauri_agent() {
    local target=$1
    local arch=$2
    
    log_info "Building Tauri agent for $arch ($target)..."
    
    cd "$ROOT_DIR/src-tauri"
    
    # Add target if not already added
    rustup target add $target 2>/dev/null || true
    
    # Build agent binary only (no bundle)
    local config_file="tauri.agent.conf.json"
    if [ -n "${ENVIRONMENT:-}" ]; then
        case "$ENVIRONMENT" in
            "test")
                config_file="tauri.conf.test.json"
                ;;
            "prod")
                config_file="tauri.conf.prod.json"
                ;;
            *)
                config_file="tauri.conf.json"
                ;;
        esac
        log_info "Using environment-specific agent config: $config_file"
    fi
    
    if [ "$DRY_RUN" = true ]; then
        log_info "DRY RUN: Would build Tauri agent with config $config_file for target $target"
        log_info "DRY RUN: Would copy agent binary to build directory"
        return 0
    fi
    
    # Build the agent binary
    log_verbose "Building Tauri agent binary..."
    TAURI_CONFIG_PATH="$config_file" cargo build --release --target $target
    
    # Copy agent binary to build directory
    local agent_binary="$ROOT_DIR/src-tauri/target/$target/release/clones_desktop"
    local agent_dir="$BUILD_DIR/tauri_agent_$arch"
    
    if [ -f "$agent_binary" ]; then
        log_verbose "Creating agent directory: $agent_dir"
        mkdir -p "$agent_dir"
        log_verbose "Copying agent binary..."
        cp "$agent_binary" "$agent_dir/clones-desktop"
        chmod +x "$agent_dir/clones-desktop"
        log_success "Tauri agent built for $arch: $agent_dir/clones-desktop"
    else
        log_error "Agent binary not found at: $agent_binary"
        return 1
    fi
    
    cd "$ROOT_DIR"
}

# Create universal binary
create_universal_app() {
    log_info "Creating universal macOS app bundle..."
    
    local flutter_app="$BUILD_DIR/flutter_macos/clones.app"
    local arm64_agent="$BUILD_DIR/tauri_agent_arm64/clones-desktop"
    local intel_agent="$BUILD_DIR/tauri_agent_intel/clones-desktop"
    local universal_app="$BUILD_DIR/universal/clones.app"
    
    if [ "$DRY_RUN" = true ]; then
        log_info "DRY RUN: Would create universal app from Flutter app and agent binaries"
        log_info "DRY RUN: Would use lipo to create universal agent binary"
        log_info "DRY RUN: Universal app would be created at: $universal_app"
        return 0
    fi
    
    if [ ! -d "$flutter_app" ]; then
        log_error "Flutter app not found at: $flutter_app"
        return 1
    fi
    
    # Copy Flutter app (already universal) as base
    mkdir -p "$BUILD_DIR/universal"
    ditto "$flutter_app" "$universal_app"
    
    # Create universal agent binary if both architectures exist
    local agent_dir="$universal_app/Contents/Resources/agent"
    mkdir -p "$agent_dir"
    
    if [ -f "$arm64_agent" ] && [ -f "$intel_agent" ]; then
        log_info "Creating universal agent binary from ARM64 and Intel builds..."
        lipo -create \
            "$arm64_agent" \
            "$intel_agent" \
            -output "$agent_dir/clones-desktop"
        chmod +x "$agent_dir/clones-desktop"
        log_success "Universal agent binary created"
    elif [ -f "$arm64_agent" ]; then
        log_warning "Only ARM64 agent found, copying single architecture"
        cp "$arm64_agent" "$agent_dir/clones-desktop"
        chmod +x "$agent_dir/clones-desktop"
    elif [ -f "$intel_agent" ]; then
        log_warning "Only Intel agent found, copying single architecture"
        cp "$intel_agent" "$agent_dir/clones-desktop"
        chmod +x "$agent_dir/clones-desktop"
    else
        log_error "No Tauri agent binaries found"
        return 1
    fi
    
    # Copy FFmpeg binaries if they exist (from build.rs)
    copy_ffmpeg_binaries_to_bundle "$universal_app"
    
    log_success "Universal app bundle created"
}

# Copy FFmpeg binaries from build artifacts to app bundle
copy_ffmpeg_binaries_to_bundle() {
    local app_path="$1"
    local ffmpeg_binaries_dir="$app_path/Contents/Resources/ffmpeg-binaries"
    
    # Look for FFmpeg binaries in architecture-specific target directories (created by build.rs)
    # Priority: aarch64 (ARM64) -> x86_64 (Intel) -> universal build
    local source_dirs=(
        "$PROJECT_DIR/src-tauri/target/aarch64-apple-darwin/release/ffmpeg-binaries"
        "$PROJECT_DIR/src-tauri/target/x86_64-apple-darwin/release/ffmpeg-binaries"
        "$PROJECT_DIR/src-tauri/target/release/ffmpeg-binaries"
    )
    
    local actual_source=""
    for dir in "${source_dirs[@]}"; do
        if [ -d "$dir" ] && [ -f "$dir/ffmpeg" ]; then
            actual_source="$dir"
            break
        fi
    done
    
    if [ -n "$actual_source" ]; then
        log_info "Found FFmpeg binaries at: $actual_source"
        log_info "Copying to app bundle..."
        
        # Create target directory
        mkdir -p "$ffmpeg_binaries_dir"
        
        # Copy binaries
        if [ -f "$actual_source/ffmpeg" ]; then
            cp "$actual_source/ffmpeg" "$ffmpeg_binaries_dir/"
            chmod +x "$ffmpeg_binaries_dir/ffmpeg"
            log_success "Copied FFmpeg binary to app bundle"
        fi
        
        if [ -f "$actual_source/ffprobe" ]; then
            cp "$actual_source/ffprobe" "$ffmpeg_binaries_dir/"
            chmod +x "$ffmpeg_binaries_dir/ffprobe"
            log_success "Copied FFprobe binary to app bundle"
        fi
        
        # List what we copied
        if [ "$(ls -A "$ffmpeg_binaries_dir" 2>/dev/null)" ]; then
            log_info "FFmpeg binaries included in app bundle:"
            ls -la "$ffmpeg_binaries_dir"
        fi
    else
        log_warning "No FFmpeg binaries found from build.rs - runtime download will be used"
        log_info "Searched in:"
        for dir in "${source_dirs[@]}"; do
            log_info "  - $dir"
        done
    fi
}

# Code sign the app bundle
code_sign_app() {
    local app_path="$1"
    
    log_info "Code signing app bundle..."
    
    if [ -z "${APPLE_SIGNING_IDENTITY:-}" ]; then
        log_warning "APPLE_SIGNING_IDENTITY not set, skipping code signing"
        return 0
    fi
    
    # Validate signing identity exists in keychain
    if ! security find-identity -v -p codesigning | grep -q "$APPLE_SIGNING_IDENTITY"; then
        log_error "Code signing identity not found in keychain: $APPLE_SIGNING_IDENTITY"
        log_info "Available identities:"
        security find-identity -v -p codesigning
        return 1
    fi
    
    log_info "Using code signing identity: ${APPLE_SIGNING_IDENTITY:0:50}..."
    
    if [ "$DRY_RUN" = true ]; then
        log_info "DRY RUN: Would code sign app bundle with identity: $APPLE_SIGNING_IDENTITY"
        log_info "DRY RUN: Would sign Sparkle components, agent binary, frameworks, and main app"
        log_info "DRY RUN: Would verify signature with codesign --verify --deep --strict"
        return 0
    fi
    
    # Determine entitlements file
    local entitlements="$ROOT_DIR/macos/Runner/Release.entitlements"
    if [ ! -f "$entitlements" ]; then
        log_error "Entitlements file not found: $entitlements"
        log_error "Required for --options runtime signing"
        return 1
    fi
    
    # Sign nested content in Sparkle first (deepest first)
    if [ -d "$app_path/Contents/Frameworks/Sparkle.framework" ]; then
        log_info "Signing Sparkle nested components..."
        
        local sparkle_autoupdate="$app_path/Contents/Frameworks/Sparkle.framework/Versions/B/Autoupdate"
        if [ -f "$sparkle_autoupdate" ]; then
            codesign --force --timestamp --options runtime --entitlements "$entitlements" --sign "$APPLE_SIGNING_IDENTITY" "$sparkle_autoupdate" || {
                log_error "Failed to sign Sparkle Autoupdate"
                return 1
            }
        fi
        
        local sparkle_updater="$app_path/Contents/Frameworks/Sparkle.framework/Versions/B/Updater.app"
        if [ -d "$sparkle_updater" ]; then
            # Sign the main executable first
            local updater_executable="$sparkle_updater/Contents/MacOS/Updater"
            if [ -f "$updater_executable" ]; then
                codesign --force --timestamp --options runtime --entitlements "$entitlements" --sign "$APPLE_SIGNING_IDENTITY" "$updater_executable" || {
                    log_error "Failed to sign Sparkle Updater executable"
                    return 1
                }
            fi
            # Then sign the app bundle
            codesign --force --timestamp --options runtime --entitlements "$entitlements" --sign "$APPLE_SIGNING_IDENTITY" "$sparkle_updater" || {
                log_error "Failed to sign Sparkle Updater.app"
                return 1
            }
        fi
        
        # Sign Sparkle XPC services (Sparkle 2.8+ specific entitlements needed)
        local sparkle_xpc_dir="$app_path/Contents/Frameworks/Sparkle.framework/Versions/B/XPCServices"
        if [ -d "$sparkle_xpc_dir" ]; then
            find "$sparkle_xpc_dir" -name "*.xpc" | while read -r xpc_service; do
                if [ -d "$xpc_service" ]; then
                    log_verbose "Signing Sparkle XPC service: $(basename "$xpc_service")"
                    
                    # XPC services need different entitlements - use main app entitlements
                    # Sign the main executable first with proper entitlements
                    local xpc_name=$(basename "$xpc_service" .xpc)
                    local xpc_executable="$xpc_service/Contents/MacOS/$xpc_name"
                    if [ -f "$xpc_executable" ]; then
                        codesign --force --timestamp --options runtime --entitlements "$entitlements" --sign "$APPLE_SIGNING_IDENTITY" "$xpc_executable" || {
                            log_error "Failed to sign XPC service executable: $xpc_executable"
                            return 1
                        }
                    fi
                    
                    # Then sign the XPC service bundle (without deep to avoid breaking Sparkle)
                    codesign --force --timestamp --options runtime --sign "$APPLE_SIGNING_IDENTITY" "$xpc_service" || {
                        log_error "Failed to sign Sparkle XPC service: $xpc_service"
                        return 1
                    }
                fi
            done
        fi
    fi
    
    # Sign the agent binary first (deepest executable)
    local agent_binary="$app_path/Contents/Resources/agent/clones-desktop"
    if [ -f "$agent_binary" ]; then
        log_info "Signing Tauri agent binary..."
        codesign --force --timestamp --options runtime --entitlements "$entitlements" --sign "$APPLE_SIGNING_IDENTITY" "$agent_binary" || {
            log_error "Failed to sign Tauri agent binary"
            return 1
        }
    fi
    
    # Sign FFmpeg binaries (embedded executables)
    local ffmpeg_binaries_dir="$app_path/Contents/Resources/ffmpeg-binaries"
    if [ -d "$ffmpeg_binaries_dir" ]; then
        log_info "Signing FFmpeg binaries..."
        
        if [ -f "$ffmpeg_binaries_dir/ffmpeg" ]; then
            log_verbose "Signing FFmpeg binary..."
            codesign --force --timestamp --options runtime --entitlements "$entitlements" --sign "$APPLE_SIGNING_IDENTITY" "$ffmpeg_binaries_dir/ffmpeg" || {
                log_error "Failed to sign FFmpeg binary"
                return 1
            }
            log_success "FFmpeg binary signed"
        fi
        
        if [ -f "$ffmpeg_binaries_dir/ffprobe" ]; then
            log_verbose "Signing FFprobe binary..."
            codesign --force --timestamp --options runtime --entitlements "$entitlements" --sign "$APPLE_SIGNING_IDENTITY" "$ffmpeg_binaries_dir/ffprobe" || {
                log_error "Failed to sign FFprobe binary"
                return 1
            }
            log_success "FFprobe binary signed"
        fi
    fi
    
    # Sign all frameworks (skip core Flutter frameworks to avoid VM snapshot issues)
    log_info "Signing frameworks..."
    
    # Enable nullglob to handle cases where no .framework directories exist
    shopt -s nullglob
    for framework in "$app_path/Contents/Frameworks"/*.framework; do
        if [ -d "$framework" ]; then
            base_name=$(basename "$framework")
            # Note: We now sign Flutter core frameworks for notarization compliance
            log_info "Signing framework: $base_name"
            
            # Find and sign actual Mach-O files, skip symlinks; prefer Versions/Current/<name>
            while IFS= read -r -d '' executable; do
                if [ -L "$executable" ]; then
                    log_verbose "Skipping symlink: $executable"
                    continue
                fi
                # Only sign Mach-O files
                if file "$executable" | grep -q "Mach-O"; then
                    log_verbose "Signing Mach-O executable: $(basename "$executable")"
                    codesign --force --timestamp --options runtime --entitlements "$entitlements" --sign "$APPLE_SIGNING_IDENTITY" "$executable" || {
                        log_error "Failed to sign executable: $executable"
                        shopt -u nullglob
                        return 1
                    }
                else
                    log_verbose "Non-Mach-O, skipping: $executable"
                fi
            done < <(find "$framework" -type f -print0)
            
            # Sign the framework - target main binary first if Versions/Current exists
            framework_name=$(basename "$framework" .framework)
            if [ -L "$framework/Versions/Current" ] && [ -f "$framework/Versions/Current/$framework_name" ]; then
                log_verbose "Signing framework root binary: $framework/Versions/Current/$framework_name"
                codesign --force --timestamp --options runtime --entitlements "$entitlements" --sign "$APPLE_SIGNING_IDENTITY" "$framework/Versions/Current/$framework_name" || {
                    log_error "Failed to sign framework root binary"
                    shopt -u nullglob
                    return 1
                }
            fi
            
            # Then sign the framework container
            codesign --force --timestamp --sign "$APPLE_SIGNING_IDENTITY" "$framework" || {
                log_error "Failed to sign framework container: $framework"
                shopt -u nullglob
                return 1
            }
        fi
    done
    # Restore default glob behavior
    shopt -u nullglob
    
    # Sign the main app bundle with hardened runtime
    log_info "Signing main app bundle with hardened runtime..."
    codesign --force --timestamp --options runtime --entitlements "$entitlements" --sign "$APPLE_SIGNING_IDENTITY" "$app_path" || {
        log_error "Failed to sign main app bundle"
        return 1
    }
    
    # Verify the signature
    log_info "Verifying code signature..."
    codesign --verify --deep --strict --verbose=2 "$app_path" || {
        log_error "Code signature verification failed"
        return 1
    }
    
    # Additional signature verification for debugging
    log_info "Displaying signature details..."
    codesign --display --requirements --verbose=2 "$app_path" || {
        log_warning "Failed to display signature requirements"
    }
    
    # Test Gatekeeper assessment for the app bundle
    log_info "Testing Gatekeeper assessment for app bundle..."
    if spctl --assess --type execute --verbose "$app_path" 2>&1; then
        log_success "App bundle passes Gatekeeper assessment"
    else
        # Capture output for analysis even if assessment fails
        local spctl_output
        spctl_output=$(spctl --assess --type execute --verbose "$app_path" 2>&1 || true)
        log_warning "App bundle Gatekeeper assessment details:"
        echo "$spctl_output"
        
        # Check for common patterns that indicate signing is correct
        if echo "$spctl_output" | grep -q "source=Developer ID"; then
            log_info "App is signed with Developer ID - should pass Gatekeeper after notarization"
        fi
    fi
    
    log_success "App bundle signed and verified successfully"
}


# Create DMG
create_dmg() {
    local app_path="$1"
    local dmg_name="$2"
    
    log_info "Creating DMG: $dmg_name"
    
    if [ "$DRY_RUN" = true ]; then
        local final_dmg="$BUILD_DIR/${dmg_name%.dmg}.dmg"
        log_info "DRY RUN: Would create temporary DMG with mktemp"
        log_info "DRY RUN: Would mount DMG and copy app bundle"
        log_info "DRY RUN: Would create Applications symlink"
        log_info "DRY RUN: Would convert to final compressed DMG: $final_dmg"
        return 0
    fi
    
    # Use mktemp for safe temporary file creation
    local temp_base
    temp_base=$(mktemp "$BUILD_DIR/tmpdmg.XXXXXX") || {
        log_error "Failed to create temporary file"
        return 1
    }
    local temp_dmg="${temp_base}.dmg"
    mv "$temp_base" "$temp_dmg" || {
        log_error "Failed to rename temporary file to .dmg"
        rm -f "$temp_base"
        return 1
    }
    
    # Set global variable for cleanup
    TEMP_DMG="$temp_dmg"
    
    # Use unique volume name per build to avoid conflicts
    local vol_name="Clones Desktop $BUILD_DATE"
    
    # Create temporary DMG with explicit output path
    log_info "Creating temporary DMG: $(basename "$temp_dmg")"
    hdiutil create -size 500m -fs HFS+ -volname "$vol_name" -ov "$temp_dmg" || {
        log_error "Failed to create temporary DMG"
        return 1
    }
    
    # Mount the DMG
    local mount_point="/Volumes/$vol_name"
    
    # Ensure previous mount is not present
    if mount | grep -q "$mount_point"; then
        log_warning "Previous DMG mount detected. Attempting to detach..."
        hdiutil detach "$mount_point" -force || true
        sleep 2
    fi
    
    # Attach DMG and capture device properly
    log_info "Mounting temporary DMG..."
    local attach_output
    attach_output=$(hdiutil attach -noverify -nobrowse -mountpoint "$mount_point" "$temp_dmg") || {
        log_error "Failed to mount temporary DMG"
        return 1
    }
    
    # Extract device node for reliable detach
    local device
    device=$(echo "$attach_output" | awk '/^\/dev\//{print $1;exit}')
    if [ -z "$device" ]; then
        log_error "Failed to determine device node from hdiutil attach output"
        return 1
    fi
    
    # Set global variable for cleanup
    VOL_DEVICE="$device"
    
    log_info "Copying app bundle to DMG..."
    ditto "$app_path" "$mount_point/$(basename "$app_path")" || {
        log_error "Failed to copy app to DMG"
        return 1
    }
    
    # Create Applications symlink
    ln -s /Applications "$mount_point/Applications" || {
        log_error "Failed to create Applications symlink"
        return 1
    }
    
    # Sync filesystem and ensure all writes complete
    sync
    sleep 2
    
    # Detach the volume
    log_info "Detaching DMG volume..."
    local detach_attempts=0
    local max_attempts=5
    local detached=false
    
    while [ $detach_attempts -lt $max_attempts ]; do
        if hdiutil detach "$device" -quiet 2>/dev/null; then
            detached=true
            break
        fi
        
        detach_attempts=$((detach_attempts + 1))
        log_warning "DMG volume busy, retrying detach ($detach_attempts/$max_attempts)..."
        
        # Kill processes that might hold the volume
        pkill -f "QuickLookUIService" 2>/dev/null || true
        pkill -f "Finder" 2>/dev/null || true
        
        # Force unmount as fallback
        diskutil unmount force "$mount_point" >/dev/null 2>&1 || true
        sleep 2
    done
    
    if [ "$detached" = false ]; then
        log_error "Failed to detach DMG volume after $max_attempts attempts"
        log_warning "Proceeding with conversion anyway..."
    fi
    
    # Convert to final compressed DMG with proper name handling
    local final_dmg="$BUILD_DIR/${dmg_name%.dmg}.dmg"
    log_info "Converting to final DMG: $(basename "$final_dmg")"
    
    hdiutil convert "$temp_dmg" -format UDZO -o "$final_dmg" || {
        log_error "Failed to convert DMG to final format"
        return 1
    }
    
    # Clean up temporary file
    rm -f "$temp_dmg"
    
    # Clear global variables after successful cleanup
    VOL_DEVICE=""
    TEMP_DMG=""
    
    log_success "DMG created: $final_dmg"
}

# Main build process
main() {
    # Check required tools first
    check_tools
    
    # Load environment
    load_environment
    
    log_info "Starting Flutter Native + Tauri Agent build process..."
    
    if [ "$DRY_RUN" = true ]; then
        log_info "DRY RUN: Would create build directory: $BUILD_DIR"
    else
        log_verbose "Creating build directory: $BUILD_DIR"
        mkdir -p "$BUILD_DIR"
    fi
    
    # Build Flutter apps for both architectures
    build_flutter_macos
    
    # Build Tauri agent for both architectures in parallel
    log_info "Building Tauri agents for both architectures in parallel..."
    build_tauri_agent "aarch64-apple-darwin" "arm64" &
    local arm64_pid=$!
    build_tauri_agent "x86_64-apple-darwin" "intel" &
    local intel_pid=$!
    
    log_info "Waiting for parallel Tauri builds to complete..."
    local arm64_result=0
    local intel_result=0
    
    if ! wait $arm64_pid; then
        arm64_result=1
        log_error "ARM64 Tauri build failed"
    fi
    
    if ! wait $intel_pid; then
        intel_result=1
        log_error "Intel Tauri build failed"
    fi
    
    if [ $arm64_result -ne 0 ] || [ $intel_result -ne 0 ]; then
        log_error "One or more Tauri builds failed"
        exit 1
    fi
    
    log_success "Parallel Tauri builds completed successfully"
    
    # Create universal app
    create_universal_app
    
    # Code sign universal app
    local universal_app="$BUILD_DIR/universal/clones.app"
    code_sign_app "$universal_app"
    
    # Create DMG (notarization + stapling happens later in deploy process)
    create_dmg "$universal_app" "clones-desktop-universal.dmg"
    
    log_success "Build completed!"
    log_info "Build artifacts located in: $BUILD_DIR"
    
    echo ""
    log_info "Built artifacts:"
    find "$BUILD_DIR" -name "*.app" -o -name "*.dmg" | while read -r file; do
        echo "  📦 $(basename "$file")"
    done
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi