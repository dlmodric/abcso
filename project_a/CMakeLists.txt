cmake_minimum_required(VERSION 3.10)
project(ProjectA)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 添加可执行文件
add_executable(project_a main.cpp plugin_loader.cpp)

# 链接动态库加载库（跨平台）
if(UNIX AND NOT APPLE)
    # Linux
    target_link_libraries(project_a dl)
    # 设置 Linux 特定的编译选项
    target_compile_options(project_a PRIVATE -Wall -Wextra -Wpedantic)
    # 设置 RPATH 以便找到动态库
    set_target_properties(project_a PROPERTIES
        INSTALL_RPATH_USE_LINK_PATH TRUE
        BUILD_WITH_INSTALL_RPATH TRUE
    )
elseif(APPLE)
    # macOS
    target_link_libraries(project_a dl)
elseif(WIN32)
    # Windows
    target_link_libraries(project_a kernel32)
    # 设置 Windows 特定的编译选项
    target_compile_options(project_a PRIVATE /W4)
    # 设置 Windows 特定的定义
    target_compile_definitions(project_a PRIVATE WIN32_LEAN_AND_MEAN)
endif()

# 设置输出目录
set_target_properties(project_a PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)

# 创建输出目录
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/bin)