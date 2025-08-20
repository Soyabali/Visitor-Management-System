import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/generalFunction.dart';
import '../../services/VisitorRegistrationRepo.dart';
import '../../services/loginRepo.dart';
import '../complaints/complaintHomePage.dart';
import '../resources/app_strings.dart';
import '../resources/app_text_style.dart';
import '../resources/values_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../visitorDashboard/visitorDashBoard.dart';
import '../visitorLoginOtp/visitorLoginOtp.dart';
import '../vmsHome/vmsHome.dart';


class VisitorWatingScreenPage extends StatefulWidget {

  final sSubmitMessage,sProgressImg;

  VisitorWatingScreenPage(this.sSubmitMessage, this.sProgressImg, {super.key});

  @override
  State<VisitorWatingScreenPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<VisitorWatingScreenPage> {

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
      home: WillPopScope(
        onWillPop: () async => false,
        child: GestureDetector(
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
              // Top image (height: 80, margin top: 20)
              Positioned(
                top: 70,
                left: 20,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    print("------262--------");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VmsHome()),
                    );
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/backtop.png",
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              // company logo on a top
              // Positioned(
              //   top: 85,
              //   left: 95,
              //   child: Center(
              //     child: Container(
              //       height: 32,
              //       //width: 140,
              //       child: Image.asset(
              //         'assets/images/synergylogo.png', // Replace with your image path
              //         // Set height
              //         fit: BoxFit.cover, // Ensures the image fills the given size
              //       ),
              //     ),
              //   ),
              // ),

              Positioned(
                top: 130,
                left: 35,
                right: 35,
                child: Center(
                  child: Image.asset(
                    'assets/images/loginupper.png', // Replace with your image path
                    fit: BoxFit.fill,
                  ),
                ),
              ),

              Positioned(
                top: 400,
                left: MediaQuery.of(context).size.width > 600
                    ? MediaQuery.of(context).size.width * 0.2 // 20% padding on tablets
                    : 15, // 15px padding on mobile
                right: MediaQuery.of(context).size.width > 600
                    ? MediaQuery.of(context).size.width * 0.2 // 20% padding on tablets
                    : 15, // 15px padding on mobile
                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                    child: Container(
                      height: 350,
                      color: Colors.white,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              width: double.infinity,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Color(0xFFC9EAFE),
                                borderRadius: BorderRadius.circular(17),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 3,
                                    spreadRadius: 2,
                                    offset: Offset(2, 4),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                "Request in Progress",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            child: SingleChildScrollView(
                              child: Form(
                                key: _formKey,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Container(
                                    color: Colors.white,
                                    child: SingleChildScrollView( // Allows scrolling when content overflows
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min, // Prevents unnecessary stretching
                                        children: <Widget>[
                                          SizedBox(height: 10),
                                          LayoutBuilder(
                                            builder: (context, constraints) {
                                              return ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth: constraints.maxWidth * 0.9, // 90% of parent width
                                                ),
                                                child: Text(
                                                  '${widget.sSubmitMessage}',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16, // Reduce font size slightly for better fit
                                                  ),
                                                  softWrap: true,
                                                  maxLines: 3, // Limits text to 3 lines
                                                  overflow: TextOverflow.ellipsis, // Adds "..." if text is too long
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(height: 10),
                                          Center(
                                            child: LayoutBuilder(
                                              builder: (context, constraints) {
                                                double imageSize = constraints.maxWidth * 0.4; // Image adjusts to 40% of width
                                                return Container(
                                                  height: imageSize.clamp(80, 150), // Min 80px, Max 150px
                                                  width: imageSize.clamp(80, 150),
                                                  child: Image.network(
                                                    '${widget.sProgressImg}',
                                                    fit: BoxFit.contain, // Ensures the full image is visible
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // child: Container(
                                  //   color: Colors.white,
                                  //   child: Column(
                                  //     children: <Widget>[
                                  //       SizedBox(height: 10),
                                  //       LayoutBuilder(
                                  //         builder: (context, constraints) {
                                  //           return SizedBox(
                                  //             width: constraints.maxWidth * 0.9, // 90% of the parent width
                                  //             child: Text(
                                  //               '${widget.sSubmitMessage}',
                                  //               style: const TextStyle(
                                  //                 color: Colors.black,
                                  //                 fontSize: 18,
                                  //               ),
                                  //               softWrap: true,
                                  //               overflow: TextOverflow.visible,
                                  //             ),
                                  //           );
                                  //         },
                                  //       ),
                                  //       SizedBox(height: 20),
                                  //       Center(
                                  //         child: Container(
                                  //           height: 150,
                                  //           width: 150,
                                  //           child: Image.network('${widget.sProgressImg}',
                                  //           fit: BoxFit.cover,
                                  //           ),
                                  //         ),
                                  //       )
                                  //
                                  //     ],
                                  //   ),
                                  // ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: 10, // Distance from the bottom
                left: 0,
                right: 0, // Ensures centering
                child: Center( // Centers the logo horizontally
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Image.asset(
                      'assets/images/companylogo2.png',
                      fit: BoxFit.fill, // Stretches to fill the height & width
                      height: 50, // Increase height
                    ),
                  ),
                ),
              ),
            ],
          ),
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
