# VulkanFX Build Approach

## 🏗️ Build Strategy

### Primary Build System: **Meson**

VulkanFX uses **Meson** as the primary build system for both platforms:

## 📦 Build Targets

### 1. Linux (Glibc) Build
**Target:** Desktop Linux distributions
**Libc:** Glibc (GNU C Library)
**Build System:** Meson
**Architecture:** x86_64

```bash
meson setup build
ninja -C build
```

**Output:**
- `libVkLayer_VulkanFX_default.so` (Glibc, x86_64)
- `libVkLayer_VulkanFX_depth.so` (Glibc, x86_64)
- `libVkLayer_VulkanFX_simple.so` (Glibc, x86_64)

**Works on:**
- Ubuntu, Debian, Fedora, Arch Linux
- Any desktop Linux with Glibc

### 2. Android (Bionic) Build
**Target:** Android, Termux, Winlator
**Libc:** Bionic (Android C Library)
**Build System:** Meson + Android NDK
**Architecture:** ARM64 (aarch64)

```bash
# With NDK cross-compilation
meson setup build_android --cross-file android-cross.txt
ninja -C build_android
```

**Output:**
- `libVkLayer_VulkanFX_default.so` (Bionic, ARM64)
- `libVkLayer_VulkanFX_depth.so` (Bionic, ARM64)
- `libVkLayer_VulkanFX_simple.so` (Bionic, ARM64)

**Works on:**
- Termux (native)
- Winlator (Wine/Proton on Android)
- Any Android app with Vulkan support
- Android 7.0+ (API 24+)

### 3. CMake (Alternative)
**Target:** Desktop Linux
**Libc:** Glibc
**Build System:** CMake
**Architecture:** x86_64

```bash
cmake -B build_cmake -DBUILD_ALL_VARIANTS=ON
cmake --build build_cmake
```

**Purpose:** Alternative build method for those who prefer CMake

## 🎯 GitHub Actions Workflow

### Build Jobs

#### Job 1: `build-linux-glibc`
- **Platform:** Ubuntu (Linux)
- **Libc:** Glibc
- **Tool:** Meson
- **Output:** `vulkanfx-linux-glibc-x86_64`

#### Job 2: `build-android-bionic`
- **Platform:** Android
- **Libc:** Bionic
- **Tool:** Meson + Android NDK r26b
- **Output:** `vulkanfx-android-bionic-arm64`

#### Job 3: `build-cmake-alternative`
- **Platform:** Ubuntu (Linux)
- **Libc:** Glibc
- **Tool:** CMake
- **Output:** `vulkanfx-cmake-linux`

## 📊 Comparison

| Aspect | Linux (Glibc) | Android (Bionic) |
|--------|---------------|------------------|
| **Libc** | Glibc | Bionic |
| **Build Tool** | Meson | Meson + NDK |
| **Arch** | x86_64 | ARM64 |
| **Target** | Desktop Linux | Android/Termux/Winlator |
| **Compiler** | GCC/Clang | Android NDK Clang |
| **API Level** | N/A | Android 24+ |

## 🔧 Why Meson for Both?

### Advantages of Meson:

1. ✅ **Consistent** - Same build system for both platforms
2. ✅ **Fast** - Faster than CMake or Autotools
3. ✅ **Cross-compilation** - Excellent NDK support
4. ✅ **Simple** - Easy to read and maintain
5. ✅ **Native** - What VulkanFX was designed for

### NDK Integration:

Meson works perfectly with Android NDK through cross-files:

```ini
[binaries]
c = 'aarch64-linux-android24-clang'
cpp = 'aarch64-linux-android24-clang++'

[host_machine]
system = 'android'
cpu_family = 'aarch64'
```

## 📦 Release Artifacts

### Linux Glibc Package
```
VulkanFX-linux-glibc-x86_64.tar.gz
├── lib/
│   ├── libVkLayer_VulkanFX_default.so (Glibc, x86_64)
│   ├── libVkLayer_VulkanFX_depth.so
│   └── libVkLayer_VulkanFX_simple.so
├── config/
├── docs/
├── scripts/
└── fx/
```

### Android Bionic Package
```
VulkanFX-android-bionic-arm64.tar.gz
├── lib/
│   ├── libVkLayer_VulkanFX_default.so (Bionic, ARM64)
│   ├── libVkLayer_VulkanFX_depth.so
│   └── libVkLayer_VulkanFX_simple.so
├── config/
├── docs/
└── fx/
```

## 🎯 Use Cases

### Desktop Linux (Glibc)
```bash
# Download Linux package
tar -xzf VulkanFX-linux-glibc-x86_64.tar.gz
cd linux-glibc-x86_64
./install.sh
```

**For:** Native Linux gaming, development

### Android/Termux/Winlator (Bionic)
```bash
# Download Android package
tar -xzf VulkanFX-android-bionic-arm64.tar.gz
cd android-bionic-arm64
cp lib/*.so ~/.local/lib/
```

**For:** Termux, Winlator, Android games

## ✅ Summary

**Primary Build System:** Meson
- ✅ Linux (Glibc) - Meson
- ✅ Android (Bionic) - Meson + NDK

**Alternative:** CMake (Linux only)

**GitHub Actions:**
- Builds both Glibc and Bionic versions
- Uses Meson for consistency
- Provides separate artifacts for each platform

**Current Build (Termux):**
- ✅ Bionic (Android)
- ✅ ARM64
- ✅ Built with Meson + NDK
- ✅ Perfect for Winlator!
