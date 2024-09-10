import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:aws_demo/common/services/notificationService.dart';
import 'package:aws_demo/models/JsonResult.dart';
import 'package:aws_demo/models/ModelProvider.dart';
import 'package:aws_demo/trips_planner_app.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:http/http.dart' as http;

import 'amplifyconfiguration.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  try {
    await _configureFCM();
  } on Exception {
    debugPrint("FCM configure failed.");
  }

  try {
    await _configureAmplify();
  } on AmplifyAlreadyConfiguredException {
    debugPrint('Amplify configuration failed.');
  }

  try {
    await NotificationService().init();
  } on Exception catch (e, s){
    debugPrint("Notification configure failed. $e");
    print('Stack trace:\n $s');
  }

  runApp(
    const ProviderScope(
      child: TripsPlannerApp(),
    ),
  );
}


Future<void> _configureAmplify() async {
  await Amplify.addPlugins([
    AmplifyAuthCognito(),
    AmplifyAPI(modelProvider: ModelProvider.instance),
  ]);
  await Amplify.configure(amplifyconfig);
}

Future<void> _configureFCM() async {

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // You may set the permission requests to "provisional" which allows the user to choose what type
  // of notifications they would like to receive once the user receives a notification.
  // final notificationSettings = await FirebaseMessaging.instance.requestPermission(provisional: true);

  // For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
  // final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  // if (apnsToken != null) {
    // APNS token is available, make FCM plugin API requests...
  // }

  final fcmToken = await FirebaseMessaging.instance.getToken();
  if(fcmToken != null) {
    debugPrint("fcmToken: $fcmToken");
    await registerTokenOnServer(fcmToken);
  }
}

Future<void> registerTokenOnServer(token) async {
  Future<JsonResult> jsonResult = registerToken(token);
  jsonResult.then((value) {
      debugPrint("jsonResult");
      debugPrint(value.toString());
  });
}

Future<JsonResult> registerToken(token) async {
  http.Response response = await http.post(
    Uri.parse('https://blog.xqu.ovh/register-user-token'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'userToken': token,
    }),
  );

  debugPrint("registerToken : ${response.statusCode}");
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return JsonResult.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}