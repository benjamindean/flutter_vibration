library vibration_ohos;

import 'dart:convert';

import 'package:device_info_plus_ohos/device_info_plus_ohos.dart';
import 'package:flutter/services.dart';
import 'package:vibration_platform_interface/vibration_platform_interface.dart';
export 'package:vibration_platform_interface/vibration_platform_interface.dart';

class VibrationOhos extends VibrationPlatform {
  /// Registers this class as the default instance of [VibrationOhos].
  static void registerWith() {
    VibrationPlatform.instance = VibrationOhos();
  }

  final DeviceInfoOhosPlugin ohosDeviceInfo = DeviceInfoOhosPlugin();

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
  Future<bool> hasVibrator() async {
    try {
      final deviceData = await ohosDeviceInfo.ohosDeviceInfo;

      if (!deviceData.isPhysicalDevice) {
        return false;
      }

      return true;
    } on PlatformException {
      return false;
    } on UnsupportedError {
      return false;
    }
  }

  /// Check if the vibrator has amplitude control.
  ///
  /// ```dart
  /// if (await Vibration.hasAmplitudeControl()) {
  ///   Vibration.vibrate(amplitude: 128);
  /// }
  /// ```
  @override
  Future<bool> hasAmplitudeControl() async {
    try {
      final deviceData = await ohosDeviceInfo.ohosDeviceInfo;
      if (!deviceData.isPhysicalDevice) {
        return false;
      }

      return true;
    } on PlatformException {
      return false;
    } on UnsupportedError {
      return false;
    }
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
  Future<bool> hasCustomVibrationsSupport() async {
    try {
      return true;
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
    // ohos only
    VibrateEffect? vibrateEffect,
    // ohos only
    VibrateAttribute vibrateAttribute = const VibrateAttribute(),
  }) =>
      _channel.invokeMethod(
        "vibrate",
        {
          "vibrateEffect": (vibrateEffect ??
                  (repeat > 0
                      ? VibratePreset(count: repeat)
                      : VibrateTime(duration: duration)))
              .toMap(),
          "vibrateAttribute": vibrateAttribute.toString(),
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

/// vibration effect.
/// 马达振动效果。
mixin VibrateEffect {
  Map<String, dynamic> toMap();
  @override
  String toString() {
    return jsonEncode(toMap());
  }
}

/// See also: https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/reference/apis/js-apis-vibrator.md#vibrateeffect9
class VibrateTime with VibrateEffect {
  /// The duration of continuous motor vibration, in milliseconds.
  /// 马达持续振动时长, 单位ms。
  final int duration;

  const VibrateTime({
    required this.duration,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'time',
      'duration': duration,
    };
  }
}

/// See also: https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/reference/apis/js-apis-vibrator.md#vibrateeffect9
class VibratePreset with VibrateEffect {
  /// 预置的振动效果ID。
  final String effectId;

  /// 重复振动的次数。
  final int count;

  const VibratePreset({
    this.effectId = 'haptic.clock.timer',
    required this.count,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'preset',
      'effectId': effectId,
      'count': count,
    };
  }
}

/// TODO: OpenHarmony not support for now
/// See also: https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/reference/apis/js-apis-vibrator.md#vibrateeffect9
class VibrateFromFile with VibrateEffect {
  final HapticFileDescriptor hapticFd;

  const VibrateFromFile({
    required this.hapticFd,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'file',
      'hapticFd': hapticFd.toMap(),
    };
  }
}

/// Descriptor for custom vibration configuration file
/// Custom vibration types, supported by only some devices
/// 自定义振动配置文件的描述符
/// 自定义振动类型，仅部分设备支持
class HapticFileDescriptor {
  final int? offset;
  final int? length;
  final Uint8List data;

  const HapticFileDescriptor({
    this.offset,
    this.length,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      if (offset != null) 'offset': offset,
      if (length != null) 'length': length,
      'data': data,
    };
  }
}

/// 马达振动属性。
class VibrateAttribute {
  final int? id;

  ///  'unknown' | 'alarm' | 'ring' |
  ///  'notification' | 'communication' | 'touch' |
  ///  'media' | 'physicalFeedback' | 'simulateReality';
  /// unknown	没有明确使用场景，最低优先级。
  /// alarm		用于警报场景。
  /// ring		用于铃声场景。
  /// notification		用于通知场景。
  /// communication		用于通信场景。
  /// touch		用于触摸场景。
  /// media		用于多媒体场景。
  /// physicalFeedback	用于物理反馈场景。
  /// simulateReality		用于模拟现实场景。
  final String usage;

  const VibrateAttribute({
    this.id,
    this.usage = 'unknown',
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'usage': usage,
    };
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }
}
