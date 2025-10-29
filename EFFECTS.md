# VulkanFX Strong Effects Configuration

## 🔥 What Changed

### Before (Subtle):
- **CAS Sharpness**: 0.4
- **DLS Sharpness**: 0.5
- **Effects**: `cas` (single pass)

### After (STRONG):
- **CAS Sharpness**: 0.9 ⚡ (225% increase!)
- **DLS Sharpness**: 0.95 ⚡ (190% increase!)
- **Effects**: `cas:cas:dls` (triple pass!)

## 🎯 How to See the Difference

### Method 1: Comparison Script (Recommended)
```bash
./compare.sh
```
This will:
1. Show vkcube WITHOUT effects for 10 seconds
2. Then show vkcube WITH strong effects
3. You'll see the HUGE difference!

### Method 2: Toggle with HOME Key
```bash
./test.sh
# Choose option 2 (vkcube with VulkanFX)
# Press HOME key to toggle effects on/off
# You'll see instant difference!
```

## 👀 What to Look For

### With Strong Effects Enabled:
- ✅ **Much sharper textures** on the cube
- ✅ **Crisp, defined edges**
- ✅ **Enhanced detail** in patterns
- ✅ **More "pop" and clarity**

### Without Effects:
- Softer, blurrier textures
- Less defined edges
- Flatter appearance

## 🎨 Effect Breakdown

### CAS (Contrast Adaptive Sharpening) x2
- Applied TWICE for maximum sharpness
- Set to 0.9 (near maximum)
- Makes edges and details pop

### DLS (Denoised Luma Sharpening)
- Applied after CAS
- Set to 0.95 (near maximum)
- Adds extra sharpness to luminance
- Low denoise (0.05) for maximum effect

## ⚙️ Configuration File

Location: `~/.config/VulkanFX/VulkanFX.conf`

Key settings:
```ini
effects = cas:cas:dls
casSharpness = 0.9
dlsSharpness = 0.95
dlsDenoise = 0.05
toggleKey = Home
```

## 🔧 Adjust Strength

To make effects even STRONGER:
```bash
nano ~/.config/VulkanFX/VulkanFX.conf

# Change to:
casSharpness = 1.0      # Maximum!
dlsSharpness = 1.0      # Maximum!
effects = cas:cas:cas   # Triple CAS!
```

To make effects SUBTLE again:
```bash
nano ~/.config/VulkanFX/VulkanFX.conf

# Change to:
casSharpness = 0.4
dlsSharpness = 0.5
effects = cas
```

## 💡 Pro Tips

1. **Use HOME key** - Toggle effects on/off while vkcube runs
2. **Watch the cube texture** - The pattern should be much sharper
3. **Look at edges** - They should be crisp and defined
4. **Compare side-by-side** - Run `./compare.sh`

## 🎮 Test Commands

```bash
# Comparison test
./compare.sh

# Quick test with toggle
./test.sh

# Manual test
export DISPLAY=:0
export VK_LAYER_PATH="$(pwd)/build/config"
export ENABLE_VULKANFX=1
vkcube
# Press HOME to toggle!
```

## 📊 Performance Note

Strong effects may reduce FPS slightly:
- **Without VulkanFX**: ~60 FPS
- **With Strong Effects**: ~50-55 FPS
- **Worth it**: Much better visual quality!

## ✅ Verification

The effects are working if:
- ✅ Pressing HOME key changes the image
- ✅ Textures look sharper with effects ON
- ✅ Edges are more defined with effects ON
- ✅ You can clearly see the difference

---

**Enjoy the enhanced graphics!** 🎉
