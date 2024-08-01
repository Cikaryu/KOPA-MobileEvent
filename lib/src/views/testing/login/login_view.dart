import 'package:app_kopabali/src/views/testing/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginController = Provider.of<LoginController>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loginController.checkLoginStatus(context);
    });
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await loginController.loginUser(
                  email: emailController.text,
                  password: passwordController.text,
                  context: context,
                );
              },
              child: loginController.isLoading
                  ? CircularProgressIndicator()
                  : Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
