
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService{
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("launch_background");

    // final IOSInitializationSettings initializationSettingsIOS =
    // IOSInitializationSettings(
    //   requestSoundPermission: false,
    //   requestBadgePermission: false,
    //   requestAlertPermission: false,
    //   onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    // );

    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: null,
        macOS: null);


    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: selectNotification);
  }

  selectNotification(NotificationResponse details) {
    //Handle notification tapped logic here
  }
}