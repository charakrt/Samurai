// Checks for the battle rules.
// Run with: dart run rules_test.dart
import 'MilitarySamurai.dart';
import 'Ronin.dart';
import 'Samurai.dart';
import 'Tool.dart';

int passed = 0;
int failed = 0;

void check(bool condition, String description) {
  if (condition) {
    passed++;
    print('PASS  $description');
  } else {
    failed++;
    print('FAIL  $description');
  }
}

bool near(double a, double b) => (a - b).abs() < 0.0001;

MilitarySamurai makeSamurai(String name) {
  MilitarySamurai samurai = MilitarySamurai.recruit(name);
  samurai.setDoubleWeapon(false);
  samurai.setHasArmor(false);
  samurai.setHasHorse(false);
  samurai.setHitPower(10.0);
  samurai.setLife(100.0);
  return samurai;
}

void main() {
  // Weapons
  MilitarySamurai s = makeSamurai('Test');
  s.setWeaponType(weapons.katana);
  check(near(s.getWeaponPower(), 10.0), 'katana = 10.0');
  s.setWeaponType(weapons.yumi);
  check(near(s.getWeaponPower(), 15.0), 'yumi = 15.0');
  s.setWeaponType(weapons.naginata);
  check(near(s.getWeaponPower(), 20.0), 'naginata = 20.0');
  s.setWeaponType(weapons.wakizashi);
  check(near(s.getWeaponPower(), 5.0), 'wakizashi = 5.0');

  // Double weapon
  s.setWeaponType(weapons.katana);
  s.setDoubleWeapon(true);
  check(near(s.getWeaponPower(), 18.0), 'double katana = 10.0 × 1.8 = 18.0');

  // Defense
  check(near(s.defend(30.0), 30.0), 'no armor, no horse: no reduction');
  s.setHasArmor(true);
  check(near(s.defend(30.0), 20.0), 'armor: -10.0');
  s.setHasArmor(false);
  s.setHasHorse(true);
  check(near(s.defend(30.0), 25.0), 'horse: -5.0');
  s.setHasArmor(true);
  check(near(s.defend(30.0), 15.0), 'armor and horse: -15.0');
  check(near(s.defend(8.0), 0.0), 'damage never becomes negative');

  // Attack formulas
  MilitarySamurai m = makeSamurai('Military');
  m.setHitPower(16.0);
  check(near(m.attack(), 26.0), 'military attack = hitPower + 10.0');
  Ronin r = Ronin.recruit('Ronin');
  r.setHitPower(16.0);
  check(near(r.attack(), 25.0), 'ronin attack = hitPower + 5.0 + hitPower / 4.0');

  // Limits
  s.setLife(-20.0);
  check(near(s.getLife()!, 0.0), 'life cannot go below 0');
  s.setHitPower(35.0);
  check(near(s.getHitPower()!, maxHitPower), 'hitPower cannot go above 20.0');
  for (int i = 0; i < 100; i++) {
    Ronin recruit = Ronin.recruit('Random $i');
    bool okHit = recruit.getHitPower()! >= minHitPower &&
        recruit.getHitPower()! <= maxHitPower;
    bool okLife =
        recruit.getLife()! >= minLife && recruit.getLife()! <= maxLife;
    if (!okHit || !okLife) {
      check(false, 'random values stay inside the limits');
      break;
    }
    if (i == 99) {
      check(true, 'random values stay inside the limits (100 recruits)');
    }
  }

  // Dead warriors
  MilitarySamurai dead = makeSamurai('Dead');
  dead.setLife(0.0);
  MilitarySamurai target = makeSamurai('Target');
  Tool.attack(dead, target);
  check(near(target.getLife()!, 100.0), 'a dead samurai cannot attack');
  Tool.attack(target, dead);
  check(near(dead.getLife()!, 0.0), 'a dead samurai stays at life 0');

  // End of a team
  MilitarySamurai a = makeSamurai('A');
  MilitarySamurai b = makeSamurai('B');
  check(!Tool.isTeamDefeated([a, b]), 'team with living members is not defeated');
  a.setLife(0.0);
  check(!Tool.isTeamDefeated([a, b]), 'team with one living member is not defeated');
  b.setLife(0.0);
  check(Tool.isTeamDefeated([a, b]), 'team with no living members is defeated');

  print('\n$passed passed, $failed failed');
}
