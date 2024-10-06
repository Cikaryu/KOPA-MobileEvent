import 'package:app_kopabali/src/views/committee/pages/profile_page_committe/pages/search_participant/search_participant_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

//Todo revisi Check if All Received
class ParticipantDetailPage extends StatelessWidget {
  final Participant participant;

  const ParticipantDetailPage({super.key, required this.participant});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final SearchParticipantController controller =
        Get.put(SearchParticipantController());
    controller.setSelectedParticipant(participant);

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
                SizedBox(height: screenHeight * 0.02),
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
                      radius: screenWidth * 0.11,
                      child: participant.selfieUrl == null ||
                              participant.selfieUrl!.isEmpty
                          ? Icon(Icons.person, size: 41, color: Colors.grey[500])
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
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
                    style: TextStyle(fontSize: screenWidth * 0.04),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Center(
                  child: Text(
                    participant.role ?? 'Unknown',
                    style: TextStyle(fontSize: screenWidth * 0.04),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: screenWidth * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Profile Data',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: screenHeight * 0.02),
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
                    screenWidth),
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Participant Kit',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: screenHeight * 0.02),
                buildDropdownContainer(
                  context,
                  controller,
                  'Merchandise',
                  'merchandise',
                  screenWidth,
                  [
                    buildStatusRow(
                        controller,
                        'Polo Shirt (${participant.poloShirtSize})',
                        'merchandise.poloShirt',
                        screenWidth),
                    buildStatusRow(
                        controller,
                        'T-Shirt (${participant.tShirtSize})',
                        'merchandise.tShirt',
                        screenWidth),
                    buildStatusRow(controller, 'Luggage Tag',
                        'merchandise.luggageTag', screenWidth),
                    buildStatusRow(controller, 'Jas Hujan',
                        'merchandise.jasHujan', screenWidth),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                buildDropdownContainer(
                  context,
                  controller,
                  'Souvenir Program',
                  'souvenir',
                  screenWidth,
                  [
                    buildStatusRow(controller, 'Gelang Tridatu',
                        'souvenir.gelangTridatu', screenWidth),
                    buildStatusRow(controller, 'Selendang Udeng',
                        'souvenir.selendangUdeng', screenWidth),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                buildDropdownContainer(
                  context,
                  controller,
                  'Benefit',
                  'benefit',
                  screenWidth,
                  [
                    buildStatusRow(controller, 'Voucher Belanja',
                        'benefit.voucherBelanja', screenWidth),
                    buildStatusRow(controller, 'Voucher E-Wallet',
                        'benefit.voucherEwallet', screenWidth),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.submitParticipantKit(participant.uid);
                      Get.back();
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
                    child: Text(
                      'Submit',
                    ),
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

  Widget buildDropdownContainer(
      BuildContext context,
      SearchParticipantController controller,
      String title,
      String containerName,
      double screenWidth,
      List<Widget> children) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06, vertical: screenWidth * 0.01),
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
                    SizedBox(height: screenWidth * 0.01),
                    Obx(() {
                      return AnimatedContainer(
                        padding:
                            EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                        width: screenWidth * 0.8,
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
                                  Text(
                                    'Items',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: screenWidth * 0.1),
                                    child: Text(
                                      'Status',
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenWidth * 0.01),
                              ...children,
                              SizedBox(height: screenWidth * 0.02),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showConfirmationDialog(
                                        context, controller, containerName);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.06,
                                        vertical: screenWidth * 0.015),
                                  ),
                                  child: Text('Click If All Received'),
                                ),
                              ),
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

  void _showConfirmationDialog(BuildContext context,
      SearchParticipantController controller, String containerName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Confirm Action',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to mark all items as received?',
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        color: Colors.red,
                        border: Border(
                          top: BorderSide(color: Colors.redAccent),
                        ),
                      ),
                      child: Text('No',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16))),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
                TextButton(
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        color: Colors.green,
                        border: Border(
                          top: BorderSide(color: Colors.greenAccent),
                        ),
                      ),
                      child: Text('Yes',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16))),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    controller.checkAllItems(participant.uid, containerName);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

   Widget buildStatusRow(
    SearchParticipantController controller,
    String itemName,
    String field,
    double screenWidth,
  ) {
    return Obx(() {
      String status =
          controller.getStatusForItem(field.split('.')[0], field.split('.')[1]);
      List<String> statusOptions = ['Pending', 'Received', 'Not Received'];
      if (!statusOptions.contains(status)) {
        status = statusOptions[0];
      }

      bool isLoading = controller.isLoadingMap[field] ??
          false; // Check if this field is loading

      return Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  itemName,
                  style: TextStyle(
                      fontSize: screenWidth * 0.04, color: Colors.black),
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Flexible(
                      child: isLoading
                          ? Container(
                              padding: EdgeInsets.all(10),
                              width: screenWidth * 1,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
                                  color: Colors.transparent),
                              child: Row(
                                children: [
                                  Text(
                                    'Loading',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.12,
                                  ),
                                  SizedBox(
                                    height: screenWidth * 0.04,
                                    width: screenWidth * 0.04,
                                    child: CircularProgressIndicator(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ) // Show loading spinner in place of dropdown
                          : DropdownButtonFormField2<String>(
                              value: status,
                              items: statusOptions.map((String statusOption) {
                                return DropdownMenuItem<String>(
                                  value: statusOption,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(statusOption,
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.03,
                                              color: Colors.black)),
                                      SizedBox(
                                          width: statusOption == 'Not Received'
                                              ? screenWidth * 0.03
                                              : statusOption == 'Pending'
                                                  ? screenWidth * 0.09
                                                  : screenWidth * 0.09),
                                      SvgPicture.asset(
                                        controller
                                            .getStatusImagePath(statusOption),
                                        width: screenWidth *
                                            0.06, // Responsive icon size
                                        height: screenWidth * 0.06,
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) async {
                                if (newValue != null) {
                                  controller.isLoadingMap[field] =
                                      true; // Set loading for this field
                                  await controller.updateItemStatus(
                                      participant.uid, field, newValue);
                                  controller.isLoadingMap[field] =
                                      false; // Remove loading after update
                                }
                              },
                              iconStyleData:
                                  IconStyleData(icon: SizedBox.shrink()),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: screenWidth * 0.02),
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
          SizedBox(height: screenWidth * 0.02),
        ],
      );
    });
  }
}
