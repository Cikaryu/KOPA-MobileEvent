import 'package:app_kopabali/src/core/base_import.dart';

class CommitteeController extends GetxController {
  PageController pageController = PageController();
  // File? image;

  @override
  onInit() {
    super.onInit();
  }

  @override
  onReady() async {
    update();
    super.onReady();
  }

  @override
  onClose() async {
    super.onClose();
  }

  onGoBack() {
    Get.back();
  }
}