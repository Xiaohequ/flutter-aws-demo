import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
   Color bgColor;
   String title;
   String message;
   String positiveBtnText;
   String negativeBtnText;
   Function onPostivePressed;
   Function onNegativePressed;
   double circularBorderRadius;

  CustomAlertDialog({
    required this.title,
    required this.message,
    this.circularBorderRadius = 15.0,
    this.bgColor = Colors.white,
    this.positiveBtnText = "Ok",
    this.negativeBtnText = "Annuler",
    required this.onPostivePressed,
    required this.onNegativePressed,
  })  : assert(bgColor != null),
        assert(circularBorderRadius != null);

  @override
  Widget build(BuildContext context) {
    Widget negativeButton = TextButton(
      child: Text(positiveBtnText),
      onPressed: () {
        Navigator.of(context).pop();
        if (onNegativePressed != null) {
          onNegativePressed();
        }
      },
    );

    Widget positivebutton = TextButton(
      child: Text(positiveBtnText),
      //textColor: Theme.of(context).accentColor,
      onPressed: () {
        if (onPostivePressed != null) {
          onPostivePressed();
        }
      },
    );

    return AlertDialog(
      title: title != null ? Text(title) : null,
      content: message != null ? Text(message) : null,
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularBorderRadius)),
      actions: [
        negativeButton,
        positivebutton,
      ],
    );
  }
}