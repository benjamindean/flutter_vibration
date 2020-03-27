import Flutter
import UIKit
import AudioToolbox
import CoreHaptics

public class SwiftVibrationPlugin: NSObject, FlutterPlugin {
    private let isDevice = TARGET_OS_SIMULATOR == 0
  
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "vibration", binaryMessenger: registrar.messenger())
        let instance = SwiftVibrationPlugin()
        
        if #available(iOS 13, *) {
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
    let supportsHaptics = hapticCapability.supportsHaptics
    print(supportsHaptics)
        }
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let ms = 1000
        switch (call.method) {
        case "hasVibrator":
            result(isDevice)
	    case "hasAmplitudeControl":
            result(isDevice)
        case "vibrate":
            guard let args = call.arguments else {
                return
            }
            if let myArgs = args as? [String: Any] {
                if let pattern = myArgs["pattern"] as? Array<Int> {
                    if pattern.count>0 {
                        if #available(iOS 13, *) {
                            var engine: CHHapticEngine?
                            if CHHapticEngine.capabilitiesForHardware().supportsHaptics {
                                var hapticpattern = [CHHapticEvent]()
                                var i: Int=0
                                var rel: Double=0.0
                                if let amplitudes = myArgs["intensities"] as? Array<Int> {
                                    while i<amplitudes.count {
                                        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(Double(amplitudes[i])/255.0))
                                        let event = CHHapticEvent(eventType: .hapticContinuous, parameters:[intensity], relativeTime: rel, duration: Double(Double(pattern[i])/1000.0))
                                        rel+=Double(Double(pattern[i])/1000.0)
                                        i+=1
                                        hapticpattern.append(event)
                                    }

                                }
                                else {
                                    while i<pattern.count {
                                        rel+=Double(Double(pattern[i])/1000.0)
                                        i+=1
                                        let event = CHHapticEvent(eventType: .hapticContinuous, parameters:[], relativeTime: rel, duration: Double(Double(pattern[i])/1000.0))
                                        rel+=Double(Double(pattern[i])/1000.0)
                                        i+=1
                                        hapticpattern.append(event)
                                    }  
                                }
                                do {
                                    engine = try CHHapticEngine()
                                    let patterntoplay = try CHHapticPattern(events: hapticpattern, parameters: [])
                                    let player = try engine.makePlayer(with: patterntoplay)
                                    try engine.start(completionHandler:nil)
                                    try player.start(atTime: 0)
                                    engine.stop(completionHandler: nil)
                                } catch let error{
                                    print("Failed to play pattern: \(error.localizedDescription).")
                                }
                            }  
                            else {
                                    var i: Int=0
                                    while i<pattern.count {
                                        usleep(useconds_t(pattern[i] * ms))
                                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                                        i+=2
                                    }
                            }          
            }
                    }
            else {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)

                }

                }
                else {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)

                }
            }
            else {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)

                }
            print(args)
            
            result(nil)
        case "cancel":
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
