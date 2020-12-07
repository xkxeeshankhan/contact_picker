import 'dart:async';

import 'package:contact_picker_platform_interface/contact_picker_platform_interface.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

/// Plugin to interact with contact Pickers
/// Supports Android, Web and iOS
class FlutterContactPicker {
  /// Checks whether this browser supports contact pickers or nor
  /// Only works for web
  /// See https://web.dev/contact-picker/ and https://developer.mozilla.org/en-US/docs/Web/API/Contact_Picker_API#Browser_compatibility for more information
  static bool get available => ContactPickerPlatform.instance.available;

  /// Fetches a list of all available properties of a contact
  /// Only works for web
  /// See https://web.dev/contact-picker/ for more information
  static Future<List<String>> getAvailableProperties() =>
      ContactPickerPlatform.instance.getAvailableProperties();

  /// Picks a [PhoneContact].
  /// Requires [hasPermission] on Android 11+ and xiaomi devices
  /// See Also [PhoneContact]
  static Future<PhoneContact> pickPhoneContact(
          {

          /// Whether to automatically request the required permission if needed or not (See [requestPermission] and [hasPermission])
          bool askForPermission = true}) async =>
      ContactPickerPlatform.instance
          .pickPhoneContact(askForPermission: askForPermission);

  /// Sister method to [pickEmailContact] to select multiple contact
  /// This will throw an [UnsupportedError] on all platform except web
  /// See Also [pickEmailContact]
  Future<List<PhoneContact>> pickPhoneContacts(
      {

      /// This doesn't do anything as web does not have permissions for now
      bool askForPermission = true,

      /// Whether to request multiple contacts or not
      bool multiple = true}) {
    return ContactPickerPlatform.instance.pickPhoneContacts(
        askForPermission: askForPermission, multiple: multiple);
  }

  /// Picks an [EmailContact]
  /// Requires [hasPermission] on Android 11+ and xiaomi devices
  /// See Also [EmailContact]
  /// See Also [pickEmailContact]
  static Future<EmailContact> pickEmailContact(
          {

          /// Whether to automatically request the required permission if needed or not (See [requestPermission] and [hasPermission])
          bool askForPermission = true}) async =>
      ContactPickerPlatform.instance
          .pickEmailContact(askForPermission: askForPermission);

  /// Sister method to [pickEmailContact] to select multiple contact
  /// This will throw an [UnsupportedError] on all platform except web
  /// See Also [pickEmailContact]
  Future<List<EmailContact>> pickEmailContacts(
      {

      /// This doesn't do anything as web does not have permissions for now
      bool askForPermission = true,

      /// Whether to request multiple contacts or not
      bool multiple = true}) {
    return ContactPickerPlatform.instance.pickEmailContacts(
        askForPermission: askForPermission, multiple: multiple);
  }

  /// Picks a full contact
  /// This is only supported on Android and on the web platform
  /// See Also [FullContact]
  /// See Also [pickFullContacts]
  static Future<FullContact> pickFullContact(
          {

          /// Whether to automatically request the required permission if needed or not (See [requestPermission] and [hasPermission])
          bool askForPermission = true}) async =>
      ContactPickerPlatform.instance
          .pickFullContact(askForPermission: askForPermission);

  /// Sister method to [pickFullContact] to select multiple contact
  /// This will throw an [UnsupportedError] on all platform except web
  /// See Also [pickFullContact]
  Future<List<FullContact>> pickFullContacts(
      {

      /// This doesn't do anything as web does not have permissions for now
      bool askForPermission = true,

      /// Whether to request multiple contacts or not
      bool multiple = true}) {
    return ContactPickerPlatform.instance.pickFullContacts(
        askForPermission: askForPermission, multiple: multiple);
  }

  /// Checks if the required platform permission to read contacts is granted or not.
  /// On Android 11+ and all xiaomi devices this will check the `Manifest.permission.READ_CONTACTS` permission
  /// On Android 10 and prior, iOS and web this will always return true
  ///
  /// See Also [requestPermission]
  static Future<bool> hasPermission() async =>
      ContactPickerPlatform.instance.hasPermission();

  /// Requests the required platform permission to read contacts and returns whether the permission was granted or not
  ///
  /// On Android 11+ and all xiaomi devices this will request the `Manifest.permission.READ_CONTACTS` permission
  /// On Android 10 and prior and iOS this will always return true
  /// On Web this will throw an [UnsupportedError] as web implementation does not have permissions
  static Future<bool> requestPermission(
          {

          /// Whether permission should be requested anyways even if [hasPermission] returns true or not
          bool force = false}) async =>
      ContactPickerPlatform.instance.requestPermission(force: force);
}
