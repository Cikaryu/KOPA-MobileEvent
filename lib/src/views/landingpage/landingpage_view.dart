import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/authpage/signin/signin_controller.dart';
import 'package:app_kopabali/src/views/authpage/signin/signin_view.dart';
import 'package:app_kopabali/src/views/authpage/signup/signup_view.dart';
import 'package:app_kopabali/src/views/landingpage/landingpage_controller.dart';

class LandingPageView extends StatelessWidget {
  const LandingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final SigninController signinController = Get.put(SigninController());

    // Memeriksa status login di build method
    WidgetsBinding.instance.addPostFrameCallback((_) {
      signinController.checkLoginStatus(context);
    });
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: GetBuilder<LandingPageController>(
        init: LandingPageController(),
        builder: (controller) => Scaffold(
            backgroundColor: HexColor('#FFFFFF'),
            appBar: AppBar(
              backgroundColor: HexColor('#FFFFFF'),
            ),
            body: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 80),
                    Center(
                        child: Image.asset(
                      'assets/images/Kopa.png',
                      width: Get.width * 0.7,
                    )),
                    Text(
                      "Kopa Super App",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Your ultimate gateway to seamless event planning and execution.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 80),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => SigninView()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor('E97717'),
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 134),
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
              ),
            )),
      ),
    );
  }
}
