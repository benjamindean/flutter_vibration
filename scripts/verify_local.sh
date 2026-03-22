#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OVERRIDE_CONTENT='dependency_overrides:
  vibration_platform_interface:
    path: ../vibration_platform_interface'

PACKAGES=("vibration" "vibration_ohos")
CREATED_OVERRIDES=()

cleanup() {
  for f in "${CREATED_OVERRIDES[@]}"; do
    rm -f "$f"
  done
}
trap cleanup EXIT

for pkg in "${PACKAGES[@]}"; do
  target="$REPO_ROOT/$pkg/pubspec_overrides.yaml"
  if [ ! -f "$target" ]; then
    echo "$OVERRIDE_CONTENT" > "$target"
    CREATED_OVERRIDES+=("$target")
  fi
done

echo "=== vibration_platform_interface: flutter analyze ==="
(cd "$REPO_ROOT/vibration_platform_interface" && flutter pub get --no-example && dart analyze lib/)

echo ""
echo "=== vibration: flutter analyze ==="
(cd "$REPO_ROOT/vibration" && flutter pub get --no-example && dart analyze lib/ test/)

echo ""
echo "=== vibration: flutter test ==="
(cd "$REPO_ROOT/vibration" && flutter test --no-pub test/vibration_test.dart)

echo ""
echo "=== vibration_ohos: flutter analyze ==="
(cd "$REPO_ROOT/vibration_ohos" && flutter pub get --no-example && dart analyze lib/)

echo ""
echo "All checks passed."
