import 'package:app_kopabali/src/views/authpage/forget_password/forgetpass_controller.dart';
import 'package:flutter/material.dart';
import 'package:app_kopabali/src/core/base_import.dart';

class ForgotPasswordView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
        final ForgetPasswordController forgetpasswordController =
      Get.put(ForgetPasswordController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              
              onPressed: () async {
                if (emailController.text.isEmpty) {
                  _showErrorDialog(context, 'Please enter your email.');
                } else {
                  await forgetpasswordController.resetPassword(
                      emailController.text, context);
                }
              },
              child: forgetpasswordController.isLoading
                  ? CircularProgressIndicator()
                  : Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
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
}
