#!/bin/bash

set -euo pipefail

# Environment configuration
set_environment_config() {
    local env="$1"
    
    case "$env" in
        "prod")
            export TIGRIS_BUCKET="clones-desktop-release-prod"
            export BUCKET_URL="https://releases.clones-ai.com"
            ;;
        "test")
            export TIGRIS_BUCKET="clones-desktop-release-test"
            export BUCKET_URL="https://releases-test.clones-ai.com"
            ;;
        *)
            log_error "Invalid environment: $env"
            echo "  Valid environments: prod, test"
            exit 1
            ;;
    esac
    
    export TIGRIS_ENDPOINT="https://fly.storage.tigris.dev"
    log_info "Environment set to: $env (bucket: $TIGRIS_BUCKET)"
}

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

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    if ! command -v aws &> /dev/null; then
        log_error "AWS CLI not found. Please install AWS CLI"
        echo "  brew install awscli"
        exit 1
    fi
    
    if [ -z "${TIGRIS_ACCESS_KEY_ID:-}" ]; then
        log_error "TIGRIS_ACCESS_KEY_ID not found"
        echo "  Either:"
        echo "    1. Add TIGRIS_ACCESS_KEY_ID=your_key to .env"
        echo "    2. Or export TIGRIS_ACCESS_KEY_ID='your_access_key'"
        exit 1
    fi
    
    if [ -z "${TIGRIS_SECRET_ACCESS_KEY:-}" ]; then
        log_error "TIGRIS_SECRET_ACCESS_KEY not found"
        echo "  Either:"
        echo "    1. Add TIGRIS_SECRET_ACCESS_KEY=your_secret to .env" 
        echo "    2. Or export TIGRIS_SECRET_ACCESS_KEY='your_secret_key'"
        exit 1
    fi
    
    log_success "Prerequisites check passed"
}

# Find latest build directory
find_latest_build() {
    local build_dir=$(find . -maxdepth 1 -name "build_output_*" -type d | sort -r | head -n1)
    
    if [ -z "$build_dir" ]; then
        log_error "No build output directory found. Please run build_release_local.sh first"
        exit 1
    fi
    
    echo "$build_dir"
}

