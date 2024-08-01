import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/authpage/forget_password/forgetpass_view.dart';
import 'package:app_kopabali/src/views/authpage/signin/signin_controller.dart';
import 'package:app_kopabali/src/views/authpage/signup/signup_view.dart';

class SigninView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
final SigninController signinController =
      Get.put(SigninController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      signinController.checkLoginStatus(context);
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
                await signinController.loginUser(
                  email: emailController.text,
                  password: passwordController.text,
                  context: context,
                );
              },
              child: signinController.isLoading
                  ? CircularProgressIndicator()
                  : Text('Login'),
            ),
            ElevatedButton(
              child: Text(
                'Sign up',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: (){Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SignupView()),
                );},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[300],
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 134),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ForgotPasswordView()),
                );
              },
              child: Text('Forgot Password?'),
            ),
          ],
        ),
      ),
    );
  }
}
