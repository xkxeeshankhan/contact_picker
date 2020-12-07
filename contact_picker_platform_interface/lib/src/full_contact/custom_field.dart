import '../labeled.dart';

class CustomField extends Labeled {
  final String name;

  const CustomField(this.name, String label) : super(label);

  factory CustomField.fromMap(Map<dynamic, dynamic> map) =>
      CustomField(map['name'], map['label']);

  @override
  String toString() {
    return 'CustomField{name: $name, label: $label}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is CustomField &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => super.hashCode ^ name.hashCode;
}
