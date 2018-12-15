import 'dart:async';

import 'package:flutter/services.dart';

class Vibration {
  static const MethodChannel _channel = const MethodChannel('vibration');

  static Future<bool> hasVibrator() => _channel.invokeMethod("hasVibrator");

  static Future<void> vibrate({int duration, List<int> pattern, int repeat = -1}) =>
      _channel.invokeMethod("vibrate",
          {"duration": duration, "pattern": pattern, "repeat": repeat});

  static Future<void> cancel() => _channel.invokeMethod("cancel");
}
