import 'Samurai.dart';

// B4 — all the storytelling of the program.
// Message only produces text: it never calculates damage.
// The Samurai classes and Tool handle the rules.
class Message {
  static const List<String> _entrances = [
    '"{name} steps onto the battlefield..."',
    '"{name} appears through the morning mist..."',
    '"The crowd falls silent as {name} walks in..."',
    '"{name} bows once, then takes his place..."',
  ];

  static const List<String> _attacks = [
    '«The {weapon} cuts through the air!»',
    '«{striker} lunges at {defender} with a fierce cry!»',
    '«Steel flashes as {striker} charges!»',
    '«{striker} moves like the wind towards {defender}!»',
    '«The {weapon} sings a deadly song!»',
  ];

  static const List<String> _defends = [
    '«{defender} braces himself behind his {gear}.»',
    '«Part of the blow is absorbed by his {gear}.»',
    '«{defender} grits his teeth as his {gear} absorbs the hit.»',
  ];

  static const List<String> _dodges = [
    '«{defender} twists aside at the last moment!»',
    '«Like a shadow, {defender} is no longer there!»',
    '«{defender} leaps back and the blow cuts only air!»',
  ];

  static const List<String> _criticalHits = [
    '«A perfect strike! {striker} finds the gap in the guard!»',
    '«{striker} strikes with the strength of ten men!»',
    '«Lightning-fast, {striker} lands a devastating blow!»',
  ];

  static const List<String> _defeats = [
    '«{name} falls to his knees and does not rise again.»',
    '«{name}\'s sword slips from his hand. His battle is over.»',
    '«{name} has fought his last fight.»',
  ];

  static const List<String> _victories = [
    '«The wind settles. The {team} stand victorious!»',
    '«Silence returns to the field. Honour belongs to the {team}!»',
    '«The battle is over. The {team} have won the day!»',
  ];

  static String _pick(List<String> lines) {
    return lines[dice.nextInt(lines.length)];
  }

  static String entrance(String name) {
    return _pick(_entrances).replaceAll('{name}', name);
  }

  static String attack(String striker, String defender, String weapon) {
    return _pick(_attacks)
        .replaceAll('{striker}', striker)
        .replaceAll('{defender}', defender)
        .replaceAll('{weapon}', weapon);
  }

  static String defend(String defender, bool hasArmor, bool hasHorse) {
    String gear = 'armor';
    if (hasArmor && hasHorse) {
      gear = 'armor and horse';
    } else if (hasHorse) {
      gear = 'horse';
    }
    return _pick(
      _defends,
    ).replaceAll('{defender}', defender).replaceAll('{gear}', gear);
  }

  static String dodge(String defender) {
    return _pick(_dodges).replaceAll('{defender}', defender);
  }

  static String criticalHit(String striker) {
    return _pick(_criticalHits).replaceAll('{striker}', striker);
  }

  static String defeat(String name) {
    return _pick(_defeats).replaceAll('{name}', name);
  }

  static String victory(String team) {
    return _pick(_victories).replaceAll('{team}', team);
  }

  static String title() => '\n=== AUTOMATED SAMURAI BATTLE ===';

  static String pressEnter() => '\nPress ENTER for the next round.';
}
