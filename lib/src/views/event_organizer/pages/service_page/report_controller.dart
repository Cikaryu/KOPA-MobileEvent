import 'package:app_kopabali/src/core/base_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ReportEventOrganizerController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<XFile?> selectedImage = Rx<XFile?>(null);
  var reportStatus = <String, String>{}.obs;
  var statusImageUrls = <String, String>{}.obs;
  var isLoading = false.obs;
  RxString selectedFilter = ''.obs;
  late Rx<User?> _user;
  RxList<QueryDocumentSnapshot> allReports = <QueryDocumentSnapshot>[].obs;
  RxList<QueryDocumentSnapshot> filteredReports = <QueryDocumentSnapshot>[].obs;
  RxString selectedSortOption = 'Newest'.obs;

  @override
  void onInit() {
    super.onInit();
    _user = Rx<User?>(_auth.currentUser);
    _auth.authStateChanges().listen((User? user) {
      _user.value = user;
    });
    fetchReports();
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

    try {
      final downloadUrl = await FirebaseStorage.instance
          .ref('status/$imageName')
          .getDownloadURL();
      statusImageUrls[reportId] = downloadUrl;
    } catch (e) {
      debugPrint('Error fetching status image: $e');
      statusImageUrls[reportId] = '';
    }
  }



  void sortReportsByDate() {
  filteredReports.sort((a, b) {
    final dataA = a.data() as Map<String, dynamic>;
    final dataB = b.data() as Map<String, dynamic>;
    final Timestamp timestampA = dataA['createdAt'];
    final Timestamp timestampB = dataB['createdAt'];

    if (selectedSortOption.value == 'Oldest') {
      return timestampA.compareTo(timestampB);
    } else {
      return timestampB.compareTo(timestampA);
    }
  });
}

void applyFilter(String filter) {
  selectedFilter.value = filter;
  filterReports();
}

void filterReports() {
  if (selectedFilter.isEmpty) {
    filteredReports.value = List.from(allReports);
  } else {
    filteredReports.value = allReports.where((report) {
      final data = report.data() as Map<String, dynamic>;
      return data['status'] == selectedFilter.value;
    }).toList();
  }
  sortReportsByDate();
}

  void fetchReports() {
    _firestore.collection('report').snapshots().listen((snapshot) {
      allReports.value = snapshot.docs;
      filterReports();
    });
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
      // Refresh the reports after updating
      fetchReports();
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
    return _firestore.collection('report').snapshots();
  }
}