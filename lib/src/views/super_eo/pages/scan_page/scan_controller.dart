import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/super_eo/pages/scan_page/pages/scan_fix.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
    // Initialize any necessary data or listeners here
  }

  void toggleContainerExpansion(String containerName) {
    expandedContainer.value =
        expandedContainer.value == containerName ? '' : containerName;
  }

  bool isContainerExpanded(String containerName) {
    return expandedContainer.value == containerName;
  }

  Future<void> fetchParticipantData(String userId) async {
    try {
      print('Fetching participant data for userId: $userId');
      isLoading(true);

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        print('User document exists. Data: ${userDoc.data()}');
        participantData.value = userDoc.data() as Map<String, dynamic>;
        tShirtSize.value = participantData['tShirtSize'] ?? '';
        poloShirtSize.value = participantData['poloShirtSize'] ?? '';

        await Future.wait(
            [fetchParticipantImage(userId), fetchParticipantKitStatus(userId)]);
      } else {
        print('User document does not exist');
        throw Exception('User not found');
      }
    } catch (e) {
      print('Error fetching participant data: $e');
      throw e;
    } finally {
      isLoading(false);
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

  Future<void> updateItemStatus(String field, String newStatus) async {
    try {
      String userId = Get.arguments['userId'];
      final fieldParts = field.split('.');
      await _firestore.collection('participantKit').doc(userId).update({
        '${fieldParts[0]}.${fieldParts[1]}.status': newStatus,
        '${fieldParts[0]}.${fieldParts[1]}.updatedAt':
            FieldValue.serverTimestamp(),
      });
      status[field] = newStatus;
      await fetchStatusImage(field, newStatus);
    } catch (e) {
      print('Error updating item status: $e');
      Get.snackbar("Error", "Failed to update item status.");
    }
  }

  Future<void> processQRCode(String qrCode) async {
    if (isProcessing.value) return;
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

  Future<String> getStatusImageUrl(String status) async {
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
      return await FirebaseStorage.instance
          .ref('status/$imageName')
          .getDownloadURL();
    } catch (e) {
      print('Error fetching status image: $e');
      return '';
    }
  }

  Future<void> fetchStatusImage(String key, String status) async {
    statusImageUrls[key] = await getStatusImageUrl(status);
  }

  String getStatusForItem(String category, String item) {
    return status['$category.$item'] ?? 'Pending';
  }

void updateParticipantRole(String newRole) async {
  try {
    String userId = Get.arguments['userId'];
    Map<String, dynamic> updateData = {'role': newRole};

    if (newRole == 'participant') {
      // Menghapus field-field yang tidak diperlukan ketika kembali menjadi participant
      updateData['wasCommittee'] = FieldValue.delete();
      updateData['wasEventOrganizer'] = FieldValue.delete();
      updateData['wasSuperEO'] = FieldValue.delete();
    }

    await _firestore.collection('users').doc(userId).update(updateData);

    // Memperbarui participantData lokal
    participantData['role'] = newRole;
    if (newRole == 'participant') {
      participantData.remove('wasCommittee');
      participantData.remove('wasEventOrganizer');
      participantData.remove('wasSuperEO');
    }

    Get.snackbar("Success", "Participant role updated successfully.");
  } catch (e) {
    print('Error updating participant role: $e');
    Get.snackbar("Error", "Failed to update participant role.");
  }
}

  void checkAllItems(String containerName) async {
    try {
      String userId = Get.arguments?['userId'];

      Map<String, dynamic> updateData = {};
      List<String> fieldsToUpdate = [];

      switch (containerName) {
        case 'merchandise':
          fieldsToUpdate = ['tShirt', 'poloShirt', 'luggageTag', 'jasHujan'];
          break;
        case 'souvenir':
          fieldsToUpdate = ['gelangTridatu', 'selendangUdeng'];
          break;
        case 'benefit':
          fieldsToUpdate = ['voucherEwallet', 'voucherBelanja'];
          break;
        default:
          Get.snackbar("Error", "Invalid container name: $containerName");
          return;
      }

      for (String field in fieldsToUpdate) {
        updateData['$containerName.$field.status'] = 'Received';
        updateData['$containerName.$field.updatedAt'] =
            FieldValue.serverTimestamp();
        status['$containerName.$field'] = 'Received';
      }

      await _firestore
          .collection('participantKit')
          .doc(userId)
          .update(updateData);
      status.refresh();

      Get.snackbar(
          "Success", "All items in $containerName marked as received.");
    } catch (e) {
      print('Error checking all items: $e');
      Get.snackbar("Error", "Failed to update all items: $e");
    }
  }

  void submitParticipantKit() async {
    try {
      String userId = Get.arguments['userId'];
      await _firestore.collection('participantKit').doc(userId).update({
        'submittedAt': FieldValue.serverTimestamp(),
      });
      Get.snackbar("Success", "Participant kit submitted successfully.");
    } catch (e) {
      print('Error submitting participant kit: $e');
      Get.snackbar("Error", "Failed to submit participant kit.");
    }
  }
}
