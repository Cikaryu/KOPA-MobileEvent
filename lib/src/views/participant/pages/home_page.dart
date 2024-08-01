import 'package:app_kopabali/src/views/participant/participant_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_kopabali/src/views/testing/login/login_controller.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final participantController = Get.find<ParticipantController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await participantController.logout();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Home Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
