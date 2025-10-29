#!/bin/bash

# Easy VulkanFX Comparison - With ReShade Daltonize Effect!

clear
echo "╔════════════════════════════════════════════════════════════╗"
echo "║    VulkanFX with ReShade - VERY VISIBLE COLOR CHANGE!     ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Set environment - IMPORTANT: Use default variant for ReShade support!
export DISPLAY=:0
export VK_LAYER_PATH="$(pwd)/build/config"
export ENABLE_VULKANFX=1  # Use "1" for default variant with ReShade
export MESA_GL_VERSION_OVERRIDE=4.5
export MESA_GLSL_VERSION_OVERRIDE=450
export GALLIUM_DRIVER=llvmpipe

echo "🎨 RESHADE DALTONIZE EFFECT ENABLED!"
echo ""
echo "   This effect changes COLORS dramatically!"
echo "   You'll see the difference IMMEDIATELY!"
echo ""
echo "WHAT WILL HAPPEN:"
echo "   • Colors will shift (simulates color blindness)"
echo "   • Press HOME key to toggle effect on/off"
echo "   • You'll see INSTANT color changes!"
echo ""
echo "CONTROLS:"
echo "   • HOME key = Toggle effect on/off (WATCH THE COLORS!)"
echo "   • ESC key = Exit fullscreen"
echo "   • Ctrl+C = Stop"
echo ""
read -p "Press Enter to start FULLSCREEN test with ReShade..."

echo ""
echo "🎮 Starting glxgears FULLSCREEN with ReShade Daltonize..."
echo ""
echo "   👉 Press HOME key and watch the COLORS CHANGE!"
echo "   👉 The gears will change color when you toggle!"
echo ""
sleep 2

glxgears -fullscreen

echo ""
echo "Test finished!"
echo ""
echo "Did you see the colors change when pressing HOME?"
echo ""
echo "If not, make sure you're using the DEFAULT variant:"
echo "  export ENABLE_VULKANFX=1"
echo ""
echo "Run again: ./easy_compare.sh"
echo ""
