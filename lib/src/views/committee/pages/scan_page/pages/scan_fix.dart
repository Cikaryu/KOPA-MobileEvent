import 'package:app_kopabali/src/views/committee/committee_view.dart';
import 'package:app_kopabali/src/views/committee/pages/scan_page/scan_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

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
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.offAll(CommitteeView());
            }),
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
                  child: CircleAvatar(
                    backgroundImage: scanController.imageBytes.value != null
                        ? MemoryImage(scanController.imageBytes.value!)
                        : null,
                    radius: 41,
                    child: scanController.imageBytes.value == null
                        ? Icon(Icons.person, size: 41, color: Colors.grey[500])
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
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Center(
                  child: Text(
                    scanController.participantData['role'] ?? '',
                    style: TextStyle(
                      fontSize: 16,
                    ),
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
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Participant Kit',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 16),
                buildDropdownContainer(
                    scanController, 'Merchandise', 'merchandise', [
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
                buildDropdownContainer(scanController, 'Souvenir', 'souvenir', [
                  buildStatusRow(scanController, 'Gelang Tridatu',
                      'souvenir.gelangTridatu'),
                  buildStatusRow(scanController, 'Selendang Udeng',
                      'souvenir.selendangUdeng'),
                ]),
                SizedBox(height: 16),
                buildDropdownContainer(scanController, 'Benefit', 'benefit', [
                  buildStatusRow(scanController, 'Voucher Belanja',
                      'benefit.voucherBelanja'),
                  buildStatusRow(scanController, 'Voucher E-Wallet',
                      'benefit.voucherEwallet'),
                ]),
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      scanController.submitParticipantKit();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: HexColor('E97717'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 150, vertical: 16),
                    ),
                    child: Text('Submit'),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
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
                                ? (children.length * 40.0 + 88)
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

  Widget buildDropdownContainer(ScanController controller, String title,
      String containerName, List<Widget> children) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        decoration: ShapeDecoration(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                padding: EdgeInsets.all(8),
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Obx(() => Icon(
                              controller.isContainerExpanded(containerName)
                                  ? Icons.keyboard_arrow_down_rounded
                                  : Icons.keyboard_arrow_up_rounded,
                              color: Colors.grey,
                            )),
                      ],
                    ),
                    SizedBox(height: 8),
                    Obx(() => AnimatedContainer(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          width: 300,
                          duration: Duration(milliseconds: 300),
                          height: controller.isContainerExpanded(containerName)
                              ? (children.length * 60 + 90)
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
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 40),
                                      child: Text('Status',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                ...children,
                                SizedBox(height: 16),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        controller.showConfirmCheckAllItems(
                                      Get.context!, // Provide the current context
                                      containerName,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 6),
                                    ),
                                    child: Text('Click If All Received'),
                                  ),
                                ),
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

  Widget buildStatusRow(
      ScanController controller, String itemName, String field) {
    return Obx(() {
      String status =
          controller.getStatusForItem(field.split('.')[0], field.split('.')[1]);
      List<String> statusOptions = ['Received', 'Pending', 'Not Received'];

      if (!statusOptions.contains(status)) {
        status = statusOptions[0];
      }

      return Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(itemName,
                    style: TextStyle(fontSize: 16, color: Colors.black)),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    SizedBox(
                      width: 142,
                      child: DropdownButtonFormField2<String>(
                        value: status,
                        items: statusOptions.map((String statusOption) {
                          return DropdownMenuItem<String>(
                            value: statusOption,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(statusOption,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black)),
                                SizedBox(
                                    width: statusOption == 'Not Received'
                                        ? 12
                                        : statusOption == 'Pending'
                                            ? 40
                                            : 33),
                                SvgPicture.asset(
                                  controller.getStatusImagePath(statusOption),
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            controller.updateItemStatus(field, newValue);
                          }
                        },
                        iconStyleData: IconStyleData(icon: SizedBox.shrink()),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
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
