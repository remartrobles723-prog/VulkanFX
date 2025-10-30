#!/bin/bash
echo "Testing CMake build with CAS only (no ReShade)..."
echo ""

# Set environment
export DISPLAY=:0
export ENABLE_VULKANFX=1
export LD_LIBRARY_PATH="$PWD/build/src:$LD_LIBRARY_PATH"

# Create simple CAS config
mkdir -p ~/.config/VulkanFX
cat > ~/.config/VulkanFX/VulkanFX.conf << 'EOF'
effects = cas
toggleKey = Home
enableOnLaunch = True
casSharpness = 1.0
depthCapture = off
EOF

echo "Config created:"
cat ~/.config/VulkanFX/VulkanFX.conf
echo ""
echo "Starting vkcube with CAS sharpening..."
echo "Press Ctrl+C to stop"
echo ""

vkcube
