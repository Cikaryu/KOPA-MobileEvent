import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchParticipantController extends GetxController {
  // Reactive variables
  RxList<Participant> allParticipants = <Participant>[].obs;
  RxList<Participant> filteredParticipants = <Participant>[].obs;

  // TextEditingController for the search field
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchParticipants();
  }

  // Fetch participants from Firestore
  Future<void> fetchParticipants() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'participant')
          .get();

      final participants = querySnapshot.docs
          .map((doc) => Participant.fromDocument(doc))
          .toList();

      allParticipants.value = participants;
      filteredParticipants.value = participants;
    } catch (e) {
      print('Error fetching participants: $e');
      // Handle errors here (e.g., show a snackbar or dialog)
    }
  }

  // Search participants by name
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
}

// Participant class definition
class Participant {
  final String? name;
  final String? role;
  final String? selfieUrl;

  Participant({this.name, this.role, this.selfieUrl});

  // Factory method to create a Participant from Firestore document
  factory Participant.fromDocument(DocumentSnapshot doc) {
    return Participant(
      name: doc['name'] as String?,
      role: doc['role'] as String?,
      selfieUrl: doc['selfieUrl'] as String?,
    );
  }
}
