import '../email_address.dart';
import '../phone_number.dart';
import 'address.dart';
import 'custom_field.dart';
import 'instant_messenger.dart';
import 'photo.dart';
import 'relation.dart';
import 'structured_name.dart';

/// This represents a full contact
/// See also [StructuredName]
/// See also [InstantMessenger]
/// See also [EmailAddress]
/// See also [PhoneNumber]
/// See also [Address]
/// See also [Relation]
/// See also [CustomField]
/// See also [Photo]
class FullContact {
  final StructuredName? name;
  final List<InstantMessenger> instantMessengers;
  final List<EmailAddress> emails;
  final List<PhoneNumber> phones;
  final List<Address> addresses;

  /// Can be null
  final String? note;

  /// Can be null
  final String? company;

  /// Can be null
  final String? sip;
  final List<Relation> relations;

  /// This fields are for the Google contacts app only
  final List<CustomField> customFields;

  /// The users profile picture (can be null if none is set)
  final Photo? photo;

  FullContact(
      this.instantMessengers,
      this.emails,
      this.phones,
      this.addresses,
      this.name,
      this.photo,
      this.note,
      this.company,
      this.sip,
      this.relations,
      this.customFields);

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
      map['photo'] == null ? null : Photo.fromMap(map),
      map['note'],
      map['company'],
      map['sip'],
      (map['relations'] as List<dynamic>)
          .map((element) => Relation.fromMap(element))
          .cast<Relation>()
          .toList(growable: false),
      (map['custom_fields'] as List<dynamic>)
          .map((element) => CustomField.fromMap(element))
          .cast<CustomField>()
          .toList(growable: false),
    );
  }

  @override
  String toString() {
    return 'FullContact{name: $name, instantMessengers: $instantMessengers, emails: $emails, phones: $phones, addresses: $addresses, note: $note, company: $company, sip: $sip, relations: $relations, customFields: $customFields, photo: $photo}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FullContact &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          instantMessengers == other.instantMessengers &&
          emails == other.emails &&
          phones == other.phones &&
          addresses == other.addresses &&
          note == other.note &&
          company == other.company &&
          sip == other.sip &&
          relations == other.relations &&
          customFields == other.customFields &&
          photo == other.photo;

  @override
  int get hashCode =>
      name.hashCode ^
      instantMessengers.hashCode ^
      emails.hashCode ^
      phones.hashCode ^
      addresses.hashCode ^
      note.hashCode ^
      company.hashCode ^
      sip.hashCode ^
      relations.hashCode ^
      customFields.hashCode ^
      photo.hashCode;
}
