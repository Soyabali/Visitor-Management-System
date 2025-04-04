
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../app/generalFunction.dart';
import '../../services/changePassWordRepo.dart';
import '../complaints/complaintHomePage.dart';
import '../login/loginScreen_2.dart';
import '../resources/app_text_style.dart';
import '../resources/assets_manager.dart';
import '../resources/values_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../visitorDashboard/visitorDashBoard.dart';

class ChangePassword extends StatelessWidget {
   final name;
  const ChangePassword({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: changePassWordPage(),
    );
  }
}

class changePassWordPage extends StatefulWidget {

  const changePassWordPage({super.key});

  @override
  State<changePassWordPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<changePassWordPage> {

  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isObscured = true;
  bool _isObscured2 = true;
  bool _isObscured3 = true;
  var loginProvider;

  // focus
  FocusNode _oldPasswordfocus = FocusNode();
  FocusNode _newPasswordfocus = FocusNode();
  FocusNode _confirmPasswordfocus = FocusNode();
  // FocusNode userfocus = FocusNode();

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
    Future.delayed(const Duration(milliseconds: 100), () {
      // requestLocationPermission();
      setState(() {
        // Here you can write your code for open new view
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  void clearText() {
    _oldPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }
  // WillPopScope(
  // onWillPop: () async => false,
  //
  // child: Scaffold

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async => false,

      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Color(0xFF5ECDC9),
              statusBarIconBrightness: Brightness.dark, // Android
              statusBarBrightness: Brightness.light, // iOS
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25)),
            ),
            centerTitle: true,
            backgroundColor: Color(0xFF5ECDC9),
            leading: GestureDetector(
              onTap: () {
                print("------back---");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VisitorDashboard()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 14),
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset("assets/images/backtop.png",

                  ),
                ),
              ),
            ),
            title: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            elevation: 0, // Removes shadow under the AppBar
          ),
          // appBar: AppBar(
          //   // statusBarColore
          //   systemOverlayStyle: const SystemUiOverlayStyle(
          //     statusBarColor: Color(0xFF12375e),
          //     statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          //     statusBarBrightness: Brightness.light, // For iOS (dark icons)
          //   ),
          //   // backgroundColor: Colors.blu
          //   backgroundColor: Color(0xFF255898),
          //   centerTitle: true,
          //   leading: GestureDetector(
          //     onTap: (){
          //       print("------back---");
          //       // Navigator.pop(context);
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => const ComplaintHomePage()),
          //       );
          //     },
          //     child: Icon(Icons.arrow_back_ios,
          //       color: Colors.white,),
          //   ),
          //   title: Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 5),
          //     child: Text(
          //       'Change Password',
          //       style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          //   //centerTitle: true,
          //   elevation: 0, // Removes shadow under the AppBar
          // ),
          body: GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: AppSize.s145,
                        width: AppSize.s145,
                        margin: const EdgeInsets.all(AppMargin.m20),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              ImageAssets.roundcircle,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppMargin.m16),
                          child: Center(
                            child: Image.asset(
                              "assets/images/dashboardupper.png",
                              // ImageAssets.iclauncher, // Replace with your image asset path
                              width: AppSize.s145,
                              height: AppSize.s145,
                              fit: BoxFit.contain, // Adjust as needed
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Align(
                          alignment: Alignment.centerLeft, // Align to the left
                          child: Text(
                            "Change Password",
                            style: AppTextStyle.font14penSansBlackTextStyle,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      /// Todo here we mention main code for a login ui.
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10,right: 10),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: [
                                    // old Password
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: AppPadding.p15, right: AppPadding.p15),
                                      // passWord TextFormField
                                      child: TextFormField(
                                        focusNode: _oldPasswordfocus,
                                        controller: _oldPasswordController,
                                        obscureText: _isObscured,
                                        decoration: InputDecoration(
                                          labelText: "Old Password",
                                          border: const OutlineInputBorder(),
                                          contentPadding: const EdgeInsets.symmetric(
                                            vertical: AppPadding.p10,
                                            horizontal: AppPadding.p10, // Add horizontal padding
                                          ),
                                          prefixIcon: const Icon(Icons.lock,
                                              color: Color(0xFF255899)),
                                          suffixIcon: IconButton(
                                            icon: Icon(_isObscured
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                            onPressed: () {
                                              setState(() {
                                                _isObscured = !_isObscured;
                                              });
                                            },
                                          ),
                                        ),
                                        autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Enter password';
                                          }
                                          if (value.length < 1) {
                                            return 'Please enter Valid Name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    // new Password
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: AppPadding.p15, right: AppPadding.p15),
                                      // passWord TextFormField
                                      child: TextFormField(
                                        focusNode: _newPasswordfocus,
                                        controller: _newPasswordController,
                                        obscureText: _isObscured2,
                                        decoration: InputDecoration(
                                          labelText: "New Password",
                                          border: const OutlineInputBorder(),
                                          contentPadding: const EdgeInsets.symmetric(
                                            vertical: AppPadding.p10,
                                            horizontal: AppPadding.p10, // Add horizontal padding
                                          ),
                                          prefixIcon: const Icon(Icons.lock,
                                              color: Color(0xFF255899)),
                                          suffixIcon: IconButton(
                                            icon: Icon(_isObscured2
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                            onPressed: () {
                                              setState(() {
                                                _isObscured2 = !_isObscured2;
                                              });
                                            },
                                          ),
                                        ),
                                        autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Enter password';
                                          }
                                          if (value.length < 1) {
                                            return 'Please enter Valid Name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    // ConfirePassword
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: AppPadding.p15, right: AppPadding.p15),
                                      // confirm Password TextFormField
                                      child: TextFormField(
                                        focusNode: _confirmPasswordfocus,
                                        controller: _confirmPasswordController,
                                        obscureText: _isObscured3,
                                        decoration: InputDecoration(
                                          labelText: "Confirm Password",
                                          border: const OutlineInputBorder(),
                                          contentPadding: const EdgeInsets.symmetric(
                                            vertical: AppPadding.p10,
                                            horizontal: AppPadding.p10, // Add horizontal padding
                                          ),
                                          prefixIcon: const Icon(Icons.lock,
                                              color: Color(0xFF255899)),
                                          suffixIcon: IconButton(
                                            icon: Icon(_isObscured3
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                            onPressed: () {
                                              setState(() {
                                                _isObscured3 = !_isObscured3;
                                              });
                                            },
                                          ),
                                        ),
                                        autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Enter password';
                                          }
                                          if (value.length < 1) {
                                            return 'Please enter Valid Name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 10),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 13,right: 13),
                                      child: InkWell(

                                        onTap: () async {

                                             var oldPassword = _oldPasswordController.text.trim();
                                             var newPassword = _newPasswordController.text.trim();
                                             var confirmPassword = _confirmPasswordController.text.trim();

                                          print("---oldPassword--$oldPassword");
                                          print("----newPassword ---$newPassword");
                                          print("----confirmPassword ---$confirmPassword");


                                          if(_formKey.currentState!.validate() && oldPassword.isNotEmpty && newPassword.isNotEmpty && confirmPassword.isNotEmpty){
                                            // Call Api
                                            //again condition

                                            if(newPassword==confirmPassword){
                                                print("--Call Api---");

                                                  loginMap = await ChangePasswordRepo().changePasswrod(context, oldPassword!,newPassword);
                                                  print('---358----$loginMap');
                                                  result = "${loginMap['Result']}";
                                                  msg = "${loginMap['Msg']}";
                                                  print('---361----$result');
                                                  print('---362----$msg');

                                              }else{
                                                print("--ConfirmPassword does not match---");
                                                displayToast("Confirm Password does not match");
                                              }


                                            // loginMap = await LoginRepo().login(context, phone!,password);
                                            //
                                            //
                                            // print('---451----->>>>>---XXXXX---XXXX----$loginMap');
                                            //
                                            // result = "${loginMap['Result']}";
                                            // msg = "${loginMap['Msg']}";
                                            // //
                                            // var token = "${loginMap['Msg']}";
                                            // print('---361----$result');
                                            // print('---362----$msg');

                                            /// to store the value in a local data base
                                            //--------------
                                            //  SharedPreferences prefs = await SharedPreferences.getInstance();
                                            //  prefs.setString('sGender',sGender);
                                            //  prefs.setString('sContactNo',sContactNo);
                                            //  prefs.setString('sCitizenName',sCitizenName);
                                            //  prefs.setString('sEmailId',sEmailId);
                                            //  prefs.setString('sToken',sToken);
                                            //----------

                                          }else{
                                            if(_oldPasswordController.text.isEmpty){
                                              _oldPasswordfocus.requestFocus();
                                              displayToast("Please Enter Old Password");
                                              return;
                                            }else if(_newPasswordController.text.isEmpty){
                                              _newPasswordfocus.requestFocus();
                                              displayToast("Please Enter New Password");
                                              return;
                                            }else if(_confirmPasswordController.text.isEmpty){
                                              _confirmPasswordfocus.requestFocus();
                                              displayToast("Please Enter Confirm Password");
                                              return;
                                            }
                                          } // condition to fetch a response form a api
                                          if(result=="1") {

                                            Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => LoginScreen_2()),
                                                  );
                                          }else{
                                            print('----373---To display error msg---');
                                            displayToast(msg);
                                          }
                                        },
                                        /// todo remoe this comments
                                        // onTap: () async {
                                        //   var oldPassword = _oldPasswordController.text.trim();
                                        //   var newPassword = _newPasswordController.text.trim();
                                        //   var confirmPassword = _confirmPasswordController.text.trim();
                                        //
                                        //   print("Old Password -----$oldPassword");
                                        //   print("newPassword -----$newPassword");
                                        //   print("confirmPassword -----$confirmPassword");
                                        //
                                        //   if(newPassword==confirmPassword){
                                        //     print("--Call Api---");
                                        //
                                        //       loginMap = await ChangePasswordRepo().changePasswrod(context, oldPassword!,newPassword);
                                        //       print('---358----$loginMap');
                                        //       result = "${loginMap['Result']}";
                                        //       msg = "${loginMap['Msg']}";
                                        //       print('---361----$result');
                                        //       print('---362----$msg');
                                        //
                                        //   }else{
                                        //     print("--ConfirmPassword does not match---");
                                        //     displayToast("Confirm Password does not match");
                                        //   }
                                        //   if(result=="1"){
                                        //     // to login PAGE
                                        //       Navigator.pushReplacement(
                                        //         context,
                                        //         MaterialPageRoute(builder: (context) => LoginScreen_2()),
                                        //       );
                                        //   }else{
                                        //     // SAME PAGE WITH NOTIFICATION
                                        //     displayToast(msg);
                                        //   }
                                        //
                                        //   },

                                        child: Container(
                                          width: double.infinity, // Make container fill the width of its parent
                                          height: AppSize.s45,
                                          //  padding: EdgeInsets.all(AppPadding.p5),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF255899), // Background color using HEX value
                                            borderRadius: BorderRadius.circular(
                                                AppMargin.m10), // Rounded corners
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Update",
                                              style: TextStyle(
                                                  fontSize: AppSize.s16,
                                                  color: Colors.white),
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
                )),
          )),
    );
  }
  // toast code
  void displayToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
