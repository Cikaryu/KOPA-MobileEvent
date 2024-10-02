import 'dart:convert';

import 'package:app_kopabali/src/core/base_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart';

class FeedbackController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final suggestionController = TextEditingController();
  final rating = 0.0.obs;
  final String spreadsheetId = '1M3gfssXScdFuTzPbGg9wE3Bg9aldOPQKcMglMdRJtwc';
  final String range = 'Sheet1!A:E';
  final isLoading = false.obs;

  @override
  void onClose() {
    suggestionController.dispose();
    super.onClose();
  }

  void setRating(double value) {
    rating.value = value;
  }

  String getRatingLabel(double rating) {
    switch (rating.toInt()) {
      case 1:
        return 'Need Improvement';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Excellent';
      case 5:
        return 'Perfect';
      default:
        return '';
    }
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
      sheets.SheetsApi.spreadsheetsScope,
    ];

    final authClient =
        await clientViaServiceAccount(serviceAccountCredentials, scopes);
    return authClient;
  }

  Future<void> updateSpreadsheet(
      String spreadsheetId, String range, List<Object> newRow) async {
    try {
      final authClient = await getAuthClient();
      var sheetsApi = sheets.SheetsApi(authClient);

      // Get existing values
      var response =
          await sheetsApi.spreadsheets.values.get(spreadsheetId, range);
      var existingValues = response.values ?? [];

      print('Existing values: $existingValues'); // Debug log

      // Check if headers exist, if not, add them
      if (existingValues.isEmpty || existingValues[0].length < 4) {
        existingValues
            .insert(0, ['TimeStamp', 'Nama', 'Rating', 'Suggestions']);
      }

      // Find the row with the matching name
      int rowIndex = -1;
      for (int i = 1; i < existingValues.length; i++) {
        if (existingValues[i].length > 1 && existingValues[i][1] == newRow[1]) {
          rowIndex = i;
          break;
        }
      }

      print('Row index for ${newRow[1]}: $rowIndex'); // Debug log

      if (rowIndex != -1) {
        // Update existing row
        existingValues[rowIndex] = newRow;
        print('Updated existing row: ${existingValues[rowIndex]}'); // Debug log
      } else {
        // Add new row
        existingValues.add(newRow);
        print('Added new row: $newRow'); // Debug log
      }

      var valueRange = sheets.ValueRange(values: existingValues);

      // Update the entire range
      var updateResponse = await sheetsApi.spreadsheets.values.update(
        valueRange,
        spreadsheetId,
        range,
        valueInputOption: 'USER_ENTERED',
      );

      print('Spreadsheet update response: $updateResponse'); // Debug log

      print('Spreadsheet updated successfully');
    } catch (e) {
      print('Error updating spreadsheet: $e');
      // Handle the error appropriately, e.g., by showing an error message to the user
    }
  }

  Future<void> submitFeedback(String suggestion) async {
    try {
      isLoading.value = true;
      final User? user = _auth.currentUser;
      if (user != null) {
        final DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        final String name = userDoc['name'] ?? '';

        final String feedbackId = _firestore.collection('feedback').doc().id;

        await _firestore.collection('feedback').doc(feedbackId).set({
          'userId': user.uid,
          'name': name,
          'rating': rating.value,
          'suggestion': suggestion,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        final timestamp = DateTime.now().toIso8601String();
        List<Object> newRow = [
          timestamp,
          name,
          rating.value.toString(),
          suggestion
        ];
        print('Submitting new row: $newRow'); // Debug log
        await updateSpreadsheet(spreadsheetId, range, newRow);

        Get.snackbar('Success', 'Feedback submitted successfully',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white);

        suggestionController.clear();
        rating.value = 0.0;
      } else {
        Get.snackbar('Error', 'User not logged in',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      print('$e');
      Get.snackbar('Error', 'Failed to submit feedback: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }
}
