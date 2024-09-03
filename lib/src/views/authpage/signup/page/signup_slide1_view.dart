import 'package:flutter/material.dart';
import 'package:app_kopabali/src/views/authpage/signin/signin_view.dart';
import 'package:app_kopabali/src/views/authpage/signup/signup_controller.dart';
import 'package:app_kopabali/src/core/base_import.dart';

class SignupSlide1View extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignupSlide1View({super.key});

  @override
  Widget build(BuildContext context) {
    final SignupController signupController = Get.put(SignupController());

    return GestureDetector(
      onTap: () {
        // Hide the keyboard and lose focus when tapped outside of a text field
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          color: Colors.white,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Create account",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      SizedBox(height: 20),
                      Text("Email",
                          style: TextStyle(
                            fontSize: 14,
                          )),
                      SizedBox(height: 4),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Example@mail.com',
                          hintStyle: TextStyle(fontSize: 14 ,color: Colors.grey.withOpacity(0.6)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        validator: (value) {
                          String pattern =
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|co\.id|ac\.id)$';
                          RegExp regex = RegExp(pattern);
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          } else if (!regex.hasMatch(value)) {
                            return 'Please enter a valid email.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Text("Password",
                          style: TextStyle(
                            fontSize: 14,
                          )),
                      SizedBox(height: 4),
                      Obx(() => TextFormField(
                            controller: _passwordController,
                            obscureText: signupController.showPassword.value
                                ? false
                                : true,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(fontSize: 14 ,color: Colors.grey.withOpacity(0.6)),
                              suffixIcon: IconButton(
                                icon: Icon(signupController.showPassword.value
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  signupController.togglePasswordVisibility();
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              } else if (value.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null; // Valid
                            },
                          )),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              signupController.emailController.text =
                                  _emailController.text;
                              signupController.passwordController.text =
                                  _passwordController.text;
                              signupController.nextPage();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor('E97717'),
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.35,
                                vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text("Submit",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                  color: Colors.grey[800], fontSize: 12),
                            ),
                            InkWell(
                              onTap: () {
                                Get.offAll(() => SigninView());
                              },
                              child: Text(
                                "Sign in",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue[300],
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
