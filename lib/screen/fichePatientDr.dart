import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hospital/screen/signin.dart';
import '../component/textfeild.dart';

class FichePatient extends StatefulWidget {
  final Map<String, dynamic> patientData; // Receive the patient data

  FichePatient({Key? key, required this.patientData}) : super(key: key);

  @override
  State<FichePatient> createState() => _FichePatientState();
}

class _FichePatientState extends State<FichePatient> {
  String selectedDeviceOption = 'D1';
  final patientNameController = TextEditingController();
  final ageController = TextEditingController();
  final noteController = TextEditingController();
  final cinController = TextEditingController();


  editData() async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("MyPatients")
        .doc(patientNameController.text);

    Map<String, dynamic> updatedData = {
      "noteDr": noteController.text,
    };

    try {
      await documentReference.update(updatedData);
      print("${patientNameController.text}'s note updated");
    } catch (error) {
      print("Error updating note: $error");
    }
  }

  deleteData () {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("MyPatients")
        .doc(patientNameController.text);
    documentReference.delete().whenComplete(() => print("$patientNameController deleted"));
  }

  String retrievedDevice = ""; // Declare a variable to store the retrieved device


  void readData() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("MyPatients")
        .doc(patientNameController.text);

    documentReference.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        Map<String, dynamic>? data = datasnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          setState(() {
            // Update the controller values with retrieved data
            cinController.text = data["cin"];
            patientNameController.text = data["patientName"];
            ageController.text = data["age"];
            retrievedDevice = data["deviceNumber"];
            selectedDeviceOption = retrievedDevice;
            noteController.text = data["noteDr"] ?? ""; // Use empty string if note doesn't exist

            // Update real-time values
            updateRealTimeValues(selectedDeviceOption);
          });
        } else {
          print("Document data is null.");
        }
      } else {
        print("Document does not exist.");
      }
    });
  }



  void signUserOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print("User signed out successfully");

      // Navigate to the login screen after sign-out and replace the current route
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login(onTap: () {  },)),
      );
    } catch (e) {
      print("Error signing out: $e");
    }
  }


  List<DropdownMenuItem<String>> deviceOptions = [
    DropdownMenuItem(value: 'D1', child: Text('D1')),
    DropdownMenuItem(value: 'D2', child: Text('D2')),
    DropdownMenuItem(value: 'D3', child: Text('D3')),
    DropdownMenuItem(value: 'D4', child: Text('D4')),
  ];




  String temp = "";
  String heartBeat = "";
  String oxygen = "";
  String situation = "";

  @override
  void initState() {
    super.initState();
    if (widget.patientData.isNotEmpty) { // Check if patient data is not empty
      // Update the text fields with patient data
      patientNameController.text = widget.patientData["patientName"] ?? "";
      ageController.text = widget.patientData["age"] ?? "";
      cinController.text = widget.patientData["cin"] ?? "";
      selectedDeviceOption = widget.patientData["deviceNumber"] ?? "D1";
      noteController.text = widget.patientData["noteDr"] ?? "";
      updateRealTimeValues(selectedDeviceOption);
    }
  }

  void updateRealTimeValues(String deviceOption) {
    DatabaseReference databaseRef = FirebaseDatabase.instance.ref().child(deviceOption);

    databaseRef.child('temperature').onValue.listen((event) {
      setState(() {
        temp = event.snapshot.value.toString();
      });
    });

    databaseRef.child('heart').onValue.listen((event) {
      setState(() {
        heartBeat = event.snapshot.value.toString();
      });
    });

    databaseRef.child('oxygen').onValue.listen((event) {
      setState(() {
        oxygen = event.snapshot.value.toString();
      });
    });

    databaseRef.child('situation').onValue.listen((event) {
      setState(() {
        situation = event.snapshot.value.toString();
      });
    });
  }



  Widget build(BuildContext context) {

    Color backgroundColor = Color(
        0xFF7E8BB9); //Convert the hexadecimal color value to a Color object


    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: const Text('Fiche patient'),
        actions: [
          IconButton(
              onPressed: signUserOut,
              icon: Icon(Icons.logout, color: Colors.white))
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text fields on the left
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(height: 0),
                          Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            IconButton(
                              onPressed: () {
                                editData();
                              },
                              icon: Icon(Icons.edit, color: Colors.white),),

                            IconButton(
                              onPressed: () {
                                deleteData();
                              },
                              icon: Icon(Icons.delete, color: Colors.white),),


                            IconButton(
                              onPressed: () {
                                readData();
                              },
                              icon: Icon(Icons.search, color: Colors.white),),

                            ],
                          ),

                            const SizedBox(height: 0),
                            MyTextField(
                              controller: cinController,
                              hintText: 'CIN',
                              obscureText: false,
                              maxLines: 1,
                            ),

                            const SizedBox(height: 4),
                            MyTextField(
                              controller: patientNameController,
                              hintText: ' Resident Nom',
                              obscureText: false,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 4),
                            MyTextField(
                              controller: ageController,
                              hintText: 'Age',
                              obscureText: false,
                              maxLines: 1,
                            ),

                            DropdownButton<String>(
                              value: selectedDeviceOption,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedDeviceOption = newValue!;
                                  updateRealTimeValues(selectedDeviceOption); // Update real-time values
                                });
                              },
                              items: deviceOptions,
                              style: TextStyle(color: Colors.black), // Change text color
                            ),


                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 400,
                                color: Colors.grey.shade200,
                                child: Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(1),
                                    1: FlexColumnWidth(1),
                                  },
                                  border: TableBorder.all(color: Colors.grey.shade200),
                                  children: [
                                    _buildTableRow('Temperature', '$temp' + '°C'),
                                    _buildTableRow('Heart beat', '$heartBeat' + ' BPM'),
                                    _buildTableRow('Oxygen', '$oxygen' + ' %'),
                                    _buildTableRow('Situation', '$situation'),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 4),
                            MyTextField(
                              controller: noteController,
                              hintText: 'Dr note..',
                              obscureText: false,
                              maxLines: null,
                            ),


                          ],
                        ),
                      ),
                    ),
                  ]
          )),
        ),
      ),
    );
  }
}

TableRow _buildTableRow(String deviceName, String value) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          deviceName,
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          value,
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
      )
    ],
  );
}
