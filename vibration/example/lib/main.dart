import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

void main() => runApp(VibratingApp());

class VibratingApp extends StatelessWidget {
  const VibratingApp({super.key});

  void showSnackBar(
    BuildContext context, {
    List<int> pattern = const [],
    int duration = -1,
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    if (pattern.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: duration),
          content: Text('Vibrate for ${duration}ms'),
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(
          milliseconds: pattern.reduce(
            (value, element) => value + element,
          ),
        ),
        content: Text(
          pattern
              .map((e) => pattern.indexOf(e) % 2 == 0
                  ? 'wait ${e / 1000}s'
                  : 'vibrate ${e / 1000}s')
              .join(', '),
        ),
      ),
    );

    return;
  }

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
              child: ListView(
                children: <Widget>[
                  ElevatedButton(
                    child: Text('Vibrate for default 500ms'),
                    onPressed: () {
                      showSnackBar(context, duration: 500);

                      Vibration.vibrate();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Vibrate for 1000ms'),
                    onPressed: () {
                      showSnackBar(context, duration: 1000);

                      Vibration.vibrate(duration: 1000);
                    },
                  ),
                  ElevatedButton(
                    child: Text('Vibrate with pattern'),
                    onPressed: () {
                      final List<int> pattern = [
                        500,
                        1000,
                        500,
                        2000,
                        500,
                        3000,
                        500,
                        500
                      ];

                      showSnackBar(context, pattern: pattern);

                      Vibration.vibrate(
                        pattern: pattern,
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('Vibrate with pattern and amplitude'),
                    onPressed: () {
                      final List<int> pattern = [
                        500,
                        1000,
                        500,
                        2000,
                        500,
                        3000,
                        500,
                        500
                      ];

                      showSnackBar(context, pattern: pattern);

                      Vibration.vibrate(
                        pattern: pattern,
                        intensities: [0, 128, 0, 255, 0, 64, 0, 255],
                      );
                    },
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Vibration Presets:',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    child: Text('Single Short Buzz'),
                    onPressed: () {
                      final VibrationPresetConfig preset =
                          presets[VibrationPreset.singleShortBuzz]!;

                      showSnackBar(
                        context,
                        pattern: preset.pattern,
                      );

                      Vibration.vibrate(
                        preset: VibrationPreset.singleShortBuzz,
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('Double Buzz'),
                    onPressed: () {
                      final VibrationPresetConfig preset =
                          presets[VibrationPreset.doubleBuzz]!;

                      showSnackBar(
                        context,
                        pattern: preset.pattern,
                      );

                      Vibration.vibrate(
                        preset: VibrationPreset.doubleBuzz,
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('Triple Buzz'),
                    onPressed: () {
                      final VibrationPresetConfig preset =
                          presets[VibrationPreset.tripleBuzz]!;

                      showSnackBar(
                        context,
                        pattern: preset.pattern,
                      );

                      Vibration.vibrate(
                        preset: VibrationPreset.tripleBuzz,
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('Long Alarm Buzz'),
                    onPressed: () {
                      final VibrationPresetConfig preset =
                          presets[VibrationPreset.longAlarmBuzz]!;

                      showSnackBar(
                        context,
                        pattern: preset.pattern,
                      );

                      Vibration.vibrate(
                        preset: VibrationPreset.longAlarmBuzz,
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('Pulse Wave'),
                    onPressed: () {
                      final VibrationPresetConfig preset =
                          presets[VibrationPreset.pulseWave]!;

                      showSnackBar(
                        context,
                        pattern: preset.pattern,
                      );

                      Vibration.vibrate(
                        preset: VibrationPreset.pulseWave,
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('Progressive Buzz'),
                    onPressed: () {
                      final VibrationPresetConfig preset =
                          presets[VibrationPreset.progressiveBuzz]!;

                      showSnackBar(
                        context,
                        pattern: preset.pattern,
                      );

                      Vibration.vibrate(
                        preset: VibrationPreset.progressiveBuzz,
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('Rhythmic Buzz'),
                    onPressed: () {
                      final VibrationPresetConfig preset =
                          presets[VibrationPreset.rhythmicBuzz]!;

                      showSnackBar(
                        context,
                        pattern: preset.pattern,
                      );

                      Vibration.vibrate(
                        preset: VibrationPreset.rhythmicBuzz,
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('Gentle Reminder'),
                    onPressed: () {
                      final VibrationPresetConfig preset =
                          presets[VibrationPreset.gentleReminder]!;

                      showSnackBar(
                        context,
                        pattern: preset.pattern,
                      );

                      Vibration.vibrate(
                        preset: VibrationPreset.gentleReminder,
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('Quick Success Alert'),
                    onPressed: () {
                      final VibrationPresetConfig preset =
                          presets[VibrationPreset.quickSuccessAlert]!;

                      showSnackBar(
                        context,
                        pattern: preset.pattern,
                      );

                      Vibration.vibrate(
                        preset: VibrationPreset.quickSuccessAlert,
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('Zig Zag Alert'),
                    onPressed: () {
                      final VibrationPresetConfig preset =
                          presets[VibrationPreset.zigZagAlert]!;

                      showSnackBar(
                        context,
                        pattern: preset.pattern,
                      );

                      Vibration.vibrate(
                        preset: VibrationPreset.zigZagAlert,
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('Soft Pulse'),
                    onPressed: () {
                      final VibrationPresetConfig preset =
                          presets[VibrationPreset.softPulse]!;

                      showSnackBar(
                        context,
                        pattern: preset.pattern,
                      );

                      Vibration.vibrate(
                        preset: VibrationPreset.softPulse,
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('Emergency Alert'),
                    onPressed: () {
                      final VibrationPresetConfig preset =
                          presets[VibrationPreset.emergencyAlert]!;

                      showSnackBar(
                        context,
                        pattern: preset.pattern,
                      );

                      Vibration.vibrate(
                        preset: VibrationPreset.emergencyAlert,
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('Heartbeat Vibration'),
                    onPressed: () {
                      final VibrationPresetConfig preset =
                          presets[VibrationPreset.heartbeatVibration]!;

                      showSnackBar(
                        context,
                        pattern: preset.pattern,
                      );

                      Vibration.vibrate(
                        preset: VibrationPreset.heartbeatVibration,
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('Countdown Timer Alert'),
                    onPressed: () {
                      final VibrationPresetConfig preset =
                          presets[VibrationPreset.countdownTimerAlert]!;

                      showSnackBar(
                        context,
                        pattern: preset.pattern,
                      );

                      Vibration.vibrate(
                        preset: VibrationPreset.countdownTimerAlert,
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('Rapid Tap Feedback'),
                    onPressed: () {
                      final VibrationPresetConfig preset =
                          presets[VibrationPreset.rapidTapFeedback]!;

                      showSnackBar(
                        context,
                        pattern: preset.pattern,
                      );

                      Vibration.vibrate(
                        preset: VibrationPreset.rapidTapFeedback,
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('Dramatic Notification'),
                    onPressed: () {
                      final VibrationPresetConfig preset =
                          presets[VibrationPreset.dramaticNotification]!;

                      showSnackBar(
                        context,
                        pattern: preset.pattern,
                      );

                      Vibration.vibrate(
                        preset: VibrationPreset.dramaticNotification,
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('Urgent Buzz Wave'),
                    onPressed: () {
                      final VibrationPresetConfig preset =
                          presets[VibrationPreset.urgentBuzzWave]!;

                      showSnackBar(
                        context,
                        pattern: preset.pattern,
                      );

                      Vibration.vibrate(
                        preset: VibrationPreset.urgentBuzzWave,
                      );
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
