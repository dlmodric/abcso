@echo off
setlocal enabledelayedexpansion

echo === Cross-Platform Plugin System Clean Script ===
echo.

REM 检测操作系统
if "%OS%"=="Windows_NT" (
    set OS_TYPE=windows
) else (
    set OS_TYPE=unknown
)

echo Operating System: %OS_TYPE%
echo.

echo Cleaning build files...

REM 删除构建目录
if exist project_a\build rmdir /s /q project_a\build
if exist project_b\build rmdir /s /q project_b\build

REM 删除其他构建产物
for /r . %%f in (*.obj) do del "%%f" 2>nul
for /r . %%f in (*.o) do del "%%f" 2>nul
for /r . %%f in (*.dll) do del "%%f" 2>nul
for /r . %%f in (*.so) do del "%%f" 2>nul
for /r . %%f in (*.dylib) do del "%%f" 2>nul
for /r . %%f in (*.exe) do del "%%f" 2>nul
for /r . %%f in (CMakeCache.txt) do del "%%f" 2>nul

REM 删除 CMakeFiles 目录
for /d /r . %%d in (CMakeFiles) do (
    if exist "%%d" rmdir /s /q "%%d" 2>nul
)

echo Build files cleaned!
echo.
pause