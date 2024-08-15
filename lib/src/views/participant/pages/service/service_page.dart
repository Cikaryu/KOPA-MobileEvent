import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/participant/pages/service/page/faq/faq_page.dart';
import 'package:app_kopabali/src/views/participant/pages/service/page/feedback/feedback_page.dart';
import 'package:app_kopabali/src/views/participant/pages/service/page/report/report_page.dart';
import 'package:app_kopabali/src/views/participant/pages/service/page/report/reportlist_page.dart';
import 'package:app_kopabali/src/views/participant/pages/service/service_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ServiceController serviceController = Get.put(ServiceController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text('Service'),
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Get.to(() => FaqPage());
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: HexColor("F3F3F3"),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: Colors.orange,
                    ),
                    SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FAQ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          'Frequently Asked Questions',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: HexColor("#F3F3F3"),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Report',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your Report',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 16),
                  StreamBuilder<QuerySnapshot>(
                    stream: serviceController.getReportsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        // Jika tidak ada laporan, kembalikan widget kosong
                        return SizedBox(); // Mengembalikan SizedBox untuk menghindari pengembangan
                      }

                      final reports = snapshot.data!.docs
                          .take(4)
                          .toList(); // Ambil hanya 4 laporan

                      return Column(
                        children: reports.map((report) {
                          final reportData =
                              report.data() as Map<String, dynamic>;
                          final reportId = report.id; // Dapatkan ID laporan

                          // Panggil fetchStatusImage untuk memastikan gambar diambil
                          serviceController.fetchStatusImage(
                              reportId, reportData['status']);

                          return Obx(() {
                            final statusImageUrl =
                                serviceController.statusImageUrls[reportId] ??
                                    '';

                            return InkWell(
                              onTap: () {
                                Get.to(() => ReportListPage());
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: HexColor("#F3F3F3"),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 0.5,
                                  ),
                                ),
                                padding: const EdgeInsets.all(16.0),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        reportData['title'] ?? 'No Title',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    // Tampilkan gambar
                                    Image.network(
                                      statusImageUrl,
                                      width: 24,
                                      height: 24,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons
                                            .error); // Tampilkan ikon kesalahan atau placeholder
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                        }).toList(),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Container(
                      width: 140,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => ReportPage());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HexColor("#72BB65"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Add Report',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: HexColor("#F3F3F3"),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Feedback',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Write your critique and advice',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 22),
                  Center(
                    child: Container(
                      width: 140,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => FeedbackPage());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HexColor("#72BB65"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Write',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 44),
          ]),
        ),
      ),
    );
  }
}
