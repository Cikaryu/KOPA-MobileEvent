import 'dart:io';

import 'package:app_kopabali/src/views/participant/pages/service/page/report/report_controller.dart';
import 'package:app_kopabali/src/core/base_import.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class ReportPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ReportController reportController = Get.put(ReportController());
    final List<String> categoryOptions = [
      'Participant Merchandise',
      'Participant Souvenir',
      'Participant Benefit',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: HexColor('01613B'),
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
                SizedBox(height: 16),
                Row(
                  children: [
                    Text('Category',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField2<String>(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          filled: true,
                          hintText: 'Select Category Report',
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
                            width: 280,
                            elevation: 5,
                            padding: EdgeInsets.all(10),
                            maxHeight: 240),
                        items: categoryOptions.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          categoryController.text = newValue!;
                        },
                        validator: (value) =>
                            value == null ? 'Please select a category' : null,
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
                Text('Attachment',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    await reportController.pickImage();
                  },
                  child: Container(
                    height: 50,
                    width: Get.width,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Attach your photo',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w300)),
                        Spacer(),
                        Icon(Icons.add),
                      ],
                    ),
                  ),
                ),
                Obx(() {
                  if (reportController.selectedImage.value != null) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Image.file(
                        File(reportController.selectedImage.value!.path),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }),
                SizedBox(height: 28),
                Center(
                  child: Container(
                    width: Get.width * 0.5,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          reportController.submitReport(
                            title: titleController.text,
                            category: categoryController.text,
                            description: descriptionController.text,
                            status: 'Pending',
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor("#72BB65"),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                      child: Text('Submit',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
