#!/bin/bash

clear
echo "╔════════════════════════════════════════════════════════════╗"
echo "║         VulkanFX Test - All-in-One Script                 ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Kill any existing processes
pkill -f com.termux.x11 2>/dev/null
pkill openbox 2>/dev/null
pkill aterm 2>/dev/null
sleep 1

# Set all environment variables
export DISPLAY=:0
export VK_LAYER_PATH="$(pwd)/build/config"
export ENABLE_VULKANFX=1
export MESA_GL_VERSION_OVERRIDE=4.5
export MESA_GLSL_VERSION_OVERRIDE=450
export GALLIUM_DRIVER=llvmpipe

echo "📱 STEP 1: Install Termux:X11 App"
echo "   Download from: https://github.com/termux/termux-x11/releases"
echo ""
echo "🚀 STEP 2: Open the Termux:X11 app now!"
echo ""
read -p "Press Enter when Termux:X11 app is open..."

echo ""
echo "⚙️  Starting X11 server..."
termux-x11 :0 -ac >/dev/null 2>&1 &
X11_PID=$!
sleep 4

echo "✅ X11 server started (PID: $X11_PID)"

echo "⚙️  Starting window manager..."
openbox >/dev/null 2>&1 &
sleep 2
echo "✅ Openbox running"

echo "⚙️  Starting terminal..."
aterm -geometry 80x24 >/dev/null 2>&1 &
sleep 2
echo "✅ Terminal ready"

echo ""
echo "You should now see a desktop with a terminal in Termux:X11 app"
echo ""
sleep 1

echo "╔════════════════════════════════════════════════════════════╗"
echo "║                    Choose a Test                          ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "  1) glxgears      - OpenGL test (simple, fast)"
echo "  2) vkcube        - Vulkan test WITH VulkanFX"
echo "  3) vkcube        - Vulkan test WITHOUT VulkanFX (compare)"
echo "  4) vulkaninfo    - Show Vulkan information"
echo "  5) Exit"
echo ""
read -p "Enter choice [1-5]: " choice

echo ""
case $choice in
    1)
        echo "🎮 Starting glxgears..."
        echo "   You should see rotating gears in Termux:X11 app"
        echo "   Press Ctrl+C to stop"
        echo ""
        sleep 2
        glxgears
        ;;
    2)
        echo "🎮 Starting vkcube WITH VulkanFX..."
        echo "   You should see a rotating cube with sharpening"
        echo "   Press HOME key to toggle effects on/off"
        echo "   Press Ctrl+C to stop"
        echo ""
        sleep 2
        vkcube
        ;;
    3)
        echo "🎮 Starting vkcube WITHOUT VulkanFX..."
        echo "   Compare with option 2 to see the difference"
        echo "   Press Ctrl+C to stop"
        echo ""
        unset ENABLE_VULKANFX
        sleep 2
        vkcube
        ;;
    4)
        echo "📊 Vulkan Information:"
        echo "====================="
        vulkaninfo | less
        ;;
    5)
        echo "👋 Exiting..."
        echo ""
        echo "To stop X11:"
        echo "  pkill -f com.termux.x11"
        exit 0
        ;;
    *)
        echo "❌ Invalid choice!"
        exit 1
        ;;
esac

echo ""
echo "Test finished!"
echo ""
echo "To run another test: ./run_test.sh"
echo "To stop X11: pkill -f com.termux.x11"
