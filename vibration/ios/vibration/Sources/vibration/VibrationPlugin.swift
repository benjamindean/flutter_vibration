import AudioToolbox
import CoreHaptics
import Flutter
import UIKit

public class VibrationPlugin: NSObject, FlutterPlugin {
#if targetEnvironment(simulator)
    private let isDevice = false
#else
    private let isDevice = true
#endif

    @available(iOS 13.0, *)
    public static var engine: CHHapticEngine?

    /// Monotonically-increasing counter used to invalidate in-flight repeat closures.
    /// Incrementing this value causes any `scheduleRepeat` closure that captured an older
    /// generation to exit without playing, effectively cancelling the active loop.
    @available(iOS 13.0, *)
    private static var repeatGeneration: Int = 0

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "vibration", binaryMessenger: registrar.messenger())
        let instance = VibrationPlugin()

        if #available(iOS 13.0, *) {
            VibrationPlugin.createEngine()
        }

        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    @available(iOS 13.0, *)
    public static func createEngine() {
        // Create and configure a haptic engine.
        do {
            VibrationPlugin.engine = try CHHapticEngine()
        } catch {
            print("Engine creation error: \(error)")
            return
        }

        if VibrationPlugin.engine == nil {
            print("Failed to create engine!")
        }

        // The stopped handler alerts you of engine stoppage due to external causes.
        // Cancel any active repeat loop for all stop reasons except .notifyWhenFinished,
        // which is an intentional completion and not applicable to our usage.
        VibrationPlugin.engine?.stoppedHandler = { reason in
            print("The engine stopped for reason: \(reason.rawValue)")
            if reason != .notifyWhenFinished {
                VibrationPlugin.repeatGeneration += 1
            }
        }

        // The reset handler provides an opportunity for your app to restart the engine in case of failure.
        VibrationPlugin.engine?.resetHandler = {
            // Try restarting the engine.
            print("The engine reset --> Restarting now!")

            do {
                try VibrationPlugin.engine?.start()
            } catch {
                print("Failed to restart the engine: \(error)")
            }
        }
    }

    private func supportsHaptics() -> Bool {
        if #available(iOS 13.0, *) {
            return CHHapticEngine.capabilitiesForHardware().supportsHaptics
        }

        return false;
    }

    private func getAmplitude(myArgs: [String: Any]) -> Int {
        let amplitude = myArgs["amplitude"] as? Int ?? -1

        return amplitude == -1 ? 255 : amplitude
    }

    private func getIntensities(myArgs: [String: Any]) -> [Int] {
        let intensities = myArgs["intensities"] as? [Int] ?? []

        let amplitude = getAmplitude(myArgs: myArgs)
        let pattern = getPattern(myArgs: myArgs)

        if pattern.count == 1 {
            return [amplitude]
        }

        if (intensities.count == pattern.count) {
            return intensities
        }

        if intensities.count < pattern.count {
            return intensities + Array(
                repeating: intensities.last ?? amplitude,
                count: pattern.count - intensities.count
            )
        }

        return pattern.enumerated().map { $0.offset % 2 == 0 ? 0 : amplitude }
    }

    private func getPattern(myArgs: [String: Any]) -> [Int] {
        let pattern = myArgs["pattern"] as? [Int] ?? []

        if (pattern.isEmpty) {
            return [getDuration(myArgs: myArgs)]
        }

        return pattern
    }

    private func getDuration(myArgs: [String: Any]) -> Int {
        let duration = myArgs["duration"] as? Int ?? -1

        return duration == -1 ? 500 : duration
    }

    private func getSharpness(myArgs: [String: Any]) -> Float {
        return myArgs["sharpness"] as? Float ?? 0.5
    }

    /// Returns the repeat index from the method arguments, defaulting to `-1` (no repeat).
    /// A value of `0` loops the entire pattern; a value of `N` plays the full pattern once,
    /// then loops from index `N` onward on every subsequent iteration.
    private func getRepeat(myArgs: [String: Any]) -> Int {
        return myArgs["repeat"] as? Int ?? -1
    }

    /// Builds an array of `CHHapticEvent` values from a slice of the pattern.
    ///
    /// - Parameters:
    ///   - pattern: Timing values in milliseconds, alternating silence and vibration durations.
    ///   - intensities: Amplitude values (0–255) corresponding to each element in `pattern`.
    ///   - sharpness: Haptic sharpness applied to all vibration events.
    ///   - startIndex: Index into `pattern` and `intensities` to begin from. Defaults to `0`
    ///                 (full pattern). Pass `repeatIndex` here when building loop-slice events.
    @available(iOS 13.0, *)
    private func buildHapticEvents(
        pattern: [Int],
        intensities: [Int],
        sharpness: Float,
        startIndex: Int = 0
    ) -> [CHHapticEvent] {
        var hapticEvents: [CHHapticEvent] = []
        var rel: Double = 0.0

        for i in startIndex..<pattern.count {
            let duration = pattern[i]
            if intensities[i] != 0 {
                hapticEvents.append(
                    CHHapticEvent(
                        eventType: .hapticContinuous,
                        parameters: [
                            CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(intensities[i]) / 255.0),
                            CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
                        ],
                        relativeTime: rel,
                        duration: Double(duration) / 1000.0
                    )
                )
            }
            rel += Double(duration) / 1000.0
        }

        return hapticEvents
    }

    /// Submits a set of haptic events to the shared engine and starts playback immediately.
    @available(iOS 13.0, *)
    private func playHapticEvents(_ events: [CHHapticEvent]) throws {
        if let engine = VibrationPlugin.engine {
            let patternToPlay = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: patternToPlay)
            try engine.start()
            try player.start(atTime: 0)
        }
    }

    /// Schedules one loop iteration after `afterMs` milliseconds, then reschedules itself.
    ///
    /// Before each iteration the closure checks `VibrationPlugin.repeatGeneration` against
    /// the captured `generation`. If they differ — because `cancelVibration` or a new
    /// `playPattern` call incremented the counter — the closure exits without playing or
    /// rescheduling, ending the loop.
    ///
    /// - Parameters:
    ///   - pattern: Full pattern array (only the slice from `startIndex` onward is played).
    ///   - intensities: Amplitude values corresponding to each element in `pattern`.
    ///   - sharpness: Haptic sharpness forwarded to `buildHapticEvents`.
    ///   - startIndex: Index in `pattern` at which each iteration begins.
    ///   - loopSliceMs: Duration of one loop iteration in milliseconds; reused as the delay
    ///                  before the next iteration.
    ///   - generation: The `repeatGeneration` value captured when this repeat session started.
    ///   - afterMs: Delay in milliseconds before the current iteration fires.
    @available(iOS 13.0, *)
    private func scheduleRepeat(
        pattern: [Int],
        intensities: [Int],
        sharpness: Float,
        startIndex: Int,
        loopSliceMs: Int,
        generation: Int,
        afterMs: Int
    ) {
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(afterMs)) { [weak self] in
            guard let self = self,
                  VibrationPlugin.repeatGeneration == generation else { return }
            do {
                let loopEvents = self.buildHapticEvents(
                    pattern: pattern,
                    intensities: intensities,
                    sharpness: sharpness,
                    startIndex: startIndex
                )
                try self.playHapticEvents(loopEvents)
            } catch {
                print("Failed to play repeat loop: \(error.localizedDescription).")
                return
            }
            self.scheduleRepeat(
                pattern: pattern,
                intensities: intensities,
                sharpness: sharpness,
                startIndex: startIndex,
                loopSliceMs: loopSliceMs,
                generation: generation,
                afterMs: loopSliceMs
            )
        }
    }

    @available(iOS 13.0, *)
    private func playPattern(myArgs: [String: Any]) -> Void {
        let intensities = getIntensities(myArgs: myArgs)
        let patternArray = getPattern(myArgs: myArgs)
        let sharpness = getSharpness(myArgs: myArgs)
        let repeatIndex = getRepeat(myArgs: myArgs)

        do {
            let events = buildHapticEvents(pattern: patternArray, intensities: intensities, sharpness: sharpness)
            try playHapticEvents(events)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
            return
        }

        guard repeatIndex >= 0, repeatIndex < patternArray.count else { return }

        VibrationPlugin.repeatGeneration += 1
        let gen = VibrationPlugin.repeatGeneration
        let firstPlayMs = patternArray.reduce(0, +)
        let loopSliceMs = patternArray[repeatIndex...].reduce(0, +)

        scheduleRepeat(
            pattern: patternArray,
            intensities: intensities,
            sharpness: sharpness,
            startIndex: repeatIndex,
            loopSliceMs: loopSliceMs,
            generation: gen,
            afterMs: firstPlayMs
        )
    }

    @available(iOS 13.0, *)
    private func cancelVibration() {
        VibrationPlugin.repeatGeneration += 1
        VibrationPlugin.engine?.stop(completionHandler: { error in
            if let error = error {
                print("Error stopping haptic engine: \(error)")
            } else {
                print("Haptic engine stopped successfully.")
            }
        })
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "hasCustomVibrationsSupport":
            result(supportsHaptics())
        case "vibrate":
            guard let myArgs = call.arguments as? [String: Any] else {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                result(true)
                return
            }

            if !supportsHaptics() {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                result(true)
                return
            }

            if #available(iOS 13.0, *) {
                playPattern(myArgs: myArgs)
                result(true)
                return
            }

            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            result(true)
            return
        case "cancel":
            if #available(iOS 13.0, *) {
                cancelVibration()
            } else {
                result(false)
            }

            result(true)
            return
        default:
            result(FlutterMethodNotImplemented)
            return
        }
    }
}
