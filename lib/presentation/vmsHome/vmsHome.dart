import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/generalFunction.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../services/CheckVisitorDetailsRepo.dart';
import '../login/loginScreen_2.dart';
import '../visitorList/visitorList.dart';
import '../visitorloginEntry/visitorLoginEntry.dart';
import 'package:audioplayers/audioplayers.dart';

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
  AudioPlayer player = AudioPlayer();
  bool isLoading = true; // logic
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
  var token,firebasetitle,firebasebody;
  var firebaseToken,iUserId;
  GeneralFunction generalFunction = GeneralFunction();

  void stopNotificationSound() {
  }
  //
  void playNotificationSound() async {
    await player.stop(); // Stop any previous sound
    await player.release(); // Release resources
    await player.setVolume(0.5);
    await player.play(AssetSource('sounds/coustom_sound.wav'), mode: PlayerMode.mediaPlayer);
  }

  Future<void> _stop() async {
    await player.stop();// Force stop the sound
  }
  // check user id
  getLocatDataBase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sContactNo2 = prefs.getString('sContactNo');
    iUserId = prefs.getString('iUserId');
    print("------294---xx---$iUserId");
    //firebaseToken = prefs.getString('firebaseToken').toString();
    if(iUserId!=null){
      checkNotifcationApi(iUserId);
    }else{
    }
  }
  // check notification api
  void checkNotifcationApi(iUserId) async {
    var  checkVisitorDetail = await CheckVisitorDetailsRepo().checkVisitorDetail(context,iUserId);
    result = '${checkVisitorDetail['Result']}';
    msg  = '${checkVisitorDetail['Msg']}';
    print("----resullt-------100-->>>--$result");
  }

  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    // await fcm.requestPermission();
    await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true, // Important for sounds
      provisional: false,
      sound: true, // Ensure this is true
    );
    token = await fcm.getToken();
    print("📌 Token:----78----xxx $token");
    //
    NotificationSettings settings = await fcm.getNotificationSettings();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📦 Data Payload----563---xx--: ${message.data}");
     // playNotificationSound();

      if (message.notification != null) {
        var sound = message.notification!.android?.sound ?? message.notification!.apple?.sound;
        print("🔔 Playing custom sound: $sound");
        playNotificationSound();
        _showNotificationDialog(message.notification!.title ?? "New Notification",
         message.notification!.body ?? "You have received a new message.");

      }
    });
  }
  // Function to show Dialog
  void _showNotificationDialog(String title, String body) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent accidental dismiss while stopping sound
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () async {
              await _stop(); // Ensure sound is completely stopped before closing

              if (Navigator.canPop(context)) {

                if(result=="1"){
                  print("----------151----------Visitor List--$result");
                }else{
                  print("----------153----------LoGIN Screnn---$result");
                }
              }

            },
            child: Container(
              height: 200,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) async {
      await _stop(); // Ensure sound stops even if user dismisses manually
    });
  }

  // handle Navigation
  void _handleNavigation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var iUserId = prefs.getString('iUserId');
    if (iUserId != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => VisitorList(payload:"")));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen_2()));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkForNotification();
    getLocatDataBase();
  }

  Future<void> checkForNotification() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? title = prefs.getString('notification_title');
    String? body = prefs.getString('notification_body');

    print("🔍 Retrieved Title----x-x-----xxx--: $title");
    print("🔍 Retrieved Body: $body");

    if (title != null) {
      await prefs.remove('notification_title');
      await prefs.remove('notification_body');
      // here You should hit api and check data is availabel or not
      if(iUserId!=null){
        // call api
        var  checkVisitorDetail = await CheckVisitorDetailsRepo().checkVisitorDetail(context,iUserId);
        print("-------checkVisitorDertails----$checkVisitorDetail");
        result = '${checkVisitorDetail['Result']}';
        msg  = '${checkVisitorDetail['Msg']}';
        //var result2="1";
        print('-----result----xxxxx----xxxxx--x-$result');
        setState(() {
        });
        if(result=="1"){

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {  // Ensure context is valid
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VisitorList(
                    payload: jsonEncode({"title": title, "body": body}),
                  ),
                ),
              );
            }
          });

        }else{
          displayToast("------Result--$result");
        }

      }else{
      }
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _phoneNumberController.dispose();
    passwordController.dispose();
    player.dispose();
    super.dispose();
  }
  void clearText() {
    _phoneNumberController.clear();
    passwordController.clear();
  }
  //WillPopScope(
  //onWillPop: () async => false,
  //child:
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: WillPopScope(
            onWillPop: () async => false,
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
                    top: 65,
                    left: 10,
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
                  //   top: 65,
                  //   left: 10,
                  //   child: Center(
                  //     child: Container(
                  //       height: 32,
                  //       //width: 140,
                  //       child: Image.asset(
                  //         'assets/images/Synergywhitelogo.png', // Replace with your image path
                  //       // Set height
                  //         fit: BoxFit.cover, // Ensures the image fills the given size
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  Positioned(
                    top: 120,
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
                                          onTap: () async{

                                            context.go('/VisitorLoginEntry');

                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             VisitorLoginEntry()));

                                            // Navigator.pushReplacement(
                                            //   context,
                                            //   MaterialPageRoute(builder: (context) => VisitorLoginEntry()),
                                            // );

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
                                      /// todo here Admin login comment its may be used in a future
                                      ///
                                      // SizedBox(width: 8), // Added better spacing
                                      // Expanded(
                                      //   child: GestureDetector(
                                      //     onTap: ()async{
                                      //       /// todo navigate loginScreen_2
                                      //
                                      //       context.go('/LoginScreen_2');
                                      //
                                      //       // Navigator.push(
                                      //       //     context,
                                      //       //     MaterialPageRoute(
                                      //       //         builder: (context) =>
                                      //       //             LoginScreen_2()));
                                      //
                                      //
                                      //       // Navigator.pushReplacement(
                                      //       //   context,
                                      //       //   MaterialPageRoute(builder: (context) => LoginScreen_2()),
                                      //       // );
                                      //
                                      //     },
                                      //     child: Container(
                                      //         height: 140,
                                      //         decoration: BoxDecoration(
                                      //           color: Colors.white,
                                      //           border: Border.all(color: Colors.black12, width: 1),
                                      //           borderRadius: BorderRadius.circular(10),
                                      //           boxShadow: [
                                      //             BoxShadow(
                                      //               color: Colors.white.withOpacity(0.2),
                                      //               //color: Colors.black12.withOpacity(0.2),
                                      //               blurRadius: 5,
                                      //               spreadRadius: 2,
                                      //               offset: Offset(0, 2),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //         child: Column(
                                      //           mainAxisAlignment: MainAxisAlignment.center,
                                      //           crossAxisAlignment: CrossAxisAlignment.center,
                                      //           children: [
                                      //             Center( // Centers the image
                                      //               child: SizedBox(
                                      //                 width: 50,
                                      //                 height: 50,
                                      //                 child: Image.asset(
                                      //                   'assets/images/exit.png',
                                      //                   fit: BoxFit.contain,
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //             const SizedBox(
                                      //               height: 5,
                                      //             ),
                                      //             const Text(
                                      //               "Admin Login",
                                      //               style: TextStyle(
                                      //                 color: Colors.black,
                                      //                 fontSize: 14,
                                      //               ),
                                      //             ),
                                      //           ],
                                      //         )
                                      //     ),
                                      //   ),
                                      // ),
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
