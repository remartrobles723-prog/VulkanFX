# VulkanFX - Working Build for Termux

✅ **Successfully built and configured!**

## 🚀 Quick Test

### Prerequisites
1. Install **Termux:X11** app from: https://github.com/termux/termux-x11/releases

### Run Test

```bash
./complete_test.sh
```

This will:
1. Start X11 server
2. Launch vkcube with VulkanFX
3. Show you the effects!

### How to See Effects

1. **Open Termux:X11 app** (before running script)
2. **Run the script** - you'll see a rotating cube
3. **Press HOME key** on your device
4. **Watch the cube** - texture will become sharper/softer!

## 👀 What You'll See

**Effects ON (after pressing HOME):**
- ✅ **VERY sharp** cube texture
- ✅ Crisp, defined edges
- ✅ Enhanced details

**Effects OFF:**
- Softer, blurrier texture
- Less defined edges

## ⚙️ Configuration

VulkanFX is configured with **EXTREME** settings:
- 5x CAS (Contrast Adaptive Sharpening) passes
- Maximum sharpness (1.0)
- Very noticeable difference!

Config file: `~/.config/VulkanFX/VulkanFX.conf`

## 🔧 Adjust Effects

Edit the config:
```bash
nano ~/.config/VulkanFX/VulkanFX.conf
```

Available effects:
- `cas` - Contrast Adaptive Sharpening
- `dls` - Denoised Luma Sharpening
- `fxaa` - Fast Approximate Anti-Aliasing
- `smaa` - Enhanced Subpixel Morphological Antialiasing

Example:
```ini
effects = cas:cas:cas:cas:cas
casSharpness = 1.0
toggleKey = Home
```

## 📁 Files

- **`complete_test.sh`** - All-in-one test script ⭐
- **`~/.local/share/vulkan/implicit_layer.d/VulkanFX.json`** - Layer manifest
- **`~/.config/VulkanFX/VulkanFX.conf`** - Configuration
- **`build/src/libVkLayer_VulkanFX_*.so`** - Built libraries

## 🛑 Stop X11

```bash
pkill -f com.termux.x11
```

## 🏗️ Rebuild

```bash
ninja -C build
```

## 📚 More Info

- **Repository**: https://github.com/remartrobles723-prog/VulkanFX
- **Based on**: vkBasalt by DadSchoorse
- **Platform**: Termux on Android (ARM64)

---

**Just run:** `./complete_test.sh` 🎉
