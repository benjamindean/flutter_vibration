import Flutter
import UIKit
import AudioToolbox

public class SwiftVibrationPlugin: NSObject, FlutterPlugin {
    private let isDevice = TARGET_OS_SIMULATOR == 0
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "vibration", binaryMessenger: registrar.messenger())
        let instance = SwiftVibrationPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case "hasVibrator":
            result(isDevice)
	case "hasAmplitudeControl":
            result(isDevice)
        case "vibrate":
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            result(nil)
        case "cancel":
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
