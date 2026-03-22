library vibration_platform_interface;

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'src/method_channel_vibration.dart';

/// The interface that implementations of vibration must implement.
///
/// Platform implementations should extend this class rather than implement it as `vibration`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [VibrationPlatform] methods.
abstract class VibrationPlatform extends PlatformInterface {
  /// Constructs a VibrationPlatform.
  VibrationPlatform() : super(token: _token);

  static final Object _token = Object();

  static VibrationPlatform _instance = MethodChannelVibration();

  /// The default instance of [VibrationPlatform] to use.
  ///
  /// Defaults to [MethodChannelVibration].
  static VibrationPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [VibrationPlatform] when they register themselves.
  static set instance(VibrationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Check if vibrator is available on device.
  ///
  /// ```dart
  /// if (await Vibration.hasVibrator()) {
  ///   Vibration.vibrate();
  /// }
  /// ```
  Future<bool> hasVibrator() async {
    throw UnimplementedError('hasVibrator() has not been implemented.');
  }

  /// Check if the vibrator has amplitude control.
  ///
  /// ```dart
  /// if (await Vibration.hasAmplitudeControl()) {
  ///   Vibration.vibrate(amplitude: 128);
  /// }
  /// ```
  Future<bool> hasAmplitudeControl() async {
    throw UnimplementedError('hasAmplitudeControl() has not been implemented.');
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
  Future<bool> hasCustomVibrationsSupport() async {
    throw UnimplementedError(
      'hasCustomVibrationsSupport() has not been implemented.',
    );
  }

  /// Vibrate with [duration] at [amplitude] or [pattern] at [intensities].
  ///
  /// The default vibration duration is 500ms.
  /// Amplitude is a range from 1 to 255, if supported.
  ///
  /// [sharpness] is iOS only. When provided, must be in the range 0.0 to 1.0.
  /// When omitted, the iOS native fallback logic applies (intensity × 0.5).
  ///
  /// [sharpnesses] is iOS only. Per-segment sharpness values for pattern
  /// vibrations, each in the range 0.0 to 1.0.
  ///
  /// ```dart
  /// Vibration.vibrate(duration: 1000);
  ///
  /// if (await Vibration.hasAmplitudeControl()) {
  ///   Vibration.vibrate(duration: 1000, amplitude: 1);
  ///   Vibration.vibrate(duration: 1000, amplitude: 255);
  /// }
  /// ```
  Future<void> vibrate({
    int duration = 500,
    List<int> pattern = const [],
    int repeat = -1,
    List<int> intensities = const [],
    int amplitude = -1,
    double? sharpness,
    List<double> sharpnesses = const [],
  }) {
    throw UnimplementedError('vibrate() has not been implemented.');
  }

  /// This method is used to cancel an ongoing vibration.
  /// iOS: only works for custom haptic vibrations using `CHHapticEngine`.
  ///
  /// ```dart
  /// Vibration.vibrate(duration: 10000);
  /// Vibration.cancel();
  /// ```
  Future<void> cancel() {
    throw UnimplementedError('cancel() has not been implemented.');
  }
}
