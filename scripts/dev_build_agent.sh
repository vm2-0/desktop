#!/bin/bash

set -e

echo "🔧 Building and signing Tauri agent for development..."

cd src-tauri

# Build the agent
echo "Building agent..."
cargo build

# Sign the executable for macOS development
if [[ "$OSTYPE" == "darwin"* ]]; then
    EXECUTABLE_PATH="target/debug/clones_desktop"
    
    if [ -f "$EXECUTABLE_PATH" ]; then
        echo "Signing executable with ad-hoc signature..."
        codesign --force --deep --sign - "$EXECUTABLE_PATH"
        echo "✅ Agent built and signed: $EXECUTABLE_PATH"
    else
        echo "❌ Executable not found: $EXECUTABLE_PATH"
        exit 1
    fi
else
    echo "✅ Agent built (no signing needed on non-macOS)"
fi

echo "🎉 Development agent ready!"