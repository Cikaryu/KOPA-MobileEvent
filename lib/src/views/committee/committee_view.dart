import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/committee/committee_controller.dart';
import 'package:app_kopabali/src/views/committee/pages/committee_page.dart';
import 'package:app_kopabali/src/views/committee/pages/event_page.dart';
import 'package:app_kopabali/src/views/committee/pages/home_page.dart';
import 'package:app_kopabali/src/views/committee/pages/profile_page.dart';
import 'package:app_kopabali/src/views/committee/pages/service_page.dart';

class CommitteeView extends StatelessWidget {
  CommitteeView({super.key});
  final CommitteeController committeeController =
      Get.put(CommitteeController());

  final List<Widget> _pages = [
    HomePageCommittee(),
    ProfileCommitteePage(),
    CommitteePage(),
    EventCommitteePage(),
    ServiceCommitteePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Committee View'),
      ),
      body: PageView.builder(
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
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                backgroundColor: Colors.blue,
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: 'Committee',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event),
                label: 'Event',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.build),
                label: 'Service',
              ),
            ],
            currentIndex: committeeController.selectedIndex.value,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black,
            onTap: (index) {
              committeeController.changeTabIndex(index);
            },
          )),
    );
  }
}
