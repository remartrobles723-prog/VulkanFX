# VulkanFX with ReShade Effects

## 🎨 ReShade Daltonize Effect - VERY VISIBLE!

The Daltonize effect **changes colors dramatically** - you'll definitely see it!

### What is Daltonize?
- Simulates color blindness (Protanopia, Deuteranopia, or Tritanopia)
- **Changes the entire color palette**
- Makes reds/greens/blues shift
- **INSTANT visible difference** when toggled

## 🚀 Quick Test

```bash
./easy_compare.sh
```

Then **press HOME key** - you'll see the colors change immediately!

## 📁 ReShade Files

Your ReShade shaders are in: `fx/`

Available effects:
- **Daltonize.fx** ⭐ (Currently enabled - changes colors!)
- **Deband.fx** (Reduces color banding)
- **LUT.fx** (Color lookup table)
- **DisplayDepth.fx** (Shows depth buffer)
- **UIMask.fx** (UI masking)

## ⚙️ Configuration

File: `~/.config/VulkanFX/VulkanFX.conf`

Current settings:
```ini
effects = reshade
reshadeTexturePath = "/data/data/com.termux/files/home/VulkanFX/fx/Textures"
reshadeIncludePath = "/data/data/com.termux/files/home/VulkanFX/fx/Shaders"
reshadeEffectPath = "/data/data/com.termux/files/home/VulkanFX/fx/Shaders/Daltonize.fx"
toggleKey = Home
```

## 🔄 Try Different Effects

### Use Deband instead:
```bash
nano ~/.config/VulkanFX/VulkanFX.conf

# Change this line:
reshadeEffectPath = "/data/data/com.termux/files/home/VulkanFX/fx/Shaders/Deband.fx"
```

### Use LUT (Color Grading):
```bash
nano ~/.config/VulkanFX/VulkanFX.conf

# Change this line:
reshadeEffectPath = "/data/data/com.termux/files/home/VulkanFX/fx/Shaders/LUT.fx"
```

## 👀 What You'll See

### With Daltonize ON:
- ✅ **Colors shift dramatically**
- ✅ Reds may become brownish
- ✅ Greens may shift
- ✅ Blues may change
- ✅ **VERY obvious difference!**

### With Daltonize OFF:
- Normal colors
- Standard rendering

## 💡 Pro Tips

1. **Use fullscreen** - `./easy_compare.sh`
2. **Press HOME key repeatedly** - See instant color changes
3. **Look at the gears** - They'll change color!
4. **Try different effects** - Edit the config file

## 🔧 Troubleshooting

**No color change?**
- Make sure you're using: `export ENABLE_VULKANFX=1` (default variant)
- NOT `simple` or `depth` - only default has ReShade support!
- Check config: `cat ~/.config/VulkanFX/VulkanFX.conf`

**Effect not loading?**
- Verify paths are correct
- Check: `ls fx/Shaders/Daltonize.fx`
- Make sure Textures folder exists: `ls fx/Textures/`

**Want to go back to simple effects?**
```bash
nano ~/.config/VulkanFX/VulkanFX.conf

# Change to:
effects = cas:cas:dls
# Remove or comment out reshade lines
```

## 📊 Performance

ReShade effects may impact FPS:
- **Daltonize**: Minimal impact (~5% FPS drop)
- **Deband**: Moderate impact (~10-15% FPS drop)
- **Worth it**: Much more visible effects!

## ✅ Verification

The ReShade effect is working if:
- ✅ Pressing HOME key changes colors
- ✅ The change is INSTANT and OBVIOUS
- ✅ Colors shift noticeably
- ✅ You can toggle back and forth

---

**Try it now!** 🎉

```bash
./easy_compare.sh
# Press HOME key and watch the colors change!
```
