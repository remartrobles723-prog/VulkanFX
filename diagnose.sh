#!/bin/bash

clear
echo "╔════════════════════════════════════════════════════════════╗"
echo "║         VulkanFX Diagnostic Tool                          ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Set environment
export DISPLAY=:0
export VK_LAYER_PATH="$(pwd)/build/config"
export ENABLE_VULKANFX=1

echo "=== Environment Check ==="
echo "DISPLAY: $DISPLAY"
echo "VK_LAYER_PATH: $VK_LAYER_PATH"
echo "ENABLE_VULKANFX: $ENABLE_VULKANFX"
echo ""

echo "=== Library Check ==="
for lib in build/src/libVkLayer_VulkanFX_*.so; do
    if [ -f "$lib" ]; then
        echo "✓ $(basename $lib) exists"
        file "$lib" | grep -q "ELF" && echo "  → Valid ELF library"
    fi
done
echo ""

echo "=== Layer Manifest Check ==="
if [ -f "build/config/VulkanFX.json" ]; then
    echo "✓ VulkanFX.json exists"
    echo ""
    echo "Layer names defined:"
    grep '"name"' build/config/VulkanFX.json
    echo ""
    echo "Enable environment:"
    grep -A 2 '"enable_environment"' build/config/VulkanFX.json | head -6
fi
echo ""

echo "=== Config File Check ==="
if [ -f "$HOME/.config/VulkanFX/VulkanFX.conf" ]; then
    echo "✓ Config file exists at: $HOME/.config/VulkanFX/VulkanFX.conf"
    echo ""
    echo "Active effects:"
    grep "^effects" "$HOME/.config/VulkanFX/VulkanFX.conf"
    echo ""
    echo "Toggle key:"
    grep "^toggleKey" "$HOME/.config/VulkanFX/VulkanFX.conf"
else
    echo "✗ Config file NOT found!"
    echo "  Expected at: $HOME/.config/VulkanFX/VulkanFX.conf"
fi
echo ""

echo "=== Vulkan Layer Detection Test ==="
echo "Running vulkaninfo with VK_LOADER_DEBUG=all..."
echo ""

export VK_LOADER_DEBUG=all
vulkaninfo 2>&1 | grep -i "vulkanfx\|layer" | head -20

echo ""
echo "=== Simple Effect Test ==="
echo "Let's try with just CAS (simple sharpening)..."
echo ""

# Create a simple config
cat > /tmp/test_vulkanfx.conf << 'EOF'
effects = cas:cas:cas
toggleKey = Home
enableOnLaunch = True
casSharpness = 1.0
EOF

cp /tmp/test_vulkanfx.conf "$HOME/.config/VulkanFX/VulkanFX.conf"

echo "✓ Created test config with TRIPLE CAS at maximum (1.0)"
echo ""
echo "Now run: ./test.sh"
echo "Choose option 3 (vkcube with VulkanFX)"
echo "Press HOME key to toggle"
echo ""
echo "If you see ANY difference in sharpness, VulkanFX is working!"
echo ""
