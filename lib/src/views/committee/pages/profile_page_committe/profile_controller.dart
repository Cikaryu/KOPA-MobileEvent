import 'dart:async';

import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/committee/committee_view.dart';
import 'package:app_kopabali/src/views/participant/participant_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCommitteeController extends GetxController {
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userDivisi = ''.obs;
  var role = ''.obs;
  var isLoading = false.obs;
  var imageUrl = ''.obs;
  var hasPreviouslyBeenCommittee = false.obs;
  var imageBytes = Rxn<Uint8List>();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    fetchProfileImage;
    getUserRole();
  }

  @override
  void onReady() async {
    super.onReady();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await getImageBytes(user);
    } else {
      debugPrint("User not logged in");
    }
    update();
  }

  void setLoading(bool value) {
    isLoading.value = value;
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          var data = userDoc.data() as Map<String, dynamic>;
          userName.value = data['name'] ?? '';
          userEmail.value = data['email'] ?? '';
          userDivisi.value = data['division'] ?? '';
          imageUrl.value = data['profileImageUrl'] ?? '';
          hasPreviouslyBeenCommittee.value = data['wasCommittee'] ?? false;

          // Fetch image if imageUrl is available
          if (imageUrl.value.isNotEmpty) {
            await fetchProfileImage(imageUrl.value);
          }
        } else {
          debugPrint('No user data found');
        }
      } catch (e) {
        debugPrint('Error fetching user data: $e');
      }
    }
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

  Future<void> fetchProfileImage(String imageUrl) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(imageUrl);
      final data = await ref.getData();
      if (data != null) {
        imageBytes.value = data;
      } else {
        debugPrint('No image data found');
      }
    } catch (e) {
      debugPrint('Error fetching image: $e');
    }
  }

  void refreshData() async {
    setLoading(true);
    await Future.delayed(Duration(milliseconds: 500));
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await fetchUserData();
      } else {
        debugPrint("User not logged in");
      }
    } catch (e) {
      debugPrint('Error refreshing data: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      debugPrint("Logging out...");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await FirebaseAuth.instance.signOut();
      debugPrint("User signed out.");
      return Get.offAllNamed('/signin');
    } catch (e) {
      debugPrint("Error during logout: $e");
    }
  }

  Future<void> getUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid) // Menggunakan uid dari pengguna saat ini
            .get();

        if (userDoc.exists) {
          role.value = userDoc['role'];
          hasPreviouslyBeenCommittee.value = userDoc['wasCommittee'] ?? false;
        } else {
          print('Document does not exist on the database');
        }
      } catch (e) {
        print('Error getting role: $e');
      }
    } else {
      print('No user is signed in');
    }
  }

  void switchRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (role.value == 'Committee') {
        // Switch ke role participant
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'role': 'Participant',
          'wasCommittee':
              true, // Indicate that this user was previously a Committee
        });
        role.value = 'Participant';
        Get.offAll(() => ParticipantView());
      } else if (role.value == 'Participant') {
        // Switch ke role committee
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'role': 'Committee',
          'wasCommittee':
              true, // Indicate that this user was previously a Committee
        });
        role.value = 'Committee';
        Get.offAll(() => CommitteeView());
      }
    }
  }
}
