import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class SearchParticipantController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxList<Participant> allParticipants = <Participant>[].obs;
  RxList<Participant> filteredParticipants = <Participant>[].obs;
  TextEditingController searchController = TextEditingController();
  RxMap<String, dynamic> participantKitStatus = <String, dynamic>{}.obs;
  RxBool isAscending = true.obs;
  final RxMap<String, String> statusImageUrls = <String, String>{}.obs;
  RxMap<String, String> status = <String, String>{}.obs;
  var expandedContainer = RxString('');
  var tShirtSize = ''.obs;
  var poloShirtSize = ''.obs;
  var isLoading = false.obs;
  Rx<Stream<DocumentSnapshot>>? participantKitStream;
  RxBool isKitStatusFiltered = false.obs;
  Rx<Participant?> selectedParticipant = Rx<Participant?>(null);
  late StreamSubscription<QuerySnapshot> _participantSubscription;

  @override
  void onInit() {
    super.onInit();
    fetchParticipants();
    startRealtimeUpdates();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      getUserData(user);
    }
  }

  @override
  void onReady() async {
    super.onReady();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await getUserData(user);
    } else {
      debugPrint("User not logged in");
    }
    update();
  }

  void startRealtimeUpdates() {
    isLoading(true);
    _participantSubscription =
        _firestore.collection('users').snapshots().listen((snapshot) {
      allParticipants.value =
          snapshot.docs.map((doc) => Participant.fromDocument(doc)).toList();
      _applyFiltersAndSort();
      isLoading(false);
    }, onError: (error) {
      print('Error in real-time updates: $error');
      isLoading(false);
    });
  }

  void _applyFiltersAndSort() {
    searchParticipants(searchController.text);
    sortParticipants();
  }

  @override
  void onClose() {
    _participantSubscription.cancel();
    super.onClose();
  }

  void toggleContainerExpansion(String containerName) {
    if (expandedContainer.value == containerName) {
      expandedContainer.value = ''; // Not Received if it's already open
    } else {
      expandedContainer.value =
          containerName; // Open the new one, closing others
    }
  }

  bool isContainerExpanded(String containerName) {
    return expandedContainer.value == containerName;
  }

  void setLoading(bool value) {
    isLoading.value = value;
  }

  Future<void> getUserData(User user) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        tShirtSize.value = doc['tShirtSize'];
        poloShirtSize.value = doc['poloShirtSize'];
      } else {
        debugPrint('No user data found');
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }

  Future<void> fetchParticipantKitStatus(String participantId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('participantKit')
          .doc(participantId)
          .get();

      if (doc.exists) {
        participantKitStatus.value = doc.data() as Map<String, dynamic>;
      } else {
        participantKitStatus.value = {};
      }
    } catch (e) {
      print('Error fetching participant kit status: $e');
      participantKitStatus.value = {};
    }
  }

  String getStatusForItem(String category, String item) {
    if (participantKitStatus.containsKey(category) &&
        participantKitStatus[category].containsKey(item)) {
      return participantKitStatus[category][item]['status'] ?? 'Unknown';
    }
    return 'Unknown';
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

  Future<String> getStatusImageUrl(String status) async {
    String imageName;
    switch (status) {
      case 'Pending':
        imageName = 'pending.png';
        break;
      case 'Received':
        imageName = 'received.png';
        break;
      case 'Not Received':
        imageName = 'close.png';
        break;
      default:
        imageName = 'default.png';
    }

    try {
      return await FirebaseStorage.instance
          .ref('status/$imageName')
          .getDownloadURL();
    } catch (e) {
      print('Error fetching status image: $e');
      return '';
    }
  }

  Future<void> fetchParticipants() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role')
          .get();

      final participants = querySnapshot.docs
          .map((doc) => Participant.fromDocument(doc))
          .toList();

      allParticipants.value = participants;
      filteredParticipants.value = participants;
    } catch (e) {
      print('Error fetching participants: $e');
    }
  }

  void searchParticipants(String query) {
    if (query.isEmpty) {
      filteredParticipants.value = allParticipants;
    } else {
      filteredParticipants.value = allParticipants
          .where(
              (p) => (p.name ?? '').toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void sortParticipants() {
    if (isAscending.value) {
      filteredParticipants
          .sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
    } else {
      filteredParticipants
          .sort((a, b) => (b.name ?? '').compareTo(a.name ?? ''));
    }
  }

  void toggleSortOrder() {
    isAscending.value = !isAscending.value;
    sortParticipants();
  }

  Future<void> toggleKitStatusFilter() async {
    isLoading.value = true;
    try {
      isKitStatusFiltered.value = !isKitStatusFiltered.value;
      if (isKitStatusFiltered.value) {
        await filterParticipantsByKitStatus();
      } else {
        filteredParticipants.value = allParticipants;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> filterParticipantsByKitStatus() async {
    isLoading.value = true;
    try {
      List<Participant> notReceivedParticipants = [];
      for (var participant in allParticipants) {
        final kitStatus = await getParticipantKitStatus(participant);
        print(
            'Participant ${participant.uid} has kit status: $kitStatus'); // Debugging
        if (kitStatus == 'Not Received') {
          notReceivedParticipants.add(participant);
        } else if (kitStatus == 'Pending') {
          notReceivedParticipants.add(participant);
        }
      }
      filteredParticipants.value = notReceivedParticipants;
      print(
          'Filtered participants with status Not Received: ${notReceivedParticipants.length}'); // Debugging
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> getParticipantKitStatus(Participant participant) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('participantKit')
          .doc(participant.uid)
          .get();
      if (doc.exists) {
        final kitData = doc.data() as Map<String, dynamic>;
        final allStatuses = [
          ...?kitData['merchandise']?.values.map((item) => item['status']),
          ...?kitData['souvenir']?.values.map((item) => item['status']),
          ...?kitData['benefit']?.values.map((item) => item['status']),
        ];

        print('All statuses for ${participant.uid}: $allStatuses'); // Debugging

        // Check if there's at least one status that is 'Not Received'
        if (allStatuses.contains('Not Received')) {
          return 'Not Received';
        } else if (allStatuses.contains('Pending')) {
          return 'Pending';
        }
      }
    } catch (e) {
      print('Error fetching participant kit status: $e');
    }
    return 'Pending'; // Default value if 'Not Received' is not found
  }

  // Load the Google Sheets service account credentials
  Future<String> loadCredentials() async {
    return await rootBundle.loadString('assets/credentials/credentials.json');
  }

  // Authenticate and return the AuthClient
  Future<AuthClient> getAuthClient() async {
    String credentials = await loadCredentials();
    final serviceAccountCredentials =
        ServiceAccountCredentials.fromJson(json.decode(credentials));

    final scopes = [
      sheets.SheetsApi.spreadsheetsScope,
    ];

    return await clientViaServiceAccount(serviceAccountCredentials, scopes);
  }

  // Function to update Google Sheets status based on the userId and changed statuses
  Future<void> updateGoogleSheetStatus(
      String userId, Map<String, String> changedStatuses) async {
    final authClient = await getAuthClient();
    var sheetsApi = sheets.SheetsApi(authClient);

    String spreadsheetId = '1zOgCl7ngSUkTJTI9NortPjgfZeKrUA4YRsj0xNSbsVY';
    String range =
        'Sheet1!A2:V'; // Define the range where data exists (Columns A to V)

    // Fetch the sheet data
    final result =
        await sheetsApi.spreadsheets.values.get(spreadsheetId, range);
    List<List<dynamic>> rows = result.values ?? [];

    // Find the row by userId (assume userId is in column B)
    int rowIndex = rows.indexWhere((row) => row[1] == userId);

    if (rowIndex != -1) {
      // Mapping of kit items to column indices in the spreadsheet
      Map<String, int> columnMap = {
        'Polo Shirt': 14, // Column O
        'T-shirt': 15, // Column P
        'Luggage Tag': 16, // Column Q
        'Jas Hujan': 17, // Column R
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
          updatedRow[columnIndex] = newStatus; // Update the status in the row
        }
      }

      // Define the specific range to update (only the row that changed)
      String updateRange =
          'Sheet1!A${rowIndex + 2}:V${rowIndex + 2}'; // Row index is 0-based, Google Sheets is 1-based

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
  Future<void> updateAllStatusesToReceived(
      String userId, String category) async {
    final authClient = await getAuthClient();
    var sheetsApi = sheets.SheetsApi(authClient);

    String spreadsheetId =
        '1zOgCl7ngSUkTJTI9NortPjgfZeKrUA4YRsj0xNSbsVY'; // Your Google Sheets ID
    String range =
        'Sheet1!A2:V'; // Define the range where data exists (Columns A to V)

    // Fetch the sheet data
    final result =
        await sheetsApi.spreadsheets.values.get(spreadsheetId, range);
    List<List<dynamic>> rows = result.values ?? [];

    // Find the row by userId (assume userId is in column B)
    int rowIndex = rows.indexWhere((row) => row[1] == userId);

    if (rowIndex != -1) {
      // Define which columns to update based on the category
      Map<String, List<int>> categoryColumnMap = {
        'merchandise': [
          14,
          15,
          16,
          17
        ], // Columns O to R (Polo Shirt, T-shirt, Luggage Tag, Jas Hujan)
        'souvenir': [
          18,
          19
        ], // Columns S to T (Gelang Tridatu, Selendang/Udeng)
        'benefit': [
          20,
          21
        ] // Columns U to V (Voucher Belanja, Voucher E-Wallet)
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
        print(
            'All statuses in $category marked as Received for userId: $userId.');
      } else {
        print('Invalid category: $category');
      }
    } else {
      print('UserId not found in Google Sheets');
    }
  }

  Future<void> updateItemStatus(
      String participantId, String field, String newStatus) async {
    try {
      List<String> fieldParts = field.split('.');
      String category = fieldParts[0];
      String item = fieldParts[1];

      await FirebaseFirestore.instance
          .collection('participantKit')
          .doc(participantId)
          .update({'$category.$item.status': newStatus});

      final String Activityid = _firestore.collection('activityLogs').doc().id;
      // add logs activity
      final User? user = _auth.currentUser;
      if (user != null) {
        final DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        final String name = userDoc['name'] ?? '';
        await _firestore.collection('activityLogs').doc(Activityid).set({
          'type': 'participantkit_changed', // Set type as a simple string
          'participantName': selectedParticipant.value?.name ?? '',
          'itemName': '$category.$item',
          'newStatus': newStatus,
          'changedBy': name,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Update in Google Sheets
      // Make sure the item name matches exactly with the columnMap keys
      String itemName = fieldParts[1]
          .replaceAllMapped(RegExp(r'([A-Z])'), (Match m) => ' ${m.group(1)}')
          .trim();
      itemName = itemName[0].toUpperCase() +
          itemName.substring(1); // Capitalize first letter
      Map<String, String> changedStatuses = {itemName: newStatus};
      await updateGoogleSheetStatus(participantId, changedStatuses);

      // Update local state
      if (participantKitStatus.containsKey(category) &&
          participantKitStatus[category].containsKey(item)) {
        participantKitStatus[category][item]['status'] = newStatus;
      }

      // Refresh the participant kit status
      await fetchParticipantKitStatus(participantId);
    } catch (e) {
      print('Error updating item status: $e');
    }
  }

  Future<void> checkAllItems(String participantId, String category) async {
    try {
      Map<String, dynamic> updates = {};
      participantKitStatus[category].forEach((item, value) {
        updates['$category.$item.status'] = 'Received';
      });

      await FirebaseFirestore.instance
          .collection('participantKit')
          .doc(participantId)
          .update(updates);

      // Mark all selected items as received in Google Sheets
      await updateAllStatusesToReceived(participantId, category);

      final String Activityid = _firestore.collection('activityLogs').doc().id;
      // add logs activity
      final User? user = _auth.currentUser;
      if (user != null) {
        final DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        final String name = userDoc['name'] ?? '';
        await _firestore.collection('activityLogs').doc(Activityid).set({
          'type': 'participantkit_changed_all', // Set type as a simple string
          'participantName': selectedParticipant.value?.name ?? '',
          'itemName': '$category.',
          'newstatusAll': 'Received',
          'changedBy': name,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Update local state
      participantKitStatus[category].forEach((item, value) {
        value['status'] = 'Received';
      });

      // Refresh the participant kit status
      await fetchParticipantKitStatus(participantId);
    } catch (e) {
      print('Error checking all items: $e');
    }
  }

  Future<void> submitParticipantKit(String participantId) async {
    try {
      // Here you can implement the logic to submit the entire participant kit
      // For example, you might want to set a flag in Firestore to indicate the kit is submitted
      await FirebaseFirestore.instance
          .collection('participantKit')
          .doc(participantId)
          .update({
        'isSubmitted': true,
        'submitUpdatedAt': FieldValue.serverTimestamp(),
      });

      print('Participant kit submitted successfully');
    } catch (e) {
      print('Error submitting participant kit: $e');
    }
  }

  void setSelectedParticipant(Participant participant) {
    selectedParticipant.value = participant;
    fetchParticipantKitStatus(participant.uid);
  }

  Future<void> updateParticipantRole(
      String participantId, String newRole) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(participantId)
          .update({'role': newRole});

      // Update local state
      int index = allParticipants.indexWhere((p) => p.uid == participantId);
      if (index != -1) {
        Participant updatedParticipant = Participant(
          name: allParticipants[index].name,
          role: newRole,
          selfieUrl: allParticipants[index].selfieUrl,
          uid: participantId,
        );
        allParticipants[index] = updatedParticipant;
        if (selectedParticipant.value?.uid == participantId) {
          selectedParticipant.value = updatedParticipant;
        }
      }
    } catch (e) {
      print('Error updating participant role: $e');
    }
  }
}

class Participant {
  final String? department;
  final String? name;
  final String? email;
  final String? division;
  final String? area;
  final String? role;
  final String? selfieUrl;
  final String? address;
  final String? whatsappNumber;
  final String? nik;
  final String uid;
  final String? tShirtSize;
  final String? poloShirtSize;

  Participant(
      {this.email,
      this.division,
      this.department,
      this.area,
      this.name,
      this.role,
      this.selfieUrl,
      this.address,
      this.whatsappNumber,
      this.nik,
      this.tShirtSize,
      this.poloShirtSize,
      required this.uid});

  factory Participant.fromDocument(DocumentSnapshot doc) {
    return Participant(
      division: doc['division'] as String?,
      email: doc['email'] as String?,
      area: doc['area'] as String?,
      department: doc['department'] as String?,
      name: doc['name'] as String?,
      role: doc['role'] as String?,
      address: doc['address'] as String?,
      whatsappNumber: doc['whatsappNumber'] as String?,
      nik: doc['NIK'] as String?,
      selfieUrl: doc['selfieUrl'] as String?,
      tShirtSize: doc['tShirtSize'] as String?,
      poloShirtSize: doc['poloShirtSize'] as String?,
      uid: doc.id,
    );
  }
}
