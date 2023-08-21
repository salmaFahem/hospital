import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hospital/screen/signin.dart';
import '../component/textfeild.dart';


class FichePatientNurse extends StatefulWidget {

  FichePatientNurse({Key? key}) : super(key: key);

  @override
  State<FichePatientNurse> createState() => _FichePatientNurseState();
}

class _FichePatientNurseState extends State<FichePatientNurse> {

  String selectedDeviceOption = 'D1'; // Set an initial value
  final patientNameController = TextEditingController();
  final ageController = TextEditingController();
  final noteController = TextEditingController();


  createData() {
    print("created");
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("MyPatients")
        .doc(patientNameController.text);

    Map<String, dynamic> patients = {
      "patientName": patientNameController.text,
      "age": ageController.text,
      "noteDr": noteController.text,
      "deviceNumber": selectedDeviceOption,
    };

    documentReference.set(patients).whenComplete(() {
      print("${patientNameController.text} created");
    }).onError((e, _) => print("Error writing document: $e"));
  }

  void editData() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("MyPatients")
        .doc(patientNameController.text);

    Map<String, dynamic> updatedData = {
      "patientName": patientNameController.text,
      "age": ageController.text,
      "deviceNumber": selectedDeviceOption,
    };

    documentReference.update(updatedData).then((_) {
      print("${patientNameController.text} updated");
    }).catchError((error) {
      print("Error updating document: $error");
    });
  }


  deleteData () {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("MyPatients")
        .doc(patientNameController.text);
    documentReference.delete().whenComplete(() => print("$patientNameController deleted"));
  }

  String retrievedDevice = "";
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
            patientNameController.text = data["patientName"];
            ageController.text = data["age"];
            retrievedDevice = data["deviceNumber"];
            selectedDeviceOption = retrievedDevice;
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
  Widget build(BuildContext context) {

    final DatabaseReference databaseRefCapTemp =
    FirebaseDatabase.instance.ref().child(retrievedDevice).child('temperature');
    databaseRefCapTemp.onValue.listen((event) {
      setState(() {
        temp = event.snapshot.value.toString();
      });
    });

    final DatabaseReference databaseRefCapHeart =
    FirebaseDatabase.instance.ref().child(retrievedDevice).child('heart');
    databaseRefCapHeart.onValue.listen((event) {
      setState(() {
        heartBeat = event.snapshot.value.toString();
      });
    });

    final DatabaseReference databaseRefCapOxygen =
    FirebaseDatabase.instance.ref().child(retrievedDevice).child('oxygen');
    databaseRefCapOxygen.onValue.listen((event) {
      setState(() {
        oxygen = event.snapshot.value.toString();
      });
    });

    final DatabaseReference databaseRefCapSituation =
    FirebaseDatabase.instance.ref().child(retrievedDevice).child('situation');
    databaseRefCapSituation.onValue.listen((event) {
      setState(() {
        situation = event.snapshot.value.toString();
      });
    });

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
                                    createData();
                                  },
                                  icon: Icon(Icons.add, color: Colors.white),
                                ),


                                IconButton(
                                  onPressed: () {
                                    readData();
                                  },
                                  icon: Icon(Icons.person, color: Colors.white),),

                              ],
                            ),


                            const SizedBox(height: 0),
                            MyTextField(
                              controller: patientNameController,
                              hintText: 'Patient Name',
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
                                    _buildTableRow('Temperature ', '$temp' + '°C'),
                                    _buildTableRow('Heart beat ',"$heartBeat" + " PBM"),
                                    _buildTableRow('oxygen ',"$oxygen" + " %"),
                                    _buildTableRow('situation ',"$situation" + " ")
                                  ],
                                ),
                              ),
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