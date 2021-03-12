import 'contact.dart';
import 'phone_number.dart';

///Phone Contact
class PhoneContact extends Contact {
  const PhoneContact(String? fullName, this.phoneNumber) : super(fullName);

  factory PhoneContact.fromMap(Map<dynamic, dynamic> map) =>
      PhoneContact(map['fullName'], PhoneNumber.fromMap(map['phoneNumber']));

  /// Phone number of the contact
  /// This can be null on Flutter Web in case the user unselects the phone number in the contact picker interface
  final PhoneNumber? phoneNumber;

  @override
  String toString() {
    return 'PhoneContact{phoneNumber: $phoneNumber}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneContact &&
          runtimeType == other.runtimeType &&
          phoneNumber == other.phoneNumber;

  @override
  int get hashCode => phoneNumber.hashCode;
}
