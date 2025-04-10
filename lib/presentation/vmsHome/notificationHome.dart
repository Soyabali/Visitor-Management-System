import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../app/generalFunction.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../login/loginScreen_2.dart';
import '../visitorloginEntry/visitorLoginEntry.dart';

class NotiFicationhome extends StatelessWidget {
  const NotiFicationhome({super.key});

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
  var token;
  GeneralFunction generalFunction = GeneralFunction();


  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    token = await fcm.getToken();
    print("🔥 Firebase Messaging Instance Info:");
    print("📌 Token:----78----xxx $token");

    NotificationSettings settings = await fcm.getNotificationSettings();
    print("🔔 Notification Permissions:");
    print("  - Authorization Status: ${settings.authorizationStatus}");
    print("  - Alert: ${settings.alert}");
    print("  - Sound: ${settings.sound}");
    print("  - Badge: ${settings.badge}");

    // ✅ Ensure notifications play default sound
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 New foreground notification received!");
      print("📦 Data Payload----563---xx--: ${message.data}");
      if (message.notification != null) {
      }
    });

    if (token != null && token!.isNotEmpty) {
      // Api call here
      print("------Call Api------");
      //notificationResponse(token);
      //var response = wait HrmsUpdateGsmidIos().hrmsupdateGsmid(context, firebaseToken, sContactNo)
    } else {
      print("🚨 No Token Received!");
    }
  }
  // Function to show Dialog
  void _showNotificationDialog(String title, String body) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            height: 200,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Notification Text
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  body,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                // Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        print("✅ Approved");
                      },
                      child: Text("Approve"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        print("❌ Rejected");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text("Reject"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupPushNotifications();
    // foreGroundNotification code
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle the foreground notification here
      print("Received message:---530-- ${message.notification?.title}");
      // You can show a dialog or display the notification in the UI

      _showNotificationDialog(message.notification!.title ?? "New Notification",
          message.notification!.body ?? "You have received a new message.");

    });
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
