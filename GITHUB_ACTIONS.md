# GitHub Actions CI/CD for VulkanFX

## 🚀 Automated Builds

VulkanFX now has **automated builds** using GitHub Actions!

## 📋 Available Workflows

### 1. Build Workflow (`build.yml`)

**Triggers:**
- Push to VulkanFX, main, or master branches
- Pull requests
- Manual dispatch

**Jobs:**
- ✅ **build-meson** - Build with Meson on Ubuntu
- ✅ **build-cmake** - Build with CMake on Ubuntu
- ✅ **build-android** - Build for Android ARM64 with NDK
- ✅ **build-multi-arch** - Build for multiple architectures
- ✅ **create-release** - Create release package

**Artifacts:**
- `vulkanfx-meson-ubuntu` - Meson build libraries
- `vulkanfx-cmake-ubuntu` - CMake build libraries
- `vulkanfx-android-arm64` - Android libraries
- `vulkanfx-release-package` - Complete release package

### 2. Test Workflow (`test.yml`)

**Triggers:**
- Push to VulkanFX, main, or master branches
- Pull requests

**Jobs:**
- ✅ **test-build** - Build and validate libraries
- ✅ **test-compatibility** - Test Vulkan compatibility
- ✅ **code-quality** - Run cppcheck and quality checks

**Checks:**
- Library validation (file type, symbols)
- JSON manifest validation
- Vulkan SDK compatibility
- Code quality analysis

### 3. Release Workflow (`release.yml`)

**Triggers:**
- Git tags (v*)
- Manual dispatch

**Jobs:**
- ✅ **build-release** - Build for Linux and Android
- ✅ **create-github-release** - Create GitHub release with artifacts

**Platforms:**
- Linux x86_64
- Android ARM64

## 🎯 How to Use

### Automatic Builds

Every push to the VulkanFX branch automatically:
1. Builds with Meson
2. Builds with CMake
3. Builds for Android
4. Runs tests
5. Creates artifacts

### Download Build Artifacts

1. Go to: https://github.com/remartrobles723-prog/VulkanFX/actions
2. Click on latest workflow run
3. Scroll to "Artifacts" section
4. Download the build you need

### Manual Build Trigger

1. Go to Actions tab
2. Select "Build VulkanFX" workflow
3. Click "Run workflow"
4. Select branch
5. Click "Run workflow" button

### Create a Release

**Method 1: Git Tag**
```bash
git tag v0.4.1
git push origin v0.4.1
```

**Method 2: Manual**
1. Go to Actions tab
2. Select "Create Release" workflow
3. Click "Run workflow"
4. Enter version (e.g., v0.4.1)
5. Click "Run workflow"

## 📦 Build Matrix

### Platforms

| Platform | OS | Arch | Build System |
|----------|-----|------|--------------|
| Ubuntu | Linux | x86_64 | Meson, CMake |
| Android | Linux | ARM64 | CMake + NDK |

### Build Variants

Each build creates:
- `libVkLayer_VulkanFX_default.so` - Full version with ReShade
- `libVkLayer_VulkanFX_depth.so` - With depth capture
- `libVkLayer_VulkanFX_simple.so` - Lightweight (no ReShade)

## 🔍 Workflow Details

### Build Workflow Steps

1. **Checkout** - Clone repository with submodules
2. **Install Dependencies** - Vulkan SDK, X11, build tools
3. **Configure** - Setup Meson or CMake
4. **Build** - Compile all variants
5. **Validate** - Check libraries
6. **Upload** - Save artifacts

### Test Workflow Steps

1. **Build Validation** - Verify libraries are valid ELF files
2. **Symbol Check** - Ensure Vulkan layer symbols exist
3. **Manifest Validation** - Check JSON is valid
4. **Compatibility Test** - Test with vulkaninfo
5. **Code Quality** - Run cppcheck

### Release Workflow Steps

1. **Build All Platforms** - Linux + Android
2. **Package** - Create tar.gz archives
3. **Create Release Notes** - Auto-generate notes
4. **Upload to GitHub** - Create release with artifacts

