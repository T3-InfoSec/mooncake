import 'package:mooncake/src/mooncake_method_channel.dart';
import 'package:vibration/vibration.dart';

class MooncakePlugin {
  static final MethodChannelMooncake _platform = MethodChannelMooncake();

  static Future<void> listenForVolumeButtonPress(Function(VolumeButtonEvent) onVolumeButtonEvent) async {
    _platform.onVolumeButtonPressed.listen((event) {
      if (event.pressType == PressType.longPress) {
        Vibration.vibrate(duration: 1000);
      } else {
        Vibration.vibrate(duration: 100);
      }

      onVolumeButtonEvent(VolumeButtonEvent(
        button: event.button,
        pressType: event.pressType,
      ));
    });
  }
}

class VolumeButtonEvent {
  final VolumeButton button;
  final PressType pressType;

  VolumeButtonEvent({
    required this.button,
    required this.pressType,
  });

  Map<String, dynamic> toMap() {
    return {
      'button': button.toString().split('.').last.toUpperCase(),
      'type': pressType.toString().split('.').last.toUpperCase(),
    };
  }

  static VolumeButtonEvent fromMap(Map<String, dynamic> map) {
    return VolumeButtonEvent(
      button: map['button'] == '1' ? VolumeButton.up : VolumeButton.down,
      pressType: map['type'] == 'LONG_PRESS' ? PressType.longPress : PressType.shortPress,
    );
  }
}

enum PressType {
  shortPress,
  longPress,
}

enum VolumeButton {
  up, // 1 represents 'up'
  down, // 0 represents 'down'
}

extension VolumeButtonExtension on VolumeButton {
  String get value => this == VolumeButton.up ? '1' : '0';
  bool get isUp => this == VolumeButton.up;
  bool get isDown => this == VolumeButton.down;
}

extension PressTypeExtension on PressType {
  String get value => this == PressType.shortPress ? 'short' : 'long';
  bool get isShortPress => this == PressType.shortPress;
  bool get isLongPress => this == PressType.longPress;
}
