import 'package:flutter/services.dart';
import 'platform.dart';

import 'email_contact.dart';
import 'full_contact/full_contact.dart';
import 'phone_contact.dart';

const MethodChannel _channel = const MethodChannel('me.schlaubi.contactpicker');

class MethodChannelContactPicker extends ContactPickerPlatform {
  @override
  Future<PhoneContact> pickPhoneContact({bool askForPermission = true}) async {
    final contact = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'pickPhoneContact', {'askForPermission': askForPermission});
    if (contact != null) return PhoneContact.fromMap(contact);
    return null;
  }

  @override
  Future<EmailContact> pickEmailContact({bool askForPermission = true}) async {
    final contact = (await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'pickEmailContact', {'askForPermission': askForPermission}));
    if (contact != null) return EmailContact.fromMap(contact);
    return null;
  }

  @override
  Future<FullContact> pickFullContact({bool askForPermission = true}) async {
    final contact = (await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'pickContact', {'askForPermission': askForPermission}));
    if (contact != null) return FullContact.fromMap(contact);
    return null;
  }

  @override
  Future<bool> hasPermission() async =>
      (await _channel.invokeMethod('hasPermission'));

  @override
  Future<bool> requestPermission({bool force = false}) async {
    if (!force) {
      var granted = await hasPermission();
      if (granted) return true;
    }
    return await _channel.invokeMethod('requestPermission');
  }
}
