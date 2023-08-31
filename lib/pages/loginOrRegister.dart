import 'package:flutter/material.dart';
import 'package:hospital/screen/signin.dart';
import 'package:hospital/screen/signup.dart';

class LoginOrRegister extends  StatefulWidget {
  final Function()? onTap;
  const LoginOrRegister({super.key, required this.onTap});
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