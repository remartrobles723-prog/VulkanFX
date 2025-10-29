# VulkanFX Toggle Key & ReShade UI Guide

## 🔑 Toggle Key Issue

### Problem
The HOME key toggle only works on first launch, not during runtime.

### Why This Happens
The keyboard input detection in X11 might not be capturing the Home key properly on Android/Termux.

### Solutions

#### Option 1: Try Different Keys
Edit `~/.config/VulkanFX/VulkanFX.conf`:

```ini
# Try these keys instead of Home:
toggleKey = F12
# or
toggleKey = Pause
# or
toggleKey = Insert
# or  
toggleKey = End
```

#### Option 2: Use Keyboard Keys
If you have a physical/Bluetooth keyboard:

```ini
toggleKey = F1
toggleKey = F2
toggleKey = F12
```

#### Option 3: Restart to Toggle
Currently, the most reliable way:
1. Stop vkcube (Ctrl+C)
2. Edit config to change `enableOnLaunch`
3. Restart vkcube

```bash
# To disable effects
nano ~/.config/VulkanFX/VulkanFX.conf
# Change: enableOnLaunch = False

# To enable effects
# Change: enableOnLaunch = True
```

### Available Key Names

Common X11 key names you can try:
- `F1` through `F12`
- `Home`, `End`, `Insert`, `Delete`
- `Page_Up`, `Page_Down`
- `Pause`, `Scroll_Lock`
- `Return` (Enter)
- `space`
- `Escape`

## 🎨 ReShade UI / Overlay

### Current Status
❌ **ReShade UI is NOT currently integrated** in VulkanFX

### What's Missing
VulkanFX uses ReShade's shader compiler but doesn't include:
- The ReShade overlay/GUI
- Runtime parameter adjustment
- Effect tweaking UI

### What You CAN Do

#### 1. Edit Config File
Adjust effect parameters in `~/.config/VulkanFX/VulkanFX.conf`:

```ini
# For Daltonize effect
effects = Daltonize
Daltonize = /path/to/Daltonize.fx

# You can add uniform values (if the shader supports them)
# Check the shader file for available uniforms
```

#### 2. Check Shader Source
Look at the shader file to see available parameters:

```bash
cat fx/Shaders/Daltonize.fx
```

Look for `uniform` declarations like:
```hlsl
uniform int Type <
    ui_type = "combo";
    ui_items = "Protanopia\0Deuteranopia\0Tritanopia\0";
> = 0;
```

#### 3. Add Parameters to Config
Some shaders allow configuration via config file:

```ini
effects = Daltonize
Daltonize = /path/to/Daltonize.fx

# Add shader-specific parameters
Daltonize_Type = 0  # Try different values
```

### Why No UI?

The ReShade overlay requires:
1. Integration with the rendering pipeline
2. ImGui or similar UI framework
3. Input handling for UI interaction
4. Significant additional code

VulkanFX currently focuses on:
- ✅ ReShade shader compilation
- ✅ Effect application
- ❌ Runtime UI (not implemented)

### Workaround: Multiple Configs

Create different config files for different settings:

```bash
# Create configs
cp ~/.config/VulkanFX/VulkanFX.conf ~/.config/VulkanFX/daltonize_type0.conf
cp ~/.config/VulkanFX/VulkanFX.conf ~/.config/VulkanFX/daltonize_type1.conf

# Edit each with different parameters
nano ~/.config/VulkanFX/daltonize_type0.conf
# Set Type = 0

nano ~/.config/VulkanFX/daltonize_type1.conf
# Set Type = 1

# Switch between them
cp ~/.config/VulkanFX/daltonize_type0.conf ~/.config/VulkanFX/VulkanFX.conf
# Restart vkcube
```

## 🔧 Practical Toggle Solutions

### Method 1: Script to Toggle
Create a toggle script:

```bash
#!/bin/bash
# toggle_effects.sh

CONFIG="$HOME/.config/VulkanFX/VulkanFX.conf"

if grep -q "enableOnLaunch = True" "$CONFIG"; then
    sed -i 's/enableOnLaunch = True/enableOnLaunch = False/' "$CONFIG"
    echo "Effects DISABLED"
else
    sed -i 's/enableOnLaunch = False/enableOnLaunch = True/' "$CONFIG"
    echo "Effects ENABLED"
fi

echo "Restart vkcube to apply"
```

### Method 2: Quick Restart Script
```bash
#!/bin/bash
# restart_vkcube.sh

pkill vkcube
sleep 1
export DISPLAY=:0
export ENABLE_VULKANFX=1
vkcube &
```

### Method 3: Test Both States
```bash
# Run with effects
export ENABLE_VULKANFX=1
vkcube &

# Run without effects (in another window)
export ENABLE_VULKANFX=0
vkcube &
```

## 📊 Summary

| Feature | Status | Workaround |
|---------|--------|------------|
| Toggle Key | ⚠️ Unreliable | Restart with different config |
| ReShade UI | ❌ Not available | Edit config file manually |
| Effect Parameters | ⚠️ Limited | Check shader source, edit config |
| Runtime Tweaking | ❌ Not available | Create multiple configs |

## 💡 Recommendations

1. **For Testing**: Use `enableOnLaunch` and restart
2. **For Different Effects**: Create multiple config files
3. **For Parameters**: Read shader source to find uniforms
4. **For Toggle**: Try different keys (F12, Pause, etc.)

## 🔮 Future Possibilities

To add ReShade UI support would require:
- Integrating `reshade_overlay.hpp`
- Adding ImGui rendering
- Implementing UI input handling
- Creating parameter binding system

This is a significant undertaking but technically possible!

---

**For now, the best workflow is:**
1. Edit config file
2. Restart vkcube
3. See changes
