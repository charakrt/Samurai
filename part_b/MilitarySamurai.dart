import 'Samurai.dart';

class MilitarySamurai extends Samurai {
  MilitarySamurai.recruit(super.name) : super.recruit();

  @override
  samuraiType getType() => samuraiType.military;

  // A2 — military attack = hitPower + 10.0
  @override
  double attack() {
    print('${getName()} shouts: For the Shogun! Haaaaiiii!');
    return getHitPower()! + 10.0;
  }

  // B1 — a disciplined, steady critical hit: damage × 1.5–2.0
  @override
  double criticalHit(double incomingDamage) {
    double multiplier = 1.5 + dice.nextDouble() * (2.0 - 1.5);
    return incomingDamage * multiplier;
  }

  // B1 — military samurai wear heavier gear, so they dodge less often
  // than ronin: 5% chance to avoid an attack completely
  @override
  bool agility() {
    int agilityPercentage = dice.nextInt(100) + 1; // 1-100
    return agilityPercentage <= 5;
  }
}
