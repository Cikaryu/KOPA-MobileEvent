import 'package:app_kopabali/src/core/base_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class HomePageSuperEOController extends GetxController {
  var userName = ''.obs;
  var duration = Duration().obs;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    startCountdown();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
      }
    }
  }

  Future<DateTime> getServerTime() async {
    DocumentReference docRef = FirebaseFirestore.instance.collection('serverTime').doc('time');
    await docRef.set({'timestamp': FieldValue.serverTimestamp()});
    DocumentSnapshot snapshot = await docRef.get();
    Timestamp timestamp = snapshot['timestamp'];
    return timestamp.toDate();
  }

  void startCountdown() async {
    DateTime serverTime = await getServerTime();
    DateTime eventDate = DateTime(2024, 9, 20, 0, 0, 0); // Set tanggal event (20 September 2024) di zona waktu Bali (GMT+8)

    // Hitung perbedaan waktu antara server dan waktu event
    duration.value = eventDate.difference(serverTime);

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      duration.value = duration.value - Duration(seconds: 1);
    });
  }
}
