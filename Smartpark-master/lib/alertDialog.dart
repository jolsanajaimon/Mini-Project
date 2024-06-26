import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smartpark/paymentP.dart';
import 'package:smartpark/paymentS.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:uuid/uuid.dart';
import 'const.dart';

class MyDialog extends StatefulWidget {
  final String vehicleNumber;
  final String mobileNumber;
  final String date;
  final String name;
  final String userId;
  final String vehicle;

  MyDialog({
    required this.vehicleNumber,
    required this.mobileNumber,
    required this.date,
    required this.name,
    required this.userId,
    required this.vehicle,
  });

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  String DialogStatus = '1';
  String randId = '';
  bool isFinished = false;
  bool isFinishedPro = false;
  @override
  void initState() {
    super.initState();
    checkLimitAvailability(widget.vehicle);
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void checkLimitAvailability(String vehicle) async {
    print(vehicle);
    String currentDateRef = widget.date;
    CollectionReference parentCollection = firestore.collection(currentDateRef);
    CollectionReference carParkingCollection =
        parentCollection.doc(vehicle + 'parking').collection(vehicle + 's');

    DocumentSnapshot carParkingSnapshot =
        await carParkingCollection.doc("limit").get();

    Map<String, dynamic>? data =
        carParkingSnapshot.data() as Map<String, dynamic>?;

    int limit = (data != null && data.containsKey('limit')) ? data['limit'] : 0;

    if (limit <= 1) {
      setState(() {
        DialogStatus = '2';
      });
    }
  }

  void checkLimitAvailabilityPro(String vehicle) async {
    print(vehicle);
    String currentDateRef = widget.date;
    CollectionReference parentCollection = firestore.collection(currentDateRef);
    CollectionReference carParkingCollection =
        parentCollection.doc(vehicle + 'pro').collection(vehicle + 's');

    DocumentSnapshot carParkingSnapshot =
        await carParkingCollection.doc("limit").get();

    Map<String, dynamic>? data =
        carParkingSnapshot.data() as Map<String, dynamic>?;

    int limit = (data != null && data.containsKey('limit')) ? data['limit'] : 0;

    if (limit <= 1) {
      setState(() {
        DialogStatus = '4';
      });
    } else {
      setState(() {
        DialogStatus = "3";
      });
    }
  }

  void onWaitingProcess() {
    if (widget.vehicle == "car") {
      addDataToSimCar();
    } else {
      addDataToSimBike();
    }
  }

  void onWaitingProcessPro() {
    if (widget.vehicle == "car") {
      addDataToSimCarPro();
    } else {
      addDataToSimBikePro();
    }

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isFinished = false;
      });
    });
  }

  void addDataToSimCar() async {
    final uuid = Uuid();
    final randomId = uuid.v4();
    setState(() {
      randId = randomId;
    });
    String currentDateRef = widget.date;
    CollectionReference parentCollection = firestore.collection(currentDateRef);
    CollectionReference carParkingCollection =
        parentCollection.doc('carparking').collection('cars');

    DocumentSnapshot carParkingSnapshot =
        await carParkingCollection.doc("limit").get();

    Map<String, dynamic>? data =
        carParkingSnapshot.data() as Map<String, dynamic>?;

    int limit = (data != null && data.containsKey('limit')) ? data['limit'] : 0;

    if (limit >= 1) {
      int sloti = 31 - limit;
      print(sloti);
      String slot = sloti.toString();
      print(randomId);
      CollectionReference SimCollection =
          firestore.collection("${widget.date}data");
      try {
        await SimCollection.doc(randomId).set({
          'vehicleNumber': widget.vehicleNumber,
          'mobileNumber': widget.mobileNumber,
          'date': widget.date,
          'name': widget.name,
          'slot': slot,
          'userId': widget.userId,
          'vehicle': widget.vehicle,
          'sucId': randomId,
        });
        // Data added successfully
        print('Data added to Firestore successfully');
        carParkingCollection.doc("limit").set({
          'limit': limit - 1,
        });
        setState(() {
          isFinished = true;
        });
      } catch (e) {
        // Error occurred while adding data
        print('Error adding data to Firestore: $e');
        // Show error message or take appropriate action
      }
    } else {
      setState(() {
        DialogStatus = "2";
      });
    }
  }

  //bike
  void addDataToSimBike() async {
    final uuid = Uuid();
    final randomId = uuid.v4();
    setState(() {
      randId = randomId;
    });
    String currentDateRef = widget.date;
    CollectionReference parentCollection = firestore.collection(currentDateRef);
    CollectionReference carParkingCollection =
        parentCollection.doc('bikeparking').collection('bikes');

    DocumentSnapshot carParkingSnapshot =
        await carParkingCollection.doc("limit").get();

    Map<String, dynamic>? data =
        carParkingSnapshot.data() as Map<String, dynamic>?;

    int limit = (data != null && data.containsKey('limit')) ? data['limit'] : 0;

    if (limit >= 1) {
      int sloti = 51 - limit;
      print(sloti);
      String slot = sloti.toString();
      print(randomId);
      CollectionReference SimCollection =
          firestore.collection("${widget.date}data");
      try {
        await SimCollection.doc(randomId).set({
          'vehicleNumber': widget.vehicleNumber,
          'mobileNumber': widget.mobileNumber,
          'date': widget.date,
          'name': widget.name,
          'slot': slot,
          'userId': widget.userId,
          'vehicle': widget.vehicle,
          'sucId': randomId,
        });
        // Data added successfully
        print('Data added to Firestore successfully');
        carParkingCollection.doc("limit").set({
          'limit': limit - 1,
        });
        setState(() {
          isFinished = true;
        });
      } catch (e) {
        // Error occurred while adding data
        print('Error adding data to Firestore: $e');
        // Show error message or take appropriate action
      }
    } else {
      setState(() {
        DialogStatus = "2";
      });
    }
  }

