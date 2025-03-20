import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/generalFunction.dart';
import '../../services/CheckVisitorDetailsRepo.dart';
import '../../services/RecentVisitorRepo.dart';
import '../../services/hrmsupdategsmidios.dart';
import '../complaints/raiseGrievance/notification.dart';
import '../login/loginScreen_2.dart';
import '../resources/app_text_style.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../visitorEntry/visitorEntry.dart';
import '../visitorExit/VisitorExit.dart';
import '../visitorList/visitorList.dart';
import '../visitorReport/reimbursementstatus.dart';
import '../visitorReport/visitorReport.dart';
import '../visitorSetting/visitorSetting.dart';
import 'horizontallist.dart';


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
  var loginMap;
  double? lat, long;
  String? sUserName,sContactNo;
  var token,firebaseToken,iUserId;
  var firebasetitle,firebasebody;
  GeneralFunction generalFunction = GeneralFunction();


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
    recentVisitorList = await RecentVisitorRepo().recentVisitor(
     context,
    );
    print('------73------sss---->>>>>>>>>--xxxxx--$recentVisitorList');
    setState(() {
      isLoading = false;
    });
  }
   // firebase token code
  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();

    token = await fcm.getToken();

    // get a local database
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //sUserName = prefs.getString('sUserName');

    iUserId = prefs.getString('iUserId');

    print("🔥 Firebase Messaging Instance Info:");
    print("📌 Token:----78----xxx $token");
    print("📌 Contact No:----78----xxx $sContactNo");

    // call api here
    var hrmsUpdateGsmid = await HrmsUpdateGsmidIos().hrmsupdateGsmid(context,iUserId,token);
    print("----172--HRMSUpdateGsmid-->>>>>>>>---xx---$hrmsUpdateGsmid");

    // to store token in a sharedPreference
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('firebaseToken',token).toString();

    // if token is not null then store in a sharedPreference

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
        // _showNotification(message.notification!);
        // show a DialogBox
        // _showNotificationDialog(message.notification!.title ?? "New Notification",
        //     message.notification!.body ?? "You have received a new message.");

      }
    });

    if (token != null && token!.isNotEmpty) {
      // Api call here
      print("------Call Api------");

      //  notificationResponse(token);

    } else {
      print("🚨 No Token Received!");
    }
  }
  void checkNotifcationApi(iUserId) async{
    var  checkVisitorDetail = await CheckVisitorDetailsRepo().checkVisitorDetail(context,iUserId);
    result = '${checkVisitorDetail['Result']}';
    msg  = '${checkVisitorDetail['Msg']}';

    print("----resullt---->>>--$result");
  }

  @override
  void initState() {
    // TODO: implement initState
    setupPushNotifications();
    // getLocatDataBase();
    getEmergencyTitleResponse();
    getLocatDataBase();
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle the foreground notification here
      print("Received message:---530-- ${message.notification?.title}");

      firebasetitle = '${message.notification?.title}';
      firebasebody = '${message.notification?.body}';


      print("-----216----firebasetitle: $firebasetitle");
      print("-----217----firebasebody: $firebasebody");

      // You can show a dialog or display the notification in the UI
      // dialog

      // showDialog(
      //   context: context,
      //   builder: (_) =>
      //       AlertDialog(
      //         title: Text(message.notification?.title ?? 'New Notification',
      //             style: AppTextStyle.font12OpenSansRegularBlackTextStyle),
      //         content: Text(
      //             message.notification?.body ?? 'You have a new message',
      //             style: AppTextStyle.font12OpenSansRegularBlackTextStyle),
      //       ),
      // );

      _showNotificationDialog(message.notification!.title ?? "New Notification",
          message.notification!.body ?? "You have received a new message.");

    });

  }
  // foregroudn dasdboard
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

  getLocatDataBase() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // sUserName = prefs.getString('sUserName');
     //sContactNo = prefs.getString('sContactNo');
     iUserId = prefs.getString('iUserId');
     //firebaseToken = prefs.getString('firebaseToken').toString();
     if(iUserId!=null){
       checkNotifcationApi(iUserId);
     }else{
       displayToast("No useerId--");
     }
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
    return Scaffold(
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
             // if(iUserId!=null){
             //   // call api
             //   var  checkVisitorDetail = await CheckVisitorDetailsRepo().checkVisitorDetail(context,iUserId);
             //    print("-------checkVisitorDertails----$checkVisitorDetail");
             //
             //    // if(result=="1"){
             //    //   // Open a new Widget to show a Detail
             //    //   // VisitorList
             //    //   Navigator.push(
             //    //     context,
             //    //     MaterialPageRoute(builder: (context) => VisitorList()),
             //    //   );
             //    // }else{
             //    //   //
             //    // }
             //
             //
             //
             // }else{
             //   displayToast("There is not a UserId");
             // }
             if(result=="1"){
                 Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => VisitorList()),
                 );
              // displayToast(msg);
             }else{
               displayToast(msg);
             }
             // print("-----notification---");
            },
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: Text(
                (result == null || result.toString().isEmpty) ? "0" : result.toString(), // Change this to your notification count
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        //IconButton
        //IconButton
        // IconButton(
        //   icon: const Icon(Icons.notification_add,
        //   ),
        //   tooltip: 'Setting Icon',
        //   onPressed: () {},
        // ),
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
            Positioned(
              top: 25,
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

                                               print("------261--images---$images");
                                               print("------262--names---$names");
                                               openFullScreenDialog(
                                                   context,
                                                   images,
                                                   names
                                                 // 'https://your-image-url.com/image.jpg', // Replace with your image URL
                                                 // 'Bill Date: 01-01-2024', // Replace with your bill date
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
                                           // child: Container(
                                           //   width: 60, // Width of each card
                                           //   padding: const EdgeInsets.all(8), // Inner padding
                                           //   child: Column(
                                           //     mainAxisAlignment: MainAxisAlignment.center,
                                           //     children: [
                                           //       Image.network(
                                           //         'http://upegov.in/VistorManagementSystemApis/VisitorImages/image/120320251615575987picker_0B6F0294-B222-428D-8729-4BBF22E4B7BD-1857-000000824320E6B3.jpg', // Replace with your image URL
                                           //         //width: 25,
                                           //         height: 44,
                                           //         fit: BoxFit.contain,
                                           //       ),
                                           //       const SizedBox(height: 5), // Space between image and text
                                           //       const Text(
                                           //         "Title", // Replace with dynamic text
                                           //         style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                           //         textAlign: TextAlign.center,
                                           //       ),
                                           //     ],
                                           //   ),
                                           // ),
                                         ),
                                       );
                                     },
                                   ),
                                   // child: Padding(
                                   //   padding: const EdgeInsets.symmetric(horizontal: 5), // Optional padding
                                   //   child: HorizontalCardList(), // Calling the HorizontalCardList class
                                   // ),
                               ),
                               // Container(
                               //   height: 65,
                               //   color: Colors.green,
                               // )
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
                                           Text(
                                             "Report",
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
                                   //         //color: Colors.black12.withOpacity(0.2),
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
                                   //         'assets/images/report.png',
                                   //         fit: BoxFit.contain,
                                   //       ),
                                   //     ),
                                   //   ),
                                   // ),
                                 ),
                               ),
                               SizedBox(width: 8), // Added better spacing
                               Expanded(
                                 child: GestureDetector(
                                   onTap: (){
                                     //   VisitorSetting    NotificationPage
                                     // Navigator.push(
                                     //   context,
                                     //   MaterialPageRoute(builder: (context) => VisitorSetting()),
                                     // );

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
                                           SizedBox(
                                             height: 5,
                                           ),
                                           Text(
                                             "Notification",
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
                                   //         'assets/images/setting.png',
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
                         // const Positioned(
                         //   top: 310,
                         //   left: 0,
                         //   right: 0,
                         //   child: Row(
                         //     children: [
                         //       Expanded(
                         //         child: Padding(
                         //           padding: EdgeInsets.only(left: 20),
                         //           child: Align(
                         //             alignment: Alignment.centerLeft,
                         //             child: Text(
                         //               "Report",
                         //               style: TextStyle(
                         //                 color: Colors.black,
                         //                 fontSize: 14,
                         //               ),
                         //             ),
                         //           ),
                         //         ),
                         //       ),
                         //       Expanded(
                         //         child: Padding(
                         //           padding: EdgeInsets.only(left: 5),
                         //           child: Align(
                         //             alignment: Alignment.centerLeft,
                         //             child: Text(
                         //               "Setting",
                         //               style: TextStyle(
                         //                 color: Colors.black,
                         //                 fontSize: 14,
                         //               ),
                         //             ),
                         //           ),
                         //         ),
                         //       ),
                         //     ],
                         //   ),
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
