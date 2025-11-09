#!/bin/bash

# Script to compile screen_recorder binary
# This should be run manually when needed

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SOURCE_FILE="$PROJECT_DIR/src-tauri/src/tools/screen_recorder.m"
OUTPUT_BINARY="$PROJECT_DIR/src-tauri/src/tools/screen_recorder"

echo "Compiling screen_recorder binary..."
echo "Source: $SOURCE_FILE"
echo "Output: $OUTPUT_BINARY"

# Check if source file exists
if [ ! -f "$SOURCE_FILE" ]; then
    echo "Error: Source file not found: $SOURCE_FILE"
    exit 1
fi

# Remove existing binary
rm -f "$OUTPUT_BINARY"

# Try different compilation approaches
echo "Resolving macOS SDK path..."
SDK_PATH=$(xcrun --sdk macosx --show-sdk-path 2>/dev/null) || {
    echo "❌ Failed to resolve macOS SDK path"
    exit 1
}
echo "Using SDK: $SDK_PATH"

COMMON_FLAGS=(-fobjc-arc -mmacos-version-min=12.3 -isysroot "$SDK_PATH" -framework Foundation -framework ScreenCaptureKit -framework AVFoundation -framework CoreMedia -framework CoreVideo -O2)

echo "Compiling arm64 slice..."
if ! xcrun clang -arch arm64 "${COMMON_FLAGS[@]}" -o "$OUTPUT_BINARY.arm64" "$SOURCE_FILE" 2>/dev/null; then
    echo "❌ Failed to compile arm64 slice"
    exit 1
fi

echo "Compiling x86_64 slice..."
if ! xcrun clang -arch x86_64 "${COMMON_FLAGS[@]}" -o "$OUTPUT_BINARY.x86_64" "$SOURCE_FILE" 2>/dev/null; then
    echo "❌ Failed to compile x86_64 slice"
    exit 1
fi

echo "Creating universal binary with lipo..."
if ! lipo -create -output "$OUTPUT_BINARY" "$OUTPUT_BINARY.arm64" "$OUTPUT_BINARY.x86_64" 2>/dev/null; then
    echo "❌ Failed to create universal binary"
    exit 1
fi

# Verify binary was created
if [ ! -f "$OUTPUT_BINARY" ]; then
    echo "❌ Binary was not created"
    exit 1
fi

# Make executable
chmod +x "$OUTPUT_BINARY"

# Check file info
echo "✅ Binary created successfully:"
echo "  Size: $(wc -c < "$OUTPUT_BINARY") bytes"
echo "  Architectures: $(lipo -archs "$OUTPUT_BINARY" 2>/dev/null || echo "unknown")"
echo "  File: $OUTPUT_BINARY"

echo "Done!"