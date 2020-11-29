import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

void main() => runApp(VibratingApp());

class VibratingApp extends StatelessWidget {
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
                  RaisedButton(
                    child: Text('Vibrate for default 500ms'),
                    onPressed: () {
                      Vibration.vibrate();
                    },
                  ),
                  RaisedButton(
                    child: Text('Vibrate for 1000ms'),
                    onPressed: () {
                      Vibration.vibrate(duration: 1000);
                    },
                  ),
                  RaisedButton(
                    child: Text('Vibrate with pattern'),
                    onPressed: () {
                      final snackBar = SnackBar(
                        content: Text(
                          'Pattern: wait 0.5s, vibrate 1s, wait 0.5s, vibrate 2s, wait 0.5s, vibrate 3s, wait 0.5s, vibrate 0.5s',
                        ),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                      Vibration.vibrate(
                        pattern: [500, 1000, 500, 2000, 500, 3000, 500, 500],
                      );
                    },
                  ),
                  RaisedButton(
                    child: Text('Vibrate with pattern and amplitude'),
                    onPressed: () {
                      final snackBar = SnackBar(
                        content: Text(
                          'Pattern: wait 0.5s, vibrate 1s, wait 0.5s, vibrate 2s, wait 0.5s, vibrate 3s, wait 0.5s, vibrate 0.5s',
                        ),
                      );

                      Scaffold.of(context).showSnackBar(snackBar);
                      Vibration.vibrate(
                        pattern: [500, 1000, 500, 2000, 500, 3000, 500, 500],
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
