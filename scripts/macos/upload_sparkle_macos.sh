#!/bin/bash

set -euo pipefail

echo "🚀 Uploading Sparkle appcast and DMG files"

ENVIRONMENT="${1:-test}"

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

# Environment configuration (fallback values if not set in .env files)
set_environment_config() {
    local env="$1"
    
    case "$env" in
        "prod")
            export TIGRIS_BUCKET="${TIGRIS_BUCKET:-clones-desktop-release-prod}"
            export BUCKET_URL="${BUCKET_URL:-https://releases.clones-ai.com}"
            ;;
        "test")
            export TIGRIS_BUCKET="${TIGRIS_BUCKET:-clones-desktop-release-test}"
            export BUCKET_URL="${BUCKET_URL:-https://releases-test.clones-ai.com}"
            ;;
        *)
            log_error "Invalid environment: $env"
            echo "  Valid environments: prod, test"
            exit 1
            ;;
    esac
    
    export TIGRIS_ENDPOINT="${TIGRIS_ENDPOINT:-https://fly.storage.tigris.dev}"
    log_info "Environment set to: $env (bucket: $TIGRIS_BUCKET)"
}

# Get app version from pubspec.yaml
get_app_version() {
    if [ ! -f "pubspec.yaml" ]; then
        log_error "pubspec.yaml not found"
        exit 1
    fi
    
    local version=$(grep -o '^version:[[:space:]]*[^+]*' pubspec.yaml | sed 's/version:[[:space:]]*//')
    
    if [ -z "$version" ]; then
        log_error "Could not extract version from pubspec.yaml"
        exit 1
    fi
    
    echo "$version"
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

# Upload file to Tigris
upload_file() {
    local file_path="$1"
    local s3_key="$2"
    local version="$3"
    
    if [ ! -f "$file_path" ]; then
        log_error "File not found: $file_path"
        return 1
    fi
    
    local file_size=$(stat -f%z "$file_path" 2>/dev/null || stat -c%s "$file_path")
    local file_name=$(basename "$file_path")
    
    log_info "Uploading $file_name (${file_size} bytes) to $s3_key..."
    
    # Configure AWS CLI for Tigris
    export AWS_ACCESS_KEY_ID="$TIGRIS_ACCESS_KEY_ID"
    export AWS_SECRET_ACCESS_KEY="$TIGRIS_SECRET_ACCESS_KEY"
    export AWS_ENDPOINT_URL="$TIGRIS_ENDPOINT"
    export AWS_REGION="auto"
    
    # Upload to S3-compatible Tigris storage
    aws s3 cp "$file_path" \
        "s3://${TIGRIS_BUCKET}/${s3_key}" \
        --no-progress
    
    log_success "Uploaded: $file_name → $s3_key"
    echo "  📄 Direct URL: ${BUCKET_URL}/${s3_key}"
}

# Create Tauri updater manifest (latest.json)
create_tauri_manifest() {
    local version="$1"
    local releases_dir="$2"
    
    local manifest_file=$(mktemp -t "manifest_XXXXXX")
    local upload_date=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    
    # Find DMG files and extract info
    local arm64_url=""
    local intel_url=""
    local universal_url=""
    
    # Look for DMG files in releases directory
    while IFS= read -r -d '' dmg_file; do
        local filename=$(basename "$dmg_file")
        local arch=""
        
        if [[ "$filename" == *"arm64"* ]] || [[ "$filename" == *"aarch64"* ]]; then
            arch="aarch64"
            arm64_url="$BUCKET_URL/latest/darwin/$filename"
        elif [[ "$filename" == *"intel"* ]] || [[ "$filename" == *"x64"* ]] || [[ "$filename" == *"x86_64"* ]]; then
            arch="x86_64"
            intel_url="$BUCKET_URL/latest/darwin/$filename"
        else
            arch="universal"
            universal_url="$BUCKET_URL/latest/darwin/$filename"
        fi
        
    done < <(find "$releases_dir" -name "*.dmg" -print0)
    
    # Create Tauri updater manifest format
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
      \"signature\": \"\",
      \"url\": \"$intel_url\"
    }")
    fi
    
    if [ -n "$arm64_url" ]; then
        platform_entries+=("    \"darwin-aarch64\": {
      \"signature\": \"\",
      \"url\": \"$arm64_url\"
    }")
    fi
    
    if [ -n "$universal_url" ]; then
        platform_entries+=("    \"darwin-universal\": {
      \"signature\": \"\",
      \"url\": \"$universal_url\"
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

    echo "$manifest_file"
}

# Create version manifest for download page (version.json)
create_version_manifest() {
    local version="$1"
    local releases_dir="$2"
    
    local manifest_file=$(mktemp -t "manifest_XXXXXX")
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
        local filename=$(basename "$dmg_file")
        local arch=""
        
        if [[ "$filename" == *"arm64"* ]] || [[ "$filename" == *"aarch64"* ]]; then
            arch="arm64"
        elif [[ "$filename" == *"intel"* ]] || [[ "$filename" == *"x64"* ]] || [[ "$filename" == *"x86_64"* ]]; then
            arch="intel"
        else
            arch="universal"
        fi
        
        local size=$(stat -f%z "$dmg_file" 2>/dev/null || stat -c%s "$dmg_file")
        
        entries+=("    \"macos_${arch}_dmg\": {
      \"filename\": \"$filename\",
      \"url\": \"$BUCKET_URL/latest/darwin/$filename\",
      \"size\": $size,
      \"arch\": \"$arch\",
      \"type\": \"dmg\"
    }")
    done < <(find "$releases_dir" -name "*.dmg" -print0)
    
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

# Upload Sparkle appcast and DMG files
upload_sparkle_files() {
    local version="$1"
    local releases_dir="releases/${ENVIRONMENT}/darwin"
    
    if [ ! -d "$releases_dir" ]; then
        log_error "Releases directory not found: $releases_dir"
        log_info "Run generate_appcast.sh first"
        exit 1
    fi
    
    log_info "Uploading Sparkle files from: $releases_dir"
    
    # Upload appcast.xml (main feed)
    if [ -f "$releases_dir/appcast.xml" ]; then
        upload_file "$releases_dir/appcast.xml" "latest/darwin/appcast.xml" "$version"
        upload_file "$releases_dir/appcast.xml" "versions/$version/darwin/appcast.xml" "$version"
    else
        log_error "appcast.xml not found in $releases_dir"
        exit 1
    fi
    
    # Upload DMG files
    find "$releases_dir" -name "*.dmg" | while read dmg_file; do
        local dmg_name=$(basename "$dmg_file")
        
        # Upload to both latest and versioned paths
        upload_file "$dmg_file" "latest/darwin/$dmg_name" "$version"
        upload_file "$dmg_file" "versions/$version/darwin/$dmg_name" "$version"
    done
    
    # Upload signature files (.sig)
    find "$releases_dir" -name "*.sig" | while read sig_file; do
        local sig_name=$(basename "$sig_file")
        
        upload_file "$sig_file" "latest/darwin/$sig_name" "$version"
        upload_file "$sig_file" "versions/$version/darwin/$sig_name" "$version"
    done
    
    # Create and upload Tauri updater manifest (latest.json)
    log_info "Creating Tauri updater manifest..."
    local tauri_manifest_file=$(create_tauri_manifest "$version" "$releases_dir")
    
    if [ ! -f "$tauri_manifest_file" ]; then
        log_warning "Failed to create Tauri manifest"
    else
        log_info "Tauri manifest content:"
        cat "$tauri_manifest_file"
        
        upload_file "$tauri_manifest_file" "latest/darwin/latest.json" "$version"
        upload_file "$tauri_manifest_file" "versions/$version/darwin/latest.json" "$version"
        rm "$tauri_manifest_file"
    fi
    
    # Create and upload version manifest (version.json)
    log_info "Creating version manifest for download page..."
    local version_manifest_file=$(create_version_manifest "$version" "$releases_dir")
    
    if [ ! -f "$version_manifest_file" ]; then
        log_warning "Failed to create version manifest"
    else
        log_info "Version manifest content:"
        cat "$version_manifest_file"
        
        upload_file "$version_manifest_file" "latest/darwin/version.json" "$version"
        upload_file "$version_manifest_file" "versions/$version/darwin/version.json" "$version"
        rm "$version_manifest_file"
    fi
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

# Main execution
main() {
    echo "🔗 Sparkle macOS Upload Script"
    echo "==============================="
    
    if [ -z "${1:-}" ]; then
        log_error "Usage: $0 <environment>"
        echo "  Environment: prod, test"
        echo "  Example: $0 prod"
        echo "  Example: $0 test"
        exit 1
    fi
    
    local environment="$1"
    
    # Check AWS CLI
    if ! command -v aws &> /dev/null; then
        log_error "AWS CLI not found. Please install it."
        exit 1
    fi
    
    load_env "$environment"
    set_environment_config "$environment"
    
    local version=$(get_app_version)
    log_info "App version: $version"
    
    # Clear latest directory before uploading new files
    clear_latest_directory
    
    upload_sparkle_files "$version"
    
    echo ""
    log_success "🎉 Sparkle upload completed!"
    log_info "Appcast URL: ${BUCKET_URL}/latest/darwin/appcast.xml"
    log_info "Downloads: ${BUCKET_URL}/latest/darwin/"
    
    # Verify CDN propagation with cache-busting
    log_info "Verifying CDN propagation..."
    sleep 2
    local remote_version=$(curl -s -H "Cache-Control: no-cache" -H "Pragma: no-cache" "${BUCKET_URL}/latest/darwin/appcast.xml" | grep -o '<sparkle:shortVersionString>[^<]*</sparkle:shortVersionString>' | sed 's/<[^>]*>//g' || echo "unknown")
    
    if [ "$remote_version" = "$version" ]; then
        log_success "CDN propagation verified - version $version is live"
    else
        log_warning "CDN propagation pending - remote shows $remote_version, expected $version"
        log_info "This is normal and should resolve within a few minutes"
    fi
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi