#!/bin/bash

echo "=== VulkanFX Library Test ==="
echo ""

# Check if libraries exist
echo "1. Checking built libraries..."
for lib in build/src/libVkLayer_VulkanFX_*.so; do
    if [ -f "$lib" ]; then
        echo "  ✓ Found: $(basename $lib)"
        file "$lib" | grep -q "ELF" && echo "    → Valid ELF shared object"
    fi
done
echo ""

# Check configuration
echo "2. Checking configuration files..."
if [ -f "build/config/VulkanFX.json" ]; then
    echo "  ✓ Layer manifest: build/config/VulkanFX.json"
fi
if [ -f "config/VulkanFX.conf" ]; then
    echo "  ✓ Configuration: config/VulkanFX.conf"
fi
echo ""

# Check if Vulkan is available
echo "3. Checking Vulkan availability..."
if command -v vulkaninfo &> /dev/null; then
    echo "  ✓ vulkaninfo is available"
    echo ""
    echo "4. Testing with vulkaninfo..."
    echo "   Setting ENABLE_VULKANFX=1 and VK_LAYER_PATH..."
    export VK_LAYER_PATH="$(pwd)/build/config"
    export ENABLE_VULKANFX=1
    
    # Run vulkaninfo and check for VulkanFX
    if vulkaninfo 2>&1 | grep -q "VulkanFX\|VULKANFX"; then
        echo "  ✓ VulkanFX layer detected by Vulkan!"
    else
        echo "  ⚠ VulkanFX layer not detected (this might be normal if not installed)"
    fi
else
    echo "  ⚠ vulkaninfo not found. Install with: pkg install vulkan-tools"
fi
echo ""

# Installation instructions
echo "5. To use VulkanFX with applications:"
echo "   export VK_LAYER_PATH=\"$(pwd)/build/config\""
echo "   export ENABLE_VULKANFX=1"
echo "   your-vulkan-app"
echo ""
echo "   Or install system-wide:"
echo "   sudo ninja -C build install"
echo ""

# Configuration
echo "6. Configuration file location:"
echo "   Copy config/VulkanFX.conf to:"
echo "   - ~/.config/VulkanFX/VulkanFX.conf (user)"
echo "   - /etc/VulkanFX.conf (system-wide)"
echo ""

echo "=== Test Complete ==="
