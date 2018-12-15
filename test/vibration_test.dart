import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibration/vibration.dart';

void main() {
  const MethodChannel channel = MethodChannel('vibration');
  final List<MethodCall> log = <MethodCall>[];

  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    log.add(methodCall);
  });

  tearDown(() {
    log.clear();
  });

  test('hasVibrator', () async {
    bool hasVibrator = await Vibration.hasVibrator();
    expect(
      hasVibrator,
      equals(null),
    );
  });

  test('vibrate with duration', () async {
    await Vibration.vibrate(duration: 100);
    expect(
      log,
      <Matcher>[
        isMethodCall('vibrate', arguments: <String, Object>{
          'duration': 100,
          'pattern': [],
          'repeat': -1
        })
      ],
    );
  });

  test('vibrate with pattern', () async {
    await Vibration.vibrate(pattern: [100, 200, 400], repeat: 1);
    expect(
      log,
      <Matcher>[
        isMethodCall('vibrate', arguments: <String, Object>{
          'duration': 500,
          'pattern': [100, 200, 400],
          'repeat': 1
        })
      ],
    );
  });
}
