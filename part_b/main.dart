import 'MilitarySamurai.dart';
import 'Message.dart';
import 'Ronin.dart';
import 'Samurai.dart';
import 'Tool.dart';
import 'dart:io';
import 'dart:math';

// The five warriors of the story, set up as in Part A
(List<Samurai>, List<Samurai>) createStoryTeams() {
  MilitarySamurai akechi = MilitarySamurai.recruit('Akechi Mitsuhide');
  akechi.setWeaponType(weapons.katana);
  akechi.setDoubleWeapon(true);
  akechi.setHasArmor(true);
  akechi.setHasHorse(false);
  akechi.setHitPower(18.0);
  akechi.setLife(100.0);

  MilitarySamurai date = MilitarySamurai.recruit('Date Masamune');
  date.setWeaponType(weapons.yumi);
  date.setDoubleWeapon(false);
  date.setHasArmor(false);
  date.setHasHorse(true);
  date.setHitPower(14.0);
  date.setLife(40.0);

  MilitarySamurai hattori = MilitarySamurai.recruit('Hattori Hanzō');
  hattori.setWeaponType(weapons.naginata);
  hattori.setDoubleWeapon(false);
  hattori.setHasArmor(true);
  hattori.setHasHorse(false);
  hattori.setHitPower(19.0);
  hattori.setLife(100.0);

  Ronin oda = Ronin.recruit('Oda Nobunaga');
  oda.setWeaponType(weapons.wakizashi);
  oda.setDoubleWeapon(true);
  oda.setHasArmor(true);
  oda.setHasHorse(true);
  oda.setHitPower(17.0);
  oda.setLife(100.0);

  Ronin takeda = Ronin.recruit('Takeda Nobunaga');
  takeda.setWeaponType(weapons.katana);
  takeda.setDoubleWeapon(false);
  takeda.setHasArmor(true);
  takeda.setHasHorse(false);
  takeda.setHitPower(20.0);
  takeda.setLife(100.0);

  return ([akechi, date, hattori], [oda, takeda]);
}

void narration(List<Samurai> militaryTeam, List<Samurai> roninTeam) {
  print('\nThe military team:');
  for (Samurai samurai in militaryTeam) {
    print('\n${Message.entrance(samurai.getName()!)}');
    samurai.printState();
  }

  print('\nThe Ronin:');
  for (Samurai samurai in roninTeam) {
    print('\n${Message.entrance(samurai.getName()!)}');
    samurai.printState();
  }

  print(
    '\nThe opponents stood there for a moment in time.. in silence.. the shearing wind was all you could hear. Then the first squeak of a katana... everything that followed happened in a flash!',
  );
}

void main(List<String> args) {
  // Optional seed: `dart run main.dart 42` replays exactly the same battle
  if (args.isNotEmpty && int.tryParse(args[0]) != null) {
    dice = Random(int.parse(args[0]));
  }

  var (militaryTeam, roninTeam) = createStoryTeams();

  // B2 — the user adds new samurai to both teams
  Tool.recruitNewSamurai(militaryTeam, roninTeam);

  narration(militaryTeam, roninTeam);

  // B3 — the automated battle.
  // The teams take turns. Each round a random living attacker from one team
  // strikes a random living defender from the other team.
  // The battle goes on while both teams have at least one living member.
  // Safety limit: at most 200 rounds, so the loop always ends.
  const int maxRounds = 200;
  int round = 0;
  bool militaryTurn = dice.nextBool(); // which team strikes first

  print(Message.title());

  while (!Tool.isTeamDefeated(militaryTeam) &&
      !Tool.isTeamDefeated(roninTeam) &&
      round < maxRounds) {
    round++;

    List<Samurai> attackers = militaryTurn ? militaryTeam : roninTeam;
    List<Samurai> defenders = militaryTurn ? roninTeam : militaryTeam;

    Samurai striker = Tool.pickRandom(attackers);
    Samurai defender = Tool.pickRandom(defenders);

    Tool.attack(striker, defender, round);
    defender.printState();

    militaryTurn = !militaryTurn;

    // B4 — the user presses ENTER to continue the story
    stdout.write(Message.pressEnter());
    stdin.readLineSync();
  }

  // The end
  print('\n=== THE END OF THE BATTLE ===');
  if (Tool.isTeamDefeated(roninTeam)) {
    print(Message.victory('Military Samurai'));
    print('Winning team: Military Samurai');
  } else if (Tool.isTeamDefeated(militaryTeam)) {
    print(Message.victory('Ronin'));
    print('Winning team: Ronin');
  } else {
    print('After $maxRounds rounds both teams retreat. No winner today.');
  }
  print('Total rounds: $round');

  print('\nSurvivors:');
  for (Samurai samurai in Tool.alive(militaryTeam + roninTeam)) {
    print(
      '- ${samurai.getName()} (life ${samurai.getLife()!.toStringAsFixed(2)})',
    );
  }
}
