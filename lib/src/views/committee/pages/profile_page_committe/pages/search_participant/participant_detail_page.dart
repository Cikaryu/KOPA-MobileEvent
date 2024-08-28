import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/committee/pages/profile_page_committe/pages/search_participant/search_participant_controller.dart';

// TODO Function fetch data status participant kit
class ParticipantDetailPage extends StatelessWidget {
  final Participant participant;

  const ParticipantDetailPage({super.key, required this.participant});

  @override
  Widget build(BuildContext context) {
    final SearchParticipantController profileController =
        Get.put(SearchParticipantController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Participant Detail'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Obx(
        () {
          return Container(
            width: Get.width,
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: participant.selfieUrl != null &&
                            participant.selfieUrl!.isNotEmpty
                        ? NetworkImage(participant.selfieUrl!)
                        : null,
                    radius: 50,
                    child: participant.selfieUrl == null ||
                            participant.selfieUrl!.isEmpty
                        ? Icon(Icons.person, size: 50)
                        : null,
                  ),
                  SizedBox(height: 16),
                  Text(
                    participant.name ?? 'Unknown',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    participant.role ?? 'Not specified',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  // Add more details here if needed
                  SizedBox(height: 24),

                  // Kontainer untuk Merchandise
                  Center(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
                                            : Icons
                                                .keyboard_arrow_right_rounded,
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                'Status',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                final imageUrl =
                                                    profileController
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
                                                final imageUrl =
                                                    profileController
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
                                                final imageUrl =
                                                    profileController
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
                                                final imageUrl =
                                                    profileController
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
                                        profileController
                                                .isSouvenirExpanded.value
                                            ? Icons.keyboard_arrow_down_rounded
                                            : Icons
                                                .keyboard_arrow_right_rounded,
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
                                    height: profileController
                                            .isSouvenirExpanded.value
                                        ? 120
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                'Status',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                final imageUrl =
                                                    profileController
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
                                                final imageUrl =
                                                    profileController
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
                                        profileController
                                                .isBenefitExpanded.value
                                            ? Icons.keyboard_arrow_down_rounded
                                            : Icons
                                                .keyboard_arrow_right_rounded,
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
                                    height: profileController
                                            .isBenefitExpanded.value
                                        ? 120
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                'Status',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                final imageUrl =
                                                    profileController
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
                                                final imageUrl =
                                                    profileController
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
