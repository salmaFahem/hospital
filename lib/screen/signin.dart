import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import '../component/button.dart';
import '../component/textfeild.dart';
import 'listOfPatients.dart';

class Login extends StatefulWidget {
  final Function()? onTap;
  const Login({super.key, required this.onTap});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //sign user in method
  void signUserIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Navigate to the ListOfPatients screen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ListOfPatients()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        wrongEmailMessage();
      } else if (e.code == 'wrong-password') {
        wrongPasswordMessage();
      }
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

  @override
  Widget build(BuildContext context) {
    double baseWidth = 377.0; // Define your new base width here
    double fem = MediaQuery.of(context).size.width / baseWidth;
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
                  Image.asset('Assets/logo cab (1).png'),


                  SizedBox(height: 100),
                  Text(
                    'WELCOME',
                    style: GoogleFonts.abhayaLibre(
                      fontSize: 40 * fem, // Increase the font size
                      fontWeight: FontWeight.w500,
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


                  const SizedBox(height: 25),
                  MyButton(
                    text: "SIGN IN",
                    onTap: signUserIn,
                  ),

                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text('Not a member? Register now',
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
