#include "plugin_implementation.h"
#include <iostream>
#include <algorithm>
#include <cctype>

MyPlugin::MyPlugin() : name_("MyCustomPlugin"), version_(1) {
    std::cout << "MyPlugin constructor called" << std::endl;
}

MyPlugin::~MyPlugin() {
    std::cout << "MyPlugin destructor called" << std::endl;
}

std::string MyPlugin::getName() const {
    return name_;
}

std::string MyPlugin::process(const std::string& input) {
    std::string result = input;

    // 简单的处理：转换为大写并添加前缀
    std::transform(result.begin(), result.end(), result.begin(), ::toupper);
    result = "[PLUGIN_B] " + result;

    return result;
}

int MyPlugin::getVersion() const {
    return version_;
}