import 'package:app_kopabali/src/widgets/custom_Popup.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;


class AttendanceController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Rx<XFile?> selectedImage = Rx<XFile?>(null);

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

  var eventDisplayNames = {
    'departure': 'Departure',
    'arrival': 'Arrival',
    'csr': 'CSR Activity',
    'lunch': 'Lunch',
    'checkInHotel': 'Check-In Hotel',
    'welcomeDinner': 'Welcome Dinner',
    'arrivedHotel': 'Arrived at Hotel',
    'teamBuilding': 'Team Building',
    'galaDinner': 'Gala Dinner',
    'roomCheckOut': 'Room Check-Out',
    'luggageDrop': 'Luggage Drop',
    'departure': 'Departure',
    'arrivalJakarta': 'Arrival in Jakarta'
  };

  // EDIT WAKTU EVENT DISINI !
  var eventTimeRanges = {
    1: {
      'departure': {'start': '14:00:', 'end': '14:01'},
      'arrival': {'start': '14:02', 'end': '14:03'},
      'csr': {'start': '14:08', 'end': '14:09'},
      'lunch': {'start': '14:10', 'end': '14:11'},
      'checkInHotel': {'start': '15:00', 'end': '17:00'},
      'welcomeDinner': {'start': '19:00', 'end': '21:00'},
      'arrivedHotel': {'start': '21:00', 'end': '23:00'}
    },
    2: {
      'teamBuilding': {'start': '09:00', 'end': '12:00'},
      'lunch': {'start': '12:00', 'end': '14:00'},
      'galaDinner': {'start': '19:00', 'end': '22:00'}
    },
    3: {
      'roomCheckOut': {'start': '07:00', 'end': '09:00'},
      'luggageDrop': {'start': '09:00', 'end': '10:00'},
      'departure': {'start': '10:00', 'end': '12:00'},
      'arrivalJakarta': {'start': '14:00', 'end': '16:00'}
    },
  };


  var currentEvent = '';
  var notParticipating = false.obs;
  var leftEarly = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAttendanceData();
    tz.initializeTimeZones();
  }

  void setLoading(bool value) {
    isLoading.value = value;
  }

  void toggleDayExpanded(int day) {
    if (day == 1) {
      if (!isDay1Expanded.value) {
        isDay2Expanded.value = false;
        isDay3Expanded.value = false;
      }
      isDay1Expanded.value = !isDay1Expanded.value;
    } else if (day == 2) {
      if (!isDay2Expanded.value) {
        isDay1Expanded.value = false;
        isDay3Expanded.value = false;
      }
      isDay2Expanded.value = !isDay2Expanded.value;
    } else if (day == 3) {
      if (!isDay3Expanded.value) {
        isDay1Expanded.value = false;
        isDay2Expanded.value = false;
      }
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
    if (day == 1 && event == 'departure') return isWithinTimeRange(day, event);

    var eventIndex = events[day]!.indexOf(event);
    if (eventIndex == 0 && day != 1) {
      // Check last event of previous day
      var lastEventPreviousDay = events[day - 1]!.last;
      var lastStatusPreviousDay = attendanceStatus[day - 1]![lastEventPreviousDay];
      return (lastStatusPreviousDay == 'Attending' ||
          lastStatusPreviousDay == 'Sick' ||
          lastStatusPreviousDay == 'Permit') &&
          isWithinTimeRange(day, event);
    }

    if (eventIndex > 0) {
      var previousEvent = events[day]![eventIndex - 1];
      var previousStatus = attendanceStatus[day]![previousEvent];

      if (day == 1 && previousEvent == 'departure') {
        return previousStatus == 'Attending' && isWithinTimeRange(day, event);
      }

      return (previousStatus == 'Attending' ||
          previousStatus == 'Sick' ||
          previousStatus == 'Permit') &&
          isWithinTimeRange(day, event);
    }

    return false;
  }

  bool isWithinTimeRange(int day, String event) {
    var nowInUTC8 = tz.TZDateTime.now(tz.getLocation('Asia/Makassar'));
    var timeRange = eventTimeRanges[day]![event];
    if (timeRange == null) return false;

    var startTime = _parseTime(timeRange['start']!, nowInUTC8);
    var endTime = _parseTime(timeRange['end']!, nowInUTC8);

    return nowInUTC8.isAfter(startTime) && nowInUTC8.isBefore(endTime);
  }
  tz.TZDateTime _parseTime(String time, tz.TZDateTime referenceDate) {
    var timeParts = time.split(':');
    return tz.TZDateTime(
      tz.getLocation('Asia/Makassar'),
      referenceDate.year,
      referenceDate.month,
      referenceDate.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
  }


  //refresh
  Future<void> refreshAttendanceData() async {
    try {
      setLoading(true);

      // Fetch your attendance data from Firebase
      String userId = _auth.currentUser!.uid;

      // Fetch the data for each day
      for (int day = 1; day <= 3; day++) {
        String dayKey = 'day$day';
        DocumentSnapshot dayData =
            await _firestore.collection('attendance').doc(userId).get();

        // Check if the document exists
        if (dayData.exists) {
          var data = dayData.data() as Map<String, dynamic>;
          if (data.containsKey(dayKey)) {
            data[dayKey].forEach((event, eventData) {
              attendanceStatus[day]![event] = eventData['status'];
            });
          }
        } else {
          // Handle the case where the document does not exist
          attendanceStatus[day] = {
            for (var event in events[day]!) event: 'Pending'
          };
        }
      }

      // Notify listeners that the data has been updated
      update();
    } catch (e) {
      print('Error refreshing attendance data: $e');
    } finally {
      setLoading(false);
    }
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
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
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
    if (imageFile.value == null &&
        status != 'Pending' &&
        status != 'Not Participating' &&
        status != 'Permit' &&
        status != 'Sick' &&
        status != 'Left Early') {
      CustomPopup(
          context: Get.context!,
          title: 'Failed Submiting',
          content: 'Please take a photo before submitting');
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

      // Update status event dalam `attendanceStatus`
      attendanceStatus[day]![event] = status;
      imageFile.value = null;
      description.value = '';

      // Update status umum peserta berdasarkan pilihan mereka
      if (status == 'Attended') {
        notParticipating.value = false;
        leftEarly.value = false;
      } else if (status == 'Not Participating') {
        notParticipating.value = true;
      } else if (status == 'Left Early') {
        leftEarly.value = true;
      }

      Get.back();
      CustomPopup(
          context: Get.context!,
          title: 'Submit Success',
          content: 'Attendance submitted successfully');
    } catch (e) {
      print('Error submitting attendance: $e');
      CustomPopup(
        context: Get.context!,
        title: 'Error',
        content: 'Failed to submit attendance. Please try again.',
      );
    } finally {
      setLoading(false);
    }
  }
}
