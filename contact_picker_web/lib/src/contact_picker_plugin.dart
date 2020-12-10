import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

import 'package:contact_picker_platform_interface/contact_picker_platform_interface.dart';
import 'package:contact_picker_web/contact_picker_web.dart';
import 'package:contact_picker_web/src/js/promise.js.dart';
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
  Future<List<String>> getAvailableProperties() async {
    assert(available, () => PickerNotAvailableException());
    return (await promiseToFuture<List<dynamic>>(getProperties()))
        .cast<String>();
  }

  @override
  Future<PhoneContact> pickPhoneContact({bool askForPermission = true}) async =>
      (_firstContact(pickPhoneContacts(
          askForPermission: askForPermission, multiple: false)));

  @override
  Future<List<PhoneContact>> pickPhoneContacts(
      {bool askForPermission = true, bool multiple = true}) async {
    var jsContacts = _pickJsContact(
        [PickerProperties.NAME_PROP, PickerProperties.TEL_PROP], multiple);

    return (await jsContacts).map((jsContact) {
      return PhoneContact(_firstOrNull(jsContact.name),
          PhoneNumber(_firstOrNull(jsContact.tel), null));
    }).toList(growable: false);
  }

  Future<T> _firstContact<T>(Future<List<T>> future) async {
    var result = _firstOrNull(await future);
    if (result == null) {
      throw UserCancelledPickingException();
    }
    return result;
  }

  T? _firstOrNull<T>(List<T> list) => list.isEmpty ? null : list.first;

  @override
  Future<EmailContact> pickEmailContact({bool askForPermission = true}) async =>
      (_firstContact(pickEmailContacts(
          askForPermission: askForPermission, multiple: false)));

  @override
  Future<List<EmailContact>> pickEmailContacts(
      {bool askForPermission = true, bool multiple = true}) async {
    var jsContacts = _pickJsContact(
        [PickerProperties.NAME_PROP, PickerProperties.EMAIL_PROP], multiple);

    return (await jsContacts).map((jsContact) {
      return EmailContact(_firstOrNull(jsContact.name),
          EmailAddress(_firstOrNull(jsContact.email), null));
    }).toList(growable: false);
  }

  @override
  Future<FullContact> pickFullContact({bool askForPermission = true}) async =>
      (_firstContact(pickFullContacts()));

  @override
  Future<List<FullContact>> pickFullContacts(
      {bool askForPermission = true, bool multiple = true}) async {
    var properties = await getAvailableProperties();
    var jsContacts = _pickJsContact(
        properties.map((e) => e.toString()).toList(growable: false), multiple);

    var futures = (await jsContacts).map((jsContact) async {
      var emails = jsContact.email
          .map((email) => EmailAddress(email, null))
          .toList(growable: false);
      var phones = jsContact.tel
          .map((phone) => PhoneNumber(phone, null))
          .toList(growable: false);
      var addresses = jsContact.address.map((address) {
        window.console.log(address);
        return Address(
            country: getProperty(address, 'country'),
            addressLine: getProperty(address, 'addressLine'),
            region: getProperty(address, 'region'),
            city: getProperty(address, 'city'),
            dependentLocality: getProperty(address, 'dependentLocality'),
            postcode: getProperty(address, 'postalCode'),
            sortingCode: getProperty(address, 'sortingCode'),
            organization: getProperty(address, 'organization'),
            recipient: getProperty(address, 'recipient'),
            phone: getProperty(address, 'phone'));
      }).toList(growable: false);
      var name = StructuredName(_firstOrNull(jsContact.name), null, null, null);
      var icon = await _parseIcon(jsContact.icon);
      return FullContact(<InstantMessenger>[], emails, phones, addresses, name,
          icon, null, null, null, <Relation>[], <CustomField>[]);
    }).toList(growable: false);

    return Future.wait(futures);
  }

  Future<Photo?> _parseIcon(List<Blob> icons) async {
    if (icons.isEmpty) return null;
    Completer<Photo> completer = Completer();
    var blob = icons[0];

    var reader = FileReader();
    reader.onError.listen((error) {
      completer.completeError(reader.error!);
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
    assert(available, () => PickerNotAvailableException());

    List<dynamic> rawContacts =
        await promiseAsFuture(openPicker(props, Options(multiple: multiple)));

    return rawContacts.cast<JSContact>();
  }

  @override
  Future<bool> hasPermission() async => true;

  @override
  Future<bool> requestPermission({bool force = false}) async {
    throw UnsupportedError('Permissions are not required for web');
  }
}
