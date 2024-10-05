import 'dart:io';

import 'package:app_kopabali/src/views/participant/pages/service/page/report/report_controller.dart';
import 'package:app_kopabali/src/core/base_import.dart';

class ReportPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  // final TextEditingController categoryController = TextEditingController();
  ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ReportController reportController = Get.put(ReportController());
    return Stack(children: [
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: HexColor('727578'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text('Report', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: Get.width,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min, // Added this line
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Text('Title',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: TextFormField(
                            controller: titleController,
                            decoration: InputDecoration(
                              hintText: 'Write your report title',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 28),
                  Text('Description',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText: 'Write your report description',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 28),
                  Text(
                    'Attachments',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Attach your photos (Optional, Max 5 Photos)',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 16),
                        Obx(() {
                          int itemCount =
                              reportController.selectedImages.length < 5
                                  ? reportController.selectedImages.length + 1
                                  : 5;

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: itemCount,
                            itemBuilder: (context, index) {
                              if (index ==
                                      reportController.selectedImages.length &&
                                  reportController.selectedImages.length < 5) {
                                return GestureDetector(
                                  onTap: () async {
                                    if (reportController.selectedImages.length <
                                        5) {
                                      await reportController.pickImages();
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(Icons.add,
                                        size: 40, color: Colors.grey[500]),
                                  ),
                                );
                              }
                              return Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: FileImage(File(reportController
                                            .selectedImages[index].path)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: GestureDetector(
                                      onTap: () {
                                        reportController.selectedImages
                                            .removeAt(index);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.close,
                                            size: 20, color: Colors.red),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }),
                        SizedBox(height: 16),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              await reportController.pickImages();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor('E97717'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.camera_alt, color: Colors.white),
                                SizedBox(width: 5),
                                Text(
                                  "Add Photos",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 28),
                  Center(
                    child: SizedBox(
                      width: Get.width * 0.5,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            reportController.submitReport(
                              title: titleController.text,
                              description: descriptionController.text,
                              status: 'Not Started',
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HexColor("E97717"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Submit',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
      Obx(() {
        return reportController.isLoading.value
            ? Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(HexColor("E97717")),
                  ),
                ),
              )
            : SizedBox.shrink();
      }),
    ]);
  }
}
