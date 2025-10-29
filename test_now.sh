#!/bin/bash

clear
echo "╔════════════════════════════════════════════════════════════╗"
echo "║    VulkanFX Test - Layer Now Properly Installed!          ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

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

echo "✅ VulkanFX layer installed to:"
echo "   ~/.local/share/vulkan/implicit_layer.d/VulkanFX.json"
echo ""
echo "✅ Config set to EXTREME:"
echo "   - 5x CAS passes"
echo "   - Maximum sharpness (1.0)"
echo ""
echo "✅ Old vkBasalt layer disabled"
echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "🎮 Starting vkcube (Vulkan application)"
echo ""
echo "WHAT TO DO:"
echo "  1. Watch the rotating cube"
echo "  2. Press HOME key to toggle effects"
echo "  3. You should see the texture become MUCH sharper/softer"
echo ""
echo "If it works, the cube will look VERY sharp with effects ON"
echo "and softer/blurrier with effects OFF"
echo ""
read -p "Press Enter to start vkcube..."

echo ""
echo "Starting vkcube..."
echo "👉 Press HOME key to toggle effects!"
echo "👉 Press Ctrl+C to stop"
echo ""

vkcube

echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "Did you see a difference when pressing HOME?"
echo ""
echo "If YES: 🎉 VulkanFX is working!"
echo "If NO: Run ./diagnose.sh again to check"
echo ""
