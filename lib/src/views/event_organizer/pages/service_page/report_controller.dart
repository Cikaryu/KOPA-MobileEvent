import 'package:app_kopabali/src/core/base_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:async';

import 'package:intl/intl.dart';



class ReportEventOrganizerController extends GetxController {
 final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<XFile?> selectedImage = Rx<XFile?>(null);
  var reportStatus = <String, String>{}.obs;
  var statusImageUrls = <String, String>{}.obs;
  var isLoading = false.obs;
  RxString selectedFilter = ''.obs;
  late Rx<User?> _user;
  RxList<QueryDocumentSnapshot> allReports = <QueryDocumentSnapshot>[].obs;
  RxList<QueryDocumentSnapshot> filteredReports = <QueryDocumentSnapshot>[].obs;
  RxString selectedSortOption = 'Newest'.obs;

  // Add this variable to store the stream subscription
  StreamSubscription<QuerySnapshot>? _reportsSubscription;

  @override
  void onInit() {
    super.onInit();
    _user = Rx<User?>(_auth.currentUser);
    _auth.authStateChanges().listen((User? user) {
      _user.value = user;
    });
    fetchReports();
  }

  @override
  void onClose() {
    // Cancel the subscription when the controller is closed
    _reportsSubscription?.cancel();
    super.onClose();
  }

  String get userId => _user.value?.uid ?? '';

  Future<String> getUserName() async {
    if (_user.value != null) {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(_user.value!.uid).get();
      return userDoc['name'] ?? '';
    }
    return '';
  }

  String getStatusImagePath(String status) {
    switch (status) {
      case 'Not Started':
        return 'assets/icons/status/ic_not_started.svg';
      case 'In Progress':
        return 'assets/icons/status/ic_in_progress.svg';
      case 'Pending':
        return 'assets/icons/status/ic_pending.svg';
      case 'Resolved':
        return 'assets/icons/status/ic_received.svg';
      default:
        return 'assets/icons/status/ic_default.svg'; // Fallback image
    }
  }



 void sortReportsByDate() {
  filteredReports.sort((a, b) {
    final dataA = a.data() as Map<String, dynamic>;
    final dataB = b.data() as Map<String, dynamic>;

    final Timestamp? timestampA = dataA['createdAt'];
    final Timestamp? timestampB = dataB['createdAt'];

    // Handle the case where one or both timestamps are null
    if (timestampA == null && timestampB == null) {
      return 0; // If both are null, consider them equal
    } else if (timestampA == null) {
      return 1; // If A is null, place it after B
    } else if (timestampB == null) {
      return -1; // If B is null, place it after A
    } else {
      if (selectedSortOption.value == 'Oldest') {
        return timestampA.compareTo(timestampB);
      } else {
        return timestampB.compareTo(timestampA);}
    }
  });
}


void applyFilter(String filter) {
  selectedFilter.value = filter;
  filterReports();
}

void filterReports() {
  if (selectedFilter.isEmpty) {
    filteredReports.value = List.from(allReports);
  } else {
    filteredReports.value = allReports.where((report) {
      final data = report.data() as Map<String, dynamic>;
      return data['status'] == selectedFilter.value;
    }).toList();
  }
  sortReportsByDate();
}

  void fetchReports() {
    // Cancel any existing subscription before creating a new one
    _reportsSubscription?.cancel();

    _reportsSubscription = firestore.collection('report').snapshots().listen((snapshot) {
      allReports.value = snapshot.docs;
      filterReports();
    });
  }

  // Add this method to cancel the stream subscription
  void cancelReportsSubscription() {
    _reportsSubscription?.cancel();
    _reportsSubscription = null;
  }

    Future<AuthClient> getAuthClient() async {
    String credentials = await rootBundle.loadString('assets/credentials/credentials.json');
    final serviceAccountCredentials = ServiceAccountCredentials.fromJson(
      json.decode(credentials),
    );

    final scopes = [sheets.SheetsApi.spreadsheetsScope];

    final authClient = await clientViaServiceAccount(serviceAccountCredentials, scopes);
    return authClient;
  }

