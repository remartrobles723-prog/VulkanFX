#!/bin/bash

echo "=== Termux:X11 Setup for VulkanFX Testing ==="
echo ""

# Kill any existing processes
pkill -f com.termux.x11 2>/dev/null
pkill openbox 2>/dev/null
pkill aterm 2>/dev/null

# Set display
export DISPLAY=:0

# Set VulkanFX environment
export VK_LAYER_PATH="$(pwd)/build/config"
export ENABLE_VULKANFX=1

# Set Mesa environment for software rendering
export MESA_GL_VERSION_OVERRIDE=4.5
export MESA_GLSL_VERSION_OVERRIDE=450
export GALLIUM_DRIVER=llvmpipe

echo "Environment variables set:"
echo "  DISPLAY=$DISPLAY"
echo "  VK_LAYER_PATH=$VK_LAYER_PATH"
echo "  ENABLE_VULKANFX=$ENABLE_VULKANFX"
echo "  MESA_GL_VERSION_OVERRIDE=$MESA_GL_VERSION_OVERRIDE"
echo ""

echo "IMPORTANT: Make sure Termux:X11 app is installed and open!"
echo "Download from: https://github.com/termux/termux-x11/releases"
echo ""
echo "Press Enter when Termux:X11 app is open..."
read

# Start X11 server in background
echo "Starting Termux:X11 server..."
termux-x11 :0 -ac &
X11_PID=$!

sleep 3

echo "✓ Termux:X11 server started (PID: $X11_PID)"
echo ""

# Start window manager
echo "Starting Openbox window manager..."
openbox &
OPENBOX_PID=$!

sleep 2
echo "✓ Openbox started (PID: $OPENBOX_PID)"
echo ""

# Start a terminal
echo "Starting terminal (aterm)..."
aterm -geometry 80x24 -e bash &
ATERM_PID=$!

sleep 1
echo "✓ Terminal started (PID: $ATERM_PID)"
echo ""

echo "=== X11 Environment Ready! ==="
echo ""
echo "You should now see:"
echo "  - Termux:X11 app showing a desktop"
echo "  - A terminal window"
echo ""
echo "In the terminal, you can run:"
echo "  vkcube                    # Test Vulkan cube"
echo "  glxgears                  # Test OpenGL gears"
echo "  vulkaninfo | less         # Check Vulkan info"
echo ""
echo "Or from this Termux session:"
echo "  export DISPLAY=:0"
echo "  vkcube &"
echo ""
echo "To stop everything:"
echo "  pkill -f com.termux.x11"
echo "  pkill openbox"
echo "  pkill aterm"
echo ""
echo "PIDs for reference:"
echo "  X11: $X11_PID"
echo "  Openbox: $OPENBOX_PID"
echo "  Terminal: $ATERM_PID"
echo ""
