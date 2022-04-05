import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  //User user = UserPreferences.myUser;
  Map<String, dynamic> formData = {};

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF212121),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black87,
          title: const Text('Modifier le profil'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          physics: const BouncingScrollPhysics(),
          children: const [
            SizedBox(height: 24),
          ],
        ),
      );
}

Widget buildNameInput(var name) => SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Text(name,
            style: const TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.left),
      ),
    );
