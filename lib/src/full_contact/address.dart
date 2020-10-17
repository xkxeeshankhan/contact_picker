class Address {
  final int type;
  final String customLabel;
  final String street;
  final String pobox;
  final String neighborhood;
  final String city;
  final String region;
  final String postcode;
  final String country;

  Address(this.type, this.customLabel, this.street, this.pobox,
      this.neighborhood, this.city, this.region, this.postcode, this.country);

  factory Address.fromMap(Map<dynamic, dynamic> map) => Address(
      map['type'],
      map['customLabel'],
      map['street'],
      map['pobox'],
      map['neighborhood'],
      map['city'],
      map['region'],
      map['postcode'],
      map['country']);

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
