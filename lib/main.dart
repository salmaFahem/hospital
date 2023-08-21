import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hospital/pages/authPage.dart';
import 'package:hospital/pages/notif.dart';
import 'package:hospital/screen/fichePatientNurse.dart';
import 'package:hospital/screen/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screen/fichePatientDr.dart';
import 'screen/listOfPatients.dart';
import 'screen/signin.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}

