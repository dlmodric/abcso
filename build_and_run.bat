@echo off
setlocal enabledelayedexpansion

echo === Cross-Platform Plugin System Build Script ===
echo.

REM 检测操作系统
if "%OS%"=="Windows_NT" (
    set OS_TYPE=windows
) else (
    set OS_TYPE=unknown
)

echo Operating System: %OS_TYPE%
echo.

REM 检查 CMake
cmake --version >nul 2>&1
if %errorlevel% neq 0 (
    echo CMake not found. Please install CMake first:
    echo   Option 1: Download from https://cmake.org/download/
    echo   Option 2: Install via Visual Studio Installer
    echo   Option 3: Install via MSYS2: pacman -S cmake
    echo   Option 4: Install via Chocolatey: choco install cmake
    echo   Option 5: Install via Scoop: scoop install cmake
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('cmake --version ^| findstr /r "cmake version"') do echo %%i
echo.

REM 检查编译器
set COMPILER_FOUND=0
where cl >nul 2>&1
if %errorlevel% equ 0 (
    set COMPILER_FOUND=1
    echo Visual Studio compiler found
) else (
    where gcc >nul 2>&1
    if %errorlevel% equ 0 (
        set COMPILER_FOUND=1
        echo GCC compiler found
    )
)

if %COMPILER_FOUND% equ 0 (
    echo No C++ compiler found. Please install one of the following:
    echo   Option 1: Visual Studio Community (with C++ workload)
    echo   Option 2: MinGW-w64 (https://www.mingw-w64.org/)
    echo   Option 3: MSYS2 (https://www.msys2.org/)
    echo   Option 4: Build Tools for Visual Studio
    pause
    exit /b 1
)

echo.
echo Building Project A...
cd project_a
if not exist build mkdir build
cd build

cmake ..
if %errorlevel% neq 0 (
    echo CMake configuration failed for Project A
    pause
    exit /b 1
)

cmake --build . --config Release
if %errorlevel% neq 0 (
    echo Build failed for Project A
    pause
    exit /b 1
)

cd ..\..
echo.

echo Building Project B...
cd project_b
if not exist build mkdir build
cd build

cmake ..
if %errorlevel% neq 0 (
    echo CMake configuration failed for Project B
    pause
    exit /b 1
)

cmake --build . --config Release
if %errorlevel% neq 0 (
    echo Build failed for Project B
    pause
    exit /b 1
)

cd ..\..
echo.

echo Running Project A with Project B plugin...
cd project_a\build\bin\Release
if not exist project_a.exe (
    echo Project A executable not found. Build may have failed.
    pause
    exit /b 1
)

set PLUGIN_PATH=..\..\..\..\project_b\build\lib\Release\plugin_b.dll
echo Using plugin path: %PLUGIN_PATH%

if not exist "%PLUGIN_PATH%" (
    echo Error: Plugin file not found at %PLUGIN_PATH%
    echo Available files in plugin directory:
    dir "..\..\..\..\project_b\build\lib\Release\" 2>nul
    pause
    exit /b 1
)

project_a.exe
if %errorlevel% neq 0 (
    echo Program execution failed
    pause
    exit /b 1
)

echo.
echo Build and run completed successfully!
pause