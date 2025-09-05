#ifndef PLUGIN_IMPLEMENTATION_H
#define PLUGIN_IMPLEMENTATION_H

#include "../project_a/interface.h"
#include <string>

class MyPlugin : public PluginInterface {
public:
    MyPlugin();
    virtual ~MyPlugin();

    std::string getName() const override;
    std::string process(const std::string& input) override;
    int getVersion() const override;

private:
    std::string name_;
    int version_;
};

#endif // PLUGIN_IMPLEMENTATION_H