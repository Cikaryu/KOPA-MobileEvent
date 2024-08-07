
import 'package:app_kopabali/src/views/authpage/signin/signin_view.dart';
import 'package:app_kopabali/src/views/authpage/signup/signup_controller.dart';
import 'package:app_kopabali/src/views/authpage/signup/signup_slide2_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_kopabali/src/core/base_import.dart';

class SignupView extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final SignupController signupController = Get.put(SignupController());

    return GestureDetector(
      onTap: () {
        // Hide the keyboard and lose focus when tapped outside of a text field
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: Color(0xFFF5F5F5),
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Create account",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your password' : null,
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      Get.to(SignupSlide2View());
                      //  {
                      //   try {
                      //     await signupController.registerUser(
                      //       email: _emailController.text,
                      //       password: _passwordController.text,
                      //       context: context,
                      //       role: 'participant',
                      //       status: 'pending',
                      //       createdAt: Timestamp.now(),
                      //       updatedAt: Timestamp.now(),
                      //     );
                      //     // Call resetForm() after successful registration
                      //   } catch (error) {
                      //     // Error handling
                      //   }
                        
                      // }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[300],
                      padding:
                          EdgeInsets.symmetric(horizontal: 154, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child:
                        Text("Submit", style: TextStyle(color: Colors.white)),
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
            if (signupController.isLoading)
              Opacity(
                opacity: 0.5, // Sesuaikan nilai opacity di sini
                child: ModalBarrier(
                  dismissible: false,
                  color: Colors.black,
                ),
              ),
            if (signupController.isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
