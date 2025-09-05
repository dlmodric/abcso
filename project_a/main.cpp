#include "plugin_loader.h"
#include <iostream>
#include <string>

#ifdef _WIN32
    const std::string LIB_EXT = ".dll";
#elif __linux__
    const std::string LIB_EXT = ".so";
#elif __APPLE__
    const std::string LIB_EXT = ".dylib";
#else
    const std::string LIB_EXT = ".so";  // 默认使用 Linux 扩展名
#endif

int main() {
    PluginLoader loader;

    // 加载插件
    std::string pluginPath = "../../../project_b/build/lib/libplugin_b" + LIB_EXT;
    if (!loader.loadPlugin(pluginPath)) {
        std::cerr << "Failed to load plugin" << std::endl;
        return 1;
    }

    std::cout << "Plugin loaded successfully!" << std::endl;

    try {
        // 创建插件实例
        auto plugin = loader.createPluginInstance();

        // 使用插件
        std::cout << "Plugin name: " << plugin->getName() << std::endl;
        std::cout << "Plugin version: " << plugin->getVersion() << std::endl;

        std::string input = "Hello from Project A!";
        std::string output = plugin->process(input);
        std::cout << "Input: " << input << std::endl;
        std::cout << "Output: " << output << std::endl;

    } catch (const std::exception& e) {
        std::cerr << "Error using plugin: " << e.what() << std::endl;
        return 1;
    }

    // 插件会在unique_ptr销毁时自动清理
    std::cout << "Plugin usage completed successfully!" << std::endl;

    return 0;
}