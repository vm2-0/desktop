#!/bin/bash

# Bash script to launch Tauri agent in development mode
# This script sets the necessary environment variables and runs cargo run

# Default values
RUST_LOG="${RUST_LOG:-debug}"
PRIMARY_LOGGER="${PRIMARY_LOGGER:-true}"
CLONES_DEV_MODE="${CLONES_DEV_MODE:-true}"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --rust-log)
            RUST_LOG="$2"
            shift 2
            ;;
        --primary-logger)
            PRIMARY_LOGGER="$2"
            shift 2
            ;;
        --dev-mode)
            CLONES_DEV_MODE="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --rust-log LEVEL     Set RUST_LOG level (default: debug)"
            echo "  --primary-logger     Set PRIMARY_LOGGER (default: true)"
            echo "  --dev-mode          Set CLONES_DEV_MODE (default: true)"
            echo "  -h, --help          Show this help message"
            echo ""
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Define paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
TAURI_DIR="$PROJECT_ROOT/src-tauri"

echo -e "${CYAN}=====================================${NC}"
echo -e "${GREEN}Tauri Agent Development Launcher${NC}"
echo -e "${CYAN}=====================================${NC}"
echo ""
echo -e "${YELLOW}Project Root: $PROJECT_ROOT${NC}"
echo -e "${YELLOW}Tauri Directory: $TAURI_DIR${NC}"
echo ""
echo -e "${CYAN}Environment Variables:${NC}"
echo -e "${WHITE}  PRIMARY_LOGGER = $PRIMARY_LOGGER${NC}"
echo -e "${WHITE}  RUST_LOG = $RUST_LOG${NC}"
echo -e "${WHITE}  CLONES_DEV_MODE = $CLONES_DEV_MODE${NC}"
echo ""

# Check if Tauri directory exists
if [ ! -d "$TAURI_DIR" ]; then
    echo -e "${RED}Error: Tauri directory not found at $TAURI_DIR${NC}"
    exit 1
fi

# Check if Cargo is available
if ! command -v cargo &> /dev/null; then
    echo -e "${RED}Error: Cargo not found. Please install Rust and Cargo.${NC}"
    exit 1
fi

echo -e "${GREEN}Cargo found: $(cargo --version)${NC}"
echo ""

# Clean up any existing agent instances
echo -e "${YELLOW}Checking for existing agent instances...${NC}"
EXISTING_PIDS=$(pgrep -f "clones_desktop" 2>/dev/null || true)

if [ -n "$EXISTING_PIDS" ]; then
    echo -e "${YELLOW}Found running instance(s) with PIDs: $EXISTING_PIDS. Terminating...${NC}"
    echo "$EXISTING_PIDS" | xargs -r kill -9 2>/dev/null || true
    sleep 1
    echo -e "${GREEN}Existing instances terminated.${NC}"
else
    echo -e "${GREEN}No existing instances found.${NC}"
fi

# Check if port 19847 is in use
echo -e "${YELLOW}Checking port 19847...${NC}"
PORT_PIDS=$(lsof -ti:19847 2>/dev/null || true)

if [ -n "$PORT_PIDS" ]; then
    echo -e "${YELLOW}Warning: Port 19847 is still in use by PIDs: $PORT_PIDS. Attempting to free it...${NC}"
    echo "$PORT_PIDS" | xargs -r kill -9 2>/dev/null || true
    sleep 1
    echo -e "${GREEN}Port cleanup completed.${NC}"
else
    echo -e "${GREEN}Port 19847 is available.${NC}"
fi

echo ""

# Change to Tauri directory
cd "$TAURI_DIR" || {
    echo -e "${RED}Error: Could not change to Tauri directory${NC}"
    exit 1
}

echo -e "${YELLOW}Changed directory to: $(pwd)${NC}"
echo ""

# Set environment variables
export PRIMARY_LOGGER="$PRIMARY_LOGGER"
export RUST_LOG="$RUST_LOG"
export CLONES_DEV_MODE="$CLONES_DEV_MODE"

echo -e "${CYAN}=====================================${NC}"
echo -e "${GREEN}Starting Tauri Agent...${NC}"
echo -e "${CYAN}=====================================${NC}"
echo ""

# Set up cleanup trap
cleanup() {
    echo ""
    echo -e "${CYAN}=====================================${NC}"
    echo -e "${YELLOW}Tauri Agent Stopped${NC}"
    echo -e "${CYAN}=====================================${NC}"
    cd "$PROJECT_ROOT"
}

trap cleanup EXIT

# Run cargo
if ! cargo run; then
    echo ""
    echo -e "${RED}Error running cargo${NC}"
    exit 1
fi