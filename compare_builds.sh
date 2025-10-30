#!/bin/bash

echo "╔════════════════════════════════════════════════════════════╗"
echo "║         CMake vs Meson Build Comparison                  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 LIBRARY LOCATIONS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "CMake Build (build_cmake/):"
if [ -d "build_cmake" ]; then
    ls -lh build_cmake/libVkLayer_VulkanFX_*.so 2>/dev/null | awk '{print "  ✅ " $9 " - " $5}'
    if [ $? -ne 0 ]; then
        echo "  ❌ No libraries found"
    fi
else
    echo "  ❌ build_cmake/ directory not found"
fi

echo ""
echo "Meson Build (build/src/):"
if [ -d "build/src" ]; then
    ls -lh build/src/libVkLayer_VulkanFX_*.so 2>/dev/null | awk '{print "  ✅ " $9 " - " $5}'
    if [ $? -ne 0 ]; then
        echo "  ❌ No libraries found"
    fi
else
    echo "  ❌ build/src/ directory not found"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 RESHADE LIBRARIES"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "CMake Build:"
if [ -d "build_cmake/subprojects/reshade" ]; then
    ls -lh build_cmake/subprojects/reshade/libReShadeFX*.so.*.*.* 2>/dev/null | awk '{print "  ✅ " $9 " - " $5}'
    if [ $? -ne 0 ]; then
        echo "  ❌ No ReShade libraries found"
    fi
else
    echo "  ❌ ReShade directory not found"
fi

echo ""
echo "Meson Build:"
if [ -d "build/src" ]; then
    ls -lh build/src/libReShadeFX*.so 2>/dev/null | awk '{print "  ✅ " $9 " - " $5}'
    if [ $? -ne 0 ]; then
        echo "  ❌ No ReShade libraries found"
    fi
else
    echo "  ❌ build/src/ directory not found"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 LAYER CONFIGURATION FILES"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "CMake Build:"
if [ -f "build_cmake/config/VulkanFX.json" ]; then
    echo "  ✅ build_cmake/config/VulkanFX.json"
    echo "     Points to: build_cmake/libVkLayer_VulkanFX_*.so"
else
    echo "  ❌ build_cmake/config/VulkanFX.json NOT FOUND"
fi

echo ""
echo "Meson Build:"
if [ -f "build/config/VulkanFX.json" ]; then
    echo "  ✅ build/config/VulkanFX.json"
    echo "     Points to: build/src/libVkLayer_VulkanFX_*.so"
else
    echo "  ❌ build/config/VulkanFX.json NOT FOUND"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧪 TEST SCRIPTS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "For CMake Build:"
if [ -f "test_cmake_build_fixed.sh" ]; then
    echo "  ✅ test_cmake_build_fixed.sh (CORRECT)"
    echo "     Uses: build_cmake/"
else
    echo "  ❌ test_cmake_build_fixed.sh NOT FOUND"
fi

echo ""
echo "For Meson Build:"
if [ -f "test_reshade.sh" ]; then
    echo "  ✅ test_reshade.sh"
    echo "     Uses: build/src/"
else
    echo "  ❌ test_reshade.sh NOT FOUND"
fi

echo ""
echo "⚠️  INCORRECT (uses Meson build):"
if [ -f "test_cmake_build.sh" ]; then
    echo "  ⚠️  test_cmake_build.sh"
    echo "     Claims to test CMake but uses: build/src/ (WRONG!)"
else
    echo "  ❌ test_cmake_build.sh NOT FOUND"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 SIZE COMPARISON"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ -f "build_cmake/libVkLayer_VulkanFX_default.so" ] && [ -f "build/src/libVkLayer_VulkanFX_default.so" ]; then
    CMAKE_SIZE=$(stat -c%s build_cmake/libVkLayer_VulkanFX_default.so 2>/dev/null || stat -f%z build_cmake/libVkLayer_VulkanFX_default.so 2>/dev/null)
    MESON_SIZE=$(stat -c%s build/src/libVkLayer_VulkanFX_default.so 2>/dev/null || stat -f%z build/src/libVkLayer_VulkanFX_default.so 2>/dev/null)
    
    echo "libVkLayer_VulkanFX_default.so:"
    echo "  CMake: $(numfmt --to=iec-i --suffix=B $CMAKE_SIZE 2>/dev/null || echo $CMAKE_SIZE bytes)"
    echo "  Meson: $(numfmt --to=iec-i --suffix=B $MESON_SIZE 2>/dev/null || echo $MESON_SIZE bytes)"
    
    if [ "$CMAKE_SIZE" -eq "$MESON_SIZE" ]; then
        echo "  Status: Same size ✅"
    else
        DIFF=$((CMAKE_SIZE - MESON_SIZE))
        echo "  Difference: $DIFF bytes"
    fi
else
    echo "  ⚠️  Cannot compare - one or both builds missing"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

CMAKE_EXISTS=false
MESON_EXISTS=false

if [ -f "build_cmake/libVkLayer_VulkanFX_default.so" ]; then
    CMAKE_EXISTS=true
fi

if [ -f "build/src/libVkLayer_VulkanFX_default.so" ]; then
    MESON_EXISTS=true
fi

if [ "$CMAKE_EXISTS" = true ]; then
    echo "CMake Build: ✅ Available"
    echo "  Test with: ./test_cmake_build_fixed.sh"
else
    echo "CMake Build: ❌ Not found"
    echo "  Build with: mkdir -p build_cmake && cd build_cmake && cmake .. && make"
fi

echo ""

if [ "$MESON_EXISTS" = true ]; then
    echo "Meson Build: ✅ Available"
    echo "  Test with: ./test_reshade.sh"
else
    echo "Meson Build: ❌ Not found"
    echo "  Build with: meson setup build && ninja -C build"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
