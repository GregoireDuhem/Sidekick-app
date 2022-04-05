import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidekick/pages/matching.dart';
import 'package:sidekick/providers/user_provider.dart';
import 'bar_chart.dart';
import 'chart_container.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.pageController}) : super(key: key);

  final PageController pageController;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool partnerFound = false;

  @override
  Widget build(BuildContext context) {
    partnerFound = context.watch<UserProvider>().isPartnerFound;
    return context.watch<UserProvider>().isPartnerFound
        ? HomeLoggedIn(pageController: widget.pageController)
        : const Matching();
  }
}

class Matching extends StatefulWidget {
  const Matching({Key? key}) : super(key: key);

  @override
  _MatchingState createState() => _MatchingState();
}

class _MatchingState extends State<Matching> {
  bool isSearchingPartner = false;

  void findPartner() {
    setState(() {
      isSearchingPartner = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text('Matching'),
          centerTitle: true,
        ),
        body: isSearchingPartner
            ? const Center(child: MatchingAnimation())
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bienvenue sur Sidekick',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Avant de commencer, vous devez trouver votre partenaire.',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).secondaryHeaderColor,
                        onPrimary: const Color(0xFFd2a6ff),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Trouver mon partenaire !',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => findPartner(),
                    ),
                  ],
                ),
              ));
  }
}

class HomeLoggedIn extends StatefulWidget {
  const HomeLoggedIn({Key? key, required this.pageController})
      : super(key: key);

  final PageController pageController;

  @override
  _HomeLoggedInState createState() => _HomeLoggedInState();
}

class _HomeLoggedInState extends State<HomeLoggedIn> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = context.read<UserProvider>().user!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(user.firstName! + ' ' + user.name!),
        leading: const Padding(
          padding:
              EdgeInsets.only(left: 16.0, bottom: 10.0, top: 10.0, right: 4.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/avatar_bright.png'),
          ),
        ),
      ),
      body: Center(
        child: PartnerOverview(pageController: widget.pageController),
      ),
    );
  }
}

class PartnerOverview extends StatefulWidget {
  PartnerOverview({Key? key, required this.pageController}) : super(key: key);

  late PageController pageController;

  @override
  _PartnerOverviewState createState() => _PartnerOverviewState();
}

class _PartnerOverviewState extends State<PartnerOverview> {
  late Match partner;

