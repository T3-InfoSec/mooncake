#ifndef FLUTTER_PLUGIN_MOONCAKE_PLUGIN_H_
#define FLUTTER_PLUGIN_MOONCAKE_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>
#include <glib-object.h>

G_BEGIN_DECLS

G_DECLARE_FINAL_TYPE(MooncakePlugin, mooncake_plugin, MOONCAKE, PLUGIN, GObject)

void mooncake_plugin_register_with_registrar(FlPluginRegistrar* registrar);

G_END_DECLS

#endif  // FLUTTER_PLUGIN_MOONCAKE_PLUGIN_H_
