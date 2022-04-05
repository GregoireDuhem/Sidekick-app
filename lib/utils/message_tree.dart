import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidekick/providers/user_provider.dart';

class Node<String> {
  final String message;
  final String username;
  final List<Node<String>> children;
  Node(this.message, this.username, this.children);
}

Node initTree(String user, String partner) {
  return Node("Bonjour ! Comment vas-tu ?", "Pierre",[
    Node("Bonjour, ça va très bien, merci !", "John", [
      Node("Je m'appelle $partner, et je suis ton partenaire !", "Pierre", [
        Node("Super ! Moi c'est $user. C'est super de pouvoir te parler !", "John", [
          Node("De quoi veux-tu discuter ?", "Pierre", [
            Node("Que cherches-tu sur l'application ?", "John", [
              Node("Je suis ici pour trouver un partenaire qui me motivera à faire du sport, et qui pourra me donner des conseils ! Je viens de débuter, et j'ai du mal à m'y mettre.", "Pierre", [
                Node("Ca tombe bien, moi aussi !", "John", [
                  Node("Alors c'est parti !", "Pierre", [])
                ]),
                Node("J'ai quelques conseils pour toi !", "John", [
                  Node("Ca serait super, merci !", "Pierre", [])
                ])
              ])
            ]),
            Node("Quel régime alimentaire souhaites-tu adopter ?", "John", [
              Node("Je pense qu'on peut voir ça ensemble !", "Pierre", [
                Node("Je ne m'y connais pas très bien...", "John", [
                  Node("Je pense qu'il nous faudrait un programme qui nous permettrait de prendre des muscles.", "Pierre", [])
                ]),
                Node("Je pense qu'il nous faudrait un programme qui nous permettrait de prendre des muscles.", "John", [
                  Node("Ca me paraît être une bonne idée !", "Pierre", [])
                ])
              ])
            ]),
            Node("Quels sont tes objectifs sportifs ?", "John", [
              Node("J'aimerais trouver un programme de musculation, construisons-le ensemble !", "Pierre", [
                Node("D'accord, je pense pouvoir t'aider.", "John", [
                  Node("Super, commençons !", "Pierre", [])
                ])
              ])
            ])
          ])
        ])
      ])
    ]),
    Node("Ca peut aller...", "John", [
      Node("Que se passe-t-il ?", "Pierre", [
        Node("Je ne trouve pas la motivation pour aller faire du sport...", "John", [
          Node("Parfait, car moi j'aimerais trouver un programme de musculation. Construisons-le ensemble !", "Pierre", [
            Node("Super, commençons !", "John ", [
              Node("C'est parti ! (:", "Pierre", [])
            ])
          ])
        ]),
        Node("Je ne suis pas en excellente santé...", "John", [
          Node("Je vois... Tu penses que le sport pourrait t'aider ?", "Pierre", [
            Node("Je pense que c'est plutôt un problème d'alimentation", "John", [
              Node("Pareil de mon côté. Il existe pas mal de régimes alimentaires différents, regardons ça ensemble !", "Pierre", [])
            ]),
            Node("Oui, je n'en pratique quasiment pas...", "John", [
              Node("Un programme de remise en forme s'impose !", "Pierre", [])
            ])
          ])
        ]),
        Node("J'aimerais avoir un meilleur régime alimentaire.", "John", [
          Node("Je pense qu'on peut voir ça ensemble !", "Pierre", [
            Node("Je ne m'y connais pas très bien...", "John", [
              Node("Je pense qu'il nous faudrait quelque chose adapté à la prise de masse.", "Pierre", [])
            ]),
            Node("Je pense qu'il nous faudrait quelque chose adapté à la prise de masse.", "John", [
              Node("Ca me paraît être une bonne idée !", "Pierre", [])
            ])
          ])
        ])
      ])
    ])
  ]);
}