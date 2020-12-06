@JS()
library contacts;

import 'package:js/js.dart';

@JS("('contacts' in navigator && 'ContactsManager' in window)")
external bool get available;

class PickerNotAvailableException implements Exception {}