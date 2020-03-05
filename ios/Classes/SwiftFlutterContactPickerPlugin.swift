import Flutter
import UIKit
import ContactsUI

@available(iOS 9.0, *)
public class SwiftFlutterContactPickerPlugin: NSObject, FlutterPlugin, CNContactPickerDelegate {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "fluttercontactpicker", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterContactPickerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    private func requestPicker(result: @escaping FlutterResult, type: String, neededProperty: String) {
        let controller = CNContactPickerViewController()
        let pickerDelegate = ContactPickerDelegate(result: result, type: type)
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
    
    private class ContactPickerDelegate : NSObject, CNContactPickerDelegate {
        
        private let result: FlutterResult
        private let type: String
        
        init(result: @escaping FlutterResult, type: String) {
            self.result = result
            self.type = type
        }
        
        public func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
            let fullName = CNContactFormatter.string(from: contactProperty.contact, style: CNContactFormatterStyle.fullName)
            let itemRaw = contactProperty.value
            var item: Any?
            if(itemRaw is CNPhoneNumber) {
                item = (itemRaw as! CNPhoneNumber).stringValue
            } else {
                item = itemRaw
            }
            let label = CNLabeledValue<NSString>.localizedString(forLabel: contactProperty.label!)
            let dict = [
                "fullName": fullName as Any,
                type: [
                    type: item,
                    "label": label
                ],
                ] as [String : Any]
            result(dict)
        }
        
        public func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            result(nil)
        }
        
    }
}
