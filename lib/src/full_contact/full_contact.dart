import '../email_address.dart';
import '../phone_number.dart';
import 'address.dart';
import 'instant_messenger.dart';
import 'photo.dart';
import 'structured_name.dart';

class FullContact {
  final StructuredName name;
  final List<InstantMessenger> instantMessengers;
  final List<EmailAddress> emails;
  final List<PhoneNumber> phones;
  final List<Address> addresses;

  /// The users profile picture (can be null if none is set)
  final Photo photo;

  FullContact(this.instantMessengers, this.emails, this.phones, this.addresses,
      this.name, this.photo);

  factory FullContact.fromMap(Map<dynamic, dynamic> map) {
    return FullContact(
        (map['instantMessengers'] as List<dynamic>)
            .map((element) => InstantMessenger.fromMap(element))
            .cast<InstantMessenger>()
            .toList(growable: false),
        (map['emails'] as List<dynamic>)
            .map((element) => EmailAddress.fromMap(element))
            .cast<EmailAddress>()
            .toList(growable: false),
        (map['phones'] as List<dynamic>)
            .map((element) => PhoneNumber.fromMap(element))
            .cast<PhoneNumber>()
            .toList(growable: false),
        (map['addresses'] as List<dynamic>)
            .map((element) => Address.fromMap(element))
            .cast<Address>()
            .toList(growable: false),
        StructuredName.fromMap(map["name"]),
        Photo.fromMap(map));
  }

  @override
  String toString() {
    return 'FullContact{instantMessengers: $instantMessengers, emails: $emails, phones: $phones, addresses: $addresses}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FullContact &&
          runtimeType == other.runtimeType &&
          instantMessengers == other.instantMessengers &&
          emails == other.emails &&
          phones == other.phones &&
          addresses == other.addresses;

  @override
  int get hashCode =>
      instantMessengers.hashCode ^
      emails.hashCode ^
      phones.hashCode ^
      addresses.hashCode;
}
