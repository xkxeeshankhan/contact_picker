class InstantMessenger {
  final int type;
  final String? customLabel;
  final String? im;
  final String? protocol;

  InstantMessenger(this.type, this.customLabel, this.im, this.protocol);

  factory InstantMessenger.fromMap(Map<dynamic, dynamic> map) =>
      InstantMessenger(
          map['type'], map['customLabel'], map['im'], map['protocol']);

  @override
  String toString() {
    return 'InstantMessenger{type: $type, customLabel: $customLabel, im: $im, protocol: $protocol}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstantMessenger &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          customLabel == other.customLabel &&
          im == other.im &&
          protocol == other.protocol;

  @override
  int get hashCode =>
      type.hashCode ^ customLabel.hashCode ^ im.hashCode ^ protocol.hashCode;
}