## 📊 Artifact Contents

### Linux Release Package

```
VulkanFX-linux-x86_64/
├── lib/
│   ├── libVkLayer_VulkanFX_default.so
│   ├── libVkLayer_VulkanFX_depth.so
│   └── libVkLayer_VulkanFX_simple.so
├── config/
│   ├── VulkanFX.conf
│   └── VulkanFX.json
├── docs/
│   ├── README.md
│   ├── BUILD_SYSTEMS.md
│   ├── WINLATOR_GUIDE.md
│   └── CHANGELOG.md
├── scripts/
│   ├── test_reshade.sh
│   ├── complete_test.sh
│   └── ...
└── fx/
    ├── Shaders/
    └── Textures/
```

### Android Release Package

```
VulkanFX-android-arm64/
├── lib/
│   ├── libVkLayer_VulkanFX_default.so
│   ├── libVkLayer_VulkanFX_depth.so
│   └── libVkLayer_VulkanFX_simple.so
├── config/
│   └── VulkanFX.conf
└── docs/
    ├── README.md
    └── WINLATOR_GUIDE.md
```

## 🔧 Customizing Workflows

### Add New Platform

Edit `.github/workflows/build.yml`:

```yaml
build-new-platform:
  name: Build for New Platform
  runs-on: ubuntu-latest
  steps:
    - name: Checkout
      uses: actions/checkout@v4
      with:
        submodules: recursive
    
    - name: Build
      run: |
        # Your build commands
```

### Add New Test

Edit `.github/workflows/test.yml`:

```yaml
test-new-feature:
  name: Test New Feature
  runs-on: ubuntu-latest
  steps:
    - name: Test
      run: |
        # Your test commands
```

## 📈 Build Status

Check build status:
- Badge: `![Build](https://github.com/remartrobles723-prog/VulkanFX/workflows/Build%20VulkanFX/badge.svg)`
- Actions: https://github.com/remartrobles723-prog/VulkanFX/actions

## 🐛 Troubleshooting

### Build Fails

1. Check Actions tab for error logs
2. Look at specific job that failed
3. Review error messages
4. Fix locally and push again

### Artifact Not Created

1. Check if build succeeded
2. Verify upload-artifact step ran
3. Check artifact retention (30-90 days)

### Release Not Created

1. Ensure tag starts with 'v'
2. Check GITHUB_TOKEN permissions
3. Verify release workflow completed

## 💡 Best Practices

### Before Pushing

1. Test locally first
2. Ensure submodules are updated
3. Check that builds work

### Commit Messages

Use clear commit messages:
- `feat: Add new feature`
- `fix: Fix bug`
- `docs: Update documentation`
- `ci: Update workflows`

### Versioning

Follow semantic versioning:
- `v0.4.0` - Major.Minor.Patch
- `v0.4.1` - Bug fixes
- `v0.5.0` - New features
- `v1.0.0` - Stable release

## 🎯 Quick Reference

### Download Latest Build

```bash
# Using GitHub CLI
gh run download --repo remartrobles723-prog/VulkanFX

# Or visit:
# https://github.com/remartrobles723-prog/VulkanFX/actions
```

### Trigger Manual Build

```bash
# Using GitHub CLI
gh workflow run build.yml --repo remartrobles723-prog/VulkanFX

# Or use web interface
```

### Create Release

```bash
# Tag and push
git tag v0.4.1
git push origin v0.4.1

# Release will be created automatically
```

## ✅ Workflow Status

| Workflow | Status | Purpose |
|----------|--------|---------|
| Build | ✅ Active | Build all platforms |
| Test | ✅ Active | Validate builds |
| Release | ✅ Active | Create releases |

## 🔗 Links

- **Actions**: https://github.com/remartrobles723-prog/VulkanFX/actions
- **Releases**: https://github.com/remartrobles723-prog/VulkanFX/releases
- **Workflows**: https://github.com/remartrobles723-prog/VulkanFX/tree/VulkanFX/.github/workflows

---

**Automated builds make development easier!** 🚀

Every push is automatically built and tested!
