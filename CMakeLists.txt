cmake_minimum_required(VERSION 3.15)
project(VulkanFX VERSION 0.4.0 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -fvisibility-inlines-hidden")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra")

# Find packages
find_package(Vulkan REQUIRED)
find_package(X11 REQUIRED)
find_package(PkgConfig REQUIRED)
pkg_check_modules(SPIRV_HEADERS REQUIRED SPIRV-Headers)

# Options
option(DISABLE_RESHADEFX "Disable ReShade FX support" OFF)
option(BUILD_ALL_VARIANTS "Build all variants (default, simple, depth)" ON)
option(WITH_SO "Install the library" ON)
option(WITH_JSON "Install the JSON" ON)
option(APPEND_LIBDIR_VULKANFX "Append 'vulkanfx' to libdir path" OFF)

# Set library directory
set(LIB_DIR "${CMAKE_INSTALL_LIBDIR}")
if(APPEND_LIBDIR_VULKANFX)
    set(LIB_DIR "${LIB_DIR}/vulkanfx")
endif()

# Generate config_paths.hpp
set(SYSCONFDIR "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_SYSCONFDIR}")
set(DATADIR "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_DATADIR}")
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/config_paths.hpp.in"
    "${CMAKE_CURRENT_BINARY_DIR}/config_paths.hpp"
    @ONLY
)

# Find glslangValidator
find_program(GLSLANG_VALIDATOR glslangValidator REQUIRED)

# Shader sources
set(SHADER_GLSL_SOURCES
    src/shader/cas.frag.glsl
    src/shader/deband.frag.glsl
    src/shader/dls.frag.glsl
    src/shader/full_screen_triangle.vert.glsl
    src/shader/fxaa.frag.glsl
    src/shader/lut.frag.glsl
    src/shader/smaa_blend.frag.glsl
    src/shader/smaa_blend.vert.glsl
    src/shader/smaa_edge_color.frag.glsl
    src/shader/smaa_edge_luma.frag.glsl
    src/shader/smaa_edge.vert.glsl
    src/shader/smaa_neighbor.frag.glsl
    src/shader/smaa_neighbor.vert.glsl
)

# Generate shader headers
set(SHADER_GENERATED_HEADERS "")
foreach(GLSL_FILE ${SHADER_GLSL_SOURCES})
    get_filename_component(FILENAME ${GLSL_FILE} NAME)
    # Replace .glsl with .h to preserve the full shader type (frag/vert)
    string(REPLACE ".glsl" ".h" HEADER_NAME "${FILENAME}")
    set(GENERATED_HEADER "${CMAKE_CURRENT_BINARY_DIR}/${HEADER_NAME}")
    list(APPEND SHADER_GENERATED_HEADERS ${GENERATED_HEADER})
    add_custom_command(
        OUTPUT ${GENERATED_HEADER}
        COMMAND ${GLSLANG_VALIDATOR} -V -x ${CMAKE_CURRENT_SOURCE_DIR}/${GLSL_FILE} -o ${GENERATED_HEADER}
        DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${GLSL_FILE}
        COMMENT "Compiling shader ${GLSL_FILE}"
        VERBATIM
    )
endforeach()

# Custom target for shader headers
add_custom_target(generate_shader_headers DEPENDS ${SHADER_GENERATED_HEADERS})

# Build ReShade libraries
add_subdirectory(subprojects/reshade)

# Common sources
set(COMMON_SOURCES
    src/basalt.cpp
    src/buffer.cpp
    src/command_buffer.cpp
    src/config.cpp
    src/descriptor_set.cpp
    src/effect.cpp
    src/effect_simple.cpp
    src/effect_transfer.cpp
    src/fake_swapchain.cpp
    src/format.cpp
    src/framebuffer.cpp
    src/graphics_pipeline.cpp
    src/image.cpp
    src/image_view.cpp
    src/keyboard_input.cpp
    src/logger.cpp
    src/logical_swapchain.cpp
    src/lut_cube.cpp
    src/memory.cpp
    src/renderpass.cpp
    src/sampler.cpp
    src/shader.cpp
    src/stb_image.c
    src/stb_image_resize.c
    src/util.cpp
    src/vma_usage.cpp
)

