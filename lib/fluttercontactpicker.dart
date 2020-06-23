import 'dart:async';

import 'package:flutter/services.dart';

///Plugin to interact with contact Pickers
class FlutterContactPicker {
  static const MethodChannel _channel =
      const MethodChannel('me.schlaubi.contactpicker');

  ///Picks a Phone contact
  ///Automatically checks for permission if [askForPermission] is true
  ///Requires [hasPermission] on Android 11+
  static Future<PhoneContact> pickPhoneContact(
          {bool askForPermission = true}) async =>
      PhoneContact.fromMap(await _channel.invokeMethod<Map<dynamic, dynamic>>(
          'pickPhoneContact', {'askForPermission': askForPermission}));

  ///Picks an Email contact
  ///Automatically checks for permission if [askForPermission] is true
  ///Requires [hasPermission] on Android 11+
  static Future<EmailContact> pickEmailContact(
          {bool askForPermission = true}) async =>
      EmailContact.fromMap(await _channel.invokeMethod<Map<dynamic, dynamic>>(
          'pickEmailContact', {'askForPermission': askForPermission}));

  ///Picks a full contact
  ///Automatically checks for permission if [askForPermission] is true
  ///Always requires [hasPermission] to return true
  /// Currently Android only because iOS does not provide api to select whole contact
  static Future<FullContact> pickContact(
          {bool askForPermission = true}) async =>
      FullContact.fromMap(await _channel.invokeMethod<Map<dynamic, dynamic>>(
          'pickContact', {'askForPermission': askForPermission}));

  /// Checks if the contact permission is already granted
  static Future<bool> hasPermission() async =>
      _channel.invokeMethod('hasPermission');

  /// Checks if the permission is already granted and requests if it is not or [force] is true
  static Future<bool> requestPermission({bool force = false}) async {
    if (!force) {
      var granted = await hasPermission();
      if (granted) return true;
    }
    return await _channel.invokeMethod('requestPermission');
  }
}

abstract class Contact {
  const Contact(this.fullName);

  /// Full name of the contact
  final String fullName;

  @override
  String toString() {
    return 'Contact{fullName: $fullName}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Contact &&
          runtimeType == other.runtimeType &&
          fullName == other.fullName;

  @override
  int get hashCode => fullName.hashCode;
}

///Phone Contact
class PhoneContact extends Contact {
  const PhoneContact(String fullName, this.phoneNumber) : super(fullName);

  factory PhoneContact.fromMap(Map<dynamic, dynamic> map) =>
      PhoneContact(map['fullName'], PhoneNumber.fromMap(map['phoneNumber']));

  ///Phone number of the contact
  final PhoneNumber phoneNumber;

  @override
  String toString() {
    return 'PhoneContact{phoneNumber: $phoneNumber}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneContact &&
          runtimeType == other.runtimeType &&
          phoneNumber == other.phoneNumber;

  @override
  int get hashCode => phoneNumber.hashCode;
}

///Email Contact
class EmailContact extends Contact {
  const EmailContact(String fullName, this.email) : super(fullName);

  factory EmailContact.fromMap(Map<dynamic, dynamic> map) =>
      EmailContact(map['fullName'], EmailAddress.fromMap(map['email']));

  /// Email of the contact
  final EmailAddress email;

  @override
  String toString() {
    return 'EmailContact{email: $email}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailContact &&
          runtimeType == other.runtimeType &&
          email == other.email;

  @override
  int get hashCode => email.hashCode;
}

abstract class Labeled {
  const Labeled(this.label);

  ///Label of the labeled item
  final String label;

  @override
  String toString() {
    return 'Labeled{label: $label}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Labeled &&
          runtimeType == other.runtimeType &&
          label == other.label;

  @override
  int get hashCode => label.hashCode;
}

class PhoneNumber extends Labeled {
  const PhoneNumber(this.number, String label) : super(label);

  factory PhoneNumber.fromMap(Map<dynamic, dynamic> map) =>
      PhoneNumber(map['phoneNumber'], map['label']);

  ///The phone number
  final String number;

  @override
  String toString() {
    return 'PhoneNumber{number: $number}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneNumber &&
          runtimeType == other.runtimeType &&
          number == other.number;

  @override
  int get hashCode => number.hashCode;
}

class EmailAddress extends Labeled {
  const EmailAddress(this.email, String label) : super(label);

  factory EmailAddress.fromMap(Map<dynamic, dynamic> map) =>
      EmailAddress(map['email'], map['label']);

  ///The email address
  final String email;

