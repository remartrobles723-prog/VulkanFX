#!/bin/bash

clear
echo "╔════════════════════════════════════════════════════════════╗"
echo "║    VulkanFX Complete Test - X11 + VulkanFX                ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Kill any existing processes
pkill -f com.termux.x11 2>/dev/null
pkill openbox 2>/dev/null
sleep 1

# Set environment
export DISPLAY=:0
export ENABLE_VULKANFX=1
export MESA_GL_VERSION_OVERRIDE=4.5
export MESA_GLSL_VERSION_OVERRIDE=450
export GALLIUM_DRIVER=llvmpipe

# Create extreme config
cat > "$HOME/.config/VulkanFX/VulkanFX.conf" << 'EOF'
effects = cas:cas:cas:cas:cas
toggleKey = Home
enableOnLaunch = True
casSharpness = 1.0
EOF

echo "✅ VulkanFX layer installed and configured"
echo "✅ Extreme sharpening: 5x CAS at maximum"
echo ""
echo "📱 STEP 1: Open Termux:X11 app now!"
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

echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "🎮 Starting vkcube with VulkanFX..."
echo ""
echo "WHAT TO DO:"
echo "  1. Look at the Termux:X11 app - you'll see a rotating cube"
echo "  2. Press HOME key on your device"
echo "  3. Watch the cube texture - it should become MUCH sharper/softer"
echo ""
echo "WITH EFFECTS ON:"
echo "  ✅ VERY sharp, crisp texture"
echo "  ✅ Enhanced edges and details"
echo ""
echo "WITH EFFECTS OFF:"
echo "  ❌ Softer, blurrier texture"
echo ""
read -p "Press Enter to start vkcube..."

echo ""
echo "Starting vkcube..."
echo ""
echo "👉 Look at Termux:X11 app!"
echo "👉 Press HOME key to toggle effects!"
echo "👉 Press Ctrl+C here to stop"
echo ""

vkcube 2>&1 | grep -v "^$"

echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "Test finished!"
echo ""
echo "Did you see the cube texture change when pressing HOME?"
echo ""
echo "To stop X11:"
echo "  pkill -f com.termux.x11"
echo ""
