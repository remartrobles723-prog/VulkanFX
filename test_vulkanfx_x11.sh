#!/bin/bash

echo "=== VulkanFX X11 Test Suite ==="
echo ""

# Set up environment
export VK_LAYER_PATH="$(pwd)/build/config"
export ENABLE_VULKANFX=1

# Check if X11 is running
if [ -z "$DISPLAY" ]; then
    echo "⚠ No DISPLAY set. Starting VNC server..."
    ./start_vnc.sh
    export DISPLAY=:1
    sleep 2
fi

echo "Display: $DISPLAY"
echo "VK_LAYER_PATH: $VK_LAYER_PATH"
echo "ENABLE_VULKANFX: $ENABLE_VULKANFX"
echo ""

# Test 1: Check Vulkan availability
echo "=== Test 1: Vulkan Availability ==="
if command -v vulkaninfo &> /dev/null; then
    echo "✓ vulkaninfo found"
    
    # Run vulkaninfo and check for VulkanFX
    echo ""
    echo "Running vulkaninfo to detect VulkanFX layer..."
    echo "---"
    
    # Capture output
    VULKAN_OUTPUT=$(vulkaninfo 2>&1)
    
    # Check for VulkanFX in layers
    if echo "$VULKAN_OUTPUT" | grep -qi "vulkanfx\|VK_LAYER_VULKANFX"; then
        echo "✓ VulkanFX layer detected!"
        echo ""
        echo "VulkanFX layer information:"
        echo "$VULKAN_OUTPUT" | grep -i "vulkanfx" -A 5
    else
        echo "⚠ VulkanFX layer not detected in vulkaninfo output"
        echo ""
        echo "Available layers:"
        echo "$VULKAN_OUTPUT" | grep -i "layer" | head -20
    fi
else
    echo "✗ vulkaninfo not found"
fi

echo ""
echo "=== Test 2: Library Check ==="
for lib in build/src/libVkLayer_VulkanFX_*.so; do
    if [ -f "$lib" ]; then
        echo "✓ $(basename $lib)"
    fi
done

echo ""
echo "=== Test 3: Configuration Files ==="
if [ -f "build/config/VulkanFX.json" ]; then
    echo "✓ Layer manifest exists"
    echo "  Layers defined:"
    grep '"name"' build/config/VulkanFX.json | sed 's/.*"name": "\(.*\)".*/    - \1/'
fi

if [ -f "config/VulkanFX.conf" ]; then
    echo "✓ Configuration file exists"
    echo "  Active effects:"
    grep "^effects" config/VulkanFX.conf | sed 's/effects = /    /'
fi

echo ""
echo "=== Test 4: Simple Vulkan Test ==="
echo "Testing with vkcube (if available)..."
if command -v vkcube &> /dev/null; then
    echo "Starting vkcube with VulkanFX enabled..."
    echo "Press Ctrl+C to stop"
    vkcube &
    VKCUBE_PID=$!
    sleep 5
    kill $VKCUBE_PID 2>/dev/null
    echo "✓ vkcube test completed"
else
    echo "⚠ vkcube not available (install with: pkg install vulkan-tools)"
fi

echo ""
echo "=== Test Complete ==="
echo ""
echo "To manually test with any Vulkan application:"
echo "  export DISPLAY=:1"
echo "  export VK_LAYER_PATH=\"$(pwd)/build/config\""
echo "  export ENABLE_VULKANFX=1"
echo "  your-vulkan-app"
echo ""
echo "Available VulkanFX variants:"
echo "  ENABLE_VULKANFX=1      - Default (with ReShade)"
echo "  ENABLE_VULKANFX=depth  - With depth capture"
echo "  ENABLE_VULKANFX=simple - Lightweight (no ReShade)"
echo ""
