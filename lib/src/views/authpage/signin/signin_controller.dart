// ignore_for_file: unnecessary_overrides

import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/routes/app_pages.dart';

class SigninController extends GetxController {
  bool showPassword = false;
  
  @override
  onInit() {
    super.onInit();
  }

  togglePasswordVisibility() {
    showPassword = !showPassword;
    update();
  }

  @override
  onReady() {
    super.onReady();
  }

  onGoBack() {
    Get.back();
  }

  tapSignup() {
    Get.toNamed(AppRoutes.signup);
  }
}
