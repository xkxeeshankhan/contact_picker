class Relation {
  final String? name;
  final RelationType type;

  const Relation(this.name, this.type);

  factory Relation.fromMap(Map<dynamic, dynamic> map) =>
      Relation(map['name'], _typeByName(map['type']));

  @override
  String toString() {
    return 'Relation{name: $name, type: $type}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Relation &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          type == other.type;

  @override
  int get hashCode => name.hashCode ^ type.hashCode;
}

enum RelationType {
  custom,
  assistant,
  brother,
  child,
  domestic_partner,
  father,
  friend,
  manager,
  mother,
  parent,
  partner,
  referred_by,
  relative,
  sister,
  spouse
}

RelationType _typeByName(String? name) {
  switch (name) {
    case 'assistant':
      return RelationType.assistant;
    case 'brother':
      return RelationType.brother;
    case 'child':
      return RelationType.child;
    case 'domestic_partner':
      return RelationType.domestic_partner;
    case 'father':
      return RelationType.father;
    case 'friend':
      return RelationType.friend;
    case 'manager':
      return RelationType.manager;
    case 'mother':
      return RelationType.mother;
    case 'parent':
      return RelationType.parent;
    case 'partner':
      return RelationType.partner;
    case 'referred_by':
      return RelationType.referred_by;
    case 'relative':
      return RelationType.relative;
    case 'sister':
      return RelationType.sister;
    case 'spouse':
      return RelationType.spouse;
    default:
      return RelationType.custom;
  }
}
