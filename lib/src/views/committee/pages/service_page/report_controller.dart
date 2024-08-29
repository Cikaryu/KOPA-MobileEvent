import 'package:app_kopabali/src/core/base_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReportCommitteeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<XFile?> selectedImage = Rx<XFile?>(null);
  var reportStatus = <String, String>{}.obs;
  var statusImageUrls = <String, String>{}.obs;
  var isLoading = false.obs;
  RxBool isAscending = true.obs;
  RxString selectedFilter = ''.obs;
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
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(_user.value!.uid).get();
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

    try {
      final downloadUrl = await FirebaseStorage.instance.ref('status/$imageName').getDownloadURL();
      statusImageUrls[reportId] = downloadUrl;
    } catch (e) {
      debugPrint('Error fetching status image: $e');
      statusImageUrls[reportId] = '';
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
          return data['status'] == selectedFilter.value;
        }).toList();
      }

      reports.sort((a, b) {
        final dataA = a.data() as Map<String, dynamic>;
        final dataB = b.data() as Map<String, dynamic>;
        final comparison = (dataA['title'] ?? '').compareTo(dataB['title'] ?? '');
        return isAscending.value ? comparison : -comparison;
      });

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
    isLoading.value = true;
    try {
      await _firestore.collection('report').doc(reportId).update({
        'reply': reply,
        'status': status,
        'updatedAt': Timestamp.now(),
      });
      Get.snackbar('Sukses', 'Laporan berhasil diperbarui.');
      return true;
    } catch (e) {
      debugPrint('Error updating report: $e');
      Get.snackbar('Error', 'Gagal memperbarui laporan.');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Stream<QuerySnapshot> getReports() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      return FirebaseFirestore.instance
          .collection('report')
          .where('userId', isEqualTo: userId)
          .snapshots();
    }
    return Stream.empty();
  }
}