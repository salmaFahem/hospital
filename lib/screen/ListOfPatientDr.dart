import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospital/screen/listOfUsers.dart';
import 'package:hospital/screen/signin.dart';
import 'fichePatientDr.dart';
import 'fichePatientNurse.dart';

class ListOfPatientDr extends StatefulWidget {
  const ListOfPatientDr({Key? key}) : super(key: key);

  @override
  State<ListOfPatientDr> createState() => _ListOfPatientDrState();
}

class _ListOfPatientDrState extends State<ListOfPatientDr> {
  final patientNameController = TextEditingController();
  final ageController = TextEditingController();
  final noteController = TextEditingController();
  final cinController = TextEditingController();
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
        title: const Text('List of patients'),
      ),
      drawer: Drawer(
          child: StreamBuilder(
            stream: fireStorenstance
                .collection("users")
                .doc(fireBaseInstance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print("${snapshot.data}");
                  return ListView(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.account_circle_outlined),
                        title: Text("Dr space"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                FichePatient(patientData: {},)),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.list),
                        title: Text("List of users"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ListOfUsers()),
                          );
                        },
                      )
                    ],
                  );
              } else {
                return const CircularProgressIndicator();
              }
            },
          )),
      body: Container(
        height: 1000,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        textDirection: TextDirection.ltr,
                        children: [
                          SizedBox(width: 0),
                          Expanded(
                            child: Text(
                              "CIN",
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
                              "Resident Nom",
                              style: TextStyle(
                                color: Colors.black,
                                // Set the text color to white
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(width: 40),
                          Expanded(
                            child: Text(
                              "Age",
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
                              "Note Dr",
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
                stream: fireStorenstance.collection('MyPatients').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                        Map<String, dynamic>? data =
                        documentSnapshot.data() as Map<String, dynamic>?;

                        // Check if the fields exist in the data map
                        String cin =
                        data != null && data.containsKey("cin")
                            ? data["cin"]
                            : "Unknown cin";
                        String patientName =
                        data != null && data.containsKey("patientName")
                            ? data["patientName"]
                            : "Unknown Patient Name";
                        String age = data != null && data.containsKey("age")
                            ? data["age"]
                            : "Unknown Age";
                        String noteDr =
                        data != null && data.containsKey("noteDr")
                            ? data["noteDr"]
                            : "Unknown Note Dr";


                        return GestureDetector(
                            onTap: () {
                              if (data != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FichePatient(
                                      patientData: data, // Pass the patient data
                                    ),
                                  ),
                                );
                              }
                            },
                        child: Row(
                          children: [

                            const SizedBox(width: 0),
                            Expanded(
                                child: Text(
                                  cin,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    // Set the text color to white
                                    fontSize: 17,
                                  ),
                                )),
                            const SizedBox(width: 7),
                            Expanded(
                                child: Text(
                                  patientName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    // Set the text color to white
                                    fontSize: 17,
                                  ),
                                )),
                            const SizedBox(width: 40),
                            const SizedBox(height: 100),
                            Expanded(
                                child: Text(
                                  age,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    // Set the text color to white
                                    fontSize: 17,
                                  ),
                                )),
                            const SizedBox(width: 0),
                            Expanded(
                                child: Text(
                                  noteDr,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    // Set the text color to white
                                    fontSize: 17,
                                  ),
                                )),
                          ],
                        ));
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
