import 'MilitarySamurai.dart';
import 'Ronin.dart';
import 'Samurai.dart';
import 'Tool.dart';
import 'dart:math';

void step(String title) {
  print('\n========================================');
  print(title);
  print('========================================');
}

void main(List<String> args) {
  // Optional seed: `dart run main.dart 42` replays exactly the same battle
  if (args.isNotEmpty && int.tryParse(args[0]) != null) {
    dice = Random(int.parse(args[0]));
  }

  // A3 — the five warriors, set up according to the story.
  // Values not given in the story are chosen inside the limits
  // and match the description.

  // Famous military warrior: on foot, intact armor, two katana, unhurt
  MilitarySamurai akechi = MilitarySamurai.recruit('Akechi Mitsuhide');
  akechi.setWeaponType(weapons.katana);
  akechi.setDoubleWeapon(true);
  akechi.setHasArmor(true);
  akechi.setHasHorse(false);
  akechi.setHitPower(18.0);
  akechi.setLife(100.0);

  // Seriously injured, on his horse, useless armor, only the yumi left
  MilitarySamurai date = MilitarySamurai.recruit('Date Masamune');
  date.setWeaponType(weapons.yumi);
  date.setDoubleWeapon(false);
  date.setHasArmor(false);
  date.setHasHorse(true);
  date.setHitPower(14.0);
  date.setLife(40.0);

  // Tough and unhurt, excellent with the naginata, armor but no horse
  MilitarySamurai hattori = MilitarySamurai.recruit('Hattori Hanzō');
  hattori.setWeaponType(weapons.naginata);
  hattori.setDoubleWeapon(false);
  hattori.setHasArmor(true);
  hattori.setHasHorse(false);
  hattori.setHitPower(19.0);
  hattori.setLife(100.0);

  // The younger ronin brother: on horseback, unhurt, two wakizashi
  // sticking out of his armor
  Ronin oda = Ronin.recruit('Oda Nobunaga');
  oda.setWeaponType(weapons.wakizashi);
  oda.setDoubleWeapon(true);
  oda.setHasArmor(true);
  oda.setHasHorse(true);
  oda.setHitPower(17.0);
  oda.setLife(100.0);

  // The abler brother: dismounts, one katana, heavy armor like new, unhurt
  Ronin takeda = Ronin.recruit('Takeda Nobunaga');
  takeda.setWeaponType(weapons.katana);
  takeda.setDoubleWeapon(false);
  takeda.setHasArmor(true);
  takeda.setHasHorse(false);
  takeda.setHitPower(20.0);
  takeda.setLife(100.0);

  // The two teams
  List<Samurai> militaryTeam = [akechi, date, hattori];
  List<Samurai> roninTeam = [oda, takeda];

  // Narration / Samurais' presentation
  print('\n"${akechi.getName()} appears proudly in the centre of the battlefield..."');
  akechi.printState();

  print('\n"${date.getName()} follows a few steps behind, badly wounded, on his horse..."');
  date.printState();

  print('\n"The last one of the team walks in... ${hattori.getName()}."');
  hattori.printState();

  print('\n"${oda.getName()} rides in to stand against them..."');
  oda.printState();

  print(
    '\n"Finally... ${takeda.getName()} gets down from his horse, beside his brother, and slowly draws his katana."',
  );
  takeda.printState();

  print(
    '\nThe opponents stood there for a moment in time.. in silence.. the shearing wind was all you could hear. Then the first squeak of a katana... everything that followed happened in a flash!',
  );

  // A4 — the fixed order of the battle

  // Step 1 — Takeda attacks Akechi and Date almost at the same time,
  // with full power. Neither of them has time to react.
  step('Step 1 — Takeda charges at both opponents.');
  Tool.attack(takeda, akechi);
  Tool.attack(takeda, date);
  Tool.report([takeda, akechi, date]);

  // Step 2 — Oda attacks Hattori with full power
  step('Step 2 — Oda attacks Hattori.');
  Tool.attack(oda, hattori);
  Tool.report([oda, hattori]);

  // Step 3 — Hattori strikes back at Oda with full power
  step('Step 3 — Hattori strikes back at Oda.');
  Tool.attack(hattori, oda);
  Tool.report([hattori, oda]);

  // Step 4 — the injured Date shoots a weak arrow at Takeda
  step('Step 4 — The injured Date shoots a weak arrow at Takeda.');
  Tool.attack(date, takeda, weak: true);
  Tool.report([date, takeda]);

  // Step 5 — Akechi attacks Takeda with full power
  step('Step 5 — Akechi attacks Takeda.');
  Tool.attack(akechi, takeda);
  Tool.report([akechi, takeda]);

  // Step 6 — to protect his brother, Takeda attacks Hattori
  // and lands two hits in a row with full power
  step('Step 6 — Takeda protects his brother and strikes Hattori twice.');
  Tool.attack(takeda, hattori);
  Tool.attack(takeda, hattori);
  Tool.report([takeda, hattori]);

  // Step 7 — the wounded Oda attacks Akechi weakly
  step('Step 7 — The wounded Oda attacks Akechi weakly.');
  Tool.attack(oda, akechi, weak: true);
  Tool.report([oda, akechi]);

  // Step 8 onwards — my own events.
  // The battle breaks into open duels. In every round, each living warrior,
  // in the order they entered the battlefield, strikes the living opponent
  // with the lowest life (the one who looks closest to falling).
  // A warrior whose life is below 30.0 is wounded and can only make
  // weak attacks. The battle ends when one team has no living warrior.
  // Safety limit: at most 50 rounds, so the loop always ends.
  const int maxRounds = 50;
  List<Samurai> battleOrder = [akechi, date, hattori, oda, takeda];
  int round = 0;

  while (!Tool.isTeamDefeated(militaryTeam) &&
      !Tool.isTeamDefeated(roninTeam) &&
      round < maxRounds) {
    round++;
    step('Step ${7 + round} — Open battle, round $round.');

    for (Samurai striker in battleOrder) {
      if (!striker.isAlive()) {
        continue;
      }

      List<Samurai> enemies = militaryTeam.contains(striker)
          ? roninTeam
          : militaryTeam;
      List<Samurai> targets = Tool.alive(enemies);
      if (targets.isEmpty) {
        break;
      }

      // the opponent with the lowest life comes first
      targets.sort((a, b) => a.getLife()!.compareTo(b.getLife()!));
      Samurai target = targets.first;

      bool weak = striker.getLife()! < Tool.woundedLife;
      Tool.attack(striker, target, weak: weak);
      Tool.report([striker, target]);
    }
  }

  // The end of the battle
  step('The end of the battle');
  if (Tool.isTeamDefeated(roninTeam)) {
    print('The Ronin brothers have fallen. Victory belongs to the military team!');
  } else if (Tool.isTeamDefeated(militaryTeam)) {
    print('The military team has fallen. Victory belongs to the Ronin brothers!');
  } else {
    print('After $maxRounds rounds both teams are exhausted and retreat. No winner today.');
  }

  print('\nSurvivors:');
  for (Samurai samurai in Tool.alive(militaryTeam + roninTeam)) {
    print('- ${samurai.getName()} (life ${samurai.getLife()!.toStringAsFixed(2)})');
  }
}
