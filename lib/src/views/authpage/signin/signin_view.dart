// ignore_for_file: sort_child_properties_last

import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/authpage/forget_password/forgetpass_view.dart';
import 'package:app_kopabali/src/views/authpage/signin/signin_controller.dart';
import 'package:app_kopabali/src/views/authpage/signup/signup_view.dart';

class SigninView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final SigninController signinController = Get.put(SigninController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      signinController.checkLoginStatus(context);
    });
    return GetBuilder<SigninController>(
        init: SigninController(),
        builder: (controller) => Scaffold(
          backgroundColor: Color(0xFFF5F5F5),
              appBar: AppBar(
                title: Text('Sign in'),
                centerTitle: true,
                backgroundColor: Color(0xFFF5F5F5),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: controller.showPassword ? false : true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(controller.showPassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            controller.togglePasswordVisibility();
                          },
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ForgotPasswordView()),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.blue[300]),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await signinController.loginUser(
                          email: emailController.text,
                          password: passwordController.text,
                          context: context,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 138),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: signinController.isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      child: Text(
                        'Sign up',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SignupView()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 134),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            );
  }
}
