import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:puri/provider/todo_provider.dart';
import '../main.dart';
import '../presentation/resources/noInternet.dart';
import '../presentation/resources/routes_managements.dart';
import '../presentation/resources/theme_manager.dart';
import '../provider/bindComplaintProvider.dart';


class MyApp extends StatefulWidget {

  MyApp._internal(); // private named constructor

  int appState = 0;

  static final MyApp instance = MyApp._internal(); // single instance -- singleton
  factory MyApp() => instance; // factory for the class instance

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // bool activeConnection = false;
  // String T = "";
  // Future checkUserConnection() async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       setState(() {
  //         activeConnection = true;
  //         T = "Turn off the data and repress again";
  //       });
  //     }
  //   } on SocketException catch (_) {
  //     setState(() {
  //       activeConnection = false;
  //       T = "Turn On the data and repress again";
  //     });
  //   }
  // }
  bool activeConnection = false;
  String connectionType = "No Internet";

  Future<void> checkUserConnection() async {
    try {
      // Check connectivity type
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        setState(() {
          activeConnection = false;
          connectionType = "No Internet";
        });
      } else {
        // Check actual internet access
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          setState(() {
            activeConnection = true;
            connectionType = connectivityResult == ConnectivityResult.wifi
                ? "Connected to Wi-Fi"
                : "Connected to Mobile Data";
          });
        }
      }
    } on SocketException catch (_) {
      setState(() {
        activeConnection = false;
        connectionType = "No Internet Access";
      });
    }
  }

  @override
  void initState() {
    checkUserConnection();
    super.initState();
  }

  @override
  void didChangeDependencies() {
   // _appPreferences.getLocal().then((local) => {context.setLocale(local)});
    super.didChangeDependencies();
  }
  void configLoading() {

    EasyLoading.instance

      ..displayDuration = const Duration(milliseconds: 2000)

      ..indicatorType = EasyLoadingIndicatorType.fadingCircle

      ..loadingStyle = EasyLoadingStyle.custom

      ..indicatorSize = 45.0

      ..radius = 10.0

      ..progressColor = Colors.white

      ..backgroundColor = Colors.black

      ..indicatorColor = Colors.white

      ..textColor = Colors.white

      ..maskColor = Colors.blue.withOpacity(0.5)

      ..userInteractions = false

      ..dismissOnTap = false;
  }

  @override
  Widget build(BuildContext context) {
    return activeConnection
        ? MultiProvider(
      providers: [
        ListenableProvider<TempleProvider>(create: (_) => TempleProvider()),
        ChangeNotifierProvider<BindComplaintProvider>(
            create: (_) => BindComplaintProvider()),
        // ListenableProvider<PendingPhotoProvider>(
        //     create: (_) => PendingPhotoProvider()),
        // ListenableProvider<ReportUploadProvider>(
        //     create: (_) => ReportUploadProvider()),
        // ListenableProvider<PendingProvider>(
        //     create: (_) => PendingProvider()),
        // ListenableProvider<CompleteListProvider>(
        //     create: (_) => CompleteListProvider()),
        // ListenableProvider<ParamsProviderCom>(
        //     create: (_) => ParamsProviderCom()),
        // ListenableProvider<GetLecParametersProvider>(
        //     create: (_) => GetLecParametersProvider()),
        // ListenableProvider<ReportDownlodeProvider>(
        //     create: (_) => ReportDownlodeProvider()),
      ],//ReportDownlodeProvider
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: getApplicationTheme(),
        initialRoute: Routes.splashRoute,
        builder: EasyLoading.init(),
        onGenerateRoute: RouteGenerator.getRoute,
      ),
    )
        : MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoInternet(),
    );
  }
}


