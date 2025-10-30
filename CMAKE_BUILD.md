# Building VulkanFX with CMake

This document describes how to build VulkanFX using CMake as an alternative to Meson.

## Prerequisites

- CMake 3.15 or later
- C++23 compatible compiler (Clang 14+ or GCC 11+)
- Vulkan SDK with glslangValidator
- X11 development libraries
- pkg-config
- SPIRV-Headers

### Installing Dependencies on Termux

```bash
pkg install cmake clang vulkan-headers vulkan-loader-android vulkan-tools libx11 pkg-config spirv-headers
```

### Installing Dependencies on Debian/Ubuntu

```bash
sudo apt install cmake build-essential libvulkan-dev glslang-tools libx11-dev pkg-config spirv-headers
```

## Build Instructions

### 1. Configure the Build

```bash
mkdir -p build_cmake
cmake -S . -B build_cmake -DCMAKE_BUILD_TYPE=Release
```

### 2. Build the Project

```bash
cmake --build build_cmake -j$(nproc)
```

**Note for Termux users**: Building on Termux can be slow. You may want to use fewer parallel jobs:

```bash
cmake --build build_cmake -j2
```

Or build without parallel jobs if you encounter memory issues:

```bash
cmake --build build_cmake
```

### 3. Install (Optional)

```bash
cmake --build build_cmake --target install
```

Or with sudo on desktop systems:

```bash
sudo cmake --build build_cmake --target install
```

## Build Options

You can customize the build with the following CMake options:

| Option | Default | Description |
|--------|---------|-------------|
| `BUILD_ALL_VARIANTS` | ON | Build all three variants (default, simple, depth) |
| `DISABLE_RESHADEFX` | OFF | Disable ReShade FX support |
| `WITH_SO` | ON | Install the library files |
| `WITH_JSON` | ON | Install the JSON manifest files |
| `APPEND_LIBDIR_VULKANFX` | OFF | Append 'vulkanfx' to library directory |
| `CMAKE_BUILD_TYPE` | - | Build type (Release, Debug, RelWithDebInfo) |
| `CMAKE_INSTALL_PREFIX` | /usr/local | Installation prefix |

### Example: Build Only the Default Variant

```bash
cmake -S . -B build_cmake -DBUILD_ALL_VARIANTS=OFF -DCMAKE_BUILD_TYPE=Release
cmake --build build_cmake
```

### Example: Debug Build

```bash
cmake -S . -B build_cmake -DCMAKE_BUILD_TYPE=Debug
cmake --build build_cmake
```

### Example: Custom Install Location

```bash
cmake -S . -B build_cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local
cmake --build build_cmake --target install
```

## Build Variants

The project builds three variants of the Vulkan layer:

1. **VkLayer_VulkanFX_default** - Full featured with ReShade FX support, no depth capture
2. **VkLayer_VulkanFX_simple** - Lightweight without ReShade FX support
3. **VkLayer_VulkanFX_depth** - Full featured with depth capture enabled

## Build Artifacts

After building, you'll find:

- **Libraries**: `build_cmake/libVkLayer_VulkanFX_*.so`
- **Shader Headers**: `build_cmake/*.h` (generated from GLSL shaders)
- **ReShade Libraries**: `build_cmake/subprojects/reshade/libReShadeFX*.so`

## Troubleshooting

### glslangValidator Not Found

If CMake can't find `glslangValidator`, install it:

```bash
# Termux
pkg install vulkan-tools

# Debian/Ubuntu
sudo apt install glslang-tools
```

### SPIRV-Headers Not Found

```bash
# Termux
pkg install spirv-headers

# Debian/Ubuntu
sudo apt install spirv-headers
```

### Out of Memory on Termux

If you run out of memory during compilation:

1. Build with a single job: `cmake --build build_cmake -j1`
2. Close other applications
3. Consider building on a more powerful device

### Slow Build Times

The ReShade library compilation can be slow, especially on mobile devices. This is normal. The `effect_symbol_table.cpp` file in particular takes a long time to compile due to its size and complexity.

## Comparison with Meson

| Feature | Meson | CMake |
|---------|-------|-------|
| Configuration Speed | Faster | Slower |
| Build Speed | Similar | Similar |
| IDE Support | Good | Excellent |
| Portability | Good | Excellent |
| Complexity | Lower | Higher |

Both build systems produce identical binaries. Choose based on your preference and tooling.

## Clean Build

To start fresh:

```bash
rm -rf build_cmake
cmake -S . -B build_cmake -DCMAKE_BUILD_TYPE=Release
cmake --build build_cmake
```

## Cross-Compilation

CMake supports cross-compilation through toolchain files. Example for Android:

```bash
cmake -S . -B build_cmake \
    -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
    -DANDROID_ABI=arm64-v8a \
    -DANDROID_PLATFORM=android-24
```

## Additional Resources

- [CMake Documentation](https://cmake.org/documentation/)
- [VulkanFX README](README.md)
- [Meson Build Instructions](BUILD_SYSTEMS.md)
