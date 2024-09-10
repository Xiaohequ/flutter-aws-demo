import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowNotificationWidget extends StatelessWidget {
  final message;

  ShowNotificationWidget(this.message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: Center(
        child: Text(this.message),
      ),
    );
  }
}