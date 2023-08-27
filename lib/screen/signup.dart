import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:hospital/screen/listOfPatients.dart';
import '../component/button.dart';
import '../component/textfeild.dart';
import 'signin.dart';

class Signup extends StatefulWidget {
  final Function()? onTap;

  const Signup({super.key, required this.onTap});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final fireBaseInstance = FirebaseAuth.instance;
  //sign user in method
  Future<bool> signUserUp() async {
    try {
      if (passwordController.text == confirmPasswordController.text) {
        await fireBaseInstance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        String userUid = fireBaseInstance.currentUser!.uid;
        final userDocRef = FirebaseFirestore.instance.collection("users").doc(userUid);
        final newUserInfos = <String, dynamic>{
          "id": userUid,
          "email": emailController.text,
          "isAdmin": false,
        };
        await userDocRef.set(newUserInfos);

        return true; // Sign-up successful
      } else {
        passwordDontMatch();
        return false; // Sign-up failed
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        wrongEmailMessage();
      } else if (e.code == 'wrong-password') {
        wrongPasswordMessage();
      }
      return false; // Sign-up failed
    }
  }




  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Incorrect Email'),
        );
      },
    );
  }

  void handleSignUpButtonTap() async {
    bool signUpSuccessful = await signUserUp();
    if (signUpSuccessful) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login(onTap: () {  },)), // Navigate to the Login screen
      );
    }
  }


  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Incorrect password'),
        );
      },
    );
  }

  void passwordDontMatch() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Password dont match'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 377.0; // Define your new base width here
    double baseHeight = 667.0; // Define your new base height here
    double fem = MediaQuery
        .of(context)
        .size
        .width / baseWidth;
    Color backgroundColor = Color(
        0xFF7E8BB9); //Convert the hexadecimal color value to a Color object
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [

                SizedBox(height: 50),
                Image.asset('Assets/nursehello.png'),


                SizedBox(height: 100),
                Text(
                  'Lets create an account for you!',
                  style: GoogleFonts.abhayaLibre(
                    fontSize: 22 * fem,
                    // Increase the font size
                    fontWeight: FontWeight.w200,
                    height: 1.2125 * fem,
                    fontStyle: FontStyle.italic,
                    color: Colors.white, // Set the text color to white
                  ),
                ),


                const SizedBox(height: 25),
                MyTextField(
                  controller: emailController,
                  hintText: 'E-mail',
                  obscureText: false,
                  maxLines: 1,
                ),


                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  maxLines: 1,
                ),

                const SizedBox(height: 10),
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm password',
                  obscureText: true,
                  maxLines: 1,
                ),


                const SizedBox(height: 25),
                MyButton(
                  text: "SIGN UP",
                  onTap: handleSignUpButtonTap,
                ),


                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login(onTap: () {  },)), // Navigate to the Login screen
                    );
                  },
                  child: const Text(
                    'Already have an account? Login now',
                    style: TextStyle(
                      color: Colors.white54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}
