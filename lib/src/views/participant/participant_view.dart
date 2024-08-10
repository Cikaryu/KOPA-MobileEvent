import 'package:app_kopabali/src/views/participant/pages/home/home_page.dart';
import 'package:app_kopabali/src/views/participant/pages/attendance/attendance_page.dart';
import 'package:app_kopabali/src/views/participant/pages/profile/profile_page.dart';
import 'package:app_kopabali/src/views/participant/pages/service/service_page.dart';
import 'package:app_kopabali/src/views/participant/participant_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ParticipantView extends StatelessWidget {
  ParticipantView({super.key});
  final ParticipantController participantController =
      Get.put(ParticipantController());

  final List<Widget> _pages = [
    HomePageParticipant(),
    AttendancePage(),
    ServicePage(),
    ProfileParticipantPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        controller: participantController.pageController,
        onPageChanged: (index) {
          participantController.selectedIndex.value = index;
        },
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          return _pages[index];
        },
      ),
      bottomNavigationBar: Obx(() => ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  backgroundColor: HexColor('01613B'),
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  backgroundColor: HexColor('01613B'),
                  label: 'Attendance',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  backgroundColor: HexColor('01613B'),
                  label: 'Service',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  backgroundColor: HexColor('01613B'),
                  label: 'Profile',
                ),
              ],
              currentIndex: participantController.selectedIndex.value,
              selectedItemColor: HexColor('F3F3F3'),
              unselectedItemColor: HexColor('D4D4D4'),
              onTap: (index) {
                participantController.changeTabIndex(index);
              },
            ),
          )),
    );
  }
}
