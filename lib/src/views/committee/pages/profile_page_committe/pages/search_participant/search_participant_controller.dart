import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// TODO Function fetch data status participant kit

class SearchParticipantController extends GetxController {
  RxList<Participant> allParticipants = <Participant>[].obs;
  RxList<Participant> filteredParticipants = <Participant>[].obs;
  TextEditingController searchController = TextEditingController();
  RxBool isAscending = true.obs;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      participantKitSubscription;
  final RxMap<String, String> statusImageUrls = <String, String>{}.obs;
  RxMap<String, String> status = <String, String>{}.obs;
  var isMerchExpanded = false.obs;
  var isSouvenirExpanded = false.obs;
  var isBenefitExpanded = false.obs;
  var tShirtSize = ''.obs;
  var poloShirtSize = ''.obs;
  var isLoading = false.obs;
  Rx<Stream<DocumentSnapshot>>? participantKitStream;

  @override
  void onInit() {
    super.onInit();
    fetchParticipants();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      getUserData(user);
      initParticipantKitStream();
    }
  }

  @override
  void onReady() async {
    super.onReady();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await getUserData(user);
      listenToParticipantKitStatus(user); 
    } else {
      debugPrint("User not logged in");
    }
    update();
  }

  void initParticipantKitStream() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      participantKitStream = FirebaseFirestore.instance
          .collection('participantKit')
          .doc(user.uid)
          .snapshots()
          .obs;
    }
  }

  void updateParticipantKitStatus(DocumentSnapshot doc) {
    if (doc.exists) {
      final participantKit = doc.data() as Map<String, dynamic>;
      final merchandise = participantKit['merchandise'] ?? {};
      final souvenirs = participantKit['souvenir'] ?? {};
      final benefits = participantKit['benefit'] ?? {};

      status.clear();
      statusImageUrls.clear();

      updateStatusAndFetchImage(merchandise);
      updateStatusAndFetchImage(souvenirs);
      updateStatusAndFetchImage(benefits);
    } else {
      debugPrint('No participantKit data found');
    }
  }

  void updateStatusAndFetchImage(Map<String, dynamic> items) {
    items.forEach((key, value) {
      status[key] = value['status'];
      fetchStatusImage(key, value['status']);
    });
  }

  void toggleMerchExpanded() {
    isMerchExpanded.value = !isMerchExpanded.value;
    if (isMerchExpanded.value) {
      isSouvenirExpanded.value = false;
      isBenefitExpanded.value = false;
    }
  }

  void toggleSouvenirExpanded() {
    isSouvenirExpanded.value = !isSouvenirExpanded.value;
    if (isSouvenirExpanded.value) {
      isMerchExpanded.value = false;
      isBenefitExpanded.value = false;
    }
  }

  void toggleBenefitExpanded() {
    isBenefitExpanded.value = !isBenefitExpanded.value;
    if (isBenefitExpanded.value) {
      isMerchExpanded.value = false;
      isSouvenirExpanded.value = false;
    }
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

  void refreshData() async {
    setLoading(true);
    await Future.delayed(Duration(milliseconds: 500));
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        initParticipantKitStream(); // Refresh participant kit status
      } else {
        debugPrint("User not logged in");
      }
    } catch (e) {
      debugPrint('Error refreshing data: $e');
    } finally {
      setLoading(false);
    }
  }

  void listenToParticipantKitStatus(User user) {
    participantKitSubscription = FirebaseFirestore.instance
        .collection('participantKit')
        .doc(user.uid)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        final participantKit = doc.data()!;
        final merchandise = participantKit['merchandise'] ?? {};
        final souvenirs = participantKit['souvenir'] ?? {};
        final benefits = participantKit['benefit'] ?? {};

        // Clear previous status
        status.clear();
        statusImageUrls.clear();

        // Add merchandise status and fetch images
        merchandise.forEach((key, value) {
          status[key] = value['status'];
          fetchStatusImage(key, value['status']);
        });

        // Add souvenirs status and fetch images
        souvenirs.forEach((key, value) {
          status[key] = value['status'];
          fetchStatusImage(key, value['status']);
        });

        // Add benefits status and fetch images
        benefits.forEach((key, value) {
          status[key] = value['status'];
          fetchStatusImage(key, value['status']);
        });

        // Call update() on the controller to refresh the UI if needed
        update();
      } else {
        debugPrint('No participantKit data found');
      }
    });
  }

  Future<void> fetchStatusImage(String key, String status) async {
    String imageName;

    switch (status) {
      case 'Pending':
        imageName = 'pending.png';
        break;
      case 'Received':
        imageName = 'received.png';
        break;
      case 'Close':
        imageName = 'close.png';
        break;
      default:
        imageName = 'default.png';
    }

    try {
      final downloadUrl = await FirebaseStorage.instance
          .ref('status/$imageName')
          .getDownloadURL();
      statusImageUrls[key] = downloadUrl;
    } catch (e) {
      debugPrint('Error fetching status image: $e');
      statusImageUrls[key] = ''; // Set to empty string if failed
    }
  }

  @override
  void onClose() {
    participantKitSubscription?.cancel();
    super.onClose();
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
}

class Participant {
  final String? name;
  final String? role;
  final String? selfieUrl;

  Participant({this.name, this.role, this.selfieUrl});

  factory Participant.fromDocument(DocumentSnapshot doc) {
    return Participant(
      name: doc['name'] as String?,
      role: doc['role'] as String?,
      selfieUrl: doc['selfieUrl'] as String?,
    );
  }
}
