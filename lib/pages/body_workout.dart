class UpperBodyWorkout {
  final String imagePath, name, instruction;
  final int glucides, lipides, proteins;

  UpperBodyWorkout(
      {required this.imagePath,
      required this.name,
      required this.instruction,
      required this.glucides,
      required this.lipides,
      required this.proteins});
}

final upperBody = [
  [
    UpperBodyWorkout(
      imagePath: "assets/apple.png",
      name: "Pomme",
      instruction: "100g : 0gr Lip - 0gr Prot - 20gr Glu",
      glucides: 20,
      lipides: 0,
      proteins: 0,
    ),
    UpperBodyWorkout(
      imagePath: "assets/broccoli.png",
      name: "Broccoli",
      instruction: "100g : 0gr Lip - 2gr Prot - 20gr Glu",
      glucides: 20,
      lipides: 0,
      proteins: 2,
    ),
    UpperBodyWorkout(
      imagePath: "assets/shrimp.png",
      name: "Crevette",
      instruction: "100g : 9gr Lip - 9gr Prot - 3gr Glu",
      glucides: 3,
      lipides: 9,
      proteins: 9,
    ),
  ],
  [
    UpperBodyWorkout(
      imagePath: "assets/meat.png",
      name: "Poulet",
      instruction: "100g : 1,7gr Lip - 26gr Prot - 0gr Glu",
      glucides: 0,
      lipides: 2,
      proteins: 26,
    ),
    UpperBodyWorkout(
      imagePath: "assets/steak.png",
      name: "Steak haché",
      instruction: "100gr : 5gr Lip - 21gr Prot - 0gr Glu",
      glucides: 0,
      lipides: 5,
      proteins: 21,
    ),
    UpperBodyWorkout(
      imagePath: "assets/egg.png",
      name: "Oeuf",
      instruction: "100gr : 10,2gr Lip - 12,3gr Prot - 0,7gr Glu",
      glucides: 1,
      lipides: 10,
      proteins: 12,
    ),
  ],
  [
    UpperBodyWorkout(
      imagePath: "assets/rice.png",
      name: "Riz thaï",
      instruction: "100gr : 1gr Lip - 8gr Prot - 78gr Glu",
      glucides: 78,
      lipides: 1,
      proteins: 8,
    ),
    UpperBodyWorkout(
      imagePath: "assets/spaguetti.png",
      name: "Pates completes",
      instruction: "100gr : 3gr Lip - 11gr Prot - 65gr Glu",
      glucides: 65,
      lipides: 3,
      proteins: 11,
    ),
    UpperBodyWorkout(
      imagePath: "assets/grain.png",
      name: "Semoule",
      instruction: "100gr : 2gr Lip - 13gr Prot - 72gr Glu",
      glucides: 72,
      lipides: 2,
      proteins: 13,
    ),
  ],
];
