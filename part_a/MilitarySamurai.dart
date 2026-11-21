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
}
