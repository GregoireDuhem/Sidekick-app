import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  late SharedPreferences _storage;
  User? user;
  late Match partner;

  UserProvider(SharedPreferences storage) {
    _storage = storage;
  }

  bool get isFirstTime => _storage.getBool('firstTime') ?? true;

  bool get isDarkMode => _storage.getBool('darkMode') ?? true;

  bool get isPartnerFound => _storage.getBool('partnerFound') ?? false;

  registerUser(Map<String, dynamic> formData) async {
    _storage.setBool('firstTime', false);
    // user = User(formData);
    user = User(formData);
    partner = Match(user!);
    notifyListeners();
  }

  findPartner() {
    _storage.setBool('partnerFound', true);
    notifyListeners();
  }

  setDarkMode() {
    _storage.setBool('darkMode', !isDarkMode);
    notifyListeners();
  }

  getMatch() {}

  //functions related to user // ex : getUser(), setUser(), etc...
}

class User {
  String? username;
  String? name;
  String? firstName;
  String? description;
  String? genre;
  int? age;
  int? taille;
  int? poids;
  int? frequence;

  User(Map<String, dynamic> formData)
      : username = formData['username'],
        name = formData['name'],
        firstName = formData['prenom'],
        description = formData['description'],
        genre = formData['genre'],
        age = int.parse(formData['age']),
        taille = int.parse(formData['taille']),
        poids = int.parse(formData['poids']),
        frequence = int.parse(formData['frequence']);
}

class Match {
  String? name;
  int? age;
  int? frequence;
  String? photo;

  Match(User user) {
    print(user.genre!);
    if (user.genre! != 'homme') {
      if (user.frequence! <= 1) {
        name = 'Christelle P.';
        photo = "assets/people/fat_woman.jpeg";
        frequence = 1;
        age = 26;
      } else if (user.frequence! > 1 && user.frequence! < 3) {
        name = 'Claire T.';
        frequence = 2;
        age = 22;
        photo = "assets/people/normal_woman.jpeg";
      } else {
        age = 21;
        frequence = 5;
        name = 'Chloé A.';
        photo = "assets/people/sports_woman.jpeg";
      }
    } else {
      if (user.frequence! <= 1) {
        frequence = 0;
        age = 27;
        name = 'Jeremy C.';
        photo = "assets/people/fat_man.jpeg";
      } else if (user.frequence! > 1 && user.frequence! < 3) {
        frequence = 2;
        age = 23;
        name = 'Charles B.';
        photo = "assets/people/normal_man.jpeg";
      } else {
        age = 25;
        frequence = 4;
        name = 'Nathan U.';
        photo = "assets/people/sports_man.jpeg";
      }
    }
  }
}
