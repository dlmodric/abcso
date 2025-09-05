#include "plugin_loader.h"
#include <iostream>
#include <stdexcept>
#include <functional>

PluginLoader::PluginLoader() : handle_(nullptr), createFunc_(nullptr), destroyFunc_(nullptr) {
}

PluginLoader::~PluginLoader() {
    unloadPlugin();
}

bool PluginLoader::loadPlugin(const std::string& pluginPath) {
    // 如果已经加载了插件，先卸载
    if (handle_) {
        unloadPlugin();
    }

    // 加载动态库
    handle_ = dlopen(pluginPath.c_str(), RTLD_LAZY);
    if (!handle_) {
        std::cerr << "Failed to load plugin: " << dlerror() << std::endl;
        return false;
    }

    // 获取创建函数
    createFunc_ = (CreatePluginFunc)dlsym(handle_, "createPlugin");
    if (!createFunc_) {
        std::cerr << "Failed to find createPlugin function: " << dlerror() << std::endl;
        dlclose(handle_);
        handle_ = nullptr;
        return false;
    }

    // 获取销毁函数
    destroyFunc_ = (DestroyPluginFunc)dlsym(handle_, "destroyPlugin");
    if (!destroyFunc_) {
        std::cerr << "Failed to find destroyPlugin function: " << dlerror() << std::endl;
        dlclose(handle_);
        handle_ = nullptr;
        createFunc_ = nullptr;
        return false;
    }

    return true;
}

std::unique_ptr<PluginInterface, std::function<void(PluginInterface*)>> PluginLoader::createPluginInstance() {
    if (!handle_ || !createFunc_) {
        throw std::runtime_error("Plugin not loaded");
    }

    PluginInterface* plugin = createFunc_();
    if (!plugin) {
        throw std::runtime_error("Failed to create plugin instance");
    }

    // 使用自定义删除器，确保调用正确的销毁函数
    return std::unique_ptr<PluginInterface, std::function<void(PluginInterface*)>>(plugin, [this](PluginInterface* p) {
        if (destroyFunc_ && p) {
            destroyFunc_(p);
        }
    });
}

void PluginLoader::unloadPlugin() {
    if (handle_) {
        dlclose(handle_);
        handle_ = nullptr;
        createFunc_ = nullptr;
        destroyFunc_ = nullptr;
    }
}