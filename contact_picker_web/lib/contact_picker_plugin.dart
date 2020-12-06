import 'dart:html';

import 'package:contact_picker_platform_interface/contact_picker_platform_interface.dart';
import 'package:contact_picker_platform_interface/email_contact.dart';
import 'package:contact_picker_platform_interface/full_contact/full_contact.dart';
import 'package:contact_picker_platform_interface/phone_contact.dart';
import 'package:contact_picker_platform_interface/phone_number.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'js_functions/check_availability.dart';
import 'js_functions/open_picker.dart';

class ContactPickerPlugin extends ContactPickerPlatform {

  static void registerWith(Registrar registrar) {
    ContactPickerPlatform.instance = ContactPickerPlugin();
  }

  ///Picks a Phone contact
  ///Automatically checks for permission if [askForPermission] is true
  ///Requires [hasPermission] on Android 11+
  Future<PhoneContact> pickPhoneContact(
      {bool askForPermission = true}) async {
    if(available) {
      var contacts = openPicker([PickerProps.NAME_PROP, PickerProps.TEL_PROP], Options(multiple: false));
      return PhoneContact(contacts.names?.elementAt(0) ?? "", PhoneNumber(contacts.tels?.elementAt(0) ?? "", "Number"));
    } else {
      throw PickerNotAvailableException();
    }
  }

  ///Picks an Email contact
  ///Automatically checks for permission if [askForPermission] is true
  ///Requires [hasPermission] on Android 11+
  Future<EmailContact> pickEmailContact(
      {bool askForPermission = true}) async => ContactPickerPlatform.instance.pickEmailContact(askForPermission: askForPermission);

  ///Picks a full contact
  ///Automatically checks for permission if [askForPermission] is true
  ///Always requires [hasPermission] to return true
  /// Currently Android only because iOS does not provide api to select whole contact
  @Deprecated(
      'Name is misleading as this returns a FullContact and not a contact. Use pickFullContact instead.')
  Future<FullContact> pickContact(
      {bool askForPermission = true}) async => ContactPickerPlatform.instance.pickContact(askForPermission: askForPermission);

  ///Picks a full contact
  ///Automatically checks for permission if [askForPermission] is true
  ///Always requires [hasPermission] to return true
  /// Currently Android only because iOS does not provide api to select whole contact
  Future<FullContact> pickFullContact(
      {bool askForPermission = true}) async => ContactPickerPlatform.instance.pickFullContact(askForPermission: askForPermission);

  /// Checks if the contact permission is already granted
  Future<bool> hasPermission() async => ContactPickerPlatform.instance.hasPermission();

  /// Checks if the permission is already granted and requests if it is not or [force] is true
  Future<bool> requestPermission({bool force = false}) async => ContactPickerPlatform.instance.requestPermission(force: force);
}