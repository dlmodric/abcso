#ifndef PLUGIN_LOADER_H
#define PLUGIN_LOADER_H

#include "interface.h"
#include <string>
#include <memory>
#include <functional>
#include <dlfcn.h>

class PluginLoader {
public:
    PluginLoader();
    ~PluginLoader();

    // 加载指定路径的so文件
    bool loadPlugin(const std::string& pluginPath);

    // 创建插件实例
    std::unique_ptr<PluginInterface, std::function<void(PluginInterface*)>> createPluginInstance();

    // 卸载插件
    void unloadPlugin();

    // 检查插件是否已加载
    bool isLoaded() const { return handle_ != nullptr; }

private:
    void* handle_;
    CreatePluginFunc createFunc_;
    DestroyPluginFunc destroyFunc_;
};

#endif // PLUGIN_LOADER_H