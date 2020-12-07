@JS('navigator.contacts')
library picker;

import 'dart:html';

import 'package:js/js.dart';

external List<String> getProperties();

@JS('select')
external List<dynamic> openPicker(List<String> props, Options options);

@JS()
@anonymous
class Options {
  external bool get multiple;

  external factory Options({bool multiple});
}

List<T> castList<T>(dynamic rawList) {
  var list = rawList as List<dynamic>;
  if (list == null) {
    return null;
  }
  if (list.isEmpty) {
    return <T>[];
  } else {
    return list.cast<T>();
  }
}

List<T> _mapList<T>(dynamic rawList, T f(dynamic e)) {
  var list = rawList as List<dynamic>;
  if (list == null) {
    return null;
  }
  if (list.isEmpty) {
    return <T>[];
  } else {
    return list.map(f).toList(growable: false);
  }
}

class JSContact {
  final List<dynamic> names;

  final List<dynamic> emails;

  final List<dynamic> tels;

  final List<Blob> icons;

  final List<JsAddress> addresses;

  JSContact(this.names, this.emails, this.tels, this.icons, this.addresses);

  factory JSContact.fromDynamic(dynamic obj) => JSContact(
      castList<String>(obj.name),
      castList<String>(obj.email),
      castList<String>(obj.tel),
      castList<Blob>(obj.icon),
      _mapList(obj.address, (e) => JsAddress.fromDynamic(e)));
}

class JsAddress {
  final String country;
  final List<String> addressLine;
  final String region;
  final String city;
  final String dependentLocality;
  final String postalCode;
  final String sortingCode;
  final String organization;
  final String recipient;
  final String phone;

  JsAddress(
      this.country,
      this.addressLine,
      this.region,
      this.city,
      this.dependentLocality,
      this.postalCode,
      this.sortingCode,
      this.organization,
      this.recipient,
      this.phone);

  factory JsAddress.fromDynamic(dynamic obj) => JsAddress(
      obj.country,
      castList<String>(obj.addressLine),
      obj.region,
      obj.city,
      obj.dependentLocality,
      obj.postalCode,
      obj.sortingCode,
      obj.organization,
      obj.recipient,
      obj.phone);
}

class PickerProperties {
  static const String NAME_PROP = 'name';
  static const String TEL_PROP = 'tel';
  static const String EMAIL_PROP = 'email';

  /// [ICON_PROP] only available on Chrome 84 and later
  static const String ICON_PROP = 'icon';

  /// [ADDR_PROP] only available on Chrome 84 and later
  static const String ADDR_PROP = 'address';
}
