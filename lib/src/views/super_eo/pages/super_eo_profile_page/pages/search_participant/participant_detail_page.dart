import 'package:app_kopabali/src/views/super_eo/pages/super_eo_profile_page/pages/search_participant/search_participant_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ParticipantDetailPage extends StatelessWidget {
  final Participant participant;

  const ParticipantDetailPage({super.key, required this.participant});

  @override
  Widget build(BuildContext context) {
    final SearchParticipantController controller =
        Get.find<SearchParticipantController>();
    controller.fetchParticipantKitStatus(participant.uid);

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
                Text(
                  participant.role ?? '',
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16),
                buildDropdownContainer(controller, 'Merch', 'merch', [
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
                SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      width: 300,
                      duration: Duration(milliseconds: 300),
                      height: controller.isContainerExpanded(containerName)
                          ? (children.length * 30 + 40)
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

  Widget buildStatusRow(
      SearchParticipantController controller, String itemName, String field) {
    return Obx(() {
      String status =
          controller.getStatusForItem(field.split('.')[0], field.split('.')[1]);
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            itemName,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          FutureBuilder<String>(
            future: controller.getStatusImageUrl(status),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Image.network(
                  snapshot.data!,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                );
              } else if (snapshot.hasError) {
                return Icon(Icons.error, color: Colors.red, size: 24);
              } else {
                return SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              }
            },
          ),
        ],
      );
    });
  }
}
