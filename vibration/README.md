# Vibration

[![Build Status](https://travis-ci.org/benjamindean/flutter_vibration.svg?branch=master)](https://travis-ci.org/benjamindean/flutter_vibration)

A plugin for handling Vibration API on iOS, Android, and web. [API docs.](https://pub.dartlang.org/documentation/vibration/latest/vibration/Vibration-class.html)

## Getting Started

1. Add `vibration` to the dependencies section of `pubspec.yaml`.

   ```yml
   dependencies:
     vibration: ^3.1.0
   ```

2. Import package:

   ```dart
   import 'package:vibration/vibration.dart';
   ```

## Methods

### hasVibrator

Check if the target device has vibration capabilities. Not required when using other methods.

```dart
if (await Vibration.hasVibrator()) {
    Vibration.vibrate();
}
```

### hasAmplitudeControl

Check if the target device has the ability to control the vibration amplitude,
introduced in Android 8.0 Oreo - false for all earlier API levels.

```dart
if (await Vibration.hasAmplitudeControl()) {
    Vibration.vibrate(amplitude: 128);
}
```

### hasCustomVibrationsSupport

Check if the device is able to vibrate with a custom duration, pattern or intensity.
May return `true` even if the device has no vibrator (if you want to check whether the device has a vibrator,
see [`hasVibrator`](#hasVibrator)).

```dart
if (await Vibration.hasCustomVibrationsSupport()) {
    Vibration.vibrate(duration: 1000);
} else {
    Vibration.vibrate();
    await Future.delayed(Duration(milliseconds: 500));
    Vibration.vibrate();
}
```

### vibrate

#### Method Arguments

- `duration`: Duration of the vibration in milliseconds. Default is 500ms.
- `pattern`: List of integers representing the vibration pattern. Alternates between wait and vibrate durations.
- `repeat`: Index in the pattern at which to repeat, or -1 for no repeat. Default is -1.
- `intensities`: List of integers representing the vibration intensities for each segment in the pattern.
- `amplitude`: Amplitude of the vibration. Range is 1 to 255. Default is -1 (use platform default).
- `sharpness`: Sharpness of the vibration. iOS only. Range is 0.0 to 1.0. Default is 0.5.
- `preset`: Predefined vibration preset. Overrides other parameters if provided.

#### With specific duration (for example, 1 second):

```dart
Vibration.vibrate(duration: 1000);
```

Default duration is 500ms.

#### With specific duration and specific amplitude (if supported):

```dart
Vibration.vibrate(duration: 1000, amplitude: 128);
```

#### With pattern (wait 500ms, vibrate 1s, wait 500ms, vibrate 2s):

```dart
Vibration.vibrate(pattern: [500, 1000, 500, 2000]);
```

#### With pattern (wait 500ms, vibrate 1s, wait 500ms, vibrate 2s) at varying intensities (1 - min, 255 - max):

```dart
Vibration.vibrate(pattern: [500, 1000, 500, 2000], intensities: [1, 255]);
```

#### With vibration presets:

You can use predefined vibration presets for common use cases.

```dart
Vibration.vibrate(preset: VibrationPreset.alarm);
```

Available presets:

- `VibrationPreset.alarm`
- `VibrationPreset.notification`
- `VibrationPreset.heartbeat`
- `VibrationPreset.singleShortBuzz`
- `VibrationPreset.doubleBuzz`
- `VibrationPreset.tripleBuzz`
- `VibrationPreset.longAlarmBuzz`
- `VibrationPreset.pulseWave`
- `VibrationPreset.progressiveBuzz`
- `VibrationPreset.rhythmicBuzz`
- `VibrationPreset.gentleReminder`
- `VibrationPreset.quickSuccessAlert`
- `VibrationPreset.zigZagAlert`
- `VibrationPreset.softPulse`
- `VibrationPreset.emergencyAlert`
- `VibrationPreset.heartbeatVibration`
- `VibrationPreset.countdownTimerAlert`
- `VibrationPreset.rapidTapFeedback`
- `VibrationPreset.dramaticNotification`
- `VibrationPreset.urgentBuzzWave`

### cancel

Stop ongoing vibration.

```dart
Vibration.cancel();
```

## Android

The `VIBRATE` permission is required in AndroidManifest.xml.

```xml
<uses-permission android:name="android.permission.VIBRATE"/>
```

Supports vibration with duration and pattern. On Android 8 (Oreo) and above, uses the [VibrationEffect](https://developer.android.com/reference/android/os/VibrationEffect) class.
For the rest of the usage instructions, see [Vibrator](https://developer.android.com/reference/android/os/Vibrator) class documentation.

## iOS

Supports vibration with duration and pattern on CoreHaptics devices. On older devices, the pattern is emulated with 500ms long vibrations.
You can check whether the current device has CoreHaptics support using [`hasCustomVibrationsSupport`](#hasCustomVibrationsSupport).

## OpenHarmony

The OpenHarmony implementation of [`vibration`][1].

[`vibration`][1] 在 OpenHarmony 平台的实现。

Add the following permission settings to your project's module.json5 file.

在你的项目的 `module.json5` 文件中增加以下权限设置。

```json
    "requestPermissions": [
         {"name" :  "ohos.permission.VIBRATE"},
    ]
```

## Usage

```yaml
dependencies:
  vibration: any
  vibration_ohos: any
```

`vibrateEffect` and `vibrateAttribute` are only exist in `VibrationOhos`.

```dart
 (VibrationPlatform.instance as VibrationOhos).vibrate(
   vibrateEffect: const VibratePreset(count: 100),
   vibrateAttribute: const VibrateAttribute(
     usage: 'alarm',
   ),
 );
```

[1]: https://pub.dev/packages/vibration
