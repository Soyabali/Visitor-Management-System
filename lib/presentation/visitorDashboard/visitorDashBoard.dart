import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../app/generalFunction.dart';
import '../login/loginScreen_2.dart';
import '../resources/app_text_style.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../visitorEntry/visitorEntry.dart';
import '../visitorExit/VisitorExit.dart';
import '../visitorReport/reimbursementstatus.dart';
import '../visitorReport/visitorReport.dart';


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
              MediaQuery.of(context).size.height * 0.7, // 70% of screen height
              child: Image.asset('assets/images/bg.png', // Replace with your image path
                fit: BoxFit.cover, // Covers the area properly
              ),
            ),
            // Positioned(
            //     top: 70,
            //     left: 20,
            //     child: GestureDetector(
            //         onTap: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(builder: (context) => LoginScreen_2()),
            //           );
            //           // Navigator.pop(context); // Navigates back when tapped
            //         },
            //         child: Image.asset("assets/images/backtop.png")
            //     )
            // ),
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
              top: 345,
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
                      height: 345,
                      width: MediaQuery.of(context).size.width - 30,
                      borderRadius: 20, // Keep it 20 for consistency
                      blur: 10,
                      alignment: Alignment.center,
                      border: 1, // Keep a smaller border for aesthetics
                      linearGradient: LinearGradient(
                        colors: [
                            Colors.white.withOpacity(0.6), // More opacity to enhance whiteness
                            Colors.white.withOpacity(0.5), // Less contrast to avoid gray tint
                          // Colors.white.withOpacity(0.2),
                          // //Colors.white38.withOpacity(0.2),
                          // Colors.white24.withOpacity(0.2),
                          //Colors.white.withOpacity(0.2),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderGradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.6), // Match with main gradient
                         // Colors.white.withOpacity(0.5),
                         //  Colors.white24.withOpacity(0.2),
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
                           child: Container(
                             width: double.infinity, // Full width
                             height: 35, // Fixed height
                             decoration: BoxDecoration(
                               color: Color(0xFFC9EAFE), // Background color
                               borderRadius: BorderRadius.circular(8), // Rounded corners
                             ),
                             alignment: Alignment.center, // Centers text inside the container
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
                         Positioned(
                           top: 65,
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
                                       MaterialPageRoute(builder: (context) => VisitorEntry()),
                                     );
                                   },
                                   child: Container(
                                     height: 100,
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
                                     child: Center( // Centers the image
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
                               ),
                               SizedBox(width: 8), // Added better spacing
                               Expanded(
                                 child: GestureDetector(
                                   onTap: (){
                                     //VisitorEntry
                                     print('---Exit---');
                                     //  VisitorExit
                                     var name = "Exit";
                                     Navigator.push(
                                       context,
                                       MaterialPageRoute(builder: (context) => VisitorExitScreen(name:name)),
                                     );
                                   },
                                   child: Container(
                                     height: 100,
                                     decoration: BoxDecoration(
                                       color: Colors.white,
                                       border: Border.all(color: Colors.black12, width: 1),
                                       borderRadius: BorderRadius.circular(10),
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.white.withOpacity(0.2),
                                          // color: Colors.black12.withOpacity(0.2),
                                           blurRadius: 5,
                                           spreadRadius: 2,
                                           offset: Offset(0, 2),
                                         ),
                                       ],
                                     ),
                                     child: Center( // Centers the image
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
                               ),
                             ],
                           ),
                         ),
                        const Positioned(
                           top: 170,
                           left: 0,
                           right: 0,
                           child: Row(
                             children: [
                               Expanded(
                                 child: Padding(
                                   padding: EdgeInsets.only(left: 20),
                                   child: Align(
                                     alignment: Alignment.centerLeft,
                                     child: Text(
                                       "Entry",
                                       style: TextStyle(
                                         color: Colors.black,
                                         fontSize: 14,
                                       ),
                                     ),
                                   ),
                                 ),
                               ),
                               Expanded(
                                 child: Padding(
                                   padding: EdgeInsets.only(left: 5),
                                   child: Align(
                                     alignment: Alignment.centerLeft,
                                     child: Text(
                                       "Exit",
                                       style: TextStyle(
                                         color: Colors.black,
                                         fontSize: 14,
                                       ),
                                     ),
                                   ),
                                 ),
                               ),
                             ],
                           ),
                         ),
                         Positioned(
                           top: 200,
                           left: 15,
                           right: 15,
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: <Widget>[
                               Expanded(
                                 child: GestureDetector(
                                   onTap: (){
                                     // VisitorReportScreen
                                     var name = "VisitorReportScreen";
                                     // Reimbursementstatus
                                     // Navigator.push(
                                     //   context,
                                     //   MaterialPageRoute(builder: (context) => VisitorReportScreen(name:name)),
                                     // );
                                     Navigator.push(
                                       context,
                                       MaterialPageRoute(builder: (context) => Reimbursementstatus()),
                                     );
                                   },
                                   child: Container(
                                     height: 100,
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
                                     child: Center( // Centers the image
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
                               ),
                               SizedBox(width: 8), // Added better spacing
                               Expanded(
                                 child: Container(
                                   height: 100,
                                   decoration: BoxDecoration(
                                     color: Colors.white,
                                     border: Border.all(color: Colors.black12, width: 1),
                                     borderRadius: BorderRadius.circular(10),
                                     boxShadow: [
                                       BoxShadow(
                                         color: Colors.white.withOpacity(0.2),
                                        // color: Colors.black12.withOpacity(0.2),
                                         blurRadius: 5,
                                         spreadRadius: 2,
                                         offset: Offset(0, 2),
                                       ),
                                     ],
                                   ),
                                   child: Center( // Centers the image
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
                         ),
                         const Positioned(
                           top: 310,
                           left: 0,
                           right: 0,
                           child: Row(
                             children: [
                               Expanded(
                                 child: Padding(
                                   padding: EdgeInsets.only(left: 20),
                                   child: Align(
                                     alignment: Alignment.centerLeft,
                                     child: Text(
                                       "Report",
                                       style: TextStyle(
                                         color: Colors.black,
                                         fontSize: 14,
                                       ),
                                     ),
                                   ),
                                 ),
                               ),
                               Expanded(
                                 child: Padding(
                                   padding: EdgeInsets.only(left: 5),
                                   child: Align(
                                     alignment: Alignment.centerLeft,
                                     child: Text(
                                       "Setting",
                                       style: TextStyle(
                                         color: Colors.black,
                                         fontSize: 14,
                                       ),
                                     ),
                                   ),
                                 ),
                               ),
                             ],
                           ),
                         ),
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
