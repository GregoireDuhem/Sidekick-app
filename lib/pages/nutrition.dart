import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animations/animations.dart';
import 'package:vector_math/vector_math.dart' as math;
import 'package:sidekick/pages/body_workout.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sidekick/pages/bar_chart.dart';
import 'package:sidekick/pages/line_chart_sample.dart';
import 'chart_container.dart';
import 'package:sidekick/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Stats extends StatefulWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  int _proteines = 0;
  int _lipides = 0;
  int _glucides = 0;

  late bool isShowingMainData;
  late User user;

  @override
  void initState() {
    super.initState();
    user = context.read<UserProvider>().user!;
    isShowingMainData = true;
  }

  setNutritionalValues(UpperBodyWorkout aliment) {
    setState(() {
      _glucides += aliment.glucides;
      _proteines += aliment.proteins;
      _lipides += aliment.lipides;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    initializeDateFormatting('fr', null);
    DateTime now = DateTime.now();
    var formatter = DateFormat("EEEE d MMMM", 'fr');
    String date = formatter.format(now);
    String dateFormated =
        date.substring(0, 1).toUpperCase() + date.substring(1);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Nutrition'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(40),
              ),
              child: Container(
                color: Theme.of(context).primaryColor,
                padding: const EdgeInsets.only(
                    top: 15, left: 32, right: 16, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        dateFormated,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Theme.of(context).dialogBackgroundColor,
                        ),
                      ),
                      subtitle: Text(
                        "Bonjour, ${user.firstName}",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 26,
                          color: Theme.of(context).dialogBackgroundColor,
                        ),
                      ),
                      trailing: const ClipOval(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 32, top: 20),
                      child: Row(
                        children: <Widget>[
                          _RadialProgress(
                            width: width * 0.3,
                            height: width * 0.3,
                            progress: 0.9,
                            key: null,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _IngredientProgress(
                                ingredient: "Protéines",
                                progress:
                                    _proteines / 90 > 1 ? 1 : _proteines / 90,
                                progressColor: Colors.green,
                                leftAmount: _proteines,
                                width: width * 0.22,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              _IngredientProgress(
                                ingredient: "Lipides",
                                progress:
                                    _lipides / 105 > 1 ? 1 : _lipides / 105,
                                progressColor: Colors.red,
                                leftAmount: _lipides,
                                width: width * 0.22,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              _IngredientProgress(
                                ingredient: "Glucides",
                                progress:
                                    _glucides / 120 > 1 ? 1 : _glucides / 120,
                                progressColor: Colors.yellow,
                                leftAmount: _glucides,
                                width: width * 0.22,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 20),
                  child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 10, left: 32, right: 32),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF20008B),
                          Color(0xFF200087),
                        ],
                      ),
                    ),
                    child: ChartContainer(
                        title: 'Statistiques Hebdomadaires',
                        color: Theme.of(context).colorScheme.primary,
                        chart: const BarChartContent()),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: OpenContainer(
                    closedElevation: 0,
                    transitionType: ContainerTransitionType.fade,
                    transitionDuration: const Duration(milliseconds: 1000),
                    closedColor: const Color(0x001e1e1e),
                    openBuilder: (context, _) {
                      return WorkoutScreen(
                          nutritionalValues: setNutritionalValues);
                    },
                    closedBuilder: (context, VoidCallback openContainer) {
                      return GestureDetector(
                        onTap: openContainer,
                        child: Container(
                          margin: const EdgeInsets.only(
                              bottom: 10, left: 32, right: 32),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF7C52FC),
                                Color(0xFF482797),
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                width: 20,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 16.0, left: 16),
                                child: Text(
                                  "Vos prochains repas",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 4.0, left: 16),
                                child: Text(
                                  "Aliments",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        color: Color(0xFF5B4D9D),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset(
                                        "assets/apple.png",
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        color: Color(0xFF5B4D9D),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset(
                                        "assets/broccoli.png",
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        color: Color(0xFF5B4D9D),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset(
                                        "assets/burger.png",
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            AspectRatio(
              aspectRatio: 1.23,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Container(
                  margin:
                      const EdgeInsets.only(bottom: 10, left: 32, right: 32),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff2c274c),
                        Color(0xff46426c),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const SizedBox(
                            height: 37,
                          ),
                          const Text(
                            'Calories moyennes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 37,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 16.0, left: 6.0),
                              child: LineChartSample(
                                  isShowingMainData: isShowingMainData),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.white
                              .withOpacity(isShowingMainData ? 1.0 : 0.5),
                        ),
                        onPressed: () {
                          setState(() {
                            isShowingMainData = !isShowingMainData;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IngredientProgress extends StatelessWidget {
  final String ingredient;
  final int leftAmount;
  final double progress, width;
  final Color progressColor;

  const _IngredientProgress(
      {Key? key,
      required this.ingredient,
      required this.leftAmount,
      required this.progress,
      required this.progressColor,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          ingredient.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).dialogBackgroundColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 9,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
                Container(
                  height: 9,
                  width: width * progress,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: progressColor,
                  ),
                )
              ],
            ),
            const SizedBox(
              width: 7,
            ),
            Text(
              "${leftAmount}g",
              style: TextStyle(
                  fontSize: 13, color: Theme.of(context).dialogBackgroundColor),
            ),
          ],
        ),
      ],
    );
  }
}

class _RadialProgress extends StatelessWidget {
  final double height, width, progress;

  const _RadialProgress(
      {Key? key,
      required this.height,
      required this.width,
      required this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadialPainter(
        progress: 0.7,
      ),
      child: SizedBox(
        height: height,
        width: width,
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "1731",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).dialogBackgroundColor),
                ),
                const TextSpan(text: "\n"),
                TextSpan(
                  text: "kcal restantes",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).dialogBackgroundColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadialPainter extends CustomPainter {
  final double progress;

  _RadialPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 10
      ..color = const Color(0xFF7C52FC)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double relativeProgress = 360 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      math.radians(-90),
      math.radians(-relativeProgress),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({Key? key, required this.nutritionalValues})
      : super(key: key);

  final Function nutritionalValues;

  final snackBar = const SnackBar(
    backgroundColor: Colors.green,
    duration: Duration(milliseconds: 800),
    content: Text(
      'Aliment ajouté',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
    ),
  );

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('fr', null);
    DateTime now = DateTime.now();
    var formatter = DateFormat("EEEE d MMMM", 'fr');
    String date = formatter.format(now);
    String dateFormated =
        date.substring(0, 1).toUpperCase() + date.substring(1);

    return Scaffold(
      backgroundColor: const Color(0xFF7C52FC),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF7C52FC),
                Color(0xFF482797),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16,
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: Text(
                    dateFormated,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: const Text(
                    "Mes Aliments",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                for (int i = 0; i < upperBody.length; i++)
                  Column(
                    children: <Widget>[
                      for (int j = 0; j < upperBody[i].length; j++)
                        ListTile(
                          onTap: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            nutritionalValues(upperBody[i][j]);
                          },
                          leading: Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Color(0xFF5B4D9D),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Image.asset(
                              upperBody[i][j].imagePath,
                              width: 45,
                              height: 45,
                            ),
                          ),
                          title: Text(
                            upperBody[i][j].name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            upperBody[i][j].instruction,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
