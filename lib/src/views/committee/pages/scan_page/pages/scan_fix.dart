import 'package:app_kopabali/src/views/committee/committee_view.dart';
import 'package:app_kopabali/src/views/committee/pages/scan_page/scan_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

// todo revisi bagian participant detail
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
          Get.snackbar("Error", "User ID not provided.");
          Get.back();
        }
      }
    });
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: HexColor('01613B'),
        title:
            Text('Particpant Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CommitteeView()),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                Container(
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
                SizedBox(height: 16),
                Text(
                  scanController.participantData['name'] ?? '',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  scanController.participantData['email'] ?? '',
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
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
    return Container(
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
                      height: scanController.isContainerExpanded(containerName)
                          ? (children.length * 40.0 + 60)
                          : 0,
                      curve: Curves.easeInOut,
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Name',
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
    );
  }
}

Widget buildStatusRow(
    ScanController controller, String itemName, String field) {
  return Obx(() {
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
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: controller.statusImageUrls[field] != null &&
                      controller.statusImageUrls[field]!.isNotEmpty
                  ? Image.network(
                      controller.statusImageUrls[field]!,
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    )
                  : SizedBox(width: 24, height: 24),
            ),
          ],
        ),
        SizedBox(height: 8),
      ],
    );
  });
}
