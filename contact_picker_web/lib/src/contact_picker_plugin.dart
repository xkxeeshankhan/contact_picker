import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

import 'package:contact_picker_platform_interface/contact_picker_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js_util.dart';

import 'js/availability.js.dart' as availability;
import 'js/picker.js.dart';

/// Web implementation of [ContactPickerPlatform] for documentation see fluttercontactpicker package.
class WebContactPickerPlugin extends ContactPickerPlatform {
  static void registerWith(Registrar registrar) {
    ContactPickerPlatform.instance = WebContactPickerPlugin();
  }

  @override
  bool get available => availability.available;

  @override
  Future<List<String>> getAvailableProperties() async =>
      (await promiseToFuture<List<dynamic>>(getProperties()))?.cast<String>() ??
      <String>[];

  @override
  Future<PhoneContact> pickPhoneContact({bool askForPermission = true}) async =>
      (await pickPhoneContacts(
              askForPermission: askForPermission, multiple: false))
          .first;

  @override
  Future<List<PhoneContact>> pickPhoneContacts(
      {bool askForPermission = true, bool multiple = true}) async {
    var jsContacts = _pickJsContact(
        [PickerProperties.NAME_PROP, PickerProperties.TEL_PROP], multiple);

    return (await jsContacts).map((jsContact) {
      return PhoneContact(
          jsContact.names.first, PhoneNumber(jsContact.tels.first, null));
    }).toList(growable: false);
  }

  @override
  Future<EmailContact> pickEmailContact({bool askForPermission = true}) async =>
      (await pickEmailContacts(
              askForPermission: askForPermission, multiple: false))
          .first;

  @override
  Future<List<EmailContact>> pickEmailContacts(
      {bool askForPermission = true, bool multiple = true}) async {
    var jsContacts = _pickJsContact(
        [PickerProperties.NAME_PROP, PickerProperties.EMAIL_PROP], multiple);

    return (await jsContacts).map((jsContact) {
      return EmailContact(
          jsContact.names.first, EmailAddress(jsContact.emails.first, null));
    }).toList(growable: false);
  }

  @override
  Future<FullContact> pickFullContact({bool askForPermission = true}) async =>
      (await pickFullContacts()).first;

  @override
  Future<List<FullContact>> pickFullContacts(
      {bool askForPermission = true, bool multiple = true}) async {
    var properties = await promiseToFuture<List<dynamic>>(getProperties());
    var jsContacts = _pickJsContact(
        properties.map((e) => e.toString()).toList(growable: false), multiple);

    var futures = (await jsContacts).map((jsContact) async {
      var emails = jsContact.emails
          .map((email) => EmailAddress(email, null))
          .toList(growable: false);
      var phones = jsContact.tels
          .map((phone) => PhoneNumber(phone, null))
          .toList(growable: false);
      var addresses = jsContact.addresses
          .map((address) => Address(
              country: address.country,
              addressLine: address.addressLine,
              region: address.region,
              city: address.city,
              dependentLocality: address.dependentLocality,
              postcode: address.postalCode,
              sortingCode: address.sortingCode,
              organization: address.organization,
              recipient: address.recipient,
              phone: address.phone))
          .toList(growable: false);
      var name = StructuredName(jsContact.names.first, null, null, null);
      var icon = await _parseIcon(jsContact.icons);
      return FullContact(<InstantMessenger>[], emails, phones, addresses, name,
          icon, null, null, null, <Relation>[], <CustomField>[]);
    }).toList(growable: false);

    return Future.wait(futures);
  }

  Future<Photo> _parseIcon(List<Blob> icons) async {
    if (icons.isEmpty) return null;
    Completer<Photo> completer = Completer();
    var blob = icons[0];

    var reader = FileReader();
    reader.onError.listen((error) {
      completer.completeError(reader.error);
    });
    reader.onLoadEnd.listen((event) {
      var buffer = reader.result as Uint8List;
      completer.complete(Photo(buffer));
    });
    reader.readAsArrayBuffer(blob);

    return completer.future;
  }

  Future<List<JSContact>> _pickJsContact(
      List<String> props, bool multiple) async {
    assert(available,
        'Picker is not available in this browser. Consider checking available');

    var rawContacts = await promiseToFuture<List<dynamic>>(
        openPicker(props, Options(multiple: multiple)));

    return rawContacts
        .map((e) => JSContact.fromDynamic(e))
        .toList(growable: false);
  }

  @override
  Future<bool> hasPermission() async => true;

  @override
  Future<bool> requestPermission({bool force = false}) async {
    throw UnsupportedError('Permissions are not required for web');
  }
}
