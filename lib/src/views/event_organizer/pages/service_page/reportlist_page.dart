// TODO: styling halaman report list
//TODO: filter by resolved, unresolved, title
import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/committee/pages/service_page/reportlist_detail_page.dart';
import 'package:app_kopabali/src/views/event_organizer/pages/service_page/report_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportListEventOrganizerPage extends StatelessWidget {
  const ReportListEventOrganizerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ReportEventOrganizerController reportController =
        Get.put(ReportEventOrganizerController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Report List',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Sort By",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    )),
                SizedBox(width: 8.0),
                DropdownButton<String>(
                  value: reportController.selectedFilter.value.isEmpty
                      ? null
                      : reportController.selectedFilter.value,
                  hint: Text("Filter"),
                  items: [
                    DropdownMenuItem(
                      value: '',
                      child: Text('All'),
                    ),
                    DropdownMenuItem(
                      value: 'Resolved',
                      child: Text('Resolved'),
                    ),
                    DropdownMenuItem(
                      value: 'Unresolved',
                      child: Text('Unresolved'),
                    ),
                  ],
                  onChanged: (value) {
                    reportController.applyFilter(value ?? '');
                  },
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.swap_vert),
                  onPressed: () {
                    reportController.toggleSortOrder();
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: StreamBuilder<List<QueryDocumentSnapshot>>(
              stream: reportController.getFilteredReports(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No reports found.'));
                }
                final reports = snapshot.data!;
                return ListView.builder(
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    final reportData = report.data() as Map<String, dynamic>;
                    reportController.fetchStatusImage(
                        report.id, reportData['status']);
                    return GestureDetector(
                      onTap: () {
                        Get.to(() =>
                            ReportDetailCommitteePage(reportId: report.id));
                      },
                      child: Column(
                        children: [
                          SizedBox(height: 8.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 21.0),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 13, right: 13, top: 23.0, bottom: 10),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.receipt_long_rounded,
                                              color: HexColor("01613B"),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              reportData['title'] ?? 'No Title',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0,
                                              ),
                                            ),
                                            Spacer(),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 8),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 34),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'From : ',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Text(
                                                      reportData['name'] ??
                                                          'No Name',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
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
                                                  Text(
                                                      reportData['category'] ??
                                                          'No category',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Status: ',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Text(
                                                    reportData['status'] ??
                                                        'No Status',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(width: 4),
                                                  Obx(() {
                                                    final imageUrl =
                                                        reportController
                                                                    .statusImageUrls[
                                                                report.id] ??
                                                            '';

                                                    if (imageUrl.isEmpty) {
                                                      return Icon(Icons
                                                          .error); // Menampilkan ikon error jika gambar gagal diambil
                                                    }
                                                    return Image.network(
                                                      imageUrl,
                                                      width: 40,
                                                      height: 40,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
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
                                      ],
                                    ),
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
          ),
        ],
      ),
    );
  }
}
