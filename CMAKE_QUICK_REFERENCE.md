# CMake Quick Reference for VulkanFX

## Basic Commands

### Configure
```bash
cmake -S . -B build_cmake
```

### Build
```bash
cmake --build build_cmake
```

### Install
```bash
cmake --build build_cmake --target install
```

### Clean
```bash
rm -rf build_cmake
```

## Common Build Configurations

### Release Build (Optimized)
```bash
cmake -S . -B build_cmake -DCMAKE_BUILD_TYPE=Release
cmake --build build_cmake -j$(nproc)
```

### Debug Build
```bash
cmake -S . -B build_cmake -DCMAKE_BUILD_TYPE=Debug
cmake --build build_cmake
```

### Build Only Default Variant
```bash
cmake -S . -B build_cmake -DBUILD_ALL_VARIANTS=OFF
cmake --build build_cmake
```

### Custom Install Location
```bash
cmake -S . -B build_cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local
cmake --build build_cmake --target install
```

## Termux-Specific

### Install Dependencies
```bash
pkg install cmake clang vulkan-headers vulkan-loader-android \
    vulkan-tools libx11 pkg-config spirv-headers
```

### Build (Low Memory)
```bash
cmake -S . -B build_cmake -DCMAKE_BUILD_TYPE=Release
cmake --build build_cmake -j1  # Single job to save memory
```

## Build Options

| Option | Values | Default | Description |
|--------|--------|---------|-------------|
| `CMAKE_BUILD_TYPE` | Release, Debug, RelWithDebInfo | - | Build type |
| `BUILD_ALL_VARIANTS` | ON, OFF | ON | Build all 3 variants |
| `DISABLE_RESHADEFX` | ON, OFF | OFF | Disable ReShade |
| `WITH_SO` | ON, OFF | ON | Install libraries |
| `WITH_JSON` | ON, OFF | ON | Install JSON files |
| `CMAKE_INSTALL_PREFIX` | path | /usr/local | Install location |

### Example with Options
```bash
cmake -S . -B build_cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_ALL_VARIANTS=ON \
    -DCMAKE_INSTALL_PREFIX=/usr/local
```

## Parallel Building

### Auto-detect CPU cores
```bash
cmake --build build_cmake -j$(nproc)
```

### Specific number of jobs
```bash
cmake --build build_cmake -j4
```

### Single job (for low memory)
```bash
cmake --build build_cmake -j1
```

## Verbose Output

### Verbose build
```bash
cmake --build build_cmake --verbose
```

### Or with make
```bash
make -C build_cmake VERBOSE=1
```

## Troubleshooting

### Check CMake version
```bash
cmake --version
```

### List all targets
```bash
cmake --build build_cmake --target help
```

### Reconfigure
```bash
cmake -S . -B build_cmake --fresh
```

### View build configuration
```bash
cat build_cmake/CMakeCache.txt | grep -E "CMAKE_BUILD_TYPE|BUILD_ALL"
```

## Comparison: Meson vs CMake

| Task | Meson | CMake |
|------|-------|-------|
| Configure | `meson setup build` | `cmake -S . -B build_cmake` |
| Build | `ninja -C build` | `cmake --build build_cmake` |
| Install | `ninja -C build install` | `cmake --build build_cmake --target install` |
| Clean | `ninja -C build clean` | `cmake --build build_cmake --target clean` |
| Reconfigure | `meson setup --reconfigure build` | `cmake -S . -B build_cmake` |
| Set option | `meson configure build -Doption=value` | `cmake -S . -B build_cmake -DOPTION=VALUE` |

## Output Files

After building, find:
- **Libraries**: `build_cmake/libVkLayer_VulkanFX_*.so`
- **Shader headers**: `build_cmake/*.h`
- **ReShade libs**: `build_cmake/subprojects/reshade/libReShadeFX*.so`

## Installation Paths

Default installation (CMAKE_INSTALL_PREFIX=/usr/local):
- Libraries: `/usr/local/lib/`
- JSON manifests: `/usr/local/share/vulkan/implicit_layer.d/`

Custom installation (CMAKE_INSTALL_PREFIX=$HOME/.local):
- Libraries: `$HOME/.local/lib/`
- JSON manifests: `$HOME/.local/share/vulkan/implicit_layer.d/`

## Quick Tips

1. **First time building?** Use Release mode:
   ```bash
   cmake -S . -B build_cmake -DCMAKE_BUILD_TYPE=Release
   ```

2. **Out of memory?** Build with single job:
   ```bash
   cmake --build build_cmake -j1
   ```

3. **Want faster rebuilds?** Use ccache:
   ```bash
   export CMAKE_CXX_COMPILER_LAUNCHER=ccache
   cmake -S . -B build_cmake
   ```

4. **IDE user?** Generate compile_commands.json:
   ```bash
   cmake -S . -B build_cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
   ```

5. **Need to start over?**
   ```bash
   rm -rf build_cmake && cmake -S . -B build_cmake
   ```
