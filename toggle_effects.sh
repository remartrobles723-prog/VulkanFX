#!/bin/bash

CONFIG="$HOME/.config/VulkanFX/VulkanFX.conf"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║         VulkanFX Effects Toggle                           ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

if [ ! -f "$CONFIG" ]; then
    echo "❌ Config file not found: $CONFIG"
    exit 1
fi

# Check current state
if grep -q "enableOnLaunch = True" "$CONFIG"; then
    CURRENT="ENABLED"
    NEW="DISABLED"
    sed -i 's/enableOnLaunch = True/enableOnLaunch = False/' "$CONFIG"
elif grep -q "enableOnLaunch = False" "$CONFIG"; then
    CURRENT="DISABLED"
    NEW="ENABLED"
    sed -i 's/enableOnLaunch = False/enableOnLaunch = True/' "$CONFIG"
else
    echo "⚠️  enableOnLaunch not found in config, adding it..."
    echo "enableOnLaunch = True" >> "$CONFIG"
    CURRENT="UNKNOWN"
    NEW="ENABLED"
fi

echo "Effects were: $CURRENT"
echo "Effects now: $NEW"
echo ""
echo "✓ Config updated!"
echo ""
echo "To apply changes:"
echo "  1. Stop vkcube (Ctrl+C)"
echo "  2. Restart: vkcube"
echo ""
echo "Or run: ./restart_vkcube.sh"
