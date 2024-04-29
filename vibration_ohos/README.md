# vibration_ohos

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
