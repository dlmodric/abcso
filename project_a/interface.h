#ifndef INTERFACE_H
#define INTERFACE_H

#include <string>

// 定义插件接口
class PluginInterface {
public:
    virtual ~PluginInterface() = default;
    virtual std::string getName() const = 0;
    virtual std::string process(const std::string& input) = 0;
    virtual int getVersion() const = 0;
};

// 插件工厂函数类型定义
typedef PluginInterface* (*CreatePluginFunc)();
typedef void (*DestroyPluginFunc)(PluginInterface*);

// 导出函数声明（用于C接口）
extern "C" {
    PluginInterface* createPlugin();
    void destroyPlugin(PluginInterface* plugin);
}

#endif // INTERFACE_H