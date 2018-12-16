import 'dart:async';

import 'package:flutter/services.dart';

class Vibration {
  static const MethodChannel _channel = const MethodChannel('vibration');

  static Future<bool> hasVibrator() =>
      _channel.invokeMethod("hasVibrator") as Future<bool>;

  static Future<void> vibrate(
          {int duration = 500,
          List<int> pattern = const [],
          int repeat = -1}) =>
      _channel.invokeMethod("vibrate",
          {"duration": duration, "pattern": pattern, "repeat": repeat});

  static Future<void> cancel() => _channel.invokeMethod("cancel");
}
