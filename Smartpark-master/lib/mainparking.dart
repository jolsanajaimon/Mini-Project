import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartpark/const.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartpark/paymentS.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smartpark/showTickets.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:calender_picker/calender_picker.dart';
import 'alertDialog.dart';

class MainParking extends StatefulWidget {
  const MainParking({super.key});

  @override
  State<MainParking> createState() => _MainParkingState();
}

class _MainParkingState extends State<MainParking> {
  bool isLoading = false;
  //Basic items
  int selectedChipIndex = 0;
  DateTime now = DateTime.now();
  DateTime _selectedValue = DateTime.now();
  String getFormattedDate() {
    DateTime now = DateTime.now();

    DateTime selectedDate = DateTime.now();

    if (selectedChipIndex == 0) {
      return "${now.day} ${_getMonthName(now.month)} ${now.year}";
    } else {
      DateTime tomorrow = now.add(Duration(days: 1));
      return "${tomorrow.day} ${_getMonthName(tomorrow.month)} ${tomorrow.year}";
    }
  }

  DateTime selectedDate = DateTime.now();
  bool isFinished = false;

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

  String selectedVehicle = '';

  //data absorb
  TextEditingController vehicle_number_controller = new TextEditingController();

  TextEditingController mobile_number_controller = new TextEditingController();
  TextEditingController name_number_controller = new TextEditingController();

  void selectVehicle(String vehicle) {
    setState(() {
      selectedVehicle = vehicle;
    });
  }

  //Logic Block Starts here

  //car logic block
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void createCollections(String currentDateRef) async {
    setState(() {
      isLoading = true;
    });
    String vehicleNumber = vehicle_number_controller.text;
    String mobileNumber = mobile_number_controller.text;
    String name = name_number_controller.text;

    User? user = FirebaseAuth.instance.currentUser;
    String? userId;

    if (user != null) {
      userId = user.uid;
      print('User ID: $userId');
    } else {
      print('User is not logged in');
    }
    String date = currentDateRef;
    String vehicle = selectedVehicle;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create the parent collection "20 June 2023"
    CollectionReference parentCollection = firestore.collection(currentDateRef);
    CollectionReference SimCollection =
        firestore.collection(currentDateRef + "data");
    // Create the collections under the parent collection
    CollectionReference carParkingCollection =
        parentCollection.doc('carparking').collection('cars');
    CollectionReference bikeParkingCollection =
        parentCollection.doc('bikeparking').collection('bikes');
    CollectionReference carProCollection =
        parentCollection.doc('carpro').collection('cars');
    CollectionReference bikeProCollection =
        parentCollection.doc('bikepro').collection('bikes');

    // Check if collections exist
    bool carParkingExists = await carParkingCollection
        .limit(1)
        .get()
        .then((snapshot) => snapshot.size > 0);
    bool bikeParkingExists = await bikeParkingCollection
        .limit(1)
        .get()
        .then((snapshot) => snapshot.size > 0);
    bool carProExists = await carProCollection
        .limit(1)
        .get()
        .then((snapshot) => snapshot.size > 0);
    bool bikeProExists = await bikeProCollection
        .limit(1)
        .get()
        .then((snapshot) => snapshot.size > 0);

    // Print if collections exist
    if (carParkingExists ||
        bikeParkingExists ||
        carProExists ||
        bikeProExists) {
      print("They exist");
    } else {
      // Add documents with value set to "available" and reference to current date

      carParkingCollection.doc("limit").set({
        'limit': 30,
      });
      bikeParkingCollection.doc("limit").set({
        'limit': 50,
      });
      carProCollection.doc("limit").set({
        'limit': 10,
      });
      bikeProCollection.doc("limit").set({
        'limit': 10,
      });
    }
    setState(() {
      isLoading = false;
    });
    // ignore: use_build_context_synchronously
    showDialogFunction(
        context: context,
        vehicleNumber,
        mobileNumber,
        date,
        name,
        userId ?? "userId",
        vehicle);
  }

  //Logic Block Ends Here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    color: kPrimaryColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'HI, welcome to samrtpark',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'The MBITS Parking Assisstant',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 45),
                          child: Text(
                            'Choose your vehicle',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 150,
                              child: ElevatedButton(
                                onPressed: () {
                                  selectVehicle('car');
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(width: 1.0),
                                  ),
                                  primary: selectedVehicle == 'car'
                                      ? Color.fromARGB(255, 234, 234, 234)
                                      : null,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/9.svg', // Replace with your SVG file path
                                          width:
                                              60, // Adjust the width as needed
                                          height:
                                              60, // Adjust the height as needed
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Container(
                              height: 150,
                              child: ElevatedButton(
                                onPressed: () {
                                  selectVehicle('bike');
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(width: 1.0),
                                  ),
                                  primary: selectedVehicle == 'bike'
                                      ? Color.fromARGB(255, 234, 234, 234)
                                      : null,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(35.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/8.svg', // Replace with your SVG file path
                                          width:
                                              70, // Adjust the width as needed
                                          height:
                                              70, // Adjust the height as needed
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ChipBuilder(
                              label: 'Today',
                              isSelected: selectedChipIndex == 0,
                              onSelected: (isSelected) {
                                setState(() {
                                  selectedChipIndex = isSelected ? 0 : -1;
                                });
                              },
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            ChipBuilder(
                              label: 'Tomorrow',
                              isSelected: selectedChipIndex == 1,
                              onSelected: (isSelected) {
                                setState(() {
                                  selectedChipIndex = isSelected ? 1 : -1;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          getFormattedDate(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: kPrimaryColor),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                              ],
                              textCapitalization: TextCapitalization.characters,
                              controller: vehicle_number_controller,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "  Enter Vehicle Number",
                                  hintStyle: TextStyle(color: Colors.white),
                                  prefixStyle: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: kPrimaryColor),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              controller: name_number_controller,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "  Enter Name",
                                  hintStyle: TextStyle(color: Colors.white),
                                  prefixStyle: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: kPrimaryColor),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              keyboardType: TextInputType.phone,
                              controller: mobile_number_controller,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                  hintText: "  Enter mobile number",
                                  prefix: Text(
                                    "+91  ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.white),
                                  prefixStyle: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: ElevatedButton(
                              onPressed: () {
                                if (vehicle_number_controller.text.isEmpty ||
                                    mobile_number_controller.text.isEmpty ||
                                    name_number_controller.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Fields should not be empty'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } else {
                                  createCollections(getFormattedDate());

                                  if (selectedVehicle == "car")
                                    ;
                                  //checkAvailabilityCar(getFormattedDate());
                                  else {
                                    //  checkAvailabilityBike(getFormattedDate());
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.yellow,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: kBackgroundColor,
                                      ),
                                    )
                                  : Text('Check Availability'),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ShowTickets()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Text('View Your Tickets'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showDialogFunction(String vehicleNumber, String mobileNumber, String date,
    String name, String userId, String vehicle,
    {required BuildContext context}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (
      BuildContext context,
    ) {
      return MyDialog(
        vehicleNumber: vehicleNumber,
        mobileNumber: mobileNumber,
        date: date,
        name: name,
        userId: userId,
        vehicle: vehicle,
      );
    },
  );
}
