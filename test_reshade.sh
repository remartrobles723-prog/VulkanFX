#!/bin/bash

clear
echo "╔════════════════════════════════════════════════════════════╗"
echo "║         VulkanFX ReShade Effects Test                     ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Set environment
export DISPLAY=:0
export ENABLE_VULKANFX=1
export MESA_GL_VERSION_OVERRIDE=4.5
export MESA_GLSL_VERSION_OVERRIDE=450
export GALLIUM_DRIVER=llvmpipe

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
echo "🎮 Starting vkcube with selected effect..."
echo ""
echo "CONTROLS:"
echo "  • Press HOME key to toggle effects on/off"
echo "  • Press Ctrl+C to stop"
echo ""
echo "Look at Termux:X11 app to see the effect!"
echo ""
sleep 2

vkcube

echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "Test finished!"
echo ""
echo "To try another effect, run: ./test_reshade.sh"
echo ""
