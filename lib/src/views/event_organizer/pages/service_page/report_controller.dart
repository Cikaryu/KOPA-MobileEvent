import 'package:app_kopabali/src/core/base_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReportEventOrganizerController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<XFile?> selectedImage = Rx<XFile?>(null);
  var reportStatus = <String, String>{}.obs; // Menyimpan status laporan
  var statusImageUrls =
      <String, String>{}.obs; // Menyimpan URL gambar berdasarkan status
  var isLoading = false.obs; // Untuk mengatur status loading
  RxBool isAscending = true.obs;
  RxString selectedFilter = ''.obs; // Menyimpan filter yang dipilih

  late Rx<User?> _user;

  @override
  void onInit() {
    super.onInit();
    _user = Rx<User?>(_auth.currentUser);
    _auth.authStateChanges().listen((User? user) {
      _user.value = user;
    });
  }

  String get userId => _user.value?.uid ?? '';

  Future<String> getUserName() async {
    if (_user.value != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(_user.value!.uid).get();
      return userDoc['name'] ?? '';
    }
    return '';
  }

  Future<void> fetchStatusImage(String reportId, String status) async {
    String imageName;

    switch (status) {
      case 'Unresolved':
        imageName = 'close.png';
        break;
      case 'Resolved':
        imageName = 'received.png';
        break;
      case 'Pending':
        imageName = 'pending.png';
        break;
      default:
        imageName = 'default.png';
    }

    debugPrint('Image name determined: $imageName'); // Debug statement

    try {
      final downloadUrl = await FirebaseStorage.instance
          .ref('status/$imageName')
          .getDownloadURL();
      debugPrint('Fetched image URL: $downloadUrl'); // Debug statement
      statusImageUrls[reportId] = downloadUrl; // Menyimpan URL gambar
    } catch (e) {
      debugPrint('Error fetching status image: $e'); // Debug statement
      statusImageUrls[reportId] = ''; // Set to empty string if failed
    }
  }

  void toggleSortOrder() {
    isAscending.value = !isAscending.value;
  }

  Stream<List<QueryDocumentSnapshot>> getFilteredReports() {
    return _firestore.collection('report').snapshots().map((snapshot) {
      var reports = snapshot.docs;

      if (selectedFilter.isNotEmpty) {
        reports = reports.where((report) {
          final data = report.data() as Map<String, dynamic>;
          return data['status'] == selectedFilter.value ||
              data['title'].contains(selectedFilter.value);
        }).toList();
      }

      if (isAscending.value) {
        reports.sort((a, b) {
          final dataA = a.data() as Map<String, dynamic>;
          final dataB = b.data() as Map<String, dynamic>;
          return (dataA['title'] ?? '').compareTo(dataB['title'] ?? '');
        });
      } else {
        reports.sort((a, b) {
          final dataA = a.data() as Map<String, dynamic>;
          final dataB = b.data() as Map<String, dynamic>;
          return (dataB['title'] ?? '').compareTo(dataA['title'] ?? '');
        });
      }

      return reports;
    });
  }

  void applyFilter(String filter) {
    selectedFilter.value = filter;
  }

  Future<bool> updateReport({
    required String reportId,
    required String reply,
    required String status,
  }) async {
    isLoading.value = true; // Memulai loading
    try {
      await _firestore.collection('report').doc(reportId).update({
        'reply': reply,
        'status': status,
        'updatedAt': Timestamp.now(),
      });
      _showDialog('Success', 'Report updated successfully.');
      return true;
    } catch (e) {
      debugPrint('Error updating report: $e');
      _showDialog('Error', 'Failed to update report.');
      return false;
    } finally {
      isLoading.value = false; // Menghentikan loading
    }
  }

  void _showDialog(String title, String message) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            }, // Close the dialog
            child: Text('OK'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Stream<QuerySnapshot> getReports() {
    final userId = FirebaseAuth.instance.currentUser?.uid; // Ambil userId
    if (userId != null) {
      return FirebaseFirestore.instance
          .collection('report')
          .where('userId', isEqualTo: userId) // Filter berdasarkan userId
          .snapshots();
    }
    return Stream.empty();
  }
}
