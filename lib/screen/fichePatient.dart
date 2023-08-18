import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../component/textfeild.dart';

class FichePatient extends StatelessWidget {
  FichePatient({Key? key}) : super(key: key);

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ageController = TextEditingController();
  final heartBeatController = TextEditingController();
  final temperatureController = TextEditingController();
  final oxygenController = TextEditingController();
  final situationController = TextEditingController();
  final noteController = TextEditingController();


  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Color(
        0xFF7E8BB9); //Convert the hexadecimal color value to a Color object
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [IconButton(onPressed: signUserOut, icon: Icon(Icons.logout, color: backgroundColor))],),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text fields on the left
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: 0),
                        MyTextField(
                          controller: firstNameController,
                          hintText: 'First Name',
                          obscureText: false,
                          maxLines: 1,
                        ),

                        const SizedBox(height:4),
                        MyTextField(
                          controller: lastNameController,
                          hintText: 'Last Name',
                          obscureText: false,
                          maxLines: 1,
                        ),

                        const SizedBox(height: 4),
                        MyTextField(
                          controller: ageController,
                          hintText: 'Age',
                          obscureText: false,
                          maxLines: 1,
                        ),

                        const SizedBox(height: 4),
                        MyTextField(
                          controller: heartBeatController,
                          hintText: 'Heart beat (PBM)',
                          obscureText: false,
                          maxLines: 1,
                        ),

                        const SizedBox(height: 4),
                        MyTextField(
                          controller: temperatureController,
                          hintText: 'Temperature (°C)',
                          obscureText: false,
                          maxLines: 1,
                        ),

                        const SizedBox(height: 4),
                        MyTextField(
                          controller: oxygenController,
                          hintText: 'Oxygen percentage',
                          obscureText: false,
                          maxLines: 1,
                        ),

                        const SizedBox(height: 4),
                        MyTextField(
                          controller: situationController,
                          hintText: 'Situation',
                          obscureText: false,
                          maxLines: 1,
                        ),

                        const SizedBox(height: 4),
                        MyTextField(
                          controller: noteController,
                          hintText: 'Dr note..',
                          obscureText: false,
                          maxLines: null,
                        ),

                      ],
                    ),
                  ),
                ),

                // Image on the right
                Image.asset('Assets/doct (2).png'),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

