import 'package:app_kopabali/src/core/base_import.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'export_data_controller.dart';

class ExportDataPage extends StatelessWidget {
  const ExportDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ExportDataController controller = Get.put(ExportDataController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Export Data', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: HexColor('727578'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
                child: Text('Export Excel',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            SizedBox(height: 16),
            Center(
                child: Text(
                    'Export data Participant to Excel format and save it to your device.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16))),
            SizedBox(height: 20),
            Obx(() => DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    hint: Text('Select export type'),
                    items: [
                      DropdownMenuItem(
                          value: 'participant_data',
                          child: Text('Participant Data')),
                      DropdownMenuItem(
                          value: 'participant_attendance',
                          child: Text('Participant Attendance')),
                      DropdownMenuItem(
                          value: 'participant_kit',
                          child: Text('Participant Kit')),
                    ],
                    value: controller.selectedExportType.value,
                    onChanged: (value) {
                      controller.selectedExportType.value = value as String;
                    },
                  ),
                )),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: HexColor('E97717'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 120, vertical: 16),
              ),
              onPressed: () => controller.downloadData(),
              child: Text('Download Data'),
            ),
          ],
        ),
      ),
    );
  }
}
