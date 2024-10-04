import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/participant/pages/profile/page/change_password_page.dart';
import 'package:app_kopabali/src/views/participant/pages/profile/page/edit_profile_page.dart';
import 'package:app_kopabali/src/views/participant/pages/profile/profile_controller.dart';
import 'package:flutter_svg/svg.dart';

// todo ubah participant kit ui
class ProfileParticipantPage extends StatelessWidget {
  const ProfileParticipantPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());

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
      body: Obx(() {
        return Container(
          color: Colors.white,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                // Kontainer untuk Profil
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
                                  image: profileController.imageBytes.value !=
                                          null
                                      ? DecorationImage(
                                          image: MemoryImage(profileController
                                              .imageBytes.value!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                  shape: OvalBorder(),
                                ),
                                child:
                                    profileController.imageBytes.value == null
                                        ? Icon(Icons.person,
                                            size: 82, color: Colors.grey[500])
                                        : null,
                              ),
                              SizedBox(height: 16),
                              Obx(() => Text(
                                    profileController.userName.value,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              Obx(() => Text(
                                    profileController.userEmail.value,
                                    style: TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              Obx(() => Text(
                                    profileController.role.value,
                                    style: TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        // Tombol untuk menampilkan QR
                        ElevatedButton(
                          onPressed: () async {
                            await profileController.fetchQrCodeUrl();
                            profileController.showQrDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor('E97717'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 12.0),
                          ),
                          child: Text(
                            'Show QR',
                            style: TextStyle(color: HexColor('F3F3F3')),
                          ),
                        ),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                // Container for Edit Profile
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
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
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => EditProfileView()),
                          );
                          profileController.resetForm();
                          profileController.getUserData;
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
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
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 16.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Edit Profile',
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
                      // Container for Change Password
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ChangePasswordPage()),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
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
                                  Icons.lock,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 16.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Change Password',
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
                      (profileController.hasPreviouslyBeenCommittee.value ||
                              profileController
                                  .hasPreviouslyBeenSuperEO.value ||
                              profileController
                                  .hasPreviouslyBeenEventOrganizer.value)
                          ? InkWell(
                              onTap: () {
                                profileController.switchRole();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
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
                SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Participant Kit',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Merch Section
                buildDropdownContainer(
                  profileController,
                  'Merch',
                  'merch',
                  [
                    buildStatusRow(
                        profileController,
                        'Polo Shirt (${profileController.poloShirtSize.value})',
                        'merchandise.poloShirt'),
                    buildStatusRow(
                        profileController,
                        'T-Shirt (${profileController.tShirtSize.value})',
                        'merchandise.tShirt'),
                    buildStatusRow(
                        profileController, 'Luggage Tag', 'merchandise.luggageTag'),
                    buildStatusRow(
                        profileController, 'Jas Hujan', 'merchandise.jasHujan'),
                  ],
                ),
                SizedBox(height: 24),
                // Souvenir Section
                buildDropdownContainer(
                  profileController,
                  'Souvenir',
                  'souvenir',
                  [
                    buildStatusRow(profileController, 'Gelang Tridatu',
                        'souvenir.gelangTridatu'),
                    buildStatusRow(profileController, 'Selendang/Udeng',
                        'souvenir.selendangUdeng'),
                  ],
                ),
                SizedBox(height: 24),
                // Benefit Section
                buildDropdownContainer(
                  profileController,
                  'Benefit',
                  'benefit',
                  [
                    buildStatusRow(profileController, 'Voucher Belanja',
                        'benefit.voucherBelanja'),
                    buildStatusRow(profileController, 'Voucher E-Wallet',
                        'benefit.voucherEwallet'),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Center(
                  child: Container(
                    height: 48,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () async {
                        await profileController.logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor("C63131"),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Log Out',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildDropdownContainer(ProfileController controller, String title,
      String containerName, List<Widget> children) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: HexColor('F3F3F3'),
          shadows: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 0),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                controller.toggleContainerExpansion(containerName);
              },
              child: Container(
                padding: EdgeInsets.all(8),
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Obx(() {
                          return Icon(
                            controller.isContainerExpanded(containerName)
                                ? Icons.keyboard_arrow_down_rounded
                                : Icons.keyboard_arrow_up_rounded,
                            color: Colors.grey,
                          );
                        }),
                      ],
                    ),
                    SizedBox(height: 8),
                    Obx(() {
                      return AnimatedContainer(
                        width: 300,
                        duration: Duration(milliseconds: 300),
                        height: controller.isContainerExpanded(containerName)
                            ? (children.length * 40 + 40)
                            : 0,
                        curve: Curves.easeInOut,
                        child: SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Items',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Status',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              ...children,
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatusRow(
      ProfileController controller, String itemName, String field) {
    return Obx(() {
      String status =
          controller.getStatusForItem(field.split('.')[0], field.split('.')[1]);
          print('Building status row for $itemName: $status');
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                itemName,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: controller.getStatusColor(status),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 8),
                    SvgPicture.asset(
                      controller.getStatusImagePath(
                        status,
                      ),
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
        ],
      );
    });
  }
}
