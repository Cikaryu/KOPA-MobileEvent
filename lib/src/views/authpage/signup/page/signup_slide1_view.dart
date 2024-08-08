import 'package:app_kopabali/src/views/authpage/signin/signin_view.dart';
import 'package:app_kopabali/src/views/authpage/signup/signup_controller.dart';
import 'package:app_kopabali/src/views/authpage/signup/page/signup_slide2_view.dart';
import 'package:app_kopabali/src/core/base_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                          hintText: 'Your email',
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
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                          RegExp regex = RegExp(pattern);
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          } else if (!regex.hasMatch(value) ||
                              !value.endsWith('.com')) {
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
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(signupController.showPassword
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
                        obscureText: true,
                        validator: (value) => value!.isEmpty
                            ? 'Please enter your password'
                            : null,
                      ),
                      SizedBox(height: 10),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                           if (_formKey.currentState!.validate()) {
                            signupController.emailController.text =
                                _emailController.text;
                            signupController.passwordController.text =
                                _passwordController.text;
                            signupController.pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                        }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[300],
                          padding: EdgeInsets.symmetric(
                              horizontal: 154, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Submit",
                            style: TextStyle(color: Colors.white)),
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
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => SigninView()),
                                );
                              },
                              child: Text(
                                "Log in",
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
