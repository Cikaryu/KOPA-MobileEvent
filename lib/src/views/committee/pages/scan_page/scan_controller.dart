import 'dart:io';
import 'package:app_kopabali/src/core/base_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScanController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController divisiController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool canPop = true;
  var userName = ''.obs;
  var userDivisi = ''.obs;
  RxMap<String, String> status = <String, String>{}.obs;
  final RxMap<String, String> statusImageUrls = <String, String>{}.obs;
  var isMerchExpanded = true.obs;
  var isSouvenirExpanded = false.obs;
  var isBenefitExpanded = false.obs;
  var isLoadingStatusImage = true.obs;
  var statusImageUrl = ''.obs;
  var selfieImage = Rxn<File>();
  var imageUrl = ''.obs;
  var imageBytes = Rxn<Uint8List>();
  var isLoading = false.obs;
  var tShirtSize = ''.obs;
  var poloShirtSize = ''.obs;

  //item dropdown
  final List<String> statusOptions = ['pending', 'received'];

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    getUserData;
  }

  tapMerch() {
    isMerchExpanded.value = !isMerchExpanded.value;
  }

  tapSouvenir() {
    isSouvenirExpanded.value = !isSouvenirExpanded.value;
  }

  tapBenefit() {
    isBenefitExpanded.value = !isBenefitExpanded.value;
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
        tShirtSize.value = doc['tShirtSize'];
        poloShirtSize.value = doc['poloShirtSize'];
      } else {
        debugPrint('No user data found');
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }

  @override
  void onReady() async {
    update();
    super.onReady();
  }

  fetchUserData() async {
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
        tShirtSize.value = data['tShirtSize'] ?? '';
        poloShirtSize.value = data['poloShirtSize'] ?? '';
        String imageUrl = data['profileImageUrl'] ?? '';
        if (imageUrl.isNotEmpty) {
          var response = await FirebaseStorage.instance.ref(imageUrl).getData();
          if (response != null) {
            imageBytes.value = response;
          }
        }

        // Fetch status for each field
        final fields = [
          'merchandise.tShirt',
          'merchandise.poloShirt',
          'merchandise.luggageTag',
          'merchandise.jasHujan',
          'souvenir.gelangTridatu',
          'souvenir.selendangUdeng',
          'benefit.voucherEwallet',
          'benefit.voucherBelanja'
        ];

        for (var field in fields) {
          final fieldParts = field.split('.');
          final categoryData = data[fieldParts[0]] as Map<String, dynamic>?;

          if (categoryData != null && categoryData[fieldParts[1]] != null) {
            final itemData =
                categoryData[fieldParts[1]] as Map<String, dynamic>?;
            final fieldStatus = itemData?['status'] ?? 'pending';
            status[field] = fieldStatus;
          } else {
            status[field] = 'pending';
          }
        }
      }
    }
    update();
  }

  // Add new method to update status in Firebase
  Future<void> updateStatus(String field, String newStatus) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final fieldParts = field.split('.');
        await FirebaseFirestore.instance
            .collection('participantKit')
            .doc(user.uid)
            .update({
          '${fieldParts[0]}.${fieldParts[1]}.status': newStatus,
          '${fieldParts[0]}.${fieldParts[1]}.updatedAt':
              FieldValue.serverTimestamp(),
        });
        // Update local status
        status[field] = newStatus;
        update();
      }
    } catch (e) {
      debugPrint('Error updating status: $e');
    }
  }

  void setLoading(bool value) {
    isLoading.value = value;
  }

  @override
  void onClose() async {
    super.onClose();
  }

  onGoBack() {
    Get.back();
  }

  void processQRCode(String qrCode) async {
    try {
      // Query ke Firestore berdasarkan userId dari QR code
      DocumentSnapshot participantDoc =
          await _firestore.collection('users').doc(qrCode).get();

      if (participantDoc.exists) {
        // Jika peserta ditemukan, navigasi ke halaman profil dengan userId
        Get.toNamed('/scan', arguments: {'userId': qrCode});
      } else {
        Get.snackbar("Error", "Participant not found.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to process QR code: $e");
    }
  }
}
