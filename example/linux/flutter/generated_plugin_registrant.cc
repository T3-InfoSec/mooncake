//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <mooncake/mooncake_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) mooncake_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "MooncakePlugin");
  mooncake_plugin_register_with_registrar(mooncake_registrar);
}
