import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/event_organizer/event_organizer_controller.dart';
import 'package:app_kopabali/src/views/event_organizer/pages/home_page/home_page.dart';
import 'package:app_kopabali/src/views/event_organizer/pages/profile_page_event_organizer/profile_page.dart';
import 'package:app_kopabali/src/views/event_organizer/pages/scan_page/scan_view.dart';
import 'package:app_kopabali/src/views/event_organizer/pages/service_page/reportlist_page.dart';

class EventOrganizerView extends StatelessWidget {
  EventOrganizerView({super.key});
  final EventOrganizerController committeeController =
      Get.put(EventOrganizerController());

  final List<Widget> _pages = [
    HomePageEventOrganizer(),
    ScannerView(),
    ReportListEventOrganizerPage(),
    ProfileEventOrganizerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        controller: committeeController.pageController,
        onPageChanged: (index) {
          committeeController.selectedIndex.value = index;
        },
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          return _pages[index];
        },
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                backgroundColor: HexColor('01613B'),
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                backgroundColor: HexColor('01613B'),
                icon: Icon(Icons.qr_code),
                label: 'Scan QR',
              ),
              BottomNavigationBarItem(
                backgroundColor: HexColor('01613B'),
                icon: Icon(Icons.group),
                label: 'Committee',
              ),
              BottomNavigationBarItem(
                backgroundColor: HexColor('01613B'),
                icon: Icon(Icons.build),
                label: 'Profile',
              ),
            ],
            currentIndex: committeeController.selectedIndex.value,
            selectedItemColor: HexColor('F3F3F3'),
            unselectedItemColor: HexColor('D4D4D4'),
            onTap: (index) {
              committeeController.changeTabIndex(index);
            },
          )),
    );
  }
}
