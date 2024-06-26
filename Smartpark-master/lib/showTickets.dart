import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartpark/const.dart';

import 'mainparking.dart';

class ShowTickets extends StatefulWidget {
  const ShowTickets({Key? key}) : super(key: key);

  @override
  State<ShowTickets> createState() => _ShowTicketsState();
}

class _ShowTicketsState extends State<ShowTickets> {
  int selectedChipIndex = 0;
  DateTime now = DateTime.now();
  late String userId = '';

  @override
  void initState() {
    super.initState();
    retrieveUserId();
  }

  void retrieveUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid.toString();
      });
    } else {
      // User is not authenticated, handle the case accordingly
    }
  }

  String getFormattedDate() {
    DateTime now = DateTime.now();

    if (selectedChipIndex == 0) {
      return "${now.day} ${_getMonthName(now.month)} ${now.year}";
    } else {
      DateTime tomorrow = now.add(Duration(days: 1));
      return "${tomorrow.day} ${_getMonthName(tomorrow.month)} ${tomorrow.year}";
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference simCollection =
        FirebaseFirestore.instance.collection("${getFormattedDate()}data");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kPrimaryColor,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainParking()),
            );
          },
        ),
        title: Text(
          'Your Tickets',
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Container(
        color: kBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChipBuilder(
                    label: 'Today',
                    isSelected: selectedChipIndex == 0,
                    onSelected: (isSelected) {
                      if (isSelected) {
                        setState(() {
                          selectedChipIndex = 0;
                        });
                      }
                    },
                  ),
                  SizedBox(width: 15),
                  ChipBuilder(
                    label: 'Tomorrow',
                    isSelected: selectedChipIndex == 1,
                    onSelected: (isSelected) {
                      if (isSelected) {
                        setState(() {
                          selectedChipIndex = 1;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: simCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data =
                          documents[index].data() as Map<String, dynamic>;

                      String slotNumber = data['slot'] ?? "0";
                      String date = data['date'] ?? "today";
                      String vehicle = data['vehicle'] ?? "Vehicle";
                      String vehicleNumber =
                          data['vehicleNumber'] ?? "KL00AA0000";
                      String type = data["type"] ?? "normal";

                      if (data['userId'] == userId) {
                        return Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:
                                  data['type'] == 'Pro' ? kgold : kPrimaryColor,
                            ),
                            child: Column(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 20,
                                    ),
                                    child: Text(
                                      data['type'] == 'Pro'
                                          ? 'Premium'
                                          : 'Standard',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      'Slot Number',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      slotNumber,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 70,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      date,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      vehicle,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      vehicleNumber,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 35),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
