import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class AttendanceController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  var isDay1Expanded = false.obs;
  var isDay2Expanded = false.obs;
  var isDay3Expanded = false.obs;
  var isLoading = false.obs;
  var imageFile = Rx<File?>(null);
  var description = ''.obs;

  var attendanceStatus = {
    1: {
      'departure': 'Pending',
      'arrival': 'Pending',
      'csr': 'Pending',
      'lunch': 'Pending',
      'checkInHotel': 'Pending',
      'welcomeDinner': 'Pending',
      'arrivedHotel': 'Pending'
    },
    2: {'teamBuilding': 'Pending', 'lunch': 'Pending', 'galaDinner': 'Pending'},
    3: {
      'roomCheckOut': 'Pending',
      'luggageDrop': 'Pending',
      'departure': 'Pending',
      'arrivalJakarta': 'Pending'
    },
  }.obs;

  var events = {
    1: [
      'departure',
      'arrival',
      'csr',
      'lunch',
      'checkInHotel',
      'welcomeDinner',
      'arrivedHotel'
    ],
    2: ['teamBuilding', 'lunch', 'galaDinner'],
    3: ['roomCheckOut', 'luggageDrop', 'departure', 'arrivalJakarta']
  };

  var currentEvent = '';
  var notParticipating = false.obs;
  var leftEarly = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAttendanceData();
  }

  void setLoading(bool value) {
    isLoading.value = value;
  }

  void toggleDayExpanded(int day) {
    if (day == 1) {
      isDay1Expanded.value = !isDay1Expanded.value;
    } else if (day == 2) {
      isDay2Expanded.value = !isDay2Expanded.value;
    } else if (day == 3) {
      isDay3Expanded.value = !isDay3Expanded.value;
    }
  }

  bool isDayExpanded(int day) {
    if (day == 1) {
      return isDay1Expanded.value;
    } else if (day == 2) {
      return isDay2Expanded.value;
    } else if (day == 3) {
      return isDay3Expanded.value;
    }
    return false;
  }

  bool isPreviousEventAttended(int day, String event) {
    var eventIndex = events[day]!.indexOf(event);
    if (eventIndex == 0) return true;

    var previousEvent = events[day]![eventIndex - 1];
    return attendanceStatus[day]![previousEvent] == 'Attended' ||
           attendanceStatus[day]![previousEvent] == 'Sick' ||
           attendanceStatus[day]![previousEvent] == 'Permit';
  }

  bool areAllEventsAttended(int day) {
    return attendanceStatus[day]!.values.every((status) =>
        status == 'Attended' || status == 'Sick' || status == 'Permit');
  }

  bool canAttendEvent(int day, String event) {
    if (notParticipating.value || leftEarly.value) return false;
    if (day == 1 && event == 'departure') return true;
    return isPreviousEventAttended(day, event) && (day == 1 || areAllEventsAttended(day - 1));
  }

  Future<void> loadAttendanceData() async {
    try {
      String userId = _auth.currentUser!.uid;
      var doc = await _firestore.collection('attendance').doc(userId).get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        for (int day = 1; day <= 3; day++) {
          String dayKey = 'day$day';
          if (data.containsKey(dayKey)) {
            data[dayKey].forEach((event, eventData) {
              attendanceStatus[day]![event] = eventData['status'];
              if (eventData['status'] == 'Not Participating') {
                notParticipating.value = true;
              } else if (eventData['status'] == 'Left Early') {
                leftEarly.value = true;
              }
            });
          }
        }
      }
    } catch (e) {
      print('Error loading attendance data: $e');
    }
  }

  Future<void> takePhoto() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      imageFile.value = File(image.path);
    }
  }

  Future<String?> uploadImage(File imageFile, String event) async {
    try {
      String userId = _auth.currentUser!.uid;
      String fileName =
          '${userId}_${DateTime.now().millisecondsSinceEpoch}_$event.jpg';
      Reference ref = _storage.ref().child(
          '/users/participant/${FirebaseAuth.instance.currentUser!.uid}/attendance_images/$fileName');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> submitAttendance(int day, String event, String status) async {
    if (imageFile.value == null && status != 'Pending' && status != 'Not Participating' && status != 'Left Early') {
      Get.snackbar('Error', 'Please take a photo before submitting');
      return;
    }

    setLoading(true);
    try {
      String userId = _auth.currentUser!.uid;
      String? imageUrl;
      if (imageFile.value != null) {
        imageUrl = await uploadImage(imageFile.value!, event);
      }

      await _firestore.collection('attendance').doc(userId).set({
        'day${day}': {
          event: {
            'status': status,
            'img': imageUrl ?? '',
            'desc': description.value,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          }
        }
      }, SetOptions(merge: true));

      attendanceStatus[day]![event] = status;
      imageFile.value = null;
      description.value = '';

      if (status == 'Not Participating') {
        notParticipating.value = true;
      } else if (status == 'Left Early') {
        leftEarly.value = true;
      }

      Get.back();
      Get.snackbar('Success', 'Attendance submitted successfully');
    } catch (e) {
      print('Error submitting attendance: $e');
      Get.snackbar('Error', 'Failed to submit attendance');
    } finally {
      setLoading(false);
    }
  }

  
}