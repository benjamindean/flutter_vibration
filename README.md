# Vibration

[![Build Status](https://travis-ci.org/benjamindean/flutter_vibration.svg?branch=master)](https://travis-ci.org/benjamindean/flutter_vibration)

A plugin for handling Vibration API on iOS and Android devices. [API docs.](https://pub.dartlang.org/documentation/vibration/latest/vibration/Vibration-class.html)

## Getting Started

1. Add `vibration` to the dependencies section of `pubspec.yaml`.

    ``` yml
    dependencies:
      vibration: 1.2.2
    ```

2. Import package:

    ``` dart
    import 'package:vibration/vibration.dart';
    ```

## Methods

### hasVibrator

Check if the target device has vibration capabilities.

``` dart
if (Vibration.hasVibrator()) {
    Vibration.vibrate();
}
```

### hasAmplitudeControl

Check if the target device has the ability to control the vibration amplitude,
introduced in Android 8.0 Oreo - false for all earlier API levels.

``` dart
if (Vibration.hasAmplitudeControl()) {
    Vibration.vibrate(amplitude: 128);
}
```

### vibrate

#### With specific duration (for example, 1 second):

``` dart
Vibration.vibrate(duration: 1000);
```

Default duration is 500ms. 

#### With specific duration and specific amplitude (if supported):

``` dart
Vibration.vibrate(duration: 1000, amplitude: 128);
```

#### With pattern (wait 500ms, vibrate 1s, wait 500ms, vibrate 2s):

``` dart
Vibration.vibrate(pattern: [500, 1000, 500, 2000]);
```

#### With pattern (wait 500ms, vibrate 1s, wait 500ms, vibrate 2s) at varying intensities (1 - min, 255 - max):

``` dart
Vibration.vibrate(pattern: [500, 1000, 500, 2000], intensities: [1, 255]);
```

### cancel

Stop ongoing vibration.

``` dart
Vibration.cancel();
```

## Android

The `VIBRATE` permission is required in AndroidManifest.xml.

``` xml
<uses-permission android:name="android.permission.VIBRATE"/>
```

Supports vibration with duration and pattern. On Android 8 (Oreo) and above, uses the [VibrationEffect](https://developer.android.com/reference/android/os/VibrationEffect) class.
For the rest of the usage instructions, see [Vibrator](https://developer.android.com/reference/android/os/Vibrator) class documentation.

## iOS

Only supports singular vibrations with 500ms duration.

## Known issues

"Conditions must have a static type of 'bool'"
If you have this error, add 'await':

``` dart
//HasVibrate uses the Future class, so it has to use async to work:

void vibrate() async {
 if (await Vibration.hasVibrator()){
   //Vibration.vibrate();
   Vibration.vibrate(duration: 100);
  }
}
```
