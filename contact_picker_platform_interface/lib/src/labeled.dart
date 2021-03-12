abstract class Labeled {
  const Labeled(this.label);

  /// Label of the labeled item
  /// Can be null if item can be labeled but has no label
  final String? label;

  @override
  String toString() {
    return 'Labeled{label: $label}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Labeled &&
          runtimeType == other.runtimeType &&
          label == other.label;

  @override
  int get hashCode => label.hashCode;
}
