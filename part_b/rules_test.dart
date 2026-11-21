// Checks for the Part B rules (critical hit, agility, end of the battle).
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

void main() {
  MilitarySamurai military = MilitarySamurai.recruit('Military');
  Ronin ronin = Ronin.recruit('Ronin');

  // Critical hit stays inside its documented range
  bool militaryOk = true;
  bool roninOk = true;
  for (int i = 0; i < 1000; i++) {
    double m = military.criticalHit(10.0);
    double r = ronin.criticalHit(10.0);
    if (m < 15.0 || m > 20.0) militaryOk = false;
    if (r < 15.0 || r > 25.0) roninOk = false;
  }
  check(militaryOk, 'military critical hit is ×1.5–2.0');
  check(roninOk, 'ronin critical hit is ×1.5–2.5');

  // Agility: ronin dodge more often than military samurai
  int militaryDodges = 0;
  int roninDodges = 0;
  for (int i = 0; i < 10000; i++) {
    if (military.agility()) militaryDodges++;
    if (ronin.agility()) roninDodges++;
  }
  check(
    militaryDodges > 300 && militaryDodges < 700,
    'military dodge about 5% ($militaryDodges / 10000)',
  );
  check(
    roninDodges > 1200 && roninDodges < 1800,
    'ronin dodge about 15% ($roninDodges / 10000)',
  );

  // Only living samurai can be picked
  MilitarySamurai a = MilitarySamurai.recruit('A');
  MilitarySamurai b = MilitarySamurai.recruit('B');
  a.setLife(0.0);
  b.setLife(50.0);
  bool onlyAlive = true;
  for (int i = 0; i < 100; i++) {
    if (Tool.pickRandom([a, b]) != b) onlyAlive = false;
  }
  check(onlyAlive, 'only living samurai are picked for the battle');

  // End of a team
  b.setLife(0.0);
  check(Tool.isTeamDefeated([a, b]), 'team with no living members is defeated');

  // Life never goes below 0
  Samurai s = Ronin.recruit('Test');
  s.setLife(-50.0);
  check(s.getLife() == 0.0, 'life cannot go below 0');

  print('\n$passed passed, $failed failed');
}
