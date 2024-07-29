// ignore_for_file: prefer_const_constructors

import 'package:app_kopabali/src/core/base_import.dart';
import 'loginpage_controller.dart';

class LoginPageView extends StatelessWidget {
  const LoginPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginPageController>(
      init: LoginPageController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Login Page"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Username",
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Password",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
