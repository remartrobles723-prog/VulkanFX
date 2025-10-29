#!/bin/bash

clear
echo "╔════════════════════════════════════════════════════════════╗"
echo "║         VulkanFX Image Effect Tester                      ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check if ImageMagick is installed
if ! command -v magick &> /dev/null; then
    echo "Installing ImageMagick..."
    pkg install -y imagemagick
fi

# Use proper directories
TEMP_DIR="$HOME/.cache/vulkanfx"
OUTPUT_DIR="$HOME/vulkanfx_images"
mkdir -p "$TEMP_DIR"
mkdir -p "$OUTPUT_DIR"

echo "This tool simulates VulkanFX effects on images"
echo ""
echo "Choose an option:"
echo ""
echo "  1) Test with sample image (download)"
echo "  2) Use your own image"
echo "  3) Take screenshot from vkcube"
echo ""
read -p "Enter choice [1-3]: " choice

case $choice in
    1)
        echo ""
        echo "Downloading sample image..."
        curl -o "$TEMP_DIR/test_image.jpg" "https://picsum.photos/800/600" 2>/dev/null
        if [ $? -ne 0 ]; then
            echo "Download failed, using alternative..."
            curl -o "$TEMP_DIR/test_image.jpg" "https://via.placeholder.com/800x600" 2>/dev/null
        fi
        INPUT_IMAGE="$TEMP_DIR/test_image.jpg"
        ;;
    2)
        echo ""
        read -p "Enter image path: " INPUT_IMAGE
        if [ ! -f "$INPUT_IMAGE" ]; then
            echo "❌ File not found!"
            exit 1
        fi
        ;;
    3)
        echo ""
        echo "Starting vkcube for screenshot..."
        echo "Press Ctrl+C after a few seconds to capture"
        export DISPLAY=:0
        export ENABLE_VULKANFX=1
        vkcube &
        VKCUBE_PID=$!
        sleep 3
        
        # Take screenshot
        if command -v scrot &> /dev/null; then
            scrot "$TEMP_DIR/vkcube_screenshot.png"
        elif command -v import &> /dev/null; then
            import -window root "$TEMP_DIR/vkcube_screenshot.png"
        else
            echo "Installing scrot for screenshots..."
            pkg install -y scrot
            scrot "$TEMP_DIR/vkcube_screenshot.png"
        fi
        
        kill $VKCUBE_PID 2>/dev/null
        INPUT_IMAGE="$TEMP_DIR/vkcube_screenshot.png"
        ;;
    *)
        echo "Invalid choice!"
        exit 1
        ;;
esac

if [ ! -f "$INPUT_IMAGE" ]; then
    echo "❌ Input image not found: $INPUT_IMAGE"
    exit 1
fi

echo ""
echo "✓ Input image: $INPUT_IMAGE"
echo ""

# Apply different effects
echo "Applying effects..."
echo ""

# 1. Original
cp "$INPUT_IMAGE" "$OUTPUT_DIR/01_original.jpg"
echo "✓ 01_original.jpg"

# 2. CAS (Contrast Adaptive Sharpening) simulation
magick "$INPUT_IMAGE" -sharpen 0x2 "$OUTPUT_DIR/02_cas_light.jpg"
echo "✓ 02_cas_light.jpg (CAS light)"

magick "$INPUT_IMAGE" -sharpen 0x4 "$OUTPUT_DIR/03_cas_strong.jpg"
echo "✓ 03_cas_strong.jpg (CAS strong)"

# 3. Daltonize (color shift) simulation
magick "$INPUT_IMAGE" -modulate 100,150,100 "$OUTPUT_DIR/04_daltonize_sim.jpg"
echo "✓ 04_daltonize_sim.jpg (Color shift)"

# 4. Deband simulation (smooth gradients)
magick "$INPUT_IMAGE" -blur 0x0.5 -sharpen 0x0.5 "$OUTPUT_DIR/05_deband_sim.jpg"
echo "✓ 05_deband_sim.jpg (Deband)"

# 5. FXAA simulation (anti-aliasing)
magick "$INPUT_IMAGE" -blur 0x0.3 "$OUTPUT_DIR/06_fxaa_sim.jpg"
echo "✓ 06_fxaa_sim.jpg (FXAA)"

# 6. Combined effects
magick "$INPUT_IMAGE" -sharpen 0x3 -modulate 100,120,100 "$OUTPUT_DIR/07_combined.jpg"
echo "✓ 07_combined.jpg (CAS + Color)"

# 7. Extreme sharpening (like 5x CAS)
magick "$INPUT_IMAGE" -sharpen 0x5 -enhance "$OUTPUT_DIR/08_extreme.jpg"
echo "✓ 08_extreme.jpg (Extreme)"

# 8. Create comparison
magick "$OUTPUT_DIR/01_original.jpg" "$OUTPUT_DIR/03_cas_strong.jpg" +append "$OUTPUT_DIR/09_comparison.jpg"
echo "✓ 09_comparison.jpg (Side-by-side)"

echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "✅ All effects applied!"
echo ""
echo "Output directory: $OUTPUT_DIR"
echo ""
echo "Files created:"
ls -lh "$OUTPUT_DIR"
echo ""
echo "To view images:"
echo "  termux-open $OUTPUT_DIR/01_original.jpg"
echo "  termux-open $OUTPUT_DIR/03_cas_strong.jpg"
echo "  termux-open $OUTPUT_DIR/09_comparison.jpg"
echo ""
echo "Or copy to storage:"
echo "  cp $OUTPUT_DIR/* ~/storage/pictures/"
echo ""
