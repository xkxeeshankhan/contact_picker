import 'dart:async';

import 'package:flutter/services.dart';

///Plugin to interact with contact Pickers
class FlutterContactPicker {
  static const MethodChannel _channel =
      const MethodChannel('me.schlaubi.contactpicker');

  ///Picks a Phone contact
  static Future<PhoneContact> pickPhoneContact() async => PhoneContact.fromMap(
      await _channel.invokeMethod<Map<dynamic, dynamic>>("pickPhoneContact"));

  ///Picks an Email contact
  static Future<EmailContact> pickEmailContact() async => EmailContact.fromMap(
      await _channel.invokeMethod<Map<dynamic, dynamic>>("pickEmailContact"));

}

abstract class Contact {
  const Contact(this.fullName);

  /// Full name of the contact
  final String fullName;
}

///Phone Contact
class PhoneContact extends Contact {
  const PhoneContact(String fullName, this.phoneNumber) : super(fullName);

  factory PhoneContact.fromMap(Map<dynamic, dynamic> map) =>
      PhoneContact(map['fullName'], PhoneNumber.fromMap(map['phoneNumber']));

  ///Phone number of the contact
  final PhoneNumber phoneNumber;
}

///Email Contact
class EmailContact extends Contact {
  const EmailContact(String fullName, this.email) : super(fullName);

  factory EmailContact.fromMap(Map<dynamic, dynamic> map) =>
      EmailContact(map['fullName'], EmailAddress.fromMap(map['email']));

  /// Email of the contact
  final EmailAddress email;
}

abstract class Labeled {
  const Labeled(this.label);

  ///Label of the labeld item
  final String label;
}

class PhoneNumber extends Labeled {
  const PhoneNumber(this.number, String label) : super(label);

  factory PhoneNumber.fromMap(Map<dynamic, dynamic> map) =>
      PhoneNumber(map['phoneNumber'], map['label']);

  ///The phone number
  final String number;
}

class EmailAddress extends Labeled {
  const EmailAddress(this.email, String label) : super(label);

  factory EmailAddress.fromMap(Map<dynamic, dynamic> map) =>
      EmailAddress(map['email'], map['label']);

  ///The email address
  final String email;
}
