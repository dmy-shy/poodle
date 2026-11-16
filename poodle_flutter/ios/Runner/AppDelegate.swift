import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "PoodleTabBar") {
      registrar.register(PoodleTabBarFactory(messenger: registrar.messenger()), withId: "poodle/ios_tab_bar")
      let channel = FlutterMethodChannel(name: "poodle/ios_navigation", binaryMessenger: registrar.messenger())
      channel.setMethodCallHandler { call, result in
        if call.method == "majorVersion" {
          result(ProcessInfo.processInfo.operatingSystemVersion.majorVersion)
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    }
  }
}
