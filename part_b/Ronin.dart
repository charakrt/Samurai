import 'Samurai.dart';

class Ronin extends Samurai {
  Ronin.recruit(super.name) : super.recruit();

  @override
  samuraiType getType() => samuraiType.ronin;

  // A2 — ronin attack = hitPower + 5.0 + hitPower / 4.0
  @override
  double attack() {
    print('${getName()} shouts: My blade speaks for me! Haaaaiiii!');
    return getHitPower()! + 5.0 + (getHitPower()! / 4.0);
  }

  // B1 — a wild, unpredictable critical hit: damage × 1.5–2.5
  @override
  double criticalHit(double incomingDamage) {
    double multiplier = 1.5 + dice.nextDouble() * (2.5 - 1.5);
    return incomingDamage * multiplier;
  }

  // B1 — ronin fight light and fast: 15% chance to avoid an attack completely
  @override
  bool agility() {
    int agilityPercentage = dice.nextInt(100) + 1; // 1-100
    return agilityPercentage <= 15;
  }
}
