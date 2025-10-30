# VulkanFX Testing Guide

Complete guide for testing the VulkanFX Vulkan layer on Termux/Android.

---

## Quick Test Summary

✅ **Build Verification:** PASSED  
✅ **Libraries:** All present and valid (ARM64 ELF)  
✅ **Configuration:** Properly set up  
⏳ **Visual Testing:** Requires X11 display server  

---

## Available Test Scripts

### 1. **test_cmake_build.sh** - Main CMake Build Test
**Purpose:** Test CMake-built VulkanFX libraries with ReShade effects

**Usage:**
```bash
# Interactive mode (choose effect)
./test_cmake_build.sh

# Auto-select effect
echo '1' | ./test_cmake_build.sh  # Daltonize (color shift)
echo '2' | ./test_cmake_build.sh  # Deband (smooth gradients)
echo '3' | ./test_cmake_build.sh  # DisplayDepth (depth visualization)
echo '4' | ./test_cmake_build.sh  # CAS only (sharpening)
echo '5' | ./test_cmake_build.sh  # CAS + Daltonize combo
```

**What it does:**
- Verifies CMake-built libraries exist
- Sets up LD_LIBRARY_PATH for ReShade
- Runs test_reshade.sh with selected effect
- Launches vkcube with VulkanFX layer

**Requirements:**
- X11 display server (Termux:X11)
- vkcube installed
- Libraries in build/src/

---

### 2. **test_reshade.sh** - ReShade Effects Test
**Purpose:** Test individual ReShade effects with VulkanFX

**Usage:**
```bash
./test_reshade.sh
```

**Available Effects:**
1. **Daltonize** - Simulates color blindness (dramatic color shift)
2. **Deband** - Reduces color banding artifacts
3. **DisplayDepth** - Visualizes depth buffer (black/white)
4. **CAS only** - Contrast Adaptive Sharpening (3 passes)
5. **CAS + Daltonize** - Combined sharpening and color shift

**Controls:**
- **HOME key** - Toggle effects on/off
- **Ctrl+C** - Stop test

**Configuration:**
Creates `~/.config/VulkanFX/VulkanFX.conf` with selected effect

---

### 3. **test_cas_only.sh** - CAS Sharpening Test
**Purpose:** Quick test of CAS (Contrast Adaptive Sharpening) only

**Usage:**
```bash
./test_cas_only.sh
```

**What it does:**
- Configures CAS sharpening (no ReShade)
- Launches vkcube with sharpening enabled
- Simpler than full ReShade test

---

### 4. **test_image.sh** - Image Comparison Test
**Purpose:** Capture and compare images with/without effects

**Usage:**
```bash
./test_image.sh
```

**What it does:**
- Captures screenshots with effects disabled
- Captures screenshots with effects enabled
- Saves to timestamped directories
- Useful for visual comparison

**Output:**
- `capture_YYYYMMDD_HHMMSS/without_effects/`
- `capture_YYYYMMDD_HHMMSS/with_effects/`

---

### 5. **complete_test.sh** - Full Test Suite
**Purpose:** Run comprehensive test of all features

**Usage:**
```bash
./complete_test.sh
```

**What it does:**
- Tests all layer variants
- Tests multiple effects
- Comprehensive validation

---

### 6. **start_x11.sh** - X11 Environment Setup
**Purpose:** Start Termux:X11 display server and window manager

**Usage:**
```bash
./start_x11.sh
```

**What it does:**
- Kills existing X11 processes
- Sets DISPLAY=:0
- Configures VulkanFX environment
- Starts Termux:X11 server
- Starts Openbox window manager
- Opens terminal window

**Requirements:**
- Termux:X11 app installed
- Download: https://github.com/termux/termux-x11/releases

**Environment Variables Set:**
- `DISPLAY=:0`
- `VK_LAYER_PATH=$(pwd)/build/config`
- `ENABLE_VULKANFX=1`
- `MESA_GL_VERSION_OVERRIDE=4.5`
- `MESA_GLSL_VERSION_OVERRIDE=450`
- `GALLIUM_DRIVER=llvmpipe`

---

### 7. **restart_vkcube.sh** - Restart vkcube
**Purpose:** Quickly restart vkcube with current settings

**Usage:**
```bash
./restart_vkcube.sh
```

**What it does:**
- Kills existing vkcube process
- Restarts with current VulkanFX configuration

---

### 8. **toggle_effects.sh** - Toggle Effects On/Off
**Purpose:** Toggle VulkanFX effects without restarting

**Usage:**
```bash
./toggle_effects.sh
```

