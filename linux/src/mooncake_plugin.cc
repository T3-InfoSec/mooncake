#include "include/mooncake/mooncake_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

// Function called when a method call is received from Dart.
static void mooncake_plugin_handle_method_call(
    MooncakePlugin* self,
    FlMethodCall* method_call) {
  const gchar* method = fl_method_call_get_name(method_call);

  if (strcmp(method, "getPlatformVersion") == 0) {
    struct utsname uname_data;
    uname(&uname_data);
    g_autofree gchar* version = g_strdup_printf("Linux %s", uname_data.version);
    fl_method_call_respond_success(method_call, fl_value_new_string(version), nullptr);
  } else {
    fl_method_call_respond_not_implemented(method_call, nullptr);
  }
}

static void mooncake_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(mooncake_plugin_parent_class)->dispose(object);
}

static void mooncake_plugin_class_init(MooncakePluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = mooncake_plugin_dispose;
}

static void mooncake_plugin_init(MooncakePlugin* self) {}

void mooncake_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  MooncakePlugin* plugin = MOONCAKE_PLUGIN(
      g_object_new(mooncake_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel = fl_method_channel_new(
      fl_plugin_registrar_get_messenger(registrar),
      "mooncake",
      FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(
      channel, (FlMethodCallHandlerFunc)mooncake_plugin_handle_method_call,
      g_object_ref(plugin),
      g_object_unref);

  g_object_unref(plugin);
}