 Future<void> updateGoogleSheets(String reportId, String reply, String status) async {
    final authClient = await getAuthClient();
    var sheetsApi = sheets.SheetsApi(authClient);

    final spreadsheetId = '1HXCINYDRoWg4Xs0sag2g7K7DEbiLCxNypnjOWOTDG9U';
    
    try {
      // Fetch the report data from Firestore
      DocumentSnapshot reportDoc = await firestore.collection('report').doc(reportId).get();
      if (!reportDoc.exists) {
        print('Report not found in Firestore');
        return;
      }
      
      Map<String, dynamic> reportData = reportDoc.data() as Map<String, dynamic>;

      // Fetch all values from the sheet
      final response = await sheetsApi.spreadsheets.values.get(spreadsheetId, 'Sheet1!A:F');
      final values = response.values;

      int rowIndex = -1;
      if (values != null) {
        for (int i = 1; i < values.length; i++) { // Start from 1 to skip header row
          if (values[i].length > 2 &&
              values[i][1] == reportData['name'] &&
              values[i][2] == reportData['title']) {
            rowIndex = i + 1; // +1 because sheets are 1-indexed
            break;
          }
        }
      }

      if (rowIndex != -1) {
        // Update existing row
        final updateRange = 'Sheet1!E$rowIndex:F$rowIndex';
        final valueRange = sheets.ValueRange(values: [[reply, status]]);
        await sheetsApi.spreadsheets.values.update(
          valueRange,
          spreadsheetId,
          updateRange,
          valueInputOption: 'USER_ENTERED',
        );
        print('Google Sheets updated successfully.');
      } else {
        // Add new row if report not found
        final appendRange = 'Sheet1!A:F';
        final valueRange = sheets.ValueRange(values: [[
          DateFormat('dd/MM/yyyy HH:mm:ss').format(reportData['createdAt'].toDate()),
          reportData['name'],
          reportData['title'],
          reportData['description'],
          reply,
          status
        ]]);
        await sheetsApi.spreadsheets.values.append(
          valueRange,
          spreadsheetId,
          appendRange,
          valueInputOption: 'USER_ENTERED',
          insertDataOption: 'INSERT_ROWS',
        );
        print('New row added to Google Sheets.');
      }
    } catch (e) {
      print('Error updating Google Sheets: $e');
    }
  }

  Future<bool> updateReport({
    required String reportId,
    required String reply,
    required String status,
  }) async {
    isLoading.value = true;
    try {
      await firestore.collection('report').doc(reportId).update({
        'reply': reply,
        'status': status,
        'updatedAt': Timestamp.now(),
      });

      // Ambil judul laporan
      DocumentSnapshot reportDoc =
          await firestore.collection('report').doc(reportId).get();
      String reportTitle = reportDoc.get('title');
      String reportName = reportDoc.get('name');
      final String Activityid = firestore.collection('activityLogs').doc().id;

      // Buat log aktivitas
      final User? user = _auth.currentUser;
      if (user != null) {
        final DocumentSnapshot userDoc =
            await firestore.collection('users').doc(user.uid).get();
        final String name = userDoc['name'] ?? '';
        await firestore.collection('activityLogs').doc(Activityid).set({
          'type': 'report_reply',
          'reportName': reportName,
          'reportTitle': reportTitle,
          'repliedBy': name,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Update Google Sheets
      await updateGoogleSheets(reportId, reply, status);
      
      Get.snackbar('Sukses', 'Laporan berhasil diperbarui.',backgroundColor: Colors.green,
          colorText: Colors.white,);
      // Refresh the reports after updating
      fetchReports();
      return true;
    } catch (e) {
      debugPrint('Error updating report: $e');
      Get.snackbar('Error', 'Gagal memperbarui laporan.',backgroundColor: Colors.red,
          colorText: Colors.white,);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Stream<QuerySnapshot> getReports() {
    return firestore.collection('report').snapshots();
  }
}