  @override
  void initState() {
    super.initState();
    partner = context.read<UserProvider>().partner;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            children: [
              Container(
                height: 150,
                padding: const EdgeInsets.only(left: 8.0, bottom: 24.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Votre partenaire',
                        style: TextStyle(
                          color: Color(0xffc48efb),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(partner.photo!),
                              radius: 30,
                            ),
                            IconButton(
                              onPressed: () {
                                widget.pageController.animateToPage(
                                  1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              icon: const Icon(Icons.chat),
                              tooltip: 'Chat',
                            ),
                            Column(
                              children: [
                                Text(
                                  partner.name!,
                                ),
                                Text(
                                  '${partner.age} ans',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: ChartContainer(
                    title: 'Statistiques Hebdomadaires',
                    color: Theme.of(context).colorScheme.primary,
                    chart: const BarChartContent()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> formData = {};
  bool isError = false;
  bool isButtonPressed = false;
  String selectedValue = "homme";
  List<DropdownMenuItem<String>> select = [
    const DropdownMenuItem(child: Text("Homme"),value: "homme"),
    const DropdownMenuItem(child: Text("Femme"),value: "femme"),
    const DropdownMenuItem(child: Text("Autres"),value: "autres"),
  ];

  String selectValue2 = "0";
  List<DropdownMenuItem<String>> select2 = [
    const DropdownMenuItem(child: Text("0 fois / semaine"),value: "0"),
    const DropdownMenuItem(child: Text("1 fois / semaine"),value: "1"),
    const DropdownMenuItem(child: Text("2 fois / semaine"),value: "2"),
    const DropdownMenuItem(child: Text("3 fois / semaine"),value: "3"),
    const DropdownMenuItem(child: Text("4 fois / semaine"),value: "4"),
    const DropdownMenuItem(child: Text("5 fois / semaine"),value: "5"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Text(
          'Inscription',
          style: TextStyle(color: Theme.of(context).dialogBackgroundColor),
        ),
      ),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Column(
            children: [
              buildNameInput('Nom d\'utilisateur'),
              buildInput("John1234", 'username',
                  'Veuillez entrer un nom d\'utilisateur'),
              buildNameInput('Prénom'),
              buildInput("John", 'prenom', 'Veuillez entrer un prénom'),
              buildNameInput('Nom'),
              buildInput('Smith', 'name', 'Veuillez entrer un nom'),
              buildNameInput('Genre'),
              buildSelectInput(select, 'genre', "homme", 'Veuillez choisir un genre'),
              buildNameInput('Description'),
              buildInput('Description', 'description',
                  'Veuillez entrer une description'),
              buildNameInput('Age'),
              buildInput('24', 'age', 'Veuillez entrer un âge'),
              buildNameInput('Taille en cm'),
              buildInput('185', 'taille', 'Veuillez entrer une taille'),
              buildNameInput('Poids'),
              buildInput('76', 'poids', 'Veuillez entrer un poids'),
              buildNameInput('Fréquence Sportive'),
              buildSelectInput(select2, 'frequence', "5", 'Veuillez choisir une fréquence'),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                child: ElevatedButton(
                  child: const Text('S\'inscrire',
                      style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(150, 40)),
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFFC48EFB)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      side: MaterialStateProperty.all(const BorderSide(
                        color: Color(0xFFC48EFB),
                        width: 2,
                      ))),
                  onPressed: () {
                    isButtonPressed = true;
                    if (_formKey.currentState?.validate() ?? false) {
                      Provider.of<UserProvider>(context, listen: false)
                          .registerUser(formData);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  Widget buildNameInput(var name) => SizedBox(
        width: double.infinity,
        child: Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Text(name,
                style: TextStyle(
                    color: Theme.of(context).dialogBackgroundColor,
                    fontSize: 20),
                textAlign: TextAlign.left)),
      );

  Widget buildInput(var placeholder, var data, var errorMessage) => Container(
        margin: const EdgeInsets.all(15),
        child: TextFormField(
          cursorColor: Colors.purple[300],
          cursorHeight: 25.0,
          style: TextStyle(
              color: Theme.of(context).dialogBackgroundColor, fontSize: 17),
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.0)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.0)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: Color(0xFF212121), width: 2.0)),
              filled: true,
              fillColor: Theme.of(context).primaryColorDark,
              labelText: placeholder,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelStyle: const TextStyle(color: Colors.grey, fontSize: 17)),
          validator: (value) {
            if (!isButtonPressed) {
              return null;
            }
            isError = true;
            if (value == null || value.isEmpty) {
              return errorMessage;
            }
            if (data == 'nom' && value.length < 2 || value.length > 40) {
              return ("Le nom n'est pas valide (2 caractères minimum).");
            }
            if (data == 'prenom' && value.length < 2 || value.length > 40) {
              return ("Le prénom n'est pas valide (2 caractères minimum).");
            }
            if (data == 'age' &&
                (int.tryParse(value) == null ||
                    int.parse(value) < 16 ||
                    int.parse(value) > 99)) {
              return ("L'âge n'est pas valide.");
            }
            if (data == 'poids' &&
                (int.tryParse(value) == null ||
                    int.parse(value) < 35 ||
                    int.parse(value) > 300)) {
              return ("Le poids n'est pas valide.");
            }
            if (data == 'taille' &&
                (int.tryParse(value) == null ||
                    int.parse(value) < 100 ||
                    int.parse(value) > 280)) {
              return ("La taille n'est pas valide.");
            }
            formData[data] = value;
            isError = false;
            return null;
          },
          onChanged: (value) {
            isButtonPressed = false;
            if (isError) {
              _formKey.currentState?.validate();
            }
          },
        ),
      );

  Widget buildSelectInput(List<DropdownMenuItem<String>> select, var data,
          String placeholder, var errorMessage) =>
      Container(
        margin: const EdgeInsets.all(15),
        child: DropdownButtonFormField(
          style: TextStyle(color: Theme.of(context).dialogBackgroundColor, fontSize: 17),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
              borderRadius: BorderRadius.circular(10.0),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF212121), width: 2),
              borderRadius: BorderRadius.circular(10.0),
            ),
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelStyle: const TextStyle(color: Colors.grey, fontSize: 17),
            fillColor: Theme.of(context).primaryColorDark,
          ),
          dropdownColor: Theme.of(context).primaryColor,
          value: placeholder,
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue!;
            });
          },
          isExpanded: true,
          validator: (value) {
            if (value == null) {
              return errorMessage;
            }
            formData[data] = value;
          },
          items: select
        )
      );
}
