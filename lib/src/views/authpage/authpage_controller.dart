// ignore_for_file: unnecessary_overrides
import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/routes/app_pages.dart';

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
}
