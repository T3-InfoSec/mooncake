#include "include/mooncake/mooncake_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "mooncake_plugin.h"

void MooncakePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  mooncake::MooncakePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
