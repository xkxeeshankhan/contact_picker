import 'labeled.dart';

class PhoneNumber extends Labeled {
  const PhoneNumber(this.number, String? label) : super(label);

  factory PhoneNumber.fromMap(Map<dynamic, dynamic> map) =>
      PhoneNumber(map['phoneNumber'], map['label']);

  /// The phone number
  final String? number;

  @override
  String toString() {
    return 'PhoneNumber{number: $number}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneNumber &&
          runtimeType == other.runtimeType &&
          number == other.number;

  @override
  int get hashCode => number.hashCode;
}
