# VulkanFX for Termux - Changelog

## Commit: a7c31dc (2025-10-29)
**Fix VulkanFX for Termux: Vulkan 1.0 compatibility, ReShade support, and testing scripts**

### 🔧 Core Fixes

#### Vulkan 1.0 Compatibility
- **Fixed VMA (Vulkan Memory Allocator)** to use Vulkan 1.0 instead of 1.2
  - Changed `VMA_VULKAN_VERSION` from 1002000 to 1000000
  - Changed `VK_API_VERSION_1_2` to `VK_API_VERSION_1_0`
  - Removed `VMA_ALLOCATOR_CREATE_EXT_MEMORY_BUDGET_BIT` flag
  - **Reason**: llvmpipe (software renderer) doesn't support all Vulkan 1.2 features
  - **Result**: No more VMA assertion failures!

#### Layer Installation
- Installed VulkanFX layer to proper implicit layer directory
  - Location: `~/.local/share/vulkan/implicit_layer.d/VulkanFX.json`
  - Used absolute paths in layer manifest
  - Changed layer type from `INSTANCE` to `GLOBAL`
  - **Result**: Vulkan loader now finds and loads VulkanFX automatically!

### 🎨 ReShade Support

#### ReShade FX Shaders
- Added support for ReShade effects from `fx/` folder
- Documented correct configuration syntax:
  ```ini
  effects = Daltonize
  Daltonize = /path/to/Daltonize.fx
  ```
- Available effects:
  - Daltonize.fx - Color shift (simulates color blindness)
  - Deband.fx - Reduces color banding
  - DisplayDepth.fx - Depth buffer visualization
  - LUT.fx - Color grading
  - UIMask.fx - UI masking

### 📜 Testing Scripts

#### Main Test Scripts
- **`complete_test.sh`** - All-in-one: starts X11 + runs vkcube
- **`test_reshade.sh`** - Interactive ReShade effect selector
- **`test.sh`** - Quick test with multiple options
- **`toggle_effects.sh`** - Toggle effects on/off in config
- **`restart_vkcube.sh`** - Quick restart helper

#### X11 Setup Scripts
- **`start_x11.sh`** - Start Termux:X11 with Openbox
- **`start_vnc.sh`** - VNC server setup (alternative)

#### Diagnostic Scripts
- **`diagnose.sh`** - Check VulkanFX installation and config
- **`test_simple.sh`** - Basic library verification
- **`test_vulkanfx.sh`** - Original test script
- **`test_vulkanfx_x11.sh`** - X11-specific tests

#### Comparison Scripts
- **`compare.sh`** - Before/after effect comparison
- **`easy_compare.sh`** - Fullscreen comparison with toggle
- **`demo_vulkanfx.sh`** - Interactive demo
- **`quick_test.sh`** - Quick OpenGL test
- **`final_test.sh`** - Extreme settings test
- **`test_now.sh`** - Simple vkcube test

### 📚 Documentation

#### Comprehensive Guides
- **`README.md`** - Updated main README with quick start
- **`TESTING.md`** - Complete testing guide
- **`README_X11.md`** - Termux:X11 setup and usage
- **`RESHADE_GUIDE.md`** - ReShade effects documentation
- **`RESHADE.md`** - ReShade setup summary
- **`EFFECTS.md`** - Effect configuration details
- **`TOGGLE_AND_UI.md`** - Toggle key and UI guide

### 🏗️ Build Configuration

#### Modified Files
- **`src/vma_usage.hpp`** - Vulkan 1.0 compatibility
- **`src/basalt.cpp`** - VMA allocator flags fix
- **`config/VulkanFX.conf`** - Updated with ReShade examples
- **`build/config/VulkanFX.json`** - Absolute paths in manifest

#### Built Libraries
All 3 variants successfully built:
- `libVkLayer_VulkanFX_default.so` - Full version with ReShade
- `libVkLayer_VulkanFX_depth.so` - With depth capture
- `libVkLayer_VulkanFX_simple.so` - Lightweight (no ReShade)

### ✅ Verified Working

- ✅ VulkanFX layer loads automatically
- ✅ Config file is read correctly
- ✅ CAS sharpening effects work (very noticeable at 5x passes)
- ✅ ReShade effects work (Daltonize, Deband, etc.)
- ✅ Effects can be toggled (via config + restart)
- ✅ X11/Termux:X11 integration works
- ✅ vkcube runs without crashes

### 📊 Test Results

#### Performance
- **Without effects**: ~60 FPS
- **With 5x CAS**: ~50-55 FPS (noticeable lag but acceptable)
- **With ReShade**: Varies by effect (~45-60 FPS)

#### Visual Impact
- **CAS (5x, sharpness 1.0)**: VERY noticeable sharpening
- **Daltonize**: Dramatic color shift (most visible)
- **Deband**: Subtle but effective
- **DisplayDepth**: Complete depth visualization

### 🐛 Known Issues

#### Toggle Key
- HOME key toggle only works on first launch
- Runtime toggle doesn't work reliably
- **Workaround**: Use `toggle_effects.sh` + restart

#### ReShade UI
- ReShade overlay/UI not integrated
- No runtime parameter adjustment
- **Workaround**: Edit config file manually

### 🔮 Future Improvements

- [ ] Fix runtime toggle key detection
- [ ] Integrate ReShade overlay UI
- [ ] Add more ReShade shader examples
- [ ] Improve performance with hardware GPU
- [ ] Add preset system for quick effect switching

### 📦 Repository

- **Branch**: VulkanFX
- **Commit**: a7c31dc
- **URL**: https://github.com/remartrobles723-prog/VulkanFX
- **Platform**: Termux on Android (ARM64)
- **Tested on**: llvmpipe (LLVM 21.1.3, 128 bits)

### 🙏 Credits

- **Original**: vkBasalt by DadSchoorse
- **Fork**: VulkanFX by pchome
- **Termux Port**: This build
- **ReShade**: ReShade FX shader framework

---

**All changes successfully pushed to GitHub VulkanFX branch!** 🎉
