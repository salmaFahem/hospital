import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hospital/screen/signin.dart';
import 'fichePatientDr.dart';
import 'fichePatientNurse.dart';

class ListOfPatients extends StatefulWidget {
  const ListOfPatients({Key? key}) : super(key: key);

  @override
  State<ListOfPatients> createState() => _ListOfPatientsState();
}

class _ListOfPatientsState extends State<ListOfPatients> {

  final patientNameController = TextEditingController();
  final ageController = TextEditingController();
  final noteController = TextEditingController();

  deleteData (String patientName) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("MyPatients")
        .doc(patientNameController.text);
    documentReference.delete().whenComplete(() => print("$patientNameController deleted"));
  }

  editData () {
    print("edited");
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("MyPatients")
        .doc(patientNameController.text);

    Map<String, dynamic> patients = {
      "patientName": patientNameController.text,
      "age": ageController.text,
      "noteDr": noteController.text,
    };

    documentReference.set(patients).whenComplete(() {
      print("${patientNameController.text} created");
    }).onError((e, _) => print("Error writing document: $e"));
  }


  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color(
        0xFF7E8BB9); //Convert the hexadecimal color value to a Color object
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: const Text('List of patients'),

      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.account_circle_outlined),
              title: Text("Dr space"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FichePatient()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.accessible_outlined),
              title: Text("Nurse space"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FichePatientNurse()),
                );
              },
            ),
          ],
        ),
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

                        const SizedBox(width: 0),
                        Expanded(
                          child: Text("Patient name",
                            style: TextStyle(
                              color: Colors.black, // Set the text color to white
                              fontSize: 15,),),
                        ),

                        const SizedBox(width: 40),
                        Expanded(
                          child: Text("age",
                            style: TextStyle(
                              color: Colors.black, // Set the text color to white
                              fontSize: 15,),),
                        ),

                        const SizedBox(width: 0),
                        Expanded(
                          child: Text("Note Dr",
                            style: TextStyle(
                              color: Colors.black, // Set the text color to white
                              fontSize: 15,),),
                        ),
                      ],
                    ),
                  ],
                  ),
                ),
              ),

              const SizedBox(height: 4),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('MyPatients').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                        Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;

                        // Check if the fields exist in the data map
                        String patientName = data != null && data.containsKey("patientName")
                            ? data["patientName"]
                            : "Unknown Patient Name";
                        String age = data != null && data.containsKey("age")
                            ? data["age"]
                            : "Unknown Age";
                        String noteDr = data != null && data.containsKey("noteDr")
                            ? data["noteDr"]
                            : "Unknown Note Dr";


                        return Row(
                            children: [
                              const SizedBox(width: 7),
                              Expanded(child: Text(patientName,style: const TextStyle(
                                color: Colors.white, // Set the text color to white
                                fontSize: 17,),)),


                              const SizedBox(width: 40),
                              const SizedBox(height: 100),


                              Expanded(child: Text(age,style: const TextStyle(
                                color: Colors.white, // Set the text color to white
                                fontSize: 17,),)),

                              const SizedBox(width: 0),
                              Expanded(child: Text(noteDr,style: const TextStyle(
                                color: Colors.white, // Set the text color to white
                                fontSize: 17,),)),

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
