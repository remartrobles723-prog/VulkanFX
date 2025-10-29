# VulkanFX with Winlator Guide

## 🎮 Using VulkanFX with Winlator (Wine/Proton)

**Yes! VulkanFX works with Winlator!** Since Winlator uses Vulkan for rendering Windows games, VulkanFX can enhance them!

## 🚀 Quick Setup

### 1. VulkanFX is Already Installed

VulkanFX layer is installed at:
```
~/.local/share/vulkan/implicit_layer.d/VulkanFX.json
```

This means **any Vulkan application** (including Winlator) will automatically detect it!

### 2. Enable VulkanFX for Winlator

#### Method 1: Environment Variable (Recommended)

In Winlator, add this environment variable:

```bash
ENABLE_VULKANFX=1
```

**How to add in Winlator:**
1. Open Winlator
2. Go to Container settings
3. Find "Environment Variables" section
4. Add: `ENABLE_VULKANFX=1`

#### Method 2: Global Enable

Create a script to launch Winlator with VulkanFX:

```bash
#!/bin/bash
# winlator_vulkanfx.sh

export ENABLE_VULKANFX=1
export VK_LAYER_PATH="$HOME/.local/share/vulkan/implicit_layer.d"

# Launch Winlator
am start -n com.winlator/.MainActivity
```

### 3. Configure Effects

Edit the config file:
```bash
nano ~/.config/VulkanFX/VulkanFX.conf
```

**Recommended for Gaming:**
```ini
# Good balance of quality and performance
effects = cas:fxaa
casSharpness = 0.7
toggleKey = Home
enableOnLaunch = True
```

**For Maximum Quality:**
```ini
# Best visual quality (may reduce FPS)
effects = smaa:cas:dls
casSharpness = 0.8
dlsSharpness = 0.7
smaaEdgeDetection = luma
toggleKey = Home
enableOnLaunch = True
```

**For Performance:**
```ini
# Minimal performance impact
effects = cas
casSharpness = 0.5
toggleKey = Home
enableOnLaunch = True
```

## 🎯 Effect Recommendations by Game Type

### FPS Games (Counter-Strike, Call of Duty, etc.)
```ini
effects = cas:fxaa
casSharpness = 0.6
fxaaQualitySubpix = 0.5
enableOnLaunch = True
```
**Why:** Sharp visuals for spotting enemies, FXAA for smooth edges

### RPG Games (Skyrim, Witcher, etc.)
```ini
effects = smaa:cas:dls
casSharpness = 0.7
dlsSharpness = 0.6
smaaEdgeDetection = color
enableOnLaunch = True
```
**Why:** Beautiful visuals, enhanced textures, smooth edges

### Racing Games (Need for Speed, etc.)
```ini
effects = cas:deband
casSharpness = 0.8
enableOnLaunch = True
```
**Why:** Sharp details, smooth gradients in sky/environment

### Strategy Games (Civilization, etc.)
```ini
effects = cas
casSharpness = 0.5
enableOnLaunch = True
```
**Why:** Clear UI and text, minimal performance impact

## 🔧 Winlator-Specific Setup

### Option 1: Per-Container Configuration

For each Winlator container:

1. **Create container-specific config:**
```bash
mkdir -p ~/.config/VulkanFX/containers/
cp ~/.config/VulkanFX/VulkanFX.conf ~/.config/VulkanFX/containers/gaming.conf
```

2. **Edit for that container:**
```bash
nano ~/.config/VulkanFX/containers/gaming.conf
```

3. **Use in Winlator:**
Add environment variable:
```
VULKANFX_CONFIG_FILE=/data/data/com.termux/files/home/.config/VulkanFX/containers/gaming.conf
```

### Option 2: Game-Specific Profiles

Create different profiles:

```bash
# High quality profile
cat > ~/.config/VulkanFX/high_quality.conf << 'EOF'
effects = smaa:cas:dls
casSharpness = 0.8
dlsSharpness = 0.7
enableOnLaunch = True
EOF

# Performance profile
cat > ~/.config/VulkanFX/performance.conf << 'EOF'
effects = cas
casSharpness = 0.5
enableOnLaunch = True
EOF

# Competitive profile (FPS games)
cat > ~/.config/VulkanFX/competitive.conf << 'EOF'
effects = cas:fxaa
casSharpness = 0.6
fxaaQualitySubpix = 0.5
enableOnLaunch = True
EOF
```

Switch profiles by symlinking:
```bash
ln -sf ~/.config/VulkanFX/high_quality.conf ~/.config/VulkanFX/VulkanFX.conf
```

## 🎮 Testing with Winlator

### 1. Verify VulkanFX is Loading

In Winlator, run a game and check logs:
```bash
# Enable Vulkan layer debug
export VK_LOADER_DEBUG=all
```

Look for:
```
VulkanFX   info: config file: /data/data/com.termux/files/home/.config/VulkanFX/VulkanFX.conf
VulkanFX   info: effects = cas
```

### 2. Compare Performance

**Without VulkanFX:**
```bash
unset ENABLE_VULKANFX
# Run game, note FPS
```

**With VulkanFX:**
```bash
export ENABLE_VULKANFX=1
# Run game, note FPS
```

### 3. Visual Comparison

Take screenshots:
```bash
# Without effects
unset ENABLE_VULKANFX
# Play game, take screenshot

# With effects
export ENABLE_VULKANFX=1
# Play game, take screenshot

# Compare!
```

## 💡 Performance Tips

### 1. Start Conservative
```ini
effects = cas
casSharpness = 0.5
```
Then increase if performance is good.