# Simple effects sources
set(SIMPLE_EFFECTS_SOURCES
    src/effect_cas.cpp
    src/effect_deband.cpp
    src/effect_dls.cpp
    src/effect_fxaa.cpp
    src/effect_lut.cpp
    src/effect_smaa.cpp
)

# ReShade sources
set(RESHADE_SOURCES
    src/effect_reshade.cpp
    src/reshade_uniforms.cpp
)

# X11 keyboard input library (separate to avoid conflicts with unity builds)
add_library(keyboard_input_x11 STATIC src/keyboard_input_x11.cpp)
target_include_directories(keyboard_input_x11 PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_BINARY_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/subprojects/vkroots
    ${X11_INCLUDE_DIR}
)
target_link_libraries(keyboard_input_x11 PRIVATE ${X11_LIBRARIES})
set_target_properties(keyboard_input_x11 PROPERTIES
    CXX_VISIBILITY_PRESET hidden
)

# Simple effects library
add_library(simple_effects STATIC ${SIMPLE_EFFECTS_SOURCES})
add_dependencies(simple_effects generate_shader_headers)
target_include_directories(simple_effects PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_BINARY_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/subprojects/vkroots
    ${CMAKE_CURRENT_SOURCE_DIR}/subprojects/stb
    ${CMAKE_CURRENT_SOURCE_DIR}/subprojects/reshade/include
    ${CMAKE_CURRENT_SOURCE_DIR}/subprojects/reshade/source
    ${CMAKE_CURRENT_SOURCE_DIR}/subprojects/reshade/deps/vma/include
    ${CMAKE_CURRENT_SOURCE_DIR}/subprojects/reshade/deps/vulkan-headers/include
    ${Vulkan_INCLUDE_DIRS}
)
target_link_libraries(simple_effects PRIVATE ReShadeFX)
set_target_properties(simple_effects PROPERTIES
    CXX_VISIBILITY_PRESET hidden
)

# Common include directories
set(COMMON_INCLUDES
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_BINARY_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/subprojects/vkroots
    ${CMAKE_CURRENT_SOURCE_DIR}/subprojects/stb
    ${CMAKE_CURRENT_SOURCE_DIR}/subprojects/reshade/deps/vma/include
    ${CMAKE_CURRENT_SOURCE_DIR}/subprojects/reshade/deps/vulkan-headers/include
    ${Vulkan_INCLUDE_DIRS}
    ${X11_INCLUDE_DIR}
)

# ReShade include directories
set(RESHADE_INCLUDES
    ${CMAKE_CURRENT_SOURCE_DIR}/subprojects/reshade/include
    ${CMAKE_CURRENT_SOURCE_DIR}/subprojects/reshade/source
)

# Common compile definitions
set(COMMON_DEFINITIONS
    VK_USE_PLATFORM_XLIB_KHR
)

# Default variant (with ReShade, no depth capture)
if(WITH_SO)
    add_library(VkLayer_VulkanFX_default SHARED
        ${COMMON_SOURCES}
        ${RESHADE_SOURCES}
    )
    
    add_dependencies(VkLayer_VulkanFX_default generate_shader_headers)
    
    target_include_directories(VkLayer_VulkanFX_default PRIVATE
        ${COMMON_INCLUDES}
        ${RESHADE_INCLUDES}
    )
    
    target_compile_definitions(VkLayer_VulkanFX_default PRIVATE
        ${COMMON_DEFINITIONS}
        DISABLE_DEPTH_CAPTURE=1
    )
    
    target_link_libraries(VkLayer_VulkanFX_default PRIVATE
        keyboard_input_x11
        simple_effects
        ReShadeFX
        ReShadeFX-spirv
        ReShadeFX-vulkan-type-convert
        ${Vulkan_LIBRARIES}
        ${X11_LIBRARIES}
        dl
        pthread
    )
    
    set_target_properties(VkLayer_VulkanFX_default PROPERTIES
        OUTPUT_NAME "VkLayer_VulkanFX_default"
        PREFIX "lib"
        CXX_VISIBILITY_PRESET hidden
    )
