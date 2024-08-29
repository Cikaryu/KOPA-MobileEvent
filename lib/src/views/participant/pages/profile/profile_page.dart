import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/participant/pages/profile/page/change_password_page.dart';
import 'package:app_kopabali/src/views/participant/pages/profile/page/edit_profile_page.dart';
import 'package:app_kopabali/src/views/participant/pages/profile/profile_controller.dart';

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
        backgroundColor: HexColor('01613B'),
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
                                    profileController.userDivisi.value,
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
                      profileController.hasPreviouslyBeenCommittee.value
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
                SizedBox(height: 12),
                // Kontainer untuk Merchandise
                Center(
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
                            profileController.toggleMerchExpanded();
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
                                  width: 300,
                                  duration: Duration(milliseconds: 300),
                                  height:
                                      profileController.isMerchExpanded.value
                                          ? 180
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Polo Shirt (${profileController.poloShirtSize.value})',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            Obx(() {
                                              final imageUrl = profileController
                                                          .statusImageUrls[
                                                      'poloShirt'] ??
                                                  '';

                                              if (imageUrl.isEmpty) {
                                                return Icon(Icons
                                                    .error); // Menampilkan ikon error jika gambar gagal diambil
                                              }
                                              return Image.network(
                                                imageUrl,
                                                width: 24,
                                                height: 24,
                                              ); // Menampilkan gambar status jika berhasil diambil
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
                                              final imageUrl = profileController
                                                          .statusImageUrls[
                                                      'tShirt'] ??
                                                  '';

                                              if (imageUrl.isEmpty) {
                                                return Icon(Icons
                                                    .error); // Menampilkan ikon error jika gambar gagal diambil
                                              }
                                              return Image.network(
                                                imageUrl,
                                                width: 24,
                                                height: 24,
                                              ); // Menampilkan gambar status jika berhasil diambil
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
                                              final imageUrl = profileController
                                                          .statusImageUrls[
                                                      'luggageTag'] ??
                                                  '';

                                              if (imageUrl.isEmpty) {
                                                return Icon(Icons
                                                    .error); // Menampilkan ikon error jika gambar gagal diambil
                                              }
                                              return Image.network(
                                                imageUrl,
                                                width: 24,
                                                height: 24,
                                              ); // Menampilkan gambar status jika berhasil diambil
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
                                              final imageUrl = profileController
                                                          .statusImageUrls[
                                                      'jasHujan'] ??
                                                  '';

                                              if (imageUrl.isEmpty) {
                                                return Icon(Icons
                                                    .error); // Menampilkan ikon error jika gambar gagal diambil
                                              }
                                              return Image.network(
                                                imageUrl,
                                                width: 24,
                                                height: 24,
                                              ); // Menampilkan gambar status jika berhasil diambil
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
                            profileController.toggleSouvenirExpanded();
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
                                  width: 300,
                                  duration: Duration(milliseconds: 300),
                                  height:
                                      profileController.isSouvenirExpanded.value
                                          ? 180
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Gelang Tridatu',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            Obx(() {
                                              final imageUrl = profileController
                                                          .statusImageUrls[
                                                      'gelangTridatu'] ??
                                                  '';

                                              if (imageUrl.isEmpty) {
                                                return Icon(Icons
                                                    .error); // Menampilkan ikon error jika gambar gagal diambil
                                              }
                                              return Image.network(
                                                imageUrl,
                                                width: 24,
                                                height: 24,
                                              ); // Menampilkan gambar status jika berhasil diambil
                                            }),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Selendang/Udeng',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            Obx(() {
                                              final imageUrl = profileController
                                                          .statusImageUrls[
                                                      'selendangUdeng'] ??
                                                  '';

                                              if (imageUrl.isEmpty) {
                                                return Icon(Icons
                                                    .error); // Menampilkan ikon error jika gambar gagal diambil
                                              }
                                              return Image.network(
                                                imageUrl,
                                                width: 24,
                                                height: 24,
                                              ); // Menampilkan gambar status jika berhasil diambil
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
                // Kontainer untuk Benefit
                Center(
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
                            profileController.toggleBenefitExpanded();
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
                                      'Benefit',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(
                                      profileController.isBenefitExpanded.value
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
                                  width: 300,
                                  duration: Duration(milliseconds: 300),
                                  height:
                                      profileController.isBenefitExpanded.value
                                          ? 180
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Voucher E-Wallet',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            Obx(() {
                                              final imageUrl = profileController
                                                          .statusImageUrls[
                                                      'voucherEwallet'] ??
                                                  '';

                                              if (imageUrl.isEmpty) {
                                                return Icon(Icons
                                                    .error); // Menampilkan ikon error jika gambar gagal diambil
                                              }
                                              return Image.network(
                                                imageUrl,
                                                width: 24,
                                                height: 24,
                                              ); // Menampilkan gambar status jika berhasil diambil
                                            }),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Voucher Belanja',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            Obx(() {
                                              final imageUrl = profileController
                                                          .statusImageUrls[
                                                      'voucherBelanja'] ??
                                                  '';

                                              if (imageUrl.isEmpty) {
                                                return Icon(Icons
                                                    .error); // Menampilkan ikon error jika gambar gagal diambil
                                              }
                                              return Image.network(
                                                imageUrl,
                                                width: 24,
                                                height: 24,
                                              ); // Menampilkan gambar status jika berhasil diambil
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
}
