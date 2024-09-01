import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_kopabali/src/views/participant/pages/attendance/attedance_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:hexcolor/hexcolor.dart';

// TODO : buatkan tombol retake setelah pick foto
// TODO : Snackbar buat jadi pop up

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
        scrolledUnderElevation: 0,
        backgroundColor: HexColor('01613B'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text('Attendance Status', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
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
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: buildSubmitButton(),
              ),
            ),
          ],
        ),
      ),
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
              hintText: 'Select your status',
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
              width: 180,
              offset: Offset(70, 60),
              elevation: 5,
              padding: EdgeInsets.all(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDescriptionField() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
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
      ),
    );
  }

  Widget buildAttachmentButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attachment',
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attach your photo',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16),
                  Obx(() {
                    var imageFile = controller.imageFile.value;
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (imageFile != null) {
                              // Show image preview or any other action
                            }
                          },
                          child: Container(
                            width: Get.width,
                            height: 160,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                              image: imageFile != null
                                  ? DecorationImage(
                                      image: FileImage(
                                        File(imageFile.path),
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: imageFile == null
                                ? Icon(Icons.add,
                                    size: 100, color: Colors.grey[500])
                                : null,
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            await controller.takePhoto();
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
                              Flexible(
                                child: Text(
                                  imageFile == null ? "Attach" : "Retake",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSubmitButton() {
    return SizedBox(
      width: 240,
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
            controller.loadAttendanceData();
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          backgroundColor: HexColor('E97717'),
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
