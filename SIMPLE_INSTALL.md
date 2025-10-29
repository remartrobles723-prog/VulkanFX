# VulkanFX Simple Installation Guide

## ✅ You're Right! No `ninja install` Needed!

### 🎯 Quick Answer

**Just build:**
```bash
meson setup build
ninja -C build
```

**That's it!** All files are generated in the `build/` directory.

## 📁 What `ninja -C build` Generates

### Libraries (build/src/)
```
build/src/
├── libVkLayer_VulkanFX_default.so  ← Main library (with ReShade)
├── libVkLayer_VulkanFX_depth.so    ← With depth capture
└── libVkLayer_VulkanFX_simple.so   ← Without ReShade
```

### Layer Manifest (build/config/)
```
build/config/
└── VulkanFX.json  ← Vulkan layer configuration
```

**The manifest already has absolute paths!**

## 🚀 How to Use (No Installation Required)

### Method 1: Use Directly from Build Directory

```bash
# Set environment variable
export VK_LAYER_PATH="$PWD/build/config"
export ENABLE_VULKANFX=1

# Run your Vulkan app
vkcube
```

**That's it!** Vulkan loader will find the layer automatically.

### Method 2: Symlink to Standard Location (Optional)

If you want it in the standard location:

```bash
# Create directory
mkdir -p ~/.local/share/vulkan/implicit_layer.d

# Symlink the manifest
ln -sf "$PWD/build/config/VulkanFX.json" \
       ~/.local/share/vulkan/implicit_layer.d/VulkanFX.json
```

**No need to copy libraries!** The manifest has absolute paths.

### Method 3: Copy to Standard Location (Optional)

Only if you want to:

```bash
# Copy libraries
mkdir -p ~/.local/lib
cp build/src/*.so ~/.local/lib/

# Copy manifest (update paths first)
mkdir -p ~/.local/share/vulkan/implicit_layer.d
# Edit VulkanFX.json to point to ~/.local/lib
cp build/config/VulkanFX.json ~/.local/share/vulkan/implicit_layer.d/
```

## 🎯 Why No `ninja install`?

### The manifest already contains absolute paths:

```json
{
  "library_path": "/data/data/com.termux/files/home/VulkanFX/build/src/libVkLayer_VulkanFX_default.so"
}
```

**This means:**
- ✅ Libraries work from build directory
- ✅ No installation needed
- ✅ Just point VK_LAYER_PATH to build/config
- ✅ Or symlink the manifest

## 📊 Comparison

| Method | Command | Pros | Cons |
|--------|---------|------|------|
| **Direct Use** | `export VK_LAYER_PATH=...` | ✅ No install<br>✅ Easy dev | ⚠️ Need env var |
| **Symlink** | `ln -sf ...` | ✅ Standard location<br>✅ No copying | ⚠️ Absolute paths |
| **Copy** | `cp ... && edit paths` | ✅ Portable | ❌ Need to update paths |

## ✅ Recommended: Direct Use

**For development and testing:**

```bash
# 1. Build
meson setup build
ninja -C build

# 2. Use
export VK_LAYER_PATH="$PWD/build/config"
export ENABLE_VULKANFX=1
vkcube
```

**For permanent installation:**

```bash
# 1. Build
meson setup build
ninja -C build

# 2. Symlink
mkdir -p ~/.local/share/vulkan/implicit_layer.d
ln -sf "$PWD/build/config/VulkanFX.json" \
       ~/.local/share/vulkan/implicit_layer.d/VulkanFX.json

# 3. Use (no VK_LAYER_PATH needed!)
export ENABLE_VULKANFX=1
vkcube
```

## 🔍 Verify Installation

### Check if layer is found:

```bash
# Method 1: With VK_LAYER_PATH
export VK_LAYER_PATH="$PWD/build/config"
vulkaninfo | grep -i vulkanfx

# Method 2: With symlink
vulkaninfo | grep -i vulkanfx
```

**You should see:**
```
VK_LAYER_VULKANFX_default
VK_LAYER_VULKANFX_depth
VK_LAYER_VULKANFX_simple
```

## 💡 What About `ninja install`?

**It's optional!** It would:
- Copy libraries to system directories
- Copy manifest to system directories
- Update paths in manifest

**But you don't need it because:**
- ✅ Manifest already has absolute paths
- ✅ Libraries work from build directory
- ✅ VK_LAYER_PATH or symlink is enough

## 🎯 Quick Reference

### Build Only
```bash
meson setup build
ninja -C build
```

### Use Immediately
```bash
export VK_LAYER_PATH="$PWD/build/config"
export ENABLE_VULKANFX=1
vkcube
```

### Make Permanent (Optional)
```bash
ln -sf "$PWD/build/config/VulkanFX.json" \
       ~/.local/share/vulkan/implicit_layer.d/VulkanFX.json
```

## ✅ Summary

**You're absolutely right!**

- ✅ `ninja -C build` generates everything
- ✅ No `ninja install` needed
- ✅ Use directly from build directory
- ✅ Or symlink for convenience
- ✅ Libraries have absolute paths in manifest

**Just build and use!** 🚀

---

**The simplest way:**
```bash
meson setup build && ninja -C build
export VK_LAYER_PATH="$PWD/build/config" ENABLE_VULKANFX=1
vkcube
```

**Done!** 🎉
