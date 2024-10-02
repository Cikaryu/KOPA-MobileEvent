import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/super_eo/pages/service_page/report_controller.dart';
import 'package:app_kopabali/src/views/super_eo/pages/service_page/reportlist_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class ReportListSuperEOPage extends StatelessWidget {
  const ReportListSuperEOPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ReportSuperEOController reportController =
        Get.put(ReportSuperEOController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
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
                          value: 'Not Started',
                          child: Text('Not Started'),
                        ),
                        DropdownMenuItem(
                          value: 'In Progress',
                          child: Text('In Progress'),
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
                        width: 130,
                        maxHeight: 160,
                        offset: Offset(5, 20),
                        elevation: 5,
                      ),
                      iconStyleData: IconStyleData(
                        icon: SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Obx(
                    () => DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
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
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300],
                          ),
                          width: 120,
                          maxHeight: 160,
                          offset: Offset(-5, 0),
                          elevation: 5,
                          padding: EdgeInsets.all(10),
                        ),
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
                   Timestamp createdAtTimestamp =
                      reportData['createdAt'] as Timestamp;
                  DateTime createdAt = createdAtTimestamp
                      .toDate()
                      .add(Duration(hours: 8)); // Manually adjust to UTC+8
                  String formattedDate =
                      DateFormat('EEE, dd-MM-yyyy / HH:mm').format(createdAt);
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                          () => ReportDetailSuperEOPage(reportId: report.id));
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
                                          SizedBox(
                                            width: 240,
                                            child: Text(
                                              reportData['title'] ?? 'No Title',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0,
                                              ),
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
                                            SizedBox(height: 8),
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
                                                SvgPicture.asset(
                                                  reportController
                                                      .getStatusImagePath(
                                                           reportData[
                                                                  'status'] ??
                                                              'Not Started'),
                                                  width: 24,
                                                  height: 24,
                                                  placeholderBuilder:
                                                      (BuildContext context) =>
                                                          Icon(Icons.error),
                                                ),
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
