import AudioToolbox
import CoreHaptics
import Flutter
import UIKit

public class VibrationPluginSwift: NSObject, FlutterPlugin {
#if targetEnvironment(simulator)
    private let isDevice = false
#else
    private let isDevice = true
#endif

    @available(iOS 13.0, *)
    public static var engine: CHHapticEngine?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "vibration", binaryMessenger: registrar.messenger())
        let instance = VibrationPluginSwift()

        if #available(iOS 13.0, *) {
            VibrationPluginSwift.createEngine()
        }

        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    @available(iOS 13.0, *)
    public static func createEngine() {
        // Create and configure a haptic engine.
        do {
            VibrationPluginSwift.engine = try CHHapticEngine()
        } catch {
            print("Engine creation error: \(error)")
            return
        }

        if VibrationPluginSwift.engine == nil {
            print("Failed to create engine!")
        }

        // The stopped handler alerts you of engine stoppage due to external causes.
        VibrationPluginSwift.engine?.stoppedHandler = { reason in
            print("The engine stopped for reason: \(reason.rawValue)")
        }

        // The reset handler provides an opportunity for your app to restart the engine in case of failure.
        VibrationPluginSwift.engine?.resetHandler = {
            // Try restarting the engine.
            print("The engine reset --> Restarting now!")

            do {
                try VibrationPluginSwift.engine?.start()
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

    @available(iOS 13.0, *)
    private func playPattern(myArgs: [String: Any]) -> Void {
        let intensities = getIntensities(myArgs: myArgs)
        let patternArray = getPattern(myArgs: myArgs)
        let sharpness = getSharpness(myArgs: myArgs)

        var hapticEvents: [CHHapticEvent] = []
        var rel: Double = 0.0

        for (i, duration) in patternArray.enumerated() {
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

                rel += Double(duration) / 1000.0
            } else {
                rel += Double(duration) / 1000.0
            }
        }

        do {
            if let engine = VibrationPluginSwift.engine {
                let patternToPlay = try CHHapticPattern(events: hapticEvents, parameters: [])
                let player = try engine.makePlayer(with: patternToPlay)
                try engine.start()
                try player.start(atTime: 0)
            }
        } catch {
            print("Failed to play pattern: \(error.localizedDescription). Play default.")
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
    }

    @available(iOS 13.0, *)
    private func cancelVibration() {
        VibrationPluginSwift.engine?.stop(completionHandler: { error in
            if let error = error {
                print("Error stopping haptic engine: \(error)")
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
