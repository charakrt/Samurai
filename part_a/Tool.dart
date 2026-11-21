import 'Samurai.dart';

// Battle logic: who hits whom and how hard.
class Tool {
  // Randomness changes only the intensity of an attack, never the rules
  // of the weapons, the defense or the life:
  // - full attack: (attack + weapon) × random factor 0.90–1.10
  // - weak attack: (attack + weapon) × random factor 0.50–0.80
  static const double fullMin = 0.90;
  static const double fullMax = 1.10;
  static const double weakMin = 0.50;
  static const double weakMax = 0.80;

  // A warrior with less life than this can only make weak attacks
  static const double woundedLife = 30.0;

  static void attack(Samurai striker, Samurai defender, {bool weak = false}) {
    print('\n${striker.getName()} → ${defender.getName()}');

    // A dead samurai cannot act, and a dead samurai cannot be attacked again
    if (!striker.isAlive()) {
      print('${striker.getName()} has fallen and cannot fight anymore.');
      return;
    }
    if (!defender.isAlive()) {
      print('${defender.getName()} has already fallen.');
      return;
    }

    double basicAttack = striker.attack();
    double weaponPower = striker.getWeaponPower();

    double factor = weak
        ? weakMin + dice.nextDouble() * (weakMax - weakMin)
        : fullMin + dice.nextDouble() * (fullMax - fullMin);

    double incomingDamage = (basicAttack + weaponPower) * factor;
    double damage = defender.defend(incomingDamage);

    double lifeBefore = defender.getLife()!;
    defender.setLife(lifeBefore - damage);

    String kind = weak ? 'Weak attack' : 'Full attack';
    print(
      '$kind: ${basicAttack.toStringAsFixed(2)} | Weapon: ${weaponPower.toStringAsFixed(2)} | Random factor: ${factor.toStringAsFixed(2)}',
    );
    print(
      '${defender.getName()}\'s defense reduction: ${defender.getProtection().toStringAsFixed(1)}',
    );
    print(
      '${defender.getName()}\'s life: ${lifeBefore.toStringAsFixed(2)} → ${defender.getLife()!.toStringAsFixed(2)}',
    );
  }

  // checkState() and printState() for every warrior involved in a step
  static void report(List<Samurai> involved) {
    print('\nInvolved warriors:');
    for (Samurai samurai in involved) {
      samurai.checkState();
      samurai.printState();
    }
  }

  static List<Samurai> alive(List<Samurai> team) {
    return team.where((samurai) => samurai.isAlive()).toList();
  }

  static bool isTeamDefeated(List<Samurai> team) {
    return alive(team).isEmpty;
  }
}
