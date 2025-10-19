#!/bin/bash
# Script wrapper to launch Tauri agent from Flutter

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Primary candidate: debug build
AGENT_PATH="$REPO_ROOT/src-tauri/target/debug/clones_desktop"

if [ ! -f "$AGENT_PATH" ]; then
    # Fallback: release build
    AGENT_PATH="$REPO_ROOT/src-tauri/target/release/clones_desktop"
fi

if [ ! -f "$AGENT_PATH" ]; then
    echo "ERROR: Tauri agent not found at $AGENT_PATH" >&2
    exit 1
fi

# Set environment
export PRIMARY_LOGGER=true
export RUST_LOG=info

# Launch agent
exec "$AGENT_PATH" "$@"