@JS('navigator.contacts')
library picker;

import 'package:js/js.dart';

@JS('select')
external Contact openPicker(List<String> props, Options options);

@JS()
@anonymous
class Options {
  external bool get multiple;

  external factory Options({bool multiple});
}

@JS()
@anonymous
class Contact {
  external List<String>? get names;
  external List<String>? get emails;
  external List<String>? get tels;
  external List<Object?>? get icons;
  external List<JsAdress>? get address;
}

@JS()
@anonymous
class JsAdress {
  external String get country;
  external List<String> get addressLine;
  external String get region;
  external String get city;
  external String get dependentLocality;
  external String get postalCode;
  external String get sortingCode;
  external String get organization;
  external String get recipient;
  external String get phone;
}


class PickerProps {
  static const String NAME_PROP = 'name';
  static const String TEL_PROP = 'tel';
  static const String EMAIL_PROP = 'email';
  /// [ICON_PROP] only available on Chrome 84 and later
  static const String ICON_PROP = 'icon';
  /// [ADDR_PROP] only available on Chrome 84 and later
  static const String ADDR_PROP = 'addr';
}
