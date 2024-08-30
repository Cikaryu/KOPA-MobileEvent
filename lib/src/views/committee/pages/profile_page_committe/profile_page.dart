import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/committee/pages/profile_page_committe/pages/search_participant/search_participant_page.dart';
import 'package:app_kopabali/src/views/committee/pages/profile_page_committe/profile_controller.dart';


class ProfileCommitteePage extends StatelessWidget {
  const ProfileCommitteePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileCommitteeController profileCommitteeController =
        Get.put(ProfileCommitteeController());

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Center(
          child: Text('My Profile',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: HexColor('01613B'),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Obx(
        () {
          return Container(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
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
                                    image: profileCommitteeController
                                                .imageBytes.value !=
                                            null
                                        ? DecorationImage(
                                            image: MemoryImage(
                                                profileCommitteeController
                                                    .imageBytes.value!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                    shape: OvalBorder(),
                                  ),
                                  child: profileCommitteeController
                                              .imageBytes.value ==
                                          null
                                      ? Icon(Icons.person,
                                          size: 82, color: Colors.grey[500])
                                      : null,
                                ),
                                SizedBox(height: 16),
                                Obx(() => Text(
                                      profileCommitteeController.userName.value,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                Obx(() => Text(
                                      profileCommitteeController
                                          .userEmail.value,
                                      style: TextStyle(fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                Obx(() => Text(
                                      profileCommitteeController
                                          .userDivisi.value,
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
                          onTap: () {},
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
                        profileCommitteeController.role.value == 'Committee'
                            ? InkWell(
                                onTap: () {
                                  profileCommitteeController.switchRole();
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
                      await profileCommitteeController.logout();
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
