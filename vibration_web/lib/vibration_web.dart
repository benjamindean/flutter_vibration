import 'dart:async';
import 'dart:js';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class VibrationWebPlugin {
  /// Get navigator JS object
  static final _navigator = context['navigator'];

  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'vibration',
      const StandardMethodCodec(),
      registrar,
    );
    final VibrationWebPlugin pluginInstance = VibrationWebPlugin();

    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'hasVibrator':
        return Future.value(_hasVibrator());
      case 'vibrate':
        final int duration = call.arguments['duration'];
        final List<int> pattern = call.arguments['pattern'].cast<int>();

        return Future.value(_vibrate(duration: duration, pattern: pattern));
      case 'hasAmplitudeControl':
      case 'hasCustomVibrationsSupport':
        return Future.value(false);
      case 'cancel':
        return Future.value(_cancel());
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'vibration_web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  static bool _hasVibrator() {
    /// Check if the navigator object has the vibrate function
    return _navigator.hasProperty('vibrate');
  }

  static _vibrate({int duration = 500, List<int> pattern = const []}) {
    if (_hasVibrator()) {
      /// If pattern is not empty, convert to JS array
      final args = pattern.length > 0 ? JsArray.from(pattern) : duration;

      /// Call vibrate function
      _navigator.callMethod('vibrate', [args]);
    }
  }

  static _cancel() {
    _vibrate(duration: 0);
  }
}
