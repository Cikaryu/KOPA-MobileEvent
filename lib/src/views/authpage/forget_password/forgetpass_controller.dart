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
          title: Text(
            'Invalid Email Address',
            textAlign: TextAlign.center,
          ),
          content: Text("Please enter your correct email !",
              textAlign: TextAlign.center),
          actions: <Widget>[
            TextButton(
              child: Center(
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: HexColor("E97717"),
                        border: Border(
                          top: BorderSide(color: Colors.orange[400]!),
                        ),
                      ),
                      child: Text(
                        'OK',
                        style: TextStyle(color: Colors.white),
                      ))),
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
            title: Text(
              'Password Reset',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: Text('A password reset link has been sent to \n\n$email.',
                textAlign: TextAlign.center),
            actions: <Widget>[
              TextButton(
                child: Center(
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: HexColor("E97717"),
                        border: Border(
                          top: BorderSide(color: Colors.orange[400]!),
                        ),
                      ),
                      child: Text(
                        'OK',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
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
