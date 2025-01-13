import FlutterMacOS
import Foundation

public class MooncakePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "mooncake", binaryMessenger: registrar.messenger)
        let instance = MooncakePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        // Handle method calls here
        result(FlutterMethodNotImplemented)
    }
}
