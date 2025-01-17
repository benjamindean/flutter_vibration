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
