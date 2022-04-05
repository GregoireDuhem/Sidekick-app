import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidekick/providers/user_provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final bool isEdit;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    this.isEdit = false,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    final image = AssetImage(imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 1,
        child: buildCircle(
          color: const Color(0xFFc48efb),
          all: 8,
          child: Icon(
            isEdit ? Icons.add_a_photo : Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false).user;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Text('Profil', style: TextStyle(color: Theme.of(context).dialogBackgroundColor)),
        actions: <Widget>[
          Switch(
            value: context.watch<UserProvider>().isDarkMode,
            onChanged: (value) {
              Provider.of<UserProvider>(context, listen: false).setDarkMode();
            },
            activeColor: Theme.of(context).secondaryHeaderColor,
          ),
        ]
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 24),
          ProfileWidget(imagePath: "assets/avatar.png", onClicked: () {}),
          const SizedBox(height: 24),
          buildName(user!),
          const SizedBox(height: 50),
          buildDescription(user),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget buildDescription(User user) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 25.0),
        //rect bubble and text
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          gradient: LinearGradient(
            colors: [Theme.of(context).secondaryHeaderColor, Color(0xFFd2a6ff)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: (const EdgeInsets.all(15)),
        constraints: const BoxConstraints(maxWidth: 330),
        child: Text(
          user.description!,
          style: const TextStyle(fontSize: 16, height: 1.4, color: Colors.white),
        ),
      );

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.firstName! + ' ' + user.name!,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: Theme.of(context).dialogBackgroundColor),
          ),
          Text(user.username!, style: const TextStyle(fontSize: 20, color:Color(0xFFBDBDBD), fontStyle: FontStyle.italic)),
          const SizedBox(height: 50),
          Text(user.genre!, style: TextStyle(color: Theme.of(context).dialogBackgroundColor)),
          const SizedBox(height: 10),
          Text(user.age.toString() + " ans",
              style: TextStyle(color: Theme.of(context).dialogBackgroundColor)),
          const SizedBox(height: 10),
          Text(user.taille.toString() + " cm",
              style: TextStyle(color: Theme.of(context).dialogBackgroundColor)),
          const SizedBox(height: 10),
          Text(user.poids.toString() + " kg",
              style: TextStyle(color: Theme.of(context).dialogBackgroundColor)),
          const SizedBox(height: 10),
          Text(user.frequence.toString() + " entrainement(s) par semaine",
              style: TextStyle(color: Theme.of(context).dialogBackgroundColor)),
        ],
      );
}
