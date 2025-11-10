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

# Environment configuration
set_environment_config() {
    local env="$1"
    
    case "$env" in
        "prod")
            export TIGRIS_BUCKET="clones-desktop-release-prod"
            ;;
        "test")
            export TIGRIS_BUCKET="clones-desktop-release-test"
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

# Delete specific CQA version files
delete_cqa_version() {
    local version="$1"
    
    # Configure AWS CLI for Tigris
    export AWS_ACCESS_KEY_ID="$TIGRIS_ACCESS_KEY_ID"
    export AWS_SECRET_ACCESS_KEY="$TIGRIS_SECRET_ACCESS_KEY"
    export AWS_ENDPOINT_URL="$TIGRIS_ENDPOINT"
    export AWS_REGION="auto"

    # Define the files to delete
    local files_to_delete=(
        "cqa/clones-quality-agent-linux-x64-package-v${version}.tar.gz"
        "cqa/clones-quality-agent-linux-x64-v${version}"
        "cqa/clones-quality-agent-macos-arm64-package-v${version}.tar.gz"
        "cqa/clones-quality-agent-macos-arm64-v${version}"
        "cqa/clones-quality-agent-win-x64-v${version}.exe"
        "cqa/clones-quality-agent-win-x64-v${version}.zip"
    )
    
    local deleted_count=0
    local not_found_count=0
    
    log_info "Checking CQA version '$version' files in /cqa folder..."
    
    for file_path in "${files_to_delete[@]}"; do
        # Check if file exists
        if aws s3api head-object --bucket "$TIGRIS_BUCKET" --key "$file_path" &> /dev/null; then
            log_info "Found: $file_path"
            ((deleted_count++))
        else
            log_warning "Not found: $file_path"
            ((not_found_count++))
        fi
    done
    
    if [ $deleted_count -eq 0 ]; then
        log_error "No CQA files found for version '$version'"
        log_info "Nothing to delete."
        exit 1
    fi
    
    log_success "Found $deleted_count CQA files for version '$version'"
    if [ $not_found_count -gt 0 ]; then
        log_warning "$not_found_count files were not found (this is normal if some platforms weren't built)"
    fi
    
    log_warning "This will permanently delete $deleted_count CQA files for version '$version'"
    
    # Confirmation prompt
    read -p "Are you sure you want to continue? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Deletion cancelled by user."
        exit 0
    fi
    
    # Delete each existing file
    local actual_deleted=0
    for file_path in "${files_to_delete[@]}"; do
        local s3_path="s3://$TIGRIS_BUCKET/$file_path"
        
        # Check if file exists before attempting deletion
        if aws s3api head-object --bucket "$TIGRIS_BUCKET" --key "$file_path" &> /dev/null; then
            log_info "Deleting: $file_path"
            if aws s3 rm "$s3_path"; then
                log_success "Deleted: $file_path"
                ((actual_deleted++))
            else
                log_error "Failed to delete: $file_path"
            fi
        fi
    done
    
    if [ $actual_deleted -gt 0 ]; then
        log_success "Successfully deleted $actual_deleted CQA files for version '$version'."
    else
        log_error "Failed to delete any CQA files for version '$version'."
        exit 1
    fi
}

# Main execution
main() {
    echo "🗑️  Clones Desktop - CQA Version Deletion Script"
    echo "==============================================="
    
    if [ -z "${1:-}" ] || [ -z "${2:-}" ]; then
        log_error "Usage: $0 <environment> <version>"
        echo "  Environment: prod, test"
        echo "  Example: $0 prod 2.0.24"
        echo "  Example: $0 test 2.0.24"
        echo ""
        echo "  This script deletes CQA (Clones Quality Agent) files for a specific version:"
        echo "    - clones-quality-agent-linux-x64-package-v{version}.tar.gz"
        echo "    - clones-quality-agent-linux-x64-v{version}"
        echo "    - clones-quality-agent-macos-arm64-package-v{version}.tar.gz"
        echo "    - clones-quality-agent-macos-arm64-v{version}"
        echo "    - clones-quality-agent-win-x64-v{version}.exe"
        echo "    - clones-quality-agent-win-x64-v{version}.zip"
        exit 1
    fi
    
    local environment="$1"
    local version_to_delete="$2"
    
    set_environment_config "$environment"
    load_env "$environment"
    check_prerequisites
    delete_cqa_version "$version_to_delete"
    
    log_success "🎉 CQA deletion process completed successfully!"
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi