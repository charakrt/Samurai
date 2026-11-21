# ⚔️ The Samurai Chronicles — a turn-based battle simulation in Dart

A console battle simulation set in feudal Japan, written in **Dart** as an exercise in object-oriented programming.
Two teams of samurai — loyal **Military Samurai** and wandering **Ronin** — clash in a narrated battle where weapons, armor, horses and a touch of randomness decide who is left standing.

The project was built as an intermediate-level assignment (Level 15) at the **Computer Science Center (CSC)**, Athens, and is split into two separate programs:

| Program | What it does |
|---|---|
| **Part A — The scripted battle** | Five named warriors, a fixed story and a fixed order of attacks. |
| **Part B — The automated battle** | The user recruits the warriors from the keyboard, and the battle runs on its own until one team is wiped out, with critical hits and agility in play. |

---

## ✨ Features

**Part A**
- An abstract `Samurai` class with two subclasses, `MilitarySamurai` and `Ronin`, each with its own attack formula and battle cry
- Four weapon types (`katana`, `yumi`, `naginata`, `wakizashi`) modelled with an `enum`, each with its own power, multiplied ×1.8 when dual-wielding
- Defense that depends on equipment: armor absorbs 10, a horse 5, both together 15, and damage never drops below 0
- Life that is clamped at 0, and warriors who are announced dead when it runs out
- Randomness kept inside clear limits (hit power 10–20, life 35–100, a weak attack loses 1–20% of its power)
- A short narrated introduction of every warrior before the fight

**Part B** (adds to Part A)
- **Recruiting from the keyboard**: name, team and weapon, with every input checked and asked again when it is invalid
- **Critical hit**: 5% chance; for a Military Samurai it multiplies the damage by a random factor
- **Agility**: Ronin have a 15% chance to dodge an attack completely
- **Random weak attacks**: about 14% of attacks lose part of their power
- **Automated battle loop** built on `Queue`s: attackers and defenders take turns, dead warriors are removed, and the battle ends when one team has no one left
- **Paced storytelling**: press `ENTER` after every attack to continue
- Static helper methods in a `Tool` class and a Dart 3 **record** `(List<MilitarySamurai>, List<Ronin>)` to return both teams at once

---

## 🧱 Class design

```
Samurai (abstract)
├── name, weaponType, doubleWeapon, hasHorse, hasArmor, hitPower, life   (private, with getters/setters)
├── Samurai.recruit(name)        named constructor with random starting values
├── defend(incomingDamage)       subtracts armor/horse protection, never below 0
├── getWeaponPower()             weapon base power, ×1.8 for double weapon
├── checkState()                 clamps life at 0 and reports dead/alive
├── printInfo()                  prints the warrior's stats
└── attack()                     abstract, each subclass defines its own
    │
    ├── MilitarySamurai          attack = hitPower + 10        "For the Shogun!"
    └── Ronin                    attack = hitPower + 5 + hitPower/4   "My blade speaks for me!"

Tool                             battle logic: attack(striker, defender), recruitTeams() in Part B
```

---

## 📁 Project structure

```
Samurai/
├── part_a/
│   ├── main.dart              the scripted story and the order of attacks
│   ├── Samurai.dart
│   ├── MilitarySamurai.dart
│   ├── Ronin.dart
│   └── Tool.dart
├── part_b/
│   ├── main.dart              the automated battle loop
│   ├── Samurai.dart
│   ├── MilitarySamurai.dart
│   ├── Ronin.dart
│   ├── tool.dart
│   └── BattleMessages.dart
├── LICENSE
└── README.md
```

---

## 🚀 How to run

You need the [Dart SDK](https://dart.dev/get-dart) (version 3.0 or later, because Part B uses records).

```bash
git clone https://github.com/charakrt/Samurai.git
cd Samurai

# Part A — the scripted battle
dart run part_a/main.dart

# Part B — the automated battle (interactive)
dart run part_b/main.dart
```

Part B asks you to recruit two warriors for each team, then press `ENTER` to move the battle forward one attack at a time.

---

## 🖥️ Sample output (Part A)

```
"Akechi Mitsuhide appears in the centre of the battlefield.."

Name: Akechi Mitsuhide
Weapon: katana
Military Samurai
Double Weapon: Yes
Armor: Yes
Horse: No
Hit Power: 14.37
Life: 100.00

...

Takeda Nobunaga attacks Akechi Mitsuhide & Date Masamune.
Takeda Nobunaga shouts: My blade speaks for me! Haaaaiiii!
Takeda Nobunaga attacks with total hit power 33.12. Akechi Mitsuhide defends himself. His armor absorbs 10.0 points.

Akechi Mitsuhide's current life is 76.88
```

*(Numbers change on every run because of the randomness.)*

---

## 🧠 What I practised

- Modelling attributes and behaviour in classes, with **encapsulation** (private fields, getters and setters)
- **Inheritance**, **abstract classes and methods**, and **method overriding**
- Named constructors and the `super` parameters of Dart 3
- `enum`s, `Random` inside controlled ranges, and null safety
- Static methods, `Queue` from `dart:collection`, and Dart 3 **records**
- Reading and validating keyboard input with `stdin`
- Keeping the battle rules inside the classes and the order of events in `main`

---

## 🛠️ Known limitations and next steps

This is a learning project and some parts are still in progress:

- [ ] `MilitarySamurai.agility()` is not implemented yet, so Part B stops with an error the first time a Military Samurai has to defend
- [ ] In Part B the weapon chosen from the keyboard is replaced by a random one right after it is chosen, and typing a non-number at the weapon prompt crashes the program
- [ ] `BattleMessages` (random battle phrases kept apart from the battle logic) is started but not connected yet
- [ ] Part A stops after the first attacks of the story; the remaining steps (until one team is defeated) are still to be written
- [ ] Team size is fixed at 2 in Part B; the plan is to let the user choose 1–3
- [ ] Add a round counter, a maximum number of rounds as a safety limit, and a fixed `Random` seed so a battle can be replayed for testing
- [ ] Add unit tests for weapons, double weapon, defense, the life clamp and the end of the battle

---

## 👩‍💻 Author

**Charikleia (Chara) Karteri**

Built as a course assignment at Computer Science Center (CSC), Athens. The assignment brief belongs to the course; the code in this repository is my own.

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
