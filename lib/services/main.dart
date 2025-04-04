import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

import '../app/myapp.dart';

// Create an instance of FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  print("🔔 Background Notification Received: ${message.notification?.title}");
  showNotification(message);
}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  initializeNotifications(); // ✅ Initialize notifications
  createNotificationChannel(); // ✅ Create custom channel

  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

  runApp(MyApp());
  configLoading();
}

// ✅ Initialize Notifications
void initializeNotifications() {
  var androidSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var iosSettings = const DarwinInitializationSettings();
  var initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

  flutterLocalNotificationsPlugin.initialize(initSettings);
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
    sound: RawResourceAndroidNotificationSound('custom_sound'), // Ensure file exists
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


