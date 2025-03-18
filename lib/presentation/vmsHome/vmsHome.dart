import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../app/generalFunction.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../login/loginScreen_2.dart';
import '../visitorEntry/visitorEntry.dart';
import '../visitorloginEntry/visitorLoginEntry.dart';



class VmsHome extends StatelessWidget {
  const VmsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VmsHomePage(),
    );
  }
}

class VmsHomePage extends StatefulWidget {
  const VmsHomePage({super.key});

  @override
  State<VmsHomePage> createState() => _LoginPageState();
}

class _LoginPageState extends State<VmsHomePage> {

  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  List<Map<String, dynamic>>? recentVisitorList;

  final _formKey = GlobalKey<FormState>();
  bool isLoading = true; // logic

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
  String? sUserName,sContactNo;
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
    return Scaffold(
      // debugShowCheckedModeBanner: false,
      // appBar: AppBar(
      //   title: Text("VMS"),
      // ),
      // drawer: generalFunction.drawerFunction_2(context,"$sUserName","$sContactNo"),
      //
      body: GestureDetector(
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
              child: Image.asset('assets/images/bg.png', // Replace with your image path
                fit: BoxFit.cover, // Covers the area properly
              ),
            ),
            // Top image (height: 80, margin top: 20)
            Positioned(
              top: 60,
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
              top: 350,
              left: 15,
              right: 15,
              child: Material(
                // elevation: 0.1, // Apply elevation
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: Colors.transparent, // Keep the Material transparent
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Container(
                    color: Colors.white.withOpacity(0.1),
                    child: GlassmorphicContainer(
                      height: 300,
                      width: MediaQuery.of(context).size.width - 30,
                      borderRadius: 20, // Keep it 20 for consistency
                      blur: 10,
                      alignment: Alignment.center,
                      border: 1, // Keep a smaller border for aesthetics
                      linearGradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.6), // More opacity to enhance whiteness
                          Colors.white.withOpacity(0.5), // Less contrast to avoid gray tint
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderGradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.6), // Match with main gradient
                          Colors.white24.withOpacity(0.5),
                          //  Colors.white70.withOpacity(0.2),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.topCenter, // Aligns child widgets from the top
                        children: [
                          Positioned(
                              top: 20, // Place text at the top of the screen
                              left: 15,
                              right: 15,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
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
                                      "Visitor Management System",
                                      style: TextStyle(
                                        color: Colors.black45, // Text color
                                        fontSize: 16, // Font size
                                        fontWeight: FontWeight.bold, // Bold text
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          //
                          Positioned(
                            top: 100,
                            left: 15,
                            right: 15,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => VisitorLoginEntry()),
                                      );
                                    },
                                    child: Container(
                                        height: 140,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: Colors.black12, width: 1),
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white.withOpacity(0.2),
                                              //color: Colors.black12.withOpacity(0.2),
                                              blurRadius: 5,
                                              spreadRadius: 2,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Center( // Centers the image
                                              child: SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: Image.asset(
                                                  'assets/images/entry.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            const Text(
                                              "Visitor Login",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8), // Added better spacing
                                Expanded(
                                  child: GestureDetector(
                                    onTap: (){
                                      //VisitorEntry

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => LoginScreen_2()),
                                      );
                                    },
                                    child: Container(
                                        height: 140,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: Colors.black12, width: 1),
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white.withOpacity(0.2),
                                              //color: Colors.black12.withOpacity(0.2),
                                              blurRadius: 5,
                                              spreadRadius: 2,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Center( // Centers the image
                                              child: SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: Image.asset(
                                                  'assets/images/exit.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            const Text(
                                              "Admin Login",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                    // child: Container(
                                    //   height: 100,
                                    //   decoration: BoxDecoration(
                                    //     color: Colors.white,
                                    //     border: Border.all(color: Colors.black12, width: 1),
                                    //     borderRadius: BorderRadius.circular(10),
                                    //     boxShadow: [
                                    //       BoxShadow(
                                    //         color: Colors.white.withOpacity(0.2),
                                    //        // color: Colors.black12.withOpacity(0.2),
                                    //         blurRadius: 5,
                                    //         spreadRadius: 2,
                                    //         offset: Offset(0, 2),
                                    //       ),
                                    //     ],
                                    //   ),
                                    //   child: Center( // Centers the image
                                    //     child: SizedBox(
                                    //       width: 50,
                                    //       height: 50,
                                    //       child: Image.asset(
                                    //         'assets/images/exit.png',
                                    //         fit: BoxFit.contain,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Positioned(
                          //   top: 40,
                          //   left: 15,
                          //   right: 15,
                          //   bottom: 15,
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: <Widget>[
                          //       Expanded(
                          //         child: GestureDetector(
                          //           onTap: () {
                          //             Navigator.push(
                          //               context,
                          //               MaterialPageRoute(builder: (context) => VisitorLoginEntry()),
                          //             );
                          //           },
                          //           child: Container(
                          //             height: 250, // Set height to 250
                          //             decoration: BoxDecoration(
                          //               color: Colors.white,
                          //               border: Border.all(color: Colors.black12, width: 1),
                          //               borderRadius: BorderRadius.circular(10),
                          //               boxShadow: [
                          //                 BoxShadow(
                          //                   color: Colors.white.withOpacity(0.2),
                          //                   blurRadius: 5,
                          //                   spreadRadius: 2,
                          //                   offset: Offset(0, 2),
                          //                 ),
                          //               ],
                          //               image: const DecorationImage(
                          //                 image: AssetImage('assets/images/vistorlogin.jpeg'),
                          //                 fit: BoxFit.cover, // Ensures image fills the container
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //       SizedBox(width: 8), // Added better spacing
                          //       Expanded(
                          //         child: GestureDetector(
                          //           onTap: () {
                          //             print('---Exit---');
                          //             Navigator.push(
                          //               context,
                          //               MaterialPageRoute(builder: (context) => LoginScreen_2()),
                          //             );
                          //           },
                          //           child: Container(
                          //             height: 250, // Set height to 250
                          //             decoration: BoxDecoration(
                          //               color: Colors.white,
                          //               border: Border.all(color: Colors.black12, width: 1),
                          //               borderRadius: BorderRadius.circular(10),
                          //               boxShadow: [
                          //                 BoxShadow(
                          //                   color: Colors.white.withOpacity(0.2),
                          //                   blurRadius: 5,
                          //                   spreadRadius: 2,
                          //                   offset: Offset(0, 2),
                          //                 ),
                          //               ],
                          //             ),
                          //             child: ClipRRect(
                          //               borderRadius: BorderRadius.circular(10),
                          //               child: Image.asset(
                          //                 'assets/images/vistorlogin.jpeg',
                          //                 fit: BoxFit.cover, // Ensures image fills the container
                          //                 width: double.infinity, // Forces image to take full width
                          //                 height: double.infinity, // Forces image to take full height
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          //
                          // ),
                        ],
                      ),
                    ),
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
