#!/bin/bash

# Simple VulkanFX Test - Better viewing experience

clear
echo "╔════════════════════════════════════════════════════════════╗"
echo "║              VulkanFX Quick Test                          ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Set environment
export DISPLAY=:0
export VK_LAYER_PATH="$(pwd)/build/config"
export ENABLE_VULKANFX=1
export MESA_GL_VERSION_OVERRIDE=4.5
export MESA_GLSL_VERSION_OVERRIDE=450
export GALLIUM_DRIVER=llvmpipe

echo "Environment configured:"
echo "  ✓ DISPLAY=:0"
echo "  ✓ VulkanFX enabled (STRONG effects)"
echo "  ✓ Mesa configured"
echo ""

echo "Choose a test:"
echo ""
echo "  1) glxgears     - OpenGL rotating gears"
echo "  2) glxgears -fs - OpenGL gears FULLSCREEN"
echo "  3) vkcube       - Vulkan cube WITH VulkanFX"
echo "  4) vkcube       - Vulkan cube WITHOUT VulkanFX"
echo "  5) es2gears     - Slower rotating gears (better for comparison)"
echo ""
read -p "Enter choice [1-5]: " choice

echo ""
case $choice in
    1)
        echo "🎮 Starting glxgears..."
        echo "   Press Ctrl+C to stop"
        echo ""
        glxgears
        ;;
    2)
        echo "🎮 Starting glxgears FULLSCREEN..."
        echo "   Press ESC or Ctrl+C to exit"
        echo ""
        glxgears -fullscreen
        ;;
    3)
        echo "🎮 Starting vkcube WITH VulkanFX (STRONG)..."
        echo ""
        echo "   TIPS:"
        echo "   • Press HOME key to toggle effects on/off"
        echo "   • Watch the texture - it should be MUCH sharper"
        echo "   • Look at the edges - they should be crisp"
        echo "   • Press Ctrl+C to stop"
        echo ""
        sleep 2
        vkcube
        ;;
    4)
        echo "🎮 Starting vkcube WITHOUT VulkanFX..."
        echo "   Compare with option 3 to see the difference"
        echo "   Press Ctrl+C to stop"
        echo ""
        unset ENABLE_VULKANFX
        vkcube
        ;;
    5)
        echo "🎮 Starting es2gears (slower rotation)..."
        echo "   Better for seeing details"
        echo "   Press Ctrl+C to stop"
        echo ""
        es2gears
        ;;
    *)
        echo "❌ Invalid choice!"
        exit 1
        ;;
esac