**What it does:**
- Toggles `enableOnLaunch` in config
- Useful for quick enable/disable

---

### 9. **capture_comparison.sh** - Automated Comparison
**Purpose:** Automated capture and comparison workflow

**Usage:**
```bash
./capture_comparison.sh
```

**What it does:**
- Automated screenshot capture
- Side-by-side comparison
- Saves comparison results

---

## Testing Workflow

### Initial Setup (One-time)

1. **Install Termux:X11:**
   ```bash
   # Download APK from:
   # https://github.com/termux/termux-x11/releases
   # Install on Android device
   ```

2. **Install required packages:**
   ```bash
   pkg install vulkan-tools mesa openbox aterm
   ```

3. **Build VulkanFX:**
   ```bash
   # Already done - libraries are in build/src/
   ```

### Quick Test (Recommended)

```bash
# 1. Start X11 (in one terminal)
./start_x11.sh

# 2. Run test (in another terminal or same after X11 starts)
echo '4' | ./test_cmake_build.sh

# 3. View in Termux:X11 app
# You should see a rotating cube with sharpening applied

# 4. Toggle effects with HOME key
```

### Full Test Suite

```bash
# 1. Start X11
./start_x11.sh

# 2. Test each effect
echo '1' | ./test_cmake_build.sh  # Daltonize
# Press Ctrl+C to stop, then:
echo '2' | ./test_cmake_build.sh  # Deband
# Press Ctrl+C to stop, then:
echo '3' | ./test_cmake_build.sh  # DisplayDepth
# etc.

# 3. Capture comparisons
./test_image.sh
```

### Manual Testing

```bash
# 1. Set environment
export DISPLAY=:0
export ENABLE_VULKANFX=1
export VK_LAYER_PATH="$(pwd)/build/config"
export LD_LIBRARY_PATH="$(pwd)/build/src:$LD_LIBRARY_PATH"

# 2. Configure effect manually
cat > ~/.config/VulkanFX/VulkanFX.conf << 'EOF'
effects = cas:cas:cas
toggleKey = Home
enableOnLaunch = True
casSharpness = 1.0
depthCapture = off
EOF

# 3. Run vkcube
vkcube
```

---

## Effect Configurations

### CAS Sharpening (Simple)
```ini
effects = cas:cas:cas
toggleKey = Home
enableOnLaunch = True
casSharpness = 1.0
depthCapture = off
```

### Daltonize (Color Shift)
```ini
effects = Daltonize
Daltonize = /data/data/com.termux/files/home/VulkanFX/fx/Shaders/Daltonize.fx
reshadeTexturePath = /data/data/com.termux/files/home/VulkanFX/fx/Textures
reshadeIncludePath = /data/data/com.termux/files/home/VulkanFX/fx/Shaders
toggleKey = Home
enableOnLaunch = True
depthCapture = off
```

### Deband (Smooth Gradients)
```ini
effects = Deband
Deband = /data/data/com.termux/files/home/VulkanFX/fx/Shaders/Deband.fx
reshadeTexturePath = /data/data/com.termux/files/home/VulkanFX/fx/Textures
reshadeIncludePath = /data/data/com.termux/files/home/VulkanFX/fx/Shaders
toggleKey = Home
enableOnLaunch = True
depthCapture = off
```

### DisplayDepth (Depth Visualization)
```ini
effects = DisplayDepth
DisplayDepth = /data/data/com.termux/files/home/VulkanFX/fx/Shaders/DisplayDepth.fx
reshadeTexturePath = /data/data/com.termux/files/home/VulkanFX/fx/Textures
reshadeIncludePath = /data/data/com.termux/files/home/VulkanFX/fx/Shaders
toggleKey = Home
enableOnLaunch = True
depthCapture = on
```

### CAS + Daltonize Combo
```ini
effects = cas:Daltonize
Daltonize = /data/data/com.termux/files/home/VulkanFX/fx/Shaders/Daltonize.fx
reshadeTexturePath = /data/data/com.termux/files/home/VulkanFX/fx/Textures
reshadeIncludePath = /data/data/com.termux/files/home/VulkanFX/fx/Shaders
toggleKey = Home
enableOnLaunch = True
casSharpness = 0.8
depthCapture = off
```

---

## Layer Variants

VulkanFX provides 3 layer variants:

### 1. VK_LAYER_VULKANFX_default
- **Enable:** `ENABLE_VULKANFX=1`
- **Features:** Full ReShade support + built-in effects
- **Library:** `libVkLayer_VulkanFX_default.so` (2.0M)

