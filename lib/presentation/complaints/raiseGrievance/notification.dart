import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/notificationRepo.dart';
import '../../visitorDashboard/visitorDashBoard.dart';


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
  // get api response
  getnotificationResponse() async {
    notificationList = await NotificationRepo().notification(context);
    setState(() {
    });
    print("------45--xx---->>>>>$notificationList");
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
          body: Container(
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
                                const Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: Icon(
                                    Icons.notification_important, size: 30, color: Colors.red,),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(notificationList?[index]['sTitle'].toString() ?? '',
                                      style: const TextStyle(
                                                            fontFamily: 'Montserrat',
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                    SizedBox(height: 2),
                                    Container(
                                      width: MediaQuery.of(context).size.width - 32,
                                      child: Text(
                                        notificationList?[index]['sNotification'].toString() ?? '',
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Colors.black,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(notificationList?[index]['dReceivedAt'].toString() ?? '',
                                      style: const TextStyle(
                                                            fontFamily: 'Montserrat',
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight.bold),
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
          )
      ),
    );

  }
}
