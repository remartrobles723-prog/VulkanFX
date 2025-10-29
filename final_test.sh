#!/bin/bash

clear
echo "╔════════════════════════════════════════════════════════════╗"
echo "║    VulkanFX Final Test - Maximum Visibility               ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Create extreme config for maximum visibility
cat > "$HOME/.config/VulkanFX/VulkanFX.conf" << 'EOF'
# EXTREME SETTINGS - Maximum visibility!
effects = cas:cas:cas:cas:cas
toggleKey = Home
enableOnLaunch = True
casSharpness = 1.0
EOF

echo "✓ Created EXTREME config:"
echo "  - 5x CAS passes"
echo "  - Maximum sharpness (1.0)"
echo ""

# Set environment with absolute paths
export DISPLAY=:0
export VK_LAYER_PATH="/data/data/com.termux/files/home/VulkanFX/build/config"
export ENABLE_VULKANFX=1
export MESA_GL_VERSION_OVERRIDE=4.5
export MESA_GLSL_VERSION_OVERRIDE=450
export GALLIUM_DRIVER=llvmpipe

# Enable Vulkan loader debug
export VK_LOADER_DEBUG=warn,error,layer

echo "Environment:"
echo "  VK_LAYER_PATH=$VK_LAYER_PATH"
echo "  ENABLE_VULKANFX=$ENABLE_VULKANFX"
echo ""

echo "═══════════════════════════════════════════════════════════"
echo ""
echo "TEST: Running glxgears with EXTREME sharpening"
echo ""
echo "WHAT TO DO:"
echo "  1. Watch the gears carefully"
echo "  2. Press HOME key to toggle effects"
echo "  3. Look for ANY change in sharpness/clarity"
echo ""
echo "If you see NO difference at all, VulkanFX may not be loading"
echo ""
read -p "Press Enter to start test..."

echo ""
echo "Starting glxgears..."
echo "Press HOME key repeatedly and watch for changes!"
echo "Press Ctrl+C to stop"
echo ""

glxgears 2>&1 | grep -i "vulkan\|layer\|error" &
GEARS_PID=$!

sleep 2
glxgears

kill $GEARS_PID 2>/dev/null

echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "Did you see ANY difference when pressing HOME?"
echo ""
echo "If NO:"
echo "  - VulkanFX layer may not be loading"
echo "  - Run: ./diagnose.sh for more info"
echo ""
echo "If YES:"
echo "  - VulkanFX is working!"
echo "  - Try different effects in the config"
echo ""
