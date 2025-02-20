### 3.1.3

- Fix intensities on iOS.
- Lower miminum Compile SDK version for Android to 34

### 3.1.2

- Restore `hasAmplitudeControl` and `hasCustomVibrationsSupport` methods.

### 3.1.1

- Fix some cases where intensities were not being used correctly.

### 3.1.0

- Add common vibration patterns for Android and iOS.
- Add `sharpness` parameter for iOS.
- Suppress deprecation warnings for `vibrate` method on Android.

### 3.0.0

- The plugin has been recreated from scratch to align with the latest Flutter and Dart features.
- The iOS version no longer depends on intensities and amplitude, and it now supports custom durations and patterns.
- The example app is more intuitive and user-friendly.
- Calling the `hasVibrator` method is no longer necessary.
- Adjustments for null safety have been implemented.

## 2.1.0

- Fix vibration on iOS
- All methods are now properly null-safe

## 2.0.1

- Bump package `vibration_platform_interface` to "0.0.2"

## 2.0.0

- Remove references to Android embedding v1
- Update package:web to ">=0.5.1 <2.0.0" (#105 by [dkrutskikh](https://github.com/dkrutskikh))

## 1.9.0

- Added OpenHarmony support
- Migrate to common platform implement (vibration_platform_interface)

## 1.8.4

- Added Web support (#95 by [san-smith](https://github.com/san-smith))

## 1.8.2

- Raise minimum and target SDK versions for Android to upgrade Gradle to 7.5.

## 1.8.0

- Use `device_info_plus` for `hasAmplitudeControl` and `hasVibrator` methods.

## 1.7.7

- Adds a namespace attribute to the Android build.gradle, for compatibility with Android Gradle Plugin 8.0.

## 1.7.6

- Update package's dart SDK max version (under 3.0.0)

## 1.7.5

- Bump `vibration_web` to 1.6.4.

## 1.7.4

- Migrating to null safety.

## 1.7.3

- Use targetEnvironment check on iOS.

## 1.7.2

- Updated description to indicate web support.

## 1.7.1

- Fix building on iOS.

## 1.7.0

- Use Android Embedding v2.

## 1.6.1

- Added Web support (#43 by [roulljdh](https://github.com/roulljdh))

## 1.5.0

- Fibration now works in backgroud on Android (#40 by [wanghaiyang5241](https://github.com/wanghaiyang5241))

## 1.4.0

- Added a `hasCustomVibrationsSupport` method (#34 by [Skyost](https://github.com/Skyost))
- Use Swift 5.0

## 1.3.1

- Fix #32 (by [Hugo Heneault](https://github.com/HugoHeneault))

## 1.3.0

- Add support for CoreHaptics on iOS devices #30 (by [Leicas](https://github.com/Leicas))

## 1.2.4

- Move `flutter_test` to dev_dependencies. Fixes issue #24.

## 1.2.3

- Add proper indication of async methods to docs (by [@qqgg231](https://github.com/qqgg231))

## 1.2.2

- Suppress deprecation warnings for `vibrate` method

## 1.2.1

- Maintenance release

## 1.2.0

- Add support for amplitude control under Android 8.0 and later (by [@pmundt](https://github.com/pmundt))

## 1.1.0

- Migrate to AndroidX (by [@gastonmuijtjens](https://github.com/gastonmuijtjens))
- Add unit test for canceling vibration (by [@vintage](https://github.com/vintage))

## 1.0.2

- Update vibration.podspec

## 1.0.1

- Implemented `cancel` method for iOS

## 1.0.0

- Initial Release
