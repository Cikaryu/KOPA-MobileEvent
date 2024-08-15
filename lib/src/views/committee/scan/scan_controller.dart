import 'dart:io';
import 'package:app_kopabali/src/core/base_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScanController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController divisiController = TextEditingController();
  bool canPop = true;
  var userName = ''.obs;
  var userDivisi = ''.obs;
  RxMap<String, String> status = <String, String>{}.obs;
  final RxMap<String, String> statusImageUrls = <String, String>{}.obs;
  var isMerchExpanded = true.obs;
  var isSouvenirExpanded = false.obs;
  var isBenefitExpanded = false.obs;
  var isLoadingStatusImage = true.obs;
  var statusImageUrl = ''.obs; // Tambahkan field untuk URL gambar status
  var selfieImage = Rxn<File>();
  var imageUrl = ''.obs;
  var imageBytes = Rxn<Uint8List>();
  var isLoading = false.obs;
  var tShirtSize = ''.obs;
  var poloShirtSize = ''.obs;

  @override
  onInit() {
    super.onInit();
    fetchUserData();
    getUserData;
  }

  tapMerch() {
    isMerchExpanded.value = !isMerchExpanded.value;
  }

  Future<void> getImageBytes(User user) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('/users/participant/${user.uid}/selfie/selfie.jpg');
      debugPrint('Fetching image from path: ${ref.fullPath}');
      final data = await ref.getData();
      if (data != null) {
        debugPrint('Image data length: ${data.length}');
        imageBytes.value = data;
      } else {
        debugPrint('No image data found');
      }
    } catch (e) {
      debugPrint('Error fetching image: $e');
    }
  }

  Future<void> getUserData(User user) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        userName.value = doc['name'];
        userDivisi.value = doc['division'];
      } else {
        debugPrint('No user data found');
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }

  @override
  onReady() async {
    update();
    super.onReady();
  }

  void fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        userName.value = data['name'] ?? '';
        userDivisi.value = data['division'] ?? '';
        String imageUrl = data['profileImageUrl'] ?? '';
        if (imageUrl.isNotEmpty) {
          var response = await FirebaseStorage.instance.ref(imageUrl).getData();
          if (response != null) {
            imageBytes.value = response;
          }
        }
      }
    }
  }

  void setLoading(bool value) {
    isLoading.value = value;
  }

  @override
  onClose() async {
    super.onClose();
  }

  onGoBack() {
    Get.back();
  }
}
