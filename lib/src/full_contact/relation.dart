class Relation {
  final String name;
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

RelationType _typeByName(String name) {
  switch (name) {
    case 'assistant':
      return RelationType.assistant;
      break;
    case 'brother':
      return RelationType.brother;
      break;
    case 'child':
      return RelationType.child;
      break;
    case 'domestic_partner':
      return RelationType.domestic_partner;
      break;
    case 'father':
      return RelationType.father;
      break;
    case 'friend':
      return RelationType.friend;
      break;
    case 'manager':
      return RelationType.manager;
      break;
    case 'mother':
      return RelationType.mother;
      break;
    case 'parent':
      return RelationType.parent;
      break;
    case 'partner':
      return RelationType.partner;
      break;
    case 'referred_by':
      return RelationType.referred_by;
      break;
    case 'relative':
      return RelationType.relative;
      break;
    case 'sister':
      return RelationType.sister;
      break;
    case 'spouse':
      return RelationType.spouse;
      break;
    default:
      throw ArgumentError('Invalid name: $name');
  }
}