### 2. Monitor FPS
- Without VulkanFX: Note baseline FPS
- With VulkanFX: Should be 5-15% lower
- If >20% drop, reduce effects

### 3. Effect Performance Impact

| Effect | FPS Impact | Visual Impact |
|--------|-----------|---------------|
| CAS (single) | ~2-5% | Medium |
| CAS (5x) | ~10-15% | High |
| FXAA | ~3-7% | Medium |
| SMAA | ~5-10% | High |
| DLS | ~5-8% | Medium |
| Deband | ~3-5% | Low-Medium |

### 4. Optimize for Your Device

**High-end device (Snapdragon 8 Gen 2+):**
```ini
effects = smaa:cas:dls
```

**Mid-range device (Snapdragon 7 series):**
```ini
effects = cas:fxaa
```

**Low-end device:**
```ini
effects = cas
casSharpness = 0.4
```

## 🔑 Toggle Effects In-Game

Press **HOME** key to toggle effects on/off!

**Note:** Toggle may not work reliably. Alternative:
1. Exit game
2. Run: `./toggle_effects.sh`
3. Restart game

## 🎨 ReShade Effects with Winlator

You can use ReShade shaders too!

```ini
effects = Daltonize
Daltonize = /data/data/com.termux/files/home/VulkanFX/fx/Shaders/Daltonize.fx
reshadeTexturePath = /data/data/com.termux/files/home/VulkanFX/fx/Textures
reshadeIncludePath = /data/data/com.termux/files/home/VulkanFX/fx/Shaders
```

**Available ReShade effects:**
- Daltonize - Color correction
- Deband - Smooth gradients
- DisplayDepth - Depth visualization
- LUT - Color grading

## 📊 Example Configurations

### Configuration 1: Balanced
```ini
# Good for most games
effects = cas:fxaa
casSharpness = 0.6
fxaaQualitySubpix = 0.75
fxaaQualityEdgeThreshold = 0.125
toggleKey = Home
enableOnLaunch = True
```

### Configuration 2: Quality
```ini
# Maximum visual quality
effects = smaa:cas:dls
casSharpness = 0.8
dlsSharpness = 0.7
dlsDenoise = 0.1
smaaEdgeDetection = color
smaaMaxSearchSteps = 32
toggleKey = Home
enableOnLaunch = True
```

### Configuration 3: Performance
```ini
# Minimal FPS impact
effects = cas
casSharpness = 0.5
toggleKey = Home
enableOnLaunch = True
```

### Configuration 4: Competitive FPS
```ini
# For competitive gaming
effects = cas:fxaa
casSharpness = 0.7
fxaaQualitySubpix = 0.5
fxaaQualityEdgeThreshold = 0.063
toggleKey = Home
enableOnLaunch = True
```

## 🐛 Troubleshooting

### VulkanFX Not Loading

**Check layer is installed:**
```bash
ls ~/.local/share/vulkan/implicit_layer.d/VulkanFX.json
```

**Check environment variable:**
```bash
echo $ENABLE_VULKANFX
# Should output: 1
```

**Check Winlator logs:**
Look for VulkanFX messages in Winlator output

### Performance Issues

**Reduce effects:**
```ini
effects = cas
casSharpness = 0.4
```

**Disable temporarily:**
```bash
export ENABLE_VULKANFX=0
```

### Visual Artifacts

**Reduce sharpness:**
```ini
casSharpness = 0.5  # Instead of 1.0
```

**Try different effects:**
```ini
effects = fxaa  # Instead of cas
```

## 📱 Winlator Integration Script

Create a helper script:

```bash
#!/bin/bash
# winlator_vulkanfx.sh

echo "VulkanFX for Winlator"
echo ""
echo "Choose profile:"
echo "  1) Performance"
echo "  2) Balanced"
echo "  3) Quality"
echo "  4) Disable"
echo ""
read -p "Choice: " choice

case $choice in
    1)
        ln -sf ~/.config/VulkanFX/performance.conf ~/.config/VulkanFX/VulkanFX.conf
        echo "✓ Performance profile active"
        ;;
    2)
        ln -sf ~/.config/VulkanFX/balanced.conf ~/.config/VulkanFX/VulkanFX.conf
        echo "✓ Balanced profile active"
        ;;
    3)
        ln -sf ~/.config/VulkanFX/high_quality.conf ~/.config/VulkanFX/VulkanFX.conf
        echo "✓ Quality profile active"
        ;;
    4)
        echo "enableOnLaunch = False" > ~/.config/VulkanFX/VulkanFX.conf
        echo "✓ VulkanFX disabled"
        ;;
esac

echo ""
echo "Restart your game for changes to take effect"
```

## ✅ Success Checklist

- [ ] VulkanFX layer installed
- [ ] Config file created
- [ ] `ENABLE_VULKANFX=1` set in Winlator
- [ ] Effects configured for your game type
- [ ] Tested and verified working
- [ ] Performance acceptable
- [ ] Visual improvement visible

## 🎉 Benefits for Winlator

1. ✅ **Sharper textures** - CAS sharpening
2. ✅ **Smoother edges** - FXAA/SMAA anti-aliasing
3. ✅ **Better colors** - ReShade effects
4. ✅ **No game modification** - Works with any Vulkan game
5. ✅ **Toggle on/off** - Easy to compare
6. ✅ **Per-game configs** - Different settings per game

---

**Enjoy enhanced graphics in Winlator!** 🎮✨

VulkanFX + Winlator = Better gaming on Android!
