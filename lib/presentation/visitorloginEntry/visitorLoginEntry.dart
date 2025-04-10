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

class VisitorLoginEntry extends StatelessWidget {
  const VisitorLoginEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VisitorLoginEntryPage(),
    );
  }
}

class VisitorLoginEntryPage extends StatefulWidget {
  const VisitorLoginEntryPage({super.key});

  @override
  State<VisitorLoginEntryPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<VisitorLoginEntryPage> {

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
                MediaQuery.of(context).size.height * 0.7, // 70% of screen height
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
              Positioned(
                top: 85,
                left: 95,
                child: Center(
                  child: Container(
                    height: 32,
                    //width: 140,
                    child: Image.asset(
                      'assets/images/Synergywhitelogo.png', // Replace with your image path
                      // Set height
                      fit: BoxFit.cover, // Ensures the image fills the given size
                    ),
                  ),
                ),
              ),
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
                      height: 285,
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
                                "Visitor Login",
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
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p15),
                                        child: SizedBox(
                                          height: 75,
                                          child: TextFormField(
                                            focusNode: phoneNumberfocus,
                                            controller: _phoneNumberController,
                                            textInputAction: TextInputAction.next,
                                            keyboardType: TextInputType.phone,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(10),
                                              FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')),
                                            ],
                                            decoration: const InputDecoration(
                                              labelText: AppStrings.txtMobile,
                                              border: OutlineInputBorder(),
                                              contentPadding: EdgeInsets.symmetric(
                                                vertical: AppPadding.p10,
                                                horizontal: AppPadding.p10,
                                              ),
                                              prefixIcon: Icon(Icons.phone, color: Color(0xFF255899)),
                                            ),
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) return 'Enter mobile number';
                                              if (value.length < 10) return 'Enter 10-digit mobile number';
                                              if (RegExp(r'[,#*]').hasMatch(value)) return 'Invalid characters (, # *) not allowed';
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 0),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p15),
                                        child: SizedBox(
                                          height: 75,
                                          child: TextFormField(
                                            controller: passwordController,
                                            decoration: const InputDecoration(
                                              labelText: "Name",
                                              border: OutlineInputBorder(),
                                              contentPadding: EdgeInsets.symmetric(
                                                vertical: AppPadding.p10,
                                                horizontal: AppPadding.p10,
                                              ),
                                              prefixIcon: Icon(Icons.admin_panel_settings, color: Color(0xFF255899)),
                                            ),
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            validator: (value) {
                                              if (value!.isEmpty) return 'Enter Name';
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 0),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: InkWell(
                                          onTap: () async {
                                            var phone = _phoneNumberController.text.trim();
                                            var name = passwordController.text.trim();
                                            print("---phone--$phone");
                                            print("----name ---$name");

                                            if (_formKey.currentState!.validate() &&
                                                phone.isNotEmpty &&
                                                name.isNotEmpty) {
                                              loginMap = await VisitorRegistrationRepo().visitorRegistratiion(
                                                context,
                                                phone,
                                                name,
                                              );
                                              result = "${loginMap['Result']}";
                                              msg = "${loginMap['Msg']}";

                                              print("-----Login Result---->>>>--$loginMap");

                                              if (result == "1") {
                                                var sContactNo = loginMap["sContactNo"].toString();
                                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                                prefs.setString('name', name);
                                                prefs.setString('sContactNo2', sContactNo);

                                                print("-----ContactNo Stored: $sContactNo");

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => VisitorLoginOtp()),
                                                );
                                              } else {
                                                displayToast(msg);
                                              }
                                            } else {
                                              if (_phoneNumberController.text.isEmpty) {
                                                phoneNumberfocus.requestFocus();
                                              } else if (passwordController.text.isEmpty) {
                                                passWordfocus.requestFocus();
                                              }
                                            }
                                          },
                                          child: Container(
                                            height: 45,
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF0f6fb5),
                                              borderRadius: BorderRadius.horizontal(
                                                left: Radius.circular(17),
                                                right: Radius.circular(17),
                                              ),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Send OTP',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
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
