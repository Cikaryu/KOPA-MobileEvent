import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/committee/pages/profile_page_committe/pages/reply_report/report_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportDetailCommitteePage extends StatelessWidget {
  final String reportId;

  const ReportDetailCommitteePage({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    final ReportCommitteeController reportController =
        Get.put(ReportCommitteeController());

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

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              scrolledUnderElevation: 0,
              title: Text('${reportData['title']}'), // Dynamic title
            ),
            body: SingleChildScrollView(
              // Wrap with SingleChildScrollView
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text('From ',
                          style: TextStyle(fontSize: 18, color: Colors.black)),
                      Text(reportData['name'], style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  SizedBox(height: 8),
                  if (reportData['image'] != '-') // Show image if it exists
                    Image.network(
                      reportData['image'],
                      fit: BoxFit.cover, // Adjust fit as needed
                      width: double.infinity, // Make image take full width
                      height: 200, // Set height as needed
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  TextFormField(
                    maxLines: 8,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'No reply yet',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
