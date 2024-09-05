import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/event_organizer/pages/service_page/report_controller.dart';
import 'package:app_kopabali/src/views/event_organizer/pages/service_page/reportlist_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';

class ReportListEventOrganizerPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final ReportEventOrganizerController reportController =
        Get.put(ReportEventOrganizerController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: HexColor('727578'),
        title: Text('Report List',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                SizedBox(
                  width: 150,
                  child: Obx(
                    () => DropdownButtonFormField2<String>(
                      isDense: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      value: reportController.selectedFilter.value,
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
                        DropdownMenuItem(
                          value: 'Pending',
                          child: Text('Pending'),
                        ),
                      ],
                      onChanged: (value) {
                        reportController.applyFilter(value!);
                      },
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300],
                        ),
                        width: 140,
                        offset: Offset(5, 50),
                        elevation: 5,
                        padding: EdgeInsets.all(10),
                      ),
                      iconStyleData: IconStyleData(
                        icon: SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 80,
                  child: Obx(
                    () => DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isDense: true,
                        value: reportController.selectedSortOption.value,
                        items: [
                          DropdownMenuItem(
                            value: 'Newest',
                            child: Text('Newest'),
                          ),
                          DropdownMenuItem(
                            value: 'Oldest',
                            child: Text('Oldest'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            reportController.selectedSortOption.value = value;
                            reportController.sortReportsByDate();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: Obx(() {
              final reports = reportController.filteredReports;
              if (reports.isEmpty) {
                return Center(child: Text('No reports found.'));
              }
              return ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final report = reports[index];
                  final reportData = report.data() as Map<String, dynamic>;
                  reportController.fetchStatusImage(
                      report.id, reportData['status']);
                  Timestamp createdAtTimestamp = reportData['createdAt'];
                  DateTime createdAt = createdAtTimestamp.toDate();
                  String formattedDate =
                      DateFormat('EEE, dd-MM-yyyy / HH:mm').format(createdAt);

                  return GestureDetector(
                    onTap: () {
                      Get.to(
                          () => ReportDetailEventOrganizerPage(reportId: report.id));
                    },
                    child: Column(
                      children: [
                        SizedBox(height: 8.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 21.0),
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
                                                  'Date/Time\t:\t',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Text(
                                                  formattedDate,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Text(
                                                  'From\t\t\t\t\t\t\t\t\t\t:\t',
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
                                            // SizedBox(height: 8),
                                            // Row(
                                            //   children: [
                                            //     Text(
                                            //       'Category\t\t\t:\t',
                                            //       style: TextStyle(
                                            //         color: Colors.grey,
                                            //       ),
                                            //     ),
                                            //     Text(
                                            //         reportData['category'] ??
                                            //             'No category',
                                            //         style: TextStyle(
                                            //             fontWeight:
                                            //                 FontWeight.bold)),
                                            //   ],
                                            // ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Status\t\t\t\t\t\t\t\t:\t',
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
                                                  final imageUrl = reportController
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
            }),
          ),
        ],
      ),
    );
  }
}
