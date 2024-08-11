import Flutter
import UIKit

public class SwiftEpsonEposPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "epson_epos", binaryMessenger: registrar.messenger())
        let instance = SwiftEpsonEposPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    private var pluginImplement = PluginImplement()
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case PluginMethods.onDiscovery.rawValue:
            pluginImplement.onDiscovery(call, result: result)
            
        case PluginMethods.onPrint.rawValue:
            pluginImplement.onPrint(call, result: result)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    
}
