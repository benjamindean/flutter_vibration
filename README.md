# Vibration

[![Build Status](https://travis-ci.org/benjamindean/flutter_vibration.svg?branch=master)](https://travis-ci.org/benjamindean/flutter_vibration)

A plugin for handling Vibration API on iOS, Android, and web. [API docs.](https://pub.dartlang.org/documentation/vibration/latest/vibration/Vibration-class.html)

## Versions

[Android, iOS.](vibration)

[Web.](vibration_web)

---

## Local Development

This is a monorepo. The `vibration` and `vibration_ohos` packages depend on
`vibration_platform_interface` by hosted version. When the latest interface
changes haven't been published yet, you need local path overrides to run
analysis and tests.

### Quick start

```bash
./scripts/verify_local.sh
```

The script creates temporary `pubspec_overrides.yaml` files, runs
`flutter analyze` and `flutter test` across the three packages, then removes
the overrides automatically.

### Manual setup

Copy the example override in each consumer package:

```bash
cp vibration/pubspec_overrides.yaml.example vibration/pubspec_overrides.yaml
cp vibration_ohos/pubspec_overrides.yaml.example vibration_ohos/pubspec_overrides.yaml
```

Then run the standard commands:

```bash
# Platform interface (no override needed — it's the source)
cd vibration_platform_interface && flutter pub get && dart analyze lib/

# Main package
cd vibration && flutter pub get --no-example && dart analyze lib/ test/
cd vibration && flutter test test/vibration_test.dart

# OHOS package
cd vibration_ohos && flutter pub get --no-example && dart analyze lib/
```

Delete the overrides when done — they are gitignored but should not be left
around for publishing.
