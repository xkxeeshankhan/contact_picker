import Flutter
import UIKit
import ContactsUI

@available(iOS 9.0, *)
public class SwiftFlutterContactPickerPlugin: NSObject, FlutterPlugin {
    
    private var pickerDelegate: CNContactPickerDelegate?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "me.schlaubi.contactpicker", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterContactPickerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    private func requestPicker(result: @escaping FlutterResult, type: String, neededProperty: String) {
        let controller = CNContactPickerViewController()
        pickerDelegate = ContactPickerDelegate(result: result, type: type)
        controller.delegate = pickerDelegate
        controller.displayedPropertyKeys = [neededProperty]
        let viewController = UIApplication.shared.delegate?.window??.rootViewController
        viewController?.present(controller, animated: true, completion: nil)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "pickPhoneContact":
            requestPicker(result: result, type: "phoneNumber", neededProperty: CNContactPhoneNumbersKey)
            break
        case "pickEmailContact":
            requestPicker(result: result, type: "email", neededProperty: CNContactEmailAddressesKey)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
  }
}
