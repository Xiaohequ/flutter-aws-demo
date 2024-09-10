import 'package:aws_demo/common/services/notificationService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationWidget extends StatefulWidget {
  Widget child;

  NotificationWidget({required this.child});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationWidget> {
  late FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();

    debugPrint("initState notificationWidget");

    messaging = FirebaseMessaging.instance;

    // Demander la permission pour les notifications (iOS)
    FirebaseMessaging.instance.requestPermission();

    // Gérer les messages lorsqu'ils sont reçus en arrière-plan
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("FirebaseMessaging.onMessage");

      //WidgetsBinding.instance.addPostFrameCallback((_) {
        //_showAlertDialog(message.notification?.title, message.notification?.body);
        //});
      showLocalNotification(message.notification?.title, message.notification?.body);
    });

    // Gérer les messages lorsque l'application est en arrière-plan ou terminée
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("FirebaseMessaging.onMessageOpenedApp");
      //WidgetsBinding.instance.addPostFrameCallback((_) {
      //_showAlertDialog(message.notification?.title, message.notification?.body);
      //});
      showLocalNotification(message.notification?.title, message.notification?.body);
    });
  }


  static final AndroidNotificationDetails androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      "channelId",
      "channelName",
      channelDescription: "Description", //Required for Android 8.0 or after
      importance: Importance.high,
      priority: Priority.high
  );

  final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

  Future<void> showLocalNotification(String? title, String? content) async{
    debugPrint("showLocalNotification, $title, $content");
    await NotificationService.flutterLocalNotificationsPlugin.show(
        0,
        "$title",
        "$content",
        platformChannelSpecifics,
        payload: 'data');
  }

  void _showAlertDialog(BuildContext context, String? title, String? content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? "Notification"),
          content: Text(content ?? "Vous avez reçu une notification."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: widget.child,
    );
  }
}