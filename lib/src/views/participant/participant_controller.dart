import 'dart:typed_data';
import 'package:app_kopabali/src/core/base_import.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParticipantController extends GetxController {
  bool canPop = true;
  var selectedIndex = 0.obs;
  PageController pageController = PageController();
  var imageBytes = Rxn<Uint8List>();
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userDivisi = ''.obs;
  var qrCodeUrl = ''.obs;
  var status = ''.obs;
  var statusImageUrl = ''.obs;
  var tShirtSize = ''.obs;
  var poloSize = ''.obs;
  var isExpanded = false.obs;

  void toggleExpand() {
    isExpanded.value = !isExpanded.value;
  }

  @override
  onInit() {
    super.onInit();
  }

  @override
  onReady() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await getUserData(user);
      await getImageBytes(user);
      await getParticipantKitStatus(user);
    } else {
      print("User not logged in");
    }
    update();
    super.onReady();
  }

  @override
  onClose() async {
    super.onClose();
  }

  onGoBack() {
    Get.back();
  }

  void changeTabIndex(int index) {
    selectedIndex.value = index;
    pageController.jumpToPage(index);
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
      print('Fetching image from path: ${ref.fullPath}'); // Debug log
      final data = await ref.getData();
      if (data != null) {
        print('Image data length: ${data.length}'); // Debug log
        imageBytes.value = data;
      } else {
        print('No image data found'); // Debug log
      }
    } catch (e) {
      print('Error fetching image: $e'); // Debug log
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
        tShirtSize.value = doc['ukuranTShirt'];
        poloSize.value = doc['ukuranPoloShirt'];
      } else {
        print('No user data found');
      }
    } catch (e) {
      print('Error fetching user data: $e'); // Debug log
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
        final statusImageUrls = doc['statusImageUrls'];

        if (kitStatus == "pending") {
          status.value = kitStatus;
          statusImageUrl.value = statusImageUrls['pending'];
        } else if (kitStatus == "received") {
          status.value = kitStatus;
          statusImageUrl.value = statusImageUrls['received'];
        } else if (kitStatus == "close") {
          status.value = kitStatus;
          statusImageUrl.value = statusImageUrls['close'];
        }
      } else {
        print('No participantKit data found');
      }
    } catch (e) {
      print('Error fetching participantKit data: $e'); // Debug log
    }
  }

  Future<void> fetchQrCodeUrl() async {
    try {
      final ref = FirebaseStorage.instance.ref().child(
          '/users/participant/${FirebaseAuth.instance.currentUser!.uid}/qr/qr.jpg');
      qrCodeUrl.value = await ref.getDownloadURL();
    } catch (e) {
      print('Error fetching QR code: $e');
    }
  }

  void showQrDialog(BuildContext context) async {
    await fetchQrCodeUrl();
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
                    backgroundColor: WidgetStatePropertyAll(Colors.red),
                  ),
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
}
