import 'package:app_kopabali/src/views/event_organizer/pages/event_organizer_profile/pages/search_participant/search_participant_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

//Todo : ukuran baju
class ParticipantDetailPage extends StatelessWidget {
  final Participant participant;

  const ParticipantDetailPage({super.key, required this.participant});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final SearchParticipantController controller =
        Get.find<SearchParticipantController>();
    controller.fetchParticipantKitStatus(participant.uid);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: HexColor('727578'),
        title:
            Text('Participant Detail', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (participant.selfieUrl != null &&
                          participant.selfieUrl!.isNotEmpty) {
                        controller.showMemoryImagePreview(
                            context, participant.selfieUrl!);
                      }
                    },
                    child: CircleAvatar(
                      backgroundImage: participant.selfieUrl != null &&
                              participant.selfieUrl!.isNotEmpty
                          ? NetworkImage(participant.selfieUrl!)
                          : null,
                      radius: 41,
                      child: participant.selfieUrl == null ||
                              participant.selfieUrl!.isEmpty
                          ? Icon(Icons.person,
                              size: 41, color: Colors.grey[500])
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    participant.name ?? 'Unknown',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Center(
                  child: Text(
                    participant.email ?? 'Unknown',
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Center(
                  child: Text(
                    participant.role ?? 'Unknown',
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Profile Data',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 16),
                buildProfileContainer(
                  controller,
                  'View Profile',
                  'profileData',
                  [
                    buildProfileRow(
                      'Department',
                      participant.department ?? 'unknown',
                    ),
                    buildProfileRow(
                      'Area',
                      participant.area ?? 'unknown',
                    ),
                    buildProfileRow(
                      'Division',
                      participant.division ?? 'unknown',
                    ),
                    buildProfileRow(
                      'Address',
                      participant.address ?? 'unknown',
                    ),
                    buildProfileRow(
                      'Whatsapp',
                      participant.whatsappNumber ?? 'unknown',
                    ),
                    buildProfileRow(
                      'NIK',
                      participant.nik ?? 'unknown',
                    ),
                  ],
                  screenWidth,
                ),
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Participant Kit',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: screenHeight * 0.02),
                buildDropdownContainer(
                    controller,
                    'Merchandise',
                    'merchandise',
                    [
                      buildStatusRow(
                          controller,
                          'Polo Shirt (${controller.poloShirtSize})',
                          'merchandise.poloShirt',
                          screenWidth),
                      buildStatusRow(
                          controller,
                          'T-Shirt (${controller.tShirtSize})',
                          'merchandise.tShirt',
                          screenWidth),
                      buildStatusRow(controller, 'Luggage Tag',
                          'merchandise.luggageTag', screenWidth),
                      buildStatusRow(controller, 'Jas Hujan',
                          'merchandise.jasHujan', screenWidth),
                    ],
                    screenWidth),
                SizedBox(height: screenHeight * 0.02),
                buildDropdownContainer(
                    controller,
                    'Souvenir Program',
                    'souvenir',
                    [
                      buildStatusRow(controller, 'Gelang Tridatu',
                          'souvenir.gelangTridatu', screenWidth),
                      buildStatusRow(controller, 'Selendang Udeng',
                          'souvenir.selendangUdeng', screenWidth),
                    ],
                    screenWidth),
                SizedBox(height: screenHeight * 0.02),
                buildDropdownContainer(
                    controller,
                    'Benefit',
                    'benefit',
                    [
                      buildStatusRow(controller, 'Voucher Belanja',
                          'benefit.voucherBelanja', screenWidth),
                      buildStatusRow(controller, 'Voucher E-Wallet',
                          'benefit.voucherEwallet', screenWidth),
                    ],
                    screenWidth),
                SizedBox(height: screenHeight * 0.03),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildProfileContainer(
      SearchParticipantController controller,
      String title,
      String containerName,
      List<Widget> children,
      double screenWidth) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06, vertical: screenWidth * 0.01),
        decoration: ShapeDecoration(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                padding: EdgeInsets.all(screenWidth * 0.02),
                width: screenWidth * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold),
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
                    SizedBox(height: screenWidth * 0.02),
                    Obx(() {
                      return AnimatedSize(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        child: controller.isContainerExpanded(containerName)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: children,
                              )
                            : SizedBox.shrink(),
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

  Widget buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            overflow: TextOverflow.ellipsis,
            value,
            style: TextStyle(fontSize: 14),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

Widget buildDropdownContainer(
    SearchParticipantController controller,
    String title,
    String containerName,
    List<Widget> children,
    double screenWidth) {
  return Center(
    child: Container(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06, vertical: screenWidth * 0.01),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: HexColor('F3F3F3'),
        shadows: [
          BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 0),
              spreadRadius: 0)
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => controller.toggleContainerExpansion(containerName),
            child: Container(
              padding: EdgeInsets.all(
                  screenWidth * 0.02), // Adjust padding dynamically
              width: screenWidth * 0.8, // Adjust width based on screen size
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title,
                          style: TextStyle(
                              fontSize: screenWidth * 0.05, // Adjust font size
                              fontWeight: FontWeight.bold)),
                      Obx(() => Icon(
                            controller.isContainerExpanded(containerName)
                                ? Icons.keyboard_arrow_down_rounded
                                : Icons.keyboard_arrow_up_rounded,
                            color: Colors.grey,
                          )),
                    ],
                  ),
                  SizedBox(
                      height:
                          screenWidth * 0.01), // Responsive vertical spacing
                  Obx(() => AnimatedContainer(
                        padding:
                            EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                        width: screenWidth * 0.8, // Adjust width dynamically
                        duration: Duration(milliseconds: 300),
                        height: controller.isContainerExpanded(containerName)
                            ? (children.length * 60 + 20)
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
                                  Text('Items',
                                      style: TextStyle(
                                          fontSize: screenWidth *
                                              0.04, // Responsive text size
                                          fontWeight: FontWeight.bold)),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: screenWidth *
                                            0.1), // Adjust padding dynamically
                                    child: Text('Status',
                                        style: TextStyle(
                                            fontSize: screenWidth * 0.04,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenWidth * 0.01),
                              ...children,
                              SizedBox(height: screenWidth * 0.02),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildStatusRow(SearchParticipantController controller, String itemName,
    String field, double screenWidth) {
  return Obx(() {
    String status =
        controller.getStatusForItem(field.split('.')[0], field.split('.')[1]);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                itemName,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: controller.getStatusColor(status),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  width: screenWidth * 0.35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SvgPicture.asset(
                        controller.getStatusImagePath(status),
                        width: screenWidth * 0.06,
                        height: screenWidth * 0.06,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: screenWidth * 0.02),
      ],
    );
  });
}
