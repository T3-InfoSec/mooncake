import 'package:mooncake_plugin/mooncake_plugin.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'mooncake_method_channel.dart';

abstract class MooncakePlatform extends PlatformInterface {
  /// Constructs a MooncakePlatform.
  MooncakePlatform() : super(token: _token);

  static final Object _token = Object();

  static MooncakePlatform _instance = MethodChannelMooncake();

  /// The default instance of [MooncakePlatform] to use.
  ///
  /// Defaults to [MethodChannelMooncake].
  static MooncakePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MooncakePlatform] when
  /// they register themselves.
  static set instance(MooncakePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<VolumeButtonEvent> get onVolumeButtonPressed {
    throw UnimplementedError('onVolumeButtonPressed has not been implemented.');
  }

  Future<void> initialize() async {
    throw UnimplementedError('initialize has not been implemented.');
  }
}
