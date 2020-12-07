class Address {
  final int type;
  final String customLabel;
  final List<String> addressLine;
  @Deprecated('Use addressLine instead')
  String get street => addressLine.first;
  final String pobox;
  final String neighborhood;
  final String city;
  final String region;
  final String postcode;
  final String sortingCode;
  final String recipient;
  final String country;
  final String phone;
  final String organization;
  final String dependentLocality;

  Address({this.type, this.customLabel, this.addressLine, this.pobox,
      this.neighborhood, this.city, this.region, this.postcode, this.country, this.sortingCode, this.recipient, this.phone, this.organization, this.dependentLocality});

  factory Address.fromMap(Map<dynamic, dynamic> map) => Address(
      type: map['type'],
      customLabel: map['customLabel'],
      addressLine: map['addressLine'],
      pobox: map['pobox'],
      neighborhood: map['neighborhood'],
      city: map['city'],
      region: map['region'],
      postcode: map['postcode'],
      country: map['country']);

  @override
  String toString() {
    return 'Address{type: $type, customLabel: $customLabel, street: $street, pobox: $pobox, neighborhood: $neighborhood, city: $city, region: $region, postcode: $postcode, country: $country}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Address &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          customLabel == other.customLabel &&
          street == other.street &&
          pobox == other.pobox &&
          neighborhood == other.neighborhood &&
          city == other.city &&
          region == other.region &&
          postcode == other.postcode &&
          country == other.country;

  @override
  int get hashCode =>
      type.hashCode ^
      customLabel.hashCode ^
      street.hashCode ^
      pobox.hashCode ^
      neighborhood.hashCode ^
      city.hashCode ^
      region.hashCode ^
      postcode.hashCode ^
      country.hashCode;
}
