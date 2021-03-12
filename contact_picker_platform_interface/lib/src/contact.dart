abstract class Contact {
  const Contact(this.fullName);

  /// Full name of the contact
  /// On Flutter Web this can be null if the user unselects name in the contact picker interface
  final String? fullName;

  @override
  String toString() {
    return 'Contact{fullName: $fullName}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Contact &&
          runtimeType == other.runtimeType &&
          fullName == other.fullName;

  @override
  int get hashCode => fullName.hashCode;
}
