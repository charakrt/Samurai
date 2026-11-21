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
}
