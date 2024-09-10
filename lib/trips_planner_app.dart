import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:aws_demo/common/navigation/router/router.dart';
import 'package:aws_demo/common/ui/notification_widget.dart';
import 'package:aws_demo/common/ui/show_notification_widget.dart';
import 'package:aws_demo/common/utils/colors.dart' as constants;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class TripsPlannerApp extends StatefulWidget {
  const TripsPlannerApp({
    super.key,
  });

  @override
  State<TripsPlannerApp> createState(){
    return _TripsPlannerAppState();
  }
}

class _TripsPlannerAppState extends State<TripsPlannerApp> {

  // In this example, suppose that all messages contain a data field with the key 'type'.
  Future<void> setupInteractedMessage() async {
    debugPrint("setupInteractedMessage");
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    //foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }

      print(message.notification?.body);

      showAlertDialog(message.notification?.body);
    });
  }

  void showAlertDialog(message){

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Annuler"),
      onPressed:  () {},
    );
    Widget continueButton = TextButton(
      child: Text("Continuer"),
      onPressed:  () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alerte"),
      content: Text(message),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog

    /*showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );*/

    Navigator.push(context, MaterialPageRoute(builder: (context) => ShowNotificationWidget(message)),);
  }


  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
  }

  void _handleMessage(RemoteMessage message) {
    debugPrint("message received ${message.category}");
    if (message.data['type'] == 'alert') {
      //Navigator.pushNamed(context, '/chat',
      //  arguments: ChatArguments(message),
      //);
      var txtMessage = message.data["message"];
      if(txtMessage != null){
        debugPrint("message = $txtMessage");
      }
    }
  }


  @override
  void initState() {
    super.initState();

    debugPrint("initState");

    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    //setupInteractedMessage();
  }

@override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MaterialApp.router(
        routerConfig: router,
          builder: (context, child) {
            return NotificationWidget(
              child: Authenticator.builder()(context, child),
            );
        },
        theme: ThemeData(
          colorScheme:
          ColorScheme.fromSwatch(primarySwatch: constants.primaryColor)
              .copyWith(
            background: const Color(0xff82CFEA),
          ),
        ),
      ),
    );
  }
}