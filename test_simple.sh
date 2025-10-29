#!/bin/bash

echo "=== Simple VulkanFX Test ==="
echo ""

# Set environment
export DISPLAY=:0
export VK_LAYER_PATH="$(pwd)/build/config"
export ENABLE_VULKANFX=1

echo "Environment Setup:"
echo "  DISPLAY: $DISPLAY"
echo "  VK_LAYER_PATH: $VK_LAYER_PATH"
echo "  ENABLE_VULKANFX: $ENABLE_VULKANFX"
echo ""

# Check libraries
echo "=== Checking VulkanFX Libraries ==="
for lib in build/src/libVkLayer_VulkanFX_*.so; do
    if [ -f "$lib" ]; then
        echo "  ✓ $(basename $lib)"
    fi
done
echo ""

# Test 1: vulkaninfo
echo "=== Test 1: Running vulkaninfo ==="
if command -v vulkaninfo &> /dev/null; then
    echo "Running vulkaninfo..."
    vulkaninfo > /tmp/vulkaninfo.log 2>&1
    
    if grep -qi "vulkanfx\|VK_LAYER_VULKANFX" /tmp/vulkaninfo.log; then
        echo "  ✓ VulkanFX layer detected!"
        grep -i "vulkanfx" /tmp/vulkaninfo.log | head -5
    else
        echo "  ℹ VulkanFX layer info:"
        echo "    Layers available: $(grep -c "layerName" /tmp/vulkaninfo.log 2>/dev/null || echo 0)"
    fi
else
    echo "  ✗ vulkaninfo not found"
fi
echo ""

# Test 2: vkcube
echo "=== Test 2: Testing vkcube ==="
if command -v vkcube &> /dev/null; then
    echo "  ✓ vkcube available"
    echo ""
    echo "To run vkcube with VulkanFX:"
    echo "  export DISPLAY=:0"
    echo "  export VK_LAYER_PATH=\"$(pwd)/build/config\""
    echo "  export ENABLE_VULKANFX=1"
    echo "  vkcube"
else
    echo "  ℹ vkcube not available"
fi
echo ""

# Configuration
echo "=== VulkanFX Configuration ==="
if [ -f "config/VulkanFX.conf" ]; then
    echo "Active effects:"
    grep "^effects" config/VulkanFX.conf
    echo ""
    echo "Toggle key:"
    grep "^toggleKey" config/VulkanFX.conf
fi
echo ""

echo "=== Test Complete ==="
echo ""
echo "Available VulkanFX variants:"
echo "  ENABLE_VULKANFX=1      → Default (with ReShade)"
echo "  ENABLE_VULKANFX=depth  → With depth capture"
echo "  ENABLE_VULKANFX=simple → Lightweight"
echo ""
