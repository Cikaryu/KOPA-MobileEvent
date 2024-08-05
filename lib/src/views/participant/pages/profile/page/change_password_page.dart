import 'package:app_kopabali/src/views/participant/pages/profile/profile_controller.dart';
import 'package:app_kopabali/src/core/base_import.dart';

class ChangePasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
        final ProfileController changePasswordController =
      Get.put(ProfileController());

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
                  await changePasswordController.resetPassword(
                      emailController.text, context);
                }
              },
              child: changePasswordController.isLoading
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
