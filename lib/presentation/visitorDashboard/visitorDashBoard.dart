import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/generalFunction.dart';
import '../../main.dart';
import '../../services/CheckVisitorDetailsRepo.dart';
import '../../services/RecentVisitorRepo.dart';
import '../../services/hrmsupdategsmidios.dart';
import '../../services/vmsUpdateGsmId.dart';
import '../complaints/raiseGrievance/notification.dart';
import '../login/loginScreen_2.dart';
import '../resources/app_text_style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../visitorEntry/visitorEntry.dart';
import '../visitorExit/VisitorExit.dart';
import '../visitorList/visitorList.dart';
import '../visitorReport/reimbursementstatus.dart';
import 'package:audioplayers/audioplayers.dart';

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
  var result2;
  var loginMap;
  double? lat, long;
  String? sUserName,sContactNo;
  var token,firebaseToken,iUserId;
  var firebasetitle,firebasebody;
  var visitorId,visitorMsg;
  GeneralFunction generalFunction = GeneralFunction();
  AudioPlayer player = AudioPlayer();

  void playNotificationSound() async {
    await player.stop(); // Stop any previous sound
    await player.release(); // Release resources
    await player.setVolume(0.5);
    await player.play(AssetSource('sounds/coustom_sound.wav'), mode: PlayerMode.mediaPlayer);

    // Automatically stop the sound after 2 seconds
    Future.delayed(Duration(seconds: 2), () async {
      await player.stop();
    });
  }


  Future<void> _stop() async {
    await player.stop();// Force stop the sound
  }

  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    token = await fcm.getToken();
    print("📌 Token: $token");
    // call Gsmid
    updateGsmid();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📦 Data Payload: ${message.data}");
      playNotificationSound();

      if (message.notification != null) {
        var title = message.notification!.title ?? "New Notification";
        var body = message.notification!.body ?? "You have received a new message";

        print("🔔 Foreground Notification Received: $title - $body");
        playNotificationSound();
        // Show notification dialog (User must click "OK" to proceed)
        _showNotificationDialog(title, body);
      }
    });
  }

  updateGsmid()async{
    if(token!=null){
      var UpdateGsmid = await VmsUpdateGsmid().vmsUpdateGsmid(context,token);
      print("-------Update Gsmid--------128-----$UpdateGsmid");
    }else{

    }
  }

