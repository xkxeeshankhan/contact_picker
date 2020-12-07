import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'email_contact.dart';
import 'full_contact/full_contact.dart';
import 'phone_contact.dart';
import 'method_channel_contact_picker.dart';

/// Interface for fluttercontactpicker package. See said package for documentation.
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

  bool get available =>
      throw UnimplementedError('available has not been implemented');

  Future<List<String>> getAvailableProperties() async =>
      throw UnimplementedError(
          'getAvailableProperties() has not been implemented');

  Future<PhoneContact> pickPhoneContact({bool askForPermission = true}) async {
    throw UnimplementedError('pickPhoneContact() has not been implemented');
  }

  Future<List<PhoneContact>> pickPhoneContacts(
      {bool askForPermission = true, bool multiple = true}) {
    throw UnimplementedError('pickPhoneContacts() has not been implemented');
  }

  Future<EmailContact> pickEmailContact({bool askForPermission = true}) async {
    throw UnimplementedError('pickEmailContact() has not been implemented');
  }

  Future<List<EmailContact>> pickEmailContacts(
      {bool askForPermission = true, bool multiple = true}) {
    throw UnimplementedError('pickEmailContacts() has not been implemented');
  }

  Future<FullContact> pickFullContact({bool askForPermission = true}) {
    throw UnimplementedError('pickFullContact() has not been implemented');
  }

  Future<List<FullContact>> pickFullContacts(
      {bool askForPermission = true, bool multiple = true}) {
    throw UnimplementedError('pickFullContacts() has not been implemented');
  }

  Future<bool> hasPermission() async {
    throw UnimplementedError('hasPermission() has not been implemented');
  }

  Future<bool> requestPermission({bool force = false}) async {
    throw UnimplementedError('hasPermission() has not been implemented');
  }
}
