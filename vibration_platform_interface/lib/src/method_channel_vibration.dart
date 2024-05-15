import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:vibration_platform_interface/vibration_platform_interface.dart';

class MethodChannelVibration extends VibrationPlatform {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  /// Method channel to communicate with native code.
  final MethodChannel _channel = const MethodChannel('vibration');

  /// Check if vibrator is available on device.
  ///
  /// ```dart
  /// if (await Vibration.hasVibrator()) {
  ///   Vibration.vibrate();
  /// }
  /// ```
  @override
  Future<bool?> hasVibrator() async {
    try {
      if (Platform.isAndroid) {
        final deviceData = await deviceInfo.androidInfo;

        if (!deviceData.isPhysicalDevice) {
          return false;
        }

        return true;
      } else if (Platform.isIOS) {
        final deviceData = await deviceInfo.iosInfo;

        if (!deviceData.isPhysicalDevice) {
          return false;
        }

        return true;
      }
    } on PlatformException {
      return false;
    } on UnsupportedError {
      return false;
    }

    return false;
  }

  /// Check if the vibrator has amplitude control.
  ///
  /// ```dart
  /// if (await Vibration.hasAmplitudeControl()) {
  ///   Vibration.vibrate(amplitude: 128);
  /// }
  /// ```
  @override
  Future<bool?> hasAmplitudeControl() async {
    try {
      if (Platform.isAndroid) {
        final deviceData = await deviceInfo.androidInfo;

        if (!deviceData.isPhysicalDevice) {
          return false;
        }

        return _channel.invokeMethod("hasAmplitudeControl");
      } else if (Platform.isIOS) {
        final deviceData = await deviceInfo.iosInfo;

        if (!deviceData.isPhysicalDevice) {
          return false;
        }

        return true;
      }
    } on PlatformException {
      return false;
    } on UnsupportedError {
      return false;
    }

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
  @override
  Future<bool?> hasCustomVibrationsSupport() async {
    try {
      return await _channel.invokeMethod("hasCustomVibrationsSupport");
    } on MissingPluginException {
      return Future.value(false);
    }
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
  @override
  Future<void> vibrate({
    int duration = 500,
    List<int> pattern = const [],
    int repeat = -1,
    List<int> intensities = const [],
    int amplitude = -1,
  }) =>
      _channel.invokeMethod(
        "vibrate",
        {
          "duration": duration,
          "pattern": pattern,
          "repeat": repeat,
          "amplitude": amplitude,
          "intensities": intensities,
        },
      );

  /// This method is used to cancel an ongoing vibration.
  /// iOS: only works for custom haptic vibrations using `CHHapticEngine.
  ///
  /// ```dart
  /// Vibration.vibrate(duration: 10000);
  /// Vibration.cancel();
  /// ```
  @override
  Future<void> cancel() => _channel.invokeMethod("cancel");
}
