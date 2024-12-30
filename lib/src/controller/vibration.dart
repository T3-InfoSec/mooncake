import 'package:vibration/vibration.dart';

class VibratePattern {
  VibratePattern();

  static Future<void> vibrateShort() async {
    if (await Vibration.hasCustomVibrationsSupport() ?? false) {
      await Vibration.vibrate(duration: 100);
    } else {
      Vibration.vibrate();
    }
  }

  Future<void> longVibrate() async {
    if (await Vibration.hasCustomVibrationsSupport() ?? false) {
      await Vibration.vibrate(duration: 1000);
    } else {
      Vibration.vibrate();
      await Future.delayed(const Duration(milliseconds: 500));
      await Vibration.vibrate();
    }
  }
}
