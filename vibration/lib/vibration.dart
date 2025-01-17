import 'dart:async';

import 'package:vibration_platform_interface/vibration_platform_interface.dart';
export 'package:vibration_platform_interface/vibration_platform_interface.dart';

/// Platform-independent vibration methods.
class Vibration {
  /// Check if vibrator is available on device.
  ///
  /// ```dart
  /// if (await Vibration.hasVibrator()) {
  ///   Vibration.vibrate();
  /// }
  /// ```
  static Future<bool> hasVibrator() async {
    return await VibrationPlatform.instance.hasVibrator();
  }

  /// Check if the vibrator has amplitude control.
  ///
  /// ```dart
  /// if (await Vibration.hasAmplitudeControl()) {
  ///   Vibration.vibrate(amplitude: 128);
  /// }
  /// ```
  static Future<bool> hasAmplitudeControl() async {
    return false;
  }

  /// Check if the device is able to vibrate with a custom
  /// [duration], [pattern] or [intensities].
  /// May return `true` even if the device has no vibrator.
  ///
  /// ```dart
  /// if (await Vibration.hasCustomVibrationsSupport()) {
  ///   Vibration.vibrate(duration: 1000);
  /// } else {
  ///   Vibration.vibrate();
  ///   await Future.delayed(Duration(milliseconds: 500));
  ///   Vibration.vibrate();
  /// }
  /// ```
  static Future<bool> hasCustomVibrationsSupport() async {
    return false;
  }

  /// Vibrate with [duration] at [amplitude] or [pattern] at [intensities].
  ///
  /// The default vibration duration is 500ms.
  /// Amplitude is a range from 1 to 255, if supported.
  ///
  /// ```dart
  /// Vibration.vibrate(duration: 1000);
  ///
  /// if (await Vibration.hasAmplitudeControl()) {
  ///   Vibration.vibrate(duration: 1000, amplitude: 1);
  ///   Vibration.vibrate(duration: 1000, amplitude: 255);
  /// }
  /// ```
  static Future<void> vibrate({
    int duration = 500,
    List<int> pattern = const [],
    int repeat = -1,
    List<int> intensities = const [],
    int amplitude = -1,
  }) async {
    return VibrationPlatform.instance.vibrate(
      duration: duration,
      pattern: pattern,
      repeat: repeat,
      intensities: intensities,
      amplitude: amplitude,
    );
  }

  /// This method is used to cancel an ongoing vibration.
  /// iOS: only works for custom haptic vibrations using `CHHapticEngine.
  ///
  /// ```dart
  /// Vibration.vibrate(duration: 10000);
  /// Vibration.cancel();
  /// ```
  static Future<void> cancel() async {
    return VibrationPlatform.instance.cancel();
  }
}