### 2. VK_LAYER_VULKANFX_depth
- **Enable:** `ENABLE_VULKANFX=depth`
- **Features:** Full support + depth capture enabled
- **Library:** `libVkLayer_VulkanFX_depth.so` (2.0M)
- **Use for:** DisplayDepth and depth-based effects

### 3. VK_LAYER_VULKANFX_simple
- **Enable:** `ENABLE_VULKANFX=simple`
- **Features:** Built-in effects only (no ReShade)
- **Library:** `libVkLayer_VulkanFX_simple.so` (1.8M)
- **Use for:** CAS, SMAA, FXAA only

---

## Troubleshooting

### Segmentation Fault
**Problem:** vkcube crashes with segfault  
**Cause:** No X11 display server running  
**Solution:**
```bash
./start_x11.sh
# Wait for X11 to start, then run test
```

### Libraries Not Found
**Problem:** Test script reports missing libraries  
**Cause:** Libraries not in build/src/  
**Solution:**
```bash
cp build_cmake/libVkLayer_VulkanFX_*.so build/src/
cp build_cmake/subprojects/reshade/libReShadeFX*.so build/src/
```

### Effects Not Visible
**Problem:** vkcube runs but no effects visible  
**Cause:** Effects toggled off or wrong layer  
**Solution:**
- Press HOME key to toggle effects
- Check `ENABLE_VULKANFX=1` is set
- Verify config: `cat ~/.config/VulkanFX/VulkanFX.conf`

### X11 Not Starting
**Problem:** Termux:X11 won't start  
**Cause:** App not installed or not running  
**Solution:**
1. Install Termux:X11 APK
2. Open Termux:X11 app first
3. Then run `./start_x11.sh`

### Wrong Layer Loaded
**Problem:** Effects don't work as expected  
**Cause:** Wrong layer variant loaded  
**Solution:**
```bash
# For ReShade effects:
export ENABLE_VULKANFX=1

# For depth effects:
export ENABLE_VULKANFX=depth

# For simple effects only:
export ENABLE_VULKANFX=simple
```

---

## Verification Commands

### Check Libraries
```bash
# List all libraries
ls -lh build/src/libVkLayer_*.so
ls -lh build/src/libReShadeFX*.so

# Verify ELF format
file build/src/libVkLayer_VulkanFX_default.so
```

### Check Configuration
```bash
# Layer config
cat build/config/VulkanFX.json

# Effect config
cat ~/.config/VulkanFX/VulkanFX.conf
```

### Check Environment
```bash
# Display
echo $DISPLAY

# VulkanFX
echo $ENABLE_VULKANFX
echo $VK_LAYER_PATH

# Library path
echo $LD_LIBRARY_PATH
```

### Check Processes
```bash
# X11 running?
ps aux | grep -i x11

# vkcube running?
ps aux | grep vkcube
```

---

## Expected Results

### CAS Sharpening
- **Visual:** Sharper edges, enhanced details
- **Performance:** Minimal impact
- **Toggle:** HOME key shows clear difference

### Daltonize
- **Visual:** Dramatic color shift (simulates color blindness)
- **Performance:** Minimal impact
- **Toggle:** HOME key shows original vs shifted colors

### Deband
- **Visual:** Smoother color gradients
- **Performance:** Minimal impact
- **Best seen:** On gradients and sky

### DisplayDepth
- **Visual:** Black and white depth visualization
- **Performance:** Minimal impact
- **Requires:** Depth capture enabled

---

## Performance Notes

- **CAS:** Very fast, suitable for real-time
- **ReShade effects:** Fast to moderate
- **Multiple effects:** Can be chained (e.g., `cas:Deband:FXAA`)
- **Toggle:** HOME key for instant on/off comparison

---

## Next Steps

1. ✅ Build verified - all libraries present
2. ⏳ Install Termux:X11 app
3. ⏳ Run `./start_x11.sh`
4. ⏳ Run `./test_cmake_build.sh`
5. ⏳ Test different effects
6. ⏳ Capture comparisons with `./test_image.sh`

---

## Additional Resources

- **VulkanFX GitHub:** https://github.com/pchome/VulkanFX
- **Termux:X11 Releases:** https://github.com/termux/termux-x11/releases
- **ReShade Effects:** Check `fx/Shaders/` directory
- **Documentation:** See `*.md` files in project root

---

## Summary

✅ **Build Status:** SUCCESS  
✅ **Libraries:** All present (ARM64 ELF)  
✅ **Configuration:** Properly set up  
✅ **Test Scripts:** 9 scripts available  
⏳ **Visual Testing:** Requires X11 setup  

**The VulkanFX layer is ready to use!**

To complete testing, install Termux:X11 and run the test scripts.
