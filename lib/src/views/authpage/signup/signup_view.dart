import 'package:app_kopabali/src/views/authpage/signup/signup_controller.dart';
import 'package:app_kopabali/src/core/base_import.dart';

class SignupView extends StatelessWidget {
  SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final SignupController signupController = Get.put(SignupController());
    return Scaffold(
      body: PageView.builder(
        controller: signupController.pageController,
        itemBuilder: signupController.pageItemBuilder,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 4,
      ),
    );
  }
}
