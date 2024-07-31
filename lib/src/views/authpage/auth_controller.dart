// ignore_for_file: unnecessary_overrides

import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/authpage/Section/signin_section.dart';
import 'package:app_kopabali/src/views/authpage/Section/signup_section.dart';

class LoginPageController extends GetxController {
  PageController pageController = PageController();
  String targetView = "SignIN";

  @override
  onInit() {
    super.onInit();
  }

  tapSignIN() {
    targetView = "SignIN";
    update();
    pageController.nextPage(
        duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  tapSignUP() {
    targetView = "SignUP";
    update();
    pageController.nextPage(
        duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  Widget PageItemBuilder(context, position) {
    switch (position) {
      case 0:
        return SignINSection();
      case 1:
        if (targetView == "SignUP") {
          return SignupSection();
        }
        if (targetView == "SignIN") {
          return SignINSection();
        }
        return SignINSection();
      default:
        return Container();
    }
  }

  @override
  onReady() {
    super.onReady();
  }

  onGoBack() {
    Get.back();
  }
}
