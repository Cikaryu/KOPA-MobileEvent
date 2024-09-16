import 'dart:io';
import 'package:app_kopabali/src/core/base_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';


class ReportController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
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

  Future<void> pickImage() async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Select Image Source",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Choose an image from",
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: HexColor("E97717"),
                    border: Border(
                      top: BorderSide(color: Colors.orange[400]!),
                    ),
                  ),
                  child: TextButton(
                    child:
                        Text("Camera", style: TextStyle(color: Colors.white)),
                    onPressed: () => Navigator.pop(context, ImageSource.camera),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: HexColor("E97717"),
                    border: Border(
                      top: BorderSide(color: Colors.orange[400]!),
                    ),
                  ),
                  child: TextButton(
                    child:
                        Text("Gallery", style: TextStyle(color: Colors.white)),
                    onPressed: () =>
                        Navigator.pop(context, ImageSource.gallery),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (source != null) {
      final XFile? image =
          await _picker.pickImage(source: source, imageQuality: 50);
      if (image != null) {
        selectedImage.value = image;
      }
    }
  }

  Future<String> uploadImage(String reportId) async {
    if (selectedImage.value != null) {
      try {
        String filePath = 'report/$reportId/report.jpg';
        await _storage.ref(filePath).putFile(File(selectedImage.value!.path));
        return await _storage.ref(filePath).getDownloadURL();
      } catch (e) {
        print("Error uploading image: $e");
        return '-';
      }
    }
    return '-';
  }

  Future<void> submitReport({
    required String title,
    // required String category,
    required String description,
    required String status,
  }) async {
    try {
      if (_user.value == null) {
        throw Exception('User not logged in');
      }

      String userName = await getUserName();

      // Generate a unique reportId
      String reportId = _firestore.collection('report').doc().id;

      // Upload image if selected
      String imageUrl = await uploadImage(reportId);

      // Create new report document
      await _firestore.collection('report').doc(reportId).set({
        'userId': userId,
        'name': userName,
        'title': title,
        // 'category': category,
        'description': description,
        'image': imageUrl,
        'status': status,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Show success dialog
      Get.dialog(
        AlertDialog(
          title: Text('Success',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Text('Report submitted successfully!',
              textAlign: TextAlign.center),
          actions: [
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: HexColor("E97717"),
                  border: Border(
                    top: BorderSide(color: Colors.orange[400]!),
                  ),
                ),
                child: TextButton(
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Get.back(); // Close dialog
                    Get.back(); // Go back to previous page
                  },
                ),
              ),
            ),
          ],
        ),
      );

      // Reset form
      resetForm();
    } catch (e) {
      Get.dialog(
        AlertDialog(
          title: Text('Failed',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Text('Failed to submit report: $e'),
          actions: [
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: HexColor("E97717"),
                  border: Border(
                    top: BorderSide(color: Colors.orange[400]!),
                  ),
                ),
                child: TextButton(
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  void resetForm() {
    selectedImage.value = null;
  }

  void onGoBack() {
    resetForm();
    Get.back();
  }

  // Future<void> fetchStatusImage(String reportId, String status) async {
  //   String imageName;

  //   switch (status) {
  //     case 'Unresolved':
  //       imageName = 'close.png';
  //       break;
  //     case 'Resolved':
  //       imageName = 'received.png';
  //       break;
  //     case 'Pending':
  //       imageName = 'pending.png';
  //       break;
  //     default:
  //       imageName = 'default.png';
  //   }

  //   debugPrint('Image name determined: $imageName'); // Debug statement

  //   try {
  //     final downloadUrl = await FirebaseStorage.instance
  //         .ref('status/$imageName')
  //         .getDownloadURL();
  //     debugPrint('Fetched image URL: $downloadUrl'); // Debug statement
  //     statusImageUrls[reportId] = downloadUrl; // Menyimpan URL gambar
  //   } catch (e) {
  //     debugPrint('Error fetching status image: $e'); // Debug statement
  //     statusImageUrls[reportId] = ''; // Set to empty string if failed
  //   }
  // }
  String getStatusImagePath(String status) {
    switch (status) {
      case 'Not Started':
        return 'assets/icons/status/ic_not_started.svg';
      case 'In Progress':
        return 'assets/icons/status/ic_in_progress.svg';
      case 'Pending':
        return 'assets/icons/status/ic_pending.svg';
      case 'Solved':
        return 'assets/icons/status/ic_received.svg';
      default:
        return 'assets/icons/status/ic_default.svg'; // Fallback image
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
