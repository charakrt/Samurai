import 'MilitarySamurai.dart';
import 'Message.dart';
import 'Ronin.dart';
import 'Samurai.dart';
import 'dart:io';

// Battle logic and keyboard input. All the story text comes from Message.
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

  // B1 — 5% chance for any attack to become a critical hit
  static const int criticalHitChance = 5;

  // B3 — one attack, in this documented order:
  // 1. weapon and intensity, 2. critical hit, 3. agility (dodge),
  // 4. armor/horse defense, 5. life update, 6. checkState and new stats
  static void attack(Samurai striker, Samurai defender, int round) {
    print('\nRound $round: ${striker.getName()} → ${defender.getName()}');

    // 1. Weapon and intensity
    bool weak = striker.getLife()! < woundedLife;
    double basicAttack = striker.attack();
    double weaponPower = striker.getWeaponPower();
    double factor = weak
        ? weakMin + dice.nextDouble() * (weakMax - weakMin)
        : fullMin + dice.nextDouble() * (fullMax - fullMin);
    double incomingDamage = (basicAttack + weaponPower) * factor;

    print(
      Message.attack(
        striker.getName()!,
        defender.getName()!,
        striker.getWeaponType()!,
      ),
    );

    // 2. Critical hit
    bool critical = dice.nextInt(100) + 1 <= criticalHitChance;
    if (critical) {
      incomingDamage = striker.criticalHit(incomingDamage);
      print(Message.criticalHit(striker.getName()!));
    }

    // 3. Agility: a dodged attack causes no damage
    bool dodged = defender.agility();
    double damage;
    if (dodged) {
      damage = 0;
      print(Message.dodge(defender.getName()!));
    } else {
      // 4. Armor and horse defense
      damage = defender.defend(incomingDamage);
      if (defender.getProtection() > 0) {
        print(
          Message.defend(
            defender.getName()!,
            defender.getHasArmor() == true,
            defender.getHasHorse() == true,
          ),
        );
      }
    }

    // 5. Life update (setLife never lets life go below 0)
    double lifeBefore = defender.getLife()!;
    defender.setLife(lifeBefore - damage);

    String attackKind = weak ? ' | Weak attack (wounded)' : '';
    print(
      'Critical hit: ${critical ? 'YES' : 'NO'} | Dodge: ${dodged ? 'YES' : 'NO'}$attackKind',
    );
    print(
      'Damage: ${damage.toStringAsFixed(2)} | ${defender.getName()} life: ${lifeBefore.toStringAsFixed(2)} → ${defender.getLife()!.toStringAsFixed(2)}',
    );

    // 6. checkState and new stats
    defender.checkState();
    if (!defender.isAlive()) {
      print(Message.defeat(defender.getName()!));
    }
  }

  static List<Samurai> alive(List<Samurai> team) {
    return team.where((samurai) => samurai.isAlive()).toList();
  }

  static bool isTeamDefeated(List<Samurai> team) {
    return alive(team).isEmpty;
  }

  // B3 — a random living samurai from a team
  static Samurai pickRandom(List<Samurai> team) {
    List<Samurai> living = alive(team);
    return living[dice.nextInt(living.length)];
  }

  // Keyboard input

  static String _readLine() {
    String? input = stdin.readLineSync();
    if (input == null) {
      print('\nNo more input. The battle cannot continue.');
      exit(1);
    }
    return input.trim();
  }

  // Asks again until the user types a whole number from min to max
  static int readNumber(String question, int min, int max) {
    while (true) {
      stdout.write(question);
      int? number = int.tryParse(_readLine());

      if (number != null && number >= min && number <= max) {
        return number;
      }
      print('Please type a number from $min to $max.');
    }
  }

  // Asks again until the name is not empty and not already taken
  static String readName(Set<String> usedNames) {
    while (true) {
      stdout.write('\nType the name of the new samurai: ');
      String name = _readLine();

      if (name.isEmpty) {
        print('The name cannot be empty.');
      } else if (usedNames.contains(name)) {
        print('There is already a samurai called $name.');
      } else {
        return name;
      }
    }
  }

  // B2 — the user adds 1 to 3 new samurai to each team.
  // Name, team and weapon come from the keyboard; the rest is random
  // inside the allowed limits (see Samurai.recruit).
  static void recruitNewSamurai(
    List<Samurai> militaryTeam,
    List<Samurai> roninTeam,
  ) {
    print('\n=== NEW WARRIORS JOIN THE BATTLE ===');

    int newMilitary = readNumber(
      'How many new Military Samurai will join (1-3)? ',
      1,
      3,
    );
    int newRonin = readNumber('How many new Ronin will join (1-3)? ', 1, 3);

    Set<String> usedNames = {
      for (Samurai samurai in militaryTeam + roninTeam) samurai.getName()!,
    };

    int addedMilitary = 0;
    int addedRonin = 0;

    while (addedMilitary < newMilitary || addedRonin < newRonin) {
      String name = readName(usedNames);

      int team;
      while (true) {
        team = readNumber('Team: 1. Military Samurai  2. Ronin: ', 1, 2);

        if (team == 1 && addedMilitary < newMilitary) {
          break;
        }
        if (team == 2 && addedRonin < newRonin) {
          break;
        }
        print('That team is already full. Choose the other team.');
      }

      int weapon = readNumber(
        'Weapon: 1. katana  2. yumi  3. naginata  4. wakizashi: ',
        1,
        4,
      );

      Samurai samurai;
      if (team == 1) {
        samurai = MilitarySamurai.recruit(name);
        militaryTeam.add(samurai);
        addedMilitary++;
      } else {
        samurai = Ronin.recruit(name);
        roninTeam.add(samurai);
        addedRonin++;
      }
      samurai.setWeaponType(weapons.values[weapon - 1]);
      usedNames.add(name);

      print('');
      samurai.printState();
    }
  }
}
