import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'email_contact.dart';
import 'full_contact/full_contact.dart';
import 'phone_contact.dart';
import 'method_channel_contact_picker.dart';

abstract class ContactPickerPlatform extends PlatformInterface {
  /// Constructs a ContactPickerPlatform
  ContactPickerPlatform() : super(token: _token);

  static final Object _token = Object();

  static ContactPickerPlatform _instance = MethodChannelContactPicker();


  /// The default [ContactPickerPlatform] to use.
  ///
  /// Defaults to [MethodChannelContactPicker]
  static ContactPickerPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [ContactPickerPlatform] when they register themselves.
  static set instance(ContactPickerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  // TODO: Implement all the Methods

  ///Picks a Phone contact
  ///Automatically checks for permission if [askForPermission] is true
  ///Requires [hasPermission] on Android 11+
  Future<PhoneContact> pickPhoneContact({bool askForPermission = true}) async {
    throw UnimplementedError('pickPhoneContact() has not been implemented');
  }

  ///Picks an Email contact
  ///Automatically checks for permission if [askForPermission] is true
  ///Requires [hasPermission] on Android 11+
  Future<EmailContact> pickEmailContact({bool askForPermission = true}) async {
    throw UnimplementedError('pickEmailContact() has not been implemented');
  }

  ///Picks a full contact
  ///Automatically checks for permission if [askForPermission] is true
  ///Always requires [hasPermission] to return true
  /// Currently Android only because iOS does not provide api to select whole contact
  @Deprecated(
      'Name is misleading as this returns a FullContact and not a contact. Use pickFullContact instead.')
  Future<FullContact> pickContact(
      {bool askForPermission = true}) async =>
      pickFullContact(askForPermission: askForPermission);

  ///Picks a full contact
  ///Automatically checks for permission if [askForPermission] is true
  ///Always requires [hasPermission] to return true
  /// Currently Android only because iOS does not provide api to select whole contact
  Future<FullContact> pickFullContact(
      {bool askForPermission = true}) {
    throw UnimplementedError('pickFullContact() has not been implemented');
  }

  /// Checks if the contact permission is already granted
  Future<bool> hasPermission() async {
    throw UnimplementedError('hasPermission() has not been implemented');
  }

  /// Checks if the permission is already granted and requests if it is not or [force] is true
  Future<bool> requestPermission({bool force = false}) async {
    throw UnimplementedError('hasPermission() has not been implemented');
  }

}