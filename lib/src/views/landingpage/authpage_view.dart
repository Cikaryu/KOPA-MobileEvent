import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/landingpage/authpage_controller.dart';
import 'package:app_kopabali/src/views/authpage/signin/signin_controller.dart';
import 'package:app_kopabali/src/views/authpage/signin/signin_view.dart';
import 'package:app_kopabali/src/views/authpage/signup/signup_view.dart';

class AuthpageView extends StatelessWidget {
  AuthpageView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthpageController authpageController = Get.put(AuthpageController());
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: GetBuilder<AuthpageController>(
        init: AuthpageController(),
        builder: (controller) => Scaffold(
            backgroundColor: Color(0xFFF5F5F5),
            appBar: AppBar(
              backgroundColor: Color(0xFFF5F5F5),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Explore the app",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Now your finance are in one place \nand always under controls",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 40),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          controller.tapSignin();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 134),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          controller.tapSignup();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 107),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Create Account',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 80),
                ],
              ),
            )),
      ),
    );
  }
}
