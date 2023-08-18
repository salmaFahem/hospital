import 'package:flutter/material.dart';
import 'package:hospital/screen/signin.dart';
import 'package:hospital/screen/signup.dart';

class LoginOrRegister extends  StatefulWidget {
  const LoginOrRegister({Key? key}) : super(key: key);

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return Login(
        onTap: togglePages,
      );
    } else {
      return Signup(
        onTap: togglePages,
      );
    }
  }
}

