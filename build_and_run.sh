#!/bin/bash

# 检测操作系统
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "linux"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
        echo "windows"
    elif [[ -n "$WINDIR" ]] || [[ -n "$OS" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# 检测 Linux 发行版
detect_linux_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "$ID"
    elif [[ -f /etc/redhat-release ]]; then
        echo "rhel"
    elif [[ -f /etc/debian_version ]]; then
        echo "debian"
    else
        echo "unknown"
    fi
}

# 获取动态库文件扩展名
get_library_extension() {
    local os=$(detect_os)
    case $os in
        "linux")
            echo ".so"
            ;;
        "macos")
            echo ".dylib"
            ;;
        "windows")
            echo ".dll"
            ;;
        *)
            echo ".so"  # 默认使用 Linux 扩展名
            ;;
    esac
}

# 检查 Windows 依赖
check_windows_dependencies() {
    local missing_deps=""
    
    # 检查 Visual Studio 或 MinGW
    if ! command -v cl >/dev/null 2>&1 && ! command -v gcc >/dev/null 2>&1; then
        missing_deps="$missing_deps C++ compiler"
    fi
    if ! command -v make >/dev/null 2>&1 && ! command -v nmake >/dev/null 2>&1 && ! command -v mingw32-make >/dev/null 2>&1; then
        missing_deps="$missing_deps Make utility"
    fi
    
    if [ -n "$missing_deps" ]; then
        echo "Missing build dependencies:$missing_deps"
        echo "Please install one of the following:"
        echo "  Option 1: Visual Studio Community (with C++ workload)"
        echo "  Option 2: MinGW-w64 (https://www.mingw-w64.org/)"
        echo "  Option 3: MSYS2 (https://www.msys2.org/)"
        echo "  Option 4: Build Tools for Visual Studio"
        exit 1
    fi
}

# 检查 Linux 依赖
check_linux_dependencies() {
    local distro=$(detect_linux_distro)
    local missing_deps=""
    
    # 检查基本构建工具
    if ! command -v gcc >/dev/null 2>&1; then
        missing_deps="$missing_deps gcc"
    fi
    if ! command -v g++ >/dev/null 2>&1; then
        missing_deps="$missing_deps g++"
    fi
    if ! command -v make >/dev/null 2>&1; then
        missing_deps="$missing_deps make"
    fi
    
    if [ -n "$missing_deps" ]; then
        echo "Missing build dependencies:$missing_deps"
        echo "Please install them using:"
        case $distro in
            "ubuntu"|"debian")
                echo "  sudo apt-get update && sudo apt-get install build-essential"
                ;;
            "centos"|"rhel"|"fedora")
                echo "  sudo yum groupinstall 'Development Tools'"
                echo "  # or for newer versions:"
                echo "  sudo dnf groupinstall 'Development Tools'"
                ;;
            "arch"|"manjaro")
                echo "  sudo pacman -S base-devel"
                ;;
            *)
                echo "  Install gcc, g++, and make for your distribution"
                ;;
        esac
        exit 1
    fi
}

# 检查CMake是否安装
check_cmake() {
    if ! command -v cmake >/dev/null 2>&1; then
        local os=$(detect_os)
        echo "CMake not found. Please install CMake first:"
        case $os in
            "linux")
                local distro=$(detect_linux_distro)
                case $distro in
                    "ubuntu"|"debian")
                        echo "  sudo apt-get install cmake"
                        ;;
                    "centos"|"rhel")
                        echo "  sudo yum install cmake"
                        echo "  # or for newer versions:"
                        echo "  sudo dnf install cmake"
                        ;;
                    "fedora")
                        echo "  sudo dnf install cmake"
                        ;;
                    "arch"|"manjaro")
                        echo "  sudo pacman -S cmake"
                        ;;
                    "opensuse"|"sles")
                        echo "  sudo zypper install cmake"
                        ;;
                    *)
                        echo "  Install cmake for your distribution"
                        echo "  Or download from: https://cmake.org/download/"
                        ;;
                esac
                ;;
            "macos")
                echo "  Option 1: brew install cmake"
                echo "  Option 2: Download from https://cmake.org/download/"
                echo "  Option 3: sudo port install cmake"
                ;;
            "windows")
                echo "  Option 1: Download from https://cmake.org/download/"
                echo "  Option 2: Install via Visual Studio Installer"
                echo "  Option 3: Install via MSYS2: pacman -S cmake"
                echo "  Option 4: Install via Chocolatey: choco install cmake"
                echo "  Option 5: Install via Scoop: scoop install cmake"
                ;;
            *)
                echo "  Download from https://cmake.org/download/"
                ;;
        esac
        exit 1
    fi
    echo "CMake found: $(cmake --version | head -n1)"
}

# 检查依赖
os=$(detect_os)
if [[ "$os" == "linux" ]]; then
    check_linux_dependencies
elif [[ "$os" == "windows" ]]; then
    check_windows_dependencies
fi
check_cmake

echo "Building Project A..."
cd project_a
mkdir -p build
cd build
cmake ..
if [ $? -ne 0 ]; then
    echo "CMake configuration failed for Project A"
    exit 1
fi
make
if [ $? -ne 0 ]; then
    echo "Build failed for Project A"
    exit 1
fi
cd ../..

echo "Building Project B..."
cd project_b
mkdir -p build
cd build
cmake ..
if [ $? -ne 0 ]; then
    echo "CMake configuration failed for Project B"
    exit 1
fi
make
if [ $? -ne 0 ]; then
    echo "Build failed for Project B"
    exit 1
fi
cd ../..

echo "Running Project A with Project B plugin..."
cd project_a/build/bin
if [ ! -f "./project_a" ]; then
    echo "Project A executable not found. Build may have failed."
    exit 1
fi

# 获取动态库扩展名并设置插件路径
LIB_EXT=$(get_library_extension)
PLUGIN_PATH="../../../project_b/build/lib/libplugin_b${LIB_EXT}"

echo "Using plugin path: $PLUGIN_PATH"

# Linux 特定的调试信息
if [[ "$(detect_os)" == "linux" ]]; then
    echo "Linux system detected. Checking dependencies..."
    echo "ldd version: $(ldd --version 2>/dev/null | head -n1 || echo 'ldd not found')"
    echo "Library dependencies:"
    ldd ./project_a 2>/dev/null || echo "Could not check library dependencies"
    echo ""
fi

# 检查插件文件是否存在
if [ ! -f "$PLUGIN_PATH" ]; then
    echo "Error: Plugin file not found at $PLUGIN_PATH"
    echo "Available files in plugin directory:"
    ls -la ../../../project_b/build/lib/ 2>/dev/null || echo "Plugin directory not found"
    exit 1
fi

./project_a