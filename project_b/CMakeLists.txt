cmake_minimum_required(VERSION 3.10)
project(ProjectB)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 添加共享库
add_library(plugin_b SHARED
        plugin_implementation.cpp
        plugin_factory.cpp
)

# 设置包含目录，指向工程A的头文件
target_include_directories(plugin_b PRIVATE ../project_a)

# 设置输出目录
set_target_properties(plugin_b PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
        OUTPUT_NAME "plugin_b"
)

# 平台特定配置
if(UNIX AND NOT APPLE)
    # Linux 特定配置
    target_compile_options(plugin_b PRIVATE -Wall -Wextra -Wpedantic -fPIC)
    target_compile_definitions(plugin_b PRIVATE -DPLUGIN_EXPORTS)
    set_target_properties(plugin_b PROPERTIES
        INSTALL_RPATH_USE_LINK_PATH TRUE
        BUILD_WITH_INSTALL_RPATH TRUE
    )
elseif(WIN32)
    # Windows 特定配置
    target_compile_options(plugin_b PRIVATE /W4)
    target_compile_definitions(plugin_b PRIVATE PLUGIN_EXPORTS WIN32_LEAN_AND_MEAN)
    # 设置 DLL 导出
    set_target_properties(plugin_b PROPERTIES
        WINDOWS_EXPORT_ALL_SYMBOLS TRUE
    )
endif()

# 创建输出目录
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/lib)