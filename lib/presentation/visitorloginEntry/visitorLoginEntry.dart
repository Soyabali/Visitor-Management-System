import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../app/generalFunction.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../vmsHome/vmsHome.dart';
import 'VisitorLoginDialog.dart';

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
              Positioned(
                top: 0, // Start from the top
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.7, // 70% of screen height
                child: Image.asset('assets/images/bg.png', // Replace with your image path
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
                top: 110,
                left: 35,
                right: 35,
                child: Center(
                  child: Image.asset('assets/images/loginupper.png', // Replace with your image path
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              // visitor login Dialog
              Positioned(
                top: 340,
                left: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width * 0.2 : 15,
                right: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width * 0.2 : 15,
                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: VisitorLoginDialog(
                    formKey: _formKey,
                    phoneController: _phoneNumberController,
                    nameController: passwordController,
                    phoneFocus: phoneNumberfocus,
                    nameFocus: passWordfocus,
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
