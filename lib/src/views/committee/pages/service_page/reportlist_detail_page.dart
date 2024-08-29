import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/committee/pages/service_page/report_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class ReportDetailCommitteePage extends StatelessWidget {
  final String reportId;

  const ReportDetailCommitteePage({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    final ReportCommitteeController reportController =
        Get.put(ReportCommitteeController());
    final List<String> categoryOptions = [
      'Resolved',
      'Pending',
      'Unresolved',
    ];

    final RxString status = 'Resolved'.obs; // Default status

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

          return Obx(() => Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  scrolledUnderElevation: 0,
                  backgroundColor: HexColor('01613B'),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                  centerTitle: true,
                  title: Text(
                    '${reportData['title']}',
                    style: TextStyle(color: Colors.white),
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
                            if (reportData['image'] !=
                                '-') // Show image if it exists
                              Image.network(
                                reportData['image'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,
                              ),
                            SizedBox(height: 16),
                            Text('Category', style: TextStyle(fontSize: 18)),
                            SizedBox(height: 8),
                            TextFormField(
                              initialValue: reportData['category'],
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
                            SizedBox(height: 8),
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
                                Text('Mark As',
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
                                      width: 140,
                                      offset: Offset(144, 48),
                                      elevation: 5,
                                      padding: EdgeInsets.all(10),
                                    ),
                                    items:
                                        categoryOptions.map((String category) {
                                      return DropdownMenuItem<String>(
                                        value: category,
                                        child: Text(
                                          category,
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
                            SizedBox(height: 140),
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
                                backgroundColor: HexColor('72BB65'),
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
