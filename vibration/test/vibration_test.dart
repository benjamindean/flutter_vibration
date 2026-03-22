import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibration/vibration.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('vibration');
  final List<MethodCall> log = <MethodCall>[];

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) {
          log.add(methodCall);

          return null;
        });
  });

  tearDown(() {
    log.clear();
  });

  group('hasVibrator', () {
    test('returns false', () async {
      bool? hasVibrator = await Vibration.hasVibrator();

      expect(hasVibrator, equals(false));
    });

    test('throws PlatformException', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            throw PlatformException(code: 'error');
          });

      final hasVibrator = await Vibration.hasVibrator();

      throwsA(isA<PlatformException>());
      expect(hasVibrator, isFalse);
    });

    test('throws UnsupportedError', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            throw UnsupportedError('error');
          });

      final hasVibrator = await Vibration.hasVibrator();

      throwsA(isA<UnsupportedError>());
      expect(hasVibrator, isFalse);
    });
  });

  group('hasAmplitudeControl', () {
    test('returns false', () async {
      bool? hasAmplitudeControl = await Vibration.hasAmplitudeControl();

      expect(hasAmplitudeControl, isFalse);
    });

    test('throws PlatformException', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            throw PlatformException(code: 'error');
          });

      final hasAmplitudeControl = await Vibration.hasAmplitudeControl();

      throwsA(isA<PlatformException>());
      expect(hasAmplitudeControl, isFalse);
    });

    test('throws UnsupportedError', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            throw UnsupportedError('error');
          });

      final hasAmplitudeControl = await Vibration.hasAmplitudeControl();

      throwsA(isA<UnsupportedError>());
      expect(hasAmplitudeControl, isFalse);
    });
  });

  test('vibrate with duration', () async {
    await Vibration.vibrate(duration: 100);

    expect(log, <Matcher>[
      isMethodCall(
        'vibrate',
        arguments: <String, Object>{
          'duration': 100,
          'pattern': [],
          'repeat': -1,
          'amplitude': -1,
          'intensities': [],
          'sharpnesses': [],
        },
      ),
    ]);
  });

  test('vibrate with pattern', () async {
    await Vibration.vibrate(pattern: [100, 200, 400], repeat: 1);

    expect(log, <Matcher>[
      isMethodCall(
        'vibrate',
        arguments: <String, Object>{
          'duration': 500,
          'pattern': [100, 200, 400],
          'repeat': 1,
          'amplitude': -1,
          'intensities': [],
          'sharpnesses': [],
        },
      ),
    ]);
  });

  test('vibrate with explicit sharpness includes key in payload', () async {
    await Vibration.vibrate(duration: 200, sharpness: 0.7);

    expect(log, <Matcher>[
      isMethodCall(
        'vibrate',
        arguments: <String, Object>{
          'duration': 200,
          'pattern': [],
          'repeat': -1,
          'amplitude': -1,
          'intensities': [],
          'sharpness': 0.7,
          'sharpnesses': [],
        },
      ),
    ]);
  });

  test('vibrate with sharpnesses list includes values in payload', () async {
    await Vibration.vibrate(pattern: [100, 200], sharpnesses: [0.3, 0.8]);

    expect(log, <Matcher>[
      isMethodCall(
        'vibrate',
        arguments: <String, Object>{
          'duration': 500,
          'pattern': [100, 200],
          'repeat': -1,
          'amplitude': -1,
          'intensities': [],
          'sharpnesses': [0.3, 0.8],
        },
      ),
    ]);
  });

  test(
    'vibrate single-element with sharpnesses passes list in payload',
    () async {
      await Vibration.vibrate(duration: 300, sharpnesses: [0.2]);

      expect(log, <Matcher>[
        isMethodCall(
          'vibrate',
          arguments: <String, Object>{
            'duration': 300,
            'pattern': [],
            'repeat': -1,
            'amplitude': -1,
            'intensities': [],
            'sharpnesses': [0.2],
          },
        ),
      ]);
    },
  );

  test('cancel vibration', () async {
    await Vibration.cancel();

    expect(log, <Matcher>[isMethodCall('cancel', arguments: null)]);
  });
}
