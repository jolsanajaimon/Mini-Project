import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartpark/const.dart';
import 'package:audioplayers/audioplayers.dart';

import 'mainparking.dart';

class MyData {
  String vehicleNumber;
  String mobileNumber;
  String date;
  String name;
  String userId;
  String vehicle;
  String sucId;
  String slot;

  MyData({
    required this.vehicleNumber,
    required this.mobileNumber,
    required this.date,
    required this.name,
    required this.userId,
    required this.vehicle,
    required this.slot,
    required this.sucId,
  });

  factory MyData.fromJson(Map<String, dynamic> json) {
    return MyData(
      vehicleNumber: json['vehicleNumber'],
      mobileNumber: json['mobileNumber'],
      date: json['date'],
      name: json['name'],
      userId: json['userId'],
      vehicle: json['vehicle'],
      slot: json['slot'],
      sucId: json['sucId'],
    );
  }
}

class PaymentSuccessfulPage extends StatefulWidget {
  final String sucid;
  final String date;

  PaymentSuccessfulPage({required this.sucid, required this.date});

  @override
  _PaymentSuccessfulPageState createState() => _PaymentSuccessfulPageState();
}

class _PaymentSuccessfulPageState extends State<PaymentSuccessfulPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    // Start the animation
    _animationController.forward();

    // Play the audio when the page is opened
    fetchData();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  // Get data ticket
  String vehicleNumber = '';
  String slot = '';
  String date = '';
  String vehicle = '';

  void fetchData() async {
    String randomId = widget.sucid;

    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("${widget.date}data")
          .doc(randomId)
          .get();

      if (documentSnapshot.exists) {
        setState(() {
          MyData myData =
              MyData.fromJson(documentSnapshot.data() as Map<String, dynamic>);

          // Access the fetched data here
          vehicleNumber = myData.vehicleNumber;
          slot = myData.slot;
          date = myData.date;
          vehicle = myData.vehicle;

          print(vehicleNumber);
        });
      } else {
        // Document with the specified random ID does not exist
      }
    } catch (e) {
      // Handle any errors that occur during the data retrieval
      print('Error retrieving data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                alignment: Alignment.center,
                child: Image.asset('assets/images/c.png'),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                alignment: Alignment.center,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: _animation.value * 120.0,
                    );
                  },
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 24.0),
                    Text(
                      'Payment Successful',
                      style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Thank you for your payment!',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  children: [
                    Text(
                      'Your Ticket',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kPrimaryColor,
                      ),
                      child: Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                'Slot Number',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                slot,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 70,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                date,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                vehicle,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w800),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                vehicleNumber,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 35,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 28.0),
              ElevatedButton(
                onPressed: () {
                  // Handle button press
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainParking()),
                  );
                },
                child: Text(
                  'Go to Home',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  primary: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
              ),
              SizedBox(height: 28.0),
            ],
          ),
        ),
      ),
    );
  }
}
