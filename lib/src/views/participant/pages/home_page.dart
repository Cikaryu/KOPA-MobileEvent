import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/participant/participant_controller.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  final ParticipantController participantController = Get.put(ParticipantController());
    return Center(
      child: Column(
        children: [
          Text('Home Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await participantController.logout();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
    );
  }
}
