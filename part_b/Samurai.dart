import 'dart:math';

// A1 — the four weapons
enum weapons { katana, yumi, naginata, wakizashi }

// A1 — the two kinds of samurai
enum samuraiType { military, ronin }

// A1 — limits given in the brief
const double minHitPower = 10.0;
const double maxHitPower = 20.0;
const double minLife = 35.0; // lowest starting life
const double maxLife = 100.0;

// One shared Random for the whole program.
// main() can replace it with Random(seed) to replay exactly the same battle.
Random dice = Random();

abstract class Samurai {
  String? _name;
  weapons? _weaponType;
  bool? _doubleWeapon;
  bool? _hasHorse;
  bool? _hasArmor;
  double? _hitPower;
  double? _life;

  // A2 — Named Constructor: a samurai with a name and random values
  // inside the allowed limits
  Samurai.recruit(String name) {
    _name = name;
    _weaponType = weapons.values[dice.nextInt(weapons.values.length)];
    _doubleWeapon = dice.nextBool();
    _hasHorse = dice.nextBool();
    _hasArmor = dice.nextBool();

    // min + random * (max - min) gives a value from min up to max
    _hitPower = minHitPower + dice.nextDouble() * (maxHitPower - minHitPower);
    _life = minLife + dice.nextDouble() * (maxLife - minLife);
  }

  //Setters-Getters
  void setName(String name) {
    _name = name;
  }

  void setWeaponType(weapons weaponType) {
    _weaponType = weaponType;
  }

  void setDoubleWeapon(bool doubleWeapon) {
    _doubleWeapon = doubleWeapon;
  }

  void setHasHorse(bool hasHorse) {
    _hasHorse = hasHorse;
  }

  void setHasArmor(bool hasArmor) {
    _hasArmor = hasArmor;
  }

  // hitPower always stays between 10.0 and 20.0
  void setHitPower(double hitPower) {
    _hitPower = hitPower.clamp(minHitPower, maxHitPower).toDouble();
  }

  // life can never be negative or above 100.0
  void setLife(double life) {
    _life = life.clamp(0.0, maxLife).toDouble();
  }

  String? getName() => _name;

  String? getWeaponType() => _weaponType?.name;

  bool? getDoubleWeapon() => _doubleWeapon;

  bool? getHasArmor() => _hasArmor;

  bool? getHasHorse() => _hasHorse;

  double? getHitPower() => _hitPower;

  double? getLife() => _life;

  bool isAlive() => (_life ?? 0) > 0;

  // Methods

  // How many points the armor and the horse absorb
  double getProtection() {
    if (_hasArmor == true && _hasHorse == true) {
      return 15.0;
    } else if (_hasArmor == true) {
      return 10.0;
    } else if (_hasHorse == true) {
      return 5.0;
    }
    return 0.0;
  }

  // A2 — returns the damage left after armor/horse protection, never negative
  double defend(double incomingDamage) {
    double damage = incomingDamage - getProtection();

    if (damage < 0) {
      damage = 0;
    }
    return damage;
  }

  // A2 — weapon base power, ×1.8 when holding two of the same weapon
  double getWeaponPower() {
    double weaponPower = 0;

    if (_weaponType == weapons.katana) {
      weaponPower = 10.0;
    } else if (_weaponType == weapons.yumi) {
      weaponPower = 15.0;
    } else if (_weaponType == weapons.naginata) {
      weaponPower = 20.0;
    } else if (_weaponType == weapons.wakizashi) {
      weaponPower = 5.0;
    }

    if (_doubleWeapon == true) {
      weaponPower *= 1.8;
    }

    return weaponPower;
  }

  // A2 — a dead samurai stays at life 0 and cannot act again
  // (Tool.attack() checks isAlive() before every attack)
  void checkState() {
    if ((_life ?? 0) <= 0.0) {
      _life = 0;
      print('\n$_name has died!');
    } else {
      print('\n$_name\'s current life is ${_life!.toStringAsFixed(2)}');
    }
  }

  // A2 — prints all the attributes of the samurai
  void printState() {
    String weapon = '${getWeaponType()}${_doubleWeapon == true ? ' ×2' : ''}';
    String horse = _hasHorse == true ? 'YES' : 'NO';
    String armor = _hasArmor == true ? 'YES' : 'NO';

    print('$_name');
    print('Type: ${getType().name}');
    print('Weapon: $weapon');
    print('Horse: $horse | Armor: $armor');
    print('Hit Power: ${_hitPower?.toStringAsFixed(2)}');
    print('Life: ${_life?.toStringAsFixed(2)}');
  }

  // Abstract methods
  samuraiType getType();

  double attack();

  // B1 — multiplies the damage of a critical hit (each kind has its own range)
  double criticalHit(double incomingDamage);

  // B1 — true when the samurai manages to avoid an attack completely
  bool agility();
}
