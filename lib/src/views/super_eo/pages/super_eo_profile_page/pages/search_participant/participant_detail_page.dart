import 'package:app_kopabali/src/views/super_eo/pages/super_eo_profile_page/pages/search_participant/search_participant_controller.dart';
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
                SizedBox(height: 16),
                Center(
                  child: CircleAvatar(
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
                SizedBox(height: 8),
                buildRoleDropdown(controller),
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
                    context, controller, 'Merchandise', 'merchandise', [
                  buildStatusRow(
                      controller,
                      'Polo Shirt (${participant.poloShirtSize})',
                      'merchandise.poloShirt'),
                  buildStatusRow(
                      controller,
                      'T-Shirt (${participant.tShirtSize})',
                      'merchandise.tShirt'),
                  buildStatusRow(
                      controller, 'Luggage Tag', 'merchandise.luggageTag'),
                  buildStatusRow(
                      controller, 'Jas Hujan', 'merchandise.jasHujan'),
                ]),
                SizedBox(height: 16),
                buildDropdownContainer(
                    context, controller, 'Souvenir Program', 'souvenir', [
                  buildStatusRow(
                      controller, 'Gelang Tridatu', 'souvenir.gelangTridatu'),
                  buildStatusRow(
                      controller, 'Selendang Udeng', 'souvenir.selendangUdeng'),
                ]),
                SizedBox(height: 16),
                buildDropdownContainer(
                    context, controller, 'Benefit', 'benefit', [
                  buildStatusRow(
                      controller, 'Voucher Belanja', 'benefit.voucherBelanja'),
                  buildStatusRow(
                      controller, 'Voucher E-Wallet', 'benefit.voucherEwallet'),
                ]),
                SizedBox(height: 24),
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

  Widget buildProfileContainer(SearchParticipantController controller,
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
                controller.toggleContainerExpansion(containerName);
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
                        width: 420,
                        duration: Duration(milliseconds: 300),
                        height: controller.isContainerExpanded(containerName)
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
      List<Widget> children) {
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
                controller.toggleContainerExpansion(containerName);
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
                                  Text(
                                    'Items',
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
                                        horizontal: 24, vertical: 6),
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
