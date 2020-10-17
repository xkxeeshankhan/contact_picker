abstract class Labeled {
  const Labeled(this.label);

  ///Label of the labeled item
  final String label;

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