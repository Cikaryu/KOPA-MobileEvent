import 'package:app_kopabali/src/views/event_organizer/event_organizer_view.dart';
import 'package:app_kopabali/src/views/event_organizer/pages/scan_page/scan_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ScanProfileView extends StatelessWidget {
  ScanProfileView({super.key});

  final ScanController scanController = Get.put(ScanController());

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scanController.participantData.isEmpty) {
        String? userId = Get.arguments?['userId'];
        if (userId != null) {
          scanController.fetchParticipantData(userId);
        } else {
          Get.snackbar("Error", "User ID not provided.",
              backgroundColor: Colors.red, colorText: Colors.white);
          Get.back();
        }
      }
    });
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: HexColor('727578'),
        title:
            Text('Participant Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => EventOrganizerView())),
        ),
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (scanController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (scanController.participantData.isEmpty) {
          return Center(child: Text('Participant not found.'));
        }
        return Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: CircleAvatar(
                    backgroundImage: scanController.imageBytes.value != null
                        ? MemoryImage(scanController.imageBytes.value!)
                        : null,
                    radius: screenWidth * 0.11,
                    child: scanController.imageBytes.value == null
                        ? Icon(Icons.person, size: 41, color: Colors.grey[500])
                        : null,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: Text(
                    scanController.participantData['name'] ?? '',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Center(
                  child: Text(
                    scanController.participantData['email'] ?? '',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Center(
                  child: Text(
                    scanController.participantData['role'] ?? '',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Profile Data',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: screenHeight * 0.02),
                buildProfileContainer(
                  'View Profile',
                  'profileData',
                  [
                    buildProfileRow(
                      'Department',
                      scanController.participantData['department'] ?? '',
                    ),
                    buildProfileRow(
                      'Area',
                      scanController.participantData['area'] ?? '',
                    ),
                    buildProfileRow(
                      'Division',
                      scanController.participantData['division'] ?? '',
                    ),
                    buildProfileRow(
                      'Address',
                      scanController.participantData['address'] ?? '',
                    ),
                    buildProfileRow(
                      'Whatsapp',
                      scanController.participantData['whatsappNumber'] ?? '',
                    ),
                    buildProfileRow(
                      'NIK',
                      scanController.participantData['NIK'] ?? '',
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
                    scanController,
                    'Merchandise',
                    'merchandise',
                    [
                      buildStatusRow(
                          scanController,
                          'Polo Shirt (${scanController.poloShirtSize})',
                          'merchandise.poloShirt',
                          screenWidth),
                      buildStatusRow(
                          scanController,
                          'T-Shirt (${scanController.tShirtSize})',
                          'merchandise.tShirt',
                          screenWidth),
                      buildStatusRow(scanController, 'Luggage Tag',
                          'merchandise.luggageTag', screenWidth),
                      buildStatusRow(scanController, 'Jas Hujan',
                          'merchandise.jasHujan', screenWidth),
                    ],
                    screenWidth),
                SizedBox(height: screenHeight * 0.02),
                buildDropdownContainer(
                    scanController,
                    'Souvenir Program',
                    'souvenir',
                    [
                      buildStatusRow(scanController, 'Gelang Tridatu',
                          'souvenir.gelangTridatu', screenWidth),
                      buildStatusRow(scanController, 'Selendang Udeng',
                          'souvenir.selendangUdeng', screenWidth),
                    ],
                    screenWidth),
                SizedBox(height: screenHeight * 0.02),
                buildDropdownContainer(
                    scanController,
                    'Benefit',
                    'benefit',
                    [
                      buildStatusRow(scanController, 'Voucher Belanja',
                          'benefit.voucherBelanja', screenWidth),
                      buildStatusRow(scanController, 'Voucher E-Wallet',
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

  Widget buildProfileContainer(String title, String containerName,
      List<Widget> children, double screenWidth) {
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
                scanController.toggleContainerExpansion(containerName);
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
                            scanController.isContainerExpanded(containerName)
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
                        child: scanController.isContainerExpanded(containerName)
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

Widget buildDropdownContainer(ScanController controller, String title,
    String containerName, List<Widget> children, double screenWidth) {
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

Widget buildStatusRow(ScanController controller, String itemName, String field,
    double screenWidth) {
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
