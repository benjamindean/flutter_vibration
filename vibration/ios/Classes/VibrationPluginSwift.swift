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

    private func getIntensities(myArgs: [String: Any]) -> [Int] {
        if let intensities = myArgs["intensities"] as? [Int], !intensities.isEmpty {
            return intensities
        }

        let amplitude = myArgs["amplitude"] as? Int ?? 255
        let pattern = getPattern(myArgs: myArgs)

        if pattern.count == 1 {
            return [amplitude]
        }

        return pattern.enumerated().map { $0.offset % 2 == 0 ? 0 : amplitude }
    }

    private func getPattern(myArgs: [String: Any]) -> [Int] {
        return myArgs["pattern"] as? [Int] ?? [getDuration(myArgs: myArgs)]
    }

    private func getDuration(myArgs: [String: Any]) -> Int {
        return myArgs["duration"] as? Int ?? 500
    }

    @available(iOS 13.0, *)
    private func playPattern(myArgs: [String: Any]) -> Void {
        let intensities = getIntensities(myArgs: myArgs)
        let patternArray = getPattern(myArgs: myArgs)
        let sharpness = myArgs["sharpness"] as? Float ?? 0.5

        var hapticEvents: [CHHapticEvent] = []
        var rel: Double = 0.0

        for (i, duration) in patternArray.enumerated() {
            if intensities[i] != 0 {
                let p = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(intensities[i]) / 255.0)
                let s = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
                let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [p, s], relativeTime: rel, duration: Double(duration) / 1000.0)

                hapticEvents.append(event)

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
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }

    @available(iOS 13.0, *)
    private func cancelVibration() {
        VibrationPluginSwift.engine?.stop(completionHandler: { error in
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
