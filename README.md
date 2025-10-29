# VulkanFX - Vulkan Post-Processing Layer

Post-processing layer for Vulkan with ReShade FX support.

## 🚀 Quick Start

### Clone
```bash
git clone --recursive -b VulkanFX https://github.com/remartrobles723-prog/VulkanFX.git
cd VulkanFX
```

### Build
```bash
meson setup build
ninja -C build
```

### Use
```bash
export VK_LAYER_PATH="$PWD/build/config"
export ENABLE_VULKANFX=1
vkcube
```

## 📋 Features

- **CAS** - Contrast Adaptive Sharpening
- **FXAA** - Fast Approximate Anti-Aliasing  
- **SMAA** - Subpixel Morphological Anti-Aliasing
- **DLS** - Deep Learning Super Sampling
- **ReShade FX** - Custom shader support
- **Vulkan 1.0+** compatible

## 🎮 Configuration

Edit `~/.config/VulkanFX/VulkanFX.conf`:

```ini
effects = cas:fxaa
casSharpness = 0.7
toggleKey = Home
enableOnLaunch = True
```

## 📚 Documentation

- [BUILD_SYSTEMS.md](BUILD_SYSTEMS.md) - Build with CMake, Meson, Android Studio
- [WINLATOR_GUIDE.md](WINLATOR_GUIDE.md) - Use with Winlator/Wine/Proton
- [RESHADE_GUIDE.md](RESHADE_GUIDE.md) - ReShade effects guide
- [CHANGELOG.md](CHANGELOG.md) - Version history

## 🔧 Build Systems

- **Meson** (primary)
- **CMake** (alternative)
- **Android Studio** (NDK)

## 📦 Platforms

- **Linux** (Glibc, x86_64)
- **Android** (Bionic, ARM64) - Termux, Winlator

## ⚙️ Requirements

- Vulkan 1.0+
- X11 (for keyboard input)
- Meson + Ninja or CMake

## 📄 License

See [LICENSE](LICENSE)

## 🔗 Links

- **Original**: [vkBasalt](https://github.com/DadSchoorse/vkBasalt)
- **Fork**: [VulkanFX](https://github.com/pchome/VulkanFX)
- **This Build**: Termux/Android optimized
