import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/committee/committee_controller.dart';
import 'package:app_kopabali/src/views/committee/pages/home_page/home_page.dart';
import 'package:app_kopabali/src/views/committee/pages/profile_page_committe/profile_page.dart';
import 'package:app_kopabali/src/views/committee/pages/scan_page/scan_view.dart';
import 'package:app_kopabali/src/views/committee/pages/service_page/service_page.dart';

class CommitteeView extends StatelessWidget {
  CommitteeView({super.key});
  final CommitteeController committeeController =
      Get.put(CommitteeController());

  final List<Widget> _pages = [
    HomePageCommittee(),
    ScannerView(),
    ServiceCommitteePage(),
    ProfileCommitteePage(),
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
            ),
          )),
    );
  }
}
