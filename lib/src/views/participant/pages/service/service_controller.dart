import 'package:app_kopabali/src/core/base_import.dart';

class ServiceController extends GetxController {
  bool canPop = true;
  var isFaq1Expanded = false.obs;


  @override
  onInit() {
    super.onInit();
  }

  @override
  onReady() async {
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
