#!/bin/bash

echo "Restarting vkcube..."

# Kill existing vkcube
pkill vkcube 2>/dev/null
sleep 1

# Set environment
export DISPLAY=:0
export ENABLE_VULKANFX=1
export MESA_GL_VERSION_OVERRIDE=4.5
export MESA_GLSL_VERSION_OVERRIDE=450
export GALLIUM_DRIVER=llvmpipe

echo "✓ Starting vkcube with current config..."
echo ""

vkcube
