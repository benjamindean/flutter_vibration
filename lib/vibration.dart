import 'dart:async';

import 'package:flutter/services.dart';

class Vibration {
  static const MethodChannel _channel = const MethodChannel('vibration');

  static Future hasVibrator() =>
    _channel.invokeMethod("hasVibrator");

  static Future vibrate({duration, pattern, repeat = -1}) =>
      _channel.invokeMethod("vibrate",
          {"duration": duration, "pattern": pattern, "repeat": repeat});

  static Future cancel() => _channel.invokeMethod("cancel");
}
