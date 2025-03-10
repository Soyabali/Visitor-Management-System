import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import '../../app/generalFunction.dart';
import '../resources/app_text_style.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VisitorDashboard extends StatelessWidget {
  const VisitorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VisitorDashboardPage(),
    );
  }
}

class VisitorDashboardPage extends StatefulWidget {
  const VisitorDashboardPage({super.key});

  @override
  State<VisitorDashboardPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<VisitorDashboardPage> {
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isObscured = true;
  var loginProvider;

  // focus
  FocusNode phoneNumberfocus = FocusNode();
  FocusNode passWordfocus = FocusNode();

  bool passwordVisible = false;
  // Visible and Unvisble value
  int selectedId = 0;
  var msg;
  var result;
  var loginMap;
  double? lat, long;
  GeneralFunction generalFunction = GeneralFunction();

  void getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    debugPrint("-------------Position-----------------");
    debugPrint(position.latitude.toString());

    lat = position.latitude;
    long = position.longitude;
    print('-----------105----$lat');
    print('-----------106----$long');
    // setState(() {
    // });
    debugPrint("Latitude: ----1056--- $lat and Longitude: $long");
    debugPrint(position.toString());
  }

  turnOnLocationMsg() {
    if ((lat == null && lat == '') || (long == null && long == '')) {
      displayToast("Please turn on Location");
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
        title: Text(
          'Are you sure?',
          style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
        ),
        content: new Text(
          'Do you want to exit app',
          style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
        ),
        actions: <Widget>[
          TextButton(
            onPressed:
                () => Navigator.of(context).pop(false), //<-- SEE HERE
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () {
              //  goToHomePage();
              // exit the app
              exit(0);
            }, //Navigator.of(context).pop(true), // <-- SEE HERE
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    if (lat == null || lat == '') {
      turnOnLocationMsg();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  void clearText() {
    _phoneNumberController.clear();
    passwordController.clear();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Hide keyboard
        },
        child: Stack(
          children: [
            // Full-screen background image
            Positioned(
              top: 0, // Start from the top
              left: 0,
              right: 0,
              height:
              MediaQuery.of(context).size.height *
                  0.7, // 70% of screen height
              child: Image.asset(
                'assets/images/bg.png', // Replace with your image path
                fit: BoxFit.cover, // Covers the area properly
              ),
            ),
            Positioned(
                top: 70,
                left: 20,
                child: GestureDetector(
                  onTap: () {
                   // Navigator.pop(context); // Navigates back when tapped
                  },
                  child: Image.asset("assets/images/backtop.png")
                  // child: Container(
                  //   width: 60,
                  //   height: 40,
                  //   decoration: BoxDecoration(
                  //     color: Colors.grey[200], // Light grey background
                  //     borderRadius: const BorderRadius.only(
                  //       topLeft: Radius.circular(15),
                  //       bottomLeft: Radius.circular(15),
                  //       topRight: Radius.circular(15),
                  //       bottomRight: Radius.circular(15),
                  //     ),
                  //   ),
                  //   child: const Center(
                  //     child: Icon(
                  //       Icons.arrow_back_ios_new, // iOS-style back arrow
                  //       color: Colors.black, // Change color as needed
                  //       size: 25, // Adjust size as per need
                  //       weight: 800,
                  //     ),
                  //   ),
                  // ),

                )
            ),
            // Top image (height: 80, margin top: 20)
            Positioned(
              top: 100,
              left: 35,
              right: 35,
              child: Center(
                child: Image.asset(
                  'assets/images/dashboardupper.png', // Replace with your image path
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              top: 340,
              left: 15,
              right: 15,
              child: Card(
                   elevation: 5,
                child: Container(
                    //color: Colors.transparent,
                    height: 325, // Fixed height
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/tcontainer.png'), // Your image path
                        fit: BoxFit.cover, // Adjust how the image fits
                      ),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Container(
                            width: double.infinity, // Full width
                            height: 35, // Fixed height
                            decoration: BoxDecoration(
                              color: Color(0xFFC9EAFE), // Background color
                              borderRadius: BorderRadius.circular(
                                8,
                              ), // Rounded border radius 17
                            ),
                            alignment:
                            Alignment
                                .center, // Centers text inside the container
                            child: const Material(
                              color: Colors.transparent,
                              child: Text(
                                "Visitor Detail",
                                style: TextStyle(
                                  color: Colors.black45, // Text color
                                  fontSize: 16, // Font size
                                  fontWeight: FontWeight.bold, // Bold text
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black12, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.all(10),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Image.asset(
                                      'assets/images/entry.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black12, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.all(10),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Image.asset(
                                      'assets/images/exit.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 5),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Material(
                                color: Colors.transparent,
                                child: Text("Entry",style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14
                                ),),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Material(
                                    color: Colors.transparent,
                                    child: Text("Exit",style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14
                                    ),),
                                  )

                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black12, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.all(10),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Image.asset(
                                      'assets/images/report.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black12, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.all(10),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Image.asset(
                                      'assets/images/setting.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 5),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Material(
                                color: Colors.transparent,
                                child: Text("Report",style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14
                                ),),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Material(
                                    color: Colors.transparent,
                                    child: Text("Setting",style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14
                                    ),),
                                  )

                                ],
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
              ),
              ),
            Positioned(
              left: 75, // Maintain same left padding
              right: 75, // Maintain same right padding
              bottom: 5, // Set distance from bottom
              child: Padding(
                padding: const EdgeInsets.only(left: 13, right: 13),
                child: Container(
                  // width: MediaQuery.of(context).size.width-50,
                  child: Image.asset('assets/images/companylogo.png', // Replace with your image path
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// toast code
void displayToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
