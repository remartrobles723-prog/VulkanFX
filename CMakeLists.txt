cmake_minimum_required(VERSION 3.15)
project(VulkanFX VERSION 0.4.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra")

# Find packages
find_package(Vulkan REQUIRED)
find_package(X11 REQUIRED)

# Options
option(DISABLE_RESHADEFX "Disable ReShade FX support" OFF)
option(BUILD_ALL_VARIANTS "Build all variants (default, simple, depth)" ON)

# Common sources
set(COMMON_SOURCES
    src/basalt.cpp
    src/buffer.cpp
    src/command_buffer.cpp
    src/config.cpp
    src/descriptor_set.cpp
    src/effect.cpp
    src/effect_cas.cpp
    src/effect_dls.cpp
    src/effect_fxaa.cpp
    src/effect_lut.cpp
    src/effect_smaa.cpp
    src/effect_deband.cpp
    src/effect_simple.cpp
    src/effect_transfer.cpp
    src/fake_swapchain.cpp
    src/format.cpp
    src/framebuffer.cpp
    src/graphics_pipeline.cpp
    src/image.cpp
    src/image_view.cpp
    src/keyboard_input.cpp
    src/keyboard_input_x11.cpp
    src/logical_swapchain.cpp
    src/logger.cpp
    src/memory.cpp
    src/renderpass.cpp
    src/sampler.cpp
    src/shader.cpp
    src/vma_usage.cpp
)

# ReShade sources
set(RESHADE_SOURCES
    src/effect_reshade.cpp
    src/reshade_uniforms.cpp
)

# Common include directories
set(COMMON_INCLUDES
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}/subprojects/vkroots/include
    ${CMAKE_CURRENT_SOURCE_DIR}/subprojects/stb
    ${Vulkan_INCLUDE_DIRS}
    ${X11_INCLUDE_DIR}
)

# ReShade include directories
set(RESHADE_INCLUDES
    ${CMAKE_CURRENT_SOURCE_DIR}/subprojects/reshade/include
    ${CMAKE_CURRENT_SOURCE_DIR}/subprojects/reshade/deps/vma/include
)

# Common compile definitions
set(COMMON_DEFINITIONS
    VK_USE_PLATFORM_XLIB_KHR
)

# Default variant (with ReShade)
add_library(VkLayer_VulkanFX_default SHARED
    ${COMMON_SOURCES}
    ${RESHADE_SOURCES}
)

target_include_directories(VkLayer_VulkanFX_default PRIVATE
    ${COMMON_INCLUDES}
    ${RESHADE_INCLUDES}
)

target_compile_definitions(VkLayer_VulkanFX_default PRIVATE
    ${COMMON_DEFINITIONS}
)

target_link_libraries(VkLayer_VulkanFX_default
    ${Vulkan_LIBRARIES}
    ${X11_LIBRARIES}
    dl
    pthread
)

set_target_properties(VkLayer_VulkanFX_default PROPERTIES
    OUTPUT_NAME "VkLayer_VulkanFX_default"
    PREFIX "lib"
)

if(BUILD_ALL_VARIANTS)
    # Simple variant (no ReShade)
    add_library(VkLayer_VulkanFX_simple SHARED
        ${COMMON_SOURCES}
    )
    
    target_include_directories(VkLayer_VulkanFX_simple PRIVATE
        ${COMMON_INCLUDES}
    )
    
    target_compile_definitions(VkLayer_VulkanFX_simple PRIVATE
        ${COMMON_DEFINITIONS}
        DISABLE_RESHADEFX=1
    )
    
    target_link_libraries(VkLayer_VulkanFX_simple
        ${Vulkan_LIBRARIES}
        ${X11_LIBRARIES}
        dl
        pthread
    )
    
    set_target_properties(VkLayer_VulkanFX_simple PROPERTIES
        OUTPUT_NAME "VkLayer_VulkanFX_simple"
        PREFIX "lib"
    )

    # Depth variant
    add_library(VkLayer_VulkanFX_depth SHARED
        ${COMMON_SOURCES}
        ${RESHADE_SOURCES}
    )
    
    target_include_directories(VkLayer_VulkanFX_depth PRIVATE
        ${COMMON_INCLUDES}
        ${RESHADE_INCLUDES}
    )
    
    target_compile_definitions(VkLayer_VulkanFX_depth PRIVATE
        ${COMMON_DEFINITIONS}
        ENABLE_DEPTH_CAPTURE=1
    )
    
    target_link_libraries(VkLayer_VulkanFX_depth
        ${Vulkan_LIBRARIES}
        ${X11_LIBRARIES}
        dl
        pthread
    )
    
    set_target_properties(VkLayer_VulkanFX_depth PROPERTIES
        OUTPUT_NAME "VkLayer_VulkanFX_depth"
        PREFIX "lib"
    )
endif()

# Install targets
install(TARGETS VkLayer_VulkanFX_default
    LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
)

if(BUILD_ALL_VARIANTS)
    install(TARGETS VkLayer_VulkanFX_simple VkLayer_VulkanFX_depth
        LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
    )
endif()

# Install layer manifest
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/build/config/VulkanFX.json
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/vulkan/implicit_layer.d
    OPTIONAL
)

# Print build information
message(STATUS "VulkanFX Build Configuration:")
message(STATUS "  Version: ${PROJECT_VERSION}")
message(STATUS "  C++ Standard: ${CMAKE_CXX_STANDARD}")
message(STATUS "  Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "  Vulkan: ${Vulkan_LIBRARIES}")
message(STATUS "  X11: ${X11_LIBRARIES}")
message(STATUS "  Build All Variants: ${BUILD_ALL_VARIANTS}")
message(STATUS "  Disable ReShade: ${DISABLE_RESHADEFX}")
