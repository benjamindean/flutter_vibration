/// Configuration for a vibration preset.
class VibrationPresetConfig {
  /// The pattern of the vibration in milliseconds.
  final List<int> pattern;

  /// The intensities of the vibration, ranging from 0 to 255.
  final List<int> intensities;

  /// Creates a new vibration preset configuration.
  const VibrationPresetConfig({
    required this.pattern,
    required this.intensities,
  });
}

/// Enum representing different vibration presets.
enum VibrationPreset {
  singleShortBuzz,
  doubleBuzz,
  tripleBuzz,
  longAlarmBuzz,
  pulseWave,
  progressiveBuzz,
  rhythmicBuzz,
  gentleReminder,
  quickSuccessAlert,
  zigZagAlert,
  softPulse,
  emergencyAlert,
  heartbeatVibration,
  countdownTimerAlert,
  rapidTapFeedback,
  dramaticNotification,
  urgentBuzzWave,
}

/// A map of vibration presets to their configurations.
final Map<VibrationPreset, VibrationPresetConfig> presets = {
  VibrationPreset.singleShortBuzz: VibrationPresetConfig(
    pattern: [0, 100],
    intensities: [0, 255],
  ),
  VibrationPreset.doubleBuzz: VibrationPresetConfig(
    pattern: [0, 100, 50, 100],
    intensities: [0, 255, 0, 255],
  ),
  VibrationPreset.tripleBuzz: VibrationPresetConfig(
    pattern: [0, 100, 50, 100, 50, 100],
    intensities: [0, 255, 0, 255, 0, 255],
  ),
  VibrationPreset.longAlarmBuzz: VibrationPresetConfig(
    pattern: [0, 500],
    intensities: [0, 255],
  ),
  VibrationPreset.pulseWave: VibrationPresetConfig(
    pattern: [0, 100, 100, 100, 100, 100],
    intensities: [0, 200, 0, 200, 0, 200],
  ),
  VibrationPreset.progressiveBuzz: VibrationPresetConfig(
    pattern: [0, 100, 200, 300, 400, 500],
    intensities: [0, 100, 150, 200, 255, 255],
  ),
  VibrationPreset.rhythmicBuzz: VibrationPresetConfig(
    pattern: [0, 200, 100, 300, 100, 200],
    intensities: [0, 150, 0, 255, 0, 200],
  ),
  VibrationPreset.gentleReminder: VibrationPresetConfig(
    pattern: [0, 50, 100, 50, 100, 50],
    intensities: [0, 128, 0, 128, 0, 128],
  ),
  VibrationPreset.quickSuccessAlert: VibrationPresetConfig(
    pattern: [0, 70, 30, 70, 30, 70],
    intensities: [0, 255, 0, 255, 0, 255],
  ),
  VibrationPreset.zigZagAlert: VibrationPresetConfig(
    pattern: [0, 100, 30, 300, 30, 100],
    intensities: [0, 200, 0, 255, 0, 200],
  ),
  VibrationPreset.softPulse: VibrationPresetConfig(
    pattern: [0, 150, 50, 150, 50, 150],
    intensities: [0, 100, 0, 100, 0, 100],
  ),
  VibrationPreset.emergencyAlert: VibrationPresetConfig(
    pattern: [0, 500, 50, 500, 50, 500],
    intensities: [0, 255, 0, 255, 0, 255],
  ),
  VibrationPreset.heartbeatVibration: VibrationPresetConfig(
    pattern: [0, 200, 100, 100, 100, 200],
    intensities: [0, 255, 0, 100, 0, 255],
  ),
  VibrationPreset.countdownTimerAlert: VibrationPresetConfig(
    pattern: [0, 100, 100, 200, 100, 300, 100, 400, 100, 500],
    intensities: [0, 100, 0, 150, 0, 200, 0, 255, 0, 255],
  ),
  VibrationPreset.rapidTapFeedback: VibrationPresetConfig(
    pattern: [0, 50, 50, 50, 50, 50, 50, 50],
    intensities: [0, 180, 0, 180, 0, 180, 0, 180],
  ),
  VibrationPreset.dramaticNotification: VibrationPresetConfig(
    pattern: [0, 100, 200, 100, 300, 100, 400],
    intensities: [0, 255, 0, 200, 0, 150, 0],
  ),
  VibrationPreset.urgentBuzzWave: VibrationPresetConfig(
    pattern: [0, 300, 50, 300, 50, 300, 50, 300],
    intensities: [0, 255, 0, 230, 0, 210, 0, 200],
  ),
};
