#include "plugin_implementation.h"
#include <iostream>

// C接口函数，用于动态加载
extern "C" {
    PluginInterface* createPlugin() {
        std::cout << "createPlugin() called in Project B" << std::endl;
        return new MyPlugin();
    }

    void destroyPlugin(PluginInterface* plugin) {
        std::cout << "destroyPlugin() called in Project B" << std::endl;
        if (plugin) {
            delete plugin;
        }
    }
}