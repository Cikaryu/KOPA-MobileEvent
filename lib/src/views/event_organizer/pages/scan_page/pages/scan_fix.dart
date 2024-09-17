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
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => EventOrganizerView()),
            );
          },
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
                SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 82,
                    height: 82,
                    decoration: ShapeDecoration(
                      image: scanController.imageBytes.value != null
                          ? DecorationImage(
                              image:
                                  MemoryImage(scanController.imageBytes.value!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      shape: OvalBorder(),
                    ),
                    child: scanController.imageBytes.value == null
                        ? Icon(Icons.person, size: 82, color: Colors.grey[500])
                        : null,
                  ),
                ),
                SizedBox(height: 16),
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
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Center(
                  child: Text(
                    scanController.participantData['role'] ?? '',
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
                  ],
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Participant Kit',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 16),
                buildDropdownContainer('Merch', 'merch', [
                  buildStatusRow(
                      scanController,
                      'Polo Shirt (${scanController.poloShirtSize})',
                      'merchandise.poloShirt'),
                  buildStatusRow(
                      scanController,
                      'T-Shirt (${scanController.tShirtSize})',
                      'merchandise.tShirt'),
                  buildStatusRow(
                      scanController, 'Luggage Tag', 'merchandise.luggageTag'),
                  buildStatusRow(
                      scanController, 'Jas Hujan', 'merchandise.jasHujan'),
                ]),
                SizedBox(height: 16),
                buildDropdownContainer('Souvenir', 'souvenir', [
                  buildStatusRow(scanController, 'Gelang Tridatu',
                      'souvenir.gelangTridatu'),
                  buildStatusRow(scanController, 'Selendang Udeng',
                      'souvenir.selendangUdeng'),
                ]),
                SizedBox(height: 16),
                buildDropdownContainer('Benefit', 'benefit', [
                  buildStatusRow(scanController, 'Voucher Belanja',
                      'benefit.voucherBelanja'),
                  buildStatusRow(scanController, 'Voucher E-Wallet',
                      'benefit.voucherEwallet'),
                ]),
                SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildDropdownContainer(
      String title, String containerName, List<Widget> children) {
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
                scanController.toggleContainerExpansion(containerName);
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
                            scanController.isContainerExpanded(containerName)
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
                        width: 420,
                        duration: Duration(milliseconds: 300),
                        height:
                            scanController.isContainerExpanded(containerName)
                                ? (children.length * 40.0 + 60)
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
                                  SizedBox(width: 8),
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

  Widget buildProfileContainer(
      String title, String containerName, List<Widget> children) {
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
                scanController.toggleContainerExpansion(containerName);
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
                            scanController.isContainerExpanded(containerName)
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
                        width: 420,
                        duration: Duration(milliseconds: 300),
                        height:
                            scanController.isContainerExpanded(containerName)
                                ? (children.length * 40.0 + 45)
                                : 0,
                        curve: Curves.easeInOut,
                        child: SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: children,
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

  Widget buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget buildStatusRow(
      ScanController controller, String itemName, String field) {
    return Obx(() {
      String status =
          controller.getStatusForItem(field.split('.')[0], field.split('.')[1]);

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
                width: 126,
                child: Row(
                  children: [
                    // Display status text with the status color
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    SvgPicture.asset(
                      controller.getStatusImagePath(status),
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
