import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_platform_utils/flutter_platform_utils.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration_ohos/vibration_ohos.dart';

void main() => runApp(const VibratingApp());

class VibratingApp extends StatelessWidget {
  const VibratingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Vibration Plugin example app'),
        ),
        body: Builder(
          builder: (BuildContext context) {
            return Center(
              child: Column(
                children: <Widget>[
                  ElevatedButton(
                    child: const Text('Vibrate for default 500ms'),
                    onPressed: () {
                      Vibration.vibrate();
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Vibrate for 1000ms'),
                    onPressed: () {
                      Vibration.vibrate(duration: 1000);
                    },
                  ),
                  if (!PlatformUtils.isOhos)
                    ElevatedButton(
                      child: const Text('Vibrate with pattern'),
                      onPressed: () {
                        const snackBar = SnackBar(
                          content: Text(
                            'Pattern: wait 0.5s, vibrate 1s, wait 0.5s, vibrate 2s, wait 0.5s, vibrate 3s, wait 0.5s, vibrate 0.5s',
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Vibration.vibrate(
                          pattern: [500, 1000, 500, 2000, 500, 3000, 500, 500],
                        );
                      },
                    ),
                  if (!PlatformUtils.isOhos)
                    ElevatedButton(
                      child: const Text('Vibrate with pattern and amplitude'),
                      onPressed: () {
                        const snackBar = SnackBar(
                          content: Text(
                            'Pattern: wait 0.5s, vibrate 1s, wait 0.5s, vibrate 2s, wait 0.5s, vibrate 3s, wait 0.5s, vibrate 0.5s',
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Vibration.vibrate(
                          pattern: [500, 1000, 500, 2000, 500, 3000, 500, 500],
                          intensities: [0, 128, 0, 255, 0, 64, 0, 255],
                        );
                      },
                    ),
                  if (PlatformUtils.isOhos)
                    ElevatedButton(
                      child: const Text('Vibrate with VibratePreset'),
                      onPressed: () {
                        (VibrationPlatform.instance as VibrationOhos).vibrate(
                          vibrateEffect: const VibratePreset(count: 100),
                          vibrateAttribute: const VibrateAttribute(
                            usage: 'alarm',
                          ),
                        );
                      },
                    ),
                  // ohos only
                  // TODO: not support for now
                  if (PlatformUtils.isOhos)
                    ElevatedButton(
                      child: Text('Vibrate  with custom haptic_file'),
                      onPressed: () {
                        rootBundle.load('assets/haptic_file.json').then((data) {
                          (VibrationPlatform.instance as VibrationOhos).vibrate(
                            vibrateEffect: VibrateFromFile(
                              hapticFd: HapticFileDescriptor(
                                data: data.buffer.asUint8List(),
                              ),
                            ),
                            vibrateAttribute: VibrateAttribute(
                              usage: 'alarm',
                            ),
                          );
                        });
                      },
                    )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
