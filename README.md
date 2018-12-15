# Vibration

A plugin for handling Vibration API in Flutter apps.

## Getting Started

1. Add `vibration` to the dependencies section of `pubspec.yaml`.

```
dependencies:
  vibration:
    git:
      url: git@github.com:benjamindean/flutter_vibration.git
```

2. Import package:

    ```
    import 'package:vibration/vibration.dart';
    ```

## Methods

### Vibration.hasVibrator()

Used to check if the target device has vibration capabilities. Returns `bool`.

### Vibration.vibrate(...)

```
Vibration.vibrate(duration: [int], pattern: [List<int>], repeat: [int])
```

Vibrate device for a certain duration or by pattern. You can either pass `duration` or `pattern` argument - not both at the same time.

## Android

Supports vibration with duration and pattern. On Android 8 (Oreo) and above, uses the [VibrationEffect](https://developer.android.com/reference/android/os/VibrationEffect) class.

### iOS

Only supports singular vibrations with 500ms duration.
