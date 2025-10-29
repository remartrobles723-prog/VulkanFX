# VulkanFX Testing with Termux:X11

## 📱 Complete Setup Guide

### Prerequisites
1. **Install Termux:X11 App**
   - Download from: https://github.com/termux/termux-x11/releases
   - Get the latest `.apk` file
   - Install on your Android device

### ✅ Installed Packages
- ✅ Termux:X11 server
- ✅ Mesa with software rendering (llvmpipe)
- ✅ OpenGL/Vulkan support
- ✅ Openbox window manager
- ✅ aterm terminal emulator
- ✅ mesa-demos (glxgears, vkcube, etc.)

## 🚀 Quick Start

### Step 1: Open Termux:X11 App
Open the Termux:X11 app on your Android device first!

### Step 2: Start X11 Environment
```bash
./start_x11.sh
```

This will:
- Start Termux:X11 server on display :0
- Launch Openbox window manager
- Open a terminal window (aterm)
- Set up VulkanFX environment

### Step 3: Test!

#### Option A: From the terminal window in Termux:X11
The terminal window will appear in the Termux:X11 app. In that terminal:
```bash
cd /data/data/com.termux/files/home/VulkanFX
./demo_vulkanfx.sh
```

#### Option B: From Termux directly
```bash
export DISPLAY=:0
./quick_test.sh
```

## 🎮 Testing VulkanFX

### Test with vkcube (Vulkan):
```bash
export DISPLAY=:0
export VK_LAYER_PATH="$(pwd)/build/config"
export ENABLE_VULKANFX=1
vkcube
```

### Test with glxgears (OpenGL):
```bash
export DISPLAY=:0
glxgears
```

### Compare with/without VulkanFX:
```bash
# With VulkanFX (sharpening enabled)
export ENABLE_VULKANFX=1
vkcube &

# Without VulkanFX
unset ENABLE_VULKANFX
vkcube &
```

## 🎨 VulkanFX Features

### Toggle Effects
Press the **Home** key while vkcube is running to toggle VulkanFX effects on/off!

### Available Variants:
```bash
# Default (with ReShade support)
export ENABLE_VULKANFX=1

# Depth capture enabled
export ENABLE_VULKANFX=depth

# Lightweight (no ReShade)
export ENABLE_VULKANFX=simple
```

### Configure Effects:
```bash
mkdir -p ~/.config/VulkanFX
cp config/VulkanFX.conf ~/.config/VulkanFX/
nano ~/.config/VulkanFX/VulkanFX.conf
```

Available effects:
- **cas** - Contrast Adaptive Sharpening (default)
- **dls** - Denoised Luma Sharpening
- **fxaa** - Fast Approximate Anti-Aliasing
- **smaa** - Enhanced Subpixel Morphological Antialiasing
- **lut** - Color LookUp Table

## 🔧 Troubleshooting

### No rendering / Black screen:
```bash
# Make sure Mesa environment is set
export MESA_GL_VERSION_OVERRIDE=4.5
export MESA_GLSL_VERSION_OVERRIDE=450
export GALLIUM_DRIVER=llvmpipe

# Test with simple OpenGL first
glxgears
```

### X11 not connecting:
```bash
# Check if Termux:X11 app is open
# Kill and restart
pkill -f com.termux.x11
./start_x11.sh
```

### Terminal not showing:
```bash
# Manually start terminal
export DISPLAY=:0
aterm &
```

### VulkanFX not working:
```bash
# Verify environment
echo $VK_LAYER_PATH
echo $ENABLE_VULKANFX

# Check libraries exist
ls -lh build/src/libVkLayer_VulkanFX_*.so

# Test without VulkanFX first
unset ENABLE_VULKANFX
vkcube
```

## 📊 What You Should See

### In Termux:X11 App:
1. **Desktop background** (gray/black)
2. **Terminal window** (aterm)
3. **Mouse cursor** (working)
4. **Applications** (vkcube, glxgears, etc.)

### With glxgears:
- Three rotating colored gears
- FPS counter in terminal

### With vkcube:
- Rotating textured cube
- VulkanFX sharpening applied (if enabled)
- Toggle effects with Home key

## 🎯 Demo Scripts

### `start_x11.sh`
Starts complete X11 environment with:
- Termux:X11 server
- Openbox window manager
- Terminal window
- VulkanFX environment

### `demo_vulkanfx.sh`
Interactive menu to test:
1. vkcube with VulkanFX
2. glxgears
3. vulkaninfo
4. vkcube without VulkanFX

### `quick_test.sh`
Quick OpenGL test with glxgears

### `test_simple.sh`
Basic VulkanFX library check

## 📝 Environment Variables

### Required:
```bash
export DISPLAY=:0                                    # X11 display
export VK_LAYER_PATH="$(pwd)/build/config"          # VulkanFX layers
export ENABLE_VULKANFX=1                            # Enable VulkanFX
```

### Recommended (for Mesa):
```bash
export MESA_GL_VERSION_OVERRIDE=4.5                 # OpenGL version
export MESA_GLSL_VERSION_OVERRIDE=450               # GLSL version
export GALLIUM_DRIVER=llvmpipe                      # Software renderer
```

## 🛑 Stopping X11

```bash
# Stop all X11 processes
pkill -f com.termux.x11
pkill openbox
pkill aterm

# Or just close the Termux:X11 app
```

## 💡 Tips

1. **Keep Termux:X11 app in foreground** for best performance
2. **Use landscape mode** for better viewing
3. **Start with glxgears** to verify rendering works
4. **Then test vkcube** with VulkanFX
5. **Press Home key** to toggle effects and see the difference
6. **Check terminal output** for FPS and debug info

## 🎓 Advanced Usage

### Run multiple apps:
```bash
export DISPLAY=:0
glxgears &
vkcube &
```

### Debug Vulkan:
```bash
export VK_LOADER_DEBUG=all
export ENABLE_VULKANFX=1
vulkaninfo 2>&1 | tee vulkan_debug.log
```

### Test different effects:
```bash
# Edit config
nano ~/.config/VulkanFX/VulkanFX.conf

# Try combinations:
effects = smaa:cas
effects = fxaa:dls
```

### Benchmark:
```bash
# With VulkanFX
export ENABLE_VULKANFX=1
vkcube  # Note FPS

# Without VulkanFX
unset ENABLE_VULKANFX
vkcube  # Compare FPS
```

## 📚 Files

- **`start_x11.sh`** - Complete X11 startup
- **`demo_vulkanfx.sh`** - Interactive demo menu
- **`quick_test.sh`** - Quick OpenGL test
- **`test_simple.sh`** - Library verification
- **`config/VulkanFX.conf`** - Effect configuration
- **`build/config/VulkanFX.json`** - Layer manifest

## ✅ Success Checklist

- [ ] Termux:X11 app installed
- [ ] Termux:X11 app open
- [ ] `./start_x11.sh` executed
- [ ] Desktop visible in Termux:X11 app
- [ ] Terminal window visible
- [ ] `glxgears` shows rotating gears
- [ ] `vkcube` shows rotating cube
- [ ] Home key toggles VulkanFX effects

---

**Ready to test!** 🎉

Run: `./start_x11.sh` then `./demo_vulkanfx.sh`
