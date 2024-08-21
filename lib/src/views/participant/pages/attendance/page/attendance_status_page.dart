import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_kopabali/src/views/participant/pages/attendance/attedance_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class AttendanceStatusPage extends StatefulWidget {
  final int day;
  final String event;

  const AttendanceStatusPage({Key? key, required this.day, required this.event})
      : super(key: key);

  @override
  _AttendanceStatusPageState createState() => _AttendanceStatusPageState();
}

class _AttendanceStatusPageState extends State<AttendanceStatusPage> {
  final AttendanceController controller = Get.find();
  String? selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Attendance Status',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() => Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      buildStatusDropdown(),
                      SizedBox(height: 20),
                      if (selectedStatus == 'Sick' ||
                          selectedStatus == 'Permit') ...[
                        buildDescriptionField(),
                        SizedBox(height: 20),
                      ],
                      if (selectedStatus != 'Not Participating' &&
                          selectedStatus != 'Left Early')
                        buildAttachmentButton(),
                      SizedBox(height: 20),
                      if (controller.imageFile.value != null)
                        buildImagePreview(),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: buildSubmitButton(),
                ),
              ),
            ],
          )),
    );
  }

  Widget buildStatusDropdown() {
    List<String> statusOptions;
    if (widget.day == 1 && widget.event == 'departure') {
      statusOptions = ['Attending', 'Not Participating'];
    } else {
      statusOptions = ['Attending', 'Sick', 'Permit', 'Left Early'];
    }

    return Row(
      children: [
        Text(
          "Status",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 20),
        SizedBox(
          width: 250,
          height: 60,
          child: DropdownButtonFormField2<String>(
            decoration: InputDecoration(
              hintText: 'Status',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            items: statusOptions
                .map((status) => DropdownMenuItem(
                      value: status,
                      child: Center(
                          child: Text(status,
                              style: TextStyle(color: Colors.grey[700]))),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedStatus = value;
              });
            },
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300],
              ),
              width: 140,
              offset: Offset(109, 60),
              elevation: 5,
              padding: EdgeInsets.all(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Write your attendance description',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          maxLines: 5,
          onChanged: (value) => controller.description.value = value,
        ),
      ],
    );
  }

  Widget buildAttachmentButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Attachment",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: Get.width,
          height: 45,
          child: ElevatedButton(
            onPressed: controller.takePhoto,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Take a picture and submit',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                Icon(Icons.add),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildImagePreview() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: FileImage(controller.imageFile.value!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildSubmitButton() {
    return SizedBox(
      width: 177,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          if (selectedStatus == null) {
            Get.snackbar('Error', 'Please select a status');
          } else if ((selectedStatus == 'Sick' || selectedStatus == 'Permit') &&
              controller.description.value.isEmpty) {
            Get.snackbar('Error', 'Please provide a description');
          } else if (selectedStatus != 'Not Participating' &&
              selectedStatus != 'Left Early' &&
              controller.imageFile.value == null) {
            Get.snackbar('Error', 'Please take a photo');
          } else {
            controller.submitAttendance(
                widget.day, widget.event, selectedStatus!);
            Get.back(); // Return to the previous page after submitting
            controller.loadAttendanceData(); // Reload attendance data
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text('Submit Attendance',
            style: TextStyle(color: Colors.white, fontSize: 14)),
      ),
    );
  }
}
