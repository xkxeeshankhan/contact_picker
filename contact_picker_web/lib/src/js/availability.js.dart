@JS()
library contacts;

import 'dart:js';

import 'package:js/js.dart';

//@JS('flutterContactPickerAvailable')
bool get available => context.callMethod(
    'eval', ["('contacts' in navigator && 'ContactsManager' in window)"]);
