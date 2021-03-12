import 'labeled.dart';

class EmailAddress extends Labeled {
  const EmailAddress(this.email, String? label) : super(label);

  factory EmailAddress.fromMap(Map<dynamic, dynamic> map) =>
      EmailAddress(map['email'], map['label']);

  /// The email address
  final String? email;

  @override
  String toString() {
    return 'EmailAddress{email: $email}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailAddress &&
          runtimeType == other.runtimeType &&
          email == other.email;

  @override
  int get hashCode => email.hashCode;
}
