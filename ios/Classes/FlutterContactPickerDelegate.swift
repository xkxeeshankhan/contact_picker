//
//  FlutterContactPickerDelegate.swift
//  fluttercontactpicker
//
//  Created by Moritz Douda on 05.03.20.
//

import Foundation
import ContactsUI

@available(iOS 9.0, *)
public class ContactPickerDelegate : NSObject, CNContactPickerDelegate {
    
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
