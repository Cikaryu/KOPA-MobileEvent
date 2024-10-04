import 'package:app_kopabali/src/widgets/custom_Popup.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

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
      'departure': {'start': '00:00:', 'end': '23:59'},
      'arrival': {'start': '00:00', 'end': '23:59'},
      'csr': {'start': '00:00', 'end': '23:59'},
      'lunch': {'start': '00:00', 'end': '23:59'},
      'checkInHotel': {'start': '00:00', 'end': '23:59'},
      'welcomeDinner': {'start': '00:00', 'end': '23:59'},
      'arrivedHotel': {'start': '00:00', 'end': '23:59'}
    },
    2: {
      'teamBuilding': {'start': '00:00', 'end': '23:59'},
      'lunch': {'start': '00:00', 'end': '23:59'},
      'galaDinner': {'start': '00:00', 'end': '23:59'}
    },
    3: {
      'roomCheckOut': {'start': '00:00', 'end': '23:59'},
      'luggageDrop': {'start': '00:00', 'end': '23:59'},
      'departure': {'start': '00:00', 'end': '23:59'},
      'arrivalJakarta': {'start': '00:00', 'end': '23:59'}
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

  Future<String> loadCredentials() async {
    return await rootBundle.loadString('assets/credentials/credentials.json');
  }

  Future<AuthClient> getAuthClient() async {
    String credentials = await loadCredentials();
    final serviceAccountCredentials = ServiceAccountCredentials.fromJson(
      json.decode(credentials),
    );

    final scopes = [
      drive.DriveApi.driveFileScope,
      sheets.SheetsApi.spreadsheetsScope,
    ];

    final authClient =
        await clientViaServiceAccount(serviceAccountCredentials, scopes);
    return authClient;
  }

  Future<void> uploadImageToDrive(
      File imageFile, String status, String day, String eventActivity) async {
    final authClient = await getAuthClient();
    var driveApi = drive.DriveApi(authClient);

    // Fetch user details
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    String userName = userDoc.data()?['name'] ?? 'unknown_user';

    // Get the current date in ddMMyy format
    String timestamp = DateFormat('ddMMyy').format(DateTime.now());
    // Folder names based on your structure
    String dayFolder = "Day $day";
    String eventFolder = "$eventActivity";
    String eventFolderpermitSick = "Sick/Permit AllActivity";

    // Base folder ID for 'Kopa-Database'
    String baseFolderId = '1FkRiNu7Yg3zuw7OJFAZ7GCZ6BYllFyjV';

    // Create or get the folders starting from the base folder 'Kopa-Database'
    String attendanceFolderId =
        await createOrGetFolderId(driveApi, baseFolderId, '3. ATTENDANCE');
    String specificDayFolderId =
        await createOrGetFolderId(driveApi, attendanceFolderId, dayFolder);
    String specificEventFolderId =
        await createOrGetFolderId(driveApi, specificDayFolderId, eventFolder);
    String eventFolderSickPermit = await createOrGetFolderId(
      driveApi,
      specificDayFolderId,
      eventFolderpermitSick,
    );

    // File name with timestamp and user status
    String fileName = '${timestamp}_${userName}_$status.png';

    // Upload the image file
    var fileToUpload = drive.File();
    fileToUpload.name = fileName;
    // Kondisi jika permit/sick
    if (status != 'Attending') {
      fileToUpload.parents = [eventFolderSickPermit];
    } else {
      fileToUpload.parents = [specificEventFolderId];
    }
    var media = drive.Media(imageFile.openRead(), imageFile.lengthSync());
    final response =
        await driveApi.files.create(fileToUpload, uploadMedia: media);
    print('Uploaded File ID: ${response.id} with name: $fileName');
  }

  Future<String> createOrGetFolderId(
      drive.DriveApi driveApi, String parentId, String folderName) async {
    try {
      var query =
          "'$parentId' in parents and mimeType = 'application/vnd.google-apps.folder' and name = '$folderName' and trashed = false";
      var folderList = await driveApi.files.list(q: query, spaces: 'drive');

      if (folderList.files!.isNotEmpty) {
        return folderList.files!.first.id!; // Folder already exists
      } else {
        var folder = drive.File();
        folder.name = folderName;
        folder.mimeType = 'application/vnd.google-apps.folder';
        folder.parents = [parentId];
        var createdFolder = await driveApi.files.create(folder);
        return createdFolder.id!;
      }
    } catch (e) {
      throw Exception("Failed to create or get folder: $e");
    }
  }

  Future<String> getUserName() async {
    String userId = _auth.currentUser!.uid;
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(userId).get();
    return userDoc.get('name') as String? ?? 'Unknown User';
  }

  Future<void> submitToGoogleSheets(
      int day, String event, String status) async {
    final authClient = await getAuthClient();
    var sheetsApi = sheets.SheetsApi(authClient);

    final spreadsheetId = '1YY4nOT_a--4sqqgtT7mpT3PH8CPQsLM5ZbVKAtJzRLY';
    final range = 'Sheet1!A:O'; // Assuming columns A to O for all events

    try {
      final spreadsheet = await sheetsApi.spreadsheets.get(spreadsheetId);
      print(
          'Successfully accessed spreadsheet: ${spreadsheet.properties?.title}');

      String userName = await getUserName();
      String timestamp = DateFormat('dd/MM/yyyy_HH:mm:ss')
          .format(DateTime.now().toUtc().add(Duration(hours: 8)));

      // Fetch all values from the sheet
      final response =
          await sheetsApi.spreadsheets.values.get(spreadsheetId, range);
      List<List<Object?>> values = response.values ?? [];

      // Find the row for the current user
      int rowIndex =
          values.indexWhere((row) => row.isNotEmpty && row[0] == userName);

      // Determine the column for the current event
      int columnIndex = _getEventIndex(day, event);
      if (columnIndex == -1) {
        print('Invalid event: $event');
        return;
      }

      if (rowIndex != -1) {
        // User found, update the existing row
        while (values[rowIndex].length <= columnIndex) {
          values[rowIndex].add(''); // Ensure the row has enough columns
        }
        values[rowIndex][columnIndex] = '${status}_$timestamp';

        // Update the specific cell
        final updateRange =
            'Sheet1!${String.fromCharCode(65 + columnIndex)}${rowIndex + 1}';
        final updateBody = sheets.ValueRange(values: [
          [values[rowIndex][columnIndex]]
        ]);
        await sheetsApi.spreadsheets.values.update(
          updateBody,
          spreadsheetId,
          updateRange,
          valueInputOption: 'USER_ENTERED',
        );
      } else {
        // User not found, create a new row
        List<Object> newRow = List.filled(15, '');
        newRow[0] = userName;
        newRow[columnIndex] = '${status}_$timestamp';

        final appendBody = sheets.ValueRange(values: [newRow]);
        await sheetsApi.spreadsheets.values.append(
          appendBody,
          spreadsheetId,
          range,
          valueInputOption: 'USER_ENTERED',
          insertDataOption: 'INSERT_ROWS',
        );
      }

      print('Data updated in Google Sheets successfully for user: $userName');
    } catch (e) {
      print('Error interacting with Google Sheets: $e');

      if (e is sheets.DetailedApiRequestError) {
        print('Error status: ${e.status}, message: ${e.message}');
        print('Error details: ${e.jsonResponse}');
        print('Retrying in 5 seconds...');
        await Future.delayed(Duration(seconds: 5));
        await submitToGoogleSheets(day, event, status);
      }
    }
  }

  int _getEventIndex(int day, String event) {
    // Define the mapping of events to column indices
    Map<String, int> eventIndices = {
      'day1_departure': 1,
      'day1_arrival': 2,
      'day1_csr': 3,
      'day1_lunch': 4,
      'day1_checkInHotel': 5,
      'day1_welcomeDinner': 6,
      'day1_arrivedHotel': 7,
      'day2_teamBuilding': 8,
      'day2_lunch': 9,
      'day2_galaDinner': 10,
      'day3_roomCheckOut': 11,
      'day3_luggageDrop': 00,
      'day3_departure': 13,
      'day3_arrivalJakarta': 14,
    };

    String key = 'day${day}_$event';
    return eventIndices[key] ?? -1; // Return -1 if the event is not found
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
      var lastStatusPreviousDay =
          attendanceStatus[day - 1]![lastEventPreviousDay];
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
      String displayName = eventDisplayNames[event] ?? event;

      if (imageFile.value != null) {
        // Upload to Firebase and get URL
        imageUrl = await uploadImage(imageFile.value!, event);

        // Upload to Google Drive
        await uploadImageToDrive(
            imageFile.value!, status, day.toString(), displayName);
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

      // Tambahkan pemanggilan submitToGoogleSheets di sini
      await submitToGoogleSheets(day, event, status);

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
