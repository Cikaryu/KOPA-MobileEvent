import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchParticipantController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<Participant> allParticipants = <Participant>[].obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
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

  @override
  void onInit() {
    super.onInit();
    fetchParticipants();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {}
  }

  @override
  void onReady() async {
    super.onReady();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
    } else {
      debugPrint("User not logged in");
    }
    update();
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
          .where('role', isEqualTo: 'Participant')
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

  Future<void> updateItemStatus(
    String participantId,
    String field,
    String newStatus,
  ) async {
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
      Get.snackbar("Success", "All items in $category marked as received.");
    } catch (e, stackTrace) {
      print('Error checking all items: $e');
      print('Stack trace: $stackTrace');
      Get.snackbar("Error", "Failed to update all items: ${e.toString()}");
    }
  }

// Add this new method to show the confirmation dialog

  Future<void> submitParticipantKit(String participantId) async {
    try {
      // Here you can implement the logic to submit the entire participant kit
      // For example, you might want to set a flag in Firestore to indicate the kit is submitted
      await FirebaseFirestore.instance
          .collection('participantKit')
          .doc(participantId)
          .update({
        'isSubmitted': true,
        'submittedAt': FieldValue.serverTimestamp(),
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
    String participantId,
    String newRole,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(participantId)
          .update({'role': newRole});

      // Buat log aktivitas
      final String Activityid = _firestore.collection('activityLogs').doc().id;

      // Buat log aktivitas
      final User? user = _auth.currentUser;
      if (user != null) {
        final DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        final String name = userDoc['name'] ?? '';
        await _firestore.collection('activityLogs').doc(Activityid).set({
          'type': 'user_promotion',
          'ParticipantName': selectedParticipant.value?.name ?? '',
          'newRole': newRole,
          'ChangedBy': name,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
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
