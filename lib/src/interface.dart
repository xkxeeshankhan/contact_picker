import 'dart:async';

import 'package:flutter/services.dart';

import 'email_contact.dart';
import 'full_contact/full_contact.dart';
import 'phone_contact.dart';

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
  @Deprecated(
      'Name is misleading as this returns a FullContact and not a contact. Use pickFullContact instead.')
  static Future<FullContact> pickContact(
          {bool askForPermission = true}) async =>
      pickFullContact(askForPermission: askForPermission);

  ///Picks a full contact
  ///Automatically checks for permission if [askForPermission] is true
  ///Always requires [hasPermission] to return true
  /// Currently Android only because iOS does not provide api to select whole contact
  static Future<FullContact> pickFullContact(
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
