import AudioToolbox
import CoreHaptics
import Flutter
import UIKit

public class VibrationPluginSwift: NSObject, FlutterPlugin {
    private let isDevice = TARGET_OS_SIMULATOR == 1
    
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
    
    @available(iOS 13.0, *)
    private func playPattern(myArgs: [String: Any], pattern: [Int]) -> Void {
        // Get event parameters, if any
        var params: [CHHapticEventParameter] = []
        
        if let amplitudes = myArgs["intensities"] as? [Int] {
            if amplitudes.count > 0 {
                // There should be half as many amplitudes as pattern
                // i.e. disregard all the wait times
                assert(amplitudes.count == pattern.count / 2)
            }
            
            for a in amplitudes {
                let p = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(Double(a) / 255.0))
                params.append(p)
            }
        }
        
        // Create haptic events
        var hapticEvents: [CHHapticEvent] = []
        var i: Int = 0
        var rel: Double = 0.0
        
        while i < pattern.count {
            // Get intensity parameter, if any
            let j = i / 2
            let p = j < params.count ? [params[j]] : []
            
            // Get wait time and duration
            let waitTime = Double(pattern[i]) / 1000.0
            let duration = Double(pattern[i + 1]) / 1000.0
            
            rel += waitTime
            i += 2
            
            // Create haptic event
            let e = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: p,
                relativeTime: rel,
                duration: duration
            )
            
            hapticEvents.append(e)
            
            // Add duration to relative time
            rel += duration
        }
        
        // Try to play engine
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
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "hasVibrator":
            result(isDevice)
        case "hasAmplitudeControl":
            result(isDevice)
        case "hasCustomVibrationsSupport":
            result(supportsHaptics())
        case "vibrate":
            guard let args = call.arguments else {
                result(isDevice)
                return
            }
            
            guard let myArgs = args as? [String: Any] else {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                result(isDevice)
                return
            }
            
            guard let pattern = myArgs["pattern"] as? [Int] else {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                result(isDevice)
                return
            }
            
            if pattern.count == 0 {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                result(isDevice)
                return
            }
            
            assert(pattern.count % 2 == 0, "Pattern must have even number of elements!")
            
            if !supportsHaptics() {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                result(isDevice)
                return
            }
            
            if #available(iOS 13.0, *) {
                playPattern(myArgs: myArgs, pattern: pattern)
            }
            
            result(isDevice)
        case "cancel":
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
