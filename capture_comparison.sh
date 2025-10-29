#!/bin/bash

clear
echo "╔════════════════════════════════════════════════════════════╗"
echo "║    VulkanFX Screenshot Comparison Tool                    ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check dependencies
if ! command -v scrot &> /dev/null; then
    echo "Installing scrot for screenshots..."
    pkg install -y scrot
fi

if ! command -v magick &> /dev/null; then
    echo "Installing ImageMagick..."
    pkg install -y imagemagick
fi

# Set environment
export DISPLAY=:0
export MESA_GL_VERSION_OVERRIDE=4.5
export MESA_GLSL_VERSION_OVERRIDE=450
export GALLIUM_DRIVER=llvmpipe

# Create output directory
OUTPUT_DIR="$HOME/vulkanfx_screenshots"
mkdir -p "$OUTPUT_DIR"

echo "This will capture vkcube with and without VulkanFX effects"
echo ""
echo "Output directory: $OUTPUT_DIR"
echo ""

# Capture WITHOUT VulkanFX
echo "═══════════════════════════════════════════════════════════"
echo "STEP 1: Capturing WITHOUT VulkanFX..."
echo "═══════════════════════════════════════════════════════════"
echo ""

# Disable VulkanFX
cat > "$HOME/.config/VulkanFX/VulkanFX.conf" << 'EOF'
effects = cas
toggleKey = Home
enableOnLaunch = False
casSharpness = 1.0
EOF

echo "Starting vkcube (no effects)..."
export ENABLE_VULKANFX=1
vkcube &
VKCUBE_PID=$!

echo "Waiting for vkcube to start..."
sleep 5

echo "Taking screenshot..."
scrot "$OUTPUT_DIR/01_without_vulkanfx.png"
echo "✓ Captured: 01_without_vulkanfx.png"

kill $VKCUBE_PID 2>/dev/null
sleep 2

# Capture WITH VulkanFX (CAS)
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "STEP 2: Capturing WITH VulkanFX (CAS 5x)..."
echo "═══════════════════════════════════════════════════════════"
echo ""

# Enable VulkanFX with strong effects
cat > "$HOME/.config/VulkanFX/VulkanFX.conf" << 'EOF'
effects = cas:cas:cas:cas:cas
toggleKey = Home
enableOnLaunch = True
casSharpness = 1.0
EOF

echo "Starting vkcube (with CAS 5x)..."
vkcube &
VKCUBE_PID=$!

echo "Waiting for vkcube to start..."
sleep 5

echo "Taking screenshot..."
scrot "$OUTPUT_DIR/02_with_cas_5x.png"
echo "✓ Captured: 02_with_cas_5x.png"

kill $VKCUBE_PID 2>/dev/null
sleep 2

# Capture WITH ReShade Daltonize
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "STEP 3: Capturing WITH ReShade (Daltonize)..."
echo "═══════════════════════════════════════════════════════════"
echo ""

# Enable Daltonize
cat > "$HOME/.config/VulkanFX/VulkanFX.conf" << 'EOF'
effects = Daltonize
Daltonize = /data/data/com.termux/files/home/VulkanFX/fx/Shaders/Daltonize.fx
reshadeTexturePath = /data/data/com.termux/files/home/VulkanFX/fx/Textures
reshadeIncludePath = /data/data/com.termux/files/home/VulkanFX/fx/Shaders
toggleKey = Home
enableOnLaunch = True
EOF

echo "Starting vkcube (with Daltonize)..."
vkcube &
VKCUBE_PID=$!

echo "Waiting for vkcube to start..."
sleep 5

echo "Taking screenshot..."
scrot "$OUTPUT_DIR/03_with_daltonize.png"
echo "✓ Captured: 03_with_daltonize.png"

kill $VKCUBE_PID 2>/dev/null
sleep 2

# Create comparison image
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "Creating comparison image..."
echo "═══════════════════════════════════════════════════════════"
echo ""

# Create side-by-side comparison
magick "$OUTPUT_DIR/01_without_vulkanfx.png" "$OUTPUT_DIR/02_with_cas_5x.png" +append "$OUTPUT_DIR/04_comparison_cas.png"
echo "✓ Created: 04_comparison_cas.png (side-by-side)"

magick "$OUTPUT_DIR/01_without_vulkanfx.png" "$OUTPUT_DIR/03_with_daltonize.png" +append "$OUTPUT_DIR/05_comparison_daltonize.png"
echo "✓ Created: 05_comparison_daltonize.png (side-by-side)"

# Create labeled comparison
magick "$OUTPUT_DIR/01_without_vulkanfx.png" -gravity North -pointsize 30 -fill red -annotate +0+10 "WITHOUT VulkanFX" "$OUTPUT_DIR/06_labeled_without.png"
magick "$OUTPUT_DIR/02_with_cas_5x.png" -gravity North -pointsize 30 -fill green -annotate +0+10 "WITH CAS 5x" "$OUTPUT_DIR/07_labeled_with_cas.png"
magick "$OUTPUT_DIR/03_with_daltonize.png" -gravity North -pointsize 30 -fill blue -annotate +0+10 "WITH Daltonize" "$OUTPUT_DIR/08_labeled_daltonize.png"

echo "✓ Created labeled versions"

# Create final comparison grid
magick \( "$OUTPUT_DIR/06_labeled_without.png" "$OUTPUT_DIR/07_labeled_with_cas.png" +append \) \
        \( "$OUTPUT_DIR/06_labeled_without.png" "$OUTPUT_DIR/08_labeled_daltonize.png" +append \) \
        -append "$OUTPUT_DIR/09_final_comparison.png"
echo "✓ Created: 09_final_comparison.png (grid)"

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "✅ All screenshots captured!"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "Output directory: $OUTPUT_DIR"
echo ""
echo "Files created:"
ls -lh "$OUTPUT_DIR"
echo ""
echo "To view:"
echo "  termux-open $OUTPUT_DIR/09_final_comparison.png"
echo ""
echo "To copy to gallery:"
echo "  cp $OUTPUT_DIR/*.png ~/storage/pictures/"
echo ""
echo "To share:"
echo "  termux-share $OUTPUT_DIR/09_final_comparison.png"
echo ""