// Show dialog with an "OK" button to navigate
  void _showNotificationDialog(String title, String message) {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false, // Prevents user from closing manually
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Rounded Dialog
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent], // Attractive gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Notification Icon
                Icon(Icons.notifications_active, size: 50, color: Colors.white),
                SizedBox(height: 10),

                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),

                // Message
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 15),

                // Custom Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Rounded button
                    ),
                    backgroundColor: Colors.amberAccent, // Attractive button color
                    elevation: 5,
                  ),
                  onPressed: () {
                    _stop(); // Stop sound
                    // call api
                    getLocatDataBase();
                    Navigator.pop(context); // Close Dialog
                    _navigateToVisitorList(title, message); // Navigate to new screen
                  },
                  child: Text(
                    "View",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToVisitorList(String? title, String? body)async {
    if (navigatorKey.currentContext != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? iUserId = prefs.getString('iUserId');
      if (iUserId == null || iUserId.isEmpty) {
        // If user is not logged in, navigate to Login Page
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => LoginScreen_2(),
          ),
        );
      } else {
        // User is logged in, check result2 condition
        if (result2 == "1") {
          print("-----result----$result2");
          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => VisitorList(
                payload: jsonEncode({"title": title, "body": body}),
              ),
            ),
          );
        } else {
          displayToast(msg);
        }
      }
    }
  }

  // full Screen Dialog
  void openFullScreenDialog(
      BuildContext context, String imageUrl, String billDate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Makes the dialog full screen
          insetPadding: EdgeInsets.all(0),
          child: Stack(
            children: [
              // Fullscreen Image
              Positioned.fill(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover, // Adjust the image to fill the dialog
                ),
              ),

              // White container with Bill Date at the bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.white.withOpacity(0.8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          billDate,
                          style:
                          AppTextStyle.font12OpenSansRegularBlackTextStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Close button in the bottom-right corner
              Positioned(
                right: 16,
                bottom: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent,
                    ),
                    padding: EdgeInsets.all(8),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  getEmergencyTitleResponse() async {
    recentVisitorList = await RecentVisitorRepo().recentVisitor(context);
    print('------324------sss---->>>>>>>>>--xxxxx--$recentVisitorList');
    setState(() {
      isLoading = false;
    });
  }
   // firebase token code

  @override
  void initState() {
    setupPushNotifications();
    getEmergencyTitleResponse();
    getLocatDataBase();
    backgroundNotification();
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Foreground Notification Received");
      getLocatDataBase(); // Call when Foreground Notification Arrives
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📩 Background Notification Clicked");
      getLocatDataBase(); // Call when User Clicks on Background Notification
    });

    //WidgetsBinding.instance.addObserver(this as WidgetsBindingObserver);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (state == AppLifecycleState.resumed) {
      print("🔄 App is now active");

      bool shouldNavigate = prefs.getBool('navigateWhenActive') ?? false;

      if (shouldNavigate) {
        prefs.setBool('navigateWhenActive', false); // Reset flag
        getLocatDataBase(); // ✅ Perform navigation when app is active
      }
    }
  }
  // background Notification

  Future<void> backgroundNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? title = prefs.getString('notification_title');
    String? body = prefs.getString('notification_body');

    var sContactNo2 = prefs.getString('sContactNo');
    iUserId = prefs.getString('iUserId');

    print("--------xxxxxxx-----------xxxxxxxxx-------$result");

    if (result != null && result.toString().trim() == "1") {
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
     // print("✅ Condition Matched: visitorId is 1");

    } else {
      print("--------xxxxxxx-----------xxxxxxxxx-------$result");
     // print("❌ Condition Not Matched: visitorId is not 1");
    }
  }

  getLocatDataBase() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
      iUserId = prefs.getString('iUserId');
     sUserName = prefs.getString('sUserName');
     sContactNo = prefs.getString('sContactNo');
      if(iUserId!=null){
        checkVisitorDetail(iUserId);
      }

  }
  checkVisitorDetail(iUserId)async{
    var  checkVisitorDetail = await CheckVisitorDetailsRepo().checkVisitorDetail(context,iUserId);
    print("-------checkVisitorDertails----$checkVisitorDetail");
    setState(() {
      result = '${checkVisitorDetail['Result']}';
      // result2
      result2 = '${checkVisitorDetail['Result']}';
      msg  = '${checkVisitorDetail['Msg']}';
    });
    print('-------406---------Result-----$result');
    print('-------407---------msg-----$msg');
  }

  // token forward api
  notificationResponse(token) async {
    var   Notiresponse = await HrmsUpdateGsmidIos().hrmsupdateGsmid(context,firebaseToken,sContactNo);
    print("-------notification Response----$Notiresponse");
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
       // debugShowCheckedModeBanner: false,
        appBar: AppBar(title: Text("VMS"), actions: <Widget>[
        Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications,size: 30,color: Colors.red,),
              tooltip: 'Setting Icon',
              onPressed: () async {
                  if(iUserId!=null){
                 // call api
                 var  checkVisitorDetail = await CheckVisitorDetailsRepo().checkVisitorDetail(context,iUserId);
                  print("-------checkVisitorDertails----$checkVisitorDetail");
                 result = '${checkVisitorDetail['Result']}';
                 msg  = '${checkVisitorDetail['Msg']}';

                 print('-----result----xxxxx----xxxxx--x-$result');
                 setState(() {
                 });
                 if(result=="1"){
                    // Open a new Widget to show a Detail
                    // VisitorList
                    result=null;

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VisitorList(payload:"")),
                    );
                    // CheckVisitorDetailsRepo().checkVisitorDetail(context,iUserId);
                  }else{
                    displayToast(msg);
                  }

               }else{
                 displayToast("There is not a UserId");
               }
              },
            ),
        ],

        ),
      ),
        ],),
        drawer: generalFunction.drawerFunction_2(context,"$sUserName","$sContactNo"),
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
              // Positioned(
              //   top: 25,
              //   left: 15,
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
                top: 25,
                left: 15,
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
                top: 45,
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
                top: 245,
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
                        height: 440,
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
                                     "Recent Visitors Detail",
                                     style: TextStyle(
                                       color: Colors.black45, // Text color
                                       fontSize: 16, // Font size
                                       fontWeight: FontWeight.bold, // Bold text
                                     ),
                                   ),
                                 ),
                                 SizedBox(height: 5,),
                                 Container(
                                     height: 70,
                                     decoration: BoxDecoration(
                                       color: Colors.white,
                                       border: Border.all(color: Colors.black12, width: 1),
                                       borderRadius: BorderRadius.circular(2),
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
                                     child: ListView.builder(
                                       scrollDirection: Axis.horizontal, // Horizontal scrolling
                                       itemCount: recentVisitorList?.length ?? 0, // Number of items
                                       itemBuilder: (context, index) {
                                         return Padding(
                                           padding: const EdgeInsets.symmetric(horizontal: 2), // Spacing between cards
                                           child: Card(
                                             elevation: 4, // Shadow effect
                                             shape: RoundedRectangleBorder(
                                               borderRadius: BorderRadius.circular(4), // Rounded corners
                                             ),
                                             child: InkWell(
                                               onTap: (){
                                                 var images = recentVisitorList![index]['sVisitorImage'];
                                                 var names = recentVisitorList![index]['sVisitorName'];

                                                 openFullScreenDialog(
                                                     context,
                                                     images,
                                                     names
                                                     );
                                                 },
                                               child: Container(
                                                 width: 60, // Fixed width of the container
                                                 height: 68, // Adjusted height for proper layout
                                                 padding: const EdgeInsets.symmetric(vertical: 5), // Balanced padding
                                                 child: Column(
                                                   mainAxisAlignment: MainAxisAlignment.center,
                                                   children: [
                                                     Expanded(
                                                       child: Image.network(
                                                         recentVisitorList![index]['sVisitorImage'],
                                                         width: double.infinity, // Image adjusts to container width
                                                         //fit: BoxFit.contain,
                                                         fit: BoxFit.fill,
                                                       ),
                                                     ),
                                                     const SizedBox(height: 2), // Space between image and text
                                                     Text(
                                                       recentVisitorList![index]['sVisitorName'], // Replace with dynamic text
                                                       style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500), // Text size 10
                                                       textAlign: TextAlign.center,
                                                       maxLines: 1, // Ensures text doesn't overflow
                                                       overflow: TextOverflow.ellipsis, // Adds "..." if text is too long
                                                     ),
                                                   ],
                                                 ),
                                               ),
                                             )
                                             ,

                                           ),
                                         );
                                       },
                                     ),
                                 ),
                               ],
                             )
                           ),
                           Positioned(
                             top: 140,
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
                                             "Entry",
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
                                       var name = "Exit";
                                       Navigator.push(
                                         context,
                                         MaterialPageRoute(builder: (context) => VisitorExitScreen(name:name)),
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
                                               "Exit",
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

                           Positioned(
                             top: 290,
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
                                         MaterialPageRoute(builder: (context) => Reimbursementstatus()),
                                       );
                                     },
                                     child:  Container(
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
                                                   'assets/images/report.png',
                                                   fit: BoxFit.contain,
                                                 ),
                                               ),
                                             ),
                                             SizedBox(
                                               height: 5,
                                             ),
                                             const Text(
                                               "Report",
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
                                       Navigator.push(
                                         context,
                                         MaterialPageRoute(builder: (context) => NotificationPage()),
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
                                                   'assets/images/ic_announcement.PNG',
                                                   fit: BoxFit.contain,
                                                 ),
                                               ),
                                             ),
                                             const SizedBox(
                                               height: 5,
                                             ),
                                             const Text(
                                               "Notification",
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
