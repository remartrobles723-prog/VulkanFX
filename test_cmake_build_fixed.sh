#!/bin/bash

echo "╔════════════════════════════════════════════════════════════╗"
echo "║    Testing CMake-Built VulkanFX Libraries (CORRECTED)    ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check if CMake libraries exist
if [ ! -f "build_cmake/libVkLayer_VulkanFX_default.so" ]; then
    echo "❌ CMake libraries not found in build_cmake/"
    echo ""
    echo "Please build with CMake first:"
    echo "  mkdir -p build_cmake && cd build_cmake"
    echo "  cmake .."
    echo "  make -j$(nproc)"
    exit 1
fi

echo "✓ CMake-built libraries found in build_cmake/"
echo ""
echo "Library sizes:"
ls -lh build_cmake/libVkLayer_VulkanFX_*.so | awk '{print "  " $9 ": " $5}'
echo ""
echo "ReShade libraries:"
ls -lh build_cmake/subprojects/reshade/libReShadeFX*.so.*.*.* 2>/dev/null | awk '{print "  " $9 ": " $5}'
echo ""

# Check if layer config exists
if [ ! -f "build_cmake/config/VulkanFX.json" ]; then
    echo "⚠️  Layer configuration not found, creating it..."
    mkdir -p build_cmake/config
    # Config will be created by the script
fi

echo "═══════════════════════════════════════════════════════════"
echo ""
echo "Setting up environment for CMAKE build..."
echo ""

# Set VK_LAYER_PATH to CMAKE build config
export VK_LAYER_PATH="$PWD/build_cmake/config"
echo "✓ VK_LAYER_PATH=$VK_LAYER_PATH"

# Set LD_LIBRARY_PATH to find ReShade libraries in CMAKE build
export LD_LIBRARY_PATH="$PWD/build_cmake/subprojects/reshade:$LD_LIBRARY_PATH"
echo "✓ LD_LIBRARY_PATH includes build_cmake/subprojects/reshade"

# Set DISPLAY
export DISPLAY=:0
echo "✓ DISPLAY=$DISPLAY"

# Enable VulkanFX
export ENABLE_VULKANFX=1
echo "✓ ENABLE_VULKANFX=$ENABLE_VULKANFX"

# Mesa settings for software rendering
export MESA_GL_VERSION_OVERRIDE=4.5
export MESA_GLSL_VERSION_OVERRIDE=450
export GALLIUM_DRIVER=llvmpipe

echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "Available ReShade effects in fx/Shaders:"
echo ""
ls -1 fx/Shaders/*.fx 2>/dev/null | while read file; do
    basename "$file"
done
echo ""

echo "Choose a ReShade effect to test:"
echo ""
echo "  1) Daltonize    - Color shift (simulates color blindness)"
echo "  2) Deband       - Reduces color banding"
echo "  3) DisplayDepth - Shows depth buffer"
echo "  4) CAS only     - Just sharpening (no ReShade)"
echo "  5) CAS + Daltonize - Sharpening + color shift"
echo ""
read -p "Enter choice [1-5]: " choice

case $choice in
    1)
        echo "Setting up Daltonize (color shift)..."
        cat > "$HOME/.config/VulkanFX/VulkanFX.conf" << 'EOF'
effects = Daltonize
Daltonize = /data/data/com.termux/files/home/VulkanFX/fx/Shaders/Daltonize.fx
reshadeTexturePath = /data/data/com.termux/files/home/VulkanFX/fx/Textures
reshadeIncludePath = /data/data/com.termux/files/home/VulkanFX/fx/Shaders
toggleKey = Home
enableOnLaunch = True
depthCapture = off
EOF
        echo "✓ Daltonize effect enabled"
        echo "  Colors will shift dramatically!"
        ;;
    2)
        echo "Setting up Deband (color banding reduction)..."
        cat > "$HOME/.config/VulkanFX/VulkanFX.conf" << 'EOF'
effects = Deband
Deband = /data/data/com.termux/files/home/VulkanFX/fx/Shaders/Deband.fx
reshadeTexturePath = /data/data/com.termux/files/home/VulkanFX/fx/Textures
reshadeIncludePath = /data/data/com.termux/files/home/VulkanFX/fx/Shaders
toggleKey = Home
enableOnLaunch = True
depthCapture = off
EOF
        echo "✓ Deband effect enabled"
        echo "  Smoother color gradients!"
        ;;
    3)
        echo "Setting up DisplayDepth (depth visualization)..."
        # Use depth layer variant
        export ENABLE_VULKANFX=depth
        cat > "$HOME/.config/VulkanFX/VulkanFX.conf" << 'EOF'
effects = DisplayDepth
DisplayDepth = /data/data/com.termux/files/home/VulkanFX/fx/Shaders/DisplayDepth.fx
reshadeTexturePath = /data/data/com.termux/files/home/VulkanFX/fx/Textures
reshadeIncludePath = /data/data/com.termux/files/home/VulkanFX/fx/Shaders
toggleKey = Home
enableOnLaunch = True
depthCapture = on
EOF
        echo "✓ DisplayDepth effect enabled"
        echo "  Shows depth buffer (black/white)!"
        echo "  Using depth layer variant (ENABLE_VULKANFX=depth)"
        ;;
    4)
        echo "Setting up CAS only (no ReShade)..."
        cat > "$HOME/.config/VulkanFX/VulkanFX.conf" << 'EOF'
effects = cas:cas:cas
toggleKey = Home
enableOnLaunch = True
casSharpness = 1.0
depthCapture = off
EOF
        echo "✓ CAS sharpening enabled (3x passes)"
        ;;
    5)
        echo "Setting up CAS + Daltonize combo..."
        cat > "$HOME/.config/VulkanFX/VulkanFX.conf" << 'EOF'
effects = cas:Daltonize
Daltonize = /data/data/com.termux/files/home/VulkanFX/fx/Shaders/Daltonize.fx
reshadeTexturePath = /data/data/com.termux/files/home/VulkanFX/fx/Textures
reshadeIncludePath = /data/data/com.termux/files/home/VulkanFX/fx/Shaders
toggleKey = Home
enableOnLaunch = True
casSharpness = 0.8
depthCapture = off
EOF
        echo "✓ CAS + Daltonize combo enabled"
        echo "  Sharp AND color shifted!"
        ;;
    *)
        echo "Invalid choice!"
        exit 1
        ;;
esac

echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "🎮 Starting vkcube with CMAKE-built VulkanFX layer..."
echo ""
echo "IMPORTANT: Using CMAKE build from build_cmake/"
echo "           NOT the Meson build from build/src/"
echo ""
echo "CONTROLS:"
echo "  • Press HOME key to toggle effects on/off"
echo "  • Press Ctrl+C to stop"
echo ""
echo "Look at Termux:X11 app to see the effect!"
echo ""

# Check if X11 is running
if [ -z "$DISPLAY" ] || ! xset q &>/dev/null; then
    echo "⚠️  WARNING: X11 display server not detected!"
    echo ""
    echo "To start X11:"
    echo "  1. Open Termux:X11 app"
    echo "  2. Run: ./start_x11.sh"
    echo ""
    echo "Attempting to run vkcube anyway..."
    echo ""
fi

sleep 2

vkcube

echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "Test finished!"
echo ""
echo "To try another effect, run: ./test_cmake_build_fixed.sh"
echo ""
