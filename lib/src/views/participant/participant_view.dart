import 'package:app_kopabali/src/views/participant/pages/event_page.dart';
import 'package:app_kopabali/src/views/participant/pages/home_page.dart';
import 'package:app_kopabali/src/views/participant/pages/participant_page.dart';
import 'package:app_kopabali/src/views/participant/pages/profile_page.dart';
import 'package:app_kopabali/src/views/participant/pages/service_page.dart';
import 'package:app_kopabali/src/views/participant/participant_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParticipantView extends StatelessWidget {
  ParticipantView({super.key});
  final ParticipantController participantController =
      Get.put(ParticipantController());

  final List<Widget> _pages = [
    HomePage(),
    EventPage(),
    ParticipantPage(),
    ServicePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Participant View'),
      ),
      body: PageView.builder(
        controller: participantController.pageController,
        onPageChanged: (index) {
          participantController.selectedIndex.value = index;
        },
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          return _pages[index];
        },
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                backgroundColor: Colors.blue,
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event),
                label: 'Event',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Participant',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Service',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: participantController.selectedIndex.value,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black,
            onTap: (index) {
              participantController.changeTabIndex(index);
            },
          )),
    );
  }
}
