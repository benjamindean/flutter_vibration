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

  /// The following methods are examples of custom vibration patterns.

  static Future<void> singleShortBuzz() {
    return Vibration.vibrate(
      pattern: [0, 100],
      intensities: [0, 255],
    );
  }

  static Future<void> doubleBuzz() {
    return Vibration.vibrate(
      pattern: [0, 100, 50, 100],
      intensities: [0, 255, 0, 255],
    );
  }

  static Future<void> tripleBuzz() {
    return Vibration.vibrate(
      pattern: [0, 100, 50, 100, 50, 100],
      intensities: [0, 255, 0, 255, 0, 255],
    );
  }

  static Future<void> longAlarmBuzz() {
    return Vibration.vibrate(
      pattern: [0, 500],
      intensities: [0, 255],
    );
  }

  static Future<void> pulseWave() {
    return Vibration.vibrate(
      pattern: [0, 100, 100, 100, 100, 100],
      intensities: [0, 200, 0, 200, 0, 200],
    );
  }

  static Future<void> progressiveBuzz() {
    return Vibration.vibrate(
      pattern: [0, 100, 200, 300, 400, 500],
      intensities: [0, 100, 150, 200, 255, 255],
    );
  }

  static Future<void> rhythmicBuzz() {
    return Vibration.vibrate(
      pattern: [0, 200, 100, 300, 100, 200],
      intensities: [0, 150, 0, 255, 0, 200],
    );
  }

  static Future<void> gentleReminder() {
    return Vibration.vibrate(
      pattern: [0, 50, 100, 50, 100, 50],
      intensities: [0, 128, 0, 128, 0, 128],
    );
  }

  static Future<void> quickSuccessAlert() {
    return Vibration.vibrate(
      pattern: [0, 70, 30, 70, 30, 70],
      intensities: [0, 255, 0, 255, 0, 255],
    );
  }

  static Future<void> zigZagAlert() {
    return Vibration.vibrate(
      pattern: [0, 100, 30, 300, 30, 100],
      intensities: [0, 200, 0, 255, 0, 200],
    );
  }

  static Future<void> softPulse() {
    return Vibration.vibrate(
      pattern: [0, 150, 50, 150, 50, 150],
      intensities: [0, 100, 0, 100, 0, 100],
    );
  }

  static Future<void> emergencyAlert() {
    return Vibration.vibrate(
      pattern: [0, 500, 50, 500, 50, 500],
      intensities: [0, 255, 0, 255, 0, 255],
    );
  }

  static Future<void> heartbeatVibration() {
    return Vibration.vibrate(
      pattern: [0, 200, 100, 100, 100, 200],
      intensities: [0, 255, 0, 100, 0, 255],
    );
  }

  static Future<void> countdownTimerAlert() {
    return Vibration.vibrate(
      pattern: [0, 100, 100, 200, 100, 300, 100, 400, 100, 500],
      intensities: [0, 100, 0, 150, 0, 200, 0, 255, 0, 255],
    );
  }

  static Future<void> rapidTapFeedback() {
    return Vibration.vibrate(
      pattern: [0, 50, 50, 50, 50, 50, 50, 50],
      intensities: [0, 180, 0, 180, 0, 180, 0, 180],
    );
  }

  static Future<void> dramaticNotification() {
    return Vibration.vibrate(
      pattern: [0, 100, 200, 100, 300, 100, 400],
      intensities: [0, 255, 0, 200, 0, 150, 0],
    );
  }

  static Future<void> urgentBuzzWave() {
    return Vibration.vibrate(
      pattern: [0, 300, 50, 300, 50, 300, 50, 300],
      intensities: [0, 255, 0, 230, 0, 210, 0, 200],
    );
  }
}