  @override
  String toString() {
    return 'EmailAddress{email: $email}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailAddress &&
          runtimeType == other.runtimeType &&
          email == other.email;

  @override
  int get hashCode => email.hashCode;
}

class StructuredName {
  final String firstName;
  final String middleName;
  final String nickName;
  final String lastName;

  StructuredName(this.firstName, this.middleName, this.nickName, this.lastName);

  factory StructuredName.fromMap(Map<dynamic, dynamic> map) => StructuredName(
      map['firstName'], map['middleName'], map['nickname'], map['lastName']);

  @override
  String toString() {
    return 'StructuredName{firstName: $firstName, middleName: $middleName, nicktName: $nickName, lastName: $lastName}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StructuredName &&
          runtimeType == other.runtimeType &&
          firstName == other.firstName &&
          middleName == other.middleName &&
          nickName == other.nickName &&
          lastName == other.lastName;

  @override
  int get hashCode =>
      firstName.hashCode ^
      middleName.hashCode ^
      nickName.hashCode ^
      lastName.hashCode;
}

class InstantMessenger {
  final int type;
  final String customLabel;
  final String im;
  final String protocol;

  InstantMessenger(this.type, this.customLabel, this.im, this.protocol);

  factory InstantMessenger.fromMap(Map<dynamic, dynamic> map) =>
      InstantMessenger(
          map['type'], map['customLabel'], map['im'], map['protocol']);

  @override
  String toString() {
    return 'InstantMessenger{type: $type, customLabel: $customLabel, im: $im, protocol: $protocol}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstantMessenger &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          customLabel == other.customLabel &&
          im == other.im &&
          protocol == other.protocol;

  @override
  int get hashCode =>
      type.hashCode ^ customLabel.hashCode ^ im.hashCode ^ protocol.hashCode;
}

class Address {
  final int type;
  final String customLabel;
  final String street;
  final String pobox;
  final String neighborhood;
  final String city;
  final String region;
  final String postcode;
  final String country;

  Address(this.type, this.customLabel, this.street, this.pobox,
      this.neighborhood, this.city, this.region, this.postcode, this.country);

  factory Address.fromMap(Map<dynamic, dynamic> map) => Address(
      map['type'],
      map['customLabel'],
      map['street'],
      map['pobox'],
      map['neighborhood'],
      map['city'],
      map['region'],
      map['postcode'],
      map['country']);

  @override
  String toString() {
    return 'Address{type: $type, customLabel: $customLabel, street: $street, pobox: $pobox, neighborhood: $neighborhood, city: $city, region: $region, postcode: $postcode, country: $country}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Address &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          customLabel == other.customLabel &&
          street == other.street &&
          pobox == other.pobox &&
          neighborhood == other.neighborhood &&
          city == other.city &&
          region == other.region &&
          postcode == other.postcode &&
          country == other.country;

  @override
  int get hashCode =>
      type.hashCode ^
      customLabel.hashCode ^
      street.hashCode ^
      pobox.hashCode ^
      neighborhood.hashCode ^
      city.hashCode ^
      region.hashCode ^
      postcode.hashCode ^
      country.hashCode;
}

class FullContact {
  final StructuredName name;
  final List<InstantMessenger> instantMessengers;
  final List<EmailAddress> emails;
  final List<PhoneNumber> phones;
  final List<Address> addresses;

  FullContact(this.instantMessengers, this.emails, this.phones, this.addresses,
      this.name);

  factory FullContact.fromMap(Map<dynamic, dynamic> map) {
    print(map);
    return FullContact(
        (map['instantMessengers'] as List<dynamic>)
            .map((element) => InstantMessenger.fromMap(element))
            .cast<InstantMessenger>()
            .toList(growable: false),
        (map['emails'] as List<dynamic>)
            .map((element) => EmailAddress.fromMap(element))
            .cast<EmailAddress>()
            .toList(growable: false),
        (map['phones'] as List<dynamic>)
            .map((element) => PhoneNumber.fromMap(element))
            .cast<PhoneNumber>()
            .toList(growable: false),
        (map['addresses'] as List<dynamic>)
            .map((element) => Address.fromMap(element))
            .cast<Address>()
            .toList(growable: false),
        StructuredName.fromMap(map["name"]));
  }

  @override
  String toString() {
    return 'FullContact{instantMessengers: $instantMessengers, emails: $emails, phones: $phones, addresses: $addresses}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FullContact &&
          runtimeType == other.runtimeType &&
          instantMessengers == other.instantMessengers &&
          emails == other.emails &&
          phones == other.phones &&
          addresses == other.addresses;

  @override
  int get hashCode =>
      instantMessengers.hashCode ^
      emails.hashCode ^
      phones.hashCode ^
      addresses.hashCode;
}
