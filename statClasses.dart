class Stat {
  var _name;
  get name => _name;
  set name (var potentName) {
    name = potentName.toString();
  }
  Stat(String name) {
    this._name = name;
  }
  String toJson() {
    return '''{
  "name" : "$_name",
  "type" : "Stat"
}''';
  }
}

class Attribute extends Stat {
  int base;
  bool halfRounded;
  get mod {
    if (halfRounded){
      return ((base-10)/2.0).floor();
    } else {
      return base;
    }
  }
  Attribute(String name, int base, bool halfRounded) : super(name) {
    this.base = base;
    this.halfRounded = halfRounded;
  }
  Attribute.fromAttr(Attribute attribute) : super(attribute.name) {
    this.base = attribute.base;
    this.halfRounded = attribute.halfRounded;
  }
  String toJson() {
    return '''{
  "name" : "$_name",
  "type" : "Attribute",
  "base" : $base,
  "halfRounded" : $halfRounded
}''';
  }
}

class Skill extends Stat {
  String relatedAttribute;
  int mod;
  Skill(String name, String attributeName, int mod) : super (name) {
    this.relatedAttribute = attributeName;
    this.mod = mod;
  }
  Skill.fromSkill(Skill copy) : super (copy.name) {
    this.relatedAttribute = copy.relatedAttribute;
    this.mod = mod;
  }
  String toJson() {
    return '''{
  "name" : "$_name",
  "type" : "Skill",
  "relatedAttribute" : $relatedAttribute,
  "mod" : $mod
}''';
  }
}
class Pool extends Stat {
  int max;
  int _pointer;
  get pointer => _pointer;
  Pool(String name, int max) : super(name) {
    this.max = max;
    _pointer = max;
  }
  Pool.fromPool(Pool copy) : super(copy.name){
    this.max = copy.max;
    _pointer = copy.pointer;
  }
  decreasePointer([int amount]) {
    for (amount ??= 1; amount>0; amount--) {
      if (_pointer > 0) {
        _pointer--;
      }
    }
  }
  increasePointer([int amount]) {
    for (amount ??=1; amount > 0; amount--) {
      if (_pointer < max) {
        _pointer++;
      }
    }
  }
  resetPointer() {
    _pointer = max;
  }
  String toJson() {
    return '''{
  "name" : "$_name",
  "type" : "Pool",
  "max" : $max,
  "pointer" : $pointer
}''';
  }
}

class Character {
  String name;
  Map<String, Attribute> attrs;
  Map<String, Skill> skills;
  Map<String, Pool> pools;
  
  Character (String name, Map<String, Stat> importStats) {
    this.name = name;
    importStats.forEach((key, value) {
      if (value is Attribute) {
        attrs[key] = value;
      }
      else if (value is Skill) {
        skills[key] = value;
      }
      else if (value is Pool) {
        pools[key] = value;
      }
      if (!pools.containsKey("HP")){
        pools["HP"] = new Pool("HP", 10);
      }
    });
  }
}