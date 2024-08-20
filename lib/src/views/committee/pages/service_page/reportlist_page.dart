// TODO: styling halaman report list
import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/committee/pages/service_page/report_controller.dart';
import 'package:app_kopabali/src/views/committee/pages/service_page/reportlist_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportListCommitteePage extends StatelessWidget {
  const ReportListCommitteePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ReportCommitteeController reportController =
        Get.put(ReportCommitteeController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Report List', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('report')
            .snapshots(), // Ambil semua laporan
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No reports found.'));
          }

          final reports = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              final reportData = report.data() as Map<String, dynamic>;

              // Memanggil fetchStatusImage untuk memastikan gambar diambil
              reportController.fetchStatusImage(
                  report.id, reportData['status']);

              return GestureDetector(
                onTap: () {
                  Get.to(() => ReportDetailCommitteePage(reportId: report.id));
                },
                child: Column(
                  children: [
                    SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        margin: EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                          color: HexColor("F3F3F3"),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reportData['title'] ?? 'No Title',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'From : ',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(reportData['name'] ?? 'No Name'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Category : ',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(reportData['category'] ??
                                          'No category'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Status: ',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(reportData['status'] ?? 'No Status'),
                                      SizedBox(width: 4),
                                      Obx(() {
                                        final imageUrl = reportController
                                                .statusImageUrls[report.id] ??
                                            '';

                                        if (imageUrl.isEmpty) {
                                          return Icon(Icons
                                              .error); // Menampilkan ikon error jika gambar gagal diambil
                                        }
                                        return Image.network(
                                          imageUrl,
                                          width: 40,
                                          height: 40,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            debugPrint(
                                                'Error loading image: $error');
                                            return Icon(Icons
                                                .error); // Menampilkan ikon error jika gambar gagal dimuat
                                          },
                                        );
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
