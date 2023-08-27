import 'package:flutter/material.dart';
import 'package:hospital/pages/loginOrRegister.dart';
import 'package:hospital/screen/signin.dart';

import '../component/button.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color(0xFF7E8BB9);
    //Convert the hexadecimal color value to a Color object
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        child: Stack(children: [
          Positioned(
              left: 60,
              top: 230,
              child: MyClickableImage(imagePath: 'Assets/doc sp.png'),),
        Positioned(
            left: 50,
            top: 410,
          child: Text('Login as a Dr',style: TextStyle(
            color: Colors.white,
            fontSize: 18, // Adjust font size as needed
            fontWeight: FontWeight.bold,
          ),)),
          Positioned(
              left: 180,
              top: 230,
              child: MyClickableImage(imagePath: 'Assets/nurse sp.png'),),
          Positioned(
              left: 220,
              top: 410,
              child: Text('Login as a Nurse',style: TextStyle(
                color: Colors.white,
                fontSize: 18, // Adjust font size as needed
                fontWeight: FontWeight.bold,
              ),)),
        ]),
      ),
    );
  }
}


class MyClickableImage extends StatelessWidget {
  final String imagePath;

  MyClickableImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginOrRegister(onTap: (){}),),
        );
      },
      child: Image.asset(imagePath),
    );
  }
}