import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/participant/pages/profile/profile_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileParticipantPage extends StatelessWidget {
  const ProfileParticipantPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('My Profile')),
      ),
      body: Obx(() {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kontainer untuk Profil
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
                      SizedBox(height: 32),
                      // Informasi pengguna
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        width: 300,
                        child: Column(
                          children: [
                            Row(
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
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        profileController.userName.value,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        profileController.userEmail.value,
                                        style: TextStyle(fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        profileController.userDivisi.value,
                                        style: TextStyle(fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // Tombol untuk menampilkan QR
                      Container(
                        width: 164,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () async {
                            await profileController.fetchQrCodeUrl();
                            profileController.showQrDialog(context);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(HexColor('E97717')),
                          ),
                          child: Text(
                            'Show QR',
                            style: TextStyle(color: HexColor('F3F3F3')),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Container for Edit Profile
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        Get.toNamed('/editprofile');
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          color: HexColor("#F3F3F3"),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10.0,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.orange,
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
                                Text(
                                  'Update your profile information',
                                  style: TextStyle(
                                    color: Colors.grey,
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
                        Get.toNamed('/changepassword');
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          color: HexColor("#F3F3F3"),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10.0,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lock,
                              color: Colors.orange,
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
                                Text(
                                  'Change your account password',
                                  style: TextStyle(
                                    color: Colors.grey,
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
                  ],
                ),
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Participant Kit',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 12),
              // Kontainer untuk Merchandise
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                      GestureDetector(
                        onTap: () {
                          profileController.isMerchExpanded.toggle();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Merch',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    profileController.isMerchExpanded.value
                                        ? Icons.keyboard_arrow_down_rounded
                                        : Icons.keyboard_arrow_right_rounded,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              AnimatedContainer(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                width: 300,
                                duration: Duration(milliseconds: 300),
                                height: profileController.isMerchExpanded.value
                                    ? 240
                                    : 0,
                                curve: Curves.easeInOut,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Name',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            'Status',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Polo Shirt (${profileController.tShirtSize.value})',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Obx(() {
                                            // Gunakan Obx untuk mendengarkan perubahan nilai
                                            if (profileController
                                                .isLoadingStatusImage.value) {
                                              return CircularProgressIndicator(); // Tampilkan indikator loading
                                            }
                                            if (profileController
                                                .statusImageUrl.value.isEmpty) {
                                              return Icon(Icons
                                                  .error); // Tampilkan ikon error jika gagal
                                            }
                                            return Image.network(
                                              profileController
                                                  .statusImageUrl.value,
                                              width: 24,
                                              height: 24,
                                            ); // Tampilkan gambar status
                                          }),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'T-Shirt (${profileController.tShirtSize.value})',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Obx(() {
                                            if (profileController
                                                .isLoadingStatusImage.value) {
                                              return CircularProgressIndicator(); // Tampilkan indikator loading
                                            }
                                            if (profileController
                                                .statusImageUrl.value.isEmpty) {
                                              return Icon(Icons
                                                  .error); // Tampilkan ikon error jika gagal
                                            }
                                            return Image.network(
                                              profileController
                                                  .statusImageUrl.value,
                                              width: 24,
                                              height: 24,
                                            ); // Tampilkan gambar status
                                          }),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Luggage Tag',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Obx(() {
                                            if (profileController
                                                .isLoadingStatusImage.value) {
                                              return CircularProgressIndicator(); // Tampilkan indikator loading
                                            }
                                            if (profileController
                                                .statusImageUrl.value.isEmpty) {
                                              return Icon(Icons
                                                  .error); // Tampilkan ikon error jika gagal
                                            }
                                            return Image.network(
                                              profileController
                                                  .statusImageUrl.value,
                                              width: 24,
                                              height: 24,
                                            ); // Tampilkan gambar status
                                          }),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Jas Hujan',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Obx(() {
                                            if (profileController
                                                .isLoadingStatusImage.value) {
                                              return CircularProgressIndicator(); // Tampilkan indikator loading
                                            }
                                            if (profileController
                                                .statusImageUrl.value.isEmpty) {
                                              return Icon(Icons
                                                  .error); // Tampilkan ikon error jika gagal
                                            }
                                            return Image.network(
                                              profileController
                                                  .statusImageUrl.value,
                                              width: 24,
                                              height: 24,
                                            ); // Tampilkan gambar status
                                          }),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Kontainer untuk Souvenir
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                      GestureDetector(
                        onTap: () {
                          profileController.isSouvenirExpanded.toggle();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Souvenir',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    profileController.isSouvenirExpanded.value
                                        ? Icons.keyboard_arrow_down_rounded
                                        : Icons.keyboard_arrow_right_rounded,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              AnimatedContainer(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                width: 300,
                                duration: Duration(milliseconds: 300),
                                height:
                                    profileController.isSouvenirExpanded.value
                                        ? 240
                                        : 0,
                                curve: Curves.easeInOut,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Name',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            'Status',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Center(
                child: Container(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: () async {
                      await profileController.logout();
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor("#C63131"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
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
        );
      }),
    );
  }
}
