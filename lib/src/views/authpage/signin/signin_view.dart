import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/authpage/forget_password/forgetpass_view.dart';
import 'package:app_kopabali/src/views/authpage/signin/signin_controller.dart';
import 'package:app_kopabali/src/views/authpage/signup/signup_view.dart';

class SigninView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SigninView({super.key});

  @override
  Widget build(BuildContext context) {
    final SigninController signinController = Get.put(SigninController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      signinController.checkLoginStatus(context);
    });
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: GetBuilder<SigninController>(
        init: SigninController(),
        builder: (controller) => Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey),
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey),
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
                          FocusScope.of(context).unfocus();
                          await signinController.loginUser(
                            email: emailController.text,
                            password: passwordController.text,
                            context: context,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HexColor("E97717"),
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 138),
                          shape: RoundedRectangleBorder(
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
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => SignupView()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 134),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Sign up',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (signinController.isLoading)
                Opacity(
                  opacity: 0.5, // Sesuaikan nilai opacity di sini
                  child: ModalBarrier(
                    dismissible: false,
                    color: Colors.black,
                  ),
                ),
              if (signinController.isLoading)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
