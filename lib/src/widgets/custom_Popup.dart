import 'package:flutter/material.dart';

class CustomPopup {
  final BuildContext context;
  final String title;
  final String content;
  final String buttonText;
  final Color buttonColor;
  final Color buttonTextColor;

  CustomPopup({
    required this.context,
    required this.title,
    required this.content,
    this.buttonText = 'OK',
    this.buttonColor = const Color(0xFFE97717),
    this.buttonTextColor = Colors.white,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text(
            content,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 35),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: buttonColor,
                  border: Border(
                    top: BorderSide(color: Colors.orange[400]!),
                  ),
                ),
                child: TextButton(
                  child: Text(
                    buttonText,
                    style: TextStyle(color: buttonTextColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
