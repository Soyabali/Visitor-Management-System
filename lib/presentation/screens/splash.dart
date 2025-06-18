import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/verifyAppVersion.dart';
import '../../testNotification.dart';
import '../complaints/complaintHomePage.dart';
import '../login/loginScreen_2.dart';
import '../loginaftersplace/loginaftersplace.dart';
import '../visitorDashboard/visitorDashBoard.dart';
import '../vmsHome/vmsHome.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplaceState();
}

class _SplaceState extends State<SplashView> {

  bool activeConnection = false;
  String T = "";
  var result, msg;

  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          activeConnection = true;
          T = "Turn off the data and repress again";
          versionAliCall();
          //displayToast(T);
        });
      }
    } on SocketException catch (_) {
      setState(() {
        activeConnection = false;
        T = "Turn On the data and repress again";
        displayToast(T);
      });
    }
  }

  String? _appVersion;

  // get app Version

  //url
  void _launchGooglePlayStore() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.instagram.android&hl=en_IN&gl=US'; // Replace <YOUR_APP_ID> with your app's package name
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //
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

  @override
  void initState() {
    // TODO: implement initState
   // checkForNotification();
    Future.delayed(const Duration(seconds: 1), () {
      checkUserConnection();
    });

    // versionAliCall();
    //getlocalDataBaseValue();
    print('---------xx--xxxxxx-------');
    super.initState();
  }

  //
  getlocalDataBaseValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sContactNo = prefs.getString('sContactNo');
    print('----TOKEN---87---$sContactNo');
    if (sContactNo != null && sContactNo != '') {

      print('-----89---Visitor DashBoard');

      context.go('/VisitorDashboard');

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => VisitorDashboard()),
      // );

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => VisitorDashboard()),
      // );
    } else {
      context.go('/Loginaftersplace');
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => LoginPageAfterSplace()),
      // );

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => VmsHome()),
      // );

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => VmsHome()),
      // );
    }
  }

  Future<void> versionAliCall() async {
    try {
      // Call the API to check the app version
      var loginMap = await VerifyAppVersionRepo().verifyAppVersion(context, "1",
      );
      result = "${loginMap['Result']}";
      msg = "${loginMap['Msg']}";

      print("------114---App ");
      // Check result and navigate or show dialog
      if (result == "1") {

        getlocalDataBaseValue();

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const VmsHome()),
        // );

      } else {
        // Show dialog for mismatched version
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('New Version Available'),
              content: const Text(
                'Please download the latest version of the app from the Play Store.',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    _launchGooglePlayStore();
                  },
                  child: const Text('Download'),
                ),
              ],
            );
          },
        );
        //displayToast(msg ?? "Version mismatch. Please update the app.");
      }
    } catch (e) {
      // Handle potential errors
      print("Error in versionAliCall: $e");
      displayToast("Failed to verify app version.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplaceScreen(),
    );
  }
}

class SplaceScreen extends StatelessWidget {
  const SplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          // Full-screen background image
          Positioned(
            top: 0, // Start from the top
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.8, // 70% of screen height
            child: Image.asset(
              'assets/images/bg.png', // Replace with your image path
              fit: BoxFit.cover, // Covers the area properly
            ),
          ),
          // Top image (height: 80, margin top: 20)
          Positioned(
            top: 100,
            left: 35,
            right: 35,
            child: Center(
              child: Image.asset(
                'assets/images/synergywlogo.png', // Replace with your image path
                height: 60,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            top: 210, // Adjust as needed
            left: 0,
            right: 0, // Ensures the column is centered horizontally
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, // Ensures text alignment in center
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child:Text(
                    "Visitor",
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child:Text(
                    "Management",
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child:Text(
                    "System",
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              ],
            ),
          ),

          // Bottom image (height: 200, margin bottom: 10)
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/splaceboy.png', // Replace with your image path
                height: 300,
              ),
            ),
          ),
        ],
      ),

    );
  }
}
