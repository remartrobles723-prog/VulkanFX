#!/bin/bash

# Quick test for VulkanFX with Termux:X11

echo "=== Quick VulkanFX Test ==="
echo ""

# Set environment
export DISPLAY=:0
export VK_LAYER_PATH="$(pwd)/build/config"
export ENABLE_VULKANFX=1
export MESA_GL_VERSION_OVERRIDE=4.5
export MESA_GLSL_VERSION_OVERRIDE=450

# Check if X11 is running
if xset q &>/dev/null 2>&1; then
    echo "✓ X11 is running"
    
    # Test with glxgears (simpler than vkcube)
    echo ""
    echo "Testing with glxgears (OpenGL)..."
    echo "You should see rotating gears in Termux:X11 app"
    echo "Press Ctrl+C to stop"
    echo ""
    sleep 2
    glxgears
else
    echo "❌ X11 is not running"
    echo ""
    echo "To start X11:"
    echo "  1. Open Termux:X11 app"
    echo "  2. Run: ./start_x11.sh"
    echo ""
fi