//Pro logic
  void addDataToSimCarPro() async {
    print("reched here");
    final uuid = Uuid();
    final randomId = uuid.v4();
    setState(() {
      randId = randomId;
    });
    String currentDateRef = widget.date;
    CollectionReference parentCollection = firestore.collection(currentDateRef);
    CollectionReference carParkingCollection =
        parentCollection.doc('carpro').collection('cars');

    DocumentSnapshot carParkingSnapshot =
        await carParkingCollection.doc("limit").get();

    Map<String, dynamic>? data =
        carParkingSnapshot.data() as Map<String, dynamic>?;

    int limit = (data != null && data.containsKey('limit')) ? data['limit'] : 0;

    if (limit >= 1) {
      int sloti = 11 - limit;
      print(sloti);
      String slot = sloti.toString();
      print(randomId);
      CollectionReference SimCollection =
          firestore.collection("${widget.date}data");
      try {
        await SimCollection.doc(randomId).set({
          'vehicleNumber': widget.vehicleNumber,
          'mobileNumber': widget.mobileNumber,
          'date': widget.date,
          'name': widget.name,
          'slot': slot,
          'userId': widget.userId,
          'vehicle': widget.vehicle,
          'sucId': randomId,
          'type': 'Pro'
        });
        // Data added successfully
        print('Data added to Firestore successfully');
        carParkingCollection.doc("limit").set({
          'limit': limit - 1,
        });
        setState(() {
          isFinishedPro = true;
        });
      } catch (e) {
        // Error occurred while adding data
        print('Error adding data to Firestore: $e');
        // Show error message or take appropriate action
      }
    } else {
      setState(() {
        DialogStatus = "4";
      });
    }
  }

  //bike
  void addDataToSimBikePro() async {
    print("reched here");
    final uuid = Uuid();
    final randomId = uuid.v4();
    setState(() {
      randId = randomId;
    });
    String currentDateRef = widget.date;
    CollectionReference parentCollection = firestore.collection(currentDateRef);
    CollectionReference carParkingCollection =
        parentCollection.doc('bikepro').collection('bikes');

    DocumentSnapshot carParkingSnapshot =
        await carParkingCollection.doc("limit").get();

    Map<String, dynamic>? data =
        carParkingSnapshot.data() as Map<String, dynamic>?;

    int limit = (data != null && data.containsKey('limit')) ? data['limit'] : 0;

    if (limit >= 1) {
      int sloti = 11 - limit;
      print(sloti);
      String slot = sloti.toString();
      print(randomId);
      CollectionReference SimCollection =
          firestore.collection("${widget.date}data");
      try {
        await SimCollection.doc(randomId).set({
          'vehicleNumber': widget.vehicleNumber,
          'mobileNumber': widget.mobileNumber,
          'date': widget.date,
          'name': widget.name,
          'slot': slot,
          'userId': widget.userId,
          'vehicle': widget.vehicle,
          'sucId': randomId,
          'type': 'Pro'
        });
        // Data added successfully
        print('Data added to Firestore successfully');
        carParkingCollection.doc("limit").set({
          'limit': limit - 1,
        });
        setState(() {
          isFinishedPro = true;
        });
      } catch (e) {
        // Error occurred while adding data
        print('Error adding data to Firestore: $e');
        // Show error message or take appropriate action
      }
    } else {
      setState(() {
        DialogStatus = "4";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (DialogStatus == "1") {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: kBackgroundColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Text(
                      'Parking is Available',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Date',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'Vehicle:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'Parking Fees:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'Processing Fees:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Total:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              widget.date,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              widget.vehicle,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              widget.vehicle == "bike" ? 'Rs 10' : 'Rs 30',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'Rs 0',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              widget.vehicle == "bike" ? 'Rs 10' : 'Rs 30',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Builder(
                      builder: (BuildContext context) {
                        return SwipeableButtonView(
                          isFinished: isFinished,
                          onFinish: () async {
                            print("success");
                            await Navigator.pushReplacement(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: PaymentSuccessfulPage(
                                  sucid: randId,
                                  date: widget.date,
                                ),
                              ),
                            );
                            setState(() {});
                          },
                          onWaitingProcess: onWaitingProcess,
                          activeColor: HexColor('1E1E1E', 1),
                          buttonWidget: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                          ),
                          buttonText: "Swipe to Pay",
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else if (DialogStatus == "2") {
      return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: kBackgroundColor,
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      Text(
                        'Sorry, Parking is Not Available',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 24,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          // Handle button press
                          setState(() {
                            checkLimitAvailabilityPro(widget.vehicle);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Try Premium Parking',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: kgold,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ])));
      // Return an empty SizedBox if the condition is not met
    } else if (DialogStatus == "3") {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: kBackgroundColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Text(
                      'Premium Parking is Available',
                      style: TextStyle(
                        color: kgold,
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Date',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'Vehicle:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'Parking Fees:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'Processing Fees:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Total:',
                              style: TextStyle(
                                color: kgold,
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              widget.date,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              widget.vehicle,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              widget.vehicle == "bike" ? 'Rs 10' : 'Rs 30',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'Rs 0',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              widget.vehicle == "bike" ? 'Rs 30' : 'Rs 50',
                              style: TextStyle(
                                color: kgold,
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Builder(
                      builder: (BuildContext context) {
                        return SwipeableButtonView(
                          isFinished: isFinishedPro,
                          onFinish: () async {
                            print("success");
                            await Navigator.pushReplacement(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: PaymentSuccessfulPagePro(
                                  sucid: randId,
                                  date: widget.date,
                                ),
                              ),
                            );
                            setState(() {
                              isFinishedPro = false;
                            });
                          },
                          onWaitingProcess: onWaitingProcessPro,
                          activeColor: kgold,
                          buttonColor: kBackgroundColor,
                          buttonWidget: Icon(
                            Icons.arrow_forward_ios,
                            color: kgold,
                          ),
                          buttonText: "Swipe to Pay",
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: kBackgroundColor,
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'Sorry,\nPremium Parking is Not Available',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 24,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                )
              ])));
    }
  }
}
