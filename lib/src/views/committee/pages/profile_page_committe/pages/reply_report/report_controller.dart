import 'dart:io';
import 'package:app_kopabali/src/core/base_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ReportCommitteeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<XFile?> selectedImage = Rx<XFile?>(null);
  var reportStatus = <String, String>{}.obs; // Menyimpan status laporan
  var statusImageUrls =
      <String, String>{}.obs; // Menyimpan URL gambar berdasarkan status

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
      case 'unresolved':
        imageName = 'pending.png';
        break;
      case 'resolved':
        imageName = 'resolved.png';
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
