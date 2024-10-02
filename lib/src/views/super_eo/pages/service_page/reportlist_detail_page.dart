import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/super_eo/pages/service_page/report_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class ReportDetailSuperEOPage extends StatelessWidget {
  final String reportId;

  const ReportDetailSuperEOPage({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    final ReportSuperEOController reportController =
        Get.put(ReportSuperEOController());
    final List<String> statusOptions = [
      'Not Started',
      'In Progress',
      'Pending',
      'Resolved',
    ];

    final RxString status = 'Not Started'.obs; // Default status

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('report').doc(reportId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No report found.'));
          }

          final reportData = snapshot.data!.data() as Map<String, dynamic>;
          final TextEditingController replyController = TextEditingController(
            text: reportData['reply'], // Use the existing reply
          );

          // Set the initial status based on the report data
          status.value = reportData['status'] ?? 'Not Started';

          return Obx(() => Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  centerTitle:reportController.isLoading.value ,
                  automaticallyImplyLeading: !reportController.isLoading.value,
                  backgroundColor: reportController.isLoading.value
                    ? HexColor('727578')
                    : Colors.white,
                  scrolledUnderElevation: 0,
                  title: Text(
                  reportController.isLoading.value
                    ? 'Waiting For updating report ...'
                    : '${reportData['title']}',
                    
                    style:  reportController.isLoading.value? TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ): TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                  ),
                  ),
                ),
                body: reportController.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text('From ',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black)),
                                Text(reportData['name'],
                                    style: TextStyle(fontSize: 18)),
                              ],
                            ),
                            SizedBox(height: 8),
                            if (reportData['image'] != '-')
                              Image.network(
                                reportData['image'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,
                              ),
                            SizedBox(height: 16),
                            Text('Description:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            TextFormField(
                              initialValue: reportData['description'],
                              maxLines: 8,
                              readOnly: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text('Reply:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            TextFormField(
                              controller: replyController,
                              maxLines: 8,
                              decoration: InputDecoration(
                                hintText: 'Write your reply here',
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Status:',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(width: 8),
                                Expanded(
                                  child: DropdownButtonFormField2<String>(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      filled: true,
                                      hintText: 'Select Status Report',
                                      fillColor: Colors.grey[200],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey[300],
                                      ),
                                      offset: Offset(0, 48),
                                      elevation: 5,
                                      maxHeight: 120,
                                      padding: EdgeInsets.all(10),
                                    ),
                                    items: statusOptions.map((String status) {
                                      return DropdownMenuItem<String>(
                                        value: status,
                                        child: Text(
                                          status,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      );
                                    }).toList(),
                                    value: status.value,
                                    onChanged: (value) {
                                      if (value != null) {
                                        status.value = value;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 80),
                            ElevatedButton(
                              onPressed: () async {
                                // Proses Update Laporan
                                await reportController.updateReport(
                                  reportId: reportId,
                                  reply: replyController.text,
                                  status: status.value,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor('E97717'),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Submit Reply',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ));
        },
      ),
    );
  }
}
