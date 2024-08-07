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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Please enter your email address to\n receive a verification',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text('Email'),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Please enter your email address',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              validator: (value) {
                String pattern =
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                RegExp regex = RegExp(pattern);
                if (value!.isEmpty) {
                  return 'Please enter your email';
                } else if (!regex.hasMatch(value) || !value.endsWith('.com')) {
                  return 'Please enter a valid email.';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor("E97717"),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 120),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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
                    : Text(
                        'Reset Password',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
              ),
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
