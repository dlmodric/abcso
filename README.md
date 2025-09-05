# 跨平台插件系统

这是一个支持 Windows、macOS 和 Linux 的 C++ 插件系统示例项目。

## 项目结构

```
abcso/
├── project_a/          # 主程序（插件加载器）
│   ├── main.cpp
│   ├── plugin_loader.h
│   ├── plugin_loader.cpp
│   ├── interface.h
│   └── CMakeLists.txt
├── project_b/          # 插件实现
│   ├── plugin_implementation.cpp
│   ├── plugin_implementation.h
│   ├── plugin_factory.cpp
│   └── CMakeLists.txt
├── build_and_run.sh    # Unix/Linux/macOS 构建脚本
├── build_and_run.bat   # Windows 构建脚本
├── clean.sh           # Unix/Linux/macOS 清理脚本
├── clean.bat          # Windows 清理脚本
├── test_linux.sh      # Linux 兼容性测试
├── test_windows.bat   # Windows 兼容性测试
└── README.md
```

## 系统要求

### macOS
- CMake 3.10+
- C++17 编译器
- 安装方式：
  ```bash
  brew install cmake
  ```

### Linux
- CMake 3.10+
- C++17 编译器 (GCC 7+ 或 Clang 5+)
- 基本构建工具
- 安装方式：
  ```bash
  # Ubuntu/Debian
  sudo apt-get update
  sudo apt-get install cmake build-essential
  
  # CentOS/RHEL 7
  sudo yum groupinstall 'Development Tools'
  sudo yum install cmake
  
  # CentOS/RHEL 8+ / Fedora
  sudo dnf groupinstall 'Development Tools'
  sudo dnf install cmake
  
  # Arch Linux / Manjaro
  sudo pacman -S cmake base-devel
  
  # openSUSE
  sudo zypper install cmake gcc-c++ make
  ```

### Windows
- CMake 3.10+
- C++17 编译器 (Visual Studio 2017+ 或 MinGW-w64)
- 安装方式：
  ```cmd
  # Option 1: Visual Studio Community (推荐)
  # 下载并安装 Visual Studio Community，确保选择 C++ 工作负载
  
  # Option 2: MinGW-w64
  # 下载并安装 MinGW-w64: https://www.mingw-w64.org/
  
  # Option 3: MSYS2
  # 下载并安装 MSYS2: https://www.msys2.org/
  # 然后运行: pacman -S cmake mingw-w64-x86_64-gcc
  
  # Option 4: Chocolatey
  # 安装 Chocolatey，然后运行: choco install cmake
  
  # Option 5: Scoop
  # 安装 Scoop，然后运行: scoop install cmake
  ```

## 使用方法

### 构建和运行

#### Unix/Linux/macOS
```bash
# 给脚本添加执行权限
chmod +x build_and_run.sh clean.sh test_linux.sh

# Linux 兼容性测试（推荐先运行）
./test_linux.sh

# 构建并运行
./build_and_run.sh

# 清理构建文件
./clean.sh
```

#### Windows
```cmd
# Windows 兼容性测试（推荐先运行）
test_windows.bat

# 构建并运行
build_and_run.bat

# 清理构建文件
clean.bat
```

### 手动构建
```bash
# 构建 Project A
cd project_a
mkdir build && cd build
cmake ..
make

# 构建 Project B
cd ../../project_b
mkdir build && cd build
cmake ..
make

# 运行
cd ../../project_a/build/bin
./project_a
```

## 跨平台特性

- **自动检测操作系统**：脚本会自动检测 Windows、macOS 或 Linux
- **动态库扩展名**：自动使用正确的文件扩展名（.dll、.dylib 或 .so）
- **包管理器提示**：根据操作系统显示相应的安装命令
- **路径兼容性**：确保在不同系统上路径正确
- **编译器支持**：支持 Visual Studio、GCC、Clang 等主流编译器

## 技术细节

- 使用 `dlopen`/`dlsym` (Unix/Linux/macOS) 或 `LoadLibrary`/`GetProcAddress` (Windows) 进行动态库加载
- 支持自定义删除器的 `std::unique_ptr`
- CMake 跨平台配置
- 自动内存管理
- Windows DLL 导出支持

## 故障排除

### 常见问题

1. **CMake 未找到**
   - 确保已安装 CMake 并添加到 PATH
   - 运行脚本会显示相应系统的安装命令

2. **插件加载失败**
   - 检查插件路径是否正确
   - 确保插件文件存在且有执行权限

3. **编译错误**
   - 确保使用 C++17 编译器
   - 检查所有依赖库是否已安装