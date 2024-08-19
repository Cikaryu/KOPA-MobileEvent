import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScanProfileView extends StatelessWidget {
  final String userId = Get.arguments['userId'];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ScanProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Participant Profile'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('users').doc(userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Participant not found.'));
          }

          var participantData = snapshot.data!;
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${participantData['name']}'),
                Text('Email: ${participantData['email']}'),
                // Tambahkan detail lainnya sesuai kebutuhan
              ],
            ),
          );
        },
      ),
    );
  }
}
