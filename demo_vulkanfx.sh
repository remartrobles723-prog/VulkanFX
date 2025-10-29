#!/bin/bash

echo "=== VulkanFX Demo ==="
echo ""

# Ensure environment is set
export DISPLAY=${DISPLAY:-:0}
export VK_LAYER_PATH="$(pwd)/build/config"
export ENABLE_VULKANFX=1

# Mesa settings for better compatibility
export MESA_GL_VERSION_OVERRIDE=4.5
export MESA_GLSL_VERSION_OVERRIDE=450

echo "Environment:"
echo "  DISPLAY: $DISPLAY"
echo "  VK_LAYER_PATH: $VK_LAYER_PATH"
echo "  ENABLE_VULKANFX: $ENABLE_VULKANFX"
echo ""

# Check if X11 is running
if ! xset q &>/dev/null; then
    echo "❌ X11 is not running!"
    echo "Please run: ./start_x11.sh first"
    exit 1
fi

echo "✓ X11 is running"
echo ""

# Menu
echo "Choose a demo:"
echo "  1) vkcube - Vulkan rotating cube (with VulkanFX)"
echo "  2) glxgears - OpenGL gears test"
echo "  3) vulkaninfo - Show Vulkan information"
echo "  4) vkcube (no VulkanFX) - Compare without effects"
echo "  5) Exit"
echo ""
read -p "Enter choice [1-5]: " choice

case $choice in
    1)
        echo ""
        echo "Starting vkcube with VulkanFX..."
        echo "Press Ctrl+C to stop"
        echo "Press Home key to toggle effects on/off"
        echo ""
        vkcube
        ;;
    2)
        echo ""
        echo "Starting glxgears..."
        echo "Press Ctrl+C to stop"
        echo ""
        glxgears
        ;;
    3)
        echo ""
        echo "Vulkan Information:"
        echo "==================="
        vulkaninfo | less
        ;;
    4)
        echo ""
        echo "Starting vkcube WITHOUT VulkanFX..."
        echo "Press Ctrl+C to stop"
        echo ""
        unset ENABLE_VULKANFX
        vkcube
        ;;
    5)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice!"
        exit 1
        ;;
esac
