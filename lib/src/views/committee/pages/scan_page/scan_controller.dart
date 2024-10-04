import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/committee/pages/scan_page/pages/scan_fix.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class ScanController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  RxMap<String, dynamic> participantData = <String, dynamic>{}.obs;
  RxMap<String, String> status = <String, String>{}.obs;
  final RxMap<String, String> statusImageUrls = <String, String>{}.obs;
  var imageBytes = Rxn<Uint8List>();
  var isLoading = true.obs;
  var tShirtSize = ''.obs;
  var poloShirtSize = ''.obs;
  var isProcessing = false.obs;
  var expandedContainer = RxString('');
  final Rx<String?> userId = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    // Initialize any necessary data or listeners here
    _initializeUserId();
  }

  void _initializeUserId() {
    if (Get.arguments != null && Get.arguments is Map) {
      userId.value = Get.arguments['userId'] as String?;
      print('UserId initialized: ${userId.value}');
    } else {
      print('Get.arguments is null or not a Map');
    }
  }

  void toggleContainerExpansion(String containerName) {
    expandedContainer.value =
        expandedContainer.value == containerName ? '' : containerName;
  }

  bool isContainerExpanded(String containerName) {
    return expandedContainer.value == containerName;
  }

  Future<void> fetchParticipantData(String userId) async {
    try {
      print('Fetching participant data for userId: $userId');
      isLoading(true);

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        print('User document exists. Data: ${userDoc.data()}');
        participantData.value = userDoc.data() as Map<String, dynamic>;
        tShirtSize.value = participantData['tShirtSize'] ?? '';
        poloShirtSize.value = participantData['poloShirtSize'] ?? '';

        await Future.wait(
            [fetchParticipantImage(userId), fetchParticipantKitStatus(userId)]);
      } else {
        print('User document does not exist');
        throw Exception('User not found');
      }
    } catch (e) {
      print('Error fetching participant data: $e');
      throw e;
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchParticipantImage(String userId) async {
    try {
      final ref =
          _storage.ref().child('/users/participant/$userId/selfie/selfie.jpg');
      final data = await ref.getData();
      if (data != null) {
        imageBytes.value = data;
      }
    } catch (e) {
      print('Error fetching participant image: $e');
    }
  }

  Future<void> fetchParticipantKitStatus(String userId) async {
    try {
      DocumentSnapshot kitDoc =
          await _firestore.collection('participantKit').doc(userId).get();

      if (kitDoc.exists) {
        Map<String, dynamic> kitData = kitDoc.data() as Map<String, dynamic>;

        final fields = [
          'merchandise.tShirt',
          'merchandise.poloShirt',
          'merchandise.luggageTag',
          'merchandise.jasHujan',
          'souvenir.gelangTridatu',
          'souvenir.selendangUdeng',
          'benefit.voucherEwallet',
          'benefit.voucherBelanja'
        ];

        for (var field in fields) {
          final fieldParts = field.split('.');
          final categoryData = kitData[fieldParts[0]] as Map<String, dynamic>?;

          if (categoryData != null && categoryData[fieldParts[1]] != null) {
            final itemData =
                categoryData[fieldParts[1]] as Map<String, dynamic>?;
            final fieldStatus = itemData?['status'] ?? 'Pending';
            status[field] = fieldStatus;
          } else {
            status[field] = 'Pending';
          }
        }
      }
    } catch (e) {
      print('Error fetching participant kit status: $e');
    }
  }

  Future<void> logActivity({
    required String type,
    required String participantName,
    String? itemName,
    String? newStatus,
    String? newstatusAll,
    String? newRole,
  }) async {
    try {
      final String activityId = _firestore.collection('activityLogs').doc().id;
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        final String name = userDoc['name'] ?? '';
        await _firestore.collection('activityLogs').doc(activityId).set({
          'type': type,
          'ParticipantName': participantName,
          'participantName': participantName,
          if (itemName != null) 'itemName': itemName,
          if (newStatus != null) 'newStatus': newStatus,
          if (newstatusAll != null) 'newstatusAll': newstatusAll,
          if (newRole != null) 'newRole': newRole,
          'ChangedBy': name,
          'changedBy': name,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error logging activity: $e');
    }
  }

   // Load the Google Sheets service account credentials
  Future<String> loadCredentials() async {
    return await rootBundle.loadString('assets/credentials/credentials.json');
  }

  // Authenticate and return the AuthClient
  Future<AuthClient> getAuthClient() async {
    String credentials = await loadCredentials();
    final serviceAccountCredentials = ServiceAccountCredentials.fromJson(json.decode(credentials));
    
    final scopes = [
      sheets.SheetsApi.spreadsheetsScope,
    ];

    return await clientViaServiceAccount(serviceAccountCredentials, scopes);
  }

  // Function to update Google Sheets status based on the userId and changed statuses
  Future<void> updateGoogleSheetStatus(String userId, Map<String, String> changedStatuses) async {
  final authClient = await getAuthClient();
  var sheetsApi = sheets.SheetsApi(authClient);

  String spreadsheetId = '1zOgCl7ngSUkTJTI9NortPjgfZeKrUA4YRsj0xNSbsVY';
  String range = 'Sheet1!A2:V';  // Define the range where data exists (Columns A to V)

  // Fetch the sheet data
  final result = await sheetsApi.spreadsheets.values.get(spreadsheetId, range);
  List<List<dynamic>> rows = result.values ?? [];

  // Find the row by userId (assume userId is in column B)
  int rowIndex = rows.indexWhere((row) => row[1] == userId);

  if (rowIndex != -1) {
    // Mapping of kit items to column indices in the spreadsheet
    Map<String, int> columnMap = {
      'Polo Shirt': 14,  // Column O
      'T-shirt': 15,     // Column P
      'Luggage Tag': 16, // Column Q
      'Jas Hujan': 17,   // Column R
      'Gelang Tridatu': 18, // Column S
      'Selendang/Udeng': 19, // Column T
      'Voucher Belanja': 20, // Column U
      'Voucher E-Wallet': 21 // Column V
    };

    // Update only the changed statuses
    List<dynamic> updatedRow = List.from(rows[rowIndex]);
    for (var entry in changedStatuses.entries) {
      String item = entry.key;
      String newStatus = entry.value;

      if (columnMap.containsKey(item)) {
        int columnIndex = columnMap[item]!;
        updatedRow[columnIndex] = newStatus;  // Update the status in the row
      }
    }

    // Define the specific range to update (only the row that changed)
    String updateRange = 'Sheet1!A${rowIndex + 2}:V${rowIndex + 2}';  // Row index is 0-based, Google Sheets is 1-based

    // Write the updated row values back to Google Sheets
    await sheetsApi.spreadsheets.values.update(
      sheets.ValueRange(values: [updatedRow]),
      spreadsheetId,
      updateRange,
      valueInputOption: 'USER_ENTERED',
    );
    print('Google Sheets status updated for userId: $userId');
  } else {
    print('UserId not found in Google Sheets');
  }
}


  // Function to mark all items as received in Google Sheets
  Future<void> updateAllStatusesToReceived(String userId, String category) async {
    final authClient = await getAuthClient();
    var sheetsApi = sheets.SheetsApi(authClient);

    String spreadsheetId = '1zOgCl7ngSUkTJTI9NortPjgfZeKrUA4YRsj0xNSbsVY';  // Your Google Sheets ID
    String range = 'Sheet1!A2:V';  // Define the range where data exists (Columns A to V)

     // Fetch the sheet data
  final result = await sheetsApi.spreadsheets.values.get(spreadsheetId, range);
  List<List<dynamic>> rows = result.values ?? [];

  // Find the row by userId (assume userId is in column B)
  int rowIndex = rows.indexWhere((row) => row[1] == userId);

  if (rowIndex != -1) {
    // Define which columns to update based on the category
    Map<String, List<int>> categoryColumnMap = {
      'merchandise': [14, 15, 16, 17], // Columns O to R (Polo Shirt, T-shirt, Luggage Tag, Jas Hujan)
      'souvenir': [18, 19],            // Columns S to T (Gelang Tridatu, Selendang/Udeng)
      'benefit': [20, 21]              // Columns U to V (Voucher Belanja, Voucher E-Wallet)
    };

    if (categoryColumnMap.containsKey(category)) {
      List<int> columnsToUpdate = categoryColumnMap[category]!;

      // Set the selected range columns to "Received"
      for (int columnIndex in columnsToUpdate) {
        rows[rowIndex][columnIndex] = 'Received';
      }

      // Write the updated values back to Google Sheets
      await sheetsApi.spreadsheets.values.update(
        sheets.ValueRange(values: rows),
        spreadsheetId,
        range,
        valueInputOption: 'USER_ENTERED',
      );
      print('All statuses in $category marked as Received for userId: $userId.');
    } else {
      print('Invalid category: $category');
    }
  } else {
    print('UserId not found in Google Sheets');
  }
}


  Future<void> updateItemStatus(String field, String newStatus) async {
    try {
      String userId = Get.arguments['userId'];
      final fieldParts = field.split('.');
      await _firestore.collection('participantKit').doc(userId).update({
        '${fieldParts[0]}.${fieldParts[1]}.status': newStatus,
        '${fieldParts[0]}.${fieldParts[1]}.updatedAt':
            FieldValue.serverTimestamp(),
      });
      status[field] = newStatus;
      
        // Update in Google Sheets
    // Make sure the item name matches exactly with the columnMap keys
    String itemName = fieldParts[1].replaceAllMapped(
      RegExp(r'([A-Z])'),
      (Match m) => ' ${m.group(1)}'
    ).trim();
    itemName = itemName[0].toUpperCase() + itemName.substring(1);  // Capitalize first letter
    Map<String, String> changedStatuses = {itemName: newStatus};
    await updateGoogleSheetStatus(userId, changedStatuses);

      // Log the activity
      await logActivity(
        type: 'participantkit_changed',
        participantName: participantData['name'] ?? '',
        itemName: '${fieldParts[0]}.${fieldParts[1]}',
        newStatus: newStatus,
      );
    } catch (e) {
      print('Error updating item status: $e');
      Get.snackbar(
        "Error",
        "Failed to update item status.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> processQRCode(String qrCode) async {
    if (isProcessing.value) return;
    try {
      isProcessing(true);
      isLoading(true);
      print('Processing QR Code: $qrCode');

      DocumentSnapshot participantDoc =
          await _firestore.collection('users').doc(qrCode).get();

      if (participantDoc.exists) {
        print('Participant found. Fetching data...');
        await fetchParticipantData(qrCode);
        print('Data fetched. Navigating to scan profile page.');
        Get.off(() => ScanProfileView(), arguments: {'userId': qrCode});
      } else {
        print('Participant not found.');
        Get.snackbar(
          "Error",
          "Participant not found.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error processing QR code: $e');
      Get.snackbar(
        "Error",
        "Failed to process QR code.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
      isProcessing(false);
    }
  }

  String getStatusImagePath(String status) {
    switch (status) {
      case 'Pending':
        return 'assets/icons/status/ic_pending.svg';
      case 'Received':
        return 'assets/icons/status/ic_received.svg';
      case 'Not Received':
        return 'assets/icons/status/ic_not_received.svg';
      default:
        return 'assets/icons/status/ic_default.svg';
    }
  }

  String getStatusForItem(String category, String item) {
    return status['$category.$item'] ?? 'Pending';
  }

  void updateParticipantRole(String newRole) async {
    try {
      String userId = Get.arguments['userId'];
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'role': newRole});
      participantData['role'] = newRole;
      Get.snackbar(
        "Success",
        "Participant role updated successfully.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error updating participant role: $e');
      Get.snackbar(
        "Error",
        "Failed to update participant role.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void checkAllItems(String containerName) async {
    if (userId.value == null) {
      print('Error: userId is null');
      Get.snackbar("Error", "User ID not found. Please try again.",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      Map<String, dynamic> updateData = {};
      List<String> fieldsToUpdate = [];

      switch (containerName) {
        case 'merchandise':
          fieldsToUpdate = ['tShirt', 'poloShirt', 'luggageTag', 'jasHujan'];
          break;
        case 'souvenir':
          fieldsToUpdate = ['gelangTridatu', 'selendangUdeng'];
          break;
        case 'benefit':
          fieldsToUpdate = ['voucherEwallet', 'voucherBelanja'];
          break;
        default:
          Get.snackbar(
            "Error",
            "Invalid container name: $containerName",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
      }

      for (String field in fieldsToUpdate) {
        updateData['$containerName.$field.status'] = 'Received';
        updateData['$containerName.$field.updatedAt'] =
            FieldValue.serverTimestamp();
        status['$containerName.$field'] = 'Received';
      }

      await _firestore
          .collection('participantKit')
          .doc(userId.value)
          .update(updateData);
      status.refresh();

    // Mark all selected items as received in Google Sheets
    await updateAllStatusesToReceived(userId.value!, containerName);

      // Log the activity
      await logActivity(
        type: 'participantkit_changed_all',
        participantName: participantData['name'] ?? '',
        itemName: containerName,
        newstatusAll: 'Received',
      );
      Get.snackbar(
        "Success",
        "All items in $containerName marked as received.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e, stackTrace) {
      print('Error checking all items: $e');
      print('Stack trace: $stackTrace');
      Get.snackbar("Error", "Failed to update all items: ${e.toString()}",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void submitParticipantKit() async {
    try {
      String userId = Get.arguments['userId'];
      await _firestore.collection('participantKit').doc(userId).update({
        'submitUpdatedAt': FieldValue.serverTimestamp(),
      });
      Get.snackbar(
        "Success",
        "Participant kit submitted successfully.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error submitting participant kit: $e');
      Get.snackbar(
        "Error",
        "Failed to submit participant kit.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void showConfirmCheckAllItems(BuildContext context, String containerName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Confirm Action',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to mark all items as received?',
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    color: Colors.red,
                    border: Border(
                      top: BorderSide(color: Colors.redAccent),
                    ),
                  ),
                  child: TextButton(
                    child: Text('No',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    color: Colors.green,
                    border: Border(
                      top: BorderSide(color: Colors.greenAccent),
                    ),
                  ),
                  child: TextButton(
                    child: Text('Yes',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    onPressed: () {
                      checkAllItems(
                          containerName); // Mark all items as received
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
