// TODO: styling halaman report list
//TODO: filter by resolved, unresolved, title
import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/committee/pages/service_page/report_controller.dart';
import 'package:app_kopabali/src/views/committee/pages/service_page/reportlist_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportListCommitteePage extends StatefulWidget {
  const ReportListCommitteePage({super.key});

  @override
  State<ReportListCommitteePage> createState() =>
      _ReportListCommitteePageState();
}

class _ReportListCommitteePageState extends State<ReportListCommitteePage> {
  bool isAscending = false;
  String selectedFilter = 'Title';
  @override
  Widget build(BuildContext context) {
    final ReportCommitteeController reportController =
        Get.put(ReportCommitteeController());

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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Sort By",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    )),
                SizedBox(width: 4),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isDense: true,
                    value: selectedFilter,
                    onChanged: (value) {
                      setState(() {
                        selectedFilter = value!;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: 'Resolved',
                        child: Text('Resolved'),
                      ),
                      DropdownMenuItem(
                        value: 'Unresolved',
                        child: Text('Unresolved'),
                      ),
                      DropdownMenuItem(
                        value: 'Title',
                        child: Text('Title'),
                      ),
                    ],
                    dropdownColor: HexColor("F3F3F3"),
                    borderRadius: BorderRadius.circular(10),
                    icon: null,
                    iconSize: 0,
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    isAscending ? Icons.swap_vert : Icons.swap_vert_rounded,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      isAscending = !isAscending; // Toggle between ASC and DSC
                      print('isAscending: $isAscending'); // Debugging line
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getReportsStream(), // Ambil semua laporan
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

  Stream<QuerySnapshot> _getReportsStream() {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection('report');

    // Apply filtering and sorting based on the selected filter
    if (selectedFilter == 'Resolved') {
      query = query.where('status', isEqualTo: 'Resolved');
    } else if (selectedFilter == 'Unresolved') {
      query = query.where('status', isEqualTo: 'Unresolved');
    } else if (selectedFilter == 'Title') {
      query = query.orderBy('title', descending: !isAscending);
    }

    // If 'All' is selected, do not apply any filtering
    if (selectedFilter != 'Title') {
      query = query.orderBy('title', descending: !isAscending);
    }

    return query.snapshots();
  }
}
