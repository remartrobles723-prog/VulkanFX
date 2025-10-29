# VulkanFX ReShade Effects Guide

## 🎨 ReShade Effects Available

Your `fx/Shaders/` folder contains these effects:

### 1. **Daltonize.fx** ⭐ (Most Visible!)
- **What it does**: Simulates color blindness
- **Effect**: Dramatically shifts colors
- **Visibility**: VERY HIGH - colors change completely!
- **Best for**: Testing if ReShade is working

### 2. **Deband.fx**
- **What it does**: Reduces color banding
- **Effect**: Smoother color gradients
- **Visibility**: Medium - subtle but noticeable
- **Best for**: Improving image quality

### 3. **DisplayDepth.fx**
- **What it does**: Visualizes depth buffer
- **Effect**: Shows scene in black/white based on depth
- **Visibility**: VERY HIGH - completely changes view!
- **Requires**: `depthCapture = on`

### 4. **LUT.fx**
- **What it does**: Color grading via lookup table
- **Effect**: Changes color palette
- **Visibility**: High (if LUT file exists)
- **Requires**: LUT texture file

## 🚀 Quick Test

```bash
./test_reshade.sh
```

This script lets you choose which effect to test!

## 🎮 Manual Testing

### Test Daltonize (Recommended First):
```bash
# Edit config
nano ~/.config/VulkanFX/VulkanFX.conf

# Set this:
effects = reshade(Daltonize.fx)
reshadeTexturePath = "/data/data/com.termux/files/home/VulkanFX/fx/Textures"
reshadeIncludePath = "/data/data/com.termux/files/home/VulkanFX/fx/Shaders"
toggleKey = Home
enableOnLaunch = True

# Then run:
export DISPLAY=:0
export ENABLE_VULKANFX=1
vkcube
```

**Press HOME key** - colors will shift dramatically!

### Test Deband:
```bash
effects = reshade(Deband.fx)
```

### Test DisplayDepth:
```bash
effects = reshade(DisplayDepth.fx)
depthCapture = on
```

## 🎨 Combining Effects

You can combine ReShade with built-in effects:

```ini
# Sharpening + Color shift
effects = cas:reshade(Daltonize.fx)

# Sharpening + Deband
effects = cas:reshade(Deband.fx)

# Multiple ReShade effects
effects = reshade(Deband.fx):reshade(Daltonize.fx)
```

## 📊 Effect Comparison

| Effect | Visibility | Performance Impact | Best Use |
|--------|-----------|-------------------|----------|
| Daltonize | ⭐⭐⭐⭐⭐ | Low | Testing |
| DisplayDepth | ⭐⭐⭐⭐⭐ | Low | Debugging |
| Deband | ⭐⭐⭐ | Medium | Quality |
| LUT | ⭐⭐⭐⭐ | Low | Color grading |
| CAS | ⭐⭐⭐ | Low | Sharpening |

## 👀 What to Expect

### Daltonize Effect:
- **ON**: Colors shift (reds → browns, greens shift, etc.)
- **OFF**: Normal colors
- **Toggle**: Press HOME key

### Deband Effect:
- **ON**: Smoother gradients, less banding
- **OFF**: May see color bands in gradients
- **Toggle**: Press HOME key

### DisplayDepth Effect:
- **ON**: Black and white depth visualization
- **OFF**: Normal colored scene
- **Toggle**: Press HOME key

## 🔧 Troubleshooting

**ReShade not working?**
1. Make sure you're using the **default** variant:
   ```bash
   export ENABLE_VULKANFX=1  # NOT "simple" or "depth"
   ```

2. Check paths are correct:
   ```bash
   ls fx/Shaders/Daltonize.fx
   ls fx/Textures/
   ```

3. Check config:
   ```bash
   cat ~/.config/VulkanFX/VulkanFX.conf
   ```

**No visible effect?**
- Try Daltonize first - it's the most obvious
- Make sure to press HOME key to toggle
- Check vkcube output for errors

**Shader compile errors?**
- Check the shader file exists
- Verify paths in config
- Look at terminal output for error messages

## 💡 Pro Tips

1. **Start with Daltonize** - easiest to see
2. **Press HOME key** - toggle to compare
3. **Watch terminal** - shows shader compilation
4. **Try combinations** - mix effects for unique looks
5. **Adjust performance** - fewer effects = better FPS

## 📝 Example Configs

### Maximum Visual Impact:
```ini
effects = reshade(Daltonize.fx)
toggleKey = Home
enableOnLaunch = True
```

### Quality Enhancement:
```ini
effects = cas:reshade(Deband.fx)
casSharpness = 0.7
toggleKey = Home
enableOnLaunch = True
```

### Debug View:
```ini
effects = reshade(DisplayDepth.fx)
depthCapture = on
toggleKey = Home
enableOnLaunch = True
```

---

**Ready to test!** 🎉

Run: `./test_reshade.sh` and choose an effect!
