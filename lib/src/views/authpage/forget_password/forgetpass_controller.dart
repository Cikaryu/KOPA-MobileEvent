// ignore_for_file: unnecessary_overrides
import 'package:app_kopabali/src/core/base_import.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPasswordController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @override
  onInit() {
    super.onInit();
  }

  @override
  onReady() {
    super.onReady();
  }

  onGoBack() {
    Get.back();
  }

  void setLoading(bool value) {
    _isLoading = value;
    update();
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Password Reset'),
            content: Text('A password reset link has been sent to $email.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/signin');
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }
}
