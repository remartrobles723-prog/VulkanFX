# VulkanFX Testing Guide

## ✅ Installation Complete

X11 and VNC server have been installed successfully!

## 🎮 Quick Start Testing

### 1. **Start VNC Server**
```bash
./start_vnc.sh
```

This will:
- Start a VNC server on display :1
- Create a desktop environment accessible via VNC
- Prompt for a password on first run

### 2. **Connect to VNC**
- Install a VNC viewer app on your Android device (e.g., "VNC Viewer" from Google Play)
- Connect to: `localhost:5901`
- Enter the password you set

### 3. **Run Automated Tests**
```bash
./test_vulkanfx_x11.sh
```

## 📋 Manual Testing

### Test with vulkaninfo:
```bash
export DISPLAY=:1
export VK_LAYER_PATH="$(pwd)/build/config"
export ENABLE_VULKANFX=1
vulkaninfo | grep -i vulkanfx
```

### Test with vkcube (Vulkan demo):
```bash
export DISPLAY=:1
export VK_LAYER_PATH="$(pwd)/build/config"
export ENABLE_VULKANFX=1
vkcube
```

## 🎨 VulkanFX Variants

### Default (Full Features):
```bash
export ENABLE_VULKANFX=1
```
- Includes all effects
- ReShade FX support
- Best for full post-processing

### Depth Capture:
```bash
export ENABLE_VULKANFX=depth
```
- Enables depth buffer capture
- Useful for depth-based effects

### Simple (Lightweight):
```bash
export ENABLE_VULKANFX=simple
```
- No ReShade FX
- Lower overhead
- Basic effects only

## ⚙️ Configuration

### Edit Effects:
```bash
mkdir -p ~/.config/VulkanFX
cp config/VulkanFX.conf ~/.config/VulkanFX/
nano ~/.config/VulkanFX/VulkanFX.conf
```

### Available Effects:
- **cas** - Contrast Adaptive Sharpening (default)
- **dls** - Denoised Luma Sharpening
- **fxaa** - Fast Approximate Anti-Aliasing
- **smaa** - Enhanced Subpixel Morphological Antialiasing
- **lut** - Color LookUp Table

### Example Configuration:
```ini
# Enable multiple effects (run in order)
effects = fxaa:cas

# Toggle key (press to enable/disable effects)
toggleKey = Home

# Enable effects on launch
enableOnLaunch = True

# CAS sharpness (0.0 - 1.0)
casSharpness = 0.4
```

## 🔧 Troubleshooting

### VulkanFX not detected:
1. Check layer path:
   ```bash
   echo $VK_LAYER_PATH
   ```
2. Verify libraries exist:
   ```bash
   ls -lh build/src/libVkLayer_VulkanFX_*.so
   ```
3. Check manifest:
   ```bash
   cat build/config/VulkanFX.json
   ```

### VNC connection issues:
```bash
# Kill existing VNC server
vncserver -kill :1

# Restart
./start_vnc.sh
```

### Display issues:
```bash
# Check if VNC is running
ps aux | grep vnc

# Set display manually
export DISPLAY=:1
```

## 📊 Test Results

### ✅ Working:
- ✅ All 3 library variants built successfully
- ✅ VNC server starts correctly
- ✅ vulkaninfo runs
- ✅ vkcube executes (with VulkanFX layer)
- ✅ Configuration files present

### 📝 Notes:
- Libraries are valid ELF 64-bit ARM shared objects
- Layer manifest correctly defines all 3 variants
- Default effect (CAS) is configured

## 🚀 Advanced Testing

### Test with a Vulkan game:
```bash
export DISPLAY=:1
export VK_LAYER_PATH="$(pwd)/build/config"
export ENABLE_VULKANFX=1
# Run your Vulkan game here
```

### Enable debug logging:
```bash
export VK_LOADER_DEBUG=all
export ENABLE_VULKANFX=1
vulkaninfo 2>&1 | tee vulkan_debug.log
```

### Test different effects:
```bash
# Edit config
nano ~/.config/VulkanFX/VulkanFX.conf

# Change effects line to:
effects = smaa:cas
# or
effects = fxaa:dls
```

## 📱 VNC Viewer Apps

Recommended VNC viewers for Android:
- **VNC Viewer** (RealVNC) - Free, reliable
- **bVNC** - Open source
- **MultiVNC** - Feature-rich

## 🛑 Stopping Services

```bash
# Stop VNC server
vncserver -kill :1

# Or kill all VNC sessions
pkill -9 Xvnc
```

## 📚 Additional Resources

- VulkanFX Config: `config/VulkanFX.conf`
- Layer Manifest: `build/config/VulkanFX.json`
- Test Scripts: `test_vulkanfx.sh`, `test_vulkanfx_x11.sh`
- VNC Script: `start_vnc.sh`

## 🎯 Next Steps

1. Connect via VNC to see the desktop
2. Run Vulkan applications with VulkanFX enabled
3. Experiment with different effects
4. Adjust sharpness and quality settings
5. Test with real games/applications

---

**Built on:** $(date)
**Platform:** Termux on Android (ARM64)
**Vulkan API:** 1.3.295
