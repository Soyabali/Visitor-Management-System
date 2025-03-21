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
import '../updateVisitorStatus/updateVisitorStatus.dart';
import '../visitorDashboard/visitorDashBoard.dart';
import '../visitorEntry/visitorEntry.dart';
import '../visitorEntryNew2/visitorEntryNew2.dart';
import '../visitorloginEntry/visitorLoginEntry.dart';
import '../vmsHome/vmsHome.dart';

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
            Padding(
              padding: const EdgeInsets.only(left: 13, right: 13),
              child: InkWell(
                // onTap: () async {
                //   getLocation();
                //   var phone = _phoneNumberController.text.trim();
                //   var password = passwordController.text.trim();
                //
                //   print("---phone--$phone");
                //   print("----password ---$password");
                //
                //   if (_formKey.currentState!.validate() &&
                //       phone.isNotEmpty &&
                //       password.isNotEmpty) {
                //     // Call Api
                //
                //     loginMap = await VisitorOtpRepo().visitorOtp(context);
                //     print('---451----->>>>>---XXXXX---XXXX----$loginMap');
                //     result = "${loginMap['Result']}";
                //     msg = "${loginMap['Msg']}";
                //     //
                //     var token = "${loginMap['Msg']}";
                //     print('---361----$result');
                //     print('---362----$msg');
                //
                //     /// to store the value in a local data base
                //     //--------------
                //     //  SharedPreferences prefs = await SharedPreferences.getInstance();
                //     //  prefs.setString('sGender',sGender);
                //     //  prefs.setString('sContactNo',sContactNo);
                //     //  prefs.setString('sCitizenName',sCitizenName);
                //     //  prefs.setString('sEmailId',sEmailId);
                //     //  prefs.setString('sToken',sToken);
                //     //----------
                //   } else {
                //     if (_phoneNumberController.text.isEmpty) {
                //       phoneNumberfocus.requestFocus();
                //       displayToast("Plese Enter Otp");
                //     }
                //   } // condition to fetch a response form a api
                //   if (result == "1") {
                //     /// todo here you should go homePage
                //     // var sContactNo = "${loginMap['Data'][0]['sContactNo']}";
                //     // var sCitizenName = "${loginMap['Data'][0]['sCitizenName']}";
                //     // var sGender = "${loginMap['Data'][0]['sGender']}";
                //     // var sEmailId = "${loginMap['Data'][0]['sEmailId']}";
                //     // var sToken = "${loginMap['Data'][0]['sToken']}";
                //     // to store the value in local dataBase
                //     //
                //     // SharedPreferences prefs =
                //     // await SharedPreferences.getInstance();
                //     // prefs.setString('sGender', sGender);
                //     // prefs.setString('sContactNo', sContactNo);
                //     // prefs.setString('sCitizenName', sCitizenName);
                //     // prefs.setString('sEmailId', sEmailId);
                //     // prefs.setString('sToken', sToken);
                //     //
                //     // String? token = prefs.getString('sToken');
                //     // print("------495----$token");
                //     //
                //     //   if ((lat == null && lat == '') ||
                //     //       (long == null && long == '')) {
                //     //     displayToast("Please turn on Location");
                //     //   } else {
                //     //     Navigator.pushReplacement(
                //     //       context,
                //     //       MaterialPageRoute(
                //     //         builder:
                //     //             (context) =>
                //     //             VisitorDashboard(),
                //     //       ),
                //     //     );
                //     //     // Navigator.pushReplacement(
                //     //     //   context,
                //     //     //   MaterialPageRoute(
                //     //     //     builder:
                //     //     //         (context) =>
                //     //     //             ComplaintHomePage(lat: lat, long: long),
                //     //     //   ),
                //     //     // );
                //     //   }
                //     // }
                //   } else {
                //     print('----373---To display error msg---');
                //     displayToast(msg);
                //   }
                // },
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
                    onTap: () {
                      //   VisitorDashboard
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const VisitorLoginEntry()),
                      );
                      // Navigator.pop(context); // Navigates back when tapped
                    },
                    child: Image.asset("assets/images/backtop.png")
                )
            ),
            Positioned(
              top: 100,
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
              top: 390,
              left: 15,
              right: 15,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    20,
                  ), // Rounded border with radius 10
                ),
                elevation: 5, // Adds shadow effect
                child: Container(
                  height: 200, // Fixed height
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
                            borderRadius: BorderRadius.circular(17), // Rounded border radius
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26, // Shadow color
                                blurRadius: 3, // Softness of the shadow
                                spreadRadius: 2, // How far the shadow spreads
                                offset: Offset(2, 4), // Offset from the container (X, Y)
                              ),
                            ],
                          ),
                          alignment: Alignment.center, // Centers text inside the container
                          child: const Text(
                            "Verify OTP",
                            style: TextStyle(
                              color: Colors.black45, // Text color
                              fontSize: 16, // Font size
                              fontWeight: FontWeight.bold, // Bold text
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
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                children: <Widget>[
                                  Column(
                                    children: [
                                      SizedBox(height: 10),
                                      SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: AppPadding.p15, right: AppPadding.p15),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 75, // Enough height to accommodate error messages
                                                child: TextFormField(
                                                  focusNode: phoneNumberfocus,
                                                  controller: _phoneNumberController,
                                                  textInputAction: TextInputAction.next,
                                                  keyboardType: TextInputType.phone,
                                                  inputFormatters: [
                                                    LengthLimitingTextInputFormatter(4),
                                                  ],
                                                  decoration: const InputDecoration(
                                                    labelText: 'Enter Otp',
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
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 0),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10,right: 10),
                                        child: InkWell(
                                          onTap: () async {
                                            var phone = _phoneNumberController.text.trim();
                                            print("---phone--$phone");
                                            if(phone.isNotEmpty && phone!=null){

                                                print("---Api call here-------");
                                                    loginMap = await VisitorOtpRepo().visitorOtp(
                                                      context,
                                                      phone);
                                                 result = "${loginMap['Result']}";
                                                 msg = "${loginMap['Msg']}";
                                                 if(result=="1"){
                                                        print("----Navigate to next screen-----");
                                                        //  VisitorDashboard
                                                        // Navigator.push(
                                                        //   context,
                                                        //   MaterialPageRoute(builder: (context) => UpdateVisitorStatus()),
                                                        // );
                                                        // VisitorEntryNew2

                                                       // Navigator.push(
                                                       //   context,
                                                       //   MaterialPageRoute(builder: (context) => VisitorEntry()),
                                                       // );
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => VisitorEntryNew2()),
                                                        );
                                                 }else{
                                                   print("----aPI NOT CALL-----");
                                                    displayToast(msg);
                                                 }



                                            }else{
                                              print("---Api not call here-------");
                                            }


                                            // if (_formKey.currentState!.validate() &&
                                            //     phone.isNotEmpty) {
                                            //       loginMap = await VisitorOtpRepo().visitorOtp(
                                            //         context,
                                            //         phone);
                                            //
                                            //   result = "${loginMap['Result']}";
                                            //   msg = "${loginMap['Msg']}";
                                            //   print("-----496---->>>>--xxx---$loginMap");

                                            //   if(result=="1"){
                                            //
                                            //     Navigator.push(
                                            //       context,
                                            //       MaterialPageRoute(builder: (context) => VisitorDashboard()),
                                            //     );
                                            //
                                            //   }else {
                                            //     displayToast(msg);
                                            //
                                            //   }
                                            // } else {
                                              if (_phoneNumberController.text.isEmpty) {
                                                phoneNumberfocus.requestFocus();
                                              } else if (passwordController.text.isEmpty) {
                                                passWordfocus.requestFocus();
                                              }
                                           // }
                                          },
                                          // onTap: () async {
                                          //   getLocation();
                                          //   var otp = _phoneNumberController.text.trim();
                                          //   print("---otp--$otp");
                                          //
                                          //
                                          //   if (_formKey.currentState!.validate() &&
                                          //       otp.isNotEmpty) {
                                          //
                                          //     print("----423-----Call API------");
                                          //
                                          //     // loginMap = await VisitorOtpRepo().visitorOtp(
                                          //     //   context,
                                          //     //   otp,);
                                          //     //
                                          //     // result = "${loginMap['Result']}";
                                          //     // msg = "${loginMap['Msg']}";
                                          //     //
                                          //     // print("-----429-->>>xxx--xxx---$loginMap");
                                          //     //
                                          //     // if(result=="1"){
                                          //     //   //
                                          //     //   // Navigator.push(
                                          //     //   //   context,
                                          //     //   //   MaterialPageRoute(builder: (context) => VisitorDashboard()),
                                          //     //   // );
                                          //     //
                                          //     // }else {
                                          //     //   displayToast(msg);
                                          //     //
                                          //     // }
                                          //   } else {
                                          //       print("-------Not call Api---------");
                                          //
                                          //     // if (_phoneNumberController.text.isEmpty) {
                                          //     //   phoneNumberfocus.requestFocus();
                                          //     //   displayToast("Enter Otp");
                                          //     // }
                                          //   }
                                          // },
                                          child: Container(
                                            height: 45,
                                            width: double.infinity, // Full width
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF0f6fb5),  // Blue color
                                              borderRadius: BorderRadius.horizontal(
                                                left: Radius.circular(17), // Left radius
                                                right: Radius.circular(17), // Right radius
                                              ),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Verify OTP',
                                                style: TextStyle(
                                                  color: Colors.white, // Text color
                                                  fontSize: 16, // Text size
                                                  fontWeight: FontWeight.bold, // Text weight
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
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
