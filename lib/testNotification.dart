import 'package:flutter/material.dart';


class NotificationHomeTesting extends StatelessWidget {
  final String payload;

  NotificationHomeTesting({required this.payload});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notification Details")),
      body: Center(
        child: Text(
          "Notification Data: $payload",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}


