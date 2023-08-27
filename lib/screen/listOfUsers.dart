import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospital/screen/signin.dart';
import 'fichePatientDr.dart';
import 'fichePatientNurse.dart';

class ListOfUsers extends StatefulWidget {
  const ListOfUsers({Key? key}) : super(key: key);

  @override
  State<ListOfUsers> createState() => _ListOfUsersState();
}

class _ListOfUsersState extends State<ListOfUsers> {
  final patientNameController = TextEditingController();
  final ageController = TextEditingController();
  final noteController = TextEditingController();
  final fireStorenstance = FirebaseFirestore.instance;
  final fireBaseInstance = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color(0xFF7E8BB9);
    //Convert the hexadecimal color value to a Color object
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: const Text('List of users'),
      ),
      body: Container(
        height: 1000,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
               Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        textDirection: TextDirection.ltr,
                        children: const [
                          SizedBox(width: 0),
                          Expanded(
                            child: Text(
                              "Email",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                // Set the text color to white
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(width: 0),
                          Expanded(
                            child: Text(
                              "is Doctor ?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                // Set the text color to white
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              StreamBuilder(
                stream: fireStorenstance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot =
                            snapshot.data!.docs[index];
                        Map<String, dynamic>? data =
                            documentSnapshot.data() as Map<String, dynamic>?;

                        // Check if the fields exist in the data map
                        String email = data != null && data.containsKey("email")
                            ? data["email"]
                            : "Unknown email";
                        bool isDoctor =
                            data != null && data.containsKey("isAdmin")
                                ? data["isAdmin"]
                                : "is Nurse";

                        return Row(
                          children: [
                            const SizedBox(width: 13),
                            const SizedBox(height: 100),
                            Expanded(
                              child: Text(
                                email,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            const SizedBox(width: 35),
                            Expanded(
                              child: Text(
                                isDoctor.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );

                      },
                    );
                  } else {
                    return const Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
