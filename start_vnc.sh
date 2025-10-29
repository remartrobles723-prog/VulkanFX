#!/bin/bash

echo "=== Starting VNC Server for VulkanFX Testing ==="
echo ""

# Set display
export DISPLAY=:1

# Kill any existing VNC server
vncserver -kill :1 2>/dev/null

# Start VNC server
echo "Starting VNC server on display :1..."
vncserver :1 -geometry 1280x720 -depth 24

echo ""
echo "VNC server started!"
echo ""
echo "To connect:"
echo "  1. Install a VNC viewer on your device"
echo "  2. Connect to: localhost:5901"
echo "  3. Default password will be prompted on first run"
echo ""
echo "To test VulkanFX:"
echo "  export DISPLAY=:1"
echo "  export VK_LAYER_PATH=\"$(pwd)/build/config\""
echo "  export ENABLE_VULKANFX=1"
echo "  vulkaninfo | grep -i vulkanfx"
echo ""
echo "To stop VNC server:"
echo "  vncserver -kill :1"
echo ""
