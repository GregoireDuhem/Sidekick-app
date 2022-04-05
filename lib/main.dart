import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidekick/pages/home.dart';

import 'package:sidekick/pages/navigation.dart';
import 'package:sidekick/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences storage = await SharedPreferences.getInstance();
  storage.clear();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => UserProvider(storage),
      ),
    ],
    child: const MyApp(),
  ));
}

Map<int, Color> color =
{
  50:const Color.fromRGBO(136,14,79, .1),
  100:const Color.fromRGBO(136,14,79, .2),
  200:const Color.fromRGBO(136,14,79, .3),
  300:const Color.fromRGBO(136,14,79, .4),
  400:const Color.fromRGBO(136,14,79, .5),
  500:const Color.fromRGBO(136,14,79, .6),
  600:const Color.fromRGBO(136,14,79, .7),
  700:const Color.fromRGBO(136,14,79, .8),
  800:const Color.fromRGBO(136,14,79, .9),
  900:const Color.fromRGBO(136,14,79, 1),
};

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    MaterialColor swatchBright = MaterialColor(0xFFe2e2e2, color);
    MaterialColor primaryBright = MaterialColor(0xFFFFFFFF, color);

    MaterialColor swatchDark = MaterialColor(0xFF111111, color);
    MaterialColor primaryDark = MaterialColor(0xFF1e1e1e, color);
    MaterialColor secondaryDark = MaterialColor(0xFF3b3b3b, color);
    MaterialColor tertiaryDark = MaterialColor(0xFF555354, color);

    MaterialColor darkFont = MaterialColor(0xFF111111, color);
    MaterialColor lightFont = MaterialColor(0xFFFFFFFF, color);
    MaterialColor secondary = MaterialColor(0xFFc48efb, color);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sidekick',
      theme: ThemeData(
        primarySwatch: swatchBright,
        primaryColor: primaryBright,
        secondaryHeaderColor: secondary,
        dialogBackgroundColor: darkFont,
          primaryColorDark: primaryBright,
          primaryColorLight: swatchBright
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: swatchDark,
        primaryColor: primaryDark,
        secondaryHeaderColor: secondary,
        dialogBackgroundColor: lightFont,
        primaryColorDark: secondaryDark,
        primaryColorLight: tertiaryDark
      ),
      themeMode: context.watch<UserProvider>().isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: context.watch<UserProvider>().isFirstTime
          ? const FormPage()
          : const Navigation(),
    );
  }
}
