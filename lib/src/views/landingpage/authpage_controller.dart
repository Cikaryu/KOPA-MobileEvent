// ignore_for_file: unnecessary_overrides
import 'package:app_kopabali/src/core/base_import.dart';

class AuthpageController extends GetxController {
  @override
  onInit() {
    super.onInit();
  }

  @override
  onReady() {
    super.onReady();
  }

  onGoBack() {
    Get.back();
  }

  void setLoading(bool value) {
    update();
  }

  tapSignin() async {
    await Get.toNamed(AppRoutes.signin);
  }

  tapSignup() async {
    await Get.toNamed(AppRoutes.signup);
  }
}
