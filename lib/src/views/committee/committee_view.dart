import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/committee/committee_controller.dart';
import 'package:app_kopabali/src/views/committee/pages/home_page.dart';
import 'package:app_kopabali/src/views/committee/pages/profile_page.dart';

class CommitteeView extends StatelessWidget {
  CommitteeView({super.key});
  final CommitteeController participantController =
      Get.put(CommitteeController());

  final List<Widget> _pages = [HomePageCommittee(), ProfileCommitteePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Committee View'),
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
