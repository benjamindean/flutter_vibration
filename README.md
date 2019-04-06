# Vibration

[![Build Status](https://travis-ci.org/benjamindean/flutter_vibration.svg?branch=master)](https://travis-ci.org/benjamindean/flutter_vibration)

A plugin for handling Vibration API on iOS and Android devices. [API docs.](https://pub.dartlang.org/documentation/vibration/latest/vibration/Vibration-class.html)

## Getting Started

1. Add `vibration` to the dependencies section of `pubspec.yaml`.

    ``` yml
    dependencies:
      vibration: 1.0.2
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

### vibrate

#### With specific duration (for example, 1 second):

``` dart
Vibration.vibrate(duration: 1000);
```

Default duration is 500ms. 

#### With pattern (wait 500ms, vibrate 1s, waint 500ms):

``` dart
Vibration.vibrate(pattern: [500, 1000, 500]);
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
