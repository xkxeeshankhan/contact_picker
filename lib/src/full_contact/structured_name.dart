class StructuredName {
  final String? firstName;
  final String? middleName;
  final String? nickName;
  final String? lastName;

  StructuredName(this.firstName, this.middleName, this.nickName, this.lastName);

  factory StructuredName.fromMap(Map<dynamic, dynamic> map) => StructuredName(
      map['firstName'], map['middleName'], map['nickname'], map['lastName']);

  @override
  String toString() {
    return 'StructuredName{firstName: $firstName, middleName: $middleName, nicktName: $nickName, lastName: $lastName}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StructuredName &&
          runtimeType == other.runtimeType &&
          firstName == other.firstName &&
          middleName == other.middleName &&
          nickName == other.nickName &&
          lastName == other.lastName;

  @override
  int get hashCode =>
      firstName.hashCode ^
      middleName.hashCode ^
      nickName.hashCode ^
      lastName.hashCode;
}
