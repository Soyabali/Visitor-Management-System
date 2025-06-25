import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:puri/presentation/login/loginScreen_2.dart';
import 'package:puri/presentation/loginaftersplace/loginaftersplace.dart';
import 'package:puri/presentation/screens/splash.dart';
import 'package:puri/presentation/visitorDashboard/visitorDashBoard.dart';
import 'package:puri/presentation/visitorList/visitorList.dart';
import 'package:puri/presentation/visitorloginEntry/visitorLoginEntry.dart';
import 'package:puri/presentation/vmsHome/vmsHome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); // ✅ Global Key

// Create an instance of FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point') // ✅ Required for background handlers
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  print("🔔 Background Notification Received: ${message.notification?.title}");

  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? title = message.notification?.title ?? "No Title";
  String? body = message.notification?.body ?? "No Body";

  await prefs.setString('notification_title', title);
  await prefs.setString('notification_body', body);

  print("✅ Stored Title: $title");
  print("✅ Stored Body: $body");
}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initializeNotifications(); // ✅ Initialize notifications
  createNotificationChannel(); // ✅ Create custom channel

  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
  // IOS TO BACKED NOTIFICATION handler
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("🔔 Notification Clicked: ${message.data}");

    String? title = message.notification?.title;
    String? body = message.notification?.body;

    if (title != null && body != null) {
      handleNotificationClick(jsonEncode({"title": title, "body": body}));
    }
  });

 runApp(MyApp());
  configLoading();
}


   /// todo this is a My App code
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       navigatorKey: navigatorKey, // ✅ Use Global Key
//       home: SplashView(),
//       builder: EasyLoading.init(),
//     );
//   }
// }
  //  todo this is a myApp  code with go_router
class MyApp extends StatelessWidget {
  final _router = GoRouter(
    navigatorKey: navigatorKey, // Keep your existing key
    initialLocation: '/',
    routes: [
      GoRoute(
        name: 'splace',
        path: '/',
        builder: (context, state) => SplashView(),
      ),
      GoRoute(
        name: 'Loginaftersplace',
        path: '/Loginaftersplace',
        builder: (context, state) => Loginaftersplace(),
      ),
      // visitorDeshBoard
      GoRoute(
        name: 'VisitorDashboard',
        path: '/VisitorDashboard',
        builder: (context, state) => VisitorDashboard(),
      ),
      // VmsHome
      GoRoute(
        name: 'VmsHome',
        path: '/VmsHome',
        builder: (context, state) => VmsHome(),
      ),
      // VisitorLoginEntry
      GoRoute(
        name: 'VisitorLoginEntry',
        path: '/VisitorLoginEntry',
        builder: (context, state) => VisitorLoginEntry(),
      ),
      // LoginScreen_2
      GoRoute(
        name: 'LoginScreen_2',
        path: '/LoginScreen_2',
        builder: (context, state) => LoginScreen_2(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: _router.routerDelegate,
      routeInformationParser: _router.routeInformationParser,
      routeInformationProvider: _router.routeInformationProvider,
      builder: EasyLoading.init(), // Retain EasyLoading
    );
  }
}


// ✅ Initialize Notifications
void initializeNotifications() {
  var androidSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var iosSettings = const DarwinInitializationSettings();
  var initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

  flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        handleNotificationClick(response.payload!);
      }
    },
    onDidReceiveBackgroundNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        handleNotificationClick(response.payload!);
      }
    },
  );
}

// Handles the notification click event
void handleNotificationClick(String payload) async {

  print("🔗 Notification Clicked with Data: $payload");

  try {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? iUserId = prefs.getString('iUserId');

    print('--------- Checking User ID ------------');

    // Determine navigation based on login status
    Widget destinationScreen;

    if (iUserId == null || iUserId.isEmpty) {
      print("⚠️ No User ID Found, navigating to LoginScreen");
      destinationScreen = LoginScreen_2();
    } else {
      print("✅ User Logged In: $iUserId, Navigating to VisitorList");
      destinationScreen = VisitorList(payload: payload);
    }

    // Ensure we have a valid navigation context
    if (navigatorKey.currentState == null) {
      print("⚠️ navigatorKey.currentState is null, cannot navigate.");
      return;
    }

    // Clear previous routes & navigate
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => destinationScreen),
          (Route<dynamic> route) => false, // Removes all previous routes
    );
  } catch (e, stackTrace) {
    print("❌ Error in handleNotificationClick: $e");
    print(stackTrace);
  }
}
// ✅ Create Custom Notification Channel for Android

void createNotificationChannel() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'custom_channel', // ID
    'Custom Notifications', // Name
    description: 'Channel for custom sound notifications',
    importance: Importance.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('coustom_sound'), // File name (without extension)
  );

  final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
  flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  await androidImplementation?.createNotificationChannel(channel);
}

// ✅ Show Local Notification
Future<void> showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'custom_channel', // Same ID as created above
    'Custom Sound Channel',
    channelDescription: 'Channel for custom sound notifications',
    importance: Importance.high,
    priority: Priority.high,
    sound: RawResourceAndroidNotificationSound('coustom_sound'), // Ensure file exists
    playSound: true,
  );

  const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
    sound: 'coustom_sound.wav', // Must match filename in iOS Resources
  );
  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidDetails, iOS: iosDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title ?? "New Alert",
    message.notification?.body ?? "This should play a custom sound",
    notificationDetails,
  );
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


