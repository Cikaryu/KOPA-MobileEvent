import 'dart:io';
import 'package:app_kopabali/src/core/base_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController divisiController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController whatsappNumberController =
      TextEditingController();
  final TextEditingController numberKTPController = TextEditingController();

  bool canPop = true;
  var imageBytes = Rxn<Uint8List>();
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userDivisi = ''.obs;
  var qrCodeUrl = ''.obs;
  var tShirtSize = ''.obs;
  var poloSize = ''.obs;
  var status = ''.obs;
  var userArea = ''.obs;
  var userDepartment = ''.obs;
  var userAlamat = ''.obs;
  var userWhatsapp = ''.obs;
  var numberKtp = ''.obs; // Tambahkan field status
  var isMerchExpanded = false.obs;
  var isSouvenirExpanded = false.obs;
  var isLoadingStatusImage = true.obs;
  var statusImageUrl = ''.obs; // Tambahkan field untuk URL gambar status
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @override
  void onReady() async {
    super.onReady();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await getUserData(user);
      await getImageBytes(user);
      await fetchQrCodeUrl(); // Ambil QR code saat controller siap
      await getParticipantKitStatus(user); // Ambil status merchandise
    } else {
      debugPrint("User not logged in");
    }
    update();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();
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
        userEmail.value = doc['email'];
        userDivisi.value = doc['divisi'];
        userArea.value = doc['area'];
        userDepartment.value = doc['department'];
        userAlamat.value = doc['alamat'];
        userWhatsapp.value = doc['nomorWhatsapp'];
        numberKtp.value = doc['nomorKtp'];
        tShirtSize.value = doc['ukuranTShirt'];
        poloSize.value = doc['ukuranPoloShirt'];
      } else {
        debugPrint('No user data found');
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }

  Future<void> getParticipantKitStatus(User user) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('participantKit')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final kitStatus = doc['status'];
        status.value = kitStatus; // Set status

        // Ambil URL gambar status berdasarkan status merchandise
        await fetchStatusImage(kitStatus);
      } else {
        debugPrint('No participantKit data found');
      }
    } catch (e) {
      debugPrint('Error fetching participantKit data: $e');
    }
  }

  Future<void> fetchStatusImage(String status) async {
    isLoadingStatusImage.value = true; // Set loading menjadi true
    String imageName;

    switch (status) {
      case 'pending':
        imageName = 'pending.png';
        break;
      case 'received':
        imageName = 'received.png';
        break;
      case 'not received':
        imageName = 'not_received.png';
        break;
      default:
        imageName = 'default.png'; // Gambar default jika status tidak dikenali
    }

    try {
      statusImageUrl.value = await FirebaseStorage.instance
          .ref()
          .child('status/$imageName')
          .getDownloadURL();
    } catch (e) {
      debugPrint('Error fetching status image: $e');
      statusImageUrl.value = ''; // Set ke kosong jika gagal
    } finally {
      isLoadingStatusImage.value = false; // Set loading menjadi false
    }
  }

  Future<void> fetchQrCodeUrl() async {
    try {
      final ref = FirebaseStorage.instance.ref().child(
          '/users/participant/${FirebaseAuth.instance.currentUser!.uid}/qr/qr.jpg');
      qrCodeUrl.value = await ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error fetching QR code: $e');
    }
  }

  void showQrDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text('QR Code'),
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            qrCodeUrl.isNotEmpty
                ? Image.network(
                    qrCodeUrl.value,
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                  )
                : CircularProgressIndicator(),
            SizedBox(height: 12),
            Text(userName.value),
          ]),
          actions: [
            Center(
              child: Container(
                width: 164,
                height: 40,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void saveChanges() {
    // Update profile controller dengan data baru
    userName.value = nameController.text;
    userArea.value = areaController.text;
    userDivisi.value = divisiController.text;
    userDepartment.value = departmentController.text;
    userAlamat.value = alamatController.text;
    userWhatsapp.value = whatsappNumberController.text;
    numberKtp.value = numberKTPController.text;

    // Panggil method untuk menyimpan perubahan ke Firestore
    updateUserProfile();
    Get.back(); // Kembali ke halaman sebelumnya setelah menyimpan
  }

  Future<void> updateUserProfile() async {
    // Implementasikan logika untuk memperbarui data pengguna di Firestore
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'name': userName.value,
        });
        Get.snackbar('Success', 'Profile updated successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
    }
  }
    void setLoading(bool value) {
    _isLoading = value;
    update();
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Password Reset'),
            content: Text('A password reset link has been sent to $email.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/signin');
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }
}
