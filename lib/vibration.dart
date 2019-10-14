import 'dart:async';

import 'package:flutter/services.dart';

/// Platform-independent vibration methods.
class Vibration {
  /// Method channel to communicate with native code.
  static const MethodChannel _channel = const MethodChannel('vibration');

  /// Check if vibrator is available on device.
  ///
  /// ```dart
  /// if (Vibration.hasVibrator()) {
  ///   Vibration.vibrate();
  /// }
  /// ```
  static Future hasVibrator() => _channel.invokeMethod("hasVibrator");

  /// Check if the vibrator has amplitude control.
  ///
  /// ```dart
  /// if (Vibration.hasAmplitudeControl()) {
  ///   Vibration.vibrate(amplitude: 128);
  /// }
  /// ```
  static Future hasAmplitudeControl() =>
      _channel.invokeMethod("hasAmplitudeControl");

  /// Vibrate with [duration] at [amplitude] or [pattern] at [intensities].
  ///
  /// The default vibration duration is 500ms.
  /// Amplitude is a range from 1 to 255, if supported.
  ///
  /// ```dart
  /// Vibration.vibrate(duration: 1000);
  ///
  /// if (Vibration.hasAmplitudeControl()) {
  ///   Vibration.vibrate(duration: 1000, amplitude: 1);
  ///   Vibration.vibrate(duration: 1000, amplitude: 255);
  /// }
  /// ```
  static Future<void> vibrate(
          {int duration = 500,
          List<int> pattern = const [],
          int repeat = -1,
          List<int> intensities = const [],
          int amplitude = -1}) =>
      _channel.invokeMethod("vibrate", {
        "duration": duration,
        "pattern": pattern,
        "repeat": repeat,
        "amplitude": amplitude,
        "intensities": intensities
      });

  /// Cancel ongoing vibration.
  ///
  /// ```dart
  /// Vibration.vibrate(duration: 10000);
  /// Vibration.cancel();
  /// ```
  static Future<void> cancel() => _channel.invokeMethod("cancel");
}
