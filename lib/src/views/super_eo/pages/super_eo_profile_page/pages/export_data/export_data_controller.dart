import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ExportDataController extends GetxController {
  var selectedExportType = 'participant_data'.obs;

  Future<void> downloadData() async {
    try {
      // Request storage permission based on Android version
      bool permissionGranted = await _getStoragePermission();

      if (!permissionGranted) {
        Get.snackbar(
          'Error',
          'Storage permission is required to export data. Please grant permission.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Participant Data'];

      // Add headers
      List<CellValue> headers = [
        TextCellValue('User ID'),
        TextCellValue('Email'),
        TextCellValue('Name'),
        TextCellValue('Area'),
        TextCellValue('Division'),
        TextCellValue('Department'),
        TextCellValue('Address'),
        TextCellValue('WhatsApp Number'),
        TextCellValue('NIK'),
        TextCellValue('T-Shirt Size'),
        TextCellValue('Polo Shirt Size'),
        TextCellValue('E-Wallet Type'),
        TextCellValue('E-Wallet Number'),
        TextCellValue('Email Verified'),
        TextCellValue('Role'),
        TextCellValue('Created At'),
        TextCellValue('Updated At')
      ];

      for (int i = 0; i < headers.length; i++) {
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .value = headers[i];
      }

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', whereIn: ['Participant', 'Committee']).get();
      print('query : ${querySnapshot.docs}');
      // Write data to Excel
      int rowIndex = 1;
      await _writeDataToSheet(sheetObject, querySnapshot, rowIndex);

      var fileBytes = excel.save();

      // Get the external storage directory
      Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir == null) {
        throw Exception('Unable to access external storage');
      }

      // Create Kopa/export directory
      String kopaDir = '${externalDir.path}/export';
      await Directory(kopaDir).create(recursive: true);

      var fileName =
          'participant_data_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      var file = File('$kopaDir/$fileName');
      await file.writeAsBytes(fileBytes!);

      Get.snackbar('Success', 'File downloaded to: ${file.path}');
    } catch (e) {
      Get.snackbar('Error', 'Failed to download file: $e');
      print('Error details: $e');
    }
  }

  Future<void> _writeDataToSheet(
    Sheet sheetObject,
    QuerySnapshot snapshot,
    int startRowIndex,
  ) async {
    for (int i = 0; i < snapshot.docs.length; i++) {
      var data = snapshot.docs[i].data() as Map<String, dynamic>;
      List<CellValue> rowData = [
        TextCellValue(data['userId'] ?? snapshot.docs[i].id),
        TextCellValue(data['email'] ?? ''),
        TextCellValue(data['name'] ?? ''),
        TextCellValue(data['area'] ?? ''),
        TextCellValue(data['division'] ?? ''),
        TextCellValue(data['department'] ?? ''),
        TextCellValue(data['address'] ?? ''),
        TextCellValue(data['whatsappNumber'] ?? ''),
        TextCellValue(data['NIK'] ?? ''),
        TextCellValue(data['tShirtSize'] ?? ''),
        TextCellValue(data['poloShirtSize'] ?? ''),
        TextCellValue(data['eWalletType'] ?? ''),
        TextCellValue(data['eWalletNumber'] ?? ''),
        TextCellValue(data['emailVerified'] != null
            ? data['emailVerified'].toString()
            : ''),
        TextCellValue(data['role'] ?? ''),
        TextCellValue(data['createdAt'] != null
            ? (data['createdAt'] as Timestamp).toDate().toString()
            : ''),
        TextCellValue(data['updatedAt'] != null
            ? (data['updatedAt'] as Timestamp).toDate().toString()
            : ''),
      ];

      for (int j = 0; j < rowData.length; j++) {
        sheetObject
            .cell(CellIndex.indexByColumnRow(
                columnIndex: j, rowIndex: startRowIndex + i))
            .value = rowData[j];
      }
    }
  }

  Future<bool> _getStoragePermission() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    if (androidInfo.version.sdkInt >= 33) {
      var status = await Permission.manageExternalStorage.request();
      if (status.isGranted) return true;
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
    } else {
      var status = await Permission.storage.request();
      if (status.isGranted) return true;
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
    }
    return false;
  }
}
