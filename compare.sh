#!/bin/bash

# VulkanFX Comparison Script - Easy to see the difference!

clear
echo "╔════════════════════════════════════════════════════════════╗"
echo "║         VulkanFX Effect Comparison (Easy Mode)            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Set environment
export DISPLAY=:0
export VK_LAYER_PATH="$(pwd)/build/config"
export MESA_GL_VERSION_OVERRIDE=4.5
export MESA_GLSL_VERSION_OVERRIDE=450
export GALLIUM_DRIVER=llvmpipe

echo "This comparison uses FULLSCREEN for better viewing!"
echo ""
echo "STRONG EFFECTS ENABLED:"
echo "  ✓ CAS Sharpness: 0.9"
echo "  ✓ DLS Sharpness: 0.95"
echo "  ✓ Triple effect: cas:cas:dls"
echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""

echo "STEP 1: FULLSCREEN WITHOUT VulkanFX"
echo "        Watch the gears carefully"
echo ""
read -p "Press Enter to start FULLSCREEN test WITHOUT effects..."

echo ""
echo "🎮 Starting glxgears FULLSCREEN WITHOUT VulkanFX..."
echo "   Watch for 10 seconds..."
echo "   Press ESC to exit early"
echo ""
unset ENABLE_VULKANFX
glxgears -fullscreen &
GEARS_PID=$!

sleep 10

echo ""
echo "Stopping..."
kill $GEARS_PID 2>/dev/null
sleep 2

echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "STEP 2: FULLSCREEN WITH VulkanFX (STRONG EFFECTS)"
echo "        The gears should look MUCH SHARPER!"
echo ""
read -p "Press Enter to start FULLSCREEN test WITH strong effects..."

echo ""
echo "🎮 Starting glxgears FULLSCREEN WITH VulkanFX..."
echo ""
echo "   LOOK FOR:"
echo "   • Sharper gear teeth"
echo "   • Crisper edges"
echo "   • More defined details"
echo ""
echo "   Press HOME key to toggle effects on/off"
echo "   Press ESC or Ctrl+C to exit"
echo ""
export ENABLE_VULKANFX=1
glxgears -fullscreen

echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "Did you see the difference?"
echo ""
echo "TIP: Run this again and press HOME key during step 2"
echo "     to toggle effects on/off and see instant difference!"
echo ""
echo "For slower rotation: ./test.sh and choose option 5 (es2gears)"
echo ""
