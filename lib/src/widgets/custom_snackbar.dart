import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static void show(
    BuildContext buildContext, {
    required String title,
    required String message,
    SnackPosition position = SnackPosition.BOTTOM,
    double opacity = 0.8,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: Colors.white.withOpacity(opacity),
      colorText: Colors.white,
      titleText: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold), // Bold title
      ),
      messageText: Text(
        message,
        style: TextStyle(fontSize: 14), // Regular message
      ),
      duration: Duration(seconds: 3),
      isDismissible: true,
    );
  }
}
