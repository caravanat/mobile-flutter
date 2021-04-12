import Flutter
import JumioCore
import Netverify
import UIKit

public class SwiftJumioMobileSdkPlugin: NSObject, FlutterPlugin {
    private let authenticationModule:       JumioMobileSdkModule    = AuthenticationModuleFlutter()
    private let netverifyModule:            NetverifyModuleFlutter  = NetverifyModuleFlutter()

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.jumio.fluttersdk", binaryMessenger: registrar.messenger())
        let instance = SwiftJumioMobileSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initNetverify":
            netverifyModule.initialize(call: call, result: result)
        case "startNetverify":
            netverifyModule.start(result: result)
        case "initAuthentication":
            authenticationModule.initialize(call: call, result: result)
        case "startAuthentication":
            authenticationModule.start(result: result)
        default:
            break
        }
    }
}
