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
      Sheet sheetObject = excel[selectedExportType.value];

      List<CellValue> headers;
      List<Map<String, dynamic>> data = [];

      switch (selectedExportType.value) {
        case 'participant_data':
          headers = _getParticipantDataHeaders();
          data = await _getParticipantData();
          break;
        case 'attendance':
          headers = _getAttendanceHeaders();
          data = await _getAttendanceData();
          break;
        case 'merchandise':
          headers = _getMerchandiseHeaders();
          data = await _getMerchandiseData();
          break;
        default:
          throw Exception('Invalid export type');
      }

      _writeHeadersToSheet(sheetObject, headers);
      _writeDataToSheet(sheetObject, data, 1);

      var fileBytes = excel.save();
      await _saveExcelFile(fileBytes!, selectedExportType.value);
    } catch (e) {
      Get.snackbar('Error', 'Failed to download file: $e');
      print('Error details: $e');
    }
  }

  List<CellValue> _getParticipantDataHeaders() {
    return [
      TextCellValue('User ID'),
      TextCellValue('Name'),
      TextCellValue('Email'),
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
  }

  List<CellValue> _getAttendanceHeaders() {
    return [
      TextCellValue('User ID'),
      TextCellValue('Name'),
      TextCellValue('Day 1 Arrival'),
      TextCellValue('Day 1 Arrived Hotel'),
      TextCellValue('Day 1 Check In Hotel'),
      TextCellValue('Day 1 CSR'),
      TextCellValue('Day 1 Departure'),
      TextCellValue('Day 1 Lunch'),
      TextCellValue('Day 1 Welcome Dinner'),
      TextCellValue('Day 2 Gala Dinner'),
      TextCellValue('Day 2 Lunch'),
      TextCellValue('Day 2 Team Building'),
      TextCellValue('Day 3 Arrival Jakarta')
    ];
  }

  List<CellValue> _getMerchandiseHeaders() {
    return [
      TextCellValue('User ID'),
      TextCellValue('Name'),
      TextCellValue('Voucher Belanja'),
      TextCellValue('Voucher E-Wallet'),
      TextCellValue('Jas Hujan'),
      TextCellValue('Luggage Tag'),
      TextCellValue('Polo Shirt'),
      TextCellValue('T-Shirt'),
      TextCellValue('Gelang Tridatu'),
      TextCellValue('Selendang Udeng')
    ];
  }

  Future<List<Map<String, dynamic>>> _getParticipantData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', whereIn: ['Participant', 'Committee']).get();

    return querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return {
        'userId': doc.id,
        'name': data['name'] ?? '',
        'email': data['email'] ?? '',
        'area': data['area'] ?? '',
        'division': data['division'] ?? '',
        'department': data['department'] ?? '',
        'address': data['address'] ?? '',
        'whatsappNumber': data['whatsappNumber'] ?? '',
        'NIK': data['NIK'] ?? '',
        'tShirtSize': data['tShirtSize'] ?? '',
        'poloShirtSize': data['poloShirtSize'] ?? '',
        'eWalletType': data['eWalletType'] ?? '',
        'eWalletNumber': data['eWalletNumber'] ?? '',
        'emailVerified': data['emailVerified'] != null
            ? data['emailVerified'].toString()
            : '',
        'role': data['role'] ?? '',
        'createdAt': data['createdAt'] != null
            ? (data['createdAt'] as Timestamp).toDate().toString()
            : '',
        'updatedAt': data['updatedAt'] != null
            ? (data['updatedAt'] as Timestamp).toDate().toString()
            : '',
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _getAttendanceData() async {
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', whereIn: ['Participant', 'Committee']).get();

    List<Map<String, dynamic>> attendanceData = [];

    for (var userDoc in usersSnapshot.docs) {
      var userData = userDoc.data() as Map<String, dynamic>;
      var attendanceDoc = await FirebaseFirestore.instance
          .collection('attendance')
          .doc(userDoc.id)
          .get();

      var attendanceMap = attendanceDoc.exists
          ? attendanceDoc.data() as Map<String, dynamic>
          : {};

      attendanceData.add({
        'userId': userDoc.id,
        'name': userData['name'] ?? '',
        'day1Arrival': _getStatusString(attendanceMap['day1']?['arrival']),
        'day1ArrivedHotel':
            _getStatusString(attendanceMap['day1']?['arrivedHotel']),
        'day1CheckInHotel':
            _getStatusString(attendanceMap['day1']?['checkInHotel']),
        'day1CSR': _getStatusString(attendanceMap['day1']?['csr']),
        'day1Departure': _getStatusString(attendanceMap['day1']?['departure']),
        'day1Lunch': _getStatusString(attendanceMap['day1']?['lunch']),
        'day1WelcomeDinner':
            _getStatusString(attendanceMap['day1']?['welcomeDinner']),
        'day2GalaDinner':
            _getStatusString(attendanceMap['day2']?['galaDinner']),
        'day2Lunch': _getStatusString(attendanceMap['day2']?['lunch']),
        'day2TeamBuilding':
            _getStatusString(attendanceMap['day2']?['teamBuilding']),
        'day3ArrivalJakarta':
            _getStatusString(attendanceMap['day3']?['arrivalJakarta']),
      });
    }

    return attendanceData;
  }

  Future<List<Map<String, dynamic>>> _getMerchandiseData() async {
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', whereIn: ['Participant', 'Committee']).get();

    List<Map<String, dynamic>> merchandiseData = [];

    for (var userDoc in usersSnapshot.docs) {
      var userData = userDoc.data() as Map<String, dynamic>;
      var benefitDoc = await FirebaseFirestore.instance
          .collection('benefit')
          .doc(userDoc.id)
          .get();
      var merchandiseDoc = await FirebaseFirestore.instance
          .collection('merchandise')
          .doc(userDoc.id)
          .get();
      var souvenirDoc = await FirebaseFirestore.instance
          .collection('souvenir')
          .doc(userDoc.id)
          .get();

      var benefitMap =
          benefitDoc.exists ? benefitDoc.data() as Map<String, dynamic> : {};
      var merchandiseMap = merchandiseDoc.exists
          ? merchandiseDoc.data() as Map<String, dynamic>
          : {};
      var souvenirMap =
          souvenirDoc.exists ? souvenirDoc.data() as Map<String, dynamic> : {};

      merchandiseData.add({
        'userId': userDoc.id,
        'name': userData['name'] ?? '',
        'voucherBelanja': _getStatusString(benefitMap['voucherBelanja']),
        'voucherEWallet': _getStatusString(benefitMap['voucherEwallet']),
        'jasHujan': _getStatusString(merchandiseMap['jasHujan']),
        'luggageTag': _getStatusString(merchandiseMap['luggageTag']),
        'poloShirt': _getStatusString(merchandiseMap['poloShirt']),
        'tShirt': _getStatusString(merchandiseMap['tShirt']),
        'gelangTridatu': _getStatusString(souvenirMap['gelangTridatu']),
        'selendangUdeng': _getStatusString(souvenirMap['selendangUdeng']),
      });
    }

    return merchandiseData;
  }

  String _getStatusString(Map<String, dynamic>? statusMap) {
    if (statusMap == null) return 'Pending';
    return statusMap['status'] ?? 'Pending';
  }

  void _writeHeadersToSheet(Sheet sheetObject, List<CellValue> headers) {
    for (int i = 0; i < headers.length; i++) {
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
          .value = headers[i];
    }
  }

  void _writeDataToSheet(
    Sheet sheetObject,
    List<Map<String, dynamic>> data,
    int startRowIndex,
  ) {
    for (int i = 0; i < data.length; i++) {
      var rowData = data[i];
      int columnIndex = 0;
      rowData.forEach((key, value) {
        sheetObject
            .cell(CellIndex.indexByColumnRow(
                columnIndex: columnIndex, rowIndex: startRowIndex + i))
            .value = TextCellValue(value.toString());
        columnIndex++;
      });
    }
  }

  Future<void> _saveExcelFile(List<int> fileBytes, String exportType) async {
    Directory? externalDir = await getExternalStorageDirectory();
    if (externalDir == null) {
      throw Exception('Unable to access external storage');
    }

    String kopaDir = '${externalDir.path}/export';
    await Directory(kopaDir).create(recursive: true);

    var fileName =
        '${exportType}_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    var file = File('$kopaDir/$fileName');
    await file.writeAsBytes(fileBytes);

    Get.snackbar('Success', 'File downloaded to: ${file.path}');
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
