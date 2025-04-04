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
              Padding(
                padding: const EdgeInsets.only(left: 13, right: 13),
                child: InkWell(
                  onTap: () async {
                    //getLocation();
                    var phone = _phoneNumberController.text.trim();
                    var password = passwordController.text.trim();
                    print("---phone--$phone");
                    print("----password ---$password");

                    if (_formKey.currentState!.validate() &&
                        phone.isNotEmpty &&
                        password.isNotEmpty) {
                      // Call Api

                      loginMap = await LoginRepo().login(context, phone!, password);

                      print('---451----->>>>>---XXXXX---XXXX----$loginMap');

                      result = "${loginMap['Result']}";
                      msg = "${loginMap['Msg']}";
                      //
                      var token = "${loginMap['Msg']}";
                      print('---361----$result');
                      print('---362----$msg');

                      /// to store the value in a local data base
                      //--------------
                      //  SharedPreferences prefs = await SharedPreferences.getInstance();
                      //  prefs.setString('sGender',sGender);
                      //  prefs.setString('sContactNo',sContactNo);
                      //  prefs.setString('sCitizenName',sCitizenName);
                      //  prefs.setString('sEmailId',sEmailId);
                      //  prefs.setString('sToken',sToken);
                      //----------
                    } else {
                      if (_phoneNumberController.text.isEmpty) {
                        phoneNumberfocus.requestFocus();
                      } else if (passwordController.text.isEmpty) {
                        passWordfocus.requestFocus();
                      }
                    } // condition to fetch a response form a api
                    if (result == "1") {
                      var sContactNo = "${loginMap['Data'][0]['sContactNo']}";
                      var sCitizenName = "${loginMap['Data'][0]['sCitizenName']}";
                      var sGender = "${loginMap['Data'][0]['sGender']}";
                      var sEmailId = "${loginMap['Data'][0]['sEmailId']}";
                      var sToken = "${loginMap['Data'][0]['sToken']}";
                      // to store the value in local dataBase

                      SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                      prefs.setString('sGender', sGender);
                      prefs.setString('sContactNo', sContactNo);
                      prefs.setString('sCitizenName', sCitizenName);
                      prefs.setString('sEmailId', sEmailId);
                      prefs.setString('sToken', sToken);

                      String? token = prefs.getString('sToken');
                      String? sContactNo2 = prefs.getString('sContactNo');
                      print("------495----$token");

                      //
                      if ((lat == null && lat == '') ||
                          (long == null && long == '')) {
                        displayToast("Please turn on Location");
                      } else {
                        // testing after open
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                VisitorDashboard(),
                          ),
                        );

                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder:
                        //         (context) =>
                        //             ComplaintHomePage(lat: lat, long: long),
                        //   ),
                        // );
                      }
                    } else {
                      print('----373---To display error msg---');
                      displayToast(msg);
                    }
                  },
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
              // Positioned(
              //   top: 70,
              //   left: 20,
              //   child: GestureDetector(
              //     behavior: HitTestBehavior.opaque, // Ensures tap is detected even outside the image
              //     onTap: () {
              //       print("------262--------");
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (context) => VmsHome()),
              //       );
              //     },
              //     child: Container(
              //       width: 60,
              //       height: 60,
              //       alignment: Alignment.center,
              //       child: Image.asset(
              //         "assets/images/backtop.png",
              //         width: 50,
              //         height: 50,
              //         fit: BoxFit.contain,
              //       ),
              //     ),
              //   ),
              // ),

              // Positioned(
              //   top: 70,
              //   left: 20,
              //   child: Material(
              //     color: Colors.transparent, // Ensures it blends with the background
              //     child: InkWell(
              //       onTap: () {
              //         print("------262--------");
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(builder: (context) => VmsHome()),
              //         );
              //       },
              //       child: Container(
              //         width: 60,
              //         height: 60,
              //         alignment: Alignment.center,
              //         child: Image.asset(
              //           "assets/images/backtop.png",
              //           width: 50,
              //           height: 50,
              //           fit: BoxFit.contain,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              // Positioned(
              //   top: 70,
              //   left: 20,
              //   child: GestureDetector(
              //     behavior: HitTestBehavior.opaque, // Ensures tap detection works even outside the image
              //     onTap: () {
              //       print("------262--------");
              //       // Uncomment this when you need navigation
              //       // Navigator.pushReplacement(
              //       //   context,
              //       //   MaterialPageRoute(builder: (context) => const VmsHome()),
              //       // );
              //     },
              //     child: Container(
              //       width: 60, // Ensure larger tap area
              //       height: 60,
              //       alignment: Alignment.center,
              //       child: Image.asset(
              //         "assets/images/backtop.png",
              //         width: 50,
              //         height: 50,
              //         fit: BoxFit.contain,
              //       ),
              //     ),
              //   ),
              // ),

              // Positioned(
              //   top: 70,
              //   left: 20,
              //   child: GestureDetector( // Use GestureDetector for better tap detection
              //     onTap: () {
              //       print("------262--------");
              //       // Navigator.pushReplacement(
              //       //   context,
              //       //   MaterialPageRoute(builder: (context) => const VmsHome()),
              //       // );
              //     },
              //     child: Container( // Ensures a larger, tappable area
              //       width: 60, // Increase size slightly for better tap response
              //       height: 60,
              //       alignment: Alignment.center,
              //       decoration: BoxDecoration(
              //         color: Colors.transparent, // Ensures tap detection works well
              //       ),
              //       child: Image.asset(
              //         "assets/images/backtop.png",
              //         width: 50,
              //         height: 50,
              //         fit: BoxFit.contain,
              //       ),
              //     ),
              //   ),
              // ),

              // Positioned(
              //   top: 70,
              //   left: 20,
              //   child: InkWell(
              //     onTap: () {
              //       Navigator.pushReplacement(
              //         context,
              //         MaterialPageRoute(builder: (context) => const VmsHome()),
              //       );
              //     },
              //     child: SizedBox(
              //       width: 50, // Set proper width
              //       height: 50, // Set proper height
              //       child: Image.asset("assets/images/backtop.png"),
              //     ),
              //   ),
              // ),

              Positioned(
                top: 80,
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
                top: 315,
                left: 15,
                right: 15,
                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        20,
                      ), // Rounded border with radius 10
                    ),
                    elevation: 5, // Adds shadow effect
                    child: Container(
                      height: 285, // Fixed height
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
                                "Visitor Login",
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
                                                    child:
                                                    TextFormField(
                                                focusNode: phoneNumberfocus,
                                                controller: _phoneNumberController,
                                                textInputAction: TextInputAction.next,
                                                keyboardType: TextInputType.phone,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(10), // Limit to 10 digits
                                                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')), // Allow only numbers
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
                                                  if (value == null || value.isEmpty) {
                                                    return 'Enter mobile number';
                                                  }
                                                  if (value.length < 10) {
                                                    return 'Enter 10-digit mobile number';
                                                  }
                                                  if (RegExp(r'[,#*]').hasMatch(value)) {
                                                    return 'Invalid characters (, # *) not allowed';
                                                  }
                                                  return null;
                                                },
                                              ),

                                                    // child: TextFormField(
                                                    //   focusNode: phoneNumberfocus,
                                                    //   controller: _phoneNumberController,
                                                    //   textInputAction: TextInputAction.next,
                                                    //   keyboardType: TextInputType.phone,
                                                    //   inputFormatters: [
                                                    //     LengthLimitingTextInputFormatter(10),
                                                    //   ],
                                                    //   decoration: const InputDecoration(
                                                    //     labelText: AppStrings.txtMobile,
                                                    //     border: OutlineInputBorder(),
                                                    //     contentPadding: EdgeInsets.symmetric(
                                                    //       vertical: AppPadding.p10,
                                                    //       horizontal: AppPadding.p10,
                                                    //     ),
                                                    //     prefixIcon: Icon(Icons.phone, color: Color(0xFF255899)),
                                                    //   ),
                                                    //   autovalidateMode: AutovalidateMode.onUserInteraction,
                                                    //   validator: (value) {
                                                    //     if (value!.isEmpty) {
                                                    //       return 'Enter mobile number';
                                                    //     }
                                                    //     if (value.length > 1 && value.length < 10) {
                                                    //       return 'Enter 10-digit mobile number';
                                                    //     }
                                                    //     return null;
                                                    //   },
                                                    // ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          SingleChildScrollView(
                                            child: SizedBox(
                                              height: 75,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: AppPadding.p15, right: AppPadding.p15),
                                                child: SizedBox(
                                                  child: TextFormField(
                                                    controller: passwordController,
                                                   // obscureText: _isObscured,
                                                    decoration: const InputDecoration(
                                                      labelText: "Name",
                                                      border: OutlineInputBorder(),
                                                      contentPadding: EdgeInsets.symmetric(
                                                        vertical: AppPadding.p10,
                                                        horizontal: AppPadding.p10,
                                                      ),
                                                      prefixIcon: Icon(Icons.admin_panel_settings, color: Color(0xFF255899)),
                                                      // suffixIcon: IconButton(
                                                      //   icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
                                                      //   onPressed: () {
                                                      //     setState(() {
                                                      //       _isObscured = !_isObscured;
                                                      //     });
                                                      //   },
                                                      // ),
                                                    ),
                                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Enter Name';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 0),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10,right: 10),
                                    child: InkWell(

                                      onTap: () async {
                                      //  getLocation();
                                        var phone = _phoneNumberController.text.trim();
                                        var name = passwordController.text.trim();

                                        print("---phone--$phone");
                                        print("----password ---$name");

                                        if (_formKey.currentState!.validate() &&
                                            phone.isNotEmpty &&
                                            name.isNotEmpty) {
                                          loginMap = await VisitorRegistrationRepo().visitorRegistratiion(
                                            context,
                                            phone,
                                            name
                                          );
                                          result = "${loginMap['Result']}";
                                          msg = "${loginMap['Msg']}";

                                          print("-----496---->>>>--xxx---$loginMap");

                                          if(result=="1"){

                                               var sContactNo = loginMap["sContactNo"].toString();
                                               var name = passwordController.text.trim();
                                               print("----name---$name");
                                            // to store the value into the sharedPreference
                                             SharedPreferences prefs = await SharedPreferences.getInstance();
                                             prefs.setString('name',name);
                                             prefs.setString('sContactNo2',sContactNo);

                                               var  sContactNo2 = prefs.getString('sContactNo2');

                                               print("-----ContactNo-----495--$sContactNo2");
                                             /// todo here you should go otp screen

                                             Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => VisitorLoginOtp()),
                                            );

                                          }else {
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
                                            'Send OTP',
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
