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
        body: Center(
          child: Column(
            children: <Widget>[
              MaterialButton(
                child: Text('Vibrate for default 500ms'),
                onPressed: () {
                  Vibration.vibrate();
                },
              ),
              MaterialButton(
                child: Text('Vibrate for 1000ms'),
                onPressed: () {
                  Vibration.vibrate(duration: 1000);
                },
              ),
              MaterialButton(
                child: Text('Vibrate with pattern 100v-200p-300v-400p-500v'),
                onPressed: () {
                  Vibration.vibrate(pattern: [100, 200, 300, 400, 500]);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
