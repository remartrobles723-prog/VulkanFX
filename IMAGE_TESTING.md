# VulkanFX Image Testing Guide

## 📸 Testing VulkanFX Effects on Images

Yes! You can test VulkanFX effects on images to see the difference clearly!

## 🚀 Quick Start

### Method 1: Automatic Screenshot Comparison (Recommended)

```bash
./capture_comparison.sh
```

This will:
1. ✅ Capture vkcube **WITHOUT** VulkanFX
2. ✅ Capture vkcube **WITH** CAS 5x sharpening
3. ✅ Capture vkcube **WITH** Daltonize effect
4. ✅ Create side-by-side comparisons
5. ✅ Create labeled comparison grid

**Output**: `~/vulkanfx_screenshots/09_final_comparison.png`

### Method 2: Test Effects on Any Image

```bash
./test_image.sh
```

Choose from:
- Download sample image
- Use your own image
- Capture from vkcube

## 📊 What You'll Get

### Screenshot Comparison Output

```
~/vulkanfx_screenshots/
├── 01_without_vulkanfx.png      # Original (no effects)
├── 02_with_cas_5x.png            # With CAS sharpening
├── 03_with_daltonize.png         # With color shift
├── 04_comparison_cas.png         # Side-by-side CAS
├── 05_comparison_daltonize.png   # Side-by-side Daltonize
├── 06_labeled_without.png        # Labeled original
├── 07_labeled_with_cas.png       # Labeled CAS
├── 08_labeled_daltonize.png      # Labeled Daltonize
└── 09_final_comparison.png       # Complete grid ⭐
```

### Image Effect Simulation Output

```
/tmp/vulkanfx_test/
├── 01_original.jpg          # Original image
├── 02_cas_light.jpg         # Light sharpening
├── 03_cas_strong.jpg        # Strong sharpening
├── 04_daltonize_sim.jpg     # Color shift simulation
├── 05_deband_sim.jpg        # Deband simulation
├── 06_fxaa_sim.jpg          # Anti-aliasing
├── 07_combined.jpg          # Combined effects
└── 08_extreme.jpg           # Extreme sharpening
```

## 👀 How to View Results

### On Device

```bash
# View final comparison
termux-open ~/vulkanfx_screenshots/09_final_comparison.png

# View in gallery
cp ~/vulkanfx_screenshots/*.png ~/storage/pictures/

# Share via apps
termux-share ~/vulkanfx_screenshots/09_final_comparison.png
```

### Transfer to PC

```bash
# Via termux-send-file (if available)
termux-send-file ~/vulkanfx_screenshots/09_final_comparison.png

# Or copy to shared storage
cp ~/vulkanfx_screenshots/*.png ~/storage/downloads/
```

## 🎨 Manual Screenshot Capture

### Capture Specific Effect

```bash
# 1. Configure effect
nano ~/.config/VulkanFX/VulkanFX.conf

# 2. Start vkcube
export DISPLAY=:0
export ENABLE_VULKANFX=1
vkcube &

# 3. Wait a moment
sleep 5

# 4. Take screenshot
scrot ~/my_screenshot.png

# 5. Stop vkcube
pkill vkcube
```

### Compare Different Effects

```bash
# Capture with CAS
echo "effects = cas:cas:cas" > ~/.config/VulkanFX/VulkanFX.conf
vkcube & sleep 5; scrot ~/cas.png; pkill vkcube

# Capture with Daltonize
echo "effects = Daltonize" > ~/.config/VulkanFX/VulkanFX.conf
echo "Daltonize = /path/to/Daltonize.fx" >> ~/.config/VulkanFX/VulkanFX.conf
vkcube & sleep 5; scrot ~/daltonize.png; pkill vkcube

# Create comparison
convert ~/cas.png ~/daltonize.png +append ~/comparison.png
```

## 🔧 Advanced: Custom Comparisons

### Create Your Own Comparison Grid

```bash
# Capture multiple effects
for effect in "cas" "cas:cas:cas" "Daltonize" "Deband"; do
    # Configure
    echo "effects = $effect" > ~/.config/VulkanFX/VulkanFX.conf
    
    # Capture
    vkcube & sleep 5
    scrot ~/effect_$effect.png
    pkill vkcube
    sleep 2
done

# Create grid
convert ~/effect_*.png -append ~/all_effects.png
```

### Zoom In on Details

```bash
# Capture high-res
scrot -q 100 ~/highres.png

# Crop specific area
convert ~/highres.png -crop 400x400+200+200 ~/detail.png

# Compare details
convert ~/detail_without.png ~/detail_with.png +append ~/detail_comparison.png
```

## 📝 Effect Visibility in Images

| Effect | Visibility | Best For |
|--------|-----------|----------|
| **CAS 5x** | ⭐⭐⭐⭐⭐ | Textures, edges |
| **Daltonize** | ⭐⭐⭐⭐⭐ | Colors (very obvious) |
| **Deband** | ⭐⭐⭐ | Gradients, sky |
| **FXAA** | ⭐⭐ | Jagged edges |
| **DisplayDepth** | ⭐⭐⭐⭐⭐ | Depth visualization |

## 💡 Tips for Best Results

### 1. Use High Contrast Scenes
- Textured objects (like the cube)
- Sharp edges
- Varied colors

### 2. Capture at Same Moment
- Use consistent timing
- Same cube rotation
- Same lighting

### 3. Compare Side-by-Side
- Use `+append` for horizontal
- Use `-append` for vertical
- Add labels for clarity

### 4. Focus on Details
- Zoom in on textures
- Look at edges
- Check color shifts

## 🎯 What to Look For

### CAS Sharpening
- **Sharper edges** on cube
- **Enhanced texture** details
- **Crisper patterns**

### Daltonize
- **Color shift** (reds → browns)
- **Different hues**
- **Very obvious change**

### Deband
- **Smoother gradients**
- **Less color banding**
- **Subtle but effective**

## 📦 Dependencies

The scripts will auto-install:
- `scrot` - Screenshot tool
- `imagemagick` - Image processing

Or install manually:
```bash
pkg install scrot imagemagick
```

## 🔄 Workflow Example

```bash
# 1. Capture comparisons
./capture_comparison.sh

# 2. View results
termux-open ~/vulkanfx_screenshots/09_final_comparison.png

# 3. Copy to gallery
cp ~/vulkanfx_screenshots/*.png ~/storage/pictures/

# 4. Share
termux-share ~/vulkanfx_screenshots/09_final_comparison.png
```

## 🎨 Example Comparison

```
┌─────────────────┬─────────────────┐
│  WITHOUT        │  WITH CAS 5x    │
│  VulkanFX       │  (Sharp!)       │
│                 │                 │
│  [Soft cube]    │  [Sharp cube]   │
│                 │                 │
└─────────────────┴─────────────────┘
┌─────────────────┬─────────────────┐
│  WITHOUT        │  WITH Daltonize │
│  VulkanFX       │  (Color shift!) │
│                 │                 │
│  [Normal]       │  [Different]    │
│                 │                 │
└─────────────────┴─────────────────┘
```

## ✅ Success Checklist

- [ ] Run `./capture_comparison.sh`
- [ ] Check `~/vulkanfx_screenshots/` folder
- [ ] View `09_final_comparison.png`
- [ ] See clear difference between images
- [ ] Copy to gallery or share

---

**Ready to test!** 📸

Run: `./capture_comparison.sh` and see VulkanFX effects in pictures!
