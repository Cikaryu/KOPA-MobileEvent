import 'package:app_kopabali/src/core/base_import.dart';

class ParticipantController extends GetxController {
  bool canPop = true;
  var selectedIndex = 0.obs;
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

  void changeTabIndex(int index) {
    selectedIndex.value = index;
    pageController.jumpToPage(index);
  }
  // Future<void> openCamera() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.camera);
  //   if (pickedFile != null) {
  //     image = File(pickedFile.path);
  //     update(); // Update the state to reflect the new image
  //   }
  // }

}