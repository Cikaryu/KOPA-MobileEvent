import 'package:app_kopabali/src/core/base_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class HomePageController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  var userName = ''.obs;
  late Timer timer;

  // Make duration reactive
  var duration = Duration().obs;
  DateTime? serverTime;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    _fetchServerTime();
  }

   Future<void> _fetchServerTime() async {
    try {
      final response = await http
          .get(Uri.parse('http://worldtimeapi.org/api/timezone/Etc/UTC'));
      if (response.statusCode == 200) {
        final serverTimeJson = jsonDecode(response.body);
        serverTime = DateTime.parse(serverTimeJson['utc_datetime']);
        DateTime eventDate = DateTime(2024, 9, 20, 0, 0, 0);

        // Convert eventDate to UTC+07:00
        eventDate = eventDate.toUtc().add(Duration(hours: 7));

        // Update the duration value using .value
        duration.value = eventDate.difference(serverTime!);

        timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
          if (duration.value.isNegative) {
            timer.cancel();
          } else {
            duration.value -= Duration(seconds: 1);
          }
        });
      } else {
        throw Exception('Failed to load server time');
      }
    } catch (e) {
      print("Error fetching server time: $e");
      duration.value = Duration.zero; // Set duration to zero on error
    }
  }

  @override
  void dispose() {
    timer.cancel();
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

  Future<void> getUserData(User user) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        userName.value = doc['name'];
      } else {
        debugPrint('No user data found');
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }
}
