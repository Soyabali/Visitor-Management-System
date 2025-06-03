import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import '../../app/generalFunction.dart';
import '../../services/VisitorOtpRepo.dart';
import '../resources/app_strings.dart';
import '../resources/app_text_style.dart';
import '../resources/values_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../visitorEntryNew2/visitorEntryNew2.dart';
import '../visitorloginEntry/visitorLoginEntry.dart';


class VisitorLoginOtp extends StatelessWidget {

  const VisitorLoginOtp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VisitorLoginOtpPage(),
    );
  }
}

class VisitorLoginOtpPage extends StatefulWidget {
  const VisitorLoginOtpPage({super.key});

  @override
  State<VisitorLoginOtpPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<VisitorLoginOtpPage> {

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
      home: WillPopScope(
        onWillPop: () async => false,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Hide keyboard
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 13, right: 13),
                child: InkWell(
                  child: Container(
                    width:
                    double.infinity, // Make container fill the width of its parent
                    height: AppSize.s45,
                    //  padding: EdgeInsets.all(AppPadding.p5),
                    decoration: BoxDecoration(
                      color: Color(0xFF255899), // Background color using HEX value
                      borderRadius: BorderRadius.circular(
                        AppMargin.m10,
                      ), // Rounded corners
                    ),
                    child: const Center(
                      child: Text(
                        AppStrings.txtLogin,
                        style: TextStyle(
                          fontSize: AppSize.s16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Full-screen background image
              Positioned(
                top: 0, // Start from the top
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.7, // 70% of screen height
                child: Image.asset(
                  'assets/images/bg.png', // Replace with your image path
                  fit: BoxFit.cover, // Covers the area properly
                ),
              ),
              // Top image (height: 80, margin top: 20)
              Positioned(
                top: 70,
                left: 20,
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const VisitorLoginEntry()),
                    );
                  },
                  child: SizedBox(
                    width: 50, // Set proper width
                    height: 50, // Set proper height
                    child: Image.asset("assets/images/backtop.png"),
                  ),
                ),
              ),
              Positioned(
                top: 85,
                left: 95,
                child: Center(
                  child: Container(
                    height: 32,
                    //width: 140,
                    child: Image.asset(
                      'assets/images/synergylogo.png', // Replace with your image path
                      // Set height
                      fit: BoxFit.cover, // Ensures the image fills the given size
                    ),
                  ),
                ),
              ),
              // Positioned(
              //   top: 85,
              //   left: 95,
              //   child: Center(
              //     child: Container(
              //       height: 32,
              //       //width: 140,
              //       child: Image.asset(
              //         'assets/images/Synergywhitelogo.png', // Replace with your image path
              //         // Set height
              //         fit: BoxFit.cover, // Ensures the image fills the given size
              //       ),
              //     ),
              //   ),
              // ),
              Positioned(
                top: 140,
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
                left: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width * 0.2 : 15,
                right: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width * 0.2 : 15,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                  child: Container(
                    height: 220,
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
                              "Verify OTP",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p15),
                                      child: SizedBox(
                                        height: 75,
                                        child: TextFormField(
                                          focusNode: phoneNumberfocus,
                                          controller: _phoneNumberController,
                                          autofocus: true,
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.phone,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(4),
                                          ],
                                          decoration: const InputDecoration(
                                            labelText: 'Enter OTP',
                                            border: OutlineInputBorder(),
                                            contentPadding: EdgeInsets.symmetric(
                                              vertical: AppPadding.p10,
                                              horizontal: AppPadding.p10,
                                            ),
                                            prefixIcon: Icon(Icons.phone, color: Color(0xFF255899)),
                                          ),
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Enter OTP';
                                            }
                                            if (value.length > 1 && value.length < 4) {
                                              return 'Enter 4-digit OTP';
                                            }
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
                                          if (phone.isNotEmpty) {
                                            print("---API call here---");
                                            loginMap = await VisitorOtpRepo().visitorOtp(context, phone);
                                            result = "${loginMap['Result']}";
                                            msg = "${loginMap['Msg']}";
                                            print("---OTP response---$loginMap");

                                            if (result == "1") {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => VisitorEntryNew2()),
                                              );
                                            } else {
                                              displayToast(msg);
                                            }
                                          } else {
                                            phoneNumberfocus.requestFocus();
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
                                              'Verify OTP',
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
