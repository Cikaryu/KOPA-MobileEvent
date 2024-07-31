

import 'package:app_kopabali/src/core/base_import.dart';



class TestingController extends GetxController {
  bool canPop = true;
  String? qrCodeResult;
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

  // Future<void> openCamera() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.camera);
  //   if (pickedFile != null) {
  //     image = File(pickedFile.path);
  //     update(); // Update the state to reflect the new image
  //   }
  // }
  void setQRCodeResult(String result) {
    qrCodeResult = result;
    update();
  }
  void clearQRCodeResult() {
    qrCodeResult = null;
    update();
  }
}
