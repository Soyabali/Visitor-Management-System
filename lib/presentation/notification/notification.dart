import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/generalFunction.dart';
import '../../services/notificationRepo.dart';
import '../complaints/complaintHomePage.dart';
import '../otp/otpverification.dart';
import '../resources/app_text_style.dart';
import '../visitorDashboard/visitorDashBoard.dart';


class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white, // Change the color of the drawer icon here
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Map<String, dynamic>>? notificationList;

  String? sName, sContactNo;
  GeneralFunction generalFunction = GeneralFunction();
  getnotificationResponse() async {
    notificationList = await NotificationRepo().notification(context);
    print('------48----$notificationList');
    setState(() {
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getlocalvalue();
    getnotificationResponse();
    super.initState();
  }
  getlocalvalue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sName = prefs.getString('sName') ?? "";
      sContactNo = prefs.getString('sContactNo') ?? "";
      print("------148---$sName");
      print("------1149---$sContactNo");
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
              child: Image.asset("assets/images/backtop.png",

              ),
            ),
          ),
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              'Notifications',
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
          //       'Notification',
          //       style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          //   //centerTitle: true,
          //   elevation: 0, // Removes shadow under the AppBar
          // ),
        //  drawer: generalFunction.drawerFunction(context,'$sName','$sContactNo'),
         // drawer: generalFunction.drawerFunction_2(context,"$sCitizenName","$sContactNo"),
    // WillPopScope(
    // onWillPop: () async => false,
    //       child:
          body: WillPopScope(
            onWillPop: ()async =>false,
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 15),
                    child: Container(
                      height: MediaQuery.of(context).size.height,

                      child: ListView.separated(
                          itemCount: notificationList != null ? notificationList!.length : 0,
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(); // Example separator, you can customize this
                          },
                          itemBuilder: (context, index) {
                            return  SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Container(
                                      child: const Icon(
                                        Icons.notification_important, size: 25, color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(notificationList?[index]['sTitle'].toString() ?? '',
                                          style: AppTextStyle
                                              .font14penSansExtraboldBlack45TextStyle
                                        // style: const TextStyle(
                                        //                       fontFamily: 'Montserrat',
                                        //                       color: Color(0xff3f617d),
                                        //                       fontSize: 14.0,
                                        //                       fontWeight: FontWeight.bold),

                                                        ),
                                      SizedBox(height: 2),
                                      Container(
                                        width: MediaQuery.of(context).size.width - 32,
                                        child: Text(
                                          notificationList?[index]['sNotification'].toString() ?? '',
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.start,
                                            style: AppTextStyle
                                                .font14penSansExtraboldBlackTextStyle
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.calendar_month,size:18,
                                          color: Color(0xff3f617d),),
                                          SizedBox(width: 5),
                                          Text(notificationList?[index]['dRecivedAt'].toString() ?? '',
                                              style: AppTextStyle
                                                  .font14penSansExtraboldBlackTextStyle
                                            // style: const TextStyle(
                                            //     fontFamily: 'Montserrat',
                                            //     color: Color(0xff3f617d),
                                            //     fontSize: 14.0,
                                            //     fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          )
                            );
                          }
                      ),
                    ),
                  )

                  ]
                ),
              ),
            ),
          )


    );


  }
}
