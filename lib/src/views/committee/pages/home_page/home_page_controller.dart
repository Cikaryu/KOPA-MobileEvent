import 'package:app_kopabali/src/core/base_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class HomePageCommitteeController extends GetxController {
 var userName = ''.obs;
  var duration = Duration().obs;
  var isEventStarted = false.obs;
  Timer? timer;
  StreamSubscription<DocumentSnapshot>? userSubscription;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    startCountdown();
  }

  @override
  void dispose() {
    timer?.cancel();
    userSubscription?.cancel();
    super.dispose();
  }

  void fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((DocumentSnapshot userDoc) {
        if (userDoc.exists) {
          var data = userDoc.data() as Map<String, dynamic>;
          String fullName = data['name'] ?? '';
          List<String> nameParts = fullName.split(' ');

          if (nameParts.length > 1) {
            userName.value = '${nameParts[0]} ${nameParts[1]}';
          } else {
            userName.value = fullName;
          }
        }
      });
    }
  }

  Future<DateTime> getServerTime() async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('serverTime').doc('time');
    await docRef.set({'timestamp': FieldValue.serverTimestamp()});
    DocumentSnapshot snapshot = await docRef.get();
    Timestamp? timestamp = snapshot['timestamp'] as Timestamp?;
    if (timestamp != null) {
      return timestamp.toDate();
    } else {
      throw Exception('Timestamp value is null');
    }
  }

  void startCountdown() async {
    DateTime serverTime = await getServerTime();
    DateTime eventDate = DateTime(2024, 9, 22, 0, 0, 0);

    duration.value = eventDate.difference(serverTime);

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (duration.value.inSeconds > 0) {
        duration.value = duration.value - Duration(seconds: 1);
      } else {
        isEventStarted.value = true;
        timer.cancel();
      }
    });
  }
}
