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

  Future<void> fetchStatusImage(String reportId, String status) async {
    String imageName;

    switch (status) {
      case 'Pending':
        imageName = 'pending.png';
        break;
      case 'Resolved':
        imageName = 'received.png';
        break;
      case 'Unresolved':
        imageName = 'close.png';
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
