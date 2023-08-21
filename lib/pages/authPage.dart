import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hospital/pages/loginOrRegister.dart';
import 'package:hospital/screen/signin.dart';

import '../screen/fichePatientDr.dart';

class AuthPage extends  StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is logged in
          if (snapshot.hasData) {
            return FichePatient();
          }

          //user is not logged in
          else {
            return LoginOrRegister();
          }
        },
      ),
    );
  }
}
