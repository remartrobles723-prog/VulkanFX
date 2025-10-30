#!/bin/bash

echo "╔════════════════════════════════════════════════════════════╗"
echo "║         Testing CMake-Built VulkanFX Libraries            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check if CMake libraries exist
if [ ! -f "build/src/libVkLayer_VulkanFX_default.so" ]; then
    echo "❌ CMake libraries not found in build/src/"
    echo ""
    echo "Please run first:"
    echo "  cp build_cmake/libVkLayer_VulkanFX_*.so build/src/"
    echo "  cp build_cmake/subprojects/reshade/libReShadeFX*.so build/src/"
    exit 1
fi

echo "✓ CMake-built libraries found in build/src/"
echo ""
echo "Library sizes:"
ls -lh build/src/libVkLayer_VulkanFX_*.so | awk '{print "  " $9 ": " $5}'
echo ""
echo "ReShade libraries:"
ls -lh build/src/libReShadeFX*.so | awk '{print "  " $9 ": " $5}'
echo ""

# Set LD_LIBRARY_PATH to find ReShade libraries
export LD_LIBRARY_PATH="$PWD/build/src:$LD_LIBRARY_PATH"

echo "═══════════════════════════════════════════════════════════"
echo ""
echo "Running test_reshade.sh with CMake-built libraries..."
echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""

# Run the actual test script
exec ./test_reshade.sh
