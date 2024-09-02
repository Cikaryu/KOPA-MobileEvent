import 'package:app_kopabali/src/views/super_eo/pages/super_eo_profile_page/pages/search_participant/search_participant_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:dropdown_button2/dropdown_button2.dart';


class ParticipantDetailPage extends StatelessWidget {
  final Participant participant;

  const ParticipantDetailPage({super.key, required this.participant});

  @override
  Widget build(BuildContext context) {
    final SearchParticipantController controller =
        Get.find<SearchParticipantController>();
    controller.setSelectedParticipant(participant);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: HexColor('01613B'),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                CircleAvatar(
                  backgroundImage: participant.selfieUrl != null &&
                          participant.selfieUrl!.isNotEmpty
                      ? NetworkImage(participant.selfieUrl!)
                      : null,
                  radius: 41,
                  child: participant.selfieUrl == null ||
                          participant.selfieUrl!.isEmpty
                      ? Icon(Icons.person, size: 41, color: Colors.grey[500])
                      : null,
                ),
                SizedBox(height: 16),
                Text(
                  participant.name ?? 'Unknown',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                buildRoleDropdown(controller),
                SizedBox(height: 16),
                buildDropdownContainer(
                    controller, 'Merchandise', 'merchandise', [
                  buildStatusRow(
                      controller, 'Polo Shirt', 'merchandise.poloShirt'),
                  buildStatusRow(controller, 'T-Shirt', 'merchandise.tShirt'),
                  buildStatusRow(
                      controller, 'Luggage Tag', 'merchandise.luggageTag'),
                  buildStatusRow(
                      controller, 'Jas Hujan', 'merchandise.jasHujan'),
                ]),
                SizedBox(height: 16),
                buildDropdownContainer(controller, 'Souvenir', 'souvenir', [
                  buildStatusRow(
                      controller, 'Gelang Tridatu', 'souvenir.gelangTridatu'),
                  buildStatusRow(
                      controller, 'Selendang Udeng', 'souvenir.selendangUdeng'),
                ]),
                SizedBox(height: 16),
                buildDropdownContainer(controller, 'Benefit', 'benefit', [
                  buildStatusRow(
                      controller, 'Voucher Belanja', 'benefit.voucherBelanja'),
                  buildStatusRow(
                      controller, 'Voucher E-Wallet', 'benefit.voucherEwallet'),
                ]),
                SizedBox(height: 24),
                ElevatedButton(
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
                SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildRoleDropdown(SearchParticipantController controller) {
    List<String> roles = [
      'Participant',
      'Committee',
      'Event Organizer',
      'Super Event Organizer'
    ];
    // Add more roles as needed

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 61),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Promote', style: TextStyle(fontSize: 16)),
          SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField2<String>(
              alignment: Alignment.centerLeft,
              buttonStyleData: ButtonStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.only(right: 8),
              ),
              iconStyleData: IconStyleData(
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
              ),
              isDense: true,
              isExpanded: true,
              value: participant.role,
              items: roles.map((String role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(
                    role,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.updateParticipantRole(participant.uid, newValue);
                }
              },
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                elevation: 5,
                offset: Offset(0, -4),
                maxHeight: 160,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdownContainer(SearchParticipantController controller,
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
              controller.toggleContainerExpansion(containerName);
            },
            child: Container(
              padding: EdgeInsets.all(8),
              width: 330,
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
                      padding: EdgeInsets.symmetric(vertical: 8),
                      width: 330,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Name',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 40),
                                  child: Text(
                                    'Status',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            ...children,
                            SizedBox(height: 16),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.checkAllItems(
                                      participant.uid, containerName);
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: HexColor('E97717'),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 6),
                                ),
                                child: Text('Check All (Received)'),
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
    );
  }

  Widget buildStatusRow(
      SearchParticipantController controller, String itemName, String field) {
    return Obx(() {
      String status =
          controller.getStatusForItem(field.split('.')[0], field.split('.')[1]);
      List<String> statusOptions = ['Pending', 'Received', 'Not Received'];

      // Ensure that status is one of the valid options
      if (!statusOptions.contains(status)) {
        status = statusOptions[0]; // Default to 'Pending' if status is invalid
      }

      return Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  itemName,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    SizedBox(
                      width: 157,
                      child: DropdownButtonFormField2<String>(
                        value: status,
                        items: statusOptions.map((String statusOption) {
                          return DropdownMenuItem<String>(
                            value: statusOption,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(statusOption),
                                SizedBox(
                                    width: statusOption == 'Not Received'
                                        ? 4
                                        : statusOption == 'Pending'
                                            ? 40
                                            : 33),
                                FutureBuilder<String>(
                                  future: controller
                                      .getStatusImageUrl(statusOption),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.hasData) {
                                      return Image.network(
                                        snapshot.data!,
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.contain,
                                      );
                                    } else if (snapshot.hasError) {
                                      return Icon(Icons.error,
                                          color: Colors.red, size: 24);
                                    } else {
                                      return SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            controller.updateItemStatus(
                                participant.uid, field, newValue);
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
