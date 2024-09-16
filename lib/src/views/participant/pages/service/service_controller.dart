import 'package:app_kopabali/src/core/base_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceController extends GetxController {
  bool canPop = true;
  var isFaq1Expanded = false.obs;
  final FirebaseStorage storage = FirebaseStorage.instance;
  var statusImageUrls =
      <String, String>{}.obs; // Menyimpan URL gambar berdasarkan status

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

  String getStatusImagePath(String status) {
    switch (status) {
      case 'Not Started':
        return 'assets/icons/status/ic_not_started.svg';
      case 'In Progress':
        return 'assets/icons/status/ic_in_progress.svg';
      case 'Pending':
        return 'assets/icons/status/ic_pending.svg';
      case 'Resolved':
        return 'assets/icons/status/ic_received.svg';
      default:
        return 'assets/icons/status/ic_default.svg'; // Fallback image
    }
  }

  Color getStatusColor(String? status) {
  switch (status) {
    case 'Not Started':
      return Colors.grey;
    case 'In Progress':
      return Colors.blue;
    case 'Pending':
      return Colors.yellow[700]!;  // Darker shade of yellow for better visibility
    case 'Resolved':
      return Colors.green;
    default:
      return Colors.black;  // Default color if status is null or unknown
  }
}

  Stream<QuerySnapshot> getReportsStream() {
    final userId = FirebaseAuth.instance.currentUser?.uid; // Ambil userId
    if (userId != null) {
      return FirebaseFirestore.instance
          .collection('report')
          .where('userId', isEqualTo: userId) // Filter berdasarkan userId
          .snapshots();
    }
    return Stream.empty(); // Mengembalikan stream kosong jika userId tidak ada
  }
}