endif()

if(BUILD_ALL_VARIANTS AND WITH_SO)
    # Simple variant (no ReShade, no depth capture)
    add_library(VkLayer_VulkanFX_simple SHARED
        ${COMMON_SOURCES}
    )
    
    add_dependencies(VkLayer_VulkanFX_simple generate_shader_headers)
    
    target_include_directories(VkLayer_VulkanFX_simple PRIVATE
        ${COMMON_INCLUDES}
    )
    
    target_compile_definitions(VkLayer_VulkanFX_simple PRIVATE
        ${COMMON_DEFINITIONS}
        DISABLE_RESHADEFX=1
        DISABLE_DEPTH_CAPTURE=1
    )
    
    target_link_libraries(VkLayer_VulkanFX_simple PRIVATE
        keyboard_input_x11
        simple_effects
        ReShadeFX
        ${Vulkan_LIBRARIES}
        ${X11_LIBRARIES}
        dl
        pthread
    )
    
    set_target_properties(VkLayer_VulkanFX_simple PROPERTIES
        OUTPUT_NAME "VkLayer_VulkanFX_simple"
        PREFIX "lib"
        CXX_VISIBILITY_PRESET hidden
    )

    # Depth variant (with ReShade and depth capture)
    add_library(VkLayer_VulkanFX_depth SHARED
        ${COMMON_SOURCES}
        ${RESHADE_SOURCES}
    )
    
    add_dependencies(VkLayer_VulkanFX_depth generate_shader_headers)
    
    target_include_directories(VkLayer_VulkanFX_depth PRIVATE
        ${COMMON_INCLUDES}
        ${RESHADE_INCLUDES}
    )
    
    target_compile_definitions(VkLayer_VulkanFX_depth PRIVATE
        ${COMMON_DEFINITIONS}
    )
    
    target_link_libraries(VkLayer_VulkanFX_depth PRIVATE
        keyboard_input_x11
        simple_effects
        ReShadeFX
        ReShadeFX-spirv
        ReShadeFX-vulkan-type-convert
        ${Vulkan_LIBRARIES}
        ${X11_LIBRARIES}
        dl
        pthread
    )
    
    set_target_properties(VkLayer_VulkanFX_depth PROPERTIES
        OUTPUT_NAME "VkLayer_VulkanFX_depth"
        PREFIX "lib"
        CXX_VISIBILITY_PRESET hidden
    )
endif()

# Install targets
if(WITH_SO)
    install(TARGETS VkLayer_VulkanFX_default
        LIBRARY DESTINATION ${LIB_DIR}
    )
    
    if(BUILD_ALL_VARIANTS)
        install(TARGETS VkLayer_VulkanFX_simple VkLayer_VulkanFX_depth
            LIBRARY DESTINATION ${LIB_DIR}
        )
    endif()
endif()

# Install layer manifest
if(WITH_JSON)
    install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/config/VulkanFX.json
        DESTINATION ${CMAKE_INSTALL_PREFIX}/share/vulkan/implicit_layer.d
        OPTIONAL
    )
endif()

# Print build information
message(STATUS "VulkanFX Build Configuration:")
message(STATUS "  Version: ${PROJECT_VERSION}")
message(STATUS "  C++ Standard: ${CMAKE_CXX_STANDARD}")
message(STATUS "  Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "  Vulkan: ${Vulkan_LIBRARIES}")
message(STATUS "  X11: ${X11_LIBRARIES}")
message(STATUS "  Build All Variants: ${BUILD_ALL_VARIANTS}")
message(STATUS "  Disable ReShade: ${DISABLE_RESHADEFX}")
message(STATUS "  Install Library: ${WITH_SO}")
message(STATUS "  Install JSON: ${WITH_JSON}")
message(STATUS "  Library Directory: ${LIB_DIR}")
