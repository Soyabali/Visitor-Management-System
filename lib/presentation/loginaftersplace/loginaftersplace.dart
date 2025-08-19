import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/generalFunction.dart';
import '../../services/loginRepo.dart';
import '../resources/app_strings.dart';
import '../resources/values_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../visitorDashboard/visitorDashBoard.dart';
import '../vmsHome/vmsHome.dart';


class Loginaftersplace extends StatelessWidget {

  const Loginaftersplace({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPageAfterSplace(),
    );
  }
}

class LoginPageAfterSplace extends StatefulWidget {
  const LoginPageAfterSplace({super.key});

  @override
  State<LoginPageAfterSplace> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPageAfterSplace> {

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
  String? phoneError;
  String? nameError;
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
                height:
                MediaQuery.of(context).size.height * 0.7, // 70% of screen height
                child: Image.asset(
                  'assets/images/bg.png', // Replace with your image path
                  fit: BoxFit.cover, // Covers the area properly
                ),
              ),
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
                top: 85,
                left: 20,
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
              Positioned(
                top: 110,
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
                top: 340,
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
                      height: 295, // Fixed height
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
                                "User Authentication",
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
                                                    height: 80,
                                                    // Enough height to accommodate error messages
                                                    child: TextFormField(
                                                      focusNode: phoneNumberfocus,
                                                      controller: _phoneNumberController,
                                                      autofocus: true,
                                                      textInputAction: TextInputAction.next,
                                                      keyboardType: TextInputType.phone,
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(10),
                                                        FilteringTextInputFormatter.digitsOnly,
                                                      ],
                                                      decoration: InputDecoration(
                                                        labelText: "Mobile Number",
                                                        border: const OutlineInputBorder(),
                                                        prefixIcon: const Icon(
                                                          Icons.phone,
                                                          color: Color(0xFF255899),
                                                        ),
                                                        errorText: phoneError,
                                                      ),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          if (value.isEmpty) {
                                                            phoneError = 'Enter mobile number';
                                                          } else if (value.length > 10) {
                                                            phoneError = 'Mobile number must be 10 digits';
                                                          } else if (!RegExp(r'^[6-9]').hasMatch(value)) {
                                                            phoneError = 'The mobile number is not valid.';
                                                          } else if (RegExp(r'^0+$').hasMatch(value)) {
                                                            phoneError = 'The mobile number is not valid.';
                                                          } else if (value.length < 10) {
                                                            phoneError = 'Mobile number must be 10 digits';
                                                          } else {
                                                            phoneError = null;
                                                          }
                                                        });
                                                      },
                                                      validator: (value) {
                                                        if (value == null || value.isEmpty) {
                                                          return 'Enter mobile number';
                                                        }
                                                        if (value.length != 10) {
                                                          return 'Mobile number must be 10 digits';
                                                        }
                                                        if (!RegExp(r'^[6-9]').hasMatch(value)) {
                                                          return 'The mobile number is not valid.';
                                                        }
                                                        if (RegExp(r'^0+$').hasMatch(value)) {
                                                          return 'The mobile number is not valid.';
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
                                            padding: const EdgeInsets.only(left: AppPadding.p15, right: AppPadding.p15),
                                            child: SizedBox(
                                              height: 80,
                                              child: TextFormField(
                                                controller: passwordController,
                                                obscureText: _isObscured,
                                                decoration: InputDecoration(
                                                  labelText: AppStrings.txtpassword,
                                                  border: const OutlineInputBorder(),
                                                  contentPadding: const EdgeInsets.symmetric(
                                                    vertical: AppPadding.p10,
                                                    horizontal: AppPadding.p10,
                                                  ),
                                                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF255899)),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
                                                    onPressed: () {
                                                      setState(() {
                                                        _isObscured = !_isObscured;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'Enter password';
                                                  }
                                                  if (value.length > 20) {
                                                    return 'Password should not exceed 20 characters';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          InkWell(
                                            onTap: ()async {
                                              // Call your API here
                                              var phone = _phoneNumberController.text.trim();
                                              var password = passwordController.text.trim();
                                              print("---phone--$phone");
                                              print("----password ---$password");

                                              if (_formKey.currentState!.validate() &&
                                                  phone.isNotEmpty &&
                                                  password.isNotEmpty) {
                                                loginMap = await LoginRepo().login(
                                                  context,
                                                  phone,
                                                  password,
                                                );
                                                result = "${loginMap['Result']}";
                                                msg = "${loginMap['Msg']}";
                                                print("-------330----$loginMap");
                                                if(result =="0"){
                                                  displayToast(msg);
                                                }

                                                if(result=="1") {
                                                  // to store the fetch data into the local database
                                                  var iUserId = loginMap["Data"][0]["iUserId"]
                                                      .toString();
                                                  var sUserName = loginMap["Data"][0]["sUserName"]
                                                      .toString();
                                                  var sContactNo = loginMap["Data"][0]["sContactNo"]
                                                      .toString();
                                                  var sToken = loginMap["Data"][0]["sToken"]
                                                      .toString();
                                                  var iUserType = loginMap["Data"][0]["iUserType"]
                                                      .toString();
                                                  var dLastLoginAt = loginMap["Data"][0]["dLastLoginAt"]
                                                      .toString();


                                                  // to store the value into the sharedPreference
                                                  SharedPreferences prefs = await SharedPreferences
                                                      .getInstance();
                                                  prefs
                                                      .setString(
                                                      'iUserId', iUserId)
                                                      .toString();
                                                  prefs
                                                      .setString(
                                                      'sUserName', sUserName)
                                                      .toString();
                                                  prefs
                                                      .setString(
                                                      'sContactNo', sContactNo)
                                                      .toString();
                                                  prefs
                                                      .setString(
                                                      'sToken', sToken)
                                                      .toString();
                                                  prefs
                                                      .setString(
                                                      'iUserType', iUserType)
                                                      .toString();
                                                  prefs.setString(
                                                      'dLastLoginAt',
                                                      dLastLoginAt).toString();


                                                  // Navigator.pushReplacement(
                                                  //   context,
                                                  //   MaterialPageRoute(builder: (context) => VisitorDashboard()),
                                                  // );
                                                  /// TODO Navigate vmsHome
                                                  /// todo here you should apply logic if iUserType is 1 then VmsHome to show only visitor Box

                                                  // context.go('/VmsHome');

                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(builder: (context) => VmsHome()),
                                                  // );

                                                  // Navigator.pushReplacement(
                                                  //   context,
                                                  //   MaterialPageRoute(
                                                  //     builder:
                                                  //         (context) => VmsHome(),
                                                  //   ),
                                                  // );
                                                  print(
                                                      "----iUserType---377----$iUserType");
                                                  if (iUserType == "2") {
                                                    //context.go('/VmsHome');
                                                     context.go('/VisitorDashboard');
                                                   // displayToast("Login ADmin Successfully $iUserType");

                                                  } else if(iUserType == "1") {
                                                   // context.go('/VisitorDashboard');
                                                    context.go('/VmsHome');
                                                   // displayToast("Login visitor Successfully $iUserType");

                                                  }else{}
                                                }
                                              } else {
                                                if (_phoneNumberController.text.isEmpty) {
                                                  phoneNumberfocus.requestFocus();
                                                } else if (passwordController.text.isEmpty) {
                                                  passWordfocus.requestFocus();
                                                }
                                              }
                                            },
                                            borderRadius: const BorderRadius.horizontal(
                                              left: Radius.circular(17), // Match Container's border radius
                                              right: Radius.circular(17),
                                            ),
                                            child: Material(
                                              color: Colors.transparent, // Keep background color unchanged
                                              borderRadius: const BorderRadius.horizontal(
                                                left: Radius.circular(17),
                                                right: Radius.circular(17),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 12,right: 12),
                                                child: Container(
                                                  height: 45,
                                                  width: double.infinity,
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xFF0f6fb5), // Blue color
                                                    borderRadius: BorderRadius.horizontal(
                                                      left: Radius.circular(17),
                                                      right: Radius.circular(17),
                                                    ),
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                      'Login',
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
                                          ),
                                        ],
                                      ),
                                    ],
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
              //SizedBox(height: 10),
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
