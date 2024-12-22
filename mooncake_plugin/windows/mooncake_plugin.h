#ifndef FLUTTER_PLUGIN_MOONCAKE_PLUGIN_H_
#define FLUTTER_PLUGIN_MOONCAKE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace mooncake {

class MooncakePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  MooncakePlugin();

  virtual ~MooncakePlugin();

  // Disallow copy and assign.
  MooncakePlugin(const MooncakePlugin&) = delete;
  MooncakePlugin& operator=(const MooncakePlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace mooncake

#endif  // FLUTTER_PLUGIN_MOONCAKE_PLUGIN_H_
