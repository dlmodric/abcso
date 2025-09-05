#!/bin/bash

# Linux 兼容性测试脚本
echo "=== Linux Compatibility Test ==="

# 检测系统信息
echo "System Information:"
echo "OS: $(uname -s)"
echo "Architecture: $(uname -m)"
echo "Kernel: $(uname -r)"

if [[ -f /etc/os-release ]]; then
    echo "Distribution:"
    cat /etc/os-release | grep -E "^(NAME|VERSION)="
fi

echo ""

# 检查编译器
echo "Compiler Information:"
if command -v gcc &> /dev/null; then
    echo "GCC: $(gcc --version | head -n1)"
else
    echo "GCC: Not found"
fi

if command -v g++ &> /dev/null; then
    echo "G++: $(g++ --version | head -n1)"
else
    echo "G++: Not found"
fi

echo ""

# 检查 CMake
echo "CMake Information:"
if command -v cmake &> /dev/null; then
    echo "CMake: $(cmake --version | head -n1)"
else
    echo "CMake: Not found"
fi

echo ""

# 检查动态链接器
echo "Dynamic Linker Information:"
if command -v ldd &> /dev/null; then
    echo "ldd: $(ldd --version 2>/dev/null | head -n1 || echo 'ldd found but version unknown')"
else
    echo "ldd: Not found"
fi

echo ""

# 检查必要的库
echo "Library Check:"
if [[ -f /usr/lib/x86_64-linux-gnu/libdl.so ]] || [[ -f /lib/x86_64-linux-gnu/libdl.so ]] || [[ -f /usr/lib64/libdl.so ]]; then
    echo "libdl: Found"
else
    echo "libdl: Not found (this may cause issues)"
fi

echo ""

# 运行构建测试
echo "Running build test..."
if ./build_and_run.sh; then
    echo ""
    echo "✅ Linux compatibility test PASSED!"
    echo "The project builds and runs successfully on this Linux system."
else
    echo ""
    echo "❌ Linux compatibility test FAILED!"
    echo "Please check the error messages above and install missing dependencies."
    exit 1
fi