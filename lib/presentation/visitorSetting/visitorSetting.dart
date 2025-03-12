import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../changePassword/changePassword.dart';
import '../login/loginScreen_2.dart';
import '../updateVisitorStatus/updateVisitorStatus.dart';
import '../visitorDashboard/visitorDashBoard.dart';
import 'custtomButton.dart';
class VisitorSetting extends StatelessWidget {
  const VisitorSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VisitorSettingPage(),
    );
  }
}
class VisitorSettingPage extends StatefulWidget {
  const VisitorSettingPage({super.key});

  @override
  State<VisitorSettingPage> createState() => _VisitorSettingPageState();
}

class _VisitorSettingPageState extends State<VisitorSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Image.asset("assets/images/backtop.png",

            ),
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            'Setting',
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
      body:Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20), // Proper spacing
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomButton(
                text: "Change Password",
                icon: Icons.lock,
                color: Colors.blue,
                onPressed: () {
                  // ChangePassword
                  print("Change Password Clicked");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePassword(name: null,)),
                  );
                },
              ),
              SizedBox(height: 20),
              CustomButton(
                text: "Update Visitor Status",
                icon: Icons.update,
                color: Colors.green,
                onPressed: () {
                  // UpdateVisitorStatus
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdateVisitorStatus(name: null,)),
                  );
                  print("Update Visitor Status Clicked");
                },
              ),
              SizedBox(height: 20),
              CustomButton(
                text: "Logout",
                icon: Icons.exit_to_app,
                color: Colors.red,
                onPressed: () async{
                  print("Logout Clicked");

                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.clear(); // Clears all stored data

                  // Navigate to login screen after clearing data
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen_2()),
                  );
                  // clear sharedPreference data and send to logout login Screen

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

