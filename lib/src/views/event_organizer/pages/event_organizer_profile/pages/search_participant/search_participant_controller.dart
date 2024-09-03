import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class SearchParticipantController extends GetxController {
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

  @override
  void onInit() {
    super.onInit();
    fetchParticipants();
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

  void toggleContainerExpansion(String containerName) {
    if (expandedContainer.value == containerName) {
      expandedContainer.value = ''; // close if it's already open
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

  Color getStatusColor(String status) {
    switch (status) {
      case 'Received':
        return Colors.green;
      case 'Pending':
        return HexColor('F0B811');
      case 'Not Received':
        return Colors.red;
      default:
        print('Unhandled status: $status'); // Debugging statement
        return Colors.grey; // Default color for unknown status
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
}

class Participant {
  final String? department;
  final String? name;
  final String? email;
  final String? division;
  final String? area;
  final String? role;
  final String? selfieUrl;
  final String uid;

  Participant(
      {this.email,
      this.division,
      this.department,
      this.area,
      this.name,
      this.role,
      this.selfieUrl,
      required this.uid});

  factory Participant.fromDocument(DocumentSnapshot doc) {
    return Participant(
      division: doc['division'] as String?,
      email: doc['email'] as String?,
      area: doc['area'] as String?,
      department: doc['department'] as String?,
      name: doc['name'] as String?,
      role: doc['role'] as String?,
      selfieUrl: doc['selfieUrl'] as String?,
      uid: doc.id,
    );
  }
}
