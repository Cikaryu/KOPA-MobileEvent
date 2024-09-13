import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/super_eo/pages/super_eo_profile_page/pages/data_logs/data_logs.dart';
import 'package:app_kopabali/src/views/super_eo/pages/super_eo_profile_page/pages/export_data/export_data_page.dart';
import 'package:app_kopabali/src/views/super_eo/pages/super_eo_profile_page/pages/search_participant/search_participant_page.dart';
import 'package:app_kopabali/src/views/super_eo/pages/super_eo_profile_page/profile_controller.dart';

class ProfileSuperEOPage extends StatelessWidget {
  const ProfileSuperEOPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileSuperEOController profileSuperEOController =
        Get.put(ProfileSuperEOController());

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Center(
          child: Text('My Profile',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: HexColor('727578'),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Obx(
        () {
          return Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: HexColor('F3F3F3'),
                        shadows: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(1, 1),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          // Informasi pengguna
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            width: 300,
                            child: Column(
                              children: [
                                Container(
                                  width: 82,
                                  height: 82,
                                  decoration: ShapeDecoration(
                                    image: profileSuperEOController
                                                .imageBytes.value !=
                                            null
                                        ? DecorationImage(
                                            image: MemoryImage(
                                                profileSuperEOController
                                                    .imageBytes.value!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                    shape: OvalBorder(),
                                  ),
                                  child: profileSuperEOController
                                              .imageBytes.value ==
                                          null
                                      ? Icon(Icons.person,
                                          size: 82, color: Colors.grey[500])
                                      : null,
                                ),
                                SizedBox(height: 16),
                                Obx(() => Text(
                                      profileSuperEOController.userName.value,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                Obx(() => Text(
                                      profileSuperEOController.userEmail.value,
                                      style: TextStyle(fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                Obx(() => Text(
                                      profileSuperEOController.role.value,
                                      style: TextStyle(fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    width: Get.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'General',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SearchParticipantPage()),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            decoration: BoxDecoration(
                                // color: HexColor("#F3F3F3"),
                                // borderRadius: BorderRadius.circular(20),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Color(0x3F000000),
                                //     blurRadius: 4,
                                //     spreadRadius: 0,
                                //     offset: Offset(0, 0),
                                //   ),
                                // ],
                                ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: HexColor("E97717"),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        spreadRadius: 0,
                                        offset: Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.person_2_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Search Participant',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ExportDataPage()),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: HexColor("E97717"),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        spreadRadius: 0,
                                        offset: Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.upload_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Export Data',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => DataLogsPageView()),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: HexColor("E97717"),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        spreadRadius: 0,
                                        offset: Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.copy,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Data Logs',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        profileSuperEOController.role.value ==
                                'Super Event Organizer'
                            ? InkWell(
                                onTap: () {
                                  profileSuperEOController.switchRole();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  decoration: BoxDecoration(
                                      // color: HexColor("#F3F3F3"),
                                      // borderRadius: BorderRadius.circular(20),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Color(0x3F000000),
                                      //     blurRadius: 4,
                                      //     spreadRadius: 0,
                                      //     offset: Offset(0, 0),
                                      //   ),
                                      // ],
                                      ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: HexColor("E97717"),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0x3F000000),
                                              spreadRadius: 0,
                                              offset: Offset(0, 0),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.import_export_rounded,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 16.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Switch account',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.keyboard_arrow_right_rounded,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () async {
                      await profileSuperEOController.logout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Log Out',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
