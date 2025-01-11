import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mooncake/src/mooncake_plugin.dart';
import 'mooncake_platform_interface.dart';

/// An implementation of [MooncakePlatform] that uses method channels.
class MethodChannelMooncake extends MooncakePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  static const MethodChannel methodChannel = MethodChannel('mooncake');
  static const EventChannel eventChannel = EventChannel('mooncake/events');

  @override
  Stream<VolumeButtonEvent> get onVolumeButtonPressed {
    return eventChannel.receiveBroadcastStream().map((dynamic event) {
      final Map<String, dynamic> map = Map<String, dynamic>.from(event);
      return VolumeButtonEvent.fromMap(map);
    });
  }

  @override
  Future<void> initialize() async {
    await methodChannel.invokeMethod('initialize');
  }
}
