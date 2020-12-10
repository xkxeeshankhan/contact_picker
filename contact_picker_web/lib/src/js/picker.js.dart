@JS('navigator.contacts')
library picker;

import 'dart:html';

import 'package:contact_picker_web/src/js/promise.js.dart';
import 'package:js/js.dart';

external List<String> getProperties();

@JS('select')
external Promise<List<JSContact>> openPicker(
    List<String> props, Options options);

@JS()
@anonymous
class Options {
  external bool get multiple;

  external factory Options({required bool multiple});
}

@JS('ContactAddress')
abstract class JSContact {
  external List<String> get name;

  external List<String> get email;

  external List<String> get tel;

  external List<Blob> get icon;

  external List<JSAddress> get address;
}

@JS('ContactAddress')
abstract class JSAddress {
  external String get city;

  external String get country;

  external String get dependentLocality;

  external String get organization;

  external String get phone;

  external String get postalCode;

  external String get recipient;

  external String get region;

  external String get sortingCode;

  external List<String> get addressLine;
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
