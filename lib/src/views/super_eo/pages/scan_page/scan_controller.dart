import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/super_eo/pages/scan_page/pages/scan_fix.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScanController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  RxMap<String, dynamic> participantData = <String, dynamic>{}.obs;
  RxMap<String, String> status = <String, String>{}.obs;
  final RxMap<String, String> statusImageUrls = <String, String>{}.obs;
  var imageBytes = Rxn<Uint8List>();
  var isLoading = true.obs;
  var tShirtSize = ''.obs;
  var poloShirtSize = ''.obs;
  var isProcessing = false.obs;

  var expandedContainer = RxString('');
  @override
  void onInit() {
    super.onInit();
  }

  void toggleContainerExpansion(String containerName) {
    if (expandedContainer.value == containerName) {
      expandedContainer.value = ''; // Close if it's already open
    } else {
      expandedContainer.value =
          containerName; // Open the new one, closing others
    }
  }

  bool isContainerExpanded(String containerName) {
    return expandedContainer.value == containerName;
  }

  Future<void> fetchParticipantData(String userId) async {
    try {
      print('Fetching participant data for userId: $userId');

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        print('User document exists. Data: ${userDoc.data()}');
        participantData.value = userDoc.data() as Map<String, dynamic>;
        tShirtSize.value = participantData['tShirtSize'] ?? '';
        poloShirtSize.value = participantData['poloShirtSize'] ?? '';

        await Future.wait(
            [fetchParticipantImage(userId), fetchParticipantKitStatus(userId)]);
      }
    } catch (e) {
      print('Error fetching participant data: $e');
      throw e; // Re-throw the error to be caught in processQRCode
    }
  }

  Future<void> fetchParticipantImage(String userId) async {
    try {
      final ref =
          _storage.ref().child('/users/participant/$userId/selfie/selfie.jpg');
      final data = await ref.getData();
      if (data != null) {
        imageBytes.value = data;
      }
    } catch (e) {
      print('Error fetching participant image: $e');
      // Don't throw here, just log the error
    }
  }

  Future<void> fetchParticipantKitStatus(String userId) async {
    try {
      DocumentSnapshot kitDoc =
          await _firestore.collection('participantKit').doc(userId).get();

      if (kitDoc.exists) {
        Map<String, dynamic> kitData = kitDoc.data() as Map<String, dynamic>;

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
          final categoryData = kitData[fieldParts[0]] as Map<String, dynamic>?;

          if (categoryData != null && categoryData[fieldParts[1]] != null) {
            final itemData =
                categoryData[fieldParts[1]] as Map<String, dynamic>?;
            final fieldStatus = itemData?['status'] ?? 'Pending';
            status[field] = fieldStatus;
            await fetchStatusImage(field, fieldStatus);
          } else {
            status[field] = 'Pending';
            await fetchStatusImage(field, 'Pending');
          }
        }
      }
    } catch (e) {
      print('Error fetching participant kit status: $e');
    }
  }

  Future<void> updateStatus(String field, String newStatus) async {
    try {
      String userId = Get.arguments['userId'];
      final fieldParts = field.split('.');
      await _firestore.collection('participantKit').doc(userId).update({
        '${fieldParts[0]}.${fieldParts[1]}.status': newStatus,
        '${fieldParts[0]}.${fieldParts[1]}.updatedAt':
            FieldValue.serverTimestamp(),
      });
      status[field] = newStatus;
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  Future<void> processQRCode(String qrCode) async {
    if (isProcessing.value) return; // Prevent multiple simultaneous processes
    try {
      isProcessing(true);
      isLoading(true);
      print('Processing QR Code: $qrCode');

      DocumentSnapshot participantDoc =
          await _firestore.collection('users').doc(qrCode).get();

      if (participantDoc.exists) {
        print('Participant found. Fetching data...');
        await fetchParticipantData(qrCode);
        print('Data fetched. Navigating to scan profile page.');
        Get.off(() => ScanProfileView(), arguments: {'userId': qrCode});
      } else {
        print('Participant not found.');
        Get.snackbar("Error", "Participant not found.");
      }
    } catch (e) {
      print('Error processing QR code: $e');
      Get.snackbar("Error", "Failed to process QR code.");
    } finally {
      isLoading(false);
      isProcessing(false);
    }
  }

  Future<void> fetchStatusImage(String key, String status) async {
    String imageName;

    switch (status) {
      case 'Pending':
        imageName = 'pending.png';
        break;
      case 'Received':
        imageName = 'received.png';
        break;
      case 'Close':
        imageName = 'close.png';
        break;
      default:
        imageName = 'default.png';
    }

    try {
      final downloadUrl = await FirebaseStorage.instance
          .ref('status/$imageName')
          .getDownloadURL();
      statusImageUrls[key] = downloadUrl;
    } catch (e) {
      debugPrint('Error fetching status image: $e');
      statusImageUrls[key] = ''; // Set to empty string if failed
    }
  }
}
