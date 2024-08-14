import 'package:app_kopabali/src/core/base_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCommitteeController extends GetxController {
  bool canPop = true;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userDivisi = ''.obs;
  var isLoading = false.obs;
  var imageUrl = ''.obs;
  var imageBytes = Rxn<Uint8List>();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    getUserData;
  }

  void setLoading(bool value) {
    isLoading.value = value;
  }

  void refreshData() async {
    setLoading(true);
    await Future.delayed(Duration(milliseconds: 500));
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await getUserData(user); // Refresh user data
        await getImageBytes(user); // Refresh profile image
      } else {
        debugPrint("User not logged in");
      }
    } catch (e) {
      debugPrint('Error refreshing data: $e');
    } finally {
      setLoading(false);
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

  Future<void> getUserData(User user) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        userName.value = doc['name'];
        userEmail.value = doc['email'];
        userDivisi.value = doc['division'];
      } else {
        debugPrint('No user data found');
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }

  void fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        userName.value = data['name'] ?? '';
        userEmail.value = data['email'] ?? '';
        userDivisi.value = data['division'] ?? '';
        String imageUrl = data['profileImageUrl'] ?? '';
        if (imageUrl.isNotEmpty) {
          var response = await FirebaseStorage.instance.ref(imageUrl).getData();
          if (response != null) {
            imageBytes.value = response;
          }
        }
      }
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed('/signin');
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() async {
    super.onClose();
  }

  void onGoBack() {
    Get.back();
  }
}
