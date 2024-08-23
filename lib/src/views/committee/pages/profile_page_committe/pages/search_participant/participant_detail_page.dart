// TODO STYlING TOLONG KRIS
import 'package:flutter/material.dart';
import 'package:app_kopabali/src/views/committee/pages/profile_page_committe/pages/search_participant/search_participant_controller.dart';

class ParticipantDetailPage extends StatelessWidget {
  final Participant participant;

  const ParticipantDetailPage({super.key, required this.participant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(participant.name ?? 'Participant Detail'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: participant.selfieUrl != null &&
                      participant.selfieUrl!.isNotEmpty
                  ? NetworkImage(participant.selfieUrl!)
                  : null,
              radius: 50,
              child: participant.selfieUrl == null ||
                      participant.selfieUrl!.isEmpty
                  ? Icon(Icons.person, size: 50)
                  : null,
            ),
            SizedBox(height: 16),
            Text(
              participant.name ?? 'Unknown',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Role: ${participant.role ?? 'Not specified'}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            // Add more details here if needed
          ],
        ),
      ),
    );
  }
}
