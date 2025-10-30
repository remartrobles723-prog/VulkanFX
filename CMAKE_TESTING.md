# Testing CMake-Built VulkanFX Libraries

## Current Status

✅ **CMake libraries successfully built and deployed!**

The CMake-built libraries have been copied to `build/src/` where your test scripts expect them.

## What's Ready

### CMake-Built Libraries (in build/src/)
- `libVkLayer_VulkanFX_default.so` - Full featured, no depth capture
- `libVkLayer_VulkanFX_depth.so` - Full featured with depth capture
- `libVkLayer_VulkanFX_simple.so` - Lightweight, no ReShade

### ReShade Libraries (in build/src/)
- `libReShadeFX.so` - Core ReShade FX compiler
- `libReShadeFX-spirv.so` - SPIR-V code generation
- `libReShadeFX-vulkan-type-convert.so` - Type conversion

### Backup
Your original Meson-built libraries are safely backed up in:
- `build/src/meson_backup/`

## How to Test

### Option 1: Use the Wrapper Script (Recommended)

```bash
./test_cmake_build.sh
```

This script:
1. Verifies CMake libraries are in place
2. Sets up the library path
3. Runs your existing `test_reshade.sh`

### Option 2: Run Test Directly

```bash
export LD_LIBRARY_PATH="$PWD/build/src:$LD_LIBRARY_PATH"
./test_reshade.sh
```

### Option 3: Manual Test with vkcube

```bash
# Set up environment
export DISPLAY=:0
export ENABLE_VULKANFX=1
export LD_LIBRARY_PATH="$PWD/build/src:$LD_LIBRARY_PATH"

# Create a simple config
mkdir -p ~/.config/VulkanFX
cat > ~/.config/VulkanFX/VulkanFX.conf << 'EOF'
effects = cas
toggleKey = Home
enableOnLaunch = True
casSharpness = 1.0
EOF

# Run vkcube
vkcube
```

## Test Options

When you run `test_reshade.sh`, you can choose:

1. **Daltonize** - Color shift effect (tests ReShade FX)
2. **Deband** - Color banding reduction (tests ReShade FX)
3. **DisplayDepth** - Depth buffer visualization (tests depth capture)
4. **CAS only** - Sharpening without ReShade (tests built-in effects)
5. **CAS + Daltonize** - Combined effects (tests both systems)

## What to Look For

### Success Indicators
- ✅ vkcube starts without errors
- ✅ Effects are visible in Termux:X11
- ✅ HOME key toggles effects on/off
- ✅ No library loading errors in console

### Potential Issues
- ❌ "cannot open shared object file" - ReShade libraries not found
  - **Fix**: Ensure `LD_LIBRARY_PATH` includes `build/src/`
  
- ❌ "undefined symbol" - Missing dependencies
  - **Fix**: Rebuild with `cmake --build build_cmake --target clean && cmake --build build_cmake`

- ❌ Effects not visible - Configuration issue
  - **Fix**: Check `~/.config/VulkanFX/VulkanFX.conf`

## Comparing Builds

### Check Library Sizes

```bash
echo "=== Meson Build ==="
ls -lh build/src/meson_backup/libVkLayer_VulkanFX_*.so

echo ""
echo "=== CMake Build ==="
ls -lh build/src/libVkLayer_VulkanFX_*.so
```

### Check Dependencies

```bash
# If you have objdump
objdump -p build/src/libVkLayer_VulkanFX_default.so | grep NEEDED
```

## Restoring Meson Build

If you want to switch back to Meson-built libraries:

```bash
# Remove CMake libraries
rm build/src/libVkLayer_VulkanFX_*.so
rm build/src/libReShadeFX*.so

# Restore Meson libraries
cp build/src/meson_backup/* build/src/

# Rebuild ReShade with Meson
ninja -C build
```

## Permanent CMake Setup

To use CMake libraries permanently, you have two options:

### Option A: Install System-Wide

```bash
sudo cmake --build build_cmake --target install
```

This installs to `/usr/local/lib/` and updates the system Vulkan layer registry.

### Option B: Create CMake-Specific JSON

Create `build_cmake/config/VulkanFX.json`:

```json
{
  "file_format_version": "1.2.1",
  "layers": [
    {
      "name": "VK_LAYER_VULKANFX_default",
      "type": "GLOBAL",
      "library_path": "/data/data/com.termux/files/home/VulkanFX/build_cmake/libVkLayer_VulkanFX_default.so",
      "api_version": "1.3.295",
      "implementation_version": "3",
      "description": "VulkanFX post processing layer (CMake build)",
      "enable_environment": {
        "ENABLE_VULKANFX": "1"
      }
    }
  ]
}
```

Then set:
```bash
export VK_LAYER_PATH="$PWD/build_cmake/config"
```

## Troubleshooting

### Library Not Found

```bash
# Check if libraries exist
ls -l build/src/libVkLayer_VulkanFX_*.so

# Check library path
echo $LD_LIBRARY_PATH

# Add build directory to path
export LD_LIBRARY_PATH="$PWD/build/src:$LD_LIBRARY_PATH"
```

### ReShade Effects Not Working

```bash
# Verify ReShade libraries are present
ls -l build/src/libReShadeFX*.so

# Check ReShade paths in config
cat ~/.config/VulkanFX/VulkanFX.conf | grep -E "reshade|effects"
```

### Depth Capture Not Working

Make sure you're using the depth variant:
```bash
export ENABLE_VULKANFX=depth
```

Or in the config:
```
depthCapture = on
```

## Performance Comparison

To compare Meson vs CMake builds:

```bash
# Test with Meson build
cp build/src/meson_backup/* build/src/
time vkcube --c 1000

# Test with CMake build  
cp build_cmake/libVkLayer_VulkanFX_*.so build/src/
time vkcube --c 1000
```

Both should perform identically as they're compiled with the same optimization flags.

## Next Steps

1. **Run the test**: `./test_cmake_build.sh`
2. **Try different effects**: Choose options 1-5 in the test menu
3. **Verify functionality**: Check that effects work as expected
4. **Report any issues**: Note any differences from Meson build

## Success Criteria

Your CMake build is working correctly if:
- ✅ All three variants load without errors
- ✅ Built-in effects (CAS, FXAA, SMAA) work
- ✅ ReShade FX effects load and run
- ✅ Depth capture works with depth variant
- ✅ Toggle key (HOME) works
- ✅ Performance is similar to Meson build

Happy testing! 🎮
