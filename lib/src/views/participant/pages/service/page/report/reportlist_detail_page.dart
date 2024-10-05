import 'package:app_kopabali/src/core/base_import.dart';
import 'package:app_kopabali/src/views/participant/pages/service/page/report/report_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportDetailPage extends StatelessWidget {
  final String reportId;

  const ReportDetailPage({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    final ReportController reportController = Get.put(ReportController());

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('report').doc(reportId).get(),
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
              scrolledUnderElevation: 0,
              backgroundColor: HexColor('727578'),
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
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (reportData['image'] != null && (reportData['image'] as List).isNotEmpty)
                    SizedBox(
                      height: 300,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          PageView.builder(
                            itemCount: (reportData['image'] as List).length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => reportController.showImagePreview(
                                    context, reportData['image'][index]),
                                child: Image.network(
                                  reportData['image'][index],
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              );
                            },
                            onPageChanged: (index) {
                              reportController.currentImageIndex.value = index;
                            },
                          ),
                          Obx(() => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                (reportData['image'] as List).length,
                                (index) => Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: reportController.currentImageIndex.value == index
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          )),
                          Obx(() => Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${reportController.currentImageIndex.value + 1}/${(reportData['image'] as List).length}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  SizedBox(height: 16),
                  Text('Description:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  TextFormField(
                    initialValue: reportData['reply'],
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}