# Extract version from Tauri config
get_app_version() {
    if [ ! -f "src-tauri/tauri.conf.json" ]; then
        log_error "src-tauri/tauri.conf.json not found"
        exit 1
    fi
    
    local version=$(grep -o '"version"[[:space:]]*:[[:space:]]*"[^"]*"' src-tauri/tauri.conf.json | head -1 | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
    
    if [ -z "$version" ]; then
        log_error "Could not extract version from src-tauri/tauri.conf.json"
        exit 1
    fi
    
    echo "$version"
}

# Upload file to Tigris with metadata
upload_file() {
    local file_path="$1"
    local s3_key="$2"
    local version="$3"
    local arch="$4"
    local file_type="$5"
    
    log_info "Uploading $(basename "$file_path") to $s3_key..."
    
    # Configure AWS CLI for Tigris
    export AWS_ACCESS_KEY_ID="$TIGRIS_ACCESS_KEY_ID"
    export AWS_SECRET_ACCESS_KEY="$TIGRIS_SECRET_ACCESS_KEY"
    export AWS_ENDPOINT_URL="$TIGRIS_ENDPOINT"
    export AWS_REGION="auto"
    
    # Upload file with metadata, overwriting existing files
    aws s3 cp "$file_path" "s3://$TIGRIS_BUCKET/$s3_key" \
        --metadata "version=$version" \
        --metadata "arch=$arch" \
        --metadata "type=$file_type" \
        --metadata "uploaded=$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
        --content-type "application/octet-stream" \
        --no-progress \
        --force
    
    if [ $? -eq 0 ]; then
        log_success "Uploaded: $BUCKET_URL/$s3_key"
    else
        log_error "Failed to upload $file_path"
        return 1
    fi
}

# Sign file for Tauri updater
sign_file() {
    local file_path="$1"
    
    if [ -z "${TAURI_SIGNING_PRIVATE_KEY:-}" ]; then
        log_error "TAURI_SIGNING_PRIVATE_KEY not found"
        return 1
    fi
    
    # Use tauri CLI to sign the file
    if command -v tauri &> /dev/null; then
        tauri signer sign "$file_path" -k "$TAURI_SIGNING_PRIVATE_KEY" --silent 2>/dev/null
    else
        log_warning "Tauri CLI not found, skipping signature"
        return 1
    fi
}

# Create Tauri updater manifest (different from our custom manifest)
create_tauri_manifest() {
    local version="$1"
    local build_dir="$2"
    
    local manifest_file=$(mktemp)
    local upload_date=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    
    # Find .tar.gz files (Tauri updater format)
    local arm64_url=""
    local intel_url=""
    local arm64_signature=""
    local intel_signature=""
    
    # Look for .tar.gz files and generate signatures
    while IFS= read -r -d '' targz_file; do
        local filename=$(basename "$targz_file")
        local arch=""
        # Add architecture to filename to match upload
        local arch_name=""
        
        if [[ "$targz_file" == *"updater_arm64"* ]]; then
            arch="aarch64"
            arch_name="arm64"
            local arch_filename="${filename%.app.tar.gz}_${arch_name}.app.tar.gz"
            arm64_url="$BUCKET_URL/latest/darwin/$arch_filename"
            # Read signature file if it exists
            if [ -f "$targz_file.sig" ]; then
                arm64_signature=$(cat "$targz_file.sig" | tr -d '\n')
            fi
        elif [[ "$targz_file" == *"updater_intel"* ]]; then
            arch="x86_64"
            arch_name="intel"
            local arch_filename="${filename%.app.tar.gz}_${arch_name}.app.tar.gz"
            intel_url="$BUCKET_URL/latest/darwin/$arch_filename"
            # Read signature file if it exists
            if [ -f "$targz_file.sig" ]; then
                intel_signature=$(cat "$targz_file.sig" | tr -d '\n')
            fi
        fi
        
    done < <(find "$build_dir" -path "*/updater_*" -name "*.app.tar.gz" -print0)
    
    # If no .app.tar.gz found, create manifest without platforms (will cause updater to report no update)
    if [ -z "$arm64_url" ] && [ -z "$intel_url" ]; then
        log_warning "No .app.tar.gz files found - creating empty manifest"
        cat > "$manifest_file" <<EOF
{
  "version": "$version",
  "notes": "Update to version $version",
  "pub_date": "$upload_date",
  "platforms": {}
}
EOF
    else
        # Create proper Tauri updater manifest format
        cat > "$manifest_file" <<EOF
{
  "version": "$version",
  "notes": "Update to version $version",
  "pub_date": "$upload_date",
  "platforms": {
EOF
        
        local platform_entries=()
        
        if [ -n "$intel_url" ]; then
            platform_entries+=("    \"darwin-x86_64\": {
      \"signature\": \"$intel_signature\",
      \"url\": \"$intel_url\"
    }")
        fi
        
        if [ -n "$arm64_url" ]; then
            platform_entries+=("    \"darwin-aarch64\": {
      \"signature\": \"$arm64_signature\",
      \"url\": \"$arm64_url\"
    }")
        fi
        
        # Join platform entries with commas
        local first=true
        for entry in "${platform_entries[@]}"; do
            if [ "$first" = false ]; then
                echo "," >> "$manifest_file"
            fi
            echo "$entry" >> "$manifest_file"
            first=false
        done
        
        cat >> "$manifest_file" <<EOF
  }
}
EOF
    fi

    echo "$manifest_file"
}

# Create version manifest (our custom format)
create_version_manifest() {
    local version="$1"
    local build_dir="$2"
    
    local manifest_file=$(mktemp)
    local upload_date=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    
    # Start JSON
    cat > "$manifest_file" <<EOF
{
  "version": "$version",
  "uploadDate": "$upload_date",
  "files": {
EOF

    local entries=()
    
    # Process DMG files
    while IFS= read -r -d '' dmg_file; do
        if [[ "$dmg_file" == *"arm64"* ]]; then
            arch="arm64"
        elif [[ "$dmg_file" == *"intel"* ]]; then
            arch="intel"
        else
            arch="universal"
        fi
        
        local filename=$(basename "$dmg_file")
        local size=$(stat -f%z "$dmg_file" 2>/dev/null || stat -c%s "$dmg_file")
        
        entries+=("    \"macos_${arch}_dmg\": {
      \"filename\": \"$filename\",
      \"url\": \"$BUCKET_URL/latest/darwin/$filename\",
      \"size\": $size,
      \"arch\": \"$arch\",
      \"type\": \"dmg\"
    }")
    done < <(find "$build_dir" -name "*.dmg" -print0)
    
    # Process APP bundles (zipped)
    while IFS= read -r -d '' app_file; do
        if [[ "$app_file" == *"arm64"* ]]; then
            arch="arm64"
        elif [[ "$app_file" == *"intel"* ]]; then
            arch="intel"
        else
            arch="universal"
        fi
        
        local app_name=$(basename "$app_file")
        local zip_name="${app_name%.app}_${arch}.zip"
        local size=$(du -sk "$app_file" | cut -f1)
        size=$((size * 1024))  # Convert KB to bytes
        
        entries+=("    \"macos_${arch}_app\": {
      \"filename\": \"$zip_name\",
      \"url\": \"$BUCKET_URL/latest/darwin/$zip_name\",
      \"size\": $size,
      \"arch\": \"$arch\",
      \"type\": \"app\"
    }")
    done < <(find "$build_dir" -name "*.app" -type d -print0)
    
    # Join entries with commas
    local first=true
    for entry in "${entries[@]}"; do
        if [ "$first" = false ]; then
            echo "," >> "$manifest_file"
        fi
        echo "$entry" >> "$manifest_file"
        first=false
    done
    
    # Close JSON
    cat >> "$manifest_file" <<EOF
  }
}
EOF

    echo "$manifest_file"
}

# Clear the 'latest/darwin' directory on Tigris
clear_latest_directory() {
    log_info "Clearing 'latest/darwin' directory on Tigris..."

    # Configure AWS CLI for Tigris
    export AWS_ACCESS_KEY_ID="$TIGRIS_ACCESS_KEY_ID"
    export AWS_SECRET_ACCESS_KEY="$TIGRIS_SECRET_ACCESS_KEY"
    export AWS_ENDPOINT_URL="$TIGRIS_ENDPOINT"
    export AWS_REGION="auto"

    # The command doesn't fail if the directory is empty or doesn't exist.
    # We wrap this in an if to prevent script exit on failure due to set -e.
    if aws s3 rm "s3://$TIGRIS_BUCKET/latest/darwin/" --recursive; then
        log_success "Successfully cleared 'latest/darwin' directory."
    else
        log_warning "Could not clear 'latest/darwin' directory. Proceeding with upload anyway."
    fi
}

# Main upload function
main_upload() {
    clear_latest_directory
    local build_dir=$(find_latest_build)
    local version=$(get_app_version)
    
    log_info "Found build directory: $build_dir"
    log_info "App version: $version"
    
    # Upload DMG files
    find "$build_dir" -name "*.dmg" | while read dmg_file; do
        if [[ "$dmg_file" == *"arm64"* ]]; then
            arch="arm64"
        elif [[ "$dmg_file" == *"intel"* ]]; then
            arch="intel"
        else
            arch="universal"
        fi
        
        local filename=$(basename "$dmg_file")
        
        # Upload to versioned path
        upload_file "$dmg_file" "versions/$version/darwin/$filename" "$version" "$arch" "dmg"
        
        # Upload to latest path (for easy access)
        upload_file "$dmg_file" "latest/darwin/$filename" "$version" "$arch" "dmg"
    done
    
    # Upload APP bundles (zipped for transport)
    find "$build_dir" -name "*.app" -type d | while read app_file; do
        if [[ "$app_file" == *"arm64"* ]]; then
            arch="arm64"
        elif [[ "$app_file" == *"intel"* ]]; then
            arch="intel"
        else
            arch="universal"
        fi
        
        local app_name=$(basename "$app_file")
        local zip_name="${app_name%.app}_${arch}.zip"
        local temp_zip=$(mktemp -d)/"$zip_name"
        
        log_info "Creating ZIP archive for $app_name..."
        cd "$(dirname "$app_file")"
        zip -r "$temp_zip" "$app_name" > /dev/null
        cd - > /dev/null
        
        # Upload to versioned path
        upload_file "$temp_zip" "versions/$version/darwin/$zip_name" "$version" "$arch" "app"
        
        # Upload to latest path
        upload_file "$temp_zip" "latest/darwin/$zip_name" "$version" "$arch" "app"
        
        rm "$temp_zip"
    done
    
    # Upload .tar.gz files (for Tauri updater)
    find "$build_dir" -path "*/updater_*" -name "*.app.tar.gz" | while read targz_file; do
        if [[ "$targz_file" == *"aarch64"* ]] || [[ "$targz_file" == *"arm64"* ]]; then
            arch="arm64"
        elif [[ "$targz_file" == *"x64"* ]] || [[ "$targz_file" == *"intel"* ]] || [[ "$targz_file" == *"x86_64"* ]]; then
            arch="intel"
        else
            arch="universal"
        fi
        
        local filename=$(basename "$targz_file")
        # Add architecture to filename to avoid overwrites
        local arch_filename="${filename%.app.tar.gz}_${arch}.app.tar.gz"
        
        # Upload to versioned path
        upload_file "$targz_file" "versions/$version/darwin/$arch_filename" "$version" "$arch" "targz"
        
        # Upload to latest path (required for Tauri updater)
        upload_file "$targz_file" "latest/darwin/$arch_filename" "$version" "$arch" "targz"
        
        # Upload signature file if it exists
        if [ -f "$targz_file.sig" ]; then
            local sig_filename="${arch_filename}.sig"
            upload_file "$targz_file.sig" "versions/$version/darwin/$sig_filename" "$version" "$arch" "sig"
            upload_file "$targz_file.sig" "latest/darwin/$sig_filename" "$version" "$arch" "sig"
        fi
    done
    
    # Create and upload version manifest
    log_info "Creating version manifest..."
    local manifest_file=$(create_version_manifest "$version" "$build_dir")
    
    if [ ! -f "$manifest_file" ]; then
        log_error "Failed to create manifest file: $manifest_file"
        exit 1
    fi
    
    log_info "Created manifest file: $manifest_file"
    log_info "Manifest content preview:"
    head -10 "$manifest_file"
    
    upload_file "$manifest_file" "latest/darwin/version.json" "$version" "all" "manifest"
    upload_file "$manifest_file" "versions/$version/darwin/version.json" "$version" "all" "manifest"
    rm "$manifest_file"
    
    # Create and upload Tauri updater manifest (secure format with signatures)
    log_info "Creating Tauri updater manifest..."
    local tauri_manifest_file=$(create_tauri_manifest "$version" "$build_dir")
    
    if [ ! -f "$tauri_manifest_file" ]; then
        log_warning "Failed to create Tauri manifest, updater will not work"
    else
        log_info "Created Tauri manifest file: $tauri_manifest_file"
        log_info "Tauri manifest content:"
        cat "$tauri_manifest_file"
        
        # Upload Tauri manifest to match the endpoint in tauri.conf.json
        # {{target}} will be replaced by 'darwin' for macOS
        upload_file "$tauri_manifest_file" "latest/darwin/latest.json" "$version" "all" "tauri_manifest"
        upload_file "$tauri_manifest_file" "versions/$version/darwin/latest.json" "$version" "all" "tauri_manifest"
        rm "$tauri_manifest_file"
    fi
    
    log_success "🎉 Upload completed successfully!"
    echo ""
    log_info "Files available at:"
    echo "  📦 Latest builds: $BUCKET_URL/latest/darwin/"
    echo "  📋 Version manifest: $BUCKET_URL/latest/darwin/version.json"
    echo "  📚 All versions: $BUCKET_URL/versions/"
}

# Main execution
main() {
    echo "🚀 Clones Desktop - Tigris Upload Script"
    echo "========================================"
    
    if [ -z "${1:-}" ]; then
        log_error "Usage: $0 <environment>"
        echo "  Environment: prod, test"
        echo "  Example: $0 prod"
        echo "  Example: $0 test"
        exit 1
    fi
    
    local environment="$1"
    
    set_environment_config "$environment"
    load_env "$environment"
    check_prerequisites
    main_upload
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi