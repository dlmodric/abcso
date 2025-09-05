#!/bin/bash

# 检测操作系统
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

echo "Cleaning build files..."
echo "Operating system: $(detect_os)"

# 删除构建目录
rm -rf project_a/build project_b/build

# 删除其他可能的构建产物
find . -name "*.o" -delete 2>/dev/null || true
find . -name "*.obj" -delete 2>/dev/null || true
find . -name "*.so" -delete 2>/dev/null || true
find . -name "*.dylib" -delete 2>/dev/null || true
find . -name "*.dll" -delete 2>/dev/null || true
find . -name "*.exe" -delete 2>/dev/null || true
find . -name "CMakeCache.txt" -delete 2>/dev/null || true
find . -name "CMakeFiles" -type d -exec rm -rf {} + 2>/dev/null || true

echo "Build files cleaned!"