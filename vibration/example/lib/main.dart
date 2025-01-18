import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

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
              child: Column(
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
                  ElevatedButton(
                    child: Text('Single Short Buzz'),
                    onPressed: () {
                      showSnackBar(
                        context,
                        pattern: [0, 100],
                      );

                      Vibration.singleShortBuzz();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Double Buzz'),
                    onPressed: () {
                      showSnackBar(
                        context,
                        pattern: [0, 100, 50, 100],
                      );

                      Vibration.doubleBuzz();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Triple Buzz'),
                    onPressed: () {
                      showSnackBar(
                        context,
                        pattern: [0, 100, 50, 100, 50, 100],
                      );

                      Vibration.tripleBuzz();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Long Alarm Buzz'),
                    onPressed: () {
                      showSnackBar(
                        context,
                        pattern: [0, 500],
                      );

                      Vibration.longAlarmBuzz();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Pulse Wave'),
                    onPressed: () {
                      showSnackBar(
                        context,
                        pattern: [0, 100, 100, 100, 100, 100],
                      );

                      Vibration.pulseWave();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Progressive Buzz'),
                    onPressed: () {
                      showSnackBar(
                        context,
                        pattern: [0, 100, 200, 300, 400, 500],
                      );

                      Vibration.progressiveBuzz();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Rhythmic Buzz'),
                    onPressed: () {
                      showSnackBar(
                        context,
                        pattern: [0, 200, 100, 300, 100, 200],
                      );

                      Vibration.rhythmicBuzz();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Gentle Reminder'),
                    onPressed: () {
                      showSnackBar(
                        context,
                        pattern: [0, 50, 100, 50, 100, 50],
                      );

                      Vibration.gentleReminder();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Quick Success Alert'),
                    onPressed: () {
                      showSnackBar(
                        context,
                        pattern: [0, 70, 30, 70, 30, 70],
                      );

                      Vibration.quickSuccessAlert();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Zig Zag Alert'),
                    onPressed: () {
                      showSnackBar(
                        context,
                        pattern: [0, 100, 30, 300, 30, 100],
                      );

                      Vibration.zigZagAlert();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Soft Pulse'),
                    onPressed: () {
                      showSnackBar(
                        context,
                        pattern: [0, 150, 50, 150, 50, 150],
                      );

                      Vibration.softPulse();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Emergency Alert'),
                    onPressed: () {
                      showSnackBar(
                        context,
                        pattern: [0, 500, 50, 500, 50, 500],
                      );

                      Vibration.emergencyAlert();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Heartbeat Vibration'),
                    onPressed: () {
                      showSnackBar(
                        context,
                        pattern: [0, 200, 100, 100, 100, 200],
                      );

                      Vibration.heartbeatVibration();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Countdown Timer Alert'),
                    onPressed: () {
                      showSnackBar(
                        context,
                        pattern: [
                          0,
                          100,
                          100,
                          200,
                          100,
                          300,
                          100,
                          400,
                          100,
                          500
                        ],
                      );

                      Vibration.countdownTimerAlert();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Rapid Tap Feedback'),
                    onPressed: () {
                      showSnackBar(
                        context,
                        pattern: [0, 50, 50, 50, 50, 50, 50, 50],
                      );

                      Vibration.rapidTapFeedback();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Dramatic Notification'),
                    onPressed: () {
                      showSnackBar(
                        context,
                        pattern: [0, 100, 200, 100, 300, 100, 400],
                      );

                      Vibration.dramaticNotification();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Urgent Buzz Wave'),
                    onPressed: () {
                      showSnackBar(
                        context,
                        pattern: [0, 300, 50, 300, 50, 300, 50, 300],
                      );

                      Vibration.urgentBuzzWave();
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
