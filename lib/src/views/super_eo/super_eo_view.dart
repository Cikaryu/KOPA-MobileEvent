import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/super_eo/pages/home_page/home_page.dart';
import 'package:app_kopabali/src/views/super_eo/pages/scan_page/scan_view.dart';
import 'package:app_kopabali/src/views/super_eo/pages/service_page/reportlist_page.dart';
import 'package:app_kopabali/src/views/super_eo/pages/super_eo_profile_page/profile_page.dart';
import 'package:app_kopabali/src/views/super_eo/super_eo_controller.dart';

class SuperEOView extends StatelessWidget {
  SuperEOView({super.key});
  final SuperEOController superEOController = Get.put(SuperEOController());

  final List<Widget> _pages = [
    HomePageSuperEO(),
    ScannerView(),
    ReportListSuperEOPage(),
    ProfileSuperEOPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        controller: superEOController.pageController,
        onPageChanged: (index) {
          superEOController.selectedIndex.value = index;
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
                icon: Icon(Icons.receipt_long_rounded),
                label: 'Reports List',
              ),
              BottomNavigationBarItem(
                backgroundColor: HexColor('01613B'),
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: superEOController.selectedIndex.value,
            selectedItemColor: HexColor('F3F3F3'),
            unselectedItemColor: HexColor('D4D4D4'),
            onTap: (index) {
              superEOController.changeTabIndex(index);
            },
          )),
    );
  }
